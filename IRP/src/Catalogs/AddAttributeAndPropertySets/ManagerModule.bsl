Procedure SinhronizeItemKeysAttributes() Export
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
	SinhronizeAttributes(Catalogs.AddAttributeAndPropertySets.Catalog_ItemKeys, ArrayOfAttributes);
EndProcedure

Procedure SinhronizePriceKeysAttributes() Export
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
	SinhronizeAttributes(Catalogs.AddAttributeAndPropertySets.Catalog_PriceKeys, ArrayOfAttributes);
EndProcedure

Procedure SinhronizeAttributes(Set, ArrayOfAttributes)
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
