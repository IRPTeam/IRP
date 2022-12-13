// @strict-types

// Description
// 
// Parameters:
// 	TableItemKeys - ValueTable:
// 	* ItemKey - CatalogRef.ItemKeys
// 	* Unit - CatalogRef.Units
// 	* ItemKeyUnit - CatalogRef.Units
// 	* ItemUnit - CatalogRef.Units
// 	* hasSpecification - Boolean
// 	* PriceType - CatalogRef.PriceTypes
// 	Period - Date
// 	AddInfo - Undefined - Description
// Returns:
// 	See GetTableOfResults 
Function ItemPriceInfoByTable(TableItemKeys, Period, AddInfo = Undefined) Export

	TableOfResults = GetTableOfResults();
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
	TableWithOutSpecification.Columns.Add("ToUnit");
	
	TableWithOutSpecificationCopy = TableWithOutSpecification.Copy();
	TableWithOutSpecificationCopy.GroupBy("ItemKey, PriceType, Unit");
	QuerySelection = QueryByItemPriceInfo(TableWithOutSpecificationCopy, Period);
    QuerySelection.Reset();
    ArrayForDelete = New Array();
    For Each Row In TableWithOutSpecification Do
    	Filter = New Structure();
    	Filter.Insert("ItemKey"   , Row.ItemKey);
    	Filter.Insert("PriceType" , Row.PriceType);
    	
    	BasisUnit = ?(ValueIsFilled(Row.ItemKeyUnit), Row.ItemKeyUnit, Row.ItemUnit);
    	
    	If Not QuerySelection.FindNext(Filter) Then
    		Row.ToUnit = Row.Unit;
    		Row.Unit = BasisUnit;
    		Continue;
    	EndIf;
    	Price = ?(ValueIsFilled(QuerySelection.Price), QuerySelection.Price, 0);
    	If Not ValueIsFilled(Price) Then
    		Row.ToUnit = Row.Unit;
    		Row.Unit = BasisUnit;
    		Continue;
    	EndIf;
    	NewRow = TableOfResults.Add();
    	FillPropertyValues(NewRow, Row);
    	NewRow.Price = Price;
    	ArrayForDelete.Add(Row);
    EndDo;
    
    For Each ItemForDelete In ArrayForDelete Do
    	TableWithOutSpecification.Delete(ItemForDelete);
    EndDo;
    
	TableWithOutSpecificationCopy = TableWithOutSpecification.Copy();
	TableWithOutSpecificationCopy.GroupBy("ItemKey, PriceType, Unit");
	QuerySelection = QueryByItemPriceInfo(TableWithOutSpecificationCopy, Period);    
	FillTableOfResults(QuerySelection, TableWithOutSpecification, TableOfResults);
	
	Return TableOfResults;
EndFunction

// Get tableof results.
// 
// Returns:
//  ValueTable - Get tableof results:
// * ItemKey - CatalogRef.ItemKeys -
// * PriceType - CatalogRef.PriceTypes -
// * Unit - CatalogRef.Units -
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * Price - DefinedType.typePrice -
// * hasSpecification - Boolean -
Function GetTableOfResults()
	TableOfResults = New ValueTable();
	TableOfResults.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"));
	TableOfResults.Columns.Add("PriceType", New TypeDescription("CatalogRef.PriceTypes"));
	TableOfResults.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	TableOfResults.Columns.Add("ItemKeyUnit", New TypeDescription("CatalogRef.Units"));
	TableOfResults.Columns.Add("ItemUnit", New TypeDescription("CatalogRef.Units"));
	TableOfResults.Columns.Add("Price", Metadata.DefinedTypes.typePrice.Type);
	TableOfResults.Columns.Add("hasSpecification", New TypeDescription("Boolean"));
	Return TableOfResults
EndFunction

