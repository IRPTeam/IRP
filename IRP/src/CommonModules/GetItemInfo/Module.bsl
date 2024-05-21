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
	TableWithSpecification = TableOfResults.CopyColumns(); // See GetTableOfResults

	TableWithOutSpecification = TableOfResults.CopyColumns(); // See GetTableOfResults

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
	TableWithOutSpecification.Columns.Add("ToUnit", New TypeDescription("CatalogRef.Units"));
	
	TableWithOutSpecificationCopy = TableWithOutSpecification.Copy();
	TableWithOutSpecificationCopy.GroupBy("ItemKey, PriceType, Unit");
	QuerySelection = QueryByItemPriceInfo(TableWithOutSpecificationCopy, Period);
    QuerySelection.Reset();
    ArrayForDelete = New Array(); // Array of ValueTableRow
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
// * ToUnit - CatalogRef.Units -
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
	PriceType = ?(Parameters.Property("RowPriceType"), Parameters.RowPriceType, Parameters.PriceType);
	//@skip-check constructor-function-return-section
	Return ServerReuse.ItemPriceInfo(Parameters.Period, Parameters.ItemKey, Parameters.Unit, PriceType);
EndFunction

// Item price info.
// 
// Parameters:
//  Parameter_Period - Date - Parameter period
//  Parameter_ItemKey - CatalogRef.ItemKeys - Parameter item key
//  Parameter_Unit - CatalogRef.Units - Parameter unit
//  Parameter_PriceType - CatalogRef.PriceTypes - Parameter price type
// 
// Returns:
//  Structure - Item price info:
// 	* Price - DefinedType.typePrice, Number -
// 	* ItemKey - CatalogRef.ItemKeys -
// 	* PriceType - CatalogRef.PriceTypes -
Function _ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType) Export
	Result = New Structure;
	Result.Insert("ItemKey", Catalogs.ItemKeys.EmptyRef());
	Result.Insert("PriceType", Catalogs.PriceTypes.EmptyRef());
	Result.Insert("Price", 0);
	 
	ItemKeyUnit = Parameter_ItemKey.Unit;
	ItemUnit = Parameter_ItemKey.Item.Unit;
	BasisUnit = ?(ValueIsFilled(ItemKeyUnit), ItemKeyUnit, ItemUnit);
	
	ItemTable = New ValueTable();
	ItemTable.Columns.Add("ItemKey"   , New TypeDescription("CatalogRef.ItemKeys"));
	ItemTable.Columns.Add("PriceType" , New TypeDescription("CatalogRef.PriceTypes"));
	
	ItemTableRow = ItemTable.Add();
	ItemTableRow.ItemKey   = Parameter_ItemKey;
	ItemTableRow.PriceType = Parameter_PriceType;
	
	Result.ItemKey   = ItemTableRow.ItemKey;
	Result.PriceType = ItemTableRow.PriceType;
	Result.Price     = 0;
	
	If ValueIsFilled(Parameter_ItemKey.Specification) Then
		QuerySelection = QueryByItemPriceInfo_Specification(ItemTable, Parameter_Period);
		If QuerySelection.Next() Then
			FillPropertyValues(Result, QuerySelection);
			Return MultiplyPriceByUnitFactor(Result, Parameter_Unit, BasisUnit);
		EndIf;
	EndIf;

	ItemTable.Columns.Add("Unit", New TypeDescription("CatalogRef.Units"));
	ItemTable[0].Unit = Parameter_Unit;
		
	QuerySelection = QueryByItemPriceInfo(ItemTable, Parameter_Period);
	
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
		If ValueIsFilled(Result.Price) Then
			Return Result;
		EndIf;
	EndIf;	
			
	ItemTable[0].Unit = BasisUnit;
	QuerySelection = QueryByItemPriceInfo(ItemTable, Parameter_Period);
	If QuerySelection.Next() Then
		FillPropertyValues(Result, QuerySelection);
		Return MultiplyPriceByUnitFactor(Result, Parameter_Unit, BasisUnit);
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

// Query by item price info.
// 
// Parameters:
//  ItemList - ValueTable - Item list:
// * ItemKey - CatalogRef.ItemKeys -
// * PriceType - CatalogRef.PriceTypes -
// * Unit - CatalogRef.Units -
//  Period - Date - Period
//  AddInfo - Undefined - Add info
// 
// Returns:
//  QueryResultSelection - Query by item price info:
//	* ItemKey - CatalogRef.ItemKeys -
//	* Specification - CatalogRef.ItemKeys -
//	* AffectPricingMD5 - String -
//	* Item - CatalogRef.ItemKeys -
//	* Unit - CatalogRef.ItemKeys -
//	* PriceType - CatalogRef.ItemKeys -
//	* PriceByItemKeys - DefinedType.typePrice
//	* PriceByProperties - DefinedType.typePrice
//	* PriceByItems - DefinedType.typePrice
//	* Price - DefinedType.typePrice
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

// Fill vendor prices.
// 
// Parameters:
//  Object - FormDataStructure
Procedure FillVendorPricesInObject(Object) Export
		
	Query = New Query;
	Query.Text =
		"SELECT ALLOWED
		|	S1001L_VendorsPricesByItemKeySliceLast.Price AS LastVendorPrice,
		|	S1001L_VendorsPricesByItemKeySliceLast.ItemKey,
		|	S1001L_VendorsPricesByItemKeySliceLast.Currency AS LastVendorPriceCurrency
		|FROM
		|	InformationRegister.S1001L_VendorsPricesByItemKey.SliceLast(&Period, Partner = &Partner
		|	AND ItemKey IN (&ItemKeys)
		|	AND Currency = &Currency) AS S1001L_VendorsPricesByItemKeySliceLast";
	
	Query.SetParameter("Period", CurrentSessionDate());
	Query.SetParameter("Currency", Object.Currency);
	Query.SetParameter("Partner", Object.Partner);
	Query.SetParameter("ItemKeys", Object.ItemList.Unload().UnloadColumn("ItemKey"));
	
	TablePrices = Query.Execute().Unload(); // ValueTable
	TablePrices.Indexes.Add("ItemKey");
	
	For Each Row In Object.ItemList Do
		SearchRow = TablePrices.Find(Row.ItemKey, "ItemKey");
		If SearchRow <> Undefined Then
			FillPropertyValues(Row, SearchRow, "LastVendorPrice, LastVendorPriceCurrency");
		EndIf;	
	EndDo;
EndProcedure

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
// Has to be the same as See BarcodeServer.FillFoundedItems
// 
// Parameters:
//	ItemsKey - CatalogRef.ItemKeys, Array of CatalogRef.ItemKeys -
//	Agreement - CatalogRef.Agreements -
// 
// Returns:
//  Array of Structure:
//  * ItemType - CatalogRef.ItemTypes -
//  * Item - CatalogRef.Items -
//  * ItemKey - CatalogRef.ItemKeys -
//  * SerialLotNumber - CatalogRef.SerialLotNumbers -
//  * Unit - CatalogRef.Units -
//  * ItemKeyUnit - CatalogRef.Units -
//  * ItemUnit - CatalogRef.Units -
//  * Quantity - DefinedType.typeQuantity
//  * BarcodeEmpty - Boolean -
//  * SourceOfOrigin - CatalogRef.SourceOfOrigins -
//  * PriceType - CatalogRef.PriceTypes -
//  * Date  - Date -
//  * hasSpecification - Boolean -
//  * Barcode - String -
//  * UseSerialLotNumber - Boolean -
//  * isService - Boolean -
//  * isCertificate - Boolean -
//  * AlwaysAddNewRowAfterScan - Boolean -
//  * EachSerialLotNumberIsUnique - Boolean -
//  * ControlCodeString - Boolean -
//  * SourceOfOrigin - CatalogRef.SourceOfOrigins -
//  * ControlCodeStringType - EnumRef.ControlCodeStringType -
Function GetInfoByItemsKey(ItemsKey, Agreement = Undefined) Export
	ItemKeyArray = New Array; // Array Of CatalogRef.ItemKeys
	If TypeOf(ItemsKey) = Type("Array") Then
		ItemKeyArray = ItemsKey;
	Else
		//@skip-check invocation-parameter-type-intersect
		ItemKeyArray.Add(ItemsKey);
	EndIf;
	
	ReturnValue = New Array(); // Array Of Structure
	Query = New Query();
	Query.Text = "SELECT
	|	ItemKey.Item.ItemType AS ItemType,
	|	ItemKey.Item AS Item,
	|	ItemKey.Ref AS ItemKey,
	|	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber,
	|	CASE
	|		WHEN ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN ItemKey.Item.Unit
	|		ELSE ItemKey.Unit
	|	END AS Unit,
	|	ItemKey.Unit AS ItemKeyUnit,
	|	ItemKey.Item.Unit AS ItemUnit,
	|	1 AS Quantity,
	|	True AS BarcodeEmpty,
	|	&PriceType AS PriceType,
	|	&Date AS Date,
	|	NOT ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	"""" AS Barcode,
	|	ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Service) OR ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Certificate) AS isService,
	|	ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Certificate) AS IsCertificate,
	|	ItemKey.Item.ItemType.AlwaysAddNewRowAfterScan AS AlwaysAddNewRowAfterScan,
	|	False AS EachSerialLotNumberIsUnique,
	|	CASE WHEN &IgnoreCodeStringControl THEN 
	|		False 
	|	ELSE 
	|		ItemKey.Item.ControlCodeString 
	|	END AS ControlCodeString,
	|	VALUE(Catalog.SourceOfOrigins.EmptyRef) AS SourceOfOrigin,
	|	ItemKey.Item.ControlCodeStringType AS ControlCodeStringType
	|FROM
	|	Catalog.ItemKeys AS ItemKey
	|WHERE
	|	ItemKey.Ref In (&ItemKeyArray)";
	Query.SetParameter("ItemKeyArray", ItemKeyArray);
	Query.SetParameter("Date", CommonFunctionsServer.GetCurrentSessionDate());
	
	Try
		Query.SetParameter("IgnoreCodeStringControl", SessionParameters.Workstation.IgnoreCodeStringControl);
	Except
		Query.SetParameter("IgnoreCodeStringControl", False);
	EndTry;
		
	PriceType = ?(ValueIsFilled(Agreement), Agreement.PriceType, Undefined);
	Query.SetParameter("PriceType", PriceType);
	
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

// By serial lot number (string).
// 
// Parameters:
//  SerialLotNumbers - See SerialLotNumbersServer.GetSerialLotNumberTable
// 
// Returns:
//  ValueTable - See GetStandardItemTable
Function BySerialLotNumberStringTable(SerialLotNumbers) Export
	StandardItemTable = GetStandardItemTable();
	
	Result = SerialLotNumbersServer.SearchBySerialLotNumber_WithKey(SerialLotNumbers);
	
	For Each Row In Result Do
		NewRow = StandardItemTable.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	
	Return StandardItemTable;
EndFunction

// By Item and ItemKeys descriptions.
// 
// Parameters:
//  ItemAndItemKeysDescriptions - See GetItemInfo.GetItemAndItemKeysInputTable
// 
// Returns:
//  ValueTable - See GetStandardItemTable
Function ByItemAndItemKeysDescriptionsTable(ItemAndItemKeysDescriptions) Export
	StandardItemTable = GetStandardItemTable();
	
	Result = SearchByItemAndItemKeysDescriptions_WithKey(ItemAndItemKeysDescriptions);
	
	For Each Row In Result Do
		NewRow = StandardItemTable.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	
	Return StandardItemTable;
EndFunction

// Get standard item table.
// 
// Returns:
//  ValueTable - Get standard item table:
// * Key - String -
// * Quantity - DefinedType.typeQuantity
// * Item  - CatalogRef.Items -
// * ItemKey  - CatalogRef.ItemKeys -
Function GetItemAndItemKeysInputTable() Export
	
	Table = New ValueTable();
	
	Table.Columns.Add(
		"Key", 
		Metadata.DefinedTypes.typeDescription.Type, 
		"Key", 
		15);
		
	Table.Columns.Add(
		"Quantity", 
		Metadata.DefinedTypes.typeQuantity.Type, 
		Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 
		15);
		
	Table.Columns.Add(
		"Item", 
		New TypeDescription("CatalogRef.Items"), 
		Metadata.Catalogs.Items.Synonym, 
		30);
		
	Table.Columns.Add(
		"ItemKey", 
		New TypeDescription("CatalogRef.ItemKeys"), 
		Metadata.Catalogs.ItemKeys.Synonym, 
		30);
		
	Return Table;
	
EndFunction

// Search by Item and ItemKeys Code/Description.
// 
// Parameters:
//  GetItemAndItemKeysInputTable - See GetItemAndItemKeysInputTable
//  AddInfo - Structure
// 
// Returns:
//  ValueTable:
// * Key - String
// * Quantity - DefinedType.typeQuantity
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * Unit - CatalogRef.Units -
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * UseSerialLotNumber - Boolean -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * ItemType - CatalogRef.ItemTypes -
// * hasSpecification - Boolean -
// * Image - CatalogRef.Files -
Function SearchByItemAndItemKeysDescriptions_WithKey(GetItemAndItemKeysInputTable, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemAndItemKeysDescriptions.Key AS Key,
	|	Cast(ItemAndItemKeysDescriptions.ItemKey AS Catalog.ItemKeys) AS ItemKey,
	|	ItemAndItemKeysDescriptions.Quantity AS Quantity
	|INTO tmpInput
	|FROM
	|	&ItemAndItemKeysDescriptions AS ItemAndItemKeysDescriptions
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpInput.Key AS Key,
	|	tmpInput.Quantity AS Quantity,
	|	tmpInput.ItemKey AS ItemKeyRef,
	|	tmpInput.ItemKey.Item AS ItemRef
	|INTO tmpMain
	|FROM
	|	tmpInput AS tmpInput
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpMain.Key AS Key,
	|	tmpMain.Quantity AS Quantity,
	|	tmpMain.ItemRef AS Item,
	|	tmpMain.ItemKeyRef AS ItemKey,
	|	CASE
	|		WHEN tmpMain.ItemKeyRef.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN tmpMain.ItemKeyRef.Item.Unit
	|		ELSE tmpMain.ItemKeyRef.Unit
	|	END AS Unit,
	|	tmpMain.ItemKeyRef.Unit AS ItemKeyUnit,
	|	tmpMain.ItemRef.Unit AS ItemUnit,
	|	NOT tmpMain.ItemKeyRef.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	tmpMain.ItemRef.ItemType AS ItemType,
	|	tmpMain.ItemRef.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	VALUE(Catalog.SerialLotNumbers.EmptyRef) AS SerialLotNumber
	|INTO tmpFullData
	|FROM
	|	tmpMain AS tmpMain
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AttachedFiles.Owner AS Item,
	|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
	|	MAX(AttachedFiles.File) AS File,
	|	MIN(AttachedFiles.Priority) AS Priority
	|INTO Images
	|FROM
	|	InformationRegister.AttachedFiles AS AttachedFiles
	|		INNER JOIN tmpFullData AS MainData
	|		ON MainData.Item = AttachedFiles.Owner
	|WHERE
	|	AttachedFiles.Priority = 0
	|GROUP BY
	|	AttachedFiles.Owner,
	|	VALUE(Catalog.ItemKeys.EmptyRef)
	|
	|UNION ALL
	|
	|SELECT
	|	AttachedFiles.Owner.Item,
	|	AttachedFiles.Owner,
	|	MAX(AttachedFiles.File),
	|	MIN(AttachedFiles.Priority)
	|FROM
	|	InformationRegister.AttachedFiles AS AttachedFiles
	|		INNER JOIN tmpFullData AS MainData
	|		ON MainData.ItemKey = AttachedFiles.Owner
	|WHERE
	|	AttachedFiles.Priority = 0
	|GROUP BY
	|	AttachedFiles.Owner.Item,
	|	AttachedFiles.Owner
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MainData.ItemKey AS ItemKey,
	|	MainData.Item AS Item,
	|	MainData.SerialLotNumber AS SerialLotNumber,
	|	MainData.Unit AS Unit,
	|	MainData.ItemKeyUnit AS ItemKeyUnit,
	|	MainData.ItemUnit AS ItemUnit,
	|	MainData.hasSpecification AS hasSpecification,
	|	MainData.ItemType AS ItemType,
	|	MainData.UseSerialLotNumber AS UseSerialLotNumber,
	|	MainData.Key AS Key,
	|	MainData.Quantity AS Quantity,
	|	Images.File AS Image
	|FROM
	|	tmpFullData AS MainData
	|		LEFT JOIN Images AS Images
	|		ON CASE
	|			WHEN Images.ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|				THEN MainData.Item = Images.Item
	|			ELSE MainData.ItemKey = Images.ItemKey
	|		END";
	
	DescriptionLocal = "Description_" + LocalizationReuse.GetLocalizationCode();
	If Not DescriptionLocal = "Description_en" Then
		Query.Text = StrReplace(Query.Text, "Description_en", DescriptionLocal);
	EndIf;
	
	Query.SetParameter("ItemAndItemKeysDescriptions", GetItemAndItemKeysInputTable);
	QueryExecution = Query.Execute();
	QueryUnload = QueryExecution.Unload();
	
	Return QueryUnload;

EndFunction

// Search item by string.
// 
// Parameters:
//  ItemString - String - Item
// 
// Returns:
//  Array of CatalogRef.Items - Search item by string
Function SearchItemByString(ItemString) Export
	
	If IsBlankString(ItemString) Then
		Return New Array;
	EndIf;
	
	ItemNumber = CommonFunctionsClientServer.GetSearchStringNumber(StrReplace(ItemString, " ", ""));
	
	Query = New Query;
	Query.SetParameter("ItemNumber", ItemNumber);
	Query.SetParameter("Item", ItemString);
	
	Query.Text =
	"SELECT
	|	Items.Ref
	|FROM
	|	Catalog.Items AS Items
	|WHERE
	|	NOT Items.DeletionMark
	|	AND Items.ItemID = &Item
	|
	|UNION
	|
	|SELECT
	|	Items.Ref
	|FROM
	|	Catalog.Items AS Items
	|WHERE
	|	NOT Items.DeletionMark
	|	AND Items.Code = &ItemNumber
	|
	|UNION
	|
	|SELECT
	|	Items.Ref
	|FROM
	|	Catalog.Items AS Items
	|WHERE
	|	NOT Items.DeletionMark
	|	AND Items.Description_en = &Item";
	
	DescriptionLocal = "Description_" + LocalizationReuse.GetLocalizationCode();
	If Not DescriptionLocal = "Description_en" Then
		Query.Text = StrReplace(Query.Text, "Description_en", DescriptionLocal);
	EndIf;
	
	Return Query.Execute().Unload().UnloadColumn(0);
	
EndFunction

// Search item key by string.
// 
// Parameters:
//  ItemKeyString - String - Item key 
//  ItemRef - CatalogRef.Items - Item
// 
// Returns:
//  Array of CatalogRef.ItemKeys - Search item key by string
Function SearchItemKeyByString(ItemKeyString, ItemRef) Export
	
	ItemKeyNumber = CommonFunctionsClientServer.GetSearchStringNumber(StrReplace(ItemKeyString, " ", ""));
	
	Query = New Query;
	Query.SetParameter("Item", ItemRef);
	Query.SetParameter("ItemKeyNumber", ItemKeyNumber);
	Query.SetParameter("ItemKey", ItemKeyString);
	
	Query.Text =
	"SELECT
	|	ItemKeys.Ref
	|INTO tmpRefs
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	NOT ItemKeys.DeletionMark
	|	AND ItemKeys.ItemKeyID = &ItemKey
	|
	|UNION
	|
	|SELECT
	|	ItemKeys.Ref
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	NOT ItemKeys.DeletionMark
	|	AND ItemKeys.Code = &ItemKeyNumber
	|
	|UNION
	|
	|SELECT
	|	ItemKeys.Ref
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	NOT ItemKeys.DeletionMark
	|	AND ItemKeys.Description_en = &ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	tmpRefs.Ref
	|FROM
	|	tmpRefs AS tmpRefs
	|WHERE
	|	&Item = VALUE(Catalog.Items.EmptyRef)
	|	OR tmpRefs.Ref.Item = &Item";
	
	DescriptionLocal = "Description_" + LocalizationReuse.GetLocalizationCode();
	If Not DescriptionLocal = "Description_en" Then
		Query.Text = StrReplace(Query.Text, "Description_en", DescriptionLocal);
	EndIf;
	
	Return Query.Execute().Unload().UnloadColumn(0);
	
EndFunction

#EndRegion

// Get package dimensions.
// 
// Parameters:
//  PackageItem - CatalogRef.ItemKeys - Package item
// 
// Returns:
//  Structure - Get package dimensions:
// * Weight - Number -
// * Volume - Number -
// * Height - Number -
// * Width - Number -
// * Length - Number -
Function GetPackageDimensions(PackageItem) Export
	
	Result = New Structure;
	Result.Insert("Weight", 0);
	Result.Insert("Volume", 0);
	Result.Insert("Height", 0);
	Result.Insert("Width", 0);
	Result.Insert("Length", 0);
	
	Selection = GetUnitInfo(PackageItem);
	
	While Selection.Next() Do
		If Selection.Length = 0 And Selection.Width = 0 And Selection.Height = 0 And
				Selection.Weight = 0 And Selection.Volume = 0 Then
			Continue;
		EndIf;
		FillPropertyValues(Result, Selection);
		Break;
	EndDo;
	
	Return Result;
	
EndFunction

// Get unit info.
// 
// Parameters:
//  PackageItem - CatalogRef.ItemKeys - Package item
// 
// Returns:
//  QueryResultSelection:
//  * Length - Number
//  * Width - Number
//  * Height - Number
//  * Weight - Number
//  * Volume - Number
Function GetUnitInfo(PackageItem)
	Query = New Query;
	Query.Text =
	"SELECT
	|	ItemKeys.Ref AS ItemKey,
	|	ItemKeys.Item,
	|	ItemKeys.Unit AS ItemKeyUnit,
	|	ItemKeys.Item.PackageUnit,
	|	ItemKeys.Item.Unit
	|INTO tmpItem
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemKeys.Weight,
	|	ItemKeys.Volume,
	|	ItemKeys.Height,
	|	ItemKeys.Width,
	|	ItemKeys.Length,
	|	1 AS Priority
	|FROM
	|	tmpItem AS tmpItem
	|		LEFT JOIN Catalog.ItemKeys AS ItemKeys
	|		ON tmpItem.ItemKey = ItemKeys.Ref
	|
	|UNION ALL
	|
	|SELECT
	|	IsNull(Items.Weight, 0) AS Weight,
	|	IsNull(Items.Volume, 0) AS Volume,
	|	IsNull(Items.Height, 0) AS Height,
	|	IsNull(Items.Width, 0) AS Width,
	|	IsNull(Items.Length, 0) AS Length,
	|	2 AS Priority
	|FROM
	|	tmpItem AS tmpItem
	|		LEFT JOIN Catalog.Items AS Items
	|		ON tmpItem.Item = Items.Ref
	|
	|UNION ALL
	|
	|SELECT
	|	IsNull(Units.Weight, 0) AS Weight,
	|	IsNull(Units.Volume, 0) AS Volume,
	|	IsNull(Units.Height, 0) AS Height,
	|	IsNull(Units.Width, 0) AS Width,
	|	IsNull(Units.Length, 0) AS Length,
	|	3 AS Priority
	|FROM
	|	tmpItem AS tmpItem
	|		LEFT JOIN Catalog.Units AS Units
	|		ON tmpItem.ItemKeyUnit = Units.Ref
	|
	|UNION ALL
	|
	|SELECT
	|	IsNull(Units.Weight, 0) AS Weight,
	|	IsNull(Units.Volume, 0) AS Volume,
	|	IsNull(Units.Height, 0) AS Height,
	|	IsNull(Units.Width, 0) AS Width,
	|	IsNull(Units.Length, 0) AS Length,
	|	4 AS Priority
	|FROM
	|	tmpItem AS tmpItem
	|		LEFT JOIN Catalog.Units AS Units
	|		ON tmpItem.ItemPackageUnit = Units.Ref
	|
	|UNION ALL
	|
	|SELECT
	|	IsNull(Units.Weight, 0) AS Weight,
	|	IsNull(Units.Volume, 0) AS Volume,
	|	IsNull(Units.Height, 0) AS Height,
	|	IsNull(Units.Width, 0) AS Width,
	|	IsNull(Units.Length, 0) AS Length,
	|	5 AS Priority
	|FROM
	|	tmpItem AS tmpItem
	|		LEFT JOIN Catalog.Units AS Units
	|		ON tmpItem.ItemUnit = Units.Ref
	|
	|ORDER BY
	|	Priority";
	
	Query.SetParameter("Ref", PackageItem);
	Selection = Query.Execute().Select();
	Return Selection
EndFunction

#Region ItemSegment
	
// Is item key in item segments.
// 
// Parameters:
//  ItemKey - CatalogRef.ItemKeys - Item key
//  ItemSegments - CatalogRef.ItemSegments, Array of CatalogRef.ItemSegments - Item segment
// 
// Returns:
//  Boolean
Function isItemKeyInItemSegments(Val ItemKey, Val ItemSegments) Export
	If TypeOf(ItemSegments) = Type("CatalogRef.ItemSegments") Then
		Array = New Array; // Array of CatalogRef.ItemSegments
		Array.Add(ItemSegments);
		//@skip-check statement-type-change
		ItemSegments = Array;
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ItemKeys.Item,
	|	ItemKeys.Ref AS ItemKey
	|INTO tmpItems
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Ref = &ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemSegments.Segment,
	|	ItemSegments.ItemKey
	|FROM
	|	InformationRegister.ItemSegments AS ItemSegments
	|		INNER JOIN tmpItems AS tmpItems
	|		ON ItemSegments.Segment IN (&Segments)
	|		AND ItemSegments.ItemKey = tmpItems.ItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	ItemSegments.Segment,
	|	ItemSegments.ItemKey
	|FROM
	|	InformationRegister.ItemSegments AS ItemSegments
	|		INNER JOIN tmpItems AS tmpItems
	|		ON ItemSegments.Segment IN (&Segments)
	|		AND ItemSegments.ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|		AND ItemSegments.Item = tmpItems.Item";
	
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("Segments", ItemSegments);
	
	Return Not Query.Execute().IsEmpty();
EndFunction
	
#EndRegion

Function CheckUnitForItem(ItemObject) Export
	Result = New Structure("Error, Document, UnitFrom, UnitTo", False, Undefined, Undefined, Undefined);
	If ValueIsFilled(ItemObject.Ref) 
		And ItemObject.Unit <> ItemObject.Ref.Unit Then
			
			CheckResult = ItemInRegisterRecords(ItemObject.Ref);
			
			Result.Error    = CheckResult.Error;
			Result.Document = CheckResult.Document;
			Result.UnitFrom = ItemObject.Ref.Unit;
			Result.UnitTo   = ItemObject.Unit;
	EndIf;
	Return Result;
EndFunction

Function CheckUnitForItemKey(ItemKeyObject) Export
	Result = New Structure("Error, Document, UnitFrom, UnitTo", False, Undefined, Undefined, Undefined);
	If ValueIsFilled(ItemKeyObject.Ref) Then
		OldUnit = ItemKeyObject.Ref.Unit;
		If Not ValueIsFilled(OldUnit) And ValueIsFilled(ItemKeyObject.Item) Then
			OldUnit = ItemKeyObject.Item.Unit;
		EndIf;
		
		If ValueIsFilled(ItemKeyObject.Unit) And ItemKeyObject.Unit <> OldUnit Then
			
			CheckResult = ItemInRegisterRecords(ItemKeyObject.Ref);
			
			Result.Error    = CheckResult.Error;
			Result.Document = CheckResult.Document;
			Result.UnitFrom = OldUnit;
			Result.UnitTo   = ItemKeyObject.Unit;
		EndIf;
		
	EndIf;
	Return Result;
EndFunction

Function ItemInRegisterRecords(ItemOrItemKey)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	R4010B_ActualStocks.Recorder
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks AS R4010B_ActualStocks
	|WHERE
	|	CASE
	|		WHEN &Filter_ItemKey
	|			THEN R4010B_ActualStocks.ItemKey = &ItemKey
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Item
	|			THEN R4010B_ActualStocks.ItemKey.Item = &Item
	|		ELSE TRUE
	|	END
	|
	|UNION ALL
	|
	|SELECT TOP 1
	|	R4050B_StockInventory.Recorder
	|FROM
	|	AccumulationRegister.R4050B_StockInventory AS R4050B_StockInventory
	|WHERE
	|	CASE
	|		WHEN &Filter_ItemKey
	|			THEN R4050B_StockInventory.ItemKey = &ItemKey
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Item
	|			THEN R4050B_StockInventory.ItemKey.Item = &Item
	|		ELSE TRUE
	|	END";
	
	If TypeOf(ItemOrItemKey) = Type("CatalogRef.Items") Then
		Query.SetParameter("Filter_ItemKey" , False);
		Query.SetParameter("ItemKey"        , Undefined);
		
		Query.SetParameter("Filter_Item"    , True);
		Query.SetParameter("Item"           , ItemOrItemKey);
	ElsIf TypeOf(ItemOrItemKey) = Type("CatalogRef.ItemKeys") Then
		Query.SetParameter("Filter_ItemKey" , True);
		Query.SetParameter("ItemKey"        , ItemOrItemKey);
		
		Query.SetParameter("Filter_Item"    , False);
		Query.SetParameter("Item"           , Undefined);		
	EndIf;
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Result = New Structure("Error, Document", False, Undefined);
	If QuerySelection.Next() Then
		Result.Error = True;
		Result.Document = QuerySelection.Recorder;
	EndIf;
	Return Result;
EndFunction

#Region GetItemDetailInfo

// Get item tree info.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
// Returns:
//  ValueTree - Get item tree description:
// * Description - String - 
// * RefValue - AnyRef -
Function GetItemTreeInfo(Item) Export
	
	TreeInfo = New ValueTree();
	TreeInfo.Columns.Add("Description", New TypeDescription("String"));
	TreeInfo.Columns.Add("RefValue");

	ItemDetailInfo = GetItemDetailInfo(Item);
	For Each DetailInfo In ItemDetailInfo Do
		TopBranch = TreeInfo.Rows.Add();
		TopBranch.Description = DetailInfo.Key;
		For Each ItemTreeBranchDescription In DetailInfo.Value Do
			NewBranch = TopBranch.Rows.Add();
			FillPropertyValues(NewBranch, ItemTreeBranchDescription);
		EndDo;
	EndDo;
	
	TreeInfo.Rows.Sort("Description", True);

	Return TreeInfo;
	
EndFunction

// Get item tree branch description.
// 
// Returns:
//  Structure - Get item tree branch description:
// * Description - String - 
// * RefValue - AnyRef - 
Function GetItemTreeBranchDescription() Export
	Result = New Structure();
	Result.Insert("Description", "");
	Result.Insert("RefValue");
	Return Result;
EndFunction

// Get item detail info.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
//  Array of KeyAndValue - Get item detail info:
//	* Key - String -
//	* Value - Array of See GetItemTreeBranchDescription
Function GetItemDetailInfo(Item)
	
	Result = New Map;
	
	Result.Insert("10. " + Metadata.Catalogs.ItemKeys.Synonym, GetTreeBranchItemKeys(Item));
	Result.Insert("20. " + Metadata.Catalogs.SerialLotNumbers.Synonym, GetTreeBranchSerialLotNumbers(Item));
	Result.Insert("30. " + Metadata.InformationRegisters.Barcodes.Synonym, GetTreeBranchBarcodes(Item));
	Result.Insert("40. " + Metadata.InformationRegisters.PricesByItems.Synonym, GetTreeBranchPrices(Item));
	Result.Insert("50. " + Metadata.AccumulationRegisters.R4010B_ActualStocks.Synonym, GetTreeBranchStocks(Item));
	
	Return Result;
	
EndFunction

// Get tree branch item keys.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
//  Array of See GetItemTreeBranchDescription
Function GetTreeBranchItemKeys(Item)
	
	Result = New Array; // Array of See GetItemTreeBranchDescription
	
	Query = New Query;
	Query.SetParameter("Item", Item);
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	ItemKeys.Ref,
	|	ItemKeys.Presentation AS Presentation
	|FROM
	|	Catalog.ItemKeys AS ItemKeys
	|WHERE
	|	ItemKeys.Item = &Item
	|	AND NOT ItemKeys.DeletionMark
	|
	|ORDER BY
	|	Presentation";
	QuerySelection = Query.Execute().Select();
	
	//@skip-check statement-type-change, property-return-type
	While QuerySelection.Next() Do
		ItemKeyRow = GetItemTreeBranchDescription();
		ItemKeyRow.RefValue = QuerySelection.Ref; 
		ItemKeyRow.Description = QuerySelection.Presentation;
		Result.Add(ItemKeyRow); 
	EndDo;
	
	Return Result;
	
EndFunction

// Get tree branch serial lot numbers.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
//  Array of See GetItemTreeBranchDescription
Function GetTreeBranchSerialLotNumbers(Item)
	
	Result = New Array; // Array of See GetItemTreeBranchDescription
	
	Query = New Query;
	Query.SetParameter("Item", Item);
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	SerialLotNumbers.Ref,
	|	SerialLotNumbers.Presentation AS Presentation
	|FROM
	|	Catalog.SerialLotNumbers AS SerialLotNumbers
	|WHERE
	|	NOT SerialLotNumbers.DeletionMark
	|	AND SerialLotNumbers.SerialLotNumberOwner = &Item
	|
	|ORDER BY
	|	Presentation";
	QuerySelection = Query.Execute().Select();
	
	//@skip-check statement-type-change, property-return-type
	While QuerySelection.Next() Do
		SerialLotNumberRow = GetItemTreeBranchDescription();
		SerialLotNumberRow.RefValue = QuerySelection.Ref; 
		SerialLotNumberRow.Description = QuerySelection.Presentation;
		Result.Add(SerialLotNumberRow); 
	EndDo;
	
	Return Result;
	
EndFunction

// Get tree branch barcodes.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
//  Array of See GetItemTreeBranchDescription
Function GetTreeBranchBarcodes(Item)
	
	Result = New Array; // Array of See GetItemTreeBranchDescription
	
	Query = New Query;
	Query.SetParameter("Item", Item);
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	Barcodes.Barcode AS Presentation
	|FROM
	|	InformationRegister.Barcodes AS Barcodes
	|WHERE
	|	Barcodes.ItemKey.Item = &Item
	|
	|ORDER BY
	|	Barcode";
	QuerySelection = Query.Execute().Select();
	
	//@skip-check statement-type-change, property-return-type
	While QuerySelection.Next() Do
		BarcodeRow = GetItemTreeBranchDescription();
		BarcodeRow.Description = QuerySelection.Presentation;
		Result.Add(BarcodeRow); 
	EndDo;
	
	Return Result;
	
EndFunction

// Get tree branch prices.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
//  Array of See GetItemTreeBranchDescription
Function GetTreeBranchPrices(Item)
	
	Result = New Array; // Array of See GetItemTreeBranchDescription
	
	Query = New Query;
	Query.SetParameter("Item", Item);
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	PricesByItemsSliceLast.PriceType AS PriceType,
	|	PricesByItemsSliceLast.Period,
	|	PricesByItemsSliceLast.Price,
	|	PricesByItemsSliceLast.PriceType.Currency AS Currency
	|FROM
	|	InformationRegister.PricesByItems.SliceLast(, Item = &Item) AS PricesByItemsSliceLast
	|
	|UNION ALL
	|
	|SELECT DISTINCT
	|	PricesByItemKeysSliceLast.PriceType AS PriceType,
	|	PricesByItemKeysSliceLast.Period,
	|	PricesByItemKeysSliceLast.Price,
	|	PricesByItemKeysSliceLast.PriceType.Currency
	|FROM
	|	InformationRegister.PricesByItemKeys.SliceLast(, ItemKey.Item = &Item) AS PricesByItemKeysSliceLast
	|
	|ORDER BY
	|	PriceType";
	QuerySelection = Query.Execute().Select();
	
	//@skip-check statement-type-change, property-return-type, invocation-parameter-type-intersect
	While QuerySelection.Next() Do
		PriceRow = GetItemTreeBranchDescription();
		PriceRow.RefValue = QuerySelection.PriceType; 
		PriceRow.Description = 
			StrTemplate("%1 (%2) - %3 (%4)", 
				QuerySelection.PriceType, 
				Format(QuerySelection.Period, "DLF=D;"),
				Format(QuerySelection.Price, "NZ=; NG=;"),
				QuerySelection.Currency);
		Result.Add(PriceRow); 
	EndDo;
	
	Return Result;
	
EndFunction

// Get tree branch stocks.
// 
// Parameters:
//  Item - CatalogRef.Items - Item
// 
// Returns:
//  Array of See GetItemTreeBranchDescription
Function GetTreeBranchStocks(Item)
	
	Result = New Array; // Array of See GetItemTreeBranchDescription
	
	Query = New Query;
	Query.SetParameter("Item", Item);
	
	Query.Text =
	"SELECT ALLOWED DISTINCT
	|	ActualStocksBalance.Store AS Store,
	|	SUM(ActualStocksBalance.QuantityBalance) AS Quantity,
	|	CASE
	|		WHEN ActualStocksBalance.ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN ActualStocksBalance.ItemKey.Item.Unit
	|		ELSE ActualStocksBalance.ItemKey.Unit
	|	END AS Unit
	|FROM
	|	AccumulationRegister.R4010B_ActualStocks.Balance(, ItemKey.Item = &Item) AS ActualStocksBalance
	|GROUP BY
	|	ActualStocksBalance.Store,
	|	CASE
	|		WHEN ActualStocksBalance.ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN ActualStocksBalance.ItemKey.Item.Unit
	|		ELSE ActualStocksBalance.ItemKey.Unit
	|	END
	|
	|ORDER BY
	|	Store";
	QuerySelection = Query.Execute().Select();
	
	//@skip-check statement-type-change, property-return-type, invocation-parameter-type-intersect
	While QuerySelection.Next() Do
		PriceRow = GetItemTreeBranchDescription();
		PriceRow.RefValue = QuerySelection.Store; 
		PriceRow.Description = 
			StrTemplate("%1 - %2 %3", 
				QuerySelection.Store, 
				Format(QuerySelection.Quantity, "NZ=; NG=;"),
				QuerySelection.Unit);
		Result.Add(PriceRow); 
	EndDo;

	Return Result;
	
EndFunction

#EndRegion

Function GetDescriptionByTemplate(Val ObjectOrRef, Val Template, LocalizationCode="") Export	
	Result = ParseDescriptionFormula(ObjectOrRef, Template);
	
	If ValueIsFilled(LocalizationCode) Then
		MultiLanguageRefs = New ValueTable();
		MultiLanguageRefs.Columns.Add("ArrayIndex");
		MultiLanguageRefs.Columns.Add("TableIndex");
		MultiLanguageRefs.Columns.Add("Ref");
	
		Array_Select1 = New Array();
		Array_Select2 = New Array();
	
		ArrayIndexCounter = 0;
		TableIndexCounter = 0;
		For Each ItemOfArray In Result.ArrayOfAttributeValues Do
			If ValueIsFilled(ItemOfArray) 
				And CommonFunctionsServer.IsRef(TypeOf(ItemOfArray))
				And CommonFunctionsServer.isCommonAttributeUseForMetadata("Description_en", ItemOfArray.Metadata()) Then
			
				NewRow = MultiLanguageRefs.Add();
				NewRow.ArrayIndex = ArrayIndexCounter;
				NewRow.TableIndex = TableIndexCounter;
				NewRow.Ref = ItemOfArray;
			
				Array_Select1.Add(StrTemplate("&Ref%1 AS Ref%1", TableIndexCounter));
				Array_Select2.Add(StrTemplate("Table.Ref%1.Description_en AS Descr%1", TableIndexCounter));
			
				TableIndexCounter = TableIndexCounter + 1;
			EndIf;
			ArrayIndexCounter = ArrayIndexCounter + 1;
		EndDo;
	
		If MultiLanguageRefs.Count() Then
			Query = New Query();
			Query.Text = StrTemplate("SELECT %1 INTO Table; SELECT %2 FROM Table AS Table", 
				StrConcat(Array_Select1, ","), StrConcat(Array_Select2, ",")); 
			
			For Each Row In MultiLanguageRefs Do
				Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, StrTemplate("Table.Ref%1", Row.TableIndex), LocalizationCode);
				Query.SetParameter(StrTemplate("Ref%1", Row.TableIndex), Row.Ref);
			EndDo;
	
			QueryResult = Query.Execute();
			QuerySelection = QueryResult.Select();
			If QuerySelection.Next() Then
				For Each Row In MultiLanguageRefs Do
					Result.ArrayOfAttributeValues[Row.ArrayIndex] = QuerySelection[StrTemplate("Descr%1", Row.TableIndex)];
				EndDo;
			EndIf;
		EndIf;
	EndIf;
	
	Parameters = Result.ArrayOfAttributeValues;
	FormulaString = """"" + " + StrReplace(Result.Value,
		"ArrayOfAttributeValues[",
		"Parameters[");
	
	Description = "";
	If ValueIsFilled(FormulaString) Then
		Try
			Description = Eval(FormulaString);
		Except
			Raise R().FormulaEditor_Error04 + Chars.LF + ErrorDescription();	
		EndTry;
	EndIf;
	
	Return Description;
