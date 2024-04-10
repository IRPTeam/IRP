#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;

	StatusInfo = New Structure("Status, Posting", Ref.Status, ObjectStatusesServer.PutStatusPostingToStructure(
		Ref.Status));

	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.SetParameter("Ref", Ref);

	Query.Text = ChequeBondTransactionItem();
	Query.Execute();
	
 	// ChequeBondBalance

	Query.Text = ChequeBondBalance_Posting();
	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "ChequeBondBalance", "Posting"));
	Query.Execute();

	Query.Text = ChequeBondBalance_Reversal();
	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "ChequeBondBalance", "Reversal"));
	Query.Execute();

	Query.Text = ChequeBondBalance_Correction();
	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "ChequeBondBalance", "Correction"));
	Query.Execute();
	
	// CustomerTransaction

	Query.Text = CustomerTransaction_Posting();
	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "CustomerTransactions", "Posting"));
	Query.Execute();

	Query.Text = CustomerTransaction_Reversal();
	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "CustomerTransactions", "Reversal"));
	Query.Execute();

	Query.Text = CustomerTransaction_Correction();
	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "CustomerTransactions", "Correction"));
	Query.Execute();
	
	// VendorTransaction

	Query.Text = VendorTransaction_Posting();
	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "VendorTransactions", "Posting"));
	Query.Execute();

	Query.Text = VendorTransaction_Reversal();
	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "VendorTransactions", "Reversal"));
	Query.Execute();

	Query.Text = VendorTransaction_Correction();
	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "VendorTransactions", "Correction"));
	Query.Execute();
		
	// CashPlanning
	Query.Text = CashPlanning_Posting();
	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "CashPlanning", "Posting"));
	Query.Execute();

	Query.Text = CashPlanning_Reversal();
	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "CashPlanning", "Reversal"));
	Query.Execute();

	Query.Text = CashPlanning_Correction();
	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "CashPlanning", "Correction"));
	Query.Execute();

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function NeedPosting(StatusInfo, SettingName, PostingType)
	// SettingName:
	// ChequeBondBalance
	// VendorTransaction
	// CustomerTransaction
	// CashPlanning

	If PostingType = "Posting" Then
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Posting, True, False);
	ElsIf PostingType = "Reversal" Then
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Reversal, True, False);
	ElsIf PostingType = "Correction" Then
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Correction, True, False);
	EndIf;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
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

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R3016B_ChequeAndBonds());
	QueryArray.Add(R3035T_CashPlanning());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	Return QueryArray;
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	*
		   |INTO R3035T_CashPlanning
		   |FROM
		   |	CashPlanning_Posting AS Table
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	*
		   |FROM
		   |	CashPlanning_Correction AS Table
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	*
		   |FROM
		   |	CashPlanning_Reversal AS Table
		   |WHERE
		   |	TRUE";
EndFunction

Function R3016B_ChequeAndBonds()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R3016B_ChequeAndBonds
		   |FROM
		   |	ChequeBondBalance_Posting AS Table
		   |WHERE
		   |	Table.IsIncomingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	*
		   |FROM
		   |	ChequeBondBalance_Posting AS Table
		   |WHERE
		   |	Table.IsOutgoingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	*
		   |FROM
		   |	ChequeBondBalance_Correction AS Table
		   |WHERE
		   |	Table.IsIncomingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	*
		   |FROM
		   |	ChequeBondBalance_Correction AS Table
		   |WHERE
		   |	Table.IsOutgoingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT 
		   |	VALUE(AccumulationRecordType.Expense),
		   |	*
		   |FROM
		   |	ChequeBondBalance_Reversal AS Table
		   |WHERE
		   |	Table.IsIncomingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	*
		   |FROM
		   |	ChequeBondBalance_Reversal AS Table
		   |WHERE
		   |	Table.IsOutgoingCheque
		   |";
EndFunction

