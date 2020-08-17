#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Tables.Insert("PartnerApTransactions", New ValueTable());
	Tables.Insert("ExpensesTurnovers", New ValueTable());
	Tables.Insert("PartnerArTransactions", New ValueTable());
	Tables.Insert("ReconciliationStatement_Expense", New ValueTable());
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Doc.Company AS Company,
		|	Doc.Date AS Period,
		|	QueryTable.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
		|	QueryTable.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.Currency AS Currency,
		|	CASE
		|		WHEN QueryTable.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN CASE
		|				WHEN QueryTable.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor)
		|					THEN QueryTable.PartnerApTransactionsBasisDocument
		|				WHEN QueryTable.Agreement.Type = VALUE(Enum.AgreementTypes.Customer)
		|					THEN QueryTable.PartnerArTransactionsBasisDocument
		|			END
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.ExpenseType AS ExpenseType,
		|	CASE
		|		WHEN QueryTable.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND QueryTable.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN QueryTable.Agreement.StandardAgreement
		|		ELSE QueryTable.Agreement
		|	END AS Agreement,
		|	QueryTable.Partner AS Partner,
		|	Doc.LegalName AS LegalName,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.Key AS Key
		|INTO tmp
		|FROM
		|	Document.CreditNote.Transactions AS QueryTable
		|		LEFT JOIN Document.CreditNote AS Doc
		|		ON Doc.Ref = &Ref
		|WHERE
		|	QueryTable.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsVendor
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
		|	tmp.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.ExpenseType AS ExpenseType,
		|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.ExpenseType,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.Period,
		|	tmp.Key,
		|	VALUE(Catalog.ItemKeys.EmptyRef)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	-SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IsCustomer
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.BasisDocument,
		|	tmp.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	Tables.PartnerApTransactions = QueryResults[1].Unload();
	Tables.ExpensesTurnovers = QueryResults[2].Unload();
	Tables.PartnerArTransactions = QueryResults[3].Unload();
	Tables.ReconciliationStatement_Expense = QueryResults[4].Unload();
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// PartnerApTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerApTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerApTransactions));
	
	// ExpensesTurnovers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BusinessUnit", "BusinessUnit");
	Fields.Insert("ExpenseType", "ExpenseType");
	Fields.Insert("ItemKey", "ItemKey");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("AdditionalAnalytic", "AdditionalAnalytic");
	DataMapWithLockFields.Insert("AccumulationRegister.ExpensesTurnovers",
		New Structure("Fields, Data", Fields, DocumentDataTables.ExpensesTurnovers));
	
	// PartnerArTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerArTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerArTransactions));
		
	// ReconciliationStatement
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.ReconciliationStatement",
		New Structure("Fields, Data", Fields, DocumentDataTables.ReconciliationStatement_Expense));
	
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;	
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// AccountsStatement
	ArrayOfTables = New Array();
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
		
	Table2 = Parameters.DocumentDataTables.PartnerArTransactions.CopyColumns();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	For Each Row In Parameters.DocumentDataTables.PartnerArTransactions Do
		If Row.Agreement.Type = Enums.AgreementTypes.Customer Then
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
		
	// ReconciliationStatement	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ReconciliationStatement_Expense));
	
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
