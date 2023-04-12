Procedure DeleteRows(Object, Form) Export
	If Object.Property("RowIDInfo") And Object.Property("ItemList") Then
		ArrayDelete = New Array();
		For Each Row In Object.RowIDInfo Do
			If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
				ArrayDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemArray In ArrayDelete Do
			Object.RowIDInfo.Delete(ItemArray);
		EndDo;
	EndIf;
EndProcedure

Procedure UpdateQuantity(Object, Form) Export
	TabularSectionName = "";
	If Object.Property("ShipmentConfirmations") Then
		TabularSectionName = "ShipmentConfirmations";
	ElsIf Object.Property("GoodsReceipts") Then
		TabularSectionName = "GoodsReceipts";
	ElsIf Object.Property("WorkSheets") Then
		TabularSectionName = "WorkSheets";
	EndIf;
	
	For Each RowItemList In Object.ItemList Do
		
		IDInfoRows = Object.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 1 Then
			If CommonFunctionsClientServer.ObjectHasProperty(RowItemList, "Difference") Then
				IDInfoRows[0].Quantity = ?(RowItemList.Difference < 0, -RowItemList.Difference, RowItemList.Difference);
			Else
				IDInfoRows[0].Quantity = RowItemList.QuantityInBaseUnit;
			EndIf;
		Else
			If Not ValueIsFilled(TabularSectionName) Then
				If CommonFunctionsClientServer.ObjectHasProperty(RowItemList, "Difference") Then
					For Each IDInfoRow In IDInfoRows Do
						IDInfoRow.Quantity = ?(RowItemList.Difference < 0, -RowItemList.Difference,
							RowItemList.Difference);
					EndDo;
				Else
					For Each IDInfoRow In IDInfoRows Do
						IDInfoRow.Quantity = RowItemList.QuantityInBaseUnit;
					EndDo;
				EndIf;
			Else
				For Each Row In Object[TabularSectionName] Do
					If Row.Key <> RowItemList.Key Then
						Continue;
					EndIf;
					IDInfoRows = Object.RowIDInfo.FindRows(New Structure("Key, BasisKey", Row.Key, Row.BasisKey));
					If IDInfoRows.Count() = 1 Then
						IDInfoRows[0].Quantity = Row.Quantity;
					EndIf;
				EndDo;
			EndIf;
		EndIf;
	EndDo;	
EndProcedure

Function GetSelectedRowInfo(CurrentData, ArrayOfFilterExcludeFields = Undefined) Export
	Result = New Structure("SelectedRow, FilterBySelectedRow", Undefined, Undefined);
	If CurrentData = Undefined Then
		Return Result;
	EndIf;
	Store = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "Store") Then
		Store = CurrentData.Store;
	EndIf;
	
	SerialLotNumber = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "SerialLotNumber") Then
		SerialLotNumber = CurrentData.SerialLotNumber;
	EndIf;
	
	Result.SelectedRow = New Structure();
	Result.SelectedRow.Insert("Key"        , CurrentData.Key);
	Result.SelectedRow.Insert("Item"       , CurrentData.Item);
	Result.SelectedRow.Insert("ItemKey"    , CurrentData.ItemKey);
	Result.SelectedRow.Insert("Store"      , Store);
	Result.SelectedRow.Insert("Unit"       , CurrentData.Unit);
	Result.SelectedRow.Insert("Quantity"   , CurrentData.Quantity);
	Result.SelectedRow.Insert("LineNumber" , CurrentData.LineNumber);
	Result.SelectedRow.Insert("SerialLotNumber" , SerialLotNumber);
		
	Result.SelectedRow.Insert("QuantityInBaseUnit", 0);
	Result.SelectedRow.Insert("BasisUnit", Undefined);

	If ValueIsFilled(CurrentData.ItemKey) And ValueIsFilled(CurrentData.Unit) And ValueIsFilled(CurrentData.Quantity) Then
		ConvertationResult = RowIDInfoServer.ConvertQuantityToQuantityInBaseUnit(CurrentData.ItemKey, CurrentData.Unit,
			CurrentData.Quantity);

		Result.SelectedRow.QuantityInBaseUnit = ConvertationResult.QuantityInBaseUnit;
		Result.SelectedRow.BasisUnit          = ConvertationResult.BasisUnit;
	EndIf;

	Result.FilterBySelectedRow = New Structure();
	Result.FilterBySelectedRow.Insert("ItemKey"     , CurrentData.ItemKey);
	Result.FilterBySelectedRow.Insert("Store"       , Store);
	Result.FilterBySelectedRow.Insert("StoreReturn" , Store);
	
	If ArrayOfFilterExcludeFields <> Undefined Then
		Result.Insert("ArrayOfFilterExcludeFields", ArrayOfFilterExcludeFields);
		For Each FilterField In ArrayOfFilterExcludeFields Do
			FieldName = TrimAll(FilterField);
			If Not ValueIsFilled(FieldName) Then
				Continue;
			EndIf;
			If Result.FilterBySelectedRow.Property(FieldName) Then
				Result.FilterBySelectedRow.Delete(FieldName);
			EndIf;
		EndDo;
	EndIf;
	
	Return Result;
EndFunction

Function GetTablesInfo(Object = Undefined, FilterKey = Undefined) Export
	TablesInfo = New Structure("ItemListRows, RowIDInfoRows", New Array(), New Array());
	If Object = Undefined Then
		Return TablesInfo;
	EndIf;
	TablesInfo.ItemListRows  = GetItemListRows(Object.ItemList, Object, FilterKey);
	TablesInfo.RowIDInfoRows = GetRowIDInfoRows(Object.RowIDInfo, Object, FilterKey);
	Return TablesInfo;