Function R2020B_AdvancesFromCustomers()
	Return AccumulationRegisters.R2020B_AdvancesFromCustomers.R2020B_AdvancesFromCustomers_Cheque();
EndFunction

Function R2021B_CustomersTransactions()
	Return AccumulationRegisters.R2021B_CustomersTransactions.R2021B_CustomersTransactions_Cheque();
EndFunction

Function R5011B_CustomersAging()
	Return AccumulationRegisters.R5011B_CustomersAging.R5011B_CustomersAging_Offset();
EndFunction

Function R1020B_AdvancesToVendors()
	Return AccumulationRegisters.R1020B_AdvancesToVendors.R1020B_AdvancesToVendors_Cheque();
EndFunction

Function R1021B_VendorsTransactions()
	Return AccumulationRegisters.R1021B_VendorsTransactions.R1021B_VendorsTransactions_Cheque();
EndFunction

Function R5012B_VendorsAging()
	Return AccumulationRegisters.R5012B_VendorsAging.R5012B_VendorsAging_Offset();
EndFunction

Function R5010B_ReconciliationStatement()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.LegalName,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.Amount
		   |INTO R5010B_ReconciliationStatement
		   |FROM
		   |	CustomerTransaction_Posting AS Table
		   |WHERE
		   |	Table.IsIncomingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.LegalName,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.Amount
		   |FROM
		   |	CustomerTransaction_Reversal AS Table
		   |WHERE
		   |	Table.IsIncomingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.LegalName,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.Amount
		   |FROM
		   |	CustomerTransaction_Correction AS Table
		   |WHERE
		   |	Table.IsIncomingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.LegalName,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.Amount
		   |FROM
		   |	VendorTransaction_Posting AS Table
		   |WHERE
		   |	Table.IsOutgoingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense),
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.LegalName,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.Amount
		   |FROM
		   |	VendorTransaction_Reversal AS Table
		   |WHERE
		   |	Table.IsOutgoingCheque
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.LegalName,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.Amount
		   |FROM
		   |	VendorTransaction_Correction AS Table
		   |WHERE
		   |	Table.IsOutgoingCheque";
EndFunction

Function T2014S_AdvancesInfo() 
	Return InformationRegisters.T2014S_AdvancesInfo.T2014S_AdvancesInfo_Cheque();
EndFunction

Function T2015S_TransactionsInfo()
	Return InformationRegisters.T2015S_TransactionsInfo.T2015S_TransactionsInfo_Cheque();
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Service

Function ChequeBondTransactionItem()
	Return "SELECT
		   |	Doc.Date AS Period,
		   |	Doc.Company,
		   |	Doc.Branch,
		   |	Doc.Cheque,
		   |	Doc.Cheque.Currency AS Currency,
		   |	Doc.Account,
		   |	Doc.Partner,
		   |	Doc.LegalName,
		   |	Doc.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque) AS IsIncomingCheque,
		   |	Doc.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque) AS IsOutgoingCheque,
		   |	Doc.Cheque.Amount AS Amount,
		   |	Doc.Cheque.DueDate AS DueDate,
		   |	Doc.BasisDocument,
		   |	Doc.Order,
		   |	CASE
		   |		WHEN DOc.Agreement.UseOrdersForSettlements
		   |			THEN Doc.Order
		   |		ELSE UNDEFINED
		   |	END AS OrderSettlements,
		   |	Doc.LegalNameContract,
		   |	Doc.FinancialMovementType,
		   |	Doc.PlanningPeriod,
		   |	Doc.Ref AS CashPlanningBasis,
		   |	Doc.Ref AS Ref,
		   |	CASE 
		   |		WHEN Doc.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque) THEN VALUE(Enum.CashFlowDirections.Incoming)
		   |		WHEN Doc.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque) THEN VALUE(Enum.CashFlowDirections.Outgoing)
		   |	END AS CashFlowDirection,
		   |
		   |	CASE
		   |		WHEN Doc.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND Doc.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN Doc.Agreement.StandardAgreement
		   |		ELSE Doc.Agreement
		   |	END AS Agreement,
		   |
		   |	CASE
		   |		WHEN Doc.Agreement.Ref IS NULL
		   |			THEN TRUE
		   |		ELSE CASE
		   |			WHEN Doc.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		   |			AND Doc.BasisDocument.Ref IS NULL
		   |				THEN TRUE
		   |			ELSE FALSE
		   |		END
		   |	END AS IsAdvance,
		   |
		   |	case when Doc.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments) Then
		   |	Doc.Agreement else Undefined end AS AdvanceAgreement,
		   |	Doc.Project
		   |INTO ChequeBondTransactionItem
		   |FROM
		   |	Document.ChequeBondTransactionItem AS Doc
		   |WHERE
		   |	Doc.Ref = &Ref";
