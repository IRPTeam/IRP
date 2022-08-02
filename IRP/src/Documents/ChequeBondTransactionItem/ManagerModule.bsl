
#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	
	StatusInfo = New Structure("Status, Posting", Ref.Status, ObjectStatusesServer.PutStatusPostingToStructure(Ref.Status));
	
	//TempTablesManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.SetParameter("Ref", Ref);
	
	Query.Text = ChequeBondTransactionItem();
	Query.Execute();
	
 	// R3016B_ChequeAndBonds
	
	// Incoming cheque
	Query.Text = R3016B_ChequeAndBonds_IncomingCheque_Posting(); // [20] Receipt (offset index 2)
	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "ChequeBondBalance", "Posting"));
	Query.Execute();
	
	Query.Text = R3016B_ChequeAndBonds_IncomingCheque_Reversal(); // [20] Expense (offset index 2)
	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "ChequeBondBalance", "Reversal"));
	Query.Execute();
	
	Query.Text = R3016B_ChequeAndBonds_IncomingCheque_Correction(); // [21] -Receipt (offset index 2)
	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "ChequeBondBalance", "Correction"));
	Query.Execute();
	
	// Outgoing cheque
	Query.Text = R3016B_ChequeAndBonds_OutgoingCheque_Posting(); // [22] Receipt (offset index 2)
	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "ChequeBondBalance", "Posting"));
	Query.Execute();
	
	Query.Text = R3016B_ChequeAndBonds_OutgoingCheque_Reversal(); // [22] Expense (offset index 2)
	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "ChequeBondBalance", "Reversal"));
	Query.Execute();
		
	Query.Text = R3016B_ChequeAndBonds_OutgoingCheque_Correction(); // [23] -Receipt (offset index 2)
	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "ChequeBondBalance", "Correction"));
	Query.Execute();

	// R2020B_AdvancesFromCustomers
	
	// Incoming cheque
//	Query.Text = R2020B_AdvancesFromCustomers_Incoming_Posting() // [4] Receipt
//	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "CustomerTransaction", "Posting"));
//	Query.Execute();
	
//	Query.Text = R2020B_AdvancesFromCustomers_Incoming_Reversal() // [4] Expense
//	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "CustomerTransaction", "Reversal"));
//	Query.Execute();
	
//	Query.Text = R2020B_AdvancesFromCustomers_Incoming_Correction() // [10] -Receipt
//	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "CustomerTransaction", "Correction"));
//	Query.Execute();
	
	
	// R1020B_AdvancesToVendors
	
	// Outgoing cheque
//	Query.Text = R1020B_AdvancesToVendors_Outgoing_Posting() // [5] Receipt
//	Query.SetParameter("IsPosting", NeedPosting(StatusInfo, "VendorTransaction", "Posting"));
//	Query.Execute();
	
//	Query.Text = R1020B_AdvancesToVendors_Outgoing_Reversal() // [5] Expense
//	Query.SetParameter("IsReversal", NeedPosting(StatusInfo, "VendorTransaction", "Reversal"));
//	Query.Execute();
	
//	Query.Text = R1020B_AdvancesToVendors_Outgoing_Correction() // [10] -Receipt
//	Query.SetParameter("IsCorrection", NeedPosting(StatusInfo, "VendorTransaction", "Correction"));
//	Query.Execute();
	
	

//=================================DRAFT====================================================================
	
// POSTING	
//	Tables.AdvanceFromCustomers_IncomingCheque = 
//		NeedPosting(StatusInfo, QueryResults[2].Unload(), "Advanced", "Posting");	
//	Tables.AdvanceToSuppliers_OutgoingCheque = 
//		NeedPosting(StatusInfo, QueryResults[3].Unload(), "Advanced", "Posting");
	
