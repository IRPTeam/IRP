
Procedure TableOnStartEdit(Object, Form, DataPath, Item, NewRow, Clone) Export
	CurrentData = Item.CurrentData;

	If CurrentData = Undefined Then
		Return;
	EndIf;

	If Not NewRow Then
		Return;
	ElsIf Clone Then
		Return;
	EndIf;

	UserSettingsClientServer.FillingRowFromSettings(Object, DataPath, CurrentData, True);

	StructureStore = New Structure("CurrentStore", Undefined);
	FillPropertyValues(StructureStore, Form);

	If Not StructureStore.CurrentStore = Undefined And ValueIsFilled(Form.CurrentStore) Then
		CurrentData.Store = Form.CurrentStore;
		If ValueIsFilled(CurrentData.Store) And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "UseShipmentConfirmation") Then
			StoreInfo = DocumentsServer.GetStoreInfo(CurrentData.Store, CurrentData.ItemKey);
			If Not StoreInfo.IsService Then
				CurrentData.UseShipmentConfirmation = StoreInfo.UseShipmentConfirmation;
			EndIf;
		EndIf;
		If ValueIsFilled(CurrentData.Store) And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "UseGoodsReceipt") Then
			StoreInfo = DocumentsServer.GetStoreInfo(CurrentData.Store, CurrentData.ItemKey);
			If Not StoreInfo.IsService Then
				CurrentData.UseGoodsReceipt = StoreInfo.UseGoodsReceipt;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