EndFunction

#Region CashPlanning

Function CashPlanning_Posting()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.CashPlanningBasis AS BasisDocument,
		   |	Table.Account,
		   |	Table.Currency,
		   |	Table.CashFlowDirection,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.FinancialMovementType,
		   |	Table.PlanningPeriod,
		   |	Table.Amount
		   |INTO CashPlanning_Posting
		   |FROM 
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsPosting";
EndFunction

Function CashPlanning_Correction()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.CashPlanningBasis AS BasisDocument,
		   |	Table.Account,
		   |	Table.Currency,
		   |	Table.CashFlowDirection,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.FinancialMovementType,
		   |	Table.PlanningPeriod,
		   |	-Table.Amount AS Amount
		   |INTO CashPlanning_Correction
		   |FROM 
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsCorrection";
EndFunction

Function CashPlanning_Reversal()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.CashPlanningBasis AS BasisDocument,
		   |	Table.Account,
		   |	Table.Currency,
		   |	Table.CashFlowDirection,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.FinancialMovementType,
		   |	Table.PlanningPeriod,
		   |	-Table.Amount AS Amount
		   |INTO CashPlanning_Reversal
		   |FROM 
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsReversal";
EndFunction

#EndRegion

#Region ChequeBondBalance

Function ChequeBondBalance_Posting()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Currency,
		   |	Table.Cheque,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Amount,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO ChequeBondBalance_Posting
		   |FROM 
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsPosting";
EndFunction

Function ChequeBondBalance_Reversal()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Currency,
		   |	Table.Cheque,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Amount,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO ChequeBondBalance_Reversal
		   |FROM 
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsReversal";
EndFunction

Function ChequeBondBalance_Correction()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Currency,
		   |	Table.Cheque,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	-Table.Amount AS Amount,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO ChequeBondBalance_Correction
		   |FROM 
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsCorrection";
EndFunction

#EndRegion

#Region CustomerTransaction

Function CustomerTransaction_Posting()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Agreement,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement,
		   |	Table.Project,
		   |	Table.Order,
		   |	Table.OrderSettlements,
		   |	Table.Ref,
		   |	Table.BasisDocument,
		   |	Table.Amount,
		   |	Table.IsAdvance,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO CustomerTransaction_Posting
		   |FROM
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsPosting";
EndFunction

Function CustomerTransaction_Reversal()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Agreement,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement,
		   |	Table.Project,
		   |	Table.Order,
		   |	Table.OrderSettlements,
		   |	Table.Ref,
		   |	Table.BasisDocument,
		   |	Table.Amount,
		   |	Table.IsAdvance,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO CustomerTransaction_Reversal
		   |FROM
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsReversal";
EndFunction

Function CustomerTransaction_Correction()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Agreement,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement,
		   |	Table.Project,
		   |	Table.Order,
		   |	Table.OrderSettlements,
		   |	Table.Ref,
		   |	Table.BasisDocument,
		   |	-Table.Amount AS Amount,
		   |	Table.IsAdvance,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO CustomerTransaction_Correction
		   |FROM
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsCorrection";
EndFunction