EndFunction

Function GetItemListRows(ItemList, Object, FilterKey = Undefined) Export
	
	SerialLotNumber_SingleRowInfo = RowIDInfoServer.GetSerialLotNumber_SingleRowInfo(Object);
	
	ItemListRows = New Array();
	For Each Row In ItemList Do
		If FilterKey <> Undefined And Row.Key <> FilterKey Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("LineNumber" , Row.LineNumber);
		NewRow.Insert("Key"        , Row.Key);
		NewRow.Insert("Item"       , Row.Item);
		NewRow.Insert("ItemKey"    , Row.ItemKey);
		NewRow.Insert("Unit"       , Row.Unit);
		NewRow.Insert("Quantity"   , Row.Quantity);
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "Store") Then
			NewRow.Insert("Store", Row.Store);
		ElsIf CommonFunctionsClientServer.ObjectHasProperty(Object, "Store") Then
			NewRow.Insert("Store", Object.Store);
		Else
			NewRow.Insert("Store", Undefined);
		EndIf;
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "IsExternalLinked") Then
			NewRow.Insert("IsExternalLinked", Row.IsExternalLinked);
		Else
			NewRow.Insert("IsExternalLinked", False);
		EndIf;
		
		NewRow.Insert("SerialLotNumber", SerialLotNumber_SingleRowInfo.Get(Row.Key));	
		
		ItemListRows.Add(NewRow);
	EndDo;
	Return ItemListRows;
EndFunction

Function GetRowIDInfoRows(RowIDInfo, Object, FilterKey = Undefined)
	RowIDInfoRows = New Array();
	For Each Row In RowIDInfo Do
		If FilterKey <> Undefined And Row.Key <> FilterKey Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("Key", Row.Key);
		NewRow.Insert("RowID", Row.RowID);
		NewRow.Insert("QuantityInBaseUnit", Row.Quantity);
		NewRow.Insert("BasisKey", Row.BasisKey);
		NewRow.Insert("Basis", Row.Basis);
		NewRow.Insert("CurrentStep", Row.CurrentStep);
		NewRow.Insert("NextStep", Row.NextStep);
		NewRow.Insert("RowRef", Row.RowRef);
		RowIDInfoRows.Add(NewRow);
	EndDo;
	Return RowIDInfoRows;
EndFunction

Function FindRowInTree(Filter, Tree) Export
	RowID = Undefined;
	FindRowInTreeRecursive(Filter, Tree.GetItems(), RowID);
	Return RowID;
EndFunction

Procedure FindRowInTreeRecursive(Filter, TreeRows, RowID)
	For Each Row In TreeRows Do
		If RowID <> Undefined Then
			Return;
		EndIf;
		Founded = True;
		For Each ItemOfFilter In Filter Do
			If Row[ItemOfFilter.Key] <> Filter[ItemOfFilter.Key] Then
				Founded = False;
				Break;
			EndIf;
		EndDo;
		If Founded Then
			RowID = Row.GetID();
		EndIf;
		If RowID = Undefined Then
			FindRowInTreeRecursive(Filter, Row.GetItems(), RowID);
		EndIf;
	EndDo;
EndProcedure

Procedure ExpandTree(Tree, TreeRows) Export
	If Not Tree.Visible Then
		Return;
	EndIf;
	For Each ItemTreeRows In TreeRows Do
		Tree.Expand(ItemTreeRows.GetID());
		ExpandTree(Tree, ItemTreeRows.GetItems());
	EndDo;
EndProcedure

#Region LockLinkedRows

#Region EventHandlers

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Notify("LockLinkedRows", WriteParameters, Form);	
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	For Each SelectedRow In Form.Items.ItemList.SelectedRows Do
		ItemListRow = Object.ItemList.FindByID(SelectedRow);
		If ItemListRow.IsExternalLinked Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_096,
					ItemListRow.LineNumber, ItemListRow.Item, ItemListRow.ItemKey), 
					"Object.ItemList[" + Format((ItemListRow.LineNumber - 1), "NZ=0; NG=0;") + "].IsExternalLinked", Form);
		EndIf;
	EndDo;
EndProcedure

// Deprecated
Procedure ItemListOnStartEdit(Object, Form, Item, NewRow, Clone, AddInfo = Undefined) Export
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Clone Then
		CurrentData.IsExternalLinked = False;
		CurrentData.IsInternalLinked = False;
		CurrentData.ExternalLinks = Undefined;
		CurrentData.InternalLinks = Undefined;
	EndIf;
EndProcedure

Procedure ItemListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	If Upper(Field.Name) = Upper("ItemListIsInternalLinked") 
		Or Upper(Field.Name) = Upper("ItemListIsExternalLinked") Then
		CurrentData = Form.Items.ItemList.CurrentData;
		If CurrentData <> Undefined Then
			FormParameters = New Structure();
			FormParameters.Insert("SelectedRowInfo", GetSelectedRowInfo(CurrentData));
			FormParameters.Insert("TablesInfo"     , GetTablesInfo(Object, CurrentData.Key));
			FormParameters.Insert("Ref"            , Object.Ref);
			OpenForm("CommonForm.InfoLinkedDocumentRows", FormParameters, , , , , , FormWindowOpeningMode.LockOwnerWindow);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#EndRegion

