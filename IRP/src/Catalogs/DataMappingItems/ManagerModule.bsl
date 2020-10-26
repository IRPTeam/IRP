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

Function GetOrCreateMappingItem(CreationStructure, AddInfo = Undefined) Export
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	DataMappingItems.Ref
		|FROM
		|	Catalog.DataMappingItems AS DataMappingItems
		|WHERE
		|	DataMappingItems.Parent = &Parent
		|	AND DataMappingItems.SimpleValue = &SimpleValue
		|	AND DataMappingItems.TypeValue = &TypeValue";
	
	Query.SetParameter("Parent", CreationStructure.TopLevel);
	Query.SetParameter("SimpleValue", CreationStructure.Value);
	Query.SetParameter("TypeValue", CreationStructure.Type);
	
	QueryResult = Query.Execute().Select();
	
	If QueryResult.Next() Then
		If QueryResult.Ref.RefValue = CreationStructure.Ref Then
			Return QueryResult.Ref;
		EndIf;
		 
		NewItem = QueryResult.Ref.GetObject();
		
	Else
		NewItem = Catalogs.DataMappingItems.CreateItem();
		NewItem.Description = CreationStructure.Value;
		NewItem.SimpleValue = CreationStructure.Value;
		NewItem.TypeValue = CreationStructure.Type;
		NewItem.Parent = CreationStructure.TopLevel;
	EndIf;

	NewItem.RefValue = CreationStructure.Ref;
	NewItem.Write();
	
	Return NewItem.Ref;
EndFunction

Function GetCreationStructure(AddInfo = Undefined) Export
	CreationStructure = New Structure;
	CreationStructure.Insert("Value", "");
	CreationStructure.Insert("Type", "");
	CreationStructure.Insert("TopLevel", Catalogs.DataMappingItems.EmptyRef());
	CreationStructure.Insert("Ref", Undefined);
	Return CreationStructure;
EndFunction