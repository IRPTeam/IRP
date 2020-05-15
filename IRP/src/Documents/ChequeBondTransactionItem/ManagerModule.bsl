#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	
	Tables.Insert("AdvanceFromCustomers", PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceToSuppliers", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReconciliationStatement", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("AccountBalance", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PartnerArTransactions", PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("PartnerApTransactions", PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PlaningCashTransactions", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("ChequeBondBalance", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	
	Tables.Insert("AdvanceFromCustomers_IncomingCheque", PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceToSuppliers_OutgoingCheque", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReconciliationStatement_IncomingCheque", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("ReconciliationStatement_OutgoingCheque", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("AccountBalance_IncomingCheque", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("AccountBalance_OutgoingCheque", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PartnerArTransactions_IncomingCheque", PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("PartnerApTransactions_OutgoingCheque", PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PlaningCashTransactions_IncomingCheque", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("PlaningCashTransactions_OutgoingCheque", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("ChequeBondBalance_IncomingCheque", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	Tables.Insert("ChequeBondBalance_OutgoingCheque", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	
	Tables.Insert("AdvanceFromCustomers_Correction_IncomingCheque", PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceToSuppliers_Correction_OutgoingCheque", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReconciliationStatement_Correction_IncomingCheque", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("ReconciliationStatement_Correction_OutgoingCheque", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("AccountBalance_Correction_IncomingCheque", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("AccountBalance_Correction_OutgoingCheque", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PartnerArTransactions_Correction_IncomingCheque", PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("PartnerApTransactions_Correction_OutgoingCheque", PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PlaningCashTransactions_Correction_IncomingCheque", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("PlaningCashTransactions_Correction_OutgoingCheque", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("ChequeBondBalance_Correction_IncomingCheque", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	Tables.Insert("ChequeBondBalance_Correction_OutgoingCheque", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	
	
	Tables.Insert("AdvanceFromCustomers_Reversal_IncomingCheque", PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceToSuppliers_Reversal_OutgoingCheque", PostingServer.CreateTable(AccReg.AdvanceToSuppliers));
	Tables.Insert("ReconciliationStatement_Reversal_IncomingCheque", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("ReconciliationStatement_Reversal_OutgoingCheque", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("AccountBalance_Reversal_IncomingCheque", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("AccountBalance_Reversal_OutgoingCheque", PostingServer.CreateTable(AccReg.AccountBalance));
	Tables.Insert("PartnerArTransactions_Reversal_IncomingCheque", PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("PartnerApTransactions_Reversal_OutgoingCheque", PostingServer.CreateTable(AccReg.PartnerApTransactions));
	Tables.Insert("PlaningCashTransactions_Reversal_IncomingCheque", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("PlaningCashTransactions_Reversal_OutgoingCheque", PostingServer.CreateTable(AccReg.PlaningCashTransactions));
	Tables.Insert("ChequeBondBalance_Reversal_IncomingCheque", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	Tables.Insert("ChequeBondBalance_Reversal_OutgoingCheque", PostingServer.CreateTable(AccReg.ChequeBondBalance));
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionItem.Ref AS ReceiptDocument,
		|	ChequeBondTransactionItem.Ref AS PaymentDocument,
		|	ChequeBondTransactionItem.Date AS Period,
		|	ChequeBondTransactionItem.Company,
		|	ChequeBondTransactionItem.LegalName,
		|	ChequeBondTransactionItem.Partner AS Partner,
		|	CASE
		|		WHEN ChequeBondTransactionItem.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND ChequeBondTransactionItem.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN ChequeBondTransactionItem.Agreement.StandardAgreement
		|		ELSE ChequeBondTransactionItem.Agreement
		|	END AS Agreement,
		|	CASE
		|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN VALUE(Catalog.Currencies.EmptyRef)
		|		ELSE ChequeBondTransactionItem.Cheque.Currency
		|	END AS Currency,
		|	CASE
		|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN DATETIME(1, 1, 1)
		|		ELSE ChequeBondTransactionItem.Cheque.DueDate
		|	END AS DueDate,
		|	ChequeBondTransactionItem.Account,
		|	CASE
		|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN 0
		|		ELSE ChequeBondTransactionItem.Cheque.Amount
		|	END AS Amount,
		|	CASE
		|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN FALSE
		|		ELSE ChequeBondTransactionItem.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque)
		|	END AS OutgoingCheque,
		|	CASE
		|		WHEN ChequeBondTransactionItem.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN FALSE
		|		ELSE ChequeBondTransactionItem.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque)
		|	END AS IncomingCheque,
		|	ChequeBondTransactionItem.Cheque,
		|	CASE
		|		WHEN NOT (ChequeBondTransactionItem.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND ChequeBondTransactionItem.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments))
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS IsAdvance
		|FROM
		|	Document.ChequeBondTransactionItem AS ChequeBondTransactionItem
		|WHERE
		|	ChequeBondTransactionItem.Ref = &Ref";
	
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionItemPaymentList.Ref.Company,
		|	ChequeBondTransactionItemPaymentList.Ref.Date AS Period,
		|	CASE
		|		WHEN
		|			ChequeBondTransactionItemPaymentList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN ChequeBondTransactionItemPaymentList.PartnerArBasisDocument
		|		ELSE UNDEFINED
		|	END AS PartnerArBasisDocument,
		|	CASE
		|		WHEN
		|			ChequeBondTransactionItemPaymentList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN ChequeBondTransactionItemPaymentList.PartnerApBasisDocument
		|		ELSE UNDEFINED
		|	END AS PartnerApBasisDocument,
		|	ChequeBondTransactionItemPaymentList.Ref.Partner AS Partner,
		|	ChequeBondTransactionItemPaymentList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND
		|			ChequeBondTransactionItemPaymentList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN ChequeBondTransactionItemPaymentList.Ref.Agreement.StandardAgreement
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Agreement
		|	END AS Agreement,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN VALUE(Catalog.Currencies.EmptyRef)
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Cheque.Currency
		|	END AS Currency,
		|	SUM(ChequeBondTransactionItemPaymentList.Amount) AS Amount,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN FALSE
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque)
		|	END AS OutgoingCheque,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN FALSE
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque)
		|	END AS IncomingCheque
		|FROM
		|	Document.ChequeBondTransactionItem.PaymentList AS ChequeBondTransactionItemPaymentList
		|WHERE
		|	ChequeBondTransactionItemPaymentList.Ref = &Ref
		|GROUP BY
		|	ChequeBondTransactionItemPaymentList.Ref.Company,
		|	CASE
		|		WHEN
		|			ChequeBondTransactionItemPaymentList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN ChequeBondTransactionItemPaymentList.PartnerArBasisDocument
		|		ELSE UNDEFINED
		|	END,
		|	CASE
		|		WHEN
		|			ChequeBondTransactionItemPaymentList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN ChequeBondTransactionItemPaymentList.PartnerApBasisDocument
		|		ELSE UNDEFINED
		|	END,
		|	ChequeBondTransactionItemPaymentList.Ref.Partner,
		|	ChequeBondTransactionItemPaymentList.Ref.LegalName,
		|	ChequeBondTransactionItemPaymentList.Ref.Cheque.Currency,
		|	ChequeBondTransactionItemPaymentList.Ref.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque),
		|	ChequeBondTransactionItemPaymentList.Ref.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque),
		|	ChequeBondTransactionItemPaymentList.Ref.Date,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND
		|			ChequeBondTransactionItemPaymentList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN ChequeBondTransactionItemPaymentList.Ref.Agreement.StandardAgreement
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Agreement
		|	END,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN VALUE(Catalog.Currencies.EmptyRef)
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Cheque.Currency
		|	END,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN FALSE
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Cheque.Type = VALUE(Enum.ChequeBondTypes.OwnCheque)
		|	END,
		|	CASE
		|		WHEN ChequeBondTransactionItemPaymentList.Ref.Cheque = VALUE(Catalog.ChequeBonds.EmptyRef)
		|			THEN FALSE
		|		ELSE ChequeBondTransactionItemPaymentList.Ref.Cheque.Type = VALUE(Enum.ChequeBondTypes.PartnerCheque)
		|	END";
	
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable_PaymentList = QueryResult.Unload();
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.ReceiptDocument AS ReceiptDocument,
		|	QueryTable.PaymentDocument AS PaymentDocument,
		|	QueryTable.Cheque AS Cheque,
		|	QueryTable.Period AS Period,
		|	QueryTable.DueDate AS DueDate,
		|	QueryTable.Company AS Company,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Account AS Account,
		|	QueryTable.Amount AS Amount,
		|	QueryTable.IncomingCheque AS IncomingCheque,
		|	QueryTable.OutgoingCheque AS OutgoingCheque,
		|	QueryTable.IsAdvance AS IsAdvance,
		|	QueryTable.Agreement AS Agreement
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	QueryTable_PaymentList.Company,
		|	QueryTable_PaymentList.Period AS Period,
		|	QueryTable_PaymentList.PartnerArBasisDocument,
		|	QueryTable_PaymentList.PartnerApBasisDocument,
		|	QueryTable_PaymentList.Partner,
		|	QueryTable_PaymentList.LegalName,
		|	QueryTable_PaymentList.Agreement,
		|	QueryTable_PaymentList.Currency,
		|	QueryTable_PaymentList.Amount,
		|	QueryTable_PaymentList.IncomingCheque AS IncomingCheque,
		|	QueryTable_PaymentList.OutgoingCheque AS OutgoingCheque
		|INTO tmp_paymentlist
		|FROM
		|	&QueryTable_PaymentList AS QueryTable_PaymentList
		|;
		|
		|//[2] AdvanceFromCustomers_IncomingCheque //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.ReceiptDocument,
		|	tmp.Period AS Period,
		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) AS Amount
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
		|		ON TRUE
		|WHERE
		|	tmp.IncomingCheque AND tmp.IsAdvance
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.ReceiptDocument,
		|	tmp.Period
		|HAVING
		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) <> 0
		|;
		|//////////////////////////////////////////////////
		|//[3] AdvanceToSuppliers_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.PaymentDocument,
		|	tmp.Period AS Period,
		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) AS Amount
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
		|		ON TRUE
		|WHERE
		|	tmp.OutgoingCheque AND tmp.IsAdvance
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.PaymentDocument,
		|	tmp.Period
		|HAVING
		|	MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0)) <> 0
		|;
		|
		|//[4] ReconciliationStatement_IncomingCheque //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|//////////////////////////////////////////////////////
		|//[5] ReconciliationStatement_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period	
		|;
		|
		|//[6] AccountBalance_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//////////////////////////////////////////////////////
		|//[7] AccountBalance_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|//[8] PartnerArTransactions_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp_paymentlist.PartnerArBasisDocument AS BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END AS Amount
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp_paymentlist.PartnerArBasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.IsAdvance
		|HAVING CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END <> 0
		|;
		|/////////////////////////////////////////////////////////////////////////////////////////
		|//[9] PartnerApTransactions_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp_paymentlist.PartnerApBasisDocument AS BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END AS Amount
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp_paymentlist.PartnerApBasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.IsAdvance
		|HAVING CASE WHEN NOT tmp.IsAdvance THEN SUM(tmp.Amount) ELSE SUM(tmp_paymentlist.Amount) END <> 0
		|;	
		|
		|//[10] AdvanceFromCustomers_Correction_IncomingCheque //////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.ReceiptDocument,
		|	tmp.Period AS Period,
		|	-(MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0))) AS Amount
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
		|		ON TRUE
		|WHERE
		|	tmp.IncomingCheque AND tmp.IsAdvance
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.ReceiptDocument,
		|	tmp.Period
		|;
		|//////////////////////////////////////////////////////////////////////////
		|//[11] AdvanceToSuppliers_Correction_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.PaymentDocument,
		|	tmp.Period AS Period,
		|	-(MAX(tmp.Amount) - SUM(ISNULL(tmp_paymentlist.Amount, 0))) AS Amount
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN tmp_paymentlist AS tmp_paymentlist
		|		ON TRUE
		|WHERE
		|	tmp.OutgoingCheque AND tmp.IsAdvance
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.PaymentDocument,
		|	tmp.Period
		|;	
		|
		|
		|//[12] ReconciliationStatement_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	-SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|//[13] ReconciliationStatement_Correction_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	-SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|
		|//[14] AccountBalance_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	-SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|///////////////////////////////////////////////////////////////////
		|//[15] AccountBalance_Correction_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	-SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[16] PartnerArTransactions_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp_paymentlist.PartnerArBasisDocument AS BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END AS Amount
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp_paymentlist.PartnerArBasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.IsAdvance
		|HAVING CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END <> 0
		|;
		|///////////////////////////////////////////////////////////////////////////
		|//[17] PartnerApTransactions_Correction_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp_paymentlist.PartnerApBasisDocument AS BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period AS Period,
		|	CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END AS Amount
		|FROM
		|	tmp_paymentlist AS tmp_paymentlist FULL JOIN tmp AS tmp ON TRUE
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp_paymentlist.PartnerApBasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period,
		|	tmp.IsAdvance
		|HAVING CASE WHEN NOT tmp.IsAdvance THEN -SUM(tmp.Amount) ELSE -SUM(tmp_paymentlist.Amount) END <> 0
		|;
		|
		|//[18] PlaningCashTransactions_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.ReceiptDocument AS BasisDocument,
		|	tmp.DueDate AS Period,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.ReceiptDocument,
		|	tmp.DueDate,
		|	VALUE(Enum.CashFlowDirections.Incoming)
		|;
		|///////////////////////////////////////////////////////////////////////////////
		|//[19] PlaningCashTransactions_OutgoingCheque
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.PaymentDocument AS BasisDocument,
		|	tmp.DueDate AS Period,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		|	SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.PaymentDocument,
		|	tmp.DueDate,
		|	VALUE(Enum.CashFlowDirections.Outgoing)
		|;
		|
		|//[20] PlaningCashTransactions_Correction_IncomingCheque//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.ReceiptDocument AS BasisDocument,
		|	tmp.Period AS Period,
		|	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		|	-SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.ReceiptDocument,
		|	tmp.Period,
		|	VALUE(Enum.CashFlowDirections.Incoming)
		|;
		|/////////////////////////////////////////////////////////////////////
		|//[21] PlaningCashTransactions_Correction_OutgoingCheque
		|
		|SELECT
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.PaymentDocument AS BasisDocument,
		|	tmp.Period AS Period,
		|	VALUE(Enum.CashFlowDirections.Outgoing) AS CashFlowDirection,
		|	-SUM(tmp.Amount) AS Amount
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Account,
		|	tmp.Currency,
		|	tmp.PaymentDocument,
		|	tmp.Period,
		|	VALUE(Enum.CashFlowDirections.Outgoing);
		|//[22] ChequeBondBalance_Incoming
		|SELECT
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM 
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period;
		|//[23] ChequeBondBalance_Correction_Incoming
		|SELECT
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period,
		|	-SUM(tmp.Amount) AS Amount
		|FROM 
		|	tmp AS tmp
		|WHERE
		|	tmp.IncomingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period;
		|//[24] ChequeBondBalance_Outgoing
		|SELECT
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period,
		|	SUM(tmp.Amount) AS Amount
		|FROM 
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period;
		|//[25] ChequeBondBalance_Correction_Outgoing
		|SELECT
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period,
		|	-SUM(tmp.Amount) AS Amount
		|FROM 
		|	tmp AS tmp
		|WHERE
		|	tmp.OutgoingCheque
		|GROUP BY
		|	tmp.Company,
		|	tmp.Cheque,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period;
		|";
	
	Query.SetParameter("QueryTable", QueryTable);
	Query.SetParameter("QueryTable_PaymentList", QueryTable_PaymentList);
	QueryResults = Query.ExecuteBatch();
	
	StatusInfo = New Structure("Status, Posting"
			, Ref.Status, ObjectStatusesServer.PutStatusPostingToStructure(Ref.Status));
	
	Tables.AdvanceFromCustomers_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[2].Unload(), "Advanced", "Posting");
	Tables.AdvanceToSuppliers_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[3].Unload(), "Advanced", "Posting");
	Tables.ReconciliationStatement_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[4].Unload(), "ReconciliationStatement", "Posting");
	Tables.ReconciliationStatement_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[5].Unload(), "ReconciliationStatement", "Posting");
	Tables.AccountBalance_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[6].Unload(), "AccountBalance", "Posting");
	Tables.AccountBalance_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[7].Unload(), "AccountBalance", "Posting");
	Tables.PartnerArTransactions_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[8].Unload(), "PartnerAccountTransactions", "Posting");
	Tables.PartnerApTransactions_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[9].Unload(), "PartnerAccountTransactions", "Posting");
	Tables.PlaningCashTransactions_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[18].Unload(), "PlaningCashTransactions", "Posting");
	Tables.PlaningCashTransactions_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[19].Unload(), "PlaningCashTransactions", "Posting");
	Tables.ChequeBondBalance_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[22].Unload(), "ChequeBondBalance", "Posting");
	Tables.ChequeBondBalance_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[24].Unload(), "ChequeBondBalance", "Posting");
	
	Tables.AdvanceFromCustomers_Correction_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[10].Unload(), "Advanced", "Correction");
	Tables.AdvanceToSuppliers_Correction_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[11].Unload(), "Advanced", "Correction");
	Tables.ReconciliationStatement_Correction_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[12].Unload(), "ReconciliationStatement", "Correction");
	Tables.ReconciliationStatement_Correction_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[13].Unload(), "ReconciliationStatement", "Correction");
	Tables.AccountBalance_Correction_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[14].Unload(), "AccountBalance", "Correction");
	Tables.AccountBalance_Correction_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[15].Unload(), "AccountBalance", "Correction");
	Tables.PartnerArTransactions_Correction_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[16].Unload(), "PartnerAccountTransactions", "Correction");
	Tables.PartnerApTransactions_Correction_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[17].Unload(), "PartnerAccountTransactions", "Correction");
	Tables.PlaningCashTransactions_Correction_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[20].Unload(), "PlaningCashTransactions", "Correction");
	Tables.PlaningCashTransactions_Correction_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[21].Unload(), "PlaningCashTransactions", "Correction");
	Tables.ChequeBondBalance_Correction_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[23].Unload(), "ChequeBondBalance", "Correction");
	Tables.ChequeBondBalance_Correction_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[25].Unload(), "ChequeBondBalance", "Correction");
	
	Tables.AdvanceFromCustomers_Reversal_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[2].Unload(), "Advanced", "Reversal");
	Tables.AdvanceToSuppliers_Reversal_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[3].Unload(), "Advanced", "Reversal");
	Tables.ReconciliationStatement_Reversal_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[4].Unload(), "ReconciliationStatement", "Reversal");
	Tables.ReconciliationStatement_Reversal_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[5].Unload(), "ReconciliationStatement", "Reversal");
	Tables.AccountBalance_Reversal_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[6].Unload(), "AccountBalance", "Reversal");
	Tables.AccountBalance_Reversal_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[7].Unload(), "AccountBalance", "Reversal");
	Tables.PartnerArTransactions_Reversal_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[8].Unload(), "PartnerAccountTransactions", "Reversal");
	Tables.PartnerApTransactions_Reversal_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[9].Unload(), "PartnerAccountTransactions", "Reversal");
	Tables.PlaningCashTransactions_Reversal_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[18].Unload(), "PlaningCashTransactions", "Reversal");
	Tables.PlaningCashTransactions_Reversal_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[19].Unload(), "PlaningCashTransactions", "Reversal");
	Tables.ChequeBondBalance_Reversal_IncomingCheque = 
	NeedPosting(StatusInfo, QueryResults[22].Unload(), "ChequeBondBalance", "Reversal");
	Tables.ChequeBondBalance_Reversal_OutgoingCheque = 
	NeedPosting(StatusInfo, QueryResults[24].Unload(), "ChequeBondBalance", "Reversal");
	
	// AdvanceFromCustomers
	// AdvanceFromCustomers_IncomingCheque [Receipt]  
	// AdvanceFromCustomers_Correction_IncomingCheque [Receipt]
	// AdvanceFromCustomers_Reversal_IncomingCheque [Expense]
	ArrayOfTables = New Array();
	Table1 = Tables.AdvanceFromCustomers_IncomingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.AdvanceFromCustomers_Correction_IncomingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.AdvanceFromCustomers_Reversal_IncomingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	Tables.AdvanceFromCustomers = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Partner, LegalName, Currency, ReceiptDocument, Amount");
	
	// AdvanceToSuppliers
	// AdvanceToSuppliers_OutgoingCheque [Receipt]  
	// AdvanceToSuppliers_Correction_OutgoingCheque [Receipt]
	// AdvanceToSuppliers_Reversal_OutgoingCheque [Expense]
	ArrayOfTables = New Array();
	Table1 = Tables.AdvanceToSuppliers_OutgoingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.AdvanceToSuppliers_Correction_OutgoingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.AdvanceToSuppliers_Reversal_OutgoingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	Tables.AdvanceToSuppliers = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Partner, LegalName, Currency, PaymentDocument, Amount");
	
	// ReconciliationStatement
	// ReconciliationStatement_IncomingCheque [Expense]  
	// ReconciliationStatement_Correction_IncomingCheque [Expense]
	// ReconciliationStatement_OutgoingCheque [Receipt]  
	// ReconciliationStatement_Correction_OutgoingCheque [Receipt]
	// ReconciliationStatement_Reversal_IncomingCheque [Receipt]
	// ReconciliationStatement_Reversal_OutgoingCheque [Expense]
	ArrayOfTables = New Array();
	Table1 = Tables.ReconciliationStatement_IncomingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.ReconciliationStatement_Correction_IncomingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.ReconciliationStatement_OutgoingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Tables.ReconciliationStatement_Correction_OutgoingCheque.Copy();
	Table4.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table4.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table4);
	
	Table5 = Tables.ReconciliationStatement_Reversal_IncomingCheque.Copy();
	Table5.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table5.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table5);
	
	Table6 = Tables.ReconciliationStatement_Reversal_OutgoingCheque.Copy();
	Table6.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table6.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table6);
	
	Tables.ReconciliationStatement = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, LegalName, Currency, Amount");
	
	// AccountBalance
	// AccountBalance_IncomingCheque [Receipt]  
	// AccountBalance_Correction_IncomingCheque [Receipt]
	// AccountBalance_OutgoingCheque [Expense]  
	// AccountBalance_Correction_OutgoingCheque [Expense]
	// AccountBalance_Reversal_IncomingCheque [Expense]
	// AccountBalance_Reversal_OutgoingCheque [Receipt]
	ArrayOfTables = New Array();
	Table1 = Tables.AccountBalance_IncomingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.AccountBalance_Correction_IncomingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.AccountBalance_OutgoingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Tables.AccountBalance_Correction_OutgoingCheque.Copy();
	Table4.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table4);
	
	Table5 = Tables.AccountBalance_Reversal_IncomingCheque.Copy();
	Table5.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table5.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table5);
	
	Table6 = Tables.AccountBalance_Reversal_OutgoingCheque.Copy();
	Table6.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table6.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table6);
	
	Tables.AccountBalance = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Account, Currency, Amount");
	
	// PartnerArTransactions
	// PartnerArTransactions_IncomingCheque [Expense]  
	// PartnerArTransactions_Correction_IncomingCheque [Expense]
	// PartnerArTransactions_Reversal_IncomingCheque [Receipt]
	ArrayOfTables = New Array();
	Table1 = Tables.PartnerArTransactions_IncomingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.PartnerArTransactions_Correction_IncomingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.PartnerArTransactions_Reversal_IncomingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table3);
	Tables.PartnerArTransactions = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, BasisDocument, Partner, LegalName, Agreement, Currency, Amount");
	
	// PartnerApTransactions
	// PartnerApTransactions_OutgoingCheque [Expense]  
	// PartnerApTransactions_Correction_OutgoingCheque [Expense]
	// PartnerApTransactions_Reversal_OutgoingCheque [Receipt]
	ArrayOfTables = New Array();
	Table1 = Tables.PartnerApTransactions_OutgoingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.PartnerApTransactions_Correction_OutgoingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.PartnerApTransactions_Reversal_OutgoingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table3);
	Tables.PartnerApTransactions = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, BasisDocument, Partner, LegalName, Agreement, Currency, Amount");
	
	// PlaningCashTransactions
	// PlaningCashTransactions_IncomingCheque [Turnovers]  
	// PlaningCashTransactions_Correction_IncomingCheque [Turnovers]
	// PlaningCashTransactions_OutgoingCheque [Turnovers]  
	// PlaningCashTransactions_Correction_OutgoingCheque [Turnovers]
	ArrayOfTables = New Array();
	ArrayOfTables.Add(Tables.PlaningCashTransactions_IncomingCheque);
	ArrayOfTables.Add(Tables.PlaningCashTransactions_Correction_IncomingCheque);
	ArrayOfTables.Add(Tables.PlaningCashTransactions_OutgoingCheque);
	ArrayOfTables.Add(Tables.PlaningCashTransactions_Correction_OutgoingCheque);
	ArrayOfTables.Add(Tables.PlaningCashTransactions_Reversal_IncomingCheque);
	ArrayOfTables.Add(Tables.PlaningCashTransactions_Reversal_OutgoingCheque);
	Tables.PlaningCashTransactions = 
	PostingServer.JoinTables(ArrayOfTables, "Period, Company, BasisDocument, Account, Currency, CashFlowDirection, Partner, LegalName, Amount");
	
	// ChequeBondBalance
	// ChequeBondBalance_IncomingCheque [Receipt]  
	// ChequeBondBalance_Correction_IncomingCheque [Receipt]
	// ChequeBondBalance_OutgoingCheque [Receipt]  
	// ChequeBondBalance_Correction_OutgoingCheque [Receipt]
	// ChequeBondBalance_Reversal_IncomingCheque [Expense]
	// ChequeBondBalance_Reversal_OutgoingCheque [Expense]
	ArrayOfTables = New Array();
	Table1 = Tables.ChequeBondBalance_IncomingCheque.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Tables.ChequeBondBalance_Correction_IncomingCheque.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Tables.ChequeBondBalance_OutgoingCheque.Copy();
	Table3.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table3.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table3);
	
	Table4 = Tables.ChequeBondBalance_Correction_OutgoingCheque.Copy();
	Table4.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table4.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table4);
	
	Table5 = Tables.ChequeBondBalance_Reversal_IncomingCheque.Copy();
	Table5.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table5.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table5);
	
	Table6 = Tables.ChequeBondBalance_Reversal_OutgoingCheque.Copy();
	Table6.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table6.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table6);
	
	Tables.ChequeBondBalance = 
	PostingServer.JoinTables(ArrayOfTables, "RecordType, Period, Company, Cheque, Partner, LegalName, Currency, Amount");
	
	Return Tables;
