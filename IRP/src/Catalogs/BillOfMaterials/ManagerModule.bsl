
Function GetBillOfMaterialsByItemKey(ItemKey) Export
	Query = New Query();
	Query.Text = 
		"SELECT TOP 2
		|	Table.Ref
		|FROM
		|	Catalog.BillOfMaterials AS Table
		|WHERE
		|	Table.ItemKey = &ItemKey
		|	AND NOT Table.DeletionMark";
	Query.SetParameter("ItemKey", ItemKey);
	
	Selection = Query.Execute().Select();
	If Selection.Count() = 1 Then
		Selection.Next();
		Return Selection.Ref;
	EndIf;
	Return Catalogs.BillOfMaterials.EmptyRef();
	
//	If ValueIsFilled(ItemKey.MF_DefaultBillOfMaterials) Then
//		Return ItemKey.MF_DefaultBillOfMaterials;
//	Else
//		Return Catalogs.ItemKeys.EmptyRef();
//	EndIf;
EndFunction