// CORRECTION
//	Tables.AdvanceFromCustomers_Correction_IncomingCheque = 
//		NeedPosting(StatusInfo, QueryResults[8].Unload(), "Advanced", "Correction");
//	Tables.AdvanceToSuppliers_Correction_OutgoingCheque = 
//		NeedPosting(StatusInfo, QueryResults[9].Unload(), "Advanced", "Correction");

// REVERSAL
//	Tables.AdvanceFromCustomers_Reversal_IncomingCheque = 
//		NeedPosting(StatusInfo, QueryResults[2].Unload(), "Advanced", "Reversal");
//	Tables.AdvanceToSuppliers_Reversal_OutgoingCheque = 
//		NeedPosting(StatusInfo, QueryResults[3].Unload(), "Advanced", "Reversal");


	
// R3016_ChequeAndBonds
// POSTING
//	Tables.ChequeBondBalance_IncomingCheque = 
//		NeedPosting(StatusInfo, QueryResults[18].Unload(), "ChequeBondBalance", "Posting");
//	Tables.ChequeBondBalance_OutgoingCheque = 
//		NeedPosting(StatusInfo, QueryResults[20].Unload(), "ChequeBondBalance", "Posting");
	
// CORRECTION
//	Tables.ChequeBondBalance_Correction_IncomingCheque = 
//		NeedPosting(StatusInfo, QueryResults[19].Unload(), "ChequeBondBalance", "Correction");
//	Tables.ChequeBondBalance_Correction_OutgoingCheque = 
//		NeedPosting(StatusInfo, QueryResults[21].Unload(), "ChequeBondBalance", "Correction");

// REVERSAL
//	Tables.ChequeBondBalance_Reversal_IncomingCheque = 
//		NeedPosting(StatusInfo, QueryResults[18].Unload(), "ChequeBondBalance", "Reversal");
//	Tables.ChequeBondBalance_Reversal_OutgoingCheque = 
//		NeedPosting(StatusInfo, QueryResults[20].Unload(), "ChequeBondBalance", "Reversal");

	
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

//Function NeedPosting(StatusInfo, PostingTable, SettingName, PostingType)
Function NeedPosting(StatusInfo, SettingName, PostingType)
	// SettingName:
	// ChequeBondBalance +
	// VendorTransaction
	// CustomerTransaction
	// CashPlanning
	
	If PostingType = "Posting" Then
		//Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Posting, PostingTable, New ValueTable());
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Posting, True, False);
	ElsIf PostingType = "Reversal" Then
		//Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Reversal, PostingTable, New ValueTable());
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Reversal, True, False);
	ElsIf PostingType = "Correction" Then
		//Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Correction, PostingTable, New ValueTable());
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Correction, True, False);
	EndIf;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);	
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region UNDOPOSTING

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

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R3016B_ChequeAndBonds());
	
//	QueryArray.Add(R2021B_CustomersTransactions());
//	QueryArray.Add(R2020B_AdvancesFromCustomers());
//	QueryArray.Add(R1021B_VendorsTransactions());
//	QueryArray.Add(R1020B_AdvancesToVendors());
//	QueryArray.Add(R5010B_ReconciliationStatement());
	
//	QueryArray.Add(R5011B_CustomersAging());
	
//	QueryArray.Add(T2014S_AdvancesInfo());
//	QueryArray.Add(T2015S_TransactionsInfo());
	
	Return QueryArray;
EndFunction

Function ChequeBondTransactionItem()
	Return
	"SELECT
	|	ChequeBondTransactionItem.Ref AS ReceiptDocument,
	|	ChequeBondTransactionItem.Ref AS PaymentDocument,
	//+
	|	ChequeBondTransactionItem.Date AS Period,
	|	ChequeBondTransactionItem.Company,
	|	ChequeBondTransactionItem.Branch,
	|	ChequeBondTransactionItem.Cheque,
	|	ChequeBondTransactionItem.Cheque.Currency AS Currency,
	|	ChequeBondTransactionItem.Account,
	|	ChequeBondTransactionItem.Partner,
	|	ChequeBondTransactionItem.LegalName,
	|	ChequeBondTransactionItem.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque) AS IsIncomingCheque,
	|	ChequeBondTransactionItem.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque) AS IsOutgoingCheque,
	|	ChequeBondTransactionItem.Cheque.Amount AS Amount,
	|
	//===
	|	CASE
	|		WHEN ChequeBondTransactionItem.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
	|		AND ChequeBondTransactionItem.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
	|			THEN ChequeBondTransactionItem.Agreement.StandardAgreement
	|		ELSE ChequeBondTransactionItem.Agreement
	|	END AS Agreement,
