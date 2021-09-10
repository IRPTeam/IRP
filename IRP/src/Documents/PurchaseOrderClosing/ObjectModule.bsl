Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	ThisObject.DocumentAmount = CalculationServer.CalculateDocumentAmount(ItemList);

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
	If FillingData = Undefined Then
		Return;
	EndIf;
	If FillingData.Property("PurchaseOrder") Then
		CloseOrder = True;
		PurchaseOrder = FillingData.PurchaseOrder;
		PurchaseOrderData = DocPurchaseOrderServer.GetPurchaseOrderForClosing(FillingData.PurchaseOrder);

		FillPropertyValues(ThisObject, PurchaseOrderData.PurchaseOrderInfo);

		For Each Table In PurchaseOrderData.Tables Do
			ThisObject[Table.Key].Load(Table.Value);
		EndDo;
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)

	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(TaxList);
	LinkedTables.Add(Currencies);
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);

EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	For RowIndex = 0 To (ThisObject.ItemList.Count() - 1) Do
		Row = ThisObject.ItemList[RowIndex];
		If Row.Cancel And Row.CancelReason.IsEmpty() Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_093, "Object.ItemList[" + RowIndex
				+ "].CancelReason", "Object.ItemList");
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure