
Function GetEditStoresParameters(CurrentData, Object) Export
	Result = New Array();
	BillOfMaterialRows = Object.BillOfMaterialsList.FindRows(New Structure("Key", CurrentData.Key));
	For Each Row In BillOfMaterialRows Do
		NewRow = New Structure();
		NewRow.Insert("ItemKey"          , Row.ItemKey);
		NewRow.Insert("Unit"             , Row.Unit);
		NewRow.Insert("Quantity"         , Row.Quantity);
		NewRow.Insert("MaterialStore"    , Row.MaterialStore);
		NewRow.Insert("ReleaseStore"     , Row.ReleaseStore);
		NewRow.Insert("SemiproductStore" , Row.SemiproductStore);
		NewRow.Insert("InputID"          , Row.InputID);
		NewRow.Insert("OutputID"         , Row.OutputID);
		NewRow.Insert("UniqueID"         , Row.UniqueID);
		NewRow.Insert("IsProduct"        , Row.IsProduct);
		NewRow.Insert("IsSemiproduct"    , Row.IsSemiproduct);
		NewRow.Insert("IsMaterial"       , Row.IsMaterial);
		NewRow.Insert("IsService"        , Row.IsService);
		Result.Add(NewRow);
	EndDo;
	Return New Structure("RowKey, BillOfMaterialRows", CurrentData.Key, Result);
EndFunction

Procedure EditStoresContinue(Result, Parameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Parameters.Form.Modified = True;
	For Each ResultRow In Result.ArrayOfRows Do
		Filter = New Structure();
		Filter.Insert("Key"      , Result.RowKey);
		Filter.Insert("InputID"  , ResultRow.InputID);
		Filter.Insert("OutputID" , ResultRow.OutputID);
		Filter.Insert("UniqueID" , ResultRow.UniqueID);
		Filter.Insert("ItemKey"  , ResultRow.ItemKey);
		BillOfMaterialRows = Parameters.Object.BillOfMaterialsList.FindRows(Filter);
		For Each Row In BillOfMaterialRows Do
			Row.MaterialStore    = ResultRow.MaterialStore;
			Row.ReleaseStore     = ResultRow.ReleaseStore;
			Row.SemiproductStore = ResultRow.SemiproductStore;
		EndDo;
	EndDo;
EndProcedure
