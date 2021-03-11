#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("AccountBalance"                  , PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("AdvanceFromCustomers"            , PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceToSuppliers"              , PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("PartnerArTransactions"           , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("PartnerApTransactions"           , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("ReconciliationStatement_Expense" , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("ReconciliationStatement_Receipt" , PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("Aging"                           , PostingServer.CreateTable(AccReg.Aging));
		
	Query = New Query();
	Query.Text =
		"//[0]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAccountBalance.Ref.Company,
		|	OpeningEntryAccountBalance.Account,
		|	OpeningEntryAccountBalance.Currency,
		|	OpeningEntryAccountBalance.Amount AS Amount,
		|	OpeningEntryAccountBalance.Ref.Date AS Period,
		|	OpeningEntryAccountBalance.Key
		|FROM
		|	Document.OpeningEntry.AccountBalance AS OpeningEntryAccountBalance
		|WHERE
		|	OpeningEntryAccountBalance.Ref = &Ref
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAdvanceFromCustomers.Ref.Company,
		|	OpeningEntryAdvanceFromCustomers.Partner,
		|	OpeningEntryAdvanceFromCustomers.LegalName,
		|	OpeningEntryAdvanceFromCustomers.Currency,
		|	OpeningEntryAdvanceFromCustomers.Amount AS Amount,
		|	OpeningEntryAdvanceFromCustomers.Ref AS ReceiptDocument,
		|	OpeningEntryAdvanceFromCustomers.Ref.Date AS Period,
		|	OpeningEntryAdvanceFromCustomers.Key
		|FROM
		|	Document.OpeningEntry.AdvanceFromCustomers AS OpeningEntryAdvanceFromCustomers
		|WHERE
		|	OpeningEntryAdvanceFromCustomers.Ref = &Ref
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAdvanceToSuppliers.Ref.Company,
		|	OpeningEntryAdvanceToSuppliers.Partner,
		|	OpeningEntryAdvanceToSuppliers.LegalName,
		|	OpeningEntryAdvanceToSuppliers.Currency,
		|	OpeningEntryAdvanceToSuppliers.Amount AS Amount,
		|	OpeningEntryAdvanceToSuppliers.Ref AS PaymentDocument,
		|	OpeningEntryAdvanceToSuppliers.Ref.Date AS Period,
		|	OpeningEntryAdvanceToSuppliers.Key
		|FROM
		|	Document.OpeningEntry.AdvanceToSuppliers AS OpeningEntryAdvanceToSuppliers
		|WHERE
		|	OpeningEntryAdvanceToSuppliers.Ref = &Ref
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAccountReceivableByDocuments.Key,
		|	OpeningEntryAccountReceivableByDocuments.Ref.Date AS Period,
		|	OpeningEntryAccountReceivableByDocuments.Ref.Company,
		|	OpeningEntryAccountReceivableByDocuments.Ref AS BasisDocument,
		|	OpeningEntryAccountReceivableByDocuments.Partner,
		|	OpeningEntryAccountReceivableByDocuments.LegalName,
		|	CASE
		|		WHEN OpeningEntryAccountReceivableByDocuments.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND
		|			OpeningEntryAccountReceivableByDocuments.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN OpeningEntryAccountReceivableByDocuments.Agreement.StandardAgreement
		|		ELSE OpeningEntryAccountReceivableByDocuments.Agreement
		|	END AS Agreement,
		|	OpeningEntryAccountReceivableByDocuments.Currency,
		|	OpeningEntryAccountReceivableByDocuments.Amount AS Amount
		|FROM
		|	Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		|WHERE
		|	OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		|
		|UNION ALL
		|
		|SELECT
		|	OpeningEntryAccountReceivableByAgreements.Key,
		|	OpeningEntryAccountReceivableByAgreements.Ref.Date,
		|	OpeningEntryAccountReceivableByAgreements.Ref.Company,
		|	UNDEFINED,
		|	OpeningEntryAccountReceivableByAgreements.Partner,
		|	OpeningEntryAccountReceivableByAgreements.LegalName,
		|	CASE
		|		WHEN OpeningEntryAccountReceivableByAgreements.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND
		|			OpeningEntryAccountReceivableByAgreements.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN OpeningEntryAccountReceivableByAgreements.Agreement.StandardAgreement
		|		ELSE OpeningEntryAccountReceivableByAgreements.Agreement
		|	END AS Agreement,
		|	OpeningEntryAccountReceivableByAgreements.Currency,
		|	OpeningEntryAccountReceivableByAgreements.Amount AS Amount
		|FROM
		|	Document.OpeningEntry.AccountReceivableByAgreements AS OpeningEntryAccountReceivableByAgreements
		|WHERE
		|	OpeningEntryAccountReceivableByAgreements.Ref = &Ref
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAccountPayableByDocuments.Ref.Date AS Period,
		|	OpeningEntryAccountPayableByDocuments.Key,
		|	OpeningEntryAccountPayableByDocuments.Ref.Company,
		|	OpeningEntryAccountPayableByDocuments.Ref AS BasisDocument,
		|	OpeningEntryAccountPayableByDocuments.Partner,
		|	OpeningEntryAccountPayableByDocuments.LegalName,
		|	CASE
		|		WHEN OpeningEntryAccountPayableByDocuments.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND
		|			OpeningEntryAccountPayableByDocuments.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN OpeningEntryAccountPayableByDocuments.Agreement.StandardAgreement
		|		ELSE OpeningEntryAccountPayableByDocuments.Agreement
		|	END AS Agreement,
		|	OpeningEntryAccountPayableByDocuments.Currency,
		|	OpeningEntryAccountPayableByDocuments.Amount AS Amount
		|FROM
		|	Document.OpeningEntry.AccountPayableByDocuments AS OpeningEntryAccountPayableByDocuments
		|WHERE
		|	OpeningEntryAccountPayableByDocuments.Ref = &Ref
		|
		|UNION ALL
		|
		|SELECT
		|	OpeningEntryAccountPayableByAgreements.Ref.Date,
		|	OpeningEntryAccountPayableByAgreements.Key,
		|	OpeningEntryAccountPayableByAgreements.Ref.Company,
		|	UNDEFINED,
		|	OpeningEntryAccountPayableByAgreements.Partner,
		|	OpeningEntryAccountPayableByAgreements.LegalName,
		|	CASE
		|		WHEN OpeningEntryAccountPayableByAgreements.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND
		|			OpeningEntryAccountPayableByAgreements.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN OpeningEntryAccountPayableByAgreements.Agreement.StandardAgreement
		|		ELSE OpeningEntryAccountPayableByAgreements.Agreement
		|	END AS Agreement,
		|	OpeningEntryAccountPayableByAgreements.Currency,
		|	OpeningEntryAccountPayableByAgreements.Amount AS Amount
		|FROM
		|	Document.OpeningEntry.AccountPayableByAgreements AS OpeningEntryAccountPayableByAgreements
		|WHERE
		|	OpeningEntryAccountPayableByAgreements.Ref = &Ref
		|;
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAdvanceFromCustomers.Ref.Date AS Period,
		|	OpeningEntryAdvanceFromCustomers.Ref.Company,
		|	OpeningEntryAdvanceFromCustomers.LegalName,
		|	OpeningEntryAdvanceFromCustomers.Currency,
		|	SUM(OpeningEntryAdvanceFromCustomers.Amount) AS Amount
		|FROM
		|	Document.OpeningEntry.AdvanceFromCustomers AS OpeningEntryAdvanceFromCustomers
		|WHERE
		|	OpeningEntryAdvanceFromCustomers.Ref = &Ref
		|GROUP BY
		|	OpeningEntryAdvanceFromCustomers.Ref.Date,
		|	OpeningEntryAdvanceFromCustomers.Ref.Company,
		|	OpeningEntryAdvanceFromCustomers.LegalName,
		|	OpeningEntryAdvanceFromCustomers.Currency
		|
		|UNION ALL
		|
		|SELECT
		|	OpeningEntryAccountPayableByAgreements.Ref.Date,
		|	OpeningEntryAccountPayableByAgreements.Ref.Company,
		|	OpeningEntryAccountPayableByAgreements.LegalName,
		|	OpeningEntryAccountPayableByAgreements.Currency,
		|	SUM(OpeningEntryAccountPayableByAgreements.Amount) AS Amount
		|FROM
		|	Document.OpeningEntry.AccountPayableByAgreements AS OpeningEntryAccountPayableByAgreements
		|WHERE
		|	OpeningEntryAccountPayableByAgreements.Ref = &Ref
		|GROUP BY
		|	OpeningEntryAccountPayableByAgreements.Ref.Date,
		|	OpeningEntryAccountPayableByAgreements.Ref.Company,
		|	OpeningEntryAccountPayableByAgreements.LegalName,
		|	OpeningEntryAccountPayableByAgreements.Currency
		|
		|UNION ALL
		|
		|SELECT
		|	OpeningEntryAccountPayableByDocuments.Ref.Date,
		|	OpeningEntryAccountPayableByDocuments.Ref.Company,
		|	OpeningEntryAccountPayableByDocuments.LegalName,
		|	OpeningEntryAccountPayableByDocuments.Currency,
		|	SUM(OpeningEntryAccountPayableByDocuments.Amount) AS Amount
		|FROM
		|	Document.OpeningEntry.AccountPayableByDocuments AS OpeningEntryAccountPayableByDocuments
		|WHERE
		|	OpeningEntryAccountPayableByDocuments.Ref = &Ref
		|GROUP BY
		|	OpeningEntryAccountPayableByDocuments.Ref.Date,
		|	OpeningEntryAccountPayableByDocuments.Ref.Company,
		|	OpeningEntryAccountPayableByDocuments.LegalName,
		|	OpeningEntryAccountPayableByDocuments.Currency
		|;
		|
		|//[7]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryAdvanceToSuppliers.Ref.Date AS Period,
		|	OpeningEntryAdvanceToSuppliers.Ref.Company,
		|	OpeningEntryAdvanceToSuppliers.LegalName,
		|	OpeningEntryAdvanceToSuppliers.Currency,
		|	SUM(OpeningEntryAdvanceToSuppliers.Amount) AS Amount
		|FROM
		|	Document.OpeningEntry.AdvanceToSuppliers AS OpeningEntryAdvanceToSuppliers
		|WHERE
		|	OpeningEntryAdvanceToSuppliers.Ref = &Ref
		|GROUP BY
		|	OpeningEntryAdvanceToSuppliers.Ref.Date,
		|	OpeningEntryAdvanceToSuppliers.Ref.Company,
		|	OpeningEntryAdvanceToSuppliers.LegalName,
		|	OpeningEntryAdvanceToSuppliers.Currency
		|
		|UNION ALL
		|
		|SELECT
		|	OpeningEntryAccountReceivableByAgreements.Ref.Date,
		|	OpeningEntryAccountReceivableByAgreements.Ref.Company,
		|	OpeningEntryAccountReceivableByAgreements.LegalName,
		|	OpeningEntryAccountReceivableByAgreements.Currency,
		|	SUM(OpeningEntryAccountReceivableByAgreements.Amount) AS Amount
		|FROM
		|	Document.OpeningEntry.AccountReceivableByAgreements AS OpeningEntryAccountReceivableByAgreements
		|WHERE
		|	OpeningEntryAccountReceivableByAgreements.Ref = &Ref
		|GROUP BY
		|	OpeningEntryAccountReceivableByAgreements.Ref.Date,
		|	OpeningEntryAccountReceivableByAgreements.Ref.Company,
		|	OpeningEntryAccountReceivableByAgreements.LegalName,
		|	OpeningEntryAccountReceivableByAgreements.Currency
		|
		|UNION ALL
		|
		|SELECT
		|	OpeningEntryAccountReceivableByDocuments.Ref.Date,
		|	OpeningEntryAccountReceivableByDocuments.Ref.Company,
		|	OpeningEntryAccountReceivableByDocuments.LegalName,
		|	OpeningEntryAccountReceivableByDocuments.Currency,
		|	SUM(OpeningEntryAccountReceivableByDocuments.Amount) AS Amount
		|FROM
		|	Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		|WHERE
		|	OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		|GROUP BY
		|	OpeningEntryAccountReceivableByDocuments.Ref.Date,
		|	OpeningEntryAccountReceivableByDocuments.Ref.Company,
		|	OpeningEntryAccountReceivableByDocuments.LegalName,
		|	OpeningEntryAccountReceivableByDocuments.Currency
		|;
		|//[8]//////////////////////////////////////////////////////////////////////////
		|SELECT
		|	OpeningEntryPaymentTerms.Ref.Date AS Period,
		|	OpeningEntryAccountReceivableByDocuments.Ref.Company AS Company,
		|	OpeningEntryAccountReceivableByDocuments.Partner AS Partner,
		|	OpeningEntryAccountReceivableByDocuments.Agreement AS Agreement,
		|	OpeningEntryAccountReceivableByDocuments.Ref AS Invoice,
		|	OpeningEntryPaymentTerms.Date AS PaymentDate,
		|	OpeningEntryAccountReceivableByDocuments.Currency AS Currency,
		|	OpeningEntryPaymentTerms.Amount AS Amount
		|FROM
		|	Document.OpeningEntry.PaymentTerms AS OpeningEntryPaymentTerms
		|	LEFT JOIN Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		|	ON OpeningEntryPaymentTerms.Key = OpeningEntryAccountReceivableByDocuments.Key
		|	AND OpeningEntryPaymentTerms.Ref = OpeningEntryAccountReceivableByDocuments.Ref
		|	AND OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		|WHERE
		|OpeningEntryPaymentTerms.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();

	Tables.AccountBalance                  = QueryResults[0].Unload();
	Tables.AdvanceFromCustomers            = QueryResults[1].Unload();
	Tables.AdvanceToSuppliers              = QueryResults[2].Unload();
	Tables.PartnerArTransactions           = QueryResults[3].Unload();
	Tables.PartnerApTransactions           = QueryResults[4].Unload();
	Tables.ReconciliationStatement_Expense = QueryResults[5].Unload();
	Tables.ReconciliationStatement_Receipt = QueryResults[6].Unload();
	Tables.Aging                           = QueryResults[7].Unload();
	