// Fill table of results.
// 
// Parameters:
//  QuerySelection - QueryResultSelection - Query selection
//  Table - ValueTable - Table
//  TableOfResults - See GetTableOfResults
Procedure FillTableOfResults(QuerySelection, Table, TableOfResults)
	QuerySelection.Reset();
	TempMap = New Map();
	
	ToUnitIsPresent = Table.Columns.Find("ToUnit") <> Undefined;
	
	For Each Row In Table Do
		If Not QuerySelection.FindNext(New Structure("ItemKey, PriceType", Row.ItemKey, Row.PriceType)) Then
			Continue;
		EndIf;

		NewRow = TableOfResults.Add();
		FillPropertyValues(NewRow, Row);
		Price = ?(ValueIsFilled(QuerySelection.Price), QuerySelection.Price, 0);
		If ValueIsFilled(Row.Unit) Then
			
			If ToUnitIsPresent And ValueIsFilled(Row.ToUnit) Then
				ToUnit = Row.ToUnit;
			Else
				ToUnit = ?(ValueIsFilled(Row.ItemKeyUnit), Row.ItemKeyUnit, Row.ItemUnit); // CatalogRef.Units
			EndIf;
			
			If ValueIsFilled(ToUnit) Then
				UnitValue = TempMap.Get(Row.Unit); // Map
				If UnitValue = Undefined Then
					UnitFactor = Catalogs.Units.GetUnitFactor(ToUnit, Row.Unit);
					Tmp = New Map();
					Tmp.Insert(ToUnit, UnitFactor);
					TempMap.Insert(Row.Unit, Tmp);
				ElsIf UnitValue.Get(ToUnit) = Undefined Then
					UnitFactor = Catalogs.Units.GetUnitFactor(Row.Unit, ToUnit);
					UnitValue.Insert(ToUnit, UnitFactor);
				Else
					
					UnitFactor = UnitValue.Get(ToUnit); // Number
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

// Item price info.
// 
// Parameters:
//  Parameters - Structure:
// 	* ItemKey - CatalogRef.ItemKeys -
// 	* RowPriceType - CatalogRef.PriceTypes -
// 	* PriceType - CatalogRef.PriceTypes -
// 	* Period - Date -
// 	* Unit - CatalogRef.Units -
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Item price info:
// * Price - DefinedType.typePrice -
// * ItemKey - CatalogRef.ItemKeys -
// * PriceType - CatalogRef.PriceTypes -
Function ItemPriceInfo(Parameters, AddInfo = Undefined) Export
	Result = New Structure("ItemKey, PriceType, Price");
	
	ItemKeyUnit = Parameters.ItemKey.Unit;
	ItemUnit = Parameters.ItemKey.Item.Unit;
	BasisUnit = ?(ValueIsFilled(ItemKeyUnit), ItemKeyUnit, ItemUnit);
	
	ItemTable = New ValueTable();
	ItemTable.Columns.Add("ItemKey"   , New TypeDescription("CatalogRef.ItemKeys"));
	ItemTable.Columns.Add("PriceType" , New TypeDescription("CatalogRef.PriceTypes"));
	
	ItemTableRow = ItemTable.Add();
	ItemTableRow.ItemKey   = Parameters.ItemKey;
	ItemTableRow.PriceType = ?(Parameters.Property("RowPriceType"), Parameters.RowPriceType, Parameters.PriceType);
	
	Result.ItemKey   = ItemTableRow.ItemKey;
	Result.PriceType = ItemTableRow.PriceType;
	Result.Price     = 0;
	
	If ValueIsFilled(Parameters.ItemKey.Specification) Then
		QuerySelection = QueryByItemPriceInfo_Specification(ItemTable, Parameters.Period);
		If QuerySelection.Next() Then
			FillPropertyValues(Result, QuerySelection);
			Return MultiplyPriceByUnitFactor(Result, Parameters.Unit, BasisUnit);
		EndIf;
	EndIf;

	ItemTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ItemTable[0].Unit = Parameters.Unit;
		
	QuerySelection = QueryByItemPriceInfo(ItemTable, Parameters.Period);
	
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
		If ValueIsFilled(Result.Price) Then
			Return Result;
		EndIf;
	EndIf;	
			
	ItemTable[0].Unit = BasisUnit;
	QuerySelection = QueryByItemPriceInfo(ItemTable, Parameters.Period);
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
		Return MultiplyPriceByUnitFactor(Result, Parameters.Unit, BasisUnit);
	EndIf;
	
	Return Result;
EndFunction

