
&AtClient
Var DeleteRows;

#Region FormEvents

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If ValueIsFilled(Parameters.IncomingExpItemListAddress) Then
		IncomingExpItemListValue = GetFromTempStorage(Parameters.IncomingExpItemListAddress);
		CompareItemListValue = Object.CompareItemList.Unload();
		For Each Row In IncomingExpItemListValue Do
			NewRow = CompareItemListValue.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
		CompareItemListValue.GroupBy("Item, ItemKey, Unit", "Quantity, Difference, Count");
		For Each Row In CompareItemListValue Do
			CalculateRowDifference(Row);
		EndDo;
		Object.CompareItemList.Load(CompareItemListValue);
		For Each Row In IncomingExpItemListValue Do
			NewRow = Object.ExpItemList.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;		
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	RevertItemListsVisible();
	DeleteRows = New Array;
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	BarcodeClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(BarcodeItems, Parameters) Export
	AddItemToPhysItemList(BarcodeItems);
	AddItemToCompareItemList(BarcodeItems);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command, AddInfo = Undefined) Export
	PickupItemsClient.OpenPickupItems(Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Procedure OpenPickupItemsEnd(Result, AdditionalParameters) Export
	If Result <> Undefined Then
		AddItemToPhysItemList(Result);
		AddItemToCompareItemList(Result);
	EndIf;
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
	DeleteRows.Clear();
	For Each Row In Items.CompareItemList.SelectedRows Do
		CurrentData = Items.CompareItemList.RowData(Row);
		If isExistItemKeyAtExpItemList(CurrentData.ItemKey, CurrentData.Unit) Then
			Cancel = True;
			Break;
		EndIf;
		RowStructure = New Structure();
		RowStructure.Insert("ItemKey", CurrentData.ItemKey);
		RowStructure.Insert("Unit", CurrentData.Unit);
		DeleteRows.Add(RowStructure);
	EndDo;
	If Cancel Then
		DeleteRows.Clear();
	EndIf;
EndProcedure

&AtClient
Procedure CompareItemListAfterDeleteRow(Item)
	For Each Row In DeleteRows Do
		PhysItemListFilter = New Structure();
		PhysItemListFilter.Insert("ItemKey", Row.ItemKey);
		PhysItemListFilter.Insert("Unit", Row.Unit);
		PhysItemListFoundedRows = Object.PhysItemList.FindRows(PhysItemListFilter);
		For Each FoundedRow In PhysItemListFoundedRows Do
			Object.PhysItemList.Delete(FoundedRow);
		EndDo;
	EndDo;
	DeleteRows.Clear();
EndProcedure

&AtClient
Procedure PhysItemListBeforeDeleteRow(Item, Cancel)
	DeleteRows.Clear();
	For Each Row In Items.PhysItemList.SelectedRows Do
		CurrentData = Items.PhysItemList.RowData(Row);
		RowStructure = New Structure();
		RowStructure.Insert("ItemKey", CurrentData.ItemKey);
		RowStructure.Insert("Unit", CurrentData.Unit);
		DeleteRows.Add(RowStructure);
	EndDo;
EndProcedure

&AtClient
Procedure PhysItemListAfterDeleteRow(Item)
	For Each Row In DeleteRows Do
		CompareItemListFilter = New Structure();
		CompareItemListFilter.Insert("ItemKey", Row.ItemKey);
		CompareItemListFilter.Insert("Unit", Row.Unit);
		CompareItemListFoundedRows = Object.CompareItemList.FindRows(CompareItemListFilter);		
		For Each FoundedRow In CompareItemListFoundedRows Do
			If isExistItemKeyAtExpItemList(FoundedRow.ItemKey, FoundedRow.Unit) Then
				FoundedRow.Count = 0;
			Else
				Object.CompareItemList.Delete(FoundedRow);
			EndIf;			
		EndDo;
	EndDo;
	DeleteRows.Clear();
EndProcedure

&AtClient
Function isExistItemKeyAtExpItemList(ItemKey, Unit)
	ReturnValue = False;
	ExpItemListFilter = New Structure();
	ExpItemListFilter.Insert("ItemKey", ItemKey);
	ExpItemListFilter.Insert("Unit", Unit);
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
	For Each Row In ItemsData Do
		PhysItemListFilter = New Structure();
		PhysItemListFilter.Insert("ItemKey", Row.ItemKey);
		PhysItemListFilter.Insert("Unit", Row.Unit);
		PhysItemListFoundedRows = Object.PhysItemList.FindRows(PhysItemListFilter);
		If PhysItemListFoundedRows.Count() Then
			ItemRow = PhysItemListFoundedRows[0];
		Else
			ItemRow = Object.PhysItemList.Add();
		EndIf;
		ItemRow.Item = Row.Item;
		ItemRow.ItemKey = Row.ItemKey;
		ItemRow.Unit = Row.Unit;
		ItemRow.Count = ItemRow.Count + Row.Quantity;
	EndDo;
EndProcedure

&AtClient
Procedure AddItemToCompareItemList(ItemsData)
	For Each Row In ItemsData Do		
		ItemListsFilter = New Structure();
		ItemListsFilter.Insert("ItemKey", Row.ItemKey);
		ItemListsFilter.Insert("Unit", Row.Unit);
		ExpItemListFoundedRows = Object.ExpItemList.FindRows(ItemListsFilter);
		Quantity = 0;
		For Each ExpItemListRow In ExpItemListFoundedRows Do
			Quantity = Quantity + ExpItemListRow.Quantity;
		EndDo;
		CompareItemListFoundedRows = Object.CompareItemList.FindRows(ItemListsFilter);
		If CompareItemListFoundedRows.Count() Then
			ItemRow = CompareItemListFoundedRows[0];
		Else
			ItemRow = Object.CompareItemList.Add();
		EndIf;
		ItemRow.Item = Row.Item;
		ItemRow.ItemKey = Row.ItemKey;
		ItemRow.Unit = Row.Unit;
		ItemRow.Quantity = Quantity;
		ItemRow.Count = ItemRow.Count + Row.Quantity;
		CalculateRowDifference(ItemRow);
	EndDo;
EndProcedure

&AtClient
Procedure CompareItemListQuantityOnChange(Item)
	CurrentData = Items.CompareItemList.CurrentData;
	PhysItemListFilter = New Structure();
	PhysItemListFilter.Insert("ItemKey", CurrentData.ItemKey);
	PhysItemListFilter.Insert("Unit", CurrentData.Unit);
	PhysItemListFoundedRows = Object.PhysItemList.FindRows(PhysItemListFilter);
	If PhysItemListFoundedRows.Count() Then
		PhysItemListFoundedRows[0].Count = CurrentData.Count;
	EndIf;
EndProcedure

&AtClient
Procedure PhysItemListCountOnChange(Item)
	CurrentData = Items.PhysItemList.CurrentData;
	CompareItemListFilter = New Structure();
	CompareItemListFilter.Insert("ItemKey", CurrentData.ItemKey);
	CompareItemListFilter.Insert("Unit", CurrentData.Unit);
	CompareItemListFoundedRows = Object.CompareItemList.FindRows(CompareItemListFilter);
	If CompareItemListFoundedRows.Count() Then
		CompareItemListFoundedRows[0].Count = CurrentData.Count;
	EndIf;
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