#EndRegion

#Region VendorTransaction

Function VendorTransaction_Posting()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Agreement,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement,
		   |	Table.Project,
		   |	Table.Order,
		   |	Table.OrderSettlements,
		   |	Table.Ref,
		   |	Table.BasisDocument,
		   |	Table.Amount,
		   |	Table.IsAdvance,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO VendorTransaction_Posting
		   |FROM
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsPosting";
EndFunction

Function VendorTransaction_Reversal()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Agreement,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement,
		   |	Table.Project,
		   |	Table.Order,
		   |	Table.OrderSettlements,
		   |	Table.Ref,
		   |	Table.BasisDocument,
		   |	Table.Amount,
		   |	Table.IsAdvance,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO VendorTransaction_Reversal
		   |FROM
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsReversal";
EndFunction

Function VendorTransaction_Correction()
	Return "SELECT
		   |	Table.Period,
		   |	Table.Company,
		   |	Table.Branch,
		   |	Table.Partner,
		   |	Table.LegalName,
		   |	Table.Agreement,
		   |	Table.LegalNameContract,
		   |	Table.Currency,
		   |	Table.AdvanceAgreement,
		   |	Table.Project,
		   |	Table.Order,
		   |	Table.OrderSettlements,
		   |	Table.Ref,
		   |	Table.BasisDocument,
		   |	-Table.Amount AS Amount,
		   |	Table.IsAdvance,
		   |	Table.IsIncomingCheque,
		   |	Table.IsOutgoingCheque
		   |INTO VendorTransaction_Correction
		   |FROM
		   |	ChequeBondTransactionItem AS Table
		   |WHERE
		   |	&IsCorrection";
EndFunction

#EndRegion

#Region SYNCHRONIZATION