Function MultiplyPriceByUnitFactor(Result, Unit, BasisUnit)
	Price = ?(ValueIsFilled(Result.Price), Result.Price, 0);
	If ValueIsFilled(Unit) Then
		UnitFactor = ?(ValueIsFilled(BasisUnit), Catalogs.Units.GetUnitFactor(Unit, BasisUnit), 1);
		Result.Price = Price * UnitFactor;
	Else
		Result.Price = Price;
	EndIf;
	Return Result;
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
	|SELECT ALLOWED
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
	|SELECT ALLOWED
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
	|SELECT ALLOWED
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
	Query.SetParameter("ItemList" , ItemList);
	Query.SetParameter("Period"   , Period);

	Query.Text =
	"SELECT
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Unit AS Unit,
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
	|	tmp.Unit AS Unit,
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
	|SELECT ALLOWED
	|	ItemKeys.ItemKey AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Unit AS Unit,
	|	ItemKeys.PriceType AS PriceType,
	|	ISNULL(PricesByItemKeysSliceLast.Price, 0) AS Price
	|INTO t_PricesByItemKeys
	|FROM
	|	t_ItemKeys AS ItemKeys
	|		LEFT JOIN InformationRegister.PricesByItemKeys.SliceLast(&Period) AS PricesByItemKeysSliceLast
	|		ON ItemKeys.ItemKey = PricesByItemKeysSliceLast.ItemKey
	|		AND ItemKeys.PriceType = PricesByItemKeysSliceLast.PriceType
	|		AND ItemKeys.Unit = PricesByItemKeysSliceLast.Unit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.ItemKey AS ItemKey,
	|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
	|	tmp2.Item AS Item,
	|	tmp2.Unit AS Unit,
	|	tmp2.PriceType AS PriceType
	|INTO tmp2
	|FROM
	|	t_PricesByItemKeys AS tmp2
	|WHERE
	|	tmp2.Price = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	PriceKeys.Ref AS PriceKey,
	|	tmp2.ItemKey AS ItemKey,
	|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
	|	tmp2.Item AS Item,
	|	tmp2.Unit AS Unit,
	|	tmp2.PriceType AS PriceType
	|INTO t_PriceKeys
	|FROM
	|	tmp2 AS tmp2
	|		LEFT JOIN Catalog.PriceKeys AS PriceKeys
	|		ON tmp2.AffectPricingMD5 = PriceKeys.AffectPricingMD5
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	PriceKeys.ItemKey AS ItemKey,
	|	PriceKeys.Item AS Item,
	|	PriceKeys.Unit AS Unit,
	|	PriceKeys.PriceType AS PriceType,
	|	ISNULL(PricesByPropertiesSliceLast.Price, 0) AS Price
	|INTO t_PricesByProperties
	|FROM
	|	t_PriceKeys AS PriceKeys
	|		LEFT JOIN InformationRegister.PricesByProperties.SliceLast(&Period) AS PricesByPropertiesSliceLast
	|		ON PriceKeys.PriceKey = PricesByPropertiesSliceLast.PriceKey
	|		AND PriceKeys.PriceType = PricesByPropertiesSliceLast.PriceType
	|		AND PriceKeys.Unit = PricesByPropertiesSliceLast.Unit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	tmp3.ItemKey AS ItemKey,
	|	tmp3.Item AS Item,
	|	tmp3.Unit AS Unit,
	|	tmp3.PriceType AS PriceType
	|INTO tmp3
	|FROM
	|	t_PricesByProperties AS tmp3
	|WHERE
	|	tmp3.Price = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	tmp3.ItemKey AS ItemKey,
	|	tmp3.Item AS Item,
	|	tmp3.Unit AS Unit,
	|	tmp3.PriceType AS PriceType,
	|	ISNULL(PricesByItemsSliceLast.Price, 0) AS Price
	|INTO t_PricesByItems
	|FROM
	|	tmp3 AS tmp3
	|		LEFT JOIN InformationRegister.PricesByItems.SliceLast(&Period, (PriceType, Item, Unit) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.Item,
	|				tmp.Unit
	|			FROM
	|				tmp3 AS tmp)) AS PricesByItemsSliceLast
	|		ON tmp3.Item = PricesByItemsSliceLast.Item
	|		AND tmp3.PriceType = PricesByItemsSliceLast.PriceType
	|		AND tmp3.Unit = PricesByItemsSliceLast.Unit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	ItemKeys.ItemKey AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Unit AS Unit,
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
	|		ELSE 0
	|	END AS Price
	|FROM
	|	t_ItemKeys AS ItemKeys
	|		LEFT JOIN t_PricesByItemKeys AS t_PricesByItemKeys
	|		ON ItemKeys.ItemKey = t_PricesByItemKeys.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByItemKeys.PriceType
	|		AND ItemKeys.Unit = t_PricesByItemKeys.Unit
	|		LEFT JOIN t_PricesByProperties AS t_PricesByProperties
	|		ON ItemKeys.ItemKey = t_PricesByProperties.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByProperties.PriceType
	|		AND ItemKeys.Unit = t_PricesByProperties.Unit
	|		LEFT JOIN t_PricesByItems AS t_PricesByItems
	|		ON ItemKeys.ItemKey = t_PricesByItems.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByItems.PriceType
	|		AND ItemKeys.Unit = t_PricesByItems.Unit";

	QuerySelection = Query.Execute().Select();
	Return QuerySelection;
