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
	For Each RowItemList In Object.ItemList Do
		IDInfoRows = Object.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 1 Then
			If CommonFunctionsClientServer.ObjectHasProperty(RowItemList, "Difference") Then
				IDInfoRows[0].Quantity = ?(RowItemList.Difference < 0, -RowItemList.Difference, RowItemList.Difference);
			Else
				IDInfoRows[0].Quantity = RowItemList.QuantityInBaseUnit;
			EndIf;
		Else

			TabularSectionName = "";
			If Object.Property("ShipmentConfirmations") Then
				TabularSectionName = "ShipmentConfirmations";
			ElsIf Object.Property("GoodsReceipts") Then
				TabularSectionName = "GoodsReceipts";
			EndIf;

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
				Continue;
			EndIf;

			For Each Row In Object[TabularSectionName] Do
				IDInfoRows = Object.RowIDInfo.FindRows(New Structure("Key, BasisKey", Row.Key, Row.BasisKey));
				If IDInfoRows.Count() = 1 Then
					IDInfoRows[0].Quantity = Row.Quantity;
				EndIf;
			EndDo;

		EndIf;
	EndDo;
EndProcedure

Function GetSelectedRowInfo(CurrentData) Export
	Result = New Structure("SelectedRow, FilterBySelectedRow", Undefined, Undefined);
	If CurrentData = Undefined Then
		Return Result;
	EndIf;
	Store = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "Store") Then
		Store = CurrentData.Store;
	EndIf;
	Result.SelectedRow = New Structure();
	Result.SelectedRow.Insert("Key", CurrentData.Key);
	Result.SelectedRow.Insert("Item", CurrentData.Item);
	Result.SelectedRow.Insert("ItemKey", CurrentData.ItemKey);
	Result.SelectedRow.Insert("Store", Store);
	Result.SelectedRow.Insert("Unit", CurrentData.Unit);
	Result.SelectedRow.Insert("Quantity", CurrentData.Quantity);
	Result.SelectedRow.Insert("LineNumber", CurrentData.LineNumber);

	Result.SelectedRow.Insert("QuantityInBaseUnit", 0);
	Result.SelectedRow.Insert("BasisUnit", Undefined);

	If ValueIsFilled(CurrentData.ItemKey) And ValueIsFilled(CurrentData.Unit) And ValueIsFilled(CurrentData.Quantity) Then
		ConvertationResult = RowIDInfoServer.ConvertQuantityToQuantityInBaseUnit(CurrentData.ItemKey, CurrentData.Unit,
			CurrentData.Quantity);

		Result.SelectedRow.QuantityInBaseUnit = ConvertationResult.QuantityInBaseUnit;
		Result.SelectedRow.BasisUnit          = ConvertationResult.BasisUnit;
	EndIf;

	Result.FilterBySelectedRow = New Structure();
	Result.FilterBySelectedRow.Insert("ItemKey", CurrentData.ItemKey);
	Result.FilterBySelectedRow.Insert("Store", Store);
	Return Result;
EndFunction

Function GetTablesInfo(Object = Undefined) Export
	TablesInfo = New Structure("ItemListRows, RowIDInfoRows", New Array(), New Array());
	If Object = Undefined Then
		Return TablesInfo;
	EndIf;
	TablesInfo.ItemListRows  = GetItemListRows(Object.ItemList, Object);
	TablesInfo.RowIDInfoRows = GetRowIDInfoRows(Object.RowIDInfo, Object);
	Return TablesInfo;
EndFunction

Function GetItemListRows(ItemList, Object) Export
	ItemListRows = New Array();
	For Each Row In ItemList Do
		NewRow = New Structure();
		NewRow.Insert("LineNumber", Row.LineNumber);
		NewRow.Insert("Key", Row.Key);
		NewRow.Insert("Item", Row.Item);
		NewRow.Insert("ItemKey", Row.ItemKey);
		NewRow.Insert("Unit", Row.Unit);
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "Store") Then
			NewRow.Insert("Store", Row.Store);
		ElsIf CommonFunctionsClientServer.ObjectHasProperty(Object, "Store") Then
			NewRow.Insert("Store", Object.Store);
		Else
			NewRow.Insert("Store", Undefined);
		EndIf;
		NewRow.Insert("Quantity", Row.Quantity);
		ItemListRows.Add(NewRow);
	EndDo;
	Return ItemListRows;
EndFunction

Function GetRowIDInfoRows(RowIDInfo, Object)
	RowIDInfoRows = New Array();
	For Each Row In RowIDInfo Do
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

Procedure AfterWriteAtClient(Object, Form, WriteParameters, AddInfo = Undefined) Export
	Notify("LockLinkedRows", WriteParameters, Form);	
EndProcedure

//Procedure NotificationProcessing(Object, Form, EventName, Parameter, Source, AddInfo = Undefined) Export
//	If Source <> Form Then
//		LockLinkedRows(Object, Form);
//		//RowIDInfoServer.SetAppearance(Object, Form);
//	EndIf;
//EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel, AddInfo = Undefined) Export
	For Each SelectedRow In Form.Items.ItemList.SelectedRows Do
		ItemListRow = Object.ItemList.FindByID(SelectedRow);
		If ItemListRow.IsLinked Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_096,
					ItemListRow.LineNumber, ItemListRow.Item, ItemListRow.ItemKey), 
					"Object.ItemList[" + Format((ItemListRow.LineNumber - 1), "NZ=0; NG=0;") + "].IsLinked", Form);
		EndIf;
	EndDo;
EndProcedure

//Procedure LockLinkedRows(Object, Form) Export
//	ArrayOfKeys = New Array();
//	For Each Row In Object.RowIDInfo Do
//		ArrayOfKeys.Add(New Structure("Key, RowID", Row.Key, Row.RowID));
//	EndDo;
//	LinkedKeys = RowIDInfoServer.GetLinkedKeys(ArrayOfKeys);
//	Form.DependentDocs.LoadValues(LinkedKeys.DependentDocs);
//	For Each Row In Object.ItemList Do
//		If LinkedKeys.Keys.Find(Row.Key) <> Undefined Then
//			Row.IsLinked = True;
//			Form.IsLinked = True;
//		Else
//			Row.IsLinked = False;
//		EndIf;
//	EndDo;
//EndProcedure

#EndRegion

