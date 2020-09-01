
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	

	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");	
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
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

	For Each Row In ThisObject.ItemList Do
		If Not SerialLotNumbersServer.IsItemKeyWithSerialLotNumbers(Row.ItemKey) Then
			Continue;
		EndIf;

		ArrayOfSerialLotNumbers = ThisObject.SerialLotNumbers.FindRows(New Structure("Key", Row.Key));
		If Not ArrayOfSerialLotNumbers.Count() Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().Error_010, "Serial lot number"), "ItemList[" + Format((Row.LineNumber - 1),
				"NZ=0; NG=0;") + "].SerialLotNumbersPresentation", ThisObject);
		Else
			QuantityBySerialLotNumber = 0;
			For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
				QuantityBySerialLotNumber = QuantityBySerialLotNumber + RowSerialLotNumber.Quantity;
			EndDo;
			If Row.Quantity <> QuantityBySerialLotNumber Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(
					StrTemplate(R().Error_078, Row.Quantity, QuantityBySerialLotNumber), "ItemList[" + Format(
					(Row.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", ThisObject);

			EndIf;
		EndIf;
	EndDo;
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