EndFunction

// Item unit info.
// 
// Parameters:
//  ItemKeyOrItem - CatalogRef.ItemKeys, CatalogRef.Items -
// 
// Returns:
//  Structure - Item unit info:
// * Unit - CatalogRef.Units, Undefined -
Function ItemUnitInfo(ItemKeyOrItem) Export
	If ValueIsFilled(ItemKeyOrItem) Then
		If TypeOf(ItemKeyOrItem) = Type("CatalogRef.Items") Then
			Return New Structure("Unit", ItemKeyOrItem.Unit);
		ElsIf TypeOf(ItemKeyOrItem) = Type("CatalogRef.ItemKeys") Then
			If ValueIsFilled(ItemKeyOrItem.Unit) Then
				Return New Structure("Unit", ItemKeyOrItem.Unit);
			EndIf;
			If ValueIsFilled(ItemKeyOrItem.Item) Then
				Return New Structure("Unit", ItemKeyOrItem.Item.Unit);
			EndIf;
		Else
			Raise "Unsupported type";
		EndIf;
	EndIf;
	Return New Structure("Unit", Undefined);
EndFunction

// Get unit factor.
// 
// Parameters:
//  ItemKey - CatalogRef.ItemKeys
//  Unit - CatalogRef.Units
// 
// Returns:
//  Number - Get unit factor
Function GetUnitFactor(ItemKey, Unit) Export
	Return Catalogs.Units.GetUnitFactor(Unit, ItemKey.Item.Unit);
EndFunction

#Region GetInfo