//	|	CASE
//	|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
//	|			THEN VALUE(Catalog.Currencies.EmptyRef)
//	|		ELSE ChequeBondTransactionItem.Cheque.Currency
//	|	END AS Currency,
	|	CASE
	|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
	|			THEN DATETIME(1, 1, 1)
	|		ELSE ChequeBondTransactionItem.Cheque.DueDate
	|	END AS DueDate,
//	|	CASE
//	|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
//	|			THEN 0
//	|		ELSE ChequeBondTransactionItem.Cheque.Amount
//	|	END AS Amount,
//	|	CASE
//	|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
//	|			THEN FALSE
//	|		ELSE ChequeBondTransactionItem.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque)
//	|	END AS OutgoingCheque,
//	|	CASE
//	|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
//	|			THEN FALSE
//	|		ELSE ChequeBondTransactionItem.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque)
//	|	END AS IncomingCheque,
	|	
	|	CASE
	|		WHEN NOT (ChequeBondTransactionItem.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
	|		AND ChequeBondTransactionItem.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments))
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsAdvance
	|INTO ChequeBondTransactionItem
	|FROM
	|	Document.ChequeBondTransactionItem AS ChequeBondTransactionItem
	|WHERE
	|	ChequeBondTransactionItem.Ref = &Ref";
EndFunction

#Region R3016B_ChequeAndBonds

Function R3016B_ChequeAndBonds_IncomingCheque_Posting() //[20]
	Return
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Cheque,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Amount
	|INTO R3016B_ChequeAndBonds_IncomingCheque_Posting
	|FROM 
	|	ChequeBondTransactionItem AS Table
	|WHERE
	|	Table.IsIncomingCheque AND &IsPosting";
EndFunction

Function R3016B_ChequeAndBonds_IncomingCheque_Reversal() //[20]
	Return
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Cheque,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Amount
	|INTO R3016B_ChequeAndBonds_IncomingCheque_Reversal
	|FROM 
	|	ChequeBondTransactionItem AS Table
	|WHERE
	|	Table.IsIncomingCheque AND &IsReversal";
EndFunction

Function R3016B_ChequeAndBonds_IncomingCheque_Correction() //[21]
	Return
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Cheque,
	|	Table.Partner,
	|	Table.LegalName,
	|	-Table.Amount AS Amount
	|INTO R3016B_ChequeAndBonds_IncomingCheque_Correction
	|FROM 
	|	ChequeBondTransactionItem AS Table
	|WHERE
	|	Table.IsIncomingCheque AND &IsCorrection";
EndFunction

Function R3016B_ChequeAndBonds_OutgoingCheque_Posting() //[22]
	Return
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Cheque,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Amount
	|INTO R3016B_ChequeAndBonds_OutgoingCheque_Posting
	|FROM 
	|	ChequeBondTransactionItem AS Table
	|WHERE
	|	Table.IsOutgoingCheque AND &IsPosting";
EndFunction

Function R3016B_ChequeAndBonds_OutgoingCheque_Reversal() //[22]
	Return
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Cheque,
	|	Table.Partner,
	|	Table.LegalName,
	|	Table.Amount
	|INTO R3016B_ChequeAndBonds_OutgoingCheque_Reversal
	|FROM 
	|	ChequeBondTransactionItem AS Table
	|WHERE
	|	Table.IsOutgoingCheque AND &IsReversal";
EndFunction

