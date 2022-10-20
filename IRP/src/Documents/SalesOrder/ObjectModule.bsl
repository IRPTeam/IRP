Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

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

	If Not IsNew() And Modified() Then
		ClosingOrder = DocSalesOrderClosingServer.GetLastSalesOrderClosingBySalesOrder(Ref);
		If Not ClosingOrder.IsEmpty() Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_022, ClosingOrder));
		EndIf;
	EndIf;

	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
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
	EndDo;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	// #1533
	If FillingData = Undefined Then
		FillingData = New Structure();
		FillingData.Insert("TransactionType", Enums.SalesTransactionTypes.Sales);
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
	Else	
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
		Number = Undefined;
		Date = Undefined;
	EndIf;
EndProcedure