// Get info by Items key.
// Parameters:
//	ItemsKey - CatalogRef.ItemKeys, Array of CatalogRef.ItemKeys -
//	AddInfo - Structure -
// 
// Returns:
//  Array of Structure:
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * Quantity - DefinedType.typeQuantity
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * Barcode  - DefinedType.typeBarcode
// * ItemType - CatalogRef.ItemTypes -
// * UseSerialLotNumber - Boolean -
Function GetInfoByItemsKey(ItemsKey, AddInfo = Undefined) Export
	ItemKeyArray = New Array;
	If TypeOf(ItemsKey) = Type("Array") Then
		ItemKeyArray = ItemsKey;
	Else
		ItemKeyArray.Add(ItemsKey);
	EndIf;
	
	ReturnValue = New Array();
	Query = New Query();
	Query.Text = "SELECT
	|	ItemKey.Ref AS ItemKey,
	|	ItemKey.Item AS Item,
	|	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber,
	|	VALUE(Catalog.SourceOfOrigins.EmptyRef) AS SourceOfOrigin,
	|	CASE WHEN ItemKey.Unit = VALUE(Catalog.Units.EmptyRef) THEN
	|		ItemKey.Item.Unit
	|	ELSE
	|		ItemKey.Unit
	|	END AS Unit,
	|	1 AS Quantity,
	|	ItemKey.Unit AS ItemKeyUnit,
	|	ItemKey.Item.Unit AS ItemUnit,
	|	NOT ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	"""" AS Barcode,
	|	ItemKey.Item.ItemType AS ItemType,
	|	ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Service) AS isService
	|FROM
	|	Catalog.ItemKeys AS ItemKey
	|WHERE
	|	ItemKey.Ref In (&ItemKeyArray)";
	Query.SetParameter("ItemKeyArray", ItemKeyArray);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return ReturnValue;
	EndIf;
	QueryUnload = QueryExecution.Unload();
	
	For Each Row In QueryUnload Do
		ItemStructure = New Structure();
		For Each Column In QueryUnload.Columns Do
			ItemStructure.Insert(Column.Name, Row[Column.Name]);
		EndDo;
		ReturnValue.Add(ItemStructure);
	EndDo;

	Return ReturnValue;

EndFunction

#EndRegion

#Region Search

// By barcode.
// 
// Parameters:
//  Barcodes - See BarcodeServer.GetBarcodeTable
// 
// Returns:
//  ValueTable - See GetStandardItemTable
Function ByBarcodeTable(Barcodes) Export
	StandardItemTable = GetStandardItemTable();
	
	Result = BarcodeServer.SearchByBarcodes_WithKey(Barcodes);
	
	For Each Row In Result Do
		NewRow = StandardItemTable.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	
	Return StandardItemTable;
EndFunction

// Get picture URL.
// 
// Parameters:
//  ItemRef - CatalogRef.Items, CatalogRef.ItemKeys - Item ref
// 
// Returns:
//  String - Get picture URL
Function GetPictureURL(ItemRef) Export
	PictureTable = PictureViewerServer.GetPicturesByObjectRef(ItemRef);
	If PictureTable.Count() Then
		Return PictureTable[0].Ref;
	EndIf;
	Return Catalogs.Files.EmptyRef();
EndFunction

// Get standard item table.
// 
// Returns:
//  ValueTable - Get standard item table:
// * Image  - CatalogRef.Files - URL to image
// * Key - String -
// * ItemType - CatalogRef.ItemTypes -
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * UseSerialLotNumber - Boolean -
// * Quantity - DefinedType.typeQuantity
// * Barcode  - DefinedType.typeBarcode
Function GetStandardItemTable() Export
	Table = New ValueTable();
	
	Table.Columns.Add("Key", New TypeDescription("String"), "Key", 15);
	Table.Columns.Add("Image", New TypeDescription("CatalogRef.Files"), "", 2);
	Table.Columns.Add("ItemType", New TypeDescription("CatalogRef.ItemTypes"), Metadata.Catalogs.ItemTypes.Synonym, 15);
	Table.Columns.Add("Item", New TypeDescription("CatalogRef.Items"), Metadata.Catalogs.Items.Synonym, 15);
	Table.Columns.Add("ItemKey", New TypeDescription("CatalogRef.ItemKeys"), Metadata.Catalogs.ItemKeys.Synonym, 15);
	Table.Columns.Add("SerialLotNumber", New TypeDescription("CatalogRef.SerialLotNumbers"), Metadata.Catalogs.SerialLotNumbers.Synonym, 15);
	Table.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"), Metadata.Catalogs.Units.Synonym, 10);
	Table.Columns.Add("hasSpecification", New TypeDescription("Boolean"), Metadata.Catalogs.ItemTypes.Synonym, 5);
	Table.Columns.Add("UseSerialLotNumber", New TypeDescription("Boolean"), Metadata.Catalogs.ItemTypes.Attributes.UseSerialLotNumber.Synonym, 5);
	
	Table.Columns.Add("Quantity", Metadata.DefinedTypes.typeQuantity.Type, Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 15);
	Table.Columns.Add("Barcode", Metadata.DefinedTypes.typeBarcode.Type, Metadata.InformationRegisters.Barcodes.Dimensions.Barcode.Synonym, 20);
	Return Table
EndFunction

// Search by item description.
// 
// Parameters:
//  DescriptionTable - See GetDescriptionTable
// 
// Returns:
//  See GetStandardItemTable
Function SearchByItemDescription(DescriptionTable) Export
	Return GetStandardItemTable();
EndFunction

// Search by item code.
// 
// Parameters:
//  CodeTable - See GetCodeTable
// 
// Returns:
//  See GetStandardItemTable
Function SearchByItemCode(CodeTable) Export
	Return GetStandardItemTable();
EndFunction

// Search by item key description.
// 
// Parameters:
//  DescriptionTable - See GetDescriptionTable
// 
// Returns:
//  See GetStandardItemTable
Function SearchByItemKeyDescription(DescriptionTable) Export
	Return GetStandardItemTable();
EndFunction

// Search by item key code.
// 
// Parameters:
//  CodeTable - See GetCodeTable
// 
// Returns:
//  See GetStandardItemTable
Function SearchByItemKeyCode(CodeTable) Export
	Return GetStandardItemTable();
EndFunction

// Get description table.
// 
// Returns:
//  ValueTable - Get description table:
// * Key - String
// * Description - String
// * Quantity - DefinedType.typeQuantity
Function GetDescriptionTable() Export
	Table = New ValueTable();
	Table.Columns.Add("Key", New TypeDescription("String"), "Key", 15);
	Table.Columns.Add("Description", Metadata.CommonAttributes.Description_en.Type, "Key", 15);
	Table.Columns.Add("Quantity", Metadata.DefinedTypes.typeQuantity.Type, Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 15);
	Return Table;
EndFunction

// Get code table.
// 
// Returns:
//  ValueTable - Get code table:
// * Key - String
// * Code - Number
// * Quantity - DefinedType.typeQuantity
Function GetCodeTable() Export
	Table = New ValueTable();
	Table.Columns.Add("Key", New TypeDescription("String"), "Key", 15);
	Table.Columns.Add("Code", Metadata.Catalogs.ItemKeys.StandardAttributes.Code.Type, "Key", 15);
	Table.Columns.Add("Quantity", Metadata.DefinedTypes.typeQuantity.Type, Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 15);
	Return Table;
EndFunction

#EndRegion