Function R3016B_ChequeAndBonds_OutgoingCheque_Correction() //[23]
	Return
	"SELECT
	|	Table.Period,
	|	Table.Company,
	|	Table.Branch,
	|	Table.Currency,
	|	Table.Cheque,
	|	Table.Partner,
	|	Table.LegalName,
	|	-Table.Amount AS Amount
	|INTO R3016B_ChequeAndBonds_OutgoingCheque_Correction
	|FROM 
	|	ChequeBondTransactionItem AS Table
	|WHERE
	|	Table.IsOutgoingCheque AND &IsCorrection";	
EndFunction

#EndRegion

Function R3016B_ChequeAndBonds()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	*
//	|	Table.Period,
//	|	Table.Company,
//	|	Table.Branch,
//	|	Table.Currency,
//	|	Table.Cheque,
//	|	Table.Partner,
//	|	Table.LegalName,
//	|	Table.Amount
	|INTO R3016B_ChequeAndBonds
	|FROM
	|	R3016B_ChequeAndBonds_IncomingCheque_Posting AS Table
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt),
	|	*
	|FROM
	|	R3016B_ChequeAndBonds_OutgoingCheque_Posting AS Table
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt),
	|	*
	|FROM
	|	R3016B_ChequeAndBonds_IncomingCheque_Correction AS Table
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt),
	|	*
	|FROM
	|	R3016B_ChequeAndBonds_OutgoingCheque_Correction AS Table
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT 
	|	VALUE(AccumulationRecordType.Expense),
	|	*
	|FROM
	|	R3016B_ChequeAndBonds_IncomingCheque_Reversal AS Table
	|WHERE
	|	TRUE
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense),
	|	*
	|FROM
	|	R3016B_ChequeAndBonds_OutgoingCheque_Reversal AS Table
	|WHERE
	|	TRUE
	|";
EndFunction


