
Procedure BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters) Export
	TransferParameters = New Structure();
	TransferParameters.Insert("Unmarked", True);
	TransferParameters.Insert("Posted", True);
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
	
	FilterStructure = CreateFilterByParameters(Parameters.Ref,
		TransferParameters, 
		Parameters.TableName, 
		OpeningEntryTableName1, 
		OpeningEntryTableName2,
		DebitNoteTableName,
		CreditNoteTableName);
	FormParameters = New Structure("CustomFilter", FilterStructure);
	
	OpenForm("DocumentJournal." + Parameters.TableName + ".Form.ChoiceForm",
		FormParameters,
		Item,
		Form.UUID,
		,
		Form.URL,
		Parameters.Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Function CreateFilterByParameters(Ref, Parameters, TableName, 
                                  OpeningEntryTableName1 = Undefined, 
                                  OpeningEntryTableName2 = Undefined,
                                  DebitNoteTableName = Undefined,
                                  CreditNoteTableName)
	QueryText_TableName = "SELECT ALLOWED
		|	Obj.Ref,
		|	Obj.Ref.Company AS Company,
		|	Obj.Ref.Partner AS Partner,
		|	Obj.Ref.LegalName AS LegalName,
		|	Obj.Ref.Agreement AS Agreement,
		|	Obj.Ref.DocumentAmount AS DocumentAmount,
		|	Obj.Ref.Currency AS Currency
		|INTO Doc
		|FROM
		|	DocumentJournal.%1 AS Obj
		|WHERE
		|	True
		|	%2";
	
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
		|	MAX(CreditNote.Currency)
		|FROM
		|Document.CreditNote.%1 AS CreditNote
		|	WHERE
		|	TRUE
		|	%2
		|GROUP BY
		|	CreditNote.Ref";
	EndIf;
		
	QueryParameters = New Structure();
	QueryParameters.Insert("Ref", Ref);
	
	ArrayOfConditions = New Array();
	ArrayOfConditionsOpeningEntry = New Array();
	ArrayOfConditionsDebitNote = New Array();
	ArrayOfConditionsCreditNote = New Array();
	
	QueryParameters.Insert("ShowAll", False);
	
	If Parameters.Property("Type") Then
		QueryParameters.Insert("Type", Parameters.Type);
		ArrayOfConditions.Add(" AND Obj.Type = &Type");
	EndIf;
	
	If Parameters.Property("Unmarked") Then
		QueryParameters.Insert("Unmarked", Parameters.Unmarked);
		ArrayOfConditions.Add(" AND NOT Obj.DeletionMark = &Unmarked");
		ArrayOfConditionsOpeningEntry.Add(" AND NOT OpeningEntry.Ref.DeletionMark = &Unmarked");
		ArrayOfConditionsDebitNote.Add(" AND NOT DebitNote.Ref.DeletionMark = &Unmarked");
		ArrayOfConditionsCreditNote.Add(" AND NOT CreditNote.Ref.DeletionMark = &Unmarked");
	EndIf;
	
	If Parameters.Property("Partner") Then
		QueryParameters.Insert("Partner", Parameters.Partner);
		ArrayOfConditions.Add(" AND Obj.Ref.Partner = &Partner");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Partner = &Partner");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Partner = &Partner");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Partner = &Partner");
	EndIf;
	
	If Parameters.Property("LegalName") Then
		QueryParameters.Insert("LegalName", Parameters.LegalName);
		ArrayOfConditions.Add(" AND Obj.Ref.LegalName = &LegalName");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.LegalName = &LegalName");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.LegalName = &LegalName");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.LegalName = &LegalName");
	EndIf;
	
	If Parameters.Property("Agreement") Then
		QueryParameters.Insert("Agreement", Parameters.Agreement);
		ArrayOfConditions.Add(" AND Obj.Ref.Agreement = &Agreement");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Agreement = &Agreement");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Agreement = &Agreement");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Agreement = &Agreement");
	EndIf;
	
	If Parameters.Property("Company") Then
		QueryParameters.Insert("Company", Parameters.Company);
		ArrayOfConditions.Add(" AND Obj.Ref.Company = &Company");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Ref.Company = &Company");
		ArrayOfConditionsDebitNote.Add(" AND DebitNote.Ref.Company = &Company");
		ArrayOfConditionsCreditNote.Add(" AND CreditNote.Ref.Company = &Company");
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
	EndIf;
	
	ConditionsText             = StrConcat(ArrayOfConditions);
	ConditionsOpeningEntryText = StrConcat(ArrayOfConditionsOpeningEntry);
	ConditionsDebitNoteText    = StrConcat(ArrayOfConditionsDebitNote);
	ConditionsCreditNoteText   = StrConcat(ArrayOfConditionsCreditNote);
	
	QueryText_TableName = StrTemplate(QueryText_TableName, TableName, ConditionsText);
	
	If OpeningEntryTableName1 <> Undefined Then
		QueryText_OpeningEntryTableName1 = StrTemplate(QueryText_OpeningEntryTableName1, OpeningEntryTableName1, ConditionsOpeningEntryText);
	EndIf;

	If OpeningEntryTableName2 <> Undefined Then
		QueryText_OpeningEntryTableName2 = StrTemplate(QueryText_OpeningEntryTableName2, OpeningEntryTableName2, ConditionsOpeningEntryText);
	EndIf;
	
	If DebitNoteTableName <> Undefined Then
		QueryText_DebitNote = StrTemplate(QueryText_DebitNote, DebitNoteTableName, ConditionsDebitNoteText);
	EndIf;
	
	If CreditNoteTableName <> Undefined Then
		QueryText_CreditNote = StrTemplate(QueryText_CreditNote, CreditNoteTableName, ConditionsCreditNoteText);
	EndIf;
	
	QueryText = QueryText_TableName 
	+ QueryText_OpeningEntryTableName1 
	+ QueryText_OpeningEntryTableName2
	+ QueryText_DebitNote
	+ QueryText_CreditNote
	+ " ;

	|SELECT ALLOWED
	|	CustomersTransactions.Basis AS Ref,
	|	CustomersTransactions.Company AS Company,
	|	CustomersTransactions.Partner AS Partner,
	|	CustomersTransactions.LegalName AS LegalName,
	|	CustomersTransactions.Agreement AS Agreement,
	|	CustomersTransactions.Currency AS Currency,
	|	CustomersTransactions.AmountBalance AS DocumentAmount
	|INTO DocWithBalance
	|FROM
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND (Basis, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc)) AS CustomersTransactions
	|WHERE
	|	CustomersTransactions.AmountBalance > 0
	|
	|
	|
	|UNION ALL
	|
	|SELECT
	|	VendorsTransactions.Basis,
	|	VendorsTransactions.Company,
	|	VendorsTransactions.Partner,
	|	VendorsTransactions.LegalName,
	|	VendorsTransactions.Agreement,
	|	VendorsTransactions.Currency,
	|	VendorsTransactions.AmountBalance
	|FROM
	|	AccumulationRegister.R1021B_VendorsTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND (Basis, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc)) AS VendorsTransactions
	|WHERE
	|	VendorsTransactions.AmountBalance > 0
	|;
	|//////////////////////////////////////////////////////////////
	|SELECT 
	|	DocWithBalance.Ref,
	|	DocWithBalance.Company,
	|	DocWithBalance.Partner,
	|	DocWithBalance.LegalName,
	|	DocWithBalance.Agreement,
	|	DocWithBalance.Currency,
	|	DocWithBalance.DocumentAmount
	|INTO AllDoc
	|FROM DocWithBalance AS DocWithBalance
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
	|FROM Doc AS Doc
	|	WHERE &ShowAll
	|;
	|/////////////////////////////////////////////////////
	|SELECT
	|	AllDoc.Ref,
	|	AllDoc.Company,
	|	AllDoc.Partner,
	|	AllDoc.LegalName,
	|	AllDoc.Agreement,
	|	AllDoc.Currency,
	|	SUM(AllDoc.DocumentAmount) AS DocumentAmount
	|FROM AllDoc AS AllDoc
	|GROUP BY
	|	AllDoc.Ref,
	|	AllDoc.Company,
	|	AllDoc.Partner,
	|	AllDoc.LegalName,
	|	AllDoc.Agreement,
	|	AllDoc.Currency";
	
	FilterStructure = New Structure();
	FilterStructure.Insert("QueryText", QueryText);
	FilterStructure.Insert("QueryParameters", QueryParameters);
	
	Return FilterStructure;
EndFunction
