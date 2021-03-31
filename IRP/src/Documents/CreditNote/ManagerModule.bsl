#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("PartnerApTransactions"       , PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PartnerArTransactions"       , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("ExpensesTurnovers"           , PostingServer.CreateTable(AccReg.ExpensesTurnovers));
	Tables.Insert("Aging_Expense"               , PostingServer.CreateTable(AccReg.Aging));
	Tables.Insert("PartnerArTransactions_Aging" , PostingServer.CreateTable(AccReg.PartnerArTransactions));
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Transactions.Ref.Company AS Company,
		|	Transactions.Ref.Date AS Period,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		|	Transactions.AdditionalAnalytic AS AdditionalAnalytic,
		|	Transactions.Currency AS Currency,
		|	Transactions.BasisDocument AS BasisDocument,
		|	Transactions.BusinessUnit AS BusinessUnit,
		|	Transactions.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN Transactions.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN Transactions.Agreement.StandardAgreement
		|		ELSE Transactions.Agreement
		|	END AS Agreement,
		|	Transactions.Partner AS Partner,
		|	Transactions.LegalName AS LegalName,
		|	Transactions.Amount AS Amount,
		|	Transactions.Key AS Key
		|INTO tmp
		|FROM
		|	Document.CreditNote.Transactions AS Transactions
		|WHERE
		|	Transactions.Ref = &Ref
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key,
		|	tmp.IsVendor,
		|	tmp.IsCustomer
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsVendor
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	-tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key,
		|	tmp.IsVendor,
		|	tmp.IsCustomer
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsCustomer
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key,
		|	tmp.IsVendor,
		|	tmp.IsCustomer
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsCustomer
		|";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PartnerApTransactions       = QueryResults[1].Unload();
	Tables.ExpensesTurnovers           = QueryResults[2].Unload();
	Tables.PartnerArTransactions       = QueryResults[3].Unload();
	Tables.PartnerArTransactions_Aging = QueryResults[4].Unload();
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	PartnerApTransactions = AccumulationRegisters.PartnerApTransactions.GetLockFields(DocumentDataTables.PartnerApTransactions);
	DataMapWithLockFields.Insert(PartnerApTransactions.RegisterName, PartnerApTransactions.LockInfo);
	
	// PartnerArTransactions
	PartnerArTransactions = AccumulationRegisters.PartnerArTransactions.GetLockFields(DocumentDataTables.PartnerArTransactions);
	DataMapWithLockFields.Insert(PartnerArTransactions.RegisterName, PartnerArTransactions.LockInfo);
	
	// ExpensesTurnovers
	ExpensesTurnovers = AccumulationRegisters.ExpensesTurnovers.GetLockFields(DocumentDataTables.ExpensesTurnovers);
	DataMapWithLockFields.Insert(ExpensesTurnovers.RegisterName, ExpensesTurnovers.LockInfo);
	
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Aging expense
	Parameters.DocumentDataTables.Aging_Expense = 
		AccumulationRegisters.Aging.GetTableAging_Expense_OnMoneyReceipt(
		Parameters.PointInTime,
		Parameters.DocumentDataTables.PartnerArTransactions_Aging,
		Undefined);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerApTransactions.CopyColumns();
	Table1.Columns.Amount.Name = "TransactionAP";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	For Each Row In Parameters.DocumentDataTables.PartnerApTransactions Do
		If Row.IsVendor Then
			NewRow = Table1.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAP = Row.Amount;
		EndIf;
	EndDo;
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");	
	ArrayOfTables.Add(Table1);
		
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.IsCustomer Then
			NewRow = Table2.Add(); 
			FillPropertyValues(NewRow, Row);
			NewRow.TransactionAR = Row.Amount;
		EndIf;
	EndDo;
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSuppliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
			
	// PartnerApTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.PartnerApTransactions));
	
	// ExpensesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ExpensesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.ExpensesTurnovers));
	
	// PartnerArTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.PartnerArTransactions));
		
	
	// Aging
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.Aging,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.Aging_Expense));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
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

	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;

	Return QueryArray;
EndFunction

#EndRegion
