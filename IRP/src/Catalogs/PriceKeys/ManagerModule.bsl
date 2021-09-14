Function GetTableByPriceList(PriceListRef, AddInfo = Undefined) Export
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("PriceList"  , New TypeDescription("DocumentRef.PriceList"));
	ResultTable.Columns.Add("PriceKey"   , New TypeDescription("CatalogRef.PriceKeys"));
	ResultTable.Columns.Add("Item"       , New TypeDescription("CatalogRef.Items"));
	ResultTable.Columns.Add("InputUnit"  , New TypeDescription("CatalogRef.Units"));
	ResultTable.Columns.Add("Price"      , New TypeDescription(Metadata.DefinedTypes.typePrice.Type));
	ResultTable.Columns.Add("InputPrice" , New TypeDescription(Metadata.DefinedTypes.typePrice.Type));

	Query = New Query();
	Query.Text =
	"SELECT
	|	PriceListDataSet.Attribute,
	|	PriceListDataSet.Value,
	|	PriceListDataSet.Key,
	|   PriceListDataSet.Ref AS PriceList,
	|	PriceListDataPrice.Price,
	|	PriceListDataPrice.Item,
	|	PriceListDataPrice.InputUnit,
	|	PriceListDataPrice.InputPrice
	|FROM
	|	Document.PriceList.DataSet AS PriceListDataSet
	|		INNER JOIN Document.PriceList.DataPrice AS PriceListDataPrice
	|		ON PriceListDataPrice.Ref = PriceListDataSet.Ref
	|		AND PriceListDataPrice.Key = PriceListDataSet.Key
	|		AND PriceListDataPrice.Ref = &PriceList
	|		AND PriceListDataSet.Ref = &PriceList";

	Query.SetParameter("PriceList", PriceListRef);

	QueryResult = Query.Execute();

	QueryTable = QueryResult.Unload();
	QueryTableCopy = QueryTable.Copy();
	QueryTableCopy.GroupBy("Key");

	For Each QueryTableCopyRow In QueryTableCopy Do
		Filter = New Structure("Key", QueryTableCopyRow.Key);
		TableOfProperties = QueryTable.Copy(Filter);
		Price      = TableOfProperties[0].Price;
		Item       = TableOfProperties[0].Item;
		PriceList  = TableOfProperties[0].PriceList;
		InputUnit  = TableOfProperties[0].InputUnit;
		InputPrice = TableOfProperties[0].InputPrice;
		
		TableOfProperties.GroupBy("Attribute, Value");

		ArrayOfItemKeys = FindOrCreateRefByProperties(TableOfProperties, Item, AddInfo);

		PriceKey = Undefined;
		If Not ArrayOfItemKeys.Count() Then
			Continue;
		EndIf;

		PriceKey = ArrayOfItemKeys[0];

		NewRowResultTable = ResultTable.Add();
		NewRowResultTable.PriceKey   = PriceKey;
		NewRowResultTable.Price      = Price;
		NewRowResultTable.Item       = Item;
		NewRowResultTable.PriceList  = PriceList;
		NewRowResultTable.InputUnit  = InputUnit;
		NewRowResultTable.InputPrice = InputPrice;		
	EndDo;

	Return ResultTable;
EndFunction

Function FindOrCreateRefByProperties(TableOfProperties, Item, AddInfo = Undefined) Export
	ArrayOfRefs = GetRefsByProperties(TableOfProperties, Item, AddInfo);
	If ArrayOfRefs.Count() Then
		Return ArrayOfRefs;
	Else
		ArrayOfResults = New Array();
		ArrayOfResults.Add(CreateRefByProperties(TableOfProperties, Item, AddInfo));
		Return ArrayOfResults;
	EndIf;
EndFunction

Function GetRefsByProperties(TableOfProperties, Item, AddInfo = Undefined) Export
	If Not TableOfProperties.Count() Then
		Query = New Query();
		Query.Text =
		"SELECT
		|	PriceKeys.Ref
		|FROM
		|	Catalog.PriceKeys AS PriceKeys
		|WHERE
		|	PriceKeys.Item = &Item";
		Query.SetParameter("Item", Item);
		Return Query.Execute().Unload().UnloadColumn("Ref");
	EndIf;

	ArrayOfFoundedItemKeys = New Array();
	For Each PropertiesRow In TableOfProperties Do
		ArrayOfFoundedItemKeys = GetRefsByOneProperty(ArrayOfFoundedItemKeys, Item, PropertiesRow.Attribute,
			PropertiesRow.Value);
		If Not ArrayOfFoundedItemKeys.Count() Then
			Return ArrayOfFoundedItemKeys;
		EndIf;
	EndDo;
	Return ArrayOfFoundedItemKeys;
EndFunction

Function GetRefsByOneProperty(ArrayOfFoundedItemKeys, Item, Attribute, Value)
	Query = New Query();
	Query.Text =
	"SELECT
	|	PriceKeysAddAttributes.Ref
	|FROM
	|	Catalog.PriceKeys.AddAttributes AS PriceKeysAddAttributes
	|WHERE
	|	&Attribute = PriceKeysAddAttributes.Property
	|	AND &Value = PriceKeysAddAttributes.Value
	|	AND &Item = PriceKeysAddAttributes.Ref.Item
	|	AND CASE
	|		WHEN &FilterByResults
	|			THEN PriceKeysAddAttributes.Ref IN (&ArrayOfResults)
	|		ELSE TRUE
	|	END
	|GROUP BY
	|	PriceKeysAddAttributes.Ref";

	Query.SetParameter("Attribute", Attribute);
	Query.SetParameter("Value", Value);
	Query.SetParameter("Item", Item);
	Query.SetParameter("ArrayOfResults", ArrayOfFoundedItemKeys);
	Query.SetParameter("FilterByResults", ArrayOfFoundedItemKeys.Count() > 0);

	Return Query.Execute().Unload().UnloadColumn("Ref");
EndFunction

Function CreateRefByProperties(TableOfProperties, Item, AddInfo = Undefined) Export
	NewObject = Catalogs.PriceKeys.CreateItem();
	NewObject.Item = Item;
	For Each TableOfPropertiesRow In TableOfProperties Do
		NewRowAddAttributes = NewObject.AddAttributes.Add();
		NewRowAddAttributes.Property = TableOfPropertiesRow.Attribute;
		NewRowAddAttributes.Value = TableOfPropertiesRow.Value;
	EndDo;
	NewObject.Write();
	Return NewObject.Ref;
EndFunction