
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString) Then
		Return;
	EndIf;

	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	CatalogsServer.SetParametersForDataChoosing(Catalogs.ItemKeys, Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);		
EndProcedure

Function GetChoiceDataTable(Parameters)
	Filter = "";
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "CustomSearchFilter" OR FilterItem.Key = "AdditionalParameters" Then
			Continue; // Service properties
		EndIf;
		Filter = Filter
			+ "
		|	AND Table." + FilterItem.Key + " = &" + FilterItem.Key;
	EndDo;			 
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.ItemKeys);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	CommonFormActionsServer.SetStandardSearchFilter(QueryBuilder, Parameters, Metadata.Catalogs.ItemKeys);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);
	For Each Filter In Parameters.Filter Do
		Query.SetParameter(Filter.Key, Filter.Value);
	EndDo;
	
	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);

	Return Query.Execute().Unload();	
EndFunction

Function GetRefsBySearchString(ItemRef, SearchString) Export
	Parameters = New Structure();
	Parameters.Insert("Filter", New Structure("Item", ItemRef));
	Parameters.Insert("SearchString", SearchString);
	DataTable = GetChoiceDataTable(Parameters);
	Return DataTable.UnloadColumn("Ref");
EndFunction

Function GetRefsByProperties(TableOfProperties, Item, AddInfo = Undefined) Export
	If Not TableOfProperties.Count() Then
		Query = New Query();
		Query.Text =
		"SELECT
		|	ItemKeys.Ref
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|WHERE
		|	ItemKeys.Item = &Item";
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
	|	ItemKeysAddAttributes.Ref
	|FROM
	|	Catalog.ItemKeys.AddAttributes AS ItemKeysAddAttributes
	|WHERE
	|	&Attribute = ItemKeysAddAttributes.Property
	|	AND &Value = ItemKeysAddAttributes.Value
	|	AND &Item = ItemKeysAddAttributes.Ref.Item
	|	AND CASE
	|		WHEN &FilterByResults
	|			THEN ItemKeysAddAttributes.Ref IN (&ArrayOfResults)
	|		ELSE TRUE
	|	END
	|GROUP BY
	|	ItemKeysAddAttributes.Ref";

	Query.SetParameter("Attribute", Attribute);
	Query.SetParameter("Value", Value);
	Query.SetParameter("Item", Item);
	Query.SetParameter("ArrayOfResults", ArrayOfFoundedItemKeys);
	Query.SetParameter("FilterByResults", ArrayOfFoundedItemKeys.Count() > 0);

	Return Query.Execute().Unload().UnloadColumn("Ref");
EndFunction

Function GetRefsByPropertiesWithSpecifications(TableOfProperties, Item, AddInfo = Undefined) Export
	If Not TableOfProperties.Count() Then
		Query = New Query();
		Query.Text =
		"SELECT
		|	ItemKeys.Ref
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|WHERE
		|	ItemKeys.Item = &Item";
		Query.SetParameter("Item", Item);
		Return Query.Execute().Unload().UnloadColumn("Ref");
	EndIf;

	ArrayOfFoundedItemKeys = New Array();
	For Each PropertiesRow In TableOfProperties Do
		ArrayOfFoundedItemKeys = GetRefsByOnePropertyWithSpecifications(ArrayOfFoundedItemKeys, Item,
			PropertiesRow.Attribute, PropertiesRow.Value);
		If Not ArrayOfFoundedItemKeys.Count() Then
			Return ArrayOfFoundedItemKeys;
		EndIf;
	EndDo;
	Return ArrayOfFoundedItemKeys;
EndFunction

Function GetRefsByOnePropertyWithSpecifications(ArrayOfFoundedItemKeys, Item, Attribute, Value)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Table.Ref,
	|	Table.Specification,
	|	CASE
	|		WHEN Table.Specification = VALUE(Catalog.Specifications.EmptyRef)
	|			THEN FALSE
	|		ELSE TRUE
	|	END AS IsSpecification
	|INTO tItemKeys
	|FROM
	|	Catalog.ItemKeys AS Table
	|WHERE
	|	&Item = Table.Item
	|	AND CASE
	|		WHEN &FilterByResults
	|			THEN Table.Ref IN (&ArrayOfResults)
	|		ELSE TRUE
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tItemKeys.Ref
	|FROM
	|	tItemKeys AS tItemKeys
	|		INNER JOIN Catalog.ItemKeys.AddAttributes AS ItemKeysAddAttributes
	|		ON tItemKeys.Ref = ItemKeysAddAttributes.Ref
	|		AND NOT tItemKeys.IsSpecification
	|		AND &Attribute = ItemKeysAddAttributes.Property
	|		AND &Value = ItemKeysAddAttributes.Value
	|
	|UNION
	|
	|SELECT
	|	tItemKeys.Ref
	|FROM
	|	tItemKeys AS tItemKeys
	|		INNER JOIN Catalog.Specifications.DataSet AS SpecificationsDataSet
	|		ON tItemKeys.Specification = SpecificationsDataSet.Ref
	|		AND tItemKeys.IsSpecification
	|		AND &Attribute = SpecificationsDataSet.Attribute
	|		AND &Value = SpecificationsDataSet.Value";

	Query.SetParameter("Attribute", Attribute);
	Query.SetParameter("Value", Value);
	Query.SetParameter("Item", Item);
	Query.SetParameter("ArrayOfResults", ArrayOfFoundedItemKeys);
	Query.SetParameter("FilterByResults", ArrayOfFoundedItemKeys.Count() > 0);

	Return Query.Execute().Unload().UnloadColumn("Ref");