//		"SELECT
//		|	QueryTable.ReceiptDocument AS ReceiptDocument,
//		|	QueryTable.PaymentDocument AS PaymentDocument,
//		|	QueryTable.Cheque AS Cheque,
//		|	QueryTable.Period AS Period,
//		|	QueryTable.DueDate AS DueDate,
//		|	QueryTable.Company AS Company,
//		|	QueryTable.LegalName AS LegalName,
//		|	QueryTable.Partner AS Partner,
//		|	QueryTable.Currency AS Currency,
//		|	QueryTable.Account AS Account,
//		|	QueryTable.Amount AS Amount,
//		|	QueryTable.IncomingCheque AS IncomingCheque,
//		|	QueryTable.OutgoingCheque AS OutgoingCheque,
//		|	QueryTable.IsAdvance AS IsAdvance,
//		|	QueryTable.Agreement AS Agreement
//		|INTO tmp
//		|FROM
//		|	&QueryTable AS QueryTable
//		|;
//		|
//		|//[1]//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	QueryTable_PaymentList.Company,
//		|	QueryTable_PaymentList.Period AS Period,
//		|	QueryTable_PaymentList.PartnerArBasisDocument,
//		|	QueryTable_PaymentList.PartnerApBasisDocument,
//		|	QueryTable_PaymentList.Partner,
//		|	QueryTable_PaymentList.LegalName,
//		|	QueryTable_PaymentList.Agreement,
//		|	QueryTable_PaymentList.Currency,
//		|	QueryTable_PaymentList.Amount,
//		|	QueryTable_PaymentList.IncomingCheque AS IncomingCheque,
//		|	QueryTable_PaymentList.OutgoingCheque AS OutgoingCheque
//		|INTO tmp_paymentlist
//		|FROM
//		|	&QueryTable_PaymentList AS QueryTable_PaymentList
//		|;
//		|
//		|//[2] AdvanceFromCustomers_IncomingCheque //////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument,
//		|	tmp.Period AS Period,
//		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
//		|		ON TRUE
//		|WHERE
//		|	tmp.IncomingCheque AND tmp.IsAdvance
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument,
//		|	tmp.Period
//		|HAVING
//		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) <> 0
//		|;
//		|//////////////////////////////////////////////////
//		|//[3] AdvanceToSuppliers_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument,
//		|	tmp.Period AS Period,
//		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
//		|		ON TRUE
//		|WHERE
//		|	tmp.OutgoingCheque AND tmp.IsAdvance
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument,
//		|	tmp.Period
//		|HAVING
//		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) <> 0
//		|;
//		|
//		|
//		|//[4] AccountBalance_IncomingCheque//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.IncomingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period
//		|;
//		|
//		|//////////////////////////////////////////////////////
//		|//[5] AccountBalance_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.OutgoingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period
//		|;
//		|//[6] PartnerArTransactions_IncomingCheque//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerArBasisDocument AS BasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END AS Amount
//		|FROM
//		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
//		|WHERE
//		|	tmp.IncomingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerArBasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period,
//		|	tmp.IsAdvance
//		|HAVING CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END <> 0
//		|;
//		|/////////////////////////////////////////////////////////////////////////////////////////
//		|//[7] PartnerApTransactions_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerApBasisDocument AS BasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END AS Amount
//		|FROM
//		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
//		|WHERE
//		|	tmp.OutgoingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerApBasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period,
//		|	tmp.IsAdvance
//		|HAVING CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END <> 0
//		|;	
//		|
//		|//[8] AdvanceFromCustomers_Correction_IncomingCheque //////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument,
//		|	tmp.Period AS Period,
//		|	-(MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0))) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
//		|		ON TRUE
//		|WHERE
//		|	tmp.IncomingCheque AND tmp.IsAdvance
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument,
//		|	tmp.Period
//		|;
//		|//////////////////////////////////////////////////////////////////////////
//		|//[9] AdvanceToSuppliers_Correction_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument,
//		|	tmp.Period AS Period,
//		|	-(MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0))) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
//		|		ON TRUE
//		|WHERE
//		|	tmp.OutgoingCheque AND tmp.IsAdvance
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument,
//		|	tmp.Period
//		|;	
//		|
//		|
//		|
//		|
//		|//[12] AccountBalance_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	-SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.IncomingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period
//		|;
//		|///////////////////////////////////////////////////////////////////
//		|//[13] AccountBalance_Correction_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	-SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.OutgoingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.Period
//		|;
//		|
//		|//[14] PartnerArTransactions_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerArBasisDocument AS BasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END AS Amount
//		|FROM
//		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
//		|WHERE
//		|	tmp.IncomingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerArBasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period,
//		|	tmp.IsAdvance
//		|HAVING CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END <> 0
//		|;
//		|///////////////////////////////////////////////////////////////////////////
//		|//[15] PartnerApTransactions_Correction_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerApBasisDocument AS BasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period AS Period,
//		|	CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END AS Amount
//		|FROM
//		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
//		|WHERE
//		|	tmp.OutgoingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp_paymentlist.PartnerApBasisDocument,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Agreement,
//		|	tmp.Currency,
//		|	tmp.Period,
//		|	tmp.IsAdvance
//		|HAVING CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END <> 0
//		|;
//		|
//		|//[16] PlaningCashTransactions_IncomingCheque//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument AS BasisDocument,
//		|	tmp.DueDate AS Period,
//		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
//		|	SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.IncomingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument,
//		|	tmp.DueDate,
//		|	VALUE(Enum.CashFlowDirections.Incoming)
//		|;
//		|///////////////////////////////////////////////////////////////////////////////
//		|//[17] PlaningCashTransactions_OutgoingCheque
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument AS BasisDocument,
//		|	tmp.DueDate AS Period,
//		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
//		|	SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.OutgoingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument,
//		|	tmp.DueDate,
//		|	VALUE(Enum.CashFlowDirections.Outgoing)
//		|;
//		|
//		|//[18] PlaningCashTransactions_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument AS BasisDocument,
//		|	tmp.Period AS Period,
//		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
//		|	-SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.IncomingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.ReceiptDocument,
//		|	tmp.Period,
//		|	VALUE(Enum.CashFlowDirections.Incoming)
//		|;
//		|/////////////////////////////////////////////////////////////////////
//		|//[19] PlaningCashTransactions_Correction_OutgoingCheque
//		|
//		|SELECT
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument AS BasisDocument,
//		|	tmp.Period AS Period,
//		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
//		|	-SUM(tmp.Amount) AS Amount
//		|FROM
//		|	tmp AS tmp
//		|WHERE
//		|	tmp.OutgoingCheque
//		|GROUP BY
//		|	tmp.Company,
//		|	tmp.Partner,
//		|	tmp.LegalName,
//		|	tmp.Account,
//		|	tmp.Currency,
//		|	tmp.PaymentDocument,
//		|	tmp.Period,
//		|	VALUE(Enum.CashFlowDirections.Outgoing);
////		|//[20] ChequeBondBalance_Incoming
////		|SELECT
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period,
////		|	SUM(tmp.Amount) AS Amount
////		|FROM 
////		|	tmp AS tmp
////		|WHERE
////		|	tmp.IncomingCheque
////		|GROUP BY
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period;
////		|//[21] ChequeBondBalance_Correction_Incoming
////		|SELECT
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period,
////		|	-SUM(tmp.Amount) AS Amount
////		|FROM 
////		|	tmp AS tmp
////		|WHERE
////		|	tmp.IncomingCheque
////		|GROUP BY
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period;
////		|//[22] ChequeBondBalance_Outgoing
////		|SELECT
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period,
////		|	SUM(tmp.Amount) AS Amount
////		|FROM 
////		|	tmp AS tmp
////		|WHERE
////		|	tmp.OutgoingCheque
////		|GROUP BY
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period;
////		|//[23] ChequeBondBalance_Correction_Outgoing
////		|SELECT
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period,
////		|	-SUM(tmp.Amount) AS Amount
////		|FROM 
////		|	tmp AS tmp
////		|WHERE
////		|	tmp.OutgoingCheque
////		|GROUP BY
////		|	tmp.Company,
////		|	tmp.Cheque,
////		|	tmp.Partner,
////		|	tmp.LegalName,
////		|	tmp.Currency,
////		|	tmp.Period;
////		|";
	


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
	DataSource = New ValueTable();
	DataSource.Columns.Add("Cheque"                , New TypeDescription("CatalogRef.ChequeBonds"));
	DataSource.Columns.Add("ChequeBondTransaction" , New TypeDescription("DocumentRef.ChequeBondTransaction"));
	For Each ItemOfCheque In ArrayOfCheque Do
		NewRow = DataSource.Add();
		NewRow.Cheque = ItemOfCheque;
		NewRow.ChequeBondTransaction = ChequeBondTransactionRef;
	EndDo;
	
	Query = New Query();
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
	DocumentObject = Documents.ChequeBondTransactionItem.CreateDocument();
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
	ChequeInfo = New Structure();
	ChequeInfo.Insert("ChequeBondTransaction", Undefined);
	ChequeInfo.Insert("PaymentList" , New Array());
	ChequeInfo.Insert("Currencies"  , New Array());
	ChequeInfo.Insert("Date"        , Undefined);
	ChequeInfo.Insert("Status"      , Undefined);
	ChequeInfo.Insert("Company"     , Undefined);
	ChequeInfo.Insert("Branch"      , Undefined);
	ChequeInfo.Insert("LegalName"   , Undefined);
	ChequeInfo.Insert("Account"     , Undefined);
	ChequeInfo.Insert("Cheque"      , Undefined);
	ChequeInfo.Insert("Agreement"   , Undefined);
	ChequeInfo.Insert("Partner"     , Undefined);
	ChequeInfo.Insert("Author"      , Undefined);
	
	Query = New Query();
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
		|	ChequeBonds.Partner AS Partner,
		|	ChequeBonds.Ref.Author AS Author
		|FROM
		|	Document.ChequeBondTransaction.ChequeBonds AS ChequeBonds
		|WHERE
		|	ChequeBonds.Ref = &ChequeBondTransactionRef
		|	AND ChequeBonds.Cheque = &ChequeRef";
	Query.SetParameter("ChequeRef"               , ChequeRef);
	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If Not QuerySelection.Next() Then
		Return ChequeInfo;
	EndIf;
	
	MainRowKey = QuerySelection.Key;
	
	FillPropertyValues(ChequeInfo, QuerySelection);
	
	
	// PaymentList
	
