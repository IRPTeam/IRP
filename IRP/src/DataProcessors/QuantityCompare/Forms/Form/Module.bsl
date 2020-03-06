
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If ValueIsFilled(Parameters.IncomingExpItemListAddress) Then
		IncomingExpItemListValue = GetFromTempStorage(Parameters.IncomingExpItemListAddress);
		CompareItemListValue = Object.CompareItemList.Unload();
		For Each Row In IncomingExpItemListValue Do
			NewRow = CompareItemListValue.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
		CompareItemListValue.GroupBy("Item, ItemKey, Unit, Key", "Quantity, Difference, Count");
		For Each Row In CompareItemListValue Do
			Row.Key = New UUID();
			CalculateRowDifference(Row);
		EndDo;
		Object.CompareItemList.Load(CompareItemListValue);
		
		For Each Row In IncomingExpItemListValue Do
			NewRow = Object.ExpItemList.Add();
			FillPropertyValues(NewRow, Row);			
			CompareItemListValueFilter = New Structure();
			CompareItemListValueFilter.Insert("ItemKey", Row.ItemKey);
			CompareItemListValueFilter.Insert("Unit", Row.Unit);
			CompareItemListValueFoundedRows = CompareItemListValue.FindRows(CompareItemListValueFilter);
			NewRow.Key = CompareItemListValueFoundedRows[0].Key;
		EndDo;		
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	//RevertExpItemListVisible();
	RevertItemListsVisible();
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
	AddItemToCompareItemList(BarcodeItems);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SwitchItemLists(Command)
	RevertItemListsVisible();
EndProcedure

&AtClient
Procedure ShowHideExpItemList(Command)
	RevertExpItemListVisible();
EndProcedure

#EndRegion

&AtClient
Procedure RevertItemListsVisible()
	ItemListVisible = Items.GroupCompareItemList.Visible;
	Items.GroupCompareItemList.Visible = Not ItemListVisible;
	Items.GroupPhysItemList.Visible = ItemListVisible;
EndProcedure

&AtClient
Procedure CompareItemListCountOnChange(Item)
	CurrentData = Items.CompareItemList.CurrentData;
	CalculateRowDifference(CurrentData);
EndProcedure

&AtClient
Procedure CompareItemListBeforeDeleteRow(Item, Cancel)
	CurrentData = Items.CompareItemList.CurrentData;
	If isExistKeyAtExpItemList(CurrentData.Key) Then
		Cancel = True;
	EndIf;
EndProcedure

&AtClient
Function isExistKeyAtExpItemList(Key)
	ReturnValue = False;
	ExpItemListFilter = New Structure();
	ExpItemListFilter.Insert("Key", Key);
	FoundedRows = Object.ExpItemList.FindRows(ExpItemListFilter);
	If FoundedRows.Count() Then
		ReturnValue = True;
	EndIf;
	Return ReturnValue;
EndFunction

&AtClientAtServerNoContext
Procedure CalculateRowDifference(RowData)
	RowData.Difference = RowData.Count - RowData.Quantity;
EndProcedure

&AtClient
Procedure RevertExpItemListVisible()
	ItemListVisible = Items.GroupExpItemList.Visible;
	Items.GroupExpItemList.Visible = Not ItemListVisible;
EndProcedure

&AtClient
Procedure AddItemToPhysItemList(ItemsData)
	For Each DataRow In ItemsData Do
		RowsFilter = New Structure();
		RowsFilter.Insert("ItemKey", DataRow.ItemKey);
		RowsFilter.Insert("Unit", DataRow.Unit);
		CollapsedPhysItemListFoundedRows = Object.PhysItemList.FindRows(RowsFilter);
		If CollapsedPhysItemListFoundedRows.Count() Then
			ItemRow = CollapsedPhysItemListFoundedRows[0];
		Else
			ItemRow = Object.PhysItemList.Add();
		EndIf;
		ItemRow.Item = DataRow.Item;
		ItemRow.ItemKey = DataRow.ItemKey;
		ItemRow.Unit = DataRow.Unit;
		ItemRow.Count = ItemRow.Count + DataRow.Quantity;
	EndDo;
EndProcedure

&AtClient
Procedure AddItemToCompareItemList(ItemsData)
	For Each DataRow In ItemsData Do
		RowsFilter = New Structure();
		RowsFilter.Insert("ItemKey", DataRow.ItemKey);
		RowsFilter.Insert("Unit", DataRow.Unit);
		ExpItemListFoundedRows = Object.ExpItemList.FindRows(RowsFilter);
		Quantity = 0;
		For Each ExpItemListRow In ExpItemListFoundedRows Do
			Quantity = Quantity + ExpItemListRow.Quantity;
		EndDo;
		CompareItemListFoundedRows = Object.CompareItemList.FindRows(RowsFilter);
		If CompareItemListFoundedRows.Count() Then
			ItemRow = CompareItemListFoundedRows[0];
		Else
			ItemRow = Object.CompareItemList.Add();
		EndIf;
		ItemRow.Item = DataRow.Item;
		ItemRow.ItemKey = DataRow.ItemKey;
		ItemRow.Unit = DataRow.Unit;
		ItemRow.Quantity = Quantity;
		ItemRow.Count = ItemRow.Count + DataRow.Quantity;
		CalculateRowDifference(ItemRow);
	EndDo;
EndProcedure

&AtClient
Procedure TransferToDocument(Command)
	If FormOwner <> Undefined Then
		ListsAddress = ListsToTempStorage(FormOwner.UUID);
		Notify("TransferDataFromQuantityCompare", ListsAddress, FormOwner);
	EndIf;
	Close();
EndProcedure

&AtServer
Function ListsToTempStorage(FormUUID)
	Lists = New Structure();
	Lists.Insert("PhysItemList", Object.PhysItemList.Unload());
	Lists.Insert("ExpItemList", Object.ExpItemList.Unload());
	Return PutToTempStorage(Lists, FormUUID);	
EndFunction



