Procedure BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters) Export
	TransferParameters = New Structure();
	TransferParameters.Insert("Unmarked", True);
	TransferParameters.Insert("Posted", True);
	TransferParameters.Insert("IsReturnTransactionType", Parameters.IsReturnTransactionType);
	
	If Parameters.Property("Filter") Then
		For Each KeyValue In Parameters.Filter Do
			TransferParameters.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	ArrayOfFilterFromCurrentData = StrSplit(Parameters.FilterFromCurrentData, ",");
	For Each ItemOfFilterFromCurrentData In ArrayOfFilterFromCurrentData Do
		If ValueIsFilled(CurrentData[TrimAll(ItemOfFilterFromCurrentData)]) Then
			TransferParameters.Insert(ItemOfFilterFromCurrentData, CurrentData[TrimAll(ItemOfFilterFromCurrentData)]);
		EndIf;
	EndDo;
	OpeningEntryTableName1 = Undefined;
	If Parameters.Property("OpeningEntryTableName1") Then
		OpeningEntryTableName1 = Parameters.OpeningEntryTableName1;
	EndIf;

	OpeningEntryTableName2 = Undefined;
	If Parameters.Property("OpeningEntryTableName2") Then
		OpeningEntryTableName2 = Parameters.OpeningEntryTableName2;
	EndIf;

	DebitNoteTableName = Undefined;
	If Parameters.Property("DebitNoteTableName") Then
		DebitNoteTableName = Parameters.DebitNoteTableName;
	EndIf;

	CreditNoteTableName = Undefined;
	If Parameters.Property("CreditNoteTableName") Then
		CreditNoteTableName = Parameters.CreditNoteTableName;
	EndIf;

	RetailSalesReceiptTableName = Undefined;
	If Parameters.Property("RetailSalesReceiptTableName") Then
		RetailSalesReceiptTableName = Parameters.RetailSalesReceiptTableName;
	EndIf;
	
	FilterStructure = CreateFilterByParameters(Parameters.Ref, TransferParameters, Parameters.TableName,
		OpeningEntryTableName1, 
		OpeningEntryTableName2, 
		DebitNoteTableName, 
		CreditNoteTableName,
		RetailSalesReceiptTableName);
	FormParameters = New Structure("CustomFilter", FilterStructure);

	EnteredItems = New Array;
	For Each PaymentListItem in Object.PaymentList Do
		If Not PaymentListItem = CurrentData Then
			StructureEnteredItem = JorDocumentsClientServer.GetStructureEnteredItem();
			StructureEnteredItem.Ref = PaymentListItem.BasisDocument;
			StructureEnteredItem.Company = Object.Company;
			StructureEnteredItem.Partner = PaymentListItem.Partner;
			StructureEnteredItem.Agreement = PaymentListItem.Agreement;
			StructureEnteredItem.Currency = Object.Currency;
			StructureEnteredItem.Amount = PaymentListItem.TotalAmount;
			If FilterStructure.QueryParameters.Property("LegalName") Then
				StructureEnteredItem.LegalName = FilterStructure.QueryParameters.LegalName;
			EndIf;
			EnteredItems.Add(StructureEnteredItem);
		EndIf;
	EndDo;
	FormParameters.Insert("EnteredItems", EnteredItems);
	FormParameters.Insert("DocumentRef",  Parameters.Ref);
	FormParameters.Insert("DocumentDate", Object.Date);

	OpenForm("DocumentJournal." + Parameters.TableName + ".Form.ChoiceForm", FormParameters, Item, Form.UUID, , Form.URL,
		Parameters.Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Function CreateFilterByParameters(Ref, Parameters, TableName, 
			OpeningEntryTableName1,
			OpeningEntryTableName2, 
			DebitNoteTableName, 
			CreditNoteTableName,
			RetailSalesReceiptTableName)

	QueryParameters = New Structure();
	QueryParameters.Insert("Ref", Ref);
	QueryParameters.Insert("IsReturnTransactionType", Parameters.IsReturnTransactionType);
	QueryParameters.Insert("ShowAll", False);
	
	QueryText_Doc = GetDocQueryText(QueryParameters, Parameters, TableName, 
			OpeningEntryTableName1, 
			OpeningEntryTableName2, 
			DebitNoteTableName, 
			CreditNoteTableName,
			RetailSalesReceiptTableName);
	QueryText_DocWithBalance = GetDocWithBalanceQueryText();
	QueryText_AllDoc = GetAllDocQueryText();
	QueryText = QueryText_Doc + "; " + QueryText_DocWithBalance + "; " + QueryText_AllDoc;  

	FilterStructure = New Structure();
	FilterStructure.Insert("QueryText", QueryText);
	FilterStructure.Insert("QueryParameters", QueryParameters);
	Return FilterStructure;
EndFunction

Function GetDocQueryText(QueryParameters, Parameters, TableName, 
			OpeningEntryTableName1, 
			OpeningEntryTableName2, 
			DebitNoteTableName, 
			CreditNoteTableName,
			RetailSalesReceiptTableName)

	QueryText_TableName = 
	"SELECT ALLOWED
	|	Obj.Ref,
	|	Obj.Ref.Company AS Company,
	|	Obj.Ref.Partner AS Partner,
	|	Obj.Ref.LegalName AS LegalName,
	|	Obj.Ref.Agreement AS Agreement,
	|	Obj.Ref.DocumentAmount AS DocumentAmount,
	|	Obj.Ref.Agreement.CurrencyMovementType.Currency AS Currency,
	|	Obj.Ref.Currency AS DocCurrency
	|INTO Doc
	|FROM
	|	DocumentJournal.%1 AS Obj
	|WHERE
	|	True
	|	%2";

	QueryText_RetailSalesReceipt = "";
	If RetailSalesReceiptTableName <> Undefined Then
		QueryText_RetailSalesReceipt = "
		|UNION ALL
		|SELECT
		|	CustomersTransactions.Recorder,
		|	CustomersTransactions.Company,
		|	CustomersTransactions.Partner,
		|	CustomersTransactions.LegalName,
		|	CustomersTransactions.Agreement,
		|	CustomersTransactions.Amount,
		|	CustomersTransactions.Agreement.CurrencyMovementType.Currency,
		|	CustomersTransactions.Currency
		|FROM
		|	AccumulationRegister.R2021B_CustomersTransactions AS CustomersTransactions
		|WHERE
		|	CustomersTransactions.Recorder REFS Document.RetailSalesReceipt
		|	%1";
	EndIf;

	QueryText_OpeningEntryTableName1 = "";
	If OpeningEntryTableName1 <> Undefined Then
		QueryText_OpeningEntryTableName1 = "
		|UNION ALL
		|SELECT
		|	OpeningEntry.Ref,
		|	MAX(OpeningEntry.Ref.Company),
		|	MAX(OpeningEntry.Partner),
		|	MAX(OpeningEntry.LegalName),
		|	MAX(OpeningEntry.Agreement),
		|	SUM(OpeningEntry.Amount),
		|	MAX(OpeningEntry.Agreement.CurrencyMovementType.Currency),
		|	MAX(OpeningEntry.Currency)
		|FROM
		|Document.OpeningEntry.%1 AS OpeningEntry
		|	WHERE
		|	TRUE
		|	%2
		|GROUP BY
		|	OpeningEntry.Ref";
	EndIf;

	QueryText_OpeningEntryTableName2 = "";
	If OpeningEntryTableName2 <> Undefined Then
		QueryText_OpeningEntryTableName2 = "
		|UNION ALL
		|SELECT
		|	OpeningEntry.Ref,
		|	MAX(OpeningEntry.Ref.Company),
		|	MAX(OpeningEntry.Partner),
		|	MAX(OpeningEntry.LegalName),
		|	MAX(OpeningEntry.Agreement),
		|	SUM(OpeningEntry.Amount),
		|	MAX(OpeningEntry.Agreement.CurrencyMovementType.Currency),
		|	MAX(OpeningEntry.Currency)
		|FROM
		|Document.OpeningEntry.%1 AS OpeningEntry
		|	WHERE
		|	TRUE
		|	%2
		|GROUP BY
		|	OpeningEntry.Ref";
	EndIf;

	QueryText_DebitNote = "";
	If DebitNoteTableName <> Undefined Then
		QueryText_DebitNote = "
		|UNION ALL
		|SELECT
		|	DebitNote.Ref,
		|	MAX(DebitNote.Ref.Company),
		|	MAX(DebitNote.Partner),
		|	MAX(DebitNote.LegalName),
		|	MAX(DebitNote.Agreement),
		|	SUM(DebitNote.Amount),
		|	MAX(DebitNote.Agreement.CurrencyMovementType.Currency),
		|	MAX(DebitNote.Currency)
		|FROM
		|Document.DebitNote.%1 AS DebitNote
		|	WHERE
		|	TRUE
		|	%2
		|GROUP BY
		|	DebitNote.Ref";
	EndIf;

	QueryText_CreditNote = "";
	If CreditNoteTableName <> Undefined Then
		QueryText_CreditNote = "
		|UNION ALL
		|SELECT
		|	CreditNote.Ref,
		|	MAX(CreditNote.Ref.Company),
		|	MAX(CreditNote.Partner),
		|	MAX(CreditNote.LegalName),
		|	MAX(CreditNote.Agreement),
		|	SUM(CreditNote.Amount),
		|	MAX(CreditNote.Agreement.CurrencyMovementType.Currency),
		|	MAX(CreditNote.Currency)
		|FROM
		|Document.CreditNote.%1 AS CreditNote
		|	WHERE
		|	TRUE
		|	%2
		|GROUP BY
		|	CreditNote.Ref";
	EndIf;

	ArrayOfConditions = New Array();
	ArrayOfConditionsOpeningEntry = New Array();
	ArrayOfConditionsDebitNote = New Array();
	ArrayOfConditionsCreditNote = New Array();
	ArrayOfConditionsRetailSalesReceipt = New Array();
	
	If Parameters.Property("Type") Then
		QueryParameters.Insert("Type", Parameters.Type);
		QueryParameters.Insert("Type_PurchaseInvoice", Type("DocumentRef.PurchaseInvoice"));
		QueryParameters.Insert("Type_SalesInvoice"   , Type("DocumentRef.SalesInvoice"));
		ArrayOfConditions.Add(" AND Obj.Type = &Type");
		ArrayOfConditions.Add(" AND Obj.Type <> &Type_PurchaseInvoice");
		ArrayOfConditions.Add(" AND Obj.Type <> &Type_SalesInvoice");
		
		If Parameters.Type = Type("DocumentRef.SalesOrder")
			Or Parameters.Type = Type("DocumentRef.PurchaseOrder") Then
			QueryParameters.Insert("OnlyOrders", True);
		Else
			QueryParameters.Insert("OnlyOrders", False);
		EndIf;
	Else
		QueryParameters.Insert("Type_PurchaseOrder", Type("DocumentRef.PurchaseOrder"));
		QueryParameters.Insert("Type_SalesOrder"   , Type("DocumentRef.SalesOrder"));
		ArrayOfConditions.Add(" AND Obj.Type <> &Type_PurchaseOrder");
		ArrayOfConditions.Add(" AND Obj.Type <> &Type_SalesOrder");
		
		QueryParameters.Insert("OnlyOrders", False);
	EndIf;
	
	If Parameters.Property("RefInList") Then
		QueryParameters.Insert("RefInList", Parameters.RefInList);
		ArrayOfConditions.Add(" AND Obj.Ref IN (&RefInList)");
	EndIf;
	
	If Parameters.Property("Unmarked") Then
		QueryParameters.Insert("Unmarked", Parameters.Unmarked);
		ArrayOfConditions.Add(" AND NOT Obj.DeletionMark = &Unmarked");
		ArrayOfConditionsOpeningEntry.Add(" AND NOT OpeningEntry.Ref.DeletionMark = &Unmarked");
		ArrayOfConditionsDebitNote.Add(" AND NOT DebitNote.Ref.DeletionMark = &Unmarked");
		ArrayOfConditionsCreditNote.Add(" AND NOT CreditNote.Ref.DeletionMark = &Unmarked");
		ArrayOfConditionsRetailSalesReceipt.Add(" AND NOT CustomersTransactions.Recorder.DeletionMark = &Unmarked");
	EndIf;

	If Parameters.Property("Partner") Then
		QueryParameters.Insert("Partner", Parameters.Partner);
		ArrayOfConditions.Add(" AND Obj.Ref.Partner = &Partner");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Partner = &Partner");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Partner = &Partner");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Partner = &Partner");
		ArrayOfConditionsRetailSalesReceipt.Add(" AND CustomersTransactions.Partner = &Partner");
	EndIf;

	If Parameters.Property("LegalName") Then
		QueryParameters.Insert("LegalName", Parameters.LegalName);
		ArrayOfConditions.Add(" AND Obj.Ref.LegalName = &LegalName");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.LegalName = &LegalName");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.LegalName = &LegalName");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.LegalName = &LegalName");
		ArrayOfConditionsRetailSalesReceipt.Add(" AND CustomersTransactions.Partner = &Partner");
	EndIf;

	If Parameters.Property("Agreement") Then
		QueryParameters.Insert("Agreement", Parameters.Agreement);
		ArrayOfConditions.Add(" AND Obj.Ref.Agreement = &Agreement");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Agreement = &Agreement");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Agreement = &Agreement");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Agreement = &Agreement");
		ArrayOfConditionsRetailSalesReceipt.Add(" AND CustomersTransactions.Agreement = &Agreement");
	EndIf;

	If Parameters.Property("Company") Then
		QueryParameters.Insert("Company", Parameters.Company);
		ArrayOfConditions.Add(" AND Obj.Ref.Company = &Company");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Ref.Company = &Company");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Ref.Company = &Company");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Ref.Company = &Company");
		ArrayOfConditionsRetailSalesReceipt.Add(" AND CustomersTransactions.Company = &Company");
	EndIf;

	If Parameters.Property("Agreement_ApArPostingDetail") Then
		QueryParameters.Insert("Agreement_ApArPostingDetail", Parameters.Agreement_ApArPostingDetail);
		ArrayOfConditions.Add(" AND Obj.Ref.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
	EndIf;

	If Parameters.Property("Posted") Then
		QueryParameters.Insert("Posted", Parameters.Posted);
		ArrayOfConditions.Add(" AND Obj.Ref.Posted = &Posted");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Ref.Posted = &Posted");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Ref.Posted = &Posted");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Ref.Posted = &Posted");
		ArrayOfConditionsRetailSalesReceipt.Add(" AND CustomersTransactions.Recorder.Posted = &Posted");
	EndIf;

	ConditionsText             = StrConcat(ArrayOfConditions);
	ConditionsOpeningEntryText = StrConcat(ArrayOfConditionsOpeningEntry);
	ConditionsDebitNoteText    = StrConcat(ArrayOfConditionsDebitNote);
	ConditionsCreditNoteText   = StrConcat(ArrayOfConditionsCreditNote);
	ConditionsRetailSalesReceiptText = StrConcat(ArrayOfConditionsRetailSalesReceipt);

	QueryText_TableName = StrTemplate(QueryText_TableName, TableName, ConditionsText);

	If RetailSalesReceiptTableName <> Undefined Then
		QueryText_RetailSalesReceipt = StrTemplate(QueryText_RetailSalesReceipt, ConditionsRetailSalesReceiptText);
	EndIf;

	If OpeningEntryTableName1 <> Undefined Then
		QueryText_OpeningEntryTableName1 = StrTemplate(QueryText_OpeningEntryTableName1, OpeningEntryTableName1,
			ConditionsOpeningEntryText);
	EndIf;

	If OpeningEntryTableName2 <> Undefined Then
		QueryText_OpeningEntryTableName2 = StrTemplate(QueryText_OpeningEntryTableName2, OpeningEntryTableName2,
			ConditionsOpeningEntryText);
	EndIf;

	If DebitNoteTableName <> Undefined Then
		QueryText_DebitNote = StrTemplate(QueryText_DebitNote, DebitNoteTableName, ConditionsDebitNoteText);
	EndIf;

	If CreditNoteTableName <> Undefined Then
		QueryText_CreditNote = StrTemplate(QueryText_CreditNote, CreditNoteTableName, ConditionsCreditNoteText);
	EndIf;
	
	Return QueryText_TableName + 
			QueryText_OpeningEntryTableName1 + 
			QueryText_OpeningEntryTableName2 + 
			QueryText_DebitNote	+ 
			QueryText_CreditNote +
			QueryText_RetailSalesReceipt;
