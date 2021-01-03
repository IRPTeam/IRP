Function ItemsInfo(Parameters, AddInfo = Undefined) Export
	Query = ItemInfo_Query(Parameters, AddInfo);
	
	QueryResult = Query.Execute().Unload();
	
	Return QueryResult;
EndFunction

Function ItemInfo_Query(Parameters, AddInfo)

	Var Query;
	Query = New Query;
	Query.Text =
		"SELECT
		|	Items.Ref AS Item,
		|	PRESENTATION(Items.Ref) AS ItemPresentation
		|INTO ItemVT
		|FROM
		|	Catalog.Items AS Items
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemKeys.Ref AS ItemKey,
		|   &PriceType AS PriceType,
		|	ItemKeys.Item AS Item,
		|	ItemVT.ItemPresentation AS ItemPresentation,
		|	ItemKeys.Item.ItemType AS ItemType,
		|	NestedSelect.QuantityBalance AS Remaining,
		|	ISNULL(ItemKeys.Item.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(PriceList.Price, 0) AS Price,
		|	0 AS Quantity,
		|	0 AS TotalAmount,
		|	0 AS NetAmount,
		|	0 AS TaxAmount,
		|	CAST("""" AS STRING(200)) AS Info,
		|	0 AS OffersAmount
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|		LEFT JOIN (SELECT
		|			PricesSliceLast.ItemKey AS ItemKey,
		|			PricesSliceLast.Price AS Price,
		|			PricesSliceLast.Unit AS Unit
		|		FROM
		|			InformationRegister.PricesByItemKeys.SliceLast(
		|					&Period,
		|					PriceType = &PriceType
		|						AND ItemKey.Item IN
		|							(SELECT
		|								ItemVT.Item
		|							FROM
		|								ItemVT)) AS PricesSliceLast) AS PriceList
		|		ON ItemKeys.Ref = PriceList.ItemKey
		|			AND ItemKeys.Item.Unit = PriceList.Unit
		|		INNER JOIN ItemVT AS ItemVT
		|		ON ItemKeys.Item = ItemVT.Item
		|		LEFT JOIN (SELECT
		|			ItemsInStoresBalance.ItemKey AS ItemKey,
		|			ItemsInStoresBalance.QuantityBalance AS QuantityBalance
		|		FROM
		|			AccumulationRegister.ItemsInStores.Balance(
		|					&Period,
		|					Store = &Store
		|						AND ItemKey.Item IN
		|							(SELECT
		|								ItemVT.Item
		|							FROM
		|								ItemVT)) AS ItemsInStoresBalance) AS NestedSelect
		|		ON ItemKeys.Ref = NestedSelect.ItemKey
		|
		|GROUP BY
		|	ItemKeys.Ref,
		|	ItemKeys.Item.ItemType,
		|	PriceList.Price,
		|	ItemVT.ItemPresentation,
		|	ItemKeys.Item,
		|	ISNULL(ItemKeys.Item.Unit, VALUE(Catalog.Units.EmptyRef)),
		|	NestedSelect.QuantityBalance
		|
		|ORDER BY
		|	ItemPresentation
		|AUTOORDER";
	
	QueryScheme = New QuerySchema();
	QueryScheme.SetQueryText(Query.Text);
	
	If ValueIsFilled(Parameters.ItemType) Then
		
		ItemVT = QueryScheme.QueryBatch.Get(0);
		Filters = ItemVT.Operators[0].Filter;
		
		Expression = "Items.%1 IN HIERARCHY(&%1)";
		
		Filters.Add(New QuerySchemaExpression(StrTemplate(Expression, "ItemType")));
	EndIf;
	
	If ValueIsFilled(Parameters.SearchString) Then
		
		ItemVT = QueryScheme.QueryBatch.Get(0);
		Filters = ItemVT.Operators[0].Filter;
		
		Expression = "Items.Description_" + SessionParameters.LocalizationCode + " LIKE " + Char(34) + "%" + Parameters.SearchString + "%" + Char(34);
		
		Filters.Add(New QuerySchemaExpression(Expression));
	EndIf;
	
	For Each Parameter In Parameters Do
		Query.Parameters.Insert(Parameter.Key, Parameter.Value);
	EndDo;
	
	If Not Query.Parameters.Property("Period") Then
		Query.Parameters.Insert("Period", CurrentUniversalDate());
	EndIf;
	
	Query.Text = QueryScheme.GetQueryText();
	
	Return Query;
EndFunction

Function SpecialOffersInfo(Parameters, AddInfo = Undefined) Export
	Query = SpecialOffersInfo_Query(Parameters, AddInfo);
	
	QueryResult = Query.Execute().Unload(QueryResultIteration.ByGroups);
	
	Return QueryResult;
EndFunction

Function SpecialOffersInfo_Query(Parameters, AddInfo)
	Query = New Query();
	Query.Text =
		"SELECT
		|	SpecialOffers.Ref AS SpecialOffers,
		|	SpecialOffers.IsFolder AS IsFolder
		|FROM
		|	Catalog.SpecialOffers AS SpecialOffers
		|WHERE
		|	NOT SpecialOffers.DeletionMark
		|	AND
		|	NOT SpecialOffers.IsFolder
		|ORDER BY
		|	SpecialOffers.IsFolder,
		|	SpecialOffers.Ref
		|TOTALS
		|BY
		|	SpecialOffers ONLY HIERARCHY";
	
	Return Query;
EndFunction

// Description
// 
// Parameters:
// 	TableItemKeys
// 	* ItemKey
// 	* PriceType
// 	* Unit
// 	Period
// 	AddInfo - Undefined - Description
// Returns:
// 	ValueTable - Description:
// * ItemKey - CatalogRef.ItemKeys -
// * PriceType - CatalogRef.PriceTypes -
// * Unit - CatalogRef.Units -
// * Price 
// * Price 
Function ItemPriceInfoByTable(TableItemKeys, Period, AddInfo = Undefined) Export
	
	TableOfResults = New ValueTable();
	TableOfResults.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	TableOfResults.Columns.Add("PriceType", New TypeDescription("CatalogRef.PriceTypes"));
	TableOfResults.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	TableOfResults.Columns.Add("ItemKeyUnit", New TypeDescription("CatalogRef.Units"));
	TableOfResults.Columns.Add("ItemUnit", New TypeDescription("CatalogRef.Units"));
	TableOfResults.Columns.Add("Price", Metadata.DefinedTypes.typePrice.Type);
	TableOfResults.Columns.Add("hasSpecification", New TypeDescription("Boolean"));
	TableWithSpecification = TableOfResults.CopyColumns();
	
	TableWithOutSpecification = TableOfResults.CopyColumns();
	
	For Each Row In TableItemKeys Do
		If Row.hasSpecification Then
			NewRow = TableWithSpecification.Add();
		Else
			NewRow = TableWithOutSpecification.Add();
		EndIf;
		
		NewRow.ItemKey = Row.ItemKey;
		NewRow.PriceType = Row.PriceType;
		NewRow.Unit = Row.Unit;
		NewRow.ItemUnit = Row.ItemUnit;
		NewRow.ItemKeyUnit = Row.ItemKeyUnit;
	EndDo;
	
	TableWithSpecification.GroupBy("ItemKey, PriceType, Unit, ItemUnit, ItemKeyUnit");
	
	TableWithSpecificationCopy = TableWithSpecification.Copy();
	TableWithSpecificationCopy.GroupBy("ItemKey, PriceType");
	
	QuerySelection = QueryByItemPriceInfo_Specification(TableWithSpecificationCopy, Period);
	
	FillTableOfResults(QuerySelection, TableWithSpecification, TableOfResults);
	
	TableWithOutSpecification.GroupBy("ItemKey, PriceType, Unit, ItemUnit, ItemKeyUnit");
	
	TableWithOutSpecificationCopy = TableWithOutSpecification.Copy();
	TableWithOutSpecificationCopy.GroupBy("ItemKey, PriceType");
	
	QuerySelection = QueryByItemPriceInfo(TableWithOutSpecificationCopy, Period);
	
	FillTableOfResults(QuerySelection, TableWithOutSpecification, TableOfResults);
	
	Return TableOfResults;
EndFunction

Procedure FillTableOfResults(QuerySelection, Table, TableOfResults)
	QuerySelection.Reset();
	TempMap = New Map;
	For Each Row In Table Do
		If Not QuerySelection.FindNext(New Structure("ItemKey, PriceType", Row.ItemKey, Row.PriceType)) Then
			Continue;
		EndIf;
		
		NewRow = TableOfResults.Add();
		FillPropertyValues(NewRow, Row);
		Price = ?(ValueIsFilled(QuerySelection.Price), QuerySelection.Price, 0);
		If ValueIsFilled(Row.Unit) Then
			ToUnit = ?(ValueIsFilled(Row.ItemKeyUnit), Row.ItemKeyUnit, Row.ItemUnit);
			If ValueIsFilled(ToUnit) Then
				If TempMap.Get(Row.Unit) = Undefined Then
					UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit, ToUnit);
					Tmp = New Map;
					Tmp.Insert(ToUnit, UnitFactor);
					TempMap.Insert(Row.Unit, Tmp);
				ElsIf TempMap.Get(Row.Unit).Get(ToUnit) = Undefined Then
					UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit, ToUnit);
					TempMap.Get(Row.Unit).Insert(ToUnit, UnitFactor);
				Else
					UnitFactor = TempMap.Get(Row.Unit).Get(ToUnit);
				EndIf;
			Else
				UnitFactor = 1;
			EndIf;
			NewRow.Price = Price * UnitFactor;
		Else
			NewRow.Price = Price;
		EndIf;
	EndDo;
	
EndProcedure

Function ItemPriceInfo(Parameters, AddInfo = Undefined) Export
	
	ItemTable = New ValueTable();
	ItemTable.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	ItemTable.Columns.Add("PriceType", New TypeDescription("CatalogRef.PriceTypes"));
	
	NewRowItemList = ItemTable.Add();
	NewRowItemList.ItemKey = Parameters.ItemKey;
	NewRowItemList.PriceType = ?(Parameters.Property("RowPriceType"), Parameters.RowPriceType, Parameters.PriceType);
	
	QueryParameterPeriod = Parameters.Period;
	
	If ValueIsFilled(Parameters.ItemKey.Specification) Then
		QuerySelection = QueryByItemPriceInfo_Specification(ItemTable, QueryParameterPeriod);
	Else
		QuerySelection = QueryByItemPriceInfo(ItemTable, QueryParameterPeriod);
	EndIf;
	
	If QuerySelection.Next() Then
		Result = New Structure();
		Price = ?(ValueIsFilled(QuerySelection.Price), QuerySelection.Price, 0);
		If ValueIsFilled(Parameters.Unit) Then
			ItemKeyUnit = Parameters.ItemKey.Unit;
			ItemUnit = Parameters.ItemKey.Item.Unit;
			ToUnit = ?(ValueIsFilled(ItemKeyUnit), ItemKeyUnit, ItemUnit);
			UnitFactor = ?(ValueIsFilled(ToUnit), Catalogs.Units.GetUnitFactor(Parameters.Unit, ToUnit), 1);
			Result.Insert("Price", Price * UnitFactor);
		Else
			Result.Insert("Price", Price);
		EndIf;
		
		Result.Insert("ItemKey", QuerySelection.ItemKey);
		Result.Insert("PriceType", QuerySelection.PriceType);
		Return Result;
	EndIf;
EndFunction

Function QueryByItemPriceInfo_Specification(ItemList, Period, AddInfo = Undefined) Export
	
	Query = New Query();
	Query.SetParameter("ItemList", ItemList);
	Query.SetParameter("Period", Period);
	
	Query.Text =
		"SELECT
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.PriceType AS PriceType
		|INTO tmp
		|FROM
		|	&ItemList AS ItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemKeys.Ref AS ItemKey,
		|	ItemKeys.Item AS Item,
		|	ItemKeys.Specification AS Specification,
		|	ItemKeysSpecificationAffectPricingMD5.Key AS Key,
		|	ItemKeysSpecificationAffectPricingMD5.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp.PriceType AS PriceType
		|INTO t_ItemKeys
		|FROM
		|	tmp AS tmp
		|		INNER JOIN Catalog.ItemKeys AS ItemKeys
		|		ON tmp.ItemKey = ItemKeys.Ref
		|		AND ItemKeys.Specification <> VALUE(Catalog.Specifications.EmptyRef)
		|		INNER JOIN Catalog.ItemKeys.SpecificationAffectPricingMD5 AS ItemKeysSpecificationAffectPricingMD5
		|		ON tmp.ItemKey = ItemKeysSpecificationAffectPricingMD5.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.ItemKey AS ItemKey,
		|	MAX(CASE
		|		WHEN tmp.Specification.Type = VALUE(Enum.SpecificationType.Bundle)
		|			THEN SpecificationsDataSet.Item
		|		ELSE tmp.Item
		|	END) AS Item,
		|	tmp.Specification AS Specification,
		|	ISNULL(SpecificationsDataQuantity.Quantity, 0) AS Quantity,
		|	tmp.Key AS Key,
		|	tmp.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp.PriceType AS PriceType
		|INTO t_SpecificationRows
		|FROM
		|	t_ItemKeys AS tmp
		|		LEFT JOIN Catalog.Specifications.DataSet AS SpecificationsDataSet
		|		ON tmp.Specification = SpecificationsDataSet.Ref
		|		AND tmp.Key = SpecificationsDataSet.Key
		|		LEFT JOIN Catalog.Specifications.DataQuantity AS SpecificationsDataQuantity
		|		ON tmp.Specification = SpecificationsDataQuantity.Ref
		|		AND tmp.Key = SpecificationsDataQuantity.Key
		|GROUP BY
		|	tmp.ItemKey,
		|	tmp.Item,
		|	tmp.Specification,
		|	ISNULL(SpecificationsDataQuantity.Quantity, 0),
		|	tmp.Key,
		|	tmp.AffectPricingMD5,
		|	tmp.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecificationRows.ItemKey AS ItemKey,
		|	SpecificationRows.Specification AS Specification,
		|	SpecificationRows.Item AS Item,
		|	SpecificationRows.PriceType AS PriceType,
		|	SpecificationRows.AffectPricingMD5 AS AffectPricingMD5,
		|	SpecificationRows.Key AS Key,
		|	SpecificationRows.Quantity AS Quantity,
		|	ISNULL(PricesByItemKeysSliceLast.Price, 0) AS Price
		|INTO t_PricesByItemKeys
		|FROM
		|	t_SpecificationRows AS SpecificationRows
		|		LEFT JOIN InformationRegister.PricesByItemKeys.SliceLast(&Period, (PriceType, ItemKey) IN
		|			(SELECT
		|				tmp.PriceType,
		|				tmp.ItemKey
		|			FROM
		|				tmp AS tmp)) AS PricesByItemKeysSliceLast
		|		ON SpecificationRows.ItemKey = PricesByItemKeysSliceLast.ItemKey
		|		AND SpecificationRows.PriceType = PricesByItemKeysSliceLast.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp2.ItemKey AS ItemKey,
		|	tmp2.Specification AS Specification,
		|	tmp2.Item AS Item,
		|	tmp2.PriceType AS PriceType,
		|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp2.Key AS Key,
		|	tmp2.Quantity AS Quantity
		|INTO tmp2
		|FROM
		|	t_PricesByItemKeys AS tmp2
		|WHERE
		|	tmp2.Price = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PriceKeys.Ref AS PriceKey,
		|	tmp2.ItemKey AS ItemKey,
		|	tmp2.Specification AS Specification,
		|	tmp2.Quantity AS Quantity,
		|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp2.Key AS Key,
		|	tmp2.Item AS Item,
		|	tmp2.PriceType AS PriceType
		|INTO t_PriceKeys
		|FROM
		|	tmp2 AS tmp2
		|		LEFT JOIN Catalog.PriceKeys AS PriceKeys
		|		ON tmp2.AffectPricingMD5 = PriceKeys.AffectPricingMD5
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PriceKeys.PriceKey AS PriceKey,
		|	PriceKeys.ItemKey AS ItemKey,
		|	PriceKeys.Specification AS Specification,
		|	PriceKeys.Quantity AS Quantity,
		|	PriceKeys.AffectPricingMD5 AS AffectPricingMD5,
		|	PriceKeys.Key AS Key,
		|	PriceKeys.Item AS Item,
		|	PriceKeys.PriceType AS PriceType,
		|	ISNULL(PricesByPropertiesSliceLast.Price, 0) * PriceKeys.Quantity AS Price
		|INTO t_PricesByProperties
		|FROM
		|	t_PriceKeys AS PriceKeys
		|		LEFT JOIN InformationRegister.PricesByProperties.SliceLast(&Period, (PriceType, PriceKey) IN
		|			(SELECT
		|				tmp.PriceType,
		|				tmp.PriceKey
		|			FROM
		|				t_PriceKeys AS tmp)) AS PricesByPropertiesSliceLast
		|		ON PriceKeys.PriceKey = PricesByPropertiesSliceLast.PriceKey
		|		AND PriceKeys.PriceType = PricesByPropertiesSliceLast.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp3.PriceKey AS PriceKey,
		|	tmp3.ItemKey AS ItemKey,
		|	tmp3.Specification AS Specification,
		|	tmp3.Quantity AS Quantity,
		|	tmp3.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp3.Key AS Key,
		|	tmp3.Item AS Item,
		|	tmp3.PriceType AS PriceType
		|INTO tmp3
		|FROM
		|	t_PricesByProperties AS tmp3
		|WHERE
		|	tmp3.Price = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp3.PriceKey AS PriceKey,
		|	tmp3.ItemKey AS ItemKey,
		|	tmp3.Specification AS Specification,
		|	tmp3.Quantity AS Quantity,
		|	tmp3.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp3.Key AS Key,
		|	tmp3.Item AS Item,
		|	tmp3.PriceType AS PriceType,
		|	ISNULL(PricesByItemsSliceLast.Price, 0) * tmp3.Quantity AS Price,
		|	tmp3.Quantity AS Q,
		|	PricesByItemsSliceLast.Price AS P
		|INTO t_PricesByItems
		|FROM
		|	tmp3 AS tmp3
		|		LEFT JOIN InformationRegister.PricesByItems.SliceLast(&Period, (PriceType, Item) IN
		|			(SELECT
		|				tmp.PriceType,
		|				tmp.Item
		|			FROM
		|				tmp3 AS tmp)) AS PricesByItemsSliceLast
		|		ON tmp3.Item = PricesByItemsSliceLast.Item
		|		AND tmp3.PriceType = PricesByItemsSliceLast.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecificationRows.ItemKey AS ItemKey,
		|	SpecificationRows.Item AS Item,
		|	SpecificationRows.Specification AS Specification,
		|	SpecificationRows.Quantity AS Quantity,
		|	SpecificationRows.Key AS Key,
		|	SpecificationRows.AffectPricingMD5 AS AffectPricingMD5,
		|	SpecificationRows.PriceType AS PriceType,
		|	ISNULL(t_PricesByItemKeys.Price, 0) AS PriceByItemKeys,
		|	ISNULL(t_PricesByProperties.Price, 0) AS PriceByProperties,
		|	ISNULL(t_PricesByItems.Price, 0) AS PriceByItems
		|INTO t_PriceDetails
		|FROM
		|	t_SpecificationRows AS SpecificationRows
		|		LEFT JOIN t_PricesByItemKeys AS t_PricesByItemKeys
		|		ON SpecificationRows.ItemKey = t_PricesByItemKeys.ItemKey
		|		AND SpecificationRows.PriceType = t_PricesByItemKeys.PriceType
		|		AND SpecificationRows.AffectPricingMD5 = t_PricesByItemKeys.AffectPricingMD5
		|		AND t_PricesByItemKeys.Price <> 0
		|		AND SpecificationRows.Key = t_PricesByItemKeys.Key
		|		LEFT JOIN t_PricesByProperties AS t_PricesByProperties
		|		ON SpecificationRows.ItemKey = t_PricesByProperties.ItemKey
		|		AND SpecificationRows.PriceType = t_PricesByProperties.PriceType
		|		AND SpecificationRows.AffectPricingMD5 = t_PricesByProperties.AffectPricingMD5
		|		AND t_PricesByProperties.Price <> 0
		|		AND SpecificationRows.Key = t_PricesByProperties.Key
		|		LEFT JOIN t_PricesByItems AS t_PricesByItems
		|		ON SpecificationRows.ItemKey = t_PricesByItems.ItemKey
		|		AND SpecificationRows.PriceType = t_PricesByItems.PriceType
		|		AND SpecificationRows.AffectPricingMD5 = t_PricesByItems.AffectPricingMD5
		|		AND t_PricesByItems.Price <> 0
		|		AND SpecificationRows.Key = t_PricesByItems.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	t_PriceDetails.ItemKey AS ItemKey,
		|	t_PriceDetails.PriceType AS PriceType,
		|	MAX(t_PriceDetails.PriceByItemKeys) + SUM(t_PriceDetails.PriceByProperties) + SUM(t_PriceDetails.PriceByItems) AS
		|		Price
		|FROM
		|	t_PriceDetails AS t_PriceDetails
		|GROUP BY
		|	t_PriceDetails.ItemKey,
		|	t_PriceDetails.PriceType";
	
	QuerySelection = Query.Execute().Select();
	Return QuerySelection;
EndFunction

Function QueryByItemPriceInfo(ItemList, Period, AddInfo = Undefined) Export
	
	Query = New Query();
	Query.SetParameter("ItemList", ItemList);
	Query.SetParameter("Period", Period);
	
	Query.Text =
		"SELECT
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.PriceType AS PriceType
		|INTO tmp
		|FROM
		|	&ItemList AS ItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemKeys.Ref AS ItemKey,
		|	ItemKeys.Specification AS Specification,
		|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
		|	ItemKeys.Item AS Item,
		|	tmp.PriceType AS PriceType
		|INTO t_ItemKeys
		|FROM
		|	tmp AS tmp
		|		INNER JOIN Catalog.ItemKeys AS ItemKeys
		|		ON tmp.ItemKey = ItemKeys.Ref
		|		AND ItemKeys.Specification = VALUE(Catalog.Specifications.EmptyRef)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemKeys.ItemKey AS ItemKey,
		|	ItemKeys.Specification AS Specification,
		|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
		|	ItemKeys.Item AS Item,
		|	ItemKeys.PriceType AS PriceType,
		|	ISNULL(PricesByItemKeysSliceLast.Price, 0) AS Price
		|INTO t_PricesByItemKeys
		|FROM
		|	t_ItemKeys AS ItemKeys
		|		LEFT JOIN InformationRegister.PricesByItemKeys.SliceLast(&Period, (PriceType, ItemKey) IN
		|			(SELECT
		|				tmp.PriceType,
		|				tmp.ItemKey
		|			FROM
		|				tmp AS tmp)) AS PricesByItemKeysSliceLast
		|		ON ItemKeys.ItemKey = PricesByItemKeysSliceLast.ItemKey
		|		AND ItemKeys.PriceType = PricesByItemKeysSliceLast.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp2.ItemKey AS ItemKey,
		|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp2.Item AS Item,
		|	tmp2.PriceType AS PriceType
		|INTO tmp2
		|FROM
		|	t_PricesByItemKeys AS tmp2
		|WHERE
		|	tmp2.Price = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PriceKeys.Ref AS PriceKey,
		|	tmp2.ItemKey AS ItemKey,
		|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
		|	tmp2.Item AS Item,
		|	tmp2.PriceType AS PriceType
		|INTO t_PriceKeys
		|FROM
		|	tmp2 AS tmp2
		|		LEFT JOIN Catalog.PriceKeys AS PriceKeys
		|		ON tmp2.AffectPricingMD5 = PriceKeys.AffectPricingMD5
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	PriceKeys.ItemKey AS ItemKey,
		|	PriceKeys.Item AS Item,
		|	PriceKeys.PriceType AS PriceType,
		|	ISNULL(PricesByPropertiesSliceLast.Price, 0) AS Price
		|INTO t_PricesByProperties
		|FROM
		|	t_PriceKeys AS PriceKeys
		|		LEFT JOIN InformationRegister.PricesByProperties.SliceLast(&Period, (PriceType, PriceKey) IN
		|			(SELECT
		|				tmp.PriceType,
		|				tmp.PriceKey
		|			FROM
		|				t_PriceKeys AS tmp)) AS PricesByPropertiesSliceLast
		|		ON PriceKeys.PriceKey = PricesByPropertiesSliceLast.PriceKey
		|		AND PriceKeys.PriceType = PricesByPropertiesSliceLast.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp3.ItemKey AS ItemKey,
		|	tmp3.Item AS Item,
		|	tmp3.PriceType AS PriceType
		|INTO tmp3
		|FROM
		|	t_PricesByProperties AS tmp3
		|WHERE
		|	tmp3.Price = 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp3.ItemKey AS ItemKey,
		|	tmp3.Item AS Item,
		|	tmp3.PriceType AS PriceType,
		|	ISNULL(PricesByItemsSliceLast.Price, 0) AS Price
		|INTO t_PricesByItems
		|FROM
		|	tmp3 AS tmp3
		|		LEFT JOIN InformationRegister.PricesByItems.SliceLast(&Period, (PriceType, Item) IN
		|			(SELECT
		|				tmp.PriceType,
		|				tmp.Item
		|			FROM
		|				tmp3 AS tmp)) AS PricesByItemsSliceLast
		|		ON tmp3.Item = PricesByItemsSliceLast.Item
		|		AND tmp3.PriceType = PricesByItemsSliceLast.PriceType
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemKeys.ItemKey AS ItemKey,
		|	ItemKeys.Specification AS Specification,
		|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
		|	ItemKeys.Item AS Item,
		|	ItemKeys.PriceType AS PriceType,
		|	ISNULL(t_PricesByItemKeys.Price, 0) AS PriceByItemKeys,
		|	ISNULL(t_PricesByProperties.Price, 0) AS PriceByProperties,
		|	ISNULL(t_PricesByItems.Price, 0) AS PriceByItems,
		|	CASE
		|		WHEN ISNULL(t_PricesByItemKeys.Price, 0) <> 0
		|			THEN ISNULL(t_PricesByItemKeys.Price, 0)
		|		WHEN ISNULL(t_PricesByProperties.Price, 0) <> 0
		|			THEN ISNULL(t_PricesByProperties.Price, 0)
		|		WHEN ISNULL(t_PricesByItems.Price, 0) <> 0
		|			THEN ISNULL(t_PricesByItems.Price, 0)
		|	END AS Price
		|FROM
		|	t_ItemKeys AS ItemKeys
		|		LEFT JOIN t_PricesByItemKeys AS t_PricesByItemKeys
		|		ON ItemKeys.ItemKey = t_PricesByItemKeys.ItemKey
		|		AND ItemKeys.PriceType = t_PricesByItemKeys.PriceType
		|		LEFT JOIN t_PricesByProperties AS t_PricesByProperties
		|		ON ItemKeys.ItemKey = t_PricesByProperties.ItemKey
		|		AND ItemKeys.PriceType = t_PricesByProperties.PriceType
		|		LEFT JOIN t_PricesByItems AS t_PricesByItems
		|		ON ItemKeys.ItemKey = t_PricesByItems.ItemKey
		|		AND ItemKeys.PriceType = t_PricesByItems.PriceType";
	
	QuerySelection = Query.Execute().Select();  
	Return QuerySelection;
EndFunction

Function ItemUnitInfo(ItemKey) Export
	If ValueIsFilled(ItemKey) Then
		If ValueIsFilled(ItemKey.Unit) Then
			Return New Structure("Unit", ItemKey.Unit);
		EndIf;
		If ValueIsFilled(ItemKey.Item) Then
			Return New Structure("Unit", ItemKey.Item.Unit);
		EndIf;
	EndIf;
	Return New Structure("Unit", Undefined);
EndFunction

Function GetUnitFactor(ItemKey, Unit) Export
	Return Catalogs.Units.GetUnitFactor(Unit, ItemKey.Item.Unit);
EndFunction