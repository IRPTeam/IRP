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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)

	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);

EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		FillingData = New Structure();
		FillingData.Insert("TransactionType", Enums.PurchaseTransactionTypes.Purchase);
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
	ElsIf TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		If FillingData.BasedOn = "PurchaseOrder" Then 
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData);
	
	// ItemList
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
	EndDo;
	
	// SpecialOffers
	For Each Row In FillingData.SpecialOffers Do
		NewRow = ThisObject.SpecialOffers.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
	EndDo;
	
	// TaxList
	For Each Row In FillingData.TaxList Do
		NewRow = ThisObject.TaxList.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
	EndDo;
	
	ThisObject.DocumentAmount = CalculationServer.CalculateDocumentAmount(ThisObject.ItemList);
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