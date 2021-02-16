
Function GetSelectedRowInfo(CurrentData) Export
	Result = New Structure("SelectedRow, FilterBySelectedRow", Undefined, Undefined);
	If CurrentData = Undefined Then
		Return Result;
	EndIf;
	
	Result.SelectedRow = New Structure();
	Result.SelectedRow.Insert("Item   "  , CurrentData.Item);
	Result.SelectedRow.Insert("ItemKey"  , CurrentData.ItemKey);
	Result.SelectedRow.Insert("Store"    , CurrentData.Store);
	Result.SelectedRow.Insert("Unit"     , CurrentData.Unit);
	Result.SelectedRow.Insert("Quantity" , CurrentData.Quantity);
		
	Result.FilterBySelectedRow = New Structure();
	Result.FilterBySelectedRow.Insert("ItemKey"  , CurrentData.ItemKey);
	Result.FilterBySelectedRow.Insert("Store"    , CurrentData.Store);		
	Return Result;
EndFunction

Function GetTablesInfo(Object) Export
	TablesInfo = New Structure();
	TablesInfo.Insert("ItemListRows"  , GetItemListRows(Object.ItemList));
	TablesInfo.Insert("RowIDInfoRows" , GetRowIDInfoRows(Object.RowIDInfo));
	Return TablesInfo;
EndFunction

Function GetItemListRows(ItemList) Export
	ItemListRows = New Array();
	For Each Row In ItemList Do
		NewRow = New Structure();
		NewRow.Insert("Key"      , Row.Key);
		NewRow.Insert("Item"     , Row.Item); 
		NewRow.Insert("ItemKey"  , Row.ItemKey); 
		NewRow.Insert("Unit"     , Row.Unit);
		NewRow.Insert("Store"    , Row.Store);
		NewRow.Insert("Quantity" , Row.Quantity);
		ItemListRows.Add(NewRow);
	EndDo;	
	Return ItemListRows;
EndFunction

Function GetRowIDInfoRows(RowIDInfo) Export
	RowIDInfoRows = New Array();
	For Each Row In RowIDInfo Do
		NewRow = New Structure();
		NewRow.Insert("Key"         , Row.Key);
		NewRow.Insert("RowID"       , Row.RowID); 
		NewRow.Insert("Quantity"    , Row.Quantity); 
		NewRow.Insert("Basis"       , Row.Basis);
		NewRow.Insert("CurrentStep" , Row.CurrentStep);
		NewRow.Insert("NextStep"    , Row.NextStep);
		NewRow.Insert("RowRef"      , Row.RowRef);
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
	For Each ItemTreeRows In TreeRows Do
		Tree.Expand(ItemTreeRows.GetID());
	EndDo;
EndProcedure
