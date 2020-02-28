
#Region FormEvents

&AtClient
Procedure OnOpen(Cancel)
	RevertPhysListsVisible();
	RevertListsVisible();
EndProcedure

#EndRegion


#Region Commands

&AtClient
Procedure SearchByBarcode(Command)
	BarcodeClient.SearchByBarcode(Command, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(BarcodeItems, Parameters) Export
	AddItemToPhysItemList(BarcodeItems);
	AddItemToCollapsedPhysItemList(BarcodeItems);
	AddItemToItemList(BarcodeItems);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SwitchList(Command)
	RevertListsVisible();
EndProcedure

&AtClient
Procedure CollapseExpandPhysItemList(Command)
	RevertPhysListsVisible();
EndProcedure

#EndRegion

&AtClient
Procedure RevertListsVisible()
	ItemListVisible = Items.GroupItemList.Visible;
	Items.GroupItemList.Visible = Not ItemListVisible;
	Items.GroupExpItemList.Visible = ItemListVisible;
	Items.GroupPhysItemLists.Visible = ItemListVisible;
EndProcedure

&AtClient
Procedure RevertPhysListsVisible()
	ItemListVisible = Items.GroupPhysItemList.Visible;
	Items.GroupPhysItemList.Visible = Not ItemListVisible;
	Items.GroupCollapsedPhysItemList.Visible = ItemListVisible;
EndProcedure

#Region ItemListEvents

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	//TODO: Insert the handler content
EndProcedure

#EndRegion


#Region PhysItemListEvents

&AtClient
Procedure PhysItemListOnChange(Item)
	FillPhysItemListFields();
EndProcedure

#EndRegion


#Region CollapsedPhysItemListEvents

&AtClient
Procedure CollapsedPhysItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	RevertPhysListsVisible();
	ItemRow = Object.PhysItemList.Add();
	ItemRow.Key = New UUID(); 	
EndProcedure

#EndRegion



&AtClient
Procedure FillPhysItemListFields()
	
EndProcedure

&AtClient
Procedure AddItemToPhysItemList(ItemsData)
	DateOfAdd = CurrentDate();
	For Each DataRow In ItemsData Do
		ItemRow = Object.PhysItemList.Add();
		ItemRow.Key = New UUID();
		ItemRow.Item = DataRow.Item;
		ItemRow.ItemKey = DataRow.ItemKey;
		ItemRow.Unit = DataRow.Unit;
		ItemRow.Count = DataRow.Quantity;
		ItemRow.Barcode = DataRow.Barcode;
		ItemRow.Date = DateOfAdd;
	EndDo;
EndProcedure

&AtClient
Procedure AddItemToCollapsedPhysItemList(ItemsData)
	For Each DataRow In ItemsData Do
		RowsFilter = New Structure();
		RowsFilter.Insert("ItemKey", DataRow.ItemKey);
		RowsFilter.Insert("Unit", DataRow.Unit);
		CollapsedPhysItemListFoundedRows = Object.CollapsedPhysItemList.FindRows(RowsFilter);
		If CollapsedPhysItemListFoundedRows.Count() Then
			ItemRow = CollapsedPhysItemListFoundedRows[0];
		Else
			ItemRow = Object.CollapsedPhysItemList.Add();
		EndIf;
		ItemRow.Item = DataRow.Item;
		ItemRow.ItemKey = DataRow.ItemKey;
		ItemRow.Unit = DataRow.Unit;
		ItemRow.Count = ItemRow.Count + DataRow.Quantity;
	EndDo;
EndProcedure

&AtClient
Procedure AddItemToItemList(ItemsData)
	For Each DataRow In ItemsData Do
		RowsFilter = New Structure();
		RowsFilter.Insert("ItemKey", DataRow.ItemKey);
		RowsFilter.Insert("Unit", DataRow.Unit);
		ExpItemListFoundedRows = Object.ExpItemList.FindRows(RowsFilter);
		Quantity = 0;
		For Each ExpItemListRow In ExpItemListFoundedRows Do
			Quantity = Quantity + ExpItemListRow.Quantity;
		EndDo;
		ItemListFoundedRows = Object.ItemList.FindRows(RowsFilter);
		If ItemListFoundedRows.Count() Then
			ItemRow = ItemListFoundedRows[0];
		Else
			ItemRow = Object.ItemList.Add();
		EndIf;
		ItemRow.Item = DataRow.Item;
		ItemRow.ItemKey = DataRow.ItemKey;
		ItemRow.Unit = DataRow.Unit;
		ItemRow.Quantity = Quantity;
		ItemRow.Count = ItemRow.Count + DataRow.Quantity;
		ItemRow.Difference = ItemRow.Quantity - ItemRow.Count;
	EndDo;
EndProcedure

&AtClient
Procedure TransferToDocument(Command)
	ItemListAddress = ItemListToTempStorage(FormOwner.UUID);
	Notify("TransferDataFromQuantityCompare", ItemListAddress, FormOwner);
	Close();
EndProcedure

&AtServer
Function ItemListToTempStorage(FormUUID)
	ItemListValue = Object.ItemList.Unload();
	Return PutToTempStorage(ItemListValue, FormUUID);	
EndFunction