EndFunction

Function GetDocWithBalanceQueryText()
	QueryText_DocWithBalance = 
	"SELECT ALLOWED
	|	CASE WHEN &OnlyOrders THEN 
	|		CustomersTransactions.Order 
	|	ELSE CustomersTransactions.Basis END AS Ref,
	|	CustomersTransactions.Company AS Company,
	|	CustomersTransactions.Partner AS Partner,
	|	CustomersTransactions.LegalName AS LegalName,
	|	CustomersTransactions.Agreement AS Agreement,
	|	CustomersTransactions.Currency AS Currency,
	|	CASE
	|		WHEN &IsReturnTransactionType
	|			THEN CASE
	|				WHEN CustomersTransactions.Basis REFS Document.SalesReturn
	|					THEN -CustomersTransactions.AmountBalance
	|				ELSE 0
	|			END
	|		ELSE CustomersTransactions.AmountBalance
	|	END AS DocumentAmount
	|INTO DocWithBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND ((Basis, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc)
	|		OR
	|		(Order, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc))) AS CustomersTransactions
	|WHERE
	|	CASE
	|		WHEN &IsReturnTransactionType
	|			THEN CASE
	|				WHEN CustomersTransactions.Basis REFS Document.SalesReturn
	|					THEN -CustomersTransactions.AmountBalance
	|				ELSE 0
	|			END
	|		ELSE CustomersTransactions.AmountBalance
	|	END > 0
	|
	|UNION ALL
	|
	|SELECT
	|	CASE WHEN &OnlyOrders THEN 
	|		VendorsTransactions.Order 
	|	ELSE VendorsTransactions.Basis END AS Ref,
	|	VendorsTransactions.Company,
	|	VendorsTransactions.Partner,
	|	VendorsTransactions.LegalName,
	|	VendorsTransactions.Agreement,
	|	VendorsTransactions.Currency,
	|	CASE
	|		WHEN &IsReturnTransactionType
	|			THEN CASE
	|				WHEN VendorsTransactions.Basis REFS Document.PurchaseReturn
	|					THEN -VendorsTransactions.AmountBalance
	|				ELSE 0
	|			END
	|		ELSE VendorsTransactions.AmountBalance
	|	END
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND ((Basis, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc)
	|		OR
	|		(Order, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc))
	|
	|) AS VendorsTransactions
	|WHERE
	|	CASE
	|		WHEN &IsReturnTransactionType
	|			THEN CASE
	|				WHEN VendorsTransactions.Basis REFS Document.PurchaseReturn
	|					THEN -VendorsTransactions.AmountBalance
	|				ELSE 0
	|			END
	|		ELSE VendorsTransactions.AmountBalance
	|	END > 0
	|
	|UNION ALL
	|
	|SELECT
	|	PurchaseOrdersToBePaid.Order,
	|	PurchaseOrdersToBePaid.Company,
	|	PurchaseOrdersToBePaid.Partner,
	|	PurchaseOrdersToBePaid.LegalName,
	|	PurchaseOrdersToBePaid.Order.Agreement,
	|	PurchaseOrdersToBePaid.Currency,
	|	PurchaseOrdersToBePaid.AmountBalance
	|FROM
	|	AccumulationRegister.R3025B_PurchaseOrdersToBePaid.Balance(&Period, (Order, Company, Partner, LegalName, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.DocCurrency
	|		FROM
	|			Doc AS Doc)) AS PurchaseOrdersToBePaid
	|WHERE
	|	PurchaseOrdersToBePaid.AmountBalance > 0
	|
	|UNION ALL
	|
	|SELECT
	|	SalesOrdersToBePaid.Order,
	|	SalesOrdersToBePaid.Company,
	|	SalesOrdersToBePaid.Partner,
	|	SalesOrdersToBePaid.LegalName,
	|	SalesOrdersToBePaid.Order.Agreement,
	|	SalesOrdersToBePaid.Currency,
	|	SalesOrdersToBePaid.AmountBalance
	|FROM
	|	AccumulationRegister.R3024B_SalesOrdersToBePaid.Balance(&Period, (Order, Company, Partner, LegalName, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.DocCurrency
	|		FROM
	|			Doc AS Doc)) AS SalesOrdersToBePaid
	|WHERE
	|	SalesOrdersToBePaid.AmountBalance > 0";
	
	QueryText_Postings =
	"
	|UNION ALL
	|
	|SELECT
	|	Postings.Ref,
	|	Postings.Company,
	|	Postings.Partner,
	|	Postings.LegalName,
	|	Postings.Agreement,
	|	Postings.Currency,
	|	SUM(Postings.Amount) AS Amount
	|FROM
	|	(SELECT
	|		CustomersTransactions.Basis AS Ref,
	|		CustomersTransactions.Company AS Company,
	|		CustomersTransactions.Partner AS Partner,
	|		CustomersTransactions.LegalName AS LegalName,
	|		CustomersTransactions.Agreement AS Agreement,
	|		CustomersTransactions.Currency AS Currency,
	|		CASE
	|			WHEN CustomersTransactions.RecordType = VALUE(AccumulationRecordType.Expense)
	|				THEN 1
	|			ELSE -1
	|		END * CASE
	|			WHEN &IsReturnTransactionType
	|				THEN CASE
	|					WHEN CustomersTransactions.Basis REFS Document.SalesReturn
	|						THEN -CustomersTransactions.Amount
	|					ELSE 0
	|				END
	|			ELSE CustomersTransactions.Amount
	|		END AS Amount
	|	FROM
	|		AccumulationRegister.R2021B_CustomersTransactions AS CustomersTransactions
	|	WHERE
	|		CustomersTransactions.Recorder = &Ref
	|		AND CustomersTransactions.Period < &Period
	|		AND
	|			CustomersTransactions.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|
	|	UNION ALL
	|
	|	SELECT
	|		VendorsTransactions.Basis,
	|		VendorsTransactions.Company,
	|		VendorsTransactions.Partner,
	|		VendorsTransactions.LegalName,
	|		VendorsTransactions.Agreement,
	|		VendorsTransactions.Currency,
	|		CASE
	|			WHEN VendorsTransactions.RecordType = VALUE(AccumulationRecordType.Expense)
	|				THEN 1
	|			ELSE -1
	|		END * CASE
	|			WHEN &IsReturnTransactionType
	|				THEN CASE
	|					WHEN VendorsTransactions.Basis REFS Document.PurchaseReturn
	|						THEN -VendorsTransactions.Amount
	|					ELSE 0
	|				END
	|			ELSE VendorsTransactions.Amount
	|		END
	|	FROM
	|		AccumulationRegister.R1021B_VendorsTransactions AS VendorsTransactions
	|	WHERE
	|		VendorsTransactions.Recorder = &Ref
	|		AND VendorsTransactions.Period < &Period
	|		AND
	|			VendorsTransactions.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|
	|	UNION ALL
	|
	|	SELECT
	|		PurchaseOrdersToBePaid.Order,
	|		PurchaseOrdersToBePaid.Company,
	|		PurchaseOrdersToBePaid.Partner,
	|		PurchaseOrdersToBePaid.LegalName,
	|		PurchaseOrdersToBePaid.Order.Agreement,
	|		PurchaseOrdersToBePaid.Currency,
	|		CASE
	|			WHEN PurchaseOrdersToBePaid.RecordType = VALUE(AccumulationRecordType.Expense)
	|				THEN 1
	|			ELSE -1
	|		END * PurchaseOrdersToBePaid.Amount
	|	FROM
	|		AccumulationRegister.R3025B_PurchaseOrdersToBePaid AS PurchaseOrdersToBePaid
	|	WHERE
	|		PurchaseOrdersToBePaid.Recorder = &Ref
	|		AND PurchaseOrdersToBePaid.Period < &Period
	|
	|	UNION ALL
	|
	|	SELECT
	|		SalesOrdersToBePaid.Order,
	|		SalesOrdersToBePaid.Company,
	|		SalesOrdersToBePaid.Partner,
	|		SalesOrdersToBePaid.LegalName,
	|		SalesOrdersToBePaid.Order.Agreement,
	|		SalesOrdersToBePaid.Currency,
	|		CASE
	|			WHEN SalesOrdersToBePaid.RecordType = VALUE(AccumulationRecordType.Expense)
	|				THEN 1
	|			ELSE -1
	|		END * SalesOrdersToBePaid.Amount
	|	FROM
	|		AccumulationRegister.R3024B_SalesOrdersToBePaid AS SalesOrdersToBePaid
	|	WHERE
	|		SalesOrdersToBePaid.Recorder = &Ref
	|		AND SalesOrdersToBePaid.Period < &Period) AS Postings
	|GROUP BY
	|	Postings.Ref,
	|	Postings.Company,
	|	Postings.Partner,
	|	Postings.LegalName,
	|	Postings.Agreement,
	|	Postings.Currency";
	Return QueryText_DocWithBalance + QueryText_Postings;
