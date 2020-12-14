
#Region Public

Function CheckDescriptionDuplicateEnabled(Object) Export
	MetadataFullName = Object.Metadata().FullName();
	Query = New Query;
	Query.Text = "SELECT ALLOWED TOP 1
	|	ConfigurationMetadata.CheckDescriptionDuplicate
	|FROM
	|	Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|WHERE
	|	ConfigurationMetadata.ObjectFullName = &ObjectFullName";
	Query.SetParameter("ObjectFullName", MetadataFullName);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return False;
	Else
		QuerySelect = QueryExecution.Select();
		QuerySelect.Next();
		Return QuerySelect.CheckDescriptionDuplicate;
	EndIf;
EndFunction

Function CheckDescriptionFillingEnabled(Object) Export
	MetadataFullName = Object.Metadata().FullName();
	Query = New Query;
	Query.Text = "SELECT ALLOWED TOP 1
	|	ConfigurationMetadata.CheckDescriptionFilling
	|FROM
	|	Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|WHERE
	|	ConfigurationMetadata.ObjectFullName = &ObjectFullName";
	Query.SetParameter("ObjectFullName", MetadataFullName);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return False;
	Else
		QuerySelect = QueryExecution.Select();
		QuerySelect.Next();
		Return QuerySelect.CheckDescriptionFilling;
	EndIf;
EndFunction

Procedure RefillMetadata() Export
	RefillCatalogs();
	RefillDocuments();
EndProcedure

Function GetConfigurationMetadataItemByObject(Object) Export
	Return GetConfigurationMetadataItemByFullName(Object.Metadata().FullName);
EndFunction

Function GetConfigurationMetadataItemByFullName(ObjectFullName) Export
	ReturnValue = Undefined;
	Query = New Query;
	Query.Text = "SELECT
	|	ConfigurationMetadata.Ref
	|FROM
	|	Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|WHERE
	|	ConfigurationMetadata.ObjectFullName = &ObjectFullName
	|	AND NOT ConfigurationMetadata.DeletionMark
	|	AND NOT ConfigurationMetadata.Unused";
	Query.SetParameter("ObjectFullName", ObjectFullName);
	QueryExecution = Query.Execute();
	If Not QueryExecution.IsEmpty() Then
		QuerySelection = QueryExecution.Select();
		QuerySelection.Next();
		ReturnValue = QuerySelection.Ref;
	EndIf;
	Return ReturnValue;
EndFunction

#EndRegion

#Region Private

Procedure RefillCatalogs()
	MetadataObjectNames = New ValueTable;
	MetadataObjectNames.Columns.Add("ObjectName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullSynonym", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	For Each MetadataObject In Metadata.Catalogs Do
		NewRow = MetadataObjectNames.Add();
		NewRow.ObjectName = MetadataObject.Name;
		NewRow.ObjectFullName = MetadataObject.FullName();
		NewRow.ObjectFullSynonym = MetadataObject.Synonym;
	EndDo;
	ProcessRefill(MetadataObjectNames, Catalogs.ConfigurationMetadata.Catalogs);
EndProcedure

Procedure RefillDocuments()
	MetadataObjectNames = New ValueTable();
	MetadataObjectNames.Columns.Add("ObjectName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullName", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	MetadataObjectNames.Columns.Add("ObjectFullSynonym", Metadata.Catalogs.ConfigurationMetadata.Attributes["ObjectFullName"].Type);
	For Each MetadataObject In Metadata.Documents Do
		NewRow = MetadataObjectNames.Add();
		NewRow.ObjectName = MetadataObject.Name;
		NewRow.ObjectFullName = MetadataObject.FullName();
		NewRow.ObjectFullSynonym = MetadataObject.Synonym;
	EndDo;
	ProcessRefill(MetadataObjectNames, Catalogs.ConfigurationMetadata.Documents);
EndProcedure

Procedure ProcessRefill(MetadataObjectNames, Parent)
	Query = New Query;
	Query.Text = "SELECT
	|	MetadataObjectNames.ObjectName,
	|	MetadataObjectNames.ObjectFullName,
	|	MetadataObjectNames.ObjectFullSynonym
	|INTO MetadataObjectNames
	|FROM
	|	&MetadataObjectNames AS MetadataObjectNames
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|//[1]
	|SELECT
	|	ConfigurationMetadata.Ref
	|FROM
	|	Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|WHERE
	|	NOT ConfigurationMetadata.Unused
	|	AND NOT ConfigurationMetadata.ObjectFullName IN (&ObjectFullNames)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|
	|//[2]
	|SELECT
	|	MetadataObjectNames.ObjectName,
	|	MetadataObjectNames.ObjectFullName,
	|	MetadataObjectNames.ObjectFullSynonym,
	|	IsNull(ConfigurationMetadata.Ref, Value(Catalog.ConfigurationMetadata.EmptyRef)) AS Ref
	|FROM
	|	MetadataObjectNames AS MetadataObjectNames
	|		Left JOIN Catalog.ConfigurationMetadata AS ConfigurationMetadata
	|		ON MetadataObjectNames.ObjectFullName = ConfigurationMetadata.ObjectFullName
	|WHERE
	|	ConfigurationMetadata.Ref IS Null
	|	OR IsNull(ConfigurationMetadata.Unused, FALSE)";
	Query.SetParameter("MetadataObjectNames", MetadataObjectNames);
	Query.SetParameter("ObjectFullNames", MetadataObjectNames.UnloadColumn("ObjectFullName"));
	QueryResults = Query.ExecuteBatch();
	
	ItemsForMarkingAsUnused = QueryResults[1].Unload();
	For Each Item In ItemsForMarkingAsUnused Do
		ItemObject = Item.Ref.GetObject();
		ItemObject.Unused = True;
		ItemObject.Write();
	EndDo;
	
	ItemsForCreate = QueryResults[2].Unload();
	For Each Item In ItemsForCreate Do
		If Item.Ref.IsEmpty() Then
			ItemObject = Catalogs.ConfigurationMetadata.CreateItem();
			ItemObject.ObjectName = Item.ObjectName;
			ItemObject.ObjectFullName = Item.ObjectFullName;
			ItemObject.Description = Item.ObjectFullSynonym;
			ItemObject.Parent = Parent;
		Else
			ItemObject = Item.Ref.GetObject();
			ItemObject.Unused = False;
		EndIf;
		ItemObject.Write();
	EndDo;	
EndProcedure

#EndRegion