EndFunction

// Parse description formula.
// 
// Parameters:
//  ObjectOrRef - AnyRef - Object or ref
//  Template - String - Template
// 
// Returns:
//  Structure - Parse description formula:
// * Value - String - 
// * ArrayOfAttributeValues - Array - 
Function ParseDescriptionFormula(Val ObjectOrRef, Val Template)
	Result = New Structure("Value, ArrayOfAttributeValues","" + Template, New Array());
	PrimitiveTypes = New TypeDescription("Number, String, Date, Boolean, ValueStorage, UUID");
	
	For OperandCounter = 0 To StrLen(Template) Do
		FirstSymbol = StrFind(Template, "[");
		LastSymbol  = StrFind(Template, "]");
		
		If FirstSymbol = 0 Or LastSymbol = 0 Or FirstSymbol > LastSymbol Then
			Break;
		EndIf;
		
		OperandName  = Mid(Template, FirstSymbol + 1, LastSymbol - FirstSymbol - 1);
		OperandValue = ObjectOrRef;
		
		ArrayOfOperandAttributes = StrSplit(OperandName, "."); 
		
		For AttributeCounter = 0 To ArrayOfOperandAttributes.Count()-1 Do
			
			AttributeName = ArrayOfOperandAttributes[AttributeCounter];
			
			If AttributeCounter > 0 And Not ValueIsFilled(OperandValue) Then
				Break;
			EndIf;
			
			If Not PrimitiveTypes.ContainsType(TypeOf(OperandValue)) Then
				_Metadata = OperandValue.Ref.Metadata();
				MetadataFullName = _Metadata.FullName();
			Else
				Raise StrTemplate("Can not eval description formula. error operand [%1]:[%2]", OperandName, AttributeName);				
			КонецЕсли;
			
			If CommonFunctionsClientServer.ObjectHasProperty(_Metadata.Attributes, AttributeName)
				Or CommonFunctionsClientServer.ObjectHasProperty(_Metadata.StandardAttributes, AttributeName) 
				Or CommonFunctionsServer.isCommonAttributeUseForMetadata(AttributeName, _Metadata) Then
				
				If AttributeCounter > 0 Or  CommonFunctionsServer.IsRef(TypeOf(OperandValue)) Then
					OperandValue = CommonFunctionsServer.GetRefAttribute(OperandValue, AttributeName); // AnyRef
				Else
					OperandValue = OperandValue[AttributeName]; // AnyRef
				EndIf;
				
			Else
				AddAttribute = ChartsOfCharacteristicTypes.AddAttributeAndProperty.FindByAttribute("UniqueID", AttributeName);
				If Not ValueIsFilled(AddAttribute) Then
					Raise StrTemplate("Can not eval description formula. error operand [%1]:[%2]", OperandName, AttributeName);
				EndIf;
				
				If AttributeCounter > 0 Or CommonFunctionsServer.IsRef(TypeOf(OperandValue)) Then
					
					Query = New Query();
					Query.Text =
					"SELECT TOP 1
					|	AddAttributes.Value КАК Value
					|FROM
					|	" + MetadataFullName + ".AddAttributes AS AddAttributes
					|WHERE
					|	AddAttributes.Ref = &Ref
					|	И AddAttributes.Property = &Property";
					
					Query.SetParameter("Ref",   OperandValue);
					Query.SetParameter("Property", AddAttribute);
					
					QuerySelection = Query.Execute().Select();
					If QuerySelection.Next() Then
						OperandValue = QuerySelection.Value;
					Else
						OperandValue = "";
					EndIf;
					
				Else
					If TypeOf(OperandValue.AddAttributes) = Type("FormDataCollection") Then
						TableRow = OperandValue.AddAttributes.Unload().Find(AddAttribute, "Property");
					Else
						TableRow = OperandValue.AddAttributes.Find(AddAttribute, "Property");
					EndIf;
					
					OperandValue   = ?(TableRow <> Undefined, TableRow.Value, "");
				EndIf;
			EndIf;
			
		EndDo;
		
		Result.ArrayOfAttributeValues.Add(
			?(ArrayOfOperandAttributes.Count() > 0 And ValueIsFilled(OperandValue), OperandValue, ""));
		
		Result.Value = StrReplace(
			Result.Value,
			"[" + OperandName + "]",
			"ArrayOfAttributeValues[" + OperandCounter + "]");
		Template = StrReplace(
			Template,
			"[" + OperandName + "]",
			"");
		
	EndDo;
	
	Return Result;
	
EndFunction
