Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
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
		FillingPropertiesHeader = RowIDInfoServer.GetSeperatorColumns(ThisObject.Metadata());
		FillPropertyValues(ThisObject, FillingData, FillingPropertiesHeader);
		FillingPropertiesTables = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		//====================================
		ArrayOfPropertiesHeader = New Array();
		For Each PropertyName In StrSplit(FillingPropertiesHeader, ",") Do
			PropertyName = TrimAll(PropertyName);
			If CommonFunctionsClientServer.ObjectHasProperty(ThisObject, PropertyName)
				And ValueIsFilled(ThisObject[PropertyName])
				And ArrayOfPropertiesHeader.Find(PropertyName) = Undefined Then
				ArrayOfPropertiesHeader.Add(PropertyName);
			EndIf;
		EndDo;
		//====================================
		ThisObject.AdditionalProperties.Insert("ReadOnlyProperties", 
			StrConcat(ArrayOfPropertiesHeader, ",") + ", " + FillingPropertiesTables);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;

	For Each Row In ThisObject.ItemList Do
		ItemKeyRow = New Structure();
		ItemKeyRow.Insert("LineNumber", Row.LineNumber);
		ItemKeyRow.Insert("Key", Row.Key);
		ItemKeyRow.Insert("Item", Row.ItemKey.Item);
		ItemKeyRow.Insert("ItemKey", Row.ItemKey);
		ItemKeyRow.Insert("QuantityUnit", Row.Unit);
		ItemKeyRow.Insert("Unit", ?(ValueIsFilled(Row.ItemKey.Unit), Row.ItemKey.Unit, Row.ItemKey.Item.Unit));
		ItemKeyRow.Insert("Quantity", Row.Quantity);

		DocumentsServer.RecalculateQuantityInRow(ItemKeyRow);

		ArrayOfRows = ThisObject.ShipmentConfirmations.FindRows(New Structure("Key", ItemKeyRow.Key));
		If Not ArrayOfRows.Count() Then
			Continue;
		EndIf;
		TotalQuantity_ShipmentConfirmations = 0;
		For Each ItemOfArray In ArrayOfRows Do
			If ItemOfArray.Quantity > ItemOfArray.QuantityInShipmentConfirmation Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_080, ItemKeyRow.LineNumber,
					ItemOfArray.ShipmentConfirmation, ItemOfArray.Quantity,
					ItemOfArray.QuantityInShipmentConfirmation), "ItemList[" + Format((ItemKeyRow.LineNumber - 1),
					"NZ=0; NG=0;") + "].Quantity", ThisObject);
			EndIf;
			TotalQuantity_ShipmentConfirmations = TotalQuantity_ShipmentConfirmations + ItemOfArray.Quantity;
		EndDo;

		If TotalQuantity_ShipmentConfirmations < ItemKeyRow.Quantity Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_081, ItemKeyRow.LineNumber,
				ItemKeyRow.Item, ItemKeyRow.ItemKey, ItemKeyRow.Quantity, TotalQuantity_ShipmentConfirmations),
				"ItemList[" + Format((ItemKeyRow.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", ThisObject);
		EndIf;

		If TotalQuantity_ShipmentConfirmations > ItemKeyRow.Quantity Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_082, ItemKeyRow.LineNumber,
				ItemKeyRow.Item, ItemKeyRow.ItemKey, ItemKeyRow.Quantity, TotalQuantity_ShipmentConfirmations),
				"ItemList[" + Format((ItemKeyRow.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", ThisObject);

		EndIf;
	EndDo;
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_SI(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(,"Key, LineNumber, ItemKey, Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
EndProcedure
