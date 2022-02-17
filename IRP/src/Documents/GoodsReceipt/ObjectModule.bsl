Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	If TransactionType = Enums.GoodsReceiptTransactionTypes.InventoryTransfer Then
		Partner = Undefined;
		LegalName = Undefined;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)

	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);

EndProcedure

Procedure UndoPosting(Cancel)

	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);

EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		PropertiesHeader = RowIDInfoServer.GetSeperatorColumns(ThisObject.Metadata());
		FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.ReceiptBasis AS ReceiptBasis
	|into tmp
	|FROM
	|	&ItemList AS tmp
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.ReceiptBasis.Currency AS Currency,
	|	SUM(1) AS CountCurrencies
	|FROM
	|	tmp AS tmp
	|WHERE
	|	NOT tmp.ReceiptBasis.Date IS NULL
	|GROUP BY
	|	tmp.ReceiptBasis.Currency";
	Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() > 1 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().S_022);
		Cancel = True;
	EndIf;
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_GR(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(,"Key, LineNumber, ItemKey, Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
	
EndProcedure
