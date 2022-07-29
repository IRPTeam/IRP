
#Region POSTING

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
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
	Return QueryArray;
EndFunction

#Region Synchronization

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
		|	ChequeBonds.Partner AS Partner
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
	
//	Query = New Query();
//	Query.Text =
//		"SELECT
//		|	ChequeBondTransactionCurrencies.CurrencyFrom,
//		|	ChequeBondTransactionCurrencies.Rate,
//		|	ChequeBondTransactionCurrencies.ReverseRate,
//		|	ChequeBondTransactionCurrencies.ShowReverseRate,
//		|	ChequeBondTransactionCurrencies.Multiplicity,
//		|	ChequeBondTransactionCurrencies.MovementType,
//		|	ChequeBondTransactionCurrencies.Amount,
//		|	ChequeBondTransactionCurrencies.Key
//		|FROM
//		|	Document.ChequeBondTransaction.Currencies AS ChequeBondTransactionCurrencies
//		|WHERE
//		|	ChequeBondTransactionCurrencies.Ref = &ChequeBondTransactionRef
//		|	AND ChequeBondTransactionCurrencies.Key = &Key";
//	
//	Query.SetParameter("Key", MainRowKey);
//	Query.SetParameter("ChequeBondTransactionRef", ChequeBondTransactionRef);
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
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
	
	// PaymentList
	
//	DocumentObject.PaymentList.Clear();
//	For Each Row In ChequeInfo.PaymentList Do
//		FillPropertyValues(DocumentObject.PaymentList.Add(), Row);
//	EndDo;
	
	// Currencies
	
//	DocumentObject.Currencies.Clear();
//	For Each Row In ChequeInfo.Currencies Do
//		FillPropertyValues(DocumentObject.Currencies.Add(), Row);
//	EndDo;
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