Function Sync_Post(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
	TableOfDocuments = FindDocuments(ArrayOfCheque, ChequeBondTransactionRef);
	SetDataLock(DataLock, TableOfDocuments);

	For Each Row In TableOfDocuments Do
		If ValueIsFilled(Row.ChequeBondTransactionRef) Then
			If Not ValueIsFilled(Row.DocumentRef) Then
				Row.DocumentRef = CreateAndPostDocument(Row.ChequeRef, ChequeBondTransactionRef);
			Else
				Row.DocumentRef = UpdateAndPostDocument(Row.DocumentRef, Row.ChequeRef, ChequeBondTransactionRef);
			EndIf;
		Else
			If ValueIsFilled(Row.DocumentRef) Then
				DocumentObject = Row.DocumentRef.GetObject();
				If DocumentObject.Posted Then
					WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
				EndIf;
				DocumentObject.Delete();
			EndIf;
		EndIf;
	EndDo;
	Return TableOfDocuments;
EndFunction

Function Sync_Unpost(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
	TableOfDocuments = FindDocuments(ArrayOfCheque, ChequeBondTransactionRef);
	SetDataLock(DataLock, TableOfDocuments);

	For Each Row In TableOfDocuments Do
		If ValueIsFilled(Row.ChequeBondTransactionRef) Then
			If ValueIsFilled(Row.DocumentRef) And Row.DocumentRef.Posted Then
				DocumentObject = Row.DocumentRef.GetObject();
				WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
			EndIf;
		Else
			If ValueIsFilled(Row.DocumentRef) Then
				DocumentObject = Row.DocumentRef.GetObject();
				If DocumentObject.Posted Then
					WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
				EndIf;
				DocumentObject.Delete();
			EndIf;
		EndIf;
	EndDo;
	Return TableOfDocuments;
EndFunction

Function Sync_SetDeletionMark(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
	TableOfDocuments = FindDocuments(ArrayOfCheque, ChequeBondTransactionRef);
	SetDataLock(DataLock, TableOfDocuments);

	For Each Row In TableOfDocuments Do
		If ValueIsFilled(Row.ChequeBondTransactionRef) Then
			If ValueIsFilled(Row.DocumentRef) And Not Row.DocumentRef.DeletionMark Then
				DocumentObject = Row.DocumentRef.GetObject();
				DocumentObject.DeletionMark = True;
				If DocumentObject.Posted Then
					WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
				Else
					WriteDocument(DocumentObject, DocumentWriteMode.Write);
				EndIf;
			EndIf;
		Else
			If ValueIsFilled(Row.DocumentRef) Then
				DocumentObject = Row.DocumentRef.GetObject();
				If DocumentObject.Posted Then
					WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
				EndIf;
				DocumentObject.Delete();
			EndIf;
		EndIf;
	EndDo;
	Return TableOfDocuments;
EndFunction

Function Sync_UnsetDeletionMark(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
	TableOfDocuments = FindDocuments(ArrayOfCheque, ChequeBondTransactionRef);
	SetDataLock(DataLock, TableOfDocuments);

	For Each Row In TableOfDocuments Do
		If ValueIsFilled(Row.ChequeBondTransactionRef) Then
			If ValueIsFilled(Row.DocumentRef) And Row.DocumentRef.DeletionMark Then
				DocumentObject = Row.DocumentRef.GetObject();
				DocumentObject.DeletionMark = False;
				WriteDocument(DocumentObject, DocumentWriteMode.Write);
			EndIf;
		Else
			If ValueIsFilled(Row.DocumentRef) Then
				DocumentObject = Row.DocumentRef.GetObject();
				If DocumentObject.Posted Then
					WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
				EndIf;
				DocumentObject.Delete();
			EndIf;
		EndIf;
	EndDo;
	Return TableOfDocuments;
EndFunction

Procedure DeleteDocuments(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
	TableOfDocuments = FindDocuments(ArrayOfCheque, ChequeBondTransactionRef);
	SetDataLock(DataLock, TableOfDocuments);

	For Each Row In TableOfDocuments Do
		If ValueIsFilled(Row.DocumentRef) Then
			DocumentObject = Row.DocumentRef.GetObject();
			If DocumentObject.Posted Then
				WriteDocument(DocumentObject, DocumentWriteMode.UndoPosting);
			EndIf;
			DocumentObject.Delete();
		EndIf;

	EndDo;
EndProcedure

Function FindDocuments(ArrayOfCheque, ChequeBondTransactionRef)
	DataSource = New ValueTable;
	DataSource.Columns.Add("Cheque", New TypeDescription("CatalogRef.ChequeBonds"));
	DataSource.Columns.Add("ChequeBondTransaction", New TypeDescription("DocumentRef.ChequeBondTransaction"));
	For Each ItemOfCheque In ArrayOfCheque Do
		NewRow = DataSource.Add();
		NewRow.Cheque = ItemOfCheque;
		NewRow.ChequeBondTransaction = ChequeBondTransactionRef;
	EndDo;

	Query = New Query;
	Query.Text =
	"SELECT
	|	DataSource.Cheque,
	|	DataSource.ChequeBondTransaction
	|INTO DataSource
	|FROM
	|	&DataSource AS DataSource
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ChequeBondTransactionItem.Ref AS Document,
	|	ChequeBondTransactionItem.Cheque AS Cheque,
	|	ChequeBondTransactionItem.ChequeBondTransaction AS ChequeBondTransaction
	|INTO ChequeBondTransactionItem
	|FROM
	|	Document.ChequeBondTransactionItem AS ChequeBondTransactionItem
	|WHERE
	|	ChequeBondTransactionItem.ChequeBondTransaction IN
	|		(SELECT
	|			DataSource.ChequeBondTransaction
	|		FROM
	|			DataSource AS DataSource)
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ChequeBondTransactionItem.Document AS DocumentRef,
	|	DataSource.Cheque AS ChequeRef,
	|	DataSource.ChequeBondTransaction AS ChequeBondTransactionRef
	|FROM
	|	DataSource AS DataSource
	|		FULL JOIN ChequeBondTransactionItem AS ChequeBondTransactionItem
	|		ON ChequeBondTransactionItem.Cheque = DataSource.Cheque
	|		AND ChequeBondTransactionItem.ChequeBondTransaction = DataSource.ChequeBondTransaction";

	Query.SetParameter("DataSource", DataSource);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Return QueryTable;
EndFunction

Function CreateAndPostDocument(ChequeRef, ChequeBondTransactionRef)
	ChequeInfo = GetChequeInfo(ChequeRef, ChequeBondTransactionRef);
	DocumentObject = CreateDocument();
	FillDocument(DocumentObject, ChequeInfo);
	WriteDocument(DocumentObject, DocumentWriteMode.Posting);
	Return DocumentObject.Ref;
EndFunction

Function UpdateAndPostDocument(DocumentRef, ChequeRef, ChequeBondTransactionRef)
	ChequeInfo = GetChequeInfo(ChequeRef, ChequeBondTransactionRef);
	DocumentObject = DocumentRef.GetObject();
	FillDocument(DocumentObject, ChequeInfo);
	If Not DocumentObject.DeletionMark Then
		WriteDocument(DocumentObject, DocumentWriteMode.Posting);
	Else
		WriteDocument(DocumentObject, DocumentWriteMode.Write);
	EndIf;
	Return DocumentRef;
EndFunction

Function GetChequeInfo(ChequeRef, ChequeBondTransactionRef)
	ChequeInfo = New Structure;
	ChequeInfo.Insert("ChequeBondTransaction", Undefined);
	ChequeInfo.Insert("PaymentList", New Array);
	ChequeInfo.Insert("Currencies", New Array);
	ChequeInfo.Insert("Date", Undefined);
	ChequeInfo.Insert("Status", Undefined);
	ChequeInfo.Insert("Company", Undefined);
	ChequeInfo.Insert("Branch", Undefined);
	ChequeInfo.Insert("LegalName", Undefined);
	ChequeInfo.Insert("LegalNameContract", Undefined);
	ChequeInfo.Insert("BasisDocument", Undefined);
	ChequeInfo.Insert("Order", Undefined);
	ChequeInfo.Insert("Account", Undefined);
	ChequeInfo.Insert("Cheque", Undefined);
	ChequeInfo.Insert("Agreement", Undefined);
	ChequeInfo.Insert("Partner", Undefined);
	ChequeInfo.Insert("Author", Undefined);
	ChequeInfo.Insert("FinancialMovementType", Undefined);
	ChequeInfo.Insert("PlanningPeriod", Undefined);

	Query = New Query;
	Query.Text =
	"SELECT
	|	ChequeBonds.Ref.Date,
	|	ChequeBonds.NewStatus AS Status,
	|	ChequeBonds.Ref.Company,
	|	ChequeBonds.LegalName,
	|	ChequeBonds.Account AS Account,
	|	ChequeBonds.Cheque,
	|	ChequeBonds.Ref AS ChequeBondTransaction,
	|	ChequeBonds.Ref.Branch AS Branch,
	|	ChequeBonds.Key,
	|	ChequeBonds.Agreement AS Agreement,
	|	ChequeBonds.LegalNameContract AS LegalNameContract,
	|	ChequeBonds.BasisDocument AS BasisDocument,
	|	ChequeBonds.Order AS Order,
	|	ChequeBonds.Partner AS Partner,
	|	ChequeBonds.Ref.Author AS Author,
	|	ChequeBonds.FinancialMovementType AS FinancialMovementType,
	|	ChequeBonds.PlanningPeriod AS PlanningPeriod
	|FROM
	|	Document.ChequeBondTransaction.ChequeBonds AS ChequeBonds
	|WHERE
	|	ChequeBonds.Ref = &ChequeBondTransactionRef
	|	AND ChequeBonds.Cheque = &ChequeRef";
	Query.SetParameter("ChequeRef", ChequeRef);
	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	If Not QuerySelection.Next() Then
		Return ChequeInfo;
	EndIf;

	MainRowKey = QuerySelection.Key;

	FillPropertyValues(ChequeInfo, QuerySelection);
		
	// Currencies

	Query = New Query;
	Query.Text =
	"SELECT *
	|FROM
	|	Document.ChequeBondTransaction.Currencies AS ChequeBondTransactionCurrencies
	|WHERE
	|	ChequeBondTransactionCurrencies.Ref = &ChequeBondTransactionRef
	|	AND ChequeBondTransactionCurrencies.Key = &Key";

	Query.SetParameter("Key", MainRowKey);
	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	For Each Row In QueryTable Do
		NewRow = New Structure;
		For Each Column In QueryTable.Columns Do
			NewRow.Insert(Column.Name, Row[Column.Name]);
		EndDo;
		ChequeInfo.Currencies.Add(NewRow);
	EndDo;

	Return ChequeInfo;
EndFunction

Procedure FillDocument(DocumentObject, ChequeInfo)
	DocumentObject.ChequeBondTransaction = ChequeInfo.ChequeBondTransaction;
	DocumentObject.Date      = ChequeInfo.Date;
	DocumentObject.Status    = ChequeInfo.Status;
	DocumentObject.Company   = ChequeInfo.Company;
	DocumentObject.Branch    = ChequeInfo.Branch;
	DocumentObject.LegalName = ChequeInfo.LegalName;
	DocumentObject.Account   = ChequeInfo.Account;
	DocumentObject.Cheque    = ChequeInfo.Cheque;
	DocumentObject.Agreement = ChequeInfo.Agreement;
	DocumentObject.LegalNameContract = ChequeInfo.LegalNameContract;
	DocumentObject.BasisDocument = ChequeInfo.BasisDocument;
	DocumentObject.Order     = ChequeInfo.Agreement;
	DocumentObject.Partner   = ChequeInfo.Partner;
	DocumentObject.Author    = ChequeInfo.Author;
	DocumentObject.FinancialMovementType = ChequeInfo.FinancialMovementType;
	DocumentObject.PlanningPeriod        = ChequeInfo.PlanningPeriod;
	
	// Currencies

	DocumentObject.Currencies.Clear();
	For Each Row In ChequeInfo.Currencies Do
		FillPropertyValues(DocumentObject.Currencies.Add(), Row);
	EndDo;
EndProcedure

Procedure SetDataLock(DataLock, TableOfDocuments)
	DataSource = New ValueTable;
	DataSource.Columns.Add("Ref", New TypeDescription("DocumentRef.ChequeBondTransactionItem"));

	For Each Row In TableOfDocuments Do
		If ValueIsFilled(Row.DocumentRef) Then
			DataSource.Add().Ref = Row.DocumentRef;
		EndIf;
	EndDo;

	ItemLock = DataLock.Add("Document.ChequeBondTransactionItem");
	ItemLock.Mode = DataLockMode.Exclusive;
	ItemLock.DataSource = DataSource;
	ItemLock.UseFromDataSource("Ref", "Ref");
	DataLock.Lock();
EndProcedure

Procedure WriteDocument(DocumentObject, WriteMode)
	If Not DocumentObject.AdditionalProperties.Property("WriteOnTransaction") Then
		DocumentObject.AdditionalProperties.Insert("WriteOnTransaction", True);
	Else
		DocumentObject.AdditionalProperties.WriteOnTransaction = True;
	EndIf;
	DocumentObject.Write(WriteMode);
EndProcedure

#EndRegion

#EndRegion

#Region Presentation

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Cheque");
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.Cheque);
EndProcedure

#EndRegion