//	Query = New Query();
//	Query.Text =
//		"SELECT
//		|	ChequeBondTransactionPaymentList.PartnerArBasisDocument,
//		|	ChequeBondTransactionPaymentList.PartnerApBasisDocument,
//		|	ChequeBondTransactionPaymentList.Amount
//		|FROM
//		|	Document.ChequeBondTransaction.PaymentList AS ChequeBondTransactionPaymentList
//		|WHERE
//		|	ChequeBondTransactionPaymentList.Ref = &ChequeBondTransactionRef
//		|	AND ChequeBondTransactionPaymentList.Key = &Key";
//	Query.SetParameter("Key", MainRowKey);
//	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
//	While QuerySelection.Next() Do
//		PaymentListRow = New Structure();
//		PaymentListRow.Insert("PartnerArBasisDocument", QuerySelection.PartnerArBasisDocument);
//		PaymentListRow.Insert("PartnerApBasisDocument", QuerySelection.PartnerApBasisDocument);
//		PaymentListRow.Insert("Amount", QuerySelection.Amount);
//		ChequeInfo.PaymentList.Add(PaymentListRow);
//	EndDo;
	
	
	// Currencies
	
	Query = New Query();
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
		NewRow = New Structure();
		For Each Column In QueryTable.Columns Do
			NewRow.Insert(Column.Name, Row[Column.Name]);
		EndDo;
		ChequeInfo.Currencies.Add(NewRow);
	EndDo;
	
	//QuerySelection = QueryResult.Select();
