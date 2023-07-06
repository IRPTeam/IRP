
Function GetBillOfMaterialsByItemKey(ItemKey, BusinessUnit = Undefined) Export
	Query = New Query();
	Query.Text = 
		"SELECT
		|	ItemKeys.DefaultBillOfMaterials AS Ref
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|WHERE
		|	ItemKeys.Ref = &ItemKey
		|	AND NOT ItemKeys.DefaultBillOfMaterials.DeletionMark
		|	AND ItemKeys.DefaultBillOfMaterials.Active
		|	and case
		|		when &Filter_BusinessUnit
		|			then ItemKeys.DefaultBillOfMaterials.BusinessUnit = &BusinessUnit
		|		else true
		|	end
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT TOP 2
		|	Table.Ref
		|FROM
		|	Catalog.BillOfMaterials AS Table
		|WHERE
		|	Table.ItemKey = &ItemKey
		|	AND NOT Table.DeletionMark
		|	AND Table.Active
		|	and case
		|		when &Filter_BusinessUnit
		|			then Table.BusinessUnit = &BusinessUnit
		|		else true
		|	end";
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("BusinessUnit", BusinessUnit);
	Query.SetParameter("Filter_BusinessUnit", BusinessUnit <> Undefined);
	
	QueryResults = Query.ExecuteBatch();
	DefaultRef = QueryResults[0].Unload();
	If DefaultRef.Count() Then
		Return DefaultRef[0].Ref;
	EndIf;
	
	Selection = QueryResults[1].Select();
	If Selection.Count() = 1 Then
		Selection.Next();
		Return Selection.Ref;
	EndIf;
	Return EmptyRef();
EndFunction