EndFunction

Function GetUniqueItemKeyByItem(Item) Export
	Query = New Query();
	Query.Text = 
	"SELECT TOP 2
	|	Table.Ref
	|FROM
	|	Catalog.ItemKeys AS Table
	|WHERE
	|	&Item = Table.Item
	|	AND NOT Table.DeletionMark";
	Query.SetParameter("Item", Item);

	Selection = Query.Execute().Select();
	If Selection.Count() = 1 Then
		Selection.Next();
		Return Selection.Ref;
	EndIf;
	Return EmptyRef();
EndFunction

Procedure UpdateDescriptions(ItemKeyObject, DescriptionsUpdated = False) Export
	For Each Lang In LocalizationReuse.AllDescription() Do
		If ValueIsFilled(ItemKeyObject.Specification) Then
			NewName = ItemKeyObject.Item[Lang] + "/" + ItemKeyObject.Specification[Lang];
		Else
			NewName = LocalizationServer.CatalogDescriptionWithAddAttributes(ItemKeyObject, StrSplit(Lang, "_")[1]);
		EndIf;

		If Not ItemKeyObject[Lang] = NewName Then
			DescriptionsUpdated = True;
			ItemKeyObject[Lang] = NewName;
		EndIf;
	EndDo;
EndProcedure

#Region Bundling

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

Function CreateRefByProperties(TableOfProperties, Item, AddInfo = Undefined) Export
	NewObject = CreateItem();
	NewObject.Item = Item;
	For Each TableOfPropertiesRow In TableOfProperties Do
		NewRowAddAttributes = NewObject.AddAttributes.Add();
		NewRowAddAttributes.Property = TableOfPropertiesRow.Attribute;
		NewRowAddAttributes.Value = TableOfPropertiesRow.Value;
	EndDo;
	NewObject.Write();
	Return NewObject.Ref;
EndFunction

Function FindOrCreateRefBySpecification(Specification, Item, AddInfo = Undefined) Export
	ItemKeyRef = GetRefsBySpecification(Specification, Item, AddInfo);
	If Not ValueIsFilled(ItemKeyRef) Then
		Return CreateRefsBySpecification(Specification, Item, AddInfo);
	Else
		Return ItemKeyRef;
	EndIf;
EndFunction

Function CreateRefsBySpecification(Specification, Item, AddInfo = Undefined) Export
	NewObject = CreateItem();
	NewObject.Item = Item;
	NewObject.Specification = Specification;
	NewObject.Write();
	Return NewObject.Ref;
EndFunction

