Function GetOrCreateTopLevel(UniqueID, AddInfo = Undefined) Export
	Query = New Query;
	Query.Text =
		"SELECT
		|	DataMappingItems.Ref
		|FROM
		|	Catalog.DataMappingItems AS DataMappingItems
		|WHERE
		|	DataMappingItems.UniqueID = &UniqueID
		|	AND DataMappingItems.IsFolder";
	
	Query.SetParameter("UniqueID", UniqueID);
	
	QueryResult = Query.Execute().Select();
	
	If QueryResult.Next() Then
		Return QueryResult.Ref;
	EndIf;
	
	NewGroup = Catalogs.DataMappingItems.CreateFolder();
	NewGroup.Description = UniqueID;
	NewGroup.UniqueID = UniqueID;
	NewGroup.Write();
	
	Return NewGroup.Ref;
EndFunction