EndFunction

Function NeedPosting(StatusInfo, PostingTable, SettingName, PostingType)
	If PostingType = "Posting" Then
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Posting, PostingTable, New ValueTable());
	ElsIf PostingType = "Reversal" Then
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Reversal, PostingTable, New ValueTable());
	ElsIf PostingType = "Correction" Then
		Return ?(StatusInfo.Posting[SettingName] = Enums.DocumentPostingTypes.Correction, PostingTable, New ValueTable());
	EndIf;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// AdvanceFromCustomers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceFromCustomers",
		New Structure("Fields, Data", Fields, DocumentDataTables.AdvanceFromCustomers));
	
	// AdvanceToSuppliers
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AdvanceToSuppliers",
		New Structure("Fields, Data", Fields, DocumentDataTables.AdvanceToSuppliers));
	
	// ReconciliationStatement
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.ReconciliationStatement",
		New Structure("Fields, Data", Fields, DocumentDataTables.ReconciliationStatement));
	
	// AccountBalance
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Account", "Account");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.AccountBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.AccountBalance));
	
	// PartnerArTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerArTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerArTransactions));
	
	// PartnerApTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("Agreement", "Agreement");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.PartnerApTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PartnerApTransactions));
	
	// PlaningCashTransactions
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("BasisDocument", "BasisDocument");
	Fields.Insert("Account", "Account");
	Fields.Insert("Currency", "Currency");
	Fields.Insert("CashFlowDirection", "CashFlowDirection");
	DataMapWithLockFields.Insert("AccumulationRegister.PlaningCashTransactions",
		New Structure("Fields, Data", Fields, DocumentDataTables.PlaningCashTransactions));
	
	// ChequeBondBalance
	Fields = New Map();
	Fields.Insert("Company", "Company");
	Fields.Insert("Cheque", "Cheque");
	Fields.Insert("Partner", "Partner");
	Fields.Insert("LegalName", "LegalName");
	Fields.Insert("Currency", "Currency");
	DataMapWithLockFields.Insert("AccumulationRegister.ChequeBondBalance",
		New Structure("Fields, Data", Fields, DocumentDataTables.ChequeBondBalance));
	
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
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
		Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table1);
	EndIf;

	If Parameters.DocumentDataTables.AdvanceToSuppliers.Count() Then
		Table2 = Parameters.DocumentDataTables.AdvanceToSuppliers.CopyColumns();
		Table2.Columns.Amount.Name = "AdvanceToSupliers";
		PostingServer.AddColumnsToAccountsStatementTable(Table2);
		For Each Row In Parameters.DocumentDataTables.AdvanceToSuppliers Do
			If Row.Partner.Vendor Then
				NewRow = Table2.Add();
				FillPropertyValues(NewRow, Row);
				If Row.RecordType = AccumulationRecordType.Receipt Then
					NewRow.AdvanceToSupliers = Row.Amount;
				Else
					NewRow.AdvanceToSupliers = - Row.Amount;
				EndIf;
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

	If Parameters.DocumentDataTables.AdvanceToSuppliers.Count() Then
		Table4 = Parameters.DocumentDataTables.AdvanceToSuppliers.CopyColumns();
		Table4.Columns.Amount.Name = "AdvanceFromCustomers";
		PostingServer.AddColumnsToAccountsStatementTable(Table4);
		For Each Row In Parameters.DocumentDataTables.AdvanceToSuppliers Do
			If Row.Partner.Customer Then
				NewRow = Table4.Add();
				FillPropertyValues(NewRow, Row);
				If Row.RecordType = AccumulationRecordType.Receipt Then
					NewRow.AdvanceFromCustomers = -Row.Amount;
				Else
					NewRow.AdvanceFromCustomers = Row.Amount;
				EndIf;
			EndIf;
		EndDo;
		Table4.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table4);
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
		Table6 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
		Table6.Columns.Amount.Name = "AdvanceToSupliers";
		PostingServer.AddColumnsToAccountsStatementTable(Table6);
		For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
			If Row.Partner.Vendor Then
				NewRow = Table6.Add();
				FillPropertyValues(NewRow, Row);
				If Row.RecordType = AccumulationRecordType.Receipt Then
					NewRow.AdvanceToSupliers = -Row.Amount;
				Else
					NewRow.AdvanceToSupliers = Row.Amount;
				EndIf;
			EndIf;
		EndDo;
		Table6.FillValues(AccumulationRecordType.Receipt, "RecordType");
		ArrayOfTables.Add(Table6);
	EndIf;

	If Parameters.DocumentDataTables.AdvanceFromCustomers.Count() Then
		Table7 = Parameters.DocumentDataTables.AdvanceFromCustomers.CopyColumns();
		Table7.Columns.Amount.Name = "AdvanceFromCustomers";
		PostingServer.AddColumnsToAccountsStatementTable(Table7);
		For Each Row In Parameters.DocumentDataTables.AdvanceFromCustomers Do
			If Row.Partner.Customer Then
				NewRow = Table7.Add();
				FillPropertyValues(NewRow, Row);
				If Row.RecordType = AccumulationRecordType.Receipt Then
					NewRow.AdvanceFromCustomers = Row.Amount;
				Else
					NewRow.AdvanceFromCustomers = - Row.Amount;
				EndIf;
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
		Table8.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table8);
	EndIf;
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAP, AdvanceToSupliers,
				|TransactionAR, AdvanceFromCustomers"),
			Parameters.IsReposting));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.AdvanceFromCustomers,
			Parameters.IsReposting));
	
	// AdvanceToSuppliers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceToSuppliers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.AdvanceToSuppliers,
			Parameters.IsReposting));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.ReconciliationStatement,
			Parameters.IsReposting));
	
	// AccountBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountBalance,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.AccountBalance,
			Parameters.IsReposting));
	
	// PartnerArTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.PartnerArTransactions,
			Parameters.IsReposting));
	
	// PartnerApTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerApTransactions,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.PartnerApTransactions,
			Parameters.IsReposting));
	
	// PlaningCashTransactions
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PlaningCashTransactions,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.PlaningCashTransactions,
			Parameters.IsReposting));
	
	// ChequeBondBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ChequeBondBalance,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.ChequeBondBalance,
			Parameters.IsReposting));
	
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