#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	

	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
	Return;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// AccountsStatement
	ArrayOfTables = New Array;
	If Parameters.DocumentDataTables.PartnerApTransactions.Count() Then
		Table1 = Parameters.DocumentDataTables.PartnerApTransactions.CopyColumns();
		Table1.Columns.Amount.Name = "TransactionAP";
		PostingServer.AddColumnsToAccountsStatementTable(Table1);
		For Each Row In Parameters.DocumentDataTables.PartnerApTransactions Do
			If Row.Agreement.Type = Enums.AgreementTypes.Vendor Then
				NewRow = Table1.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.TransactionAP = Row.Amount;
			EndIf;
		EndDo;
		Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table1);
	EndIf;

	If Parameters.DocumentDataTables.AdvanceToSuppliers.Count() Then
		Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers.CopyColumns();
		Table2.Columns.Amount.Name = "AdvanceToSuppliers";
		PostingServer.AddColumnsToAccountsStatementTable(Table2);
		For Each Row In Parameters.DocumentDataTables.AdvanceToSuppliers Do
			If Row.Partner.Vendor Then
				NewRow = Table2.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.AdvanceToSuppliers = Row.Amount;
			EndIf;
		EndDo;
		Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table2);
	EndIf;

	If Parameters.DocumentDataTables.PartnerApTransactions.Count() Then
		Table3 = Parameters.DocumentDataTables.PartnerApTransactions.CopyColumns();
		Table3.Columns.Amount.Name = "TransactionAR";
		PostingServer.AddColumnsToAccountsStatementTable(Table3);
		For Each Row In Parameters.DocumentDataTables.PartnerApTransactions Do
			If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
				NewRow = Table3.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.TransactionAR = -Row.Amount;
			EndIf;
		EndDo;
		Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table3);
	EndIf;

	If Parameters.DocumentDataTables.PartnerArTransactions.Count() Then
		Table5 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
		Table5.Columns.Amount.Name = "TransactionAP";
		PostingServer.AddColumnsToAccountsStatementTable(Table5);
		For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
			If Row.Agreement.Type = Enums.AgreementTypes.Vendor Then
				NewRow = Table5.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.TransactionAP = -Row.Amount;
			EndIf;
		EndDo;
		Table5.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table5);
	EndIf;

	If Parameters.DocumentDataTables.AdvanceFromCustomers.Count() Then
		Table7 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
		Table7.Columns.Amount.Name = "AdvanceFromCustomers";
		PostingServer.AddColumnsToAccountsStatementTable(Table7);
		For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
			If Row.Partner.Customer Then
				NewRow = Table7.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.AdvanceFromCustomers = Row.Amount;
			EndIf;
		EndDo;
		Table7.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table7);
	EndIf;

	If Parameters.DocumentDataTables.PartnerArTransactions.Count() Then
		Table8 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
		Table8.Columns.Amount.Name = "TransactionAR";
		PostingServer.AddColumnsToAccountsStatementTable(Table8);
		For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
			If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
				NewRow = Table8.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.TransactionAR = Row.Amount;
			EndIf;
		EndDo;
		Table8.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table8);
	EndIf;
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSuppliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AdvanceFromCustomers));
	
	// AdvanceToSuppliers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AdvanceToSuppliers));
	
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.AccountBalance));
		
	// PartnerArTransactions		
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.PartnerArTransactions));
	
	// PartnerApTransactions		
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.PartnerApTransactions));

	// ReconciliationStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.ReconciliationStatement_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.ReconciliationStatement_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, LegalName, Currency, Amount"),
			Parameters.IsReposting));

	// Aging
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.Aging,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.Aging));
#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion		
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "TableDataPath", "Object.Inventory");
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.OpeningEntry.Inventory", AddInfo);
EndProcedure