EndFunction

Function GetAllDocQueryText()
	Return
	"////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocWithBalance.Ref,
	|	DocWithBalance.Company,
	|	DocWithBalance.Partner,
	|	DocWithBalance.LegalName,
	|	DocWithBalance.Agreement,
	|	DocWithBalance.Currency,
	|	DocWithBalance.DocumentAmount
	|INTO AllDoc
	|FROM
	|	DocWithBalance AS DocWithBalance
	|
	|UNION ALL
	|
	|SELECT
	|	Doc.Ref,
	|	Doc.Company,
	|	Doc.Partner,
	|	Doc.LegalName,
	|	Doc.Agreement,
	|	Doc.Currency,
	|	0
	|FROM
	|	Doc AS Doc
	|WHERE
	|	&ShowAll
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDoc.Ref,
	|	AllDoc.Company,
	|	AllDoc.Partner,
	|	AllDoc.LegalName,
	|	AllDoc.Agreement,
	|	AllDoc.Currency,
	|	SUM(AllDoc.DocumentAmount) AS DocumentAmount
	|FROM
	|	AllDoc AS AllDoc
	|GROUP BY
	|	AllDoc.Ref,
	|	AllDoc.Company,
	|	AllDoc.Partner,
	|	AllDoc.LegalName,
	|	AllDoc.Agreement,
	|	AllDoc.Currency";
EndFunction
