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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	ClosingOrder = DocSalesOrderServer.GetLastSalesOrderClosingBySalesOrder(Ref);
	If Not IsNew() AND Not ClosingOrder.IsEmpty() Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_022, ClosingOrder));
	EndIf;
	
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel And IsNew() Then
		For Each Row In ThisObject.ItemList Do
			If Not ValueIsFilled(Row.ReservationDate) Then
				Row.ReservationDate = ThisObject.Date;
			EndIf;
		EndDo;
	EndIf;
		
	For RowIndex = 0 To (ThisObject.ItemList.Count() - 1) Do
		Row = ThisObject.ItemList[RowIndex];
		If Not ValueIsFilled(Row.ProcurementMethod) And Row.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Product Then
			MessageText = StrTemplate(R().Error_010, R().S_023);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.ItemList[" + RowIndex
				+ "].ProcurementMethod", "Object.ItemList");
			Cancel = True;
		EndIf;
		
		If Row.Cancel And Row.CancelReason.IsEmpty() Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_093, "Object.ItemList[" + RowIndex
				+ "].CancelReason", "Object.ItemList");
			Cancel = True;
		EndIf;
		
		If ValueIsFilled(Row.ProcurementMethod) 
			And Row.ProcurementMethod = Enums.ProcurementMethods.Stock 
			And Not ValueIsFilled(Row.ReservationDate) Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_096, "Object.ItemList[" + RowIndex
				+ "].ReservationDate", "Object.ItemList");
			Cancel = True;	
		EndIf;
	EndDo;
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

	FillPropertyValues(ThisObject, FillingData);
	Number = Undefined;
	Date = Undefined;
EndProcedure