Function GetRefsBySpecification(Specification, Item, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemKeys.Ref
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Item = &Item
	|	AND ItemKeys.Specification = &Specification
	|GROUP BY
	|	ItemKeys.Ref";
	Query.SetParameter("Item", Item);
	Query.SetParameter("Specification", Specification);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return EmptyRef();
	EndIf;
EndFunction

Function GetWaysToFillItemListByBundle(ItemKeyBundle, AddInfo = Undefined) Export
	Result = New Structure("BySpecification, ByBundling", False, False);
	If Not ValueIsFilled(ItemKeyBundle) Then
		Return Result;
	EndIf;

	If ValueIsFilled(ItemKeyBundle.Specification) Then
		Result.BySpecification = True;
	EndIf;

	Query = New Query();
	Query.Text =
	"SELECT TOP 1
	|	BundleContentsSliceLast.ItemKeyBundle
	|FROM
	|	InformationRegister.BundleContents.SliceLast AS BundleContentsSliceLast
	|WHERE
	|	BundleContentsSliceLast.ItemKeyBundle = &ItemKeyBundle";
	Query.SetParameter("ItemKeyBundle", ItemKeyBundle);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Result.ByBundling = True;
	EndIf;

	Return Result;
EndFunction

Function GetTableByBundleContent(ItemKeyBundle, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	BundleContentsSliceLast.ItemKeyBundle,
	|	BundleContentsSliceLast.ItemKey.Item AS Item,
	|	BundleContentsSliceLast.ItemKey,
	|	BundleContentsSliceLast.Quantity,
	|	BundleContentsSliceLast.Quantity AS QuantityInBaseUnit,
	|	CASE
	|		WHEN BundleContentsSliceLast.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN BundleContentsSliceLast.ItemKey.Unit
	|		ELSE BundleContentsSliceLast.ItemKey.Item.Unit
	|	END AS Unit
	|FROM
	|	InformationRegister.BundleContents.SliceLast(, ItemKeyBundle = &ItemKeyBundle) AS BundleContentsSliceLast";
	Query.SetParameter("ItemKeyBundle", ItemKeyBundle);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetTableBySpecification(ItemKeyBundle, AddInfo = Undefined) Export
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("ItemKeyBundle"      , New TypeDescription("CatalogRef.ItemKeys"));
	ResultTable.Columns.Add("Item"               , New TypeDescription("CatalogRef.Items"));
	ResultTable.Columns.Add("ItemKey"            , New TypeDescription("CatalogRef.ItemKeys"));
	ResultTable.Columns.Add("Quantity"           , New TypeDescription("Number"));
	ResultTable.Columns.Add("QuantityInBaseUnit" , New TypeDescription("Number"));
	ResultTable.Columns.Add("Unit"               , New TypeDescription("CatalogRef.Units"));

	Query = New Query();
	Query.Text =
	"SELECT
	|	CASE
	|		WHEN SpecificationsDataSet.Ref.Type = VALUE(Enum.SpecificationType.Bundle)
	|			THEN SpecificationsDataSet.Item
	|		ELSE &ItemKeyBundle_ItemKey
	|	END AS Item,
	|	SpecificationsDataSet.Attribute,
	|	SpecificationsDataSet.Value,
	|	SpecificationsDataQuantity.Quantity,
	|	SpecificationsDataSet.Key
	|FROM
	|	Catalog.Specifications.DataSet AS SpecificationsDataSet
	|		INNER JOIN Catalog.Specifications.DataQuantity AS SpecificationsDataQuantity
	|		ON SpecificationsDataQuantity.Ref = SpecificationsDataSet.Ref
	|		AND SpecificationsDataQuantity.Key = SpecificationsDataSet.Key
	|		AND SpecificationsDataQuantity.Ref = &ItemKeyBundle_Specification
	|		AND SpecificationsDataSet.Ref = &ItemKeyBundle_Specification";

	Query.SetParameter("ItemKeyBundle_Specification", ItemKeyBundle.Specification);
	Query.SetParameter("ItemKeyBundle_ItemKey", ItemKeyBundle.Item);

	QueryResult = Query.Execute();

	QueryTable = QueryResult.Unload();
	QueryTableCopy = QueryTable.Copy();
	QueryTableCopy.GroupBy("Key");

	For Each QueryTableCopyRow In QueryTableCopy Do
		Filter = New Structure("Key", QueryTableCopyRow.Key);
		TableOfProperties = QueryTable.Copy(Filter);
		Quantity = TableOfProperties[0].Quantity;
		Item = TableOfProperties[0].Item;
		TableOfProperties.GroupBy("Attribute, Value");

		ArrayOfItemKeys = FindOrCreateRefByProperties(TableOfProperties, Item, AddInfo);

		ItemKey = Undefined;
		If Not ArrayOfItemKeys.Count() Then
			Continue;
		EndIf;

		ItemKey = ArrayOfItemKeys[0];

		NewRowResultTable = ResultTable.Add();
		NewRowResultTable.ItemKeyBundle      = ItemKeyBundle;
		NewRowResultTable.Item               = ItemKey.Item;
		NewRowResultTable.ItemKey            = ItemKey;
		NewRowResultTable.Quantity           = Quantity;
		NewRowResultTable.QuantityInBaseUnit = Quantity;
		NewRowResultTable.Unit = ?(ValueIsFilled(ItemKey.Unit), ItemKey.Unit, ItemKey.Item.Unit);
	EndDo;

	Return ResultTable;
EndFunction

#EndRegion

#Region AffectPricingMD5

Procedure SynchronizeAffectPricingMD5ByItemType(ItemType) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemKeys.Ref AS ItemKey,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Item.ItemType AS ItemType,
	|	ItemKeys.AffectPricingMD5,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.Specification.Type AS SpecificationType
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Item.ItemType = &ItemType";
	Query.SetParameter("ItemType", ItemType);
	QueryResult = Query.Execute();
	SynchronizeAffectPricingMD5(QueryResult.Select());
EndProcedure

Procedure SynchronizeAffectPricingMD5BySpecification(Specification) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	ItemKeys.Ref AS ItemKey,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Item.ItemType AS ItemType,
	|	ItemKeys.AffectPricingMD5,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.Specification.Type AS SpecificationType
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Specification = &Specification";
	Query.SetParameter("Specification", Specification);
	QueryResult = Query.Execute();
	SynchronizeAffectPricingMD5(QueryResult.Select());
EndProcedure

Procedure SynchronizeAffectPricingMD5(QuerySelection)

	While QuerySelection.Next() Do
		NeedWrite = False;
		AffectPricingMD5 = Undefined;
		TableOfAffectPricingMD5 = Undefined;

		If ValueIsFilled(QuerySelection.Specification) Then
			If QuerySelection.SpecificationType = Enums.SpecificationType.Set Then
				TableOfAffectPricingMD5 = CalculateMD5ForSet(QuerySelection.Specification.DataQuantity.Unload(),
					QuerySelection.Specification.DataSet.Unload(), QuerySelection.Item, QuerySelection.ItemType);
			EndIf;
			If QuerySelection.SpecificationType = Enums.SpecificationType.Bundle Then
				TableOfAffectPricingMD5 = CalculateMD5ForBundle(QuerySelection.Specification.DataQuantity.Unload(),
					QuerySelection.Specification.DataSet.Unload(), QuerySelection.Item, QuerySelection.ItemType);
			EndIf;

			ExistTableOfAffectPricingMD5 = GetResultTableMD5ForSpecification();
			For Each Row In QuerySelection.ItemKey.SpecificationAffectPricingMD5 Do
				FillPropertyValues(ExistTableOfAffectPricingMD5.Add(), Row);
			EndDo;

			If TableOfAffectPricingMD5 <> Undefined 
				And CommonFunctionsServer.GetMD5(TableOfAffectPricingMD5) <> CommonFunctionsServer.GetMD5(ExistTableOfAffectPricingMD5) Then
				NeedWrite = True;
			EndIf;

		Else
			AffectPricingMD5 = AddAttributesAndPropertiesServer.GetAffectPricingMD5(QuerySelection.Item, QuerySelection.ItemType,
				QuerySelection.ItemKey.AddAttributes.Unload());
			If AffectPricingMD5 <> QuerySelection.AffectPricingMD5 Then
				NeedWrite = True;
			EndIf;
		EndIf;

		If NeedWrite Then
			ItemKeyObject = QuerySelection.ItemKey.GetObject();
			ItemKeyObject.AdditionalProperties.Insert("SynchronizeAffectPricingMD5", True);
			If AffectPricingMD5 <> Undefined Then
				ItemKeyObject.AdditionalProperties.Insert("AffectPricingMD5", AffectPricingMD5);
			EndIf;
			If TableOfAffectPricingMD5 <> Undefined Then
				ItemKeyObject.AdditionalProperties.Insert("TableOfAffectPricingMD5", TableOfAffectPricingMD5);
			EndIf;
			ItemKeyObject.Write();
		EndIf;
	EndDo;
EndProcedure

Function CalculateMD5ForSet(TableOfDataQuantity, TableOfDataSet, Item, ItemType) Export
	Return CalculateMD5ForSpecification(TableOfDataQuantity, TableOfDataSet, Item, ItemType);
EndFunction

Function CalculateMD5ForBundle(TableOfDataQuantity, TableOfDataSet, Item, ItemType) Export
	Return CalculateMD5ForSpecification(TableOfDataQuantity, TableOfDataSet, Undefined, Undefined);
EndFunction

Function CalculateMD5ForSpecification(TableOfDataQuantity, TableOfDataSet, Item = Undefined, ItemType = Undefined)
	TableOfResult = GetResultTableMD5ForSpecification();
	For Each Row In TableOfDataQuantity Do
		TableOfAddAttributes = TableOfDataSet.Copy(New Structure("Key", Row.Key));
		If TableOfAddAttributes.Count() Then
			NewRow = TableOfResult.Add();
			NewRow.Key = Row.Key;
			TableOfAddAttributes.Columns.Attribute.Name = "Property";
			If Item <> Undefined And ItemType <> Undefined Then
				NewRow.AffectPricingMD5 = AddAttributesAndPropertiesServer.GetAffectPricingMD5(Item, ItemType,
					TableOfAddAttributes);
			Else
				NewRow.AffectPricingMD5 = AddAttributesAndPropertiesServer.GetAffectPricingMD5(
					TableOfAddAttributes[0].Item, TableOfAddAttributes[0].Item.ItemType, TableOfAddAttributes);
			EndIf;
		EndIf;
	EndDo;
	Return TableOfResult;
EndFunction

Function GetResultTableMD5ForSpecification()
	TableOfResult = New ValueTable();
	TableOfResult.Columns.Add("Key");
	TableOfResult.Columns.Add("AffectPricingMD5");
	Return TableOfResult;
EndFunction

#EndRegion