Function PostDocuments(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
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

Function UnpostDocuments(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
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

Function SetDeletionMarkForDocuments(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
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

Function UnsetDeletionMerkForDocuments(DataLock, ArrayOfCheque, ChequeBondTransactionRef) Export
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
	DataSource.Columns.Add("Cheque", New TypeDescription("CatalogRef.ChequeBonds"));
	DataSource.Columns.Add("ChequeBondTransaction", New TypeDescription("DocumentRef.ChequeBondTransaction"));
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
	ChequeInfo.Insert("PaymentList", New Array());
	ChequeInfo.Insert("Currencies", New Array());
	ChequeInfo.Insert("Date", Undefined);
	ChequeInfo.Insert("Status", Undefined);
	ChequeInfo.Insert("Company", Undefined);
	ChequeInfo.Insert("LegalName", Undefined);
	ChequeInfo.Insert("Account", Undefined);
	ChequeInfo.Insert("Cheque", Undefined);
	ChequeInfo.Insert("ChequeBondTransaction", Undefined);
	ChequeInfo.Insert("Agreement", Undefined);
	ChequeInfo.Insert("Partner", Undefined);
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionChequeBonds.Ref.Date,
		|	ChequeBondTransactionChequeBonds.NewStatus AS Status,
		|	ChequeBondTransactionChequeBonds.Ref.Company,
		|	ChequeBondTransactionChequeBonds.LegalName,
		|	ChequeBondTransactionChequeBonds.CashAccount AS Account,
		|	ChequeBondTransactionChequeBonds.Cheque,
		|	ChequeBondTransactionChequeBonds.Ref AS ChequeBondTransaction,
		|	ChequeBondTransactionChequeBonds.Key,
		|	ChequeBondTransactionChequeBonds.Agreement AS Agreement,
		|	ChequeBondTransactionChequeBonds.Partner AS Partner
		|FROM
		|	Document.ChequeBondTransaction.ChequeBonds AS ChequeBondTransactionChequeBonds
		|WHERE
		|	ChequeBondTransactionChequeBonds.Ref = &ChequeBondTransactionRef
		|	AND ChequeBondTransactionChequeBonds.Cheque = &ChequeRef";
	Query.SetParameter("ChequeRef", ChequeRef);
	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	If Not QuerySelection.Next() Then
		Return ChequeInfo;
	EndIf;
	
	MainRowKey = QuerySelection.Key;
	
	FillPropertyValues(ChequeInfo, QuerySelection);
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionPaymentList.PartnerArBasisDocument,
		|	ChequeBondTransactionPaymentList.PartnerApBasisDocument,
		|	ChequeBondTransactionPaymentList.Amount
		|FROM
		|	Document.ChequeBondTransaction.PaymentList AS ChequeBondTransactionPaymentList
		|WHERE
		|	ChequeBondTransactionPaymentList.Ref = &ChequeBondTransactionRef
		|	AND ChequeBondTransactionPaymentList.Key = &Key";
	Query.SetParameter("Key", MainRowKey);
	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		PaymentListRow = New Structure();
		PaymentListRow.Insert("PartnerArBasisDocument", QuerySelection.PartnerArBasisDocument);
		PaymentListRow.Insert("PartnerApBasisDocument", QuerySelection.PartnerApBasisDocument);
		PaymentListRow.Insert("Amount", QuerySelection.Amount);
		ChequeInfo.PaymentList.Add(PaymentListRow);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	ChequeBondTransactionCurrencies.CurrencyFrom,
		|	ChequeBondTransactionCurrencies.Rate,
		|	ChequeBondTransactionCurrencies.ReverseRate,
		|	ChequeBondTransactionCurrencies.ShowReverseRate,
		|	ChequeBondTransactionCurrencies.Multiplicity,
		|	ChequeBondTransactionCurrencies.MovementType,
		|	ChequeBondTransactionCurrencies.Amount,
		|	ChequeBondTransactionCurrencies.Key
		|FROM
		|	Document.ChequeBondTransaction.Currencies AS ChequeBondTransactionCurrencies
		|WHERE
		|	ChequeBondTransactionCurrencies.Ref = &ChequeBondTransactionRef
		|	AND ChequeBondTransactionCurrencies.Key = &Key";
	
	Query.SetParameter("Key", MainRowKey);
	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		CurrenciesRow = New Structure();
		CurrenciesRow.Insert("CurrencyFrom", QuerySelection.CurrencyFrom);
		CurrenciesRow.Insert("Rate", QuerySelection.Rate);
		CurrenciesRow.Insert("ReverseRate", QuerySelection.ReverseRate);
		CurrenciesRow.Insert("ShowReverseRate", QuerySelection.ShowReverseRate);
		CurrenciesRow.Insert("Multiplicity", QuerySelection.Multiplicity);
		CurrenciesRow.Insert("MovementType", QuerySelection.MovementType);
		CurrenciesRow.Insert("Amount", QuerySelection.Amount);
		CurrenciesRow.Insert("Key", QuerySelection.Key);
		ChequeInfo.Currencies.Add(CurrenciesRow);
	EndDo;
	
	Return ChequeInfo;
EndFunction

Procedure FillDocument(DocumentObject, ChequeInfo)
	DocumentObject.Date = ChequeInfo.Date;
	DocumentObject.Status = ChequeInfo.Status;
	DocumentObject.Company = ChequeInfo.Company;
	DocumentObject.LegalName = ChequeInfo.LegalName;
	DocumentObject.Account = ChequeInfo.Account;
	DocumentObject.Cheque = ChequeInfo.Cheque;
	DocumentObject.ChequeBondTransaction = ChequeInfo.ChequeBondTransaction;
	DocumentObject.Agreement = ChequeInfo.Agreement;
	DocumentObject.Partner = ChequeInfo.Partner;
	DocumentObject.PaymentList.Clear();
	For Each Row In ChequeInfo.PaymentList Do
		FillPropertyValues(DocumentObject.PaymentList.Add(), Row);
	EndDo;
	
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

Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Cheque");
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.Cheque);
EndProcedure

