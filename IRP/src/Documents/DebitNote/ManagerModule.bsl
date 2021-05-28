#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("RevenuesTurnovers"                     , PostingServer.CreateTable(AccReg.RevenuesTurnovers));
	
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
		|	Transactions.RevenueType AS RevenueType,
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
		|	Document.DebitNote.Transactions AS Transactions
		|WHERE
		|	Transactions.Ref = &Ref
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.RevenueType AS RevenueType,
		|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	tmp.Amount AS Amount,
		|	tmp.Period AS Period,
		|	tmp.Key AS Key
		|FROM
		|	tmp AS tmp";
	
	Query.SetParameter("Ref", Ref);
	QueryResults = Query.ExecuteBatch();
	
	Tables.RevenuesTurnovers         = QueryResults[1].Unload();
	
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
#Region NewRegistersPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	
	Tables.R1021B_VendorsTransactions.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key" , Metadata.DefinedTypes.typeRowID.Type);
	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion	
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();		
	// RevenuesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RevenuesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.RevenuesTurnovers));
		
#Region NewRegistersPosting	
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion

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
	QueryArray.Add(Transactions());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(T1001I_PartnerTransactions());
	Return QueryArray;
EndFunction

Function Transactions()
	Return
	"SELECT
	|	Transactions.Ref.Date AS Period,
	|	Transactions.Ref.Company AS Company,
	|	Transactions.Partner,
	|	Transactions.LegalName,
	|	Transactions.Agreement,
	|	CASE
	|		WHEN Transactions.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN Transactions.BasisDocument
	|		ELSE UNDEFINED
	|	END AS BasisDocument,
	|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Vendor) AS IsVendor,
	|	Transactions.Agreement.Type = VALUE(Enum.AgreementTypes.Customer) AS IsCustomer,
	|	Transactions.Currency,
	|	Transactions.Key,
	|	Transactions.Amount
	|INTO Transactions
	|FROM
	|	Document.DebitNote.Transactions AS Transactions
	|WHERE
	|	Transactions.Ref = &Ref";	
EndFunction

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period AS Period,
		|	Transactions.Company,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS Basis,
		|	Transactions.Key,
		|	Transactions.Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Key,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function T1001I_PartnerTransactions()
	Return
		"SELECT
		|	Transactions.Period AS Period,
		|	Transactions.Company,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS TransactionDocument,
		|	Transactions.Key,
		|	Transactions.Amount,
		|	TRUE AS IsCustomerTransaction,
		|	FALSE AS IsPaymentToVendor
		|INTO T1001I_PartnerTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|
		|UNION ALL
		|
		|SELECT
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument,
		|	Transactions.Key,
		|	Transactions.Amount,
		|	FALSE,
		|	TRUE
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor";
EndFunction

Function R1021B_VendorsTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period AS Period,
		|	Transactions.Company,
		|	Transactions.Currency,
		|	Transactions.LegalName,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS Basis,
		|	Transactions.Key,
		|	- Transactions.Amount AS Amount
		|INTO R1021B_VendorsTransactions
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsVendor";
EndFunction

Function R1020B_AdvancesToVendors()
	Return
		"SELECT *
		|INTO R1020B_AdvancesToVendors
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	FALSE";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvances.AdvancesDocument AS Basis,
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		|	*
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	InformationRegister.T1000I_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R5011B_CustomersAging()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	Transactions.Period AS PaymentDate,
		|	Transactions.Period AS Period,
		|	Transactions.Company,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument AS Invoice,
		|	SUM(Transactions.Amount) AS Amount,
		|	UNDEFINED AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	Transactions AS Transactions
		|WHERE
		|	Transactions.IsCustomer
		|	AND NOT Transactions.BasisDocument.Ref IS NULL
		|GROUP BY
		|	Transactions.Period,
		|	Transactions.Company,
		|	Transactions.Currency,
		|	Transactions.Partner,
		|	Transactions.Agreement,
		|	Transactions.BasisDocument,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder
		|FROM
		|	InformationRegister.T1003I_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction

Function R5012B_VendorsAging()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder AS AgingClosing
		|INTO R5012B_VendorsAging
		|FROM
		|	InformationRegister.T1003I_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	*
	|INTO R5010B_ReconciliationStatement
	|FROM
	|	Transactions";	
EndFunction


#EndRegion
