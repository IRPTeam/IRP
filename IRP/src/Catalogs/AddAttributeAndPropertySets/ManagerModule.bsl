
#Region Public

//
Procedure SynchronizeItemKeysAttributes() Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	ItemTypesAvailableAttributes.Attribute AS Attribute
		|FROM
		|	Catalog.ItemTypes.AvailableAttributes AS ItemTypesAvailableAttributes
		|WHERE
		|	NOT ItemTypesAvailableAttributes.Ref.DeletionMark
		|GROUP BY
		|	ItemTypesAvailableAttributes.Attribute";
	QueryResult = Query.Execute();
	ArrayOfAttributes = QueryResult.Unload().UnloadColumn("Attribute");
	SynchronizeAttributes(Catalogs.AddAttributeAndPropertySets.Catalog_ItemKeys, ArrayOfAttributes);
EndProcedure

//
Procedure SynchronizePriceKeysAttributes() Export
	Query = New Query();
	Query.Text =
		"SELECT
		|	ItemTypesAvailableAttributes.Attribute AS Attribute
		|FROM
		|	Catalog.ItemTypes.AvailableAttributes AS ItemTypesAvailableAttributes
		|WHERE
		|	NOT ItemTypesAvailableAttributes.Ref.DeletionMark
		|	AND ItemTypesAvailableAttributes.AffectPricing
		|GROUP BY
		|	ItemTypesAvailableAttributes.Attribute";
	QueryResult = Query.Execute();
	ArrayOfAttributes = QueryResult.Unload().UnloadColumn("Attribute");
	SynchronizeAttributes(Catalogs.AddAttributeAndPropertySets.Catalog_PriceKeys, ArrayOfAttributes);
EndProcedure

//
Function GetExtensionAttributesListByObjectMetadata(ObjectMetadata) Export
	ObjectDataName = StrReplace(ObjectMetadata.FullName(), ".", "_");
	
	Query = New Query;
	Query.Text = "SELECT
	|	AddAttributeAndPropertySets.Ref,
	|	AddAttributeAndPropertySets.PredefinedDataName
	|FROM
	|	Catalog.AddAttributeAndPropertySets AS AddAttributeAndPropertySets
	|WHERE
	|	AddAttributeAndPropertySets.Predefined";
	PredefinedAddAttributeAndPropertySets = Query.Execute().Unload();
	PredefinedNameFilter = New Structure;
	PredefinedNameFilter.Insert("PredefinedDataName", ObjectDataName);
	FoundRefs = PredefinedAddAttributeAndPropertySets.FindRows(PredefinedNameFilter);
	If FoundRefs.Count() Then
		AddAttributeAndPropertySetRef = FoundRefs[0].Ref;
	Else
		AddAttributeAndPropertySetRef = Catalogs.AddAttributeAndPropertySets.EmptyRef();
	EndIf;
	
	AttributeNames = New Array;
	For Each Attribute In ObjectMetadata.Attributes Do
		AttributeNames.Add(Attribute.Name);
	EndDo;
	Query = New Query();
	Query.Text = "SELECT
		|	ExtensionAttributes.Attribute AS Attribute,
		|	ExtensionAttributes.InterfaceGroup,
		|	ExtensionAttributes.Required,
		|	ExtensionAttributes.ShowInHTML
		|FROM
		|	Catalog.AddAttributeAndPropertySets.ExtensionAttributes AS ExtensionAttributes
		|WHERE
		|	ExtensionAttributes.Show
		|	AND ExtensionAttributes.Attribute IN (&AttributeNames)
		|	AND ExtensionAttributes.Ref = &AddAttributeAndPropertySetRef";
	Query.SetParameter("AttributeNames", AttributeNames);
	Query.SetParameter("AddAttributeAndPropertySetRef", AddAttributeAndPropertySetRef);	
	Return Query.Execute().Unload();
EndFunction

#EndRegion

#Region Private

Procedure SynchronizeAttributes(Set, ArrayOfAttributes)
	If Not TransactionActive() Then
		BeginTransaction(DataLockControlMode.Managed);
		Try
			WriteDataToObject(Set, ArrayOfAttributes);
			If TransactionActive() Then
				CommitTransaction();
			EndIf;
		Except
			If TransactionActive() Then
				RollbackTransaction();
			EndIf;
		EndTry;
	Else
		WriteDataToObject(Set, ArrayOfAttributes);
	EndIf;
EndProcedure

Procedure WriteDataToObject(Set, ArrayOfAttributes)
	DataSource = New ValueTable();
	DataSource.Columns.Add("Ref", New TypeDescription("CatalogRef.AddAttributeAndPropertySets"));
	DataSource.Add().Ref = Set;
	
	DataLock = New DataLock();
	ItemLock = DataLock.Add("Catalog.AddAttributeAndPropertySets");
	ItemLock.Mode = DataLockMode.Exclusive;
	ItemLock.DataSource = DataSource;
	ItemLock.UseFromDataSource("Ref", "Ref");
	DataLock.Lock();
	
	CatalogObject = Set.GetObject();
	CatalogObject.Attributes.Clear();
	For Each Attribute In ArrayOfAttributes Do
		CatalogObject.Attributes.Add().Attribute = Attribute;
	EndDo;
	
	CatalogObject.Write();
EndProcedure

#EndRegion
