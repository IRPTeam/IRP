Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingClientServer.UpdateAccountingTables(ThisObject, "ItemList");
	EndIf;

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
	If FillingData = Undefined Then
		FillingData = New Structure();
		FillingData.Insert("TransactionType", Enums.PurchaseTransactionTypes.Purchase);
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
	ElsIf TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		If FillingData.BasedOn = "SalesReportFromTradeAgent" Then
			ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
			Filling_BasedOn(FillingData);
		Else
			PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
			FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
			LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
			ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData);
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
	EndDo;
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

		ArrayOfRows = ThisObject.GoodsReceipts.FindRows(New Structure("Key", ItemKeyRow.Key));
		If Not ArrayOfRows.Count() Then
			Continue;
		EndIf;
		TotalQuantity_GoodsReceipt = 0;
		For Each ItemOfArray In ArrayOfRows Do
			If ItemOfArray.Quantity > ItemOfArray.QuantityInGoodsReceipt Then
				Cancel = True;
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_080, ItemKeyRow.LineNumber,
					ItemOfArray.GoodsReceipt, ItemOfArray.Quantity, ItemOfArray.QuantityInGoodsReceipt), "ItemList["
					+ Format((ItemKeyRow.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", ThisObject);
			EndIf;
			TotalQuantity_GoodsReceipt = TotalQuantity_GoodsReceipt + ItemOfArray.Quantity;
		EndDo;

		If TotalQuantity_GoodsReceipt < ItemKeyRow.Quantity Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_081, ItemKeyRow.LineNumber,
				ItemKeyRow.Item, ItemKeyRow.ItemKey, ItemKeyRow.Quantity, TotalQuantity_GoodsReceipt), "ItemList["
				+ Format((ItemKeyRow.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", ThisObject);
		EndIf;

		If TotalQuantity_GoodsReceipt > ItemKeyRow.Quantity Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_082, ItemKeyRow.LineNumber,
				ItemKeyRow.Item, ItemKeyRow.ItemKey, ItemKeyRow.Quantity, TotalQuantity_GoodsReceipt), "ItemList["
				+ Format((ItemKeyRow.LineNumber - 1), "NZ=0; NG=0;") + "].Quantity", ThisObject);

		EndIf;
	EndDo;
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_PI(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(, "Key, LineNumber, ItemKey, Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
	
	If ValueIsFilled(ThisObject.Company) Then
		Query = New Query;
		Query.Text =
		"SELECT
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS Key,
		|	CAST(ItemList.Store AS Catalog.Stores) AS Store
		|into ttItemList
		|FROM
		|	&ItemList AS ItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	RowIDInfo.Key AS Key,
		|	RowIDInfo.Basis AS Basis
		|into ttRowIDInfo
		|FROM
		|	&RowIDInfo AS RowIDInfo
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Store AS Store,
		|	ItemList.Store.Company AS StoreCompany,
		|	RowIDInfo.Basis AS Basis
		|FROM
		|	ttItemList AS ItemList
		|		LEFT JOIN ttRowIDInfo AS RowIDInfo
		|		ON ItemList.Key = RowIDInfo.Key
		|
		|ORDER BY
		|	LineNumber";
		Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
		Query.SetParameter("RowIDInfo", ThisObject.RowIDInfo.Unload());
		QuerySelection = Query.Execute().Select();
		While QuerySelection.Next() Do
			If ValueIsFilled(QuerySelection.Basis) Then
				Continue;
			ElsIf ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company_Row,
					QuerySelection.Store,
					ThisObject.Company, 
					QuerySelection.LineNumber);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.ItemList[" + (QuerySelection.LineNumber - 1) + "].Store", 
					"Object.ItemList");
			EndIf;
		EndDo;
	EndIf;
EndProcedure