#EndRegion

#Region NewRegistersPosting

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Exists_R4010B_ActualStocks());
	QueryArray.Add(Exists_R4011B_FreeStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());	
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	OpeningEntryInventory.Ref,
		|	OpeningEntryInventory.Key,
		|	OpeningEntryInventory.ItemKey,
		|	OpeningEntryInventory.Store,
		|	OpeningEntryInventory.Quantity,
		|	NOT OpeningEntryInventory.SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef) AS isSerialLotNumberSet,
		|	OpeningEntryInventory.SerialLotNumber,
		|	OpeningEntryInventory.Ref.Date AS Period,
		|	OpeningEntryInventory.Ref.Company AS Company
		|INTO ItemList
		|FROM
		|	Document.OpeningEntry.Inventory AS OpeningEntryInventory
		|WHERE
		|	OpeningEntryInventory.Ref = &Ref";
EndFunction

Function R4010B_ActualStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE 
		|	TRUE";

EndFunction

Function Exists_R4010B_ActualStocks()
	Return
	"SELECT *
	|INTO Exists_R4010B_ActualStocks
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks AS R4010B_ActualStocks
	|WHERE
	|	R4010B_ActualStocks.Recorder = &Ref";
EndFunction

Function R4011B_FreeStocks()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS QueryTable
		|WHERE
		|	TRUE";

EndFunction

Function Exists_R4011B_FreeStocks()
	Return
	"SELECT *
	|INTO Exists_R4011B_FreeStocks
	|FROM
	|	AccumulationRegister.R4011B_FreeStocks AS R4011B_FreeStocks
	|WHERE
	|	R4011B_FreeStocks.Recorder = &Ref";
EndFunction

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	ItemList AS QueryTable
		|WHERE 
		|	QueryTable.isSerialLotNumberSet";

EndFunction

#EndRegion