//	While QuerySelection.Next() Do
//		CurrenciesRow = New Structure();
//		CurrenciesRow.Insert("CurrencyFrom", QuerySelection.CurrencyFrom);
//		CurrenciesRow.Insert("Rate", QuerySelection.Rate);
//		CurrenciesRow.Insert("ReverseRate", QuerySelection.ReverseRate);
//		CurrenciesRow.Insert("ShowReverseRate", QuerySelection.ShowReverseRate);
//		CurrenciesRow.Insert("Multiplicity", QuerySelection.Multiplicity);
//		CurrenciesRow.Insert("MovementType", QuerySelection.MovementType);
//		CurrenciesRow.Insert("Amount", QuerySelection.Amount);
//		CurrenciesRow.Insert("Key", QuerySelection.Key);
//		ChequeInfo.Currencies.Add(CurrenciesRow);
//	EndDo;
	
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
	DocumentObject.Partner   = ChequeInfo.Partner;
	DocumentObject.Author    = ChequeInfo.Author;
	
	// PaymentList
	
//	DocumentObject.PaymentList.Clear();
//	For Each Row In ChequeInfo.PaymentList Do
//		FillPropertyValues(DocumentObject.PaymentList.Add(), Row);
//	EndDo;
	
	// Currencies
	
	DocumentObject.Currencies.Clear();
	For Each Row In ChequeInfo.Currencies Do
		FillPropertyValues(DocumentObject.Currencies.Add(), Row);
	EndDo;
EndProcedure

Procedure SetDataLock(DataLock, TableOfDocuments)
	DataSource = New ValueTable();
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

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Cheque");
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.Cheque);
EndProcedure
