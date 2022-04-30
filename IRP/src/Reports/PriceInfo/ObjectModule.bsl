Procedure OnComposeResult(ResultDocument, DetailsData, StandardProcessing)
	StandardProcessing = False;

	TemplateComposer = New DataCompositionTemplateComposer();
	Settings = SettingsComposer.GetSettings();

	Settings.DataParameters.SetParameterValue("PricePeriod", ?(ValueIsFilled(PricePeriod), EndOfDay(PricePeriod),
		EndOfDay(CurrentDate())));

	ItemKeysArray = New Array();
	If TypeOf(PriceOwner) = Type("CatalogRef.ItemKeys") Then
		ItemKeysArray.Add(PriceOwner);
	ElsIf TypeOf(PriceOwner) = Type("CatalogRef.Items") Then
		ItemKeysArray = CatItemsServer.GetArrayOfItemKeysByItem(PriceOwner);
	Else
		Return;
	EndIf;

	Query = New Query("SELECT ALLOWED
					  |	Table.Ref AS ItemKey,
					  |	PriceTypes.Ref AS PriceType,
					  |	Table.Item AS Item,
					  |	Table.Specification AS Specification,
					  |	Table.AffectPricingMD5 AS AffectPricingMD5,
					  |	CASE
					  |		WHEN Table.Specification = VALUE(Catalog.Specifications.EmptyRef)
					  |			THEN FALSE
					  |		ELSE TRUE
					  |	END AS IsSpecification
					  |into tmp_ItemKeys
					  |FROM
					  |	Catalog.ItemKeys AS Table
					  |		INNER JOIN Catalog.PriceTypes AS PriceTypes
					  |		ON Not PriceTypes.DeletionMark
					  |		AND CASE
					  |			WHEN &PriceOwnerIsItem
					  |				THEN Table.Item = &PriceOwner
					  |			ELSE Table.Ref = &PriceOwner
					  |		END
					  |;
					  |
					  |////////////////////////////////////////////////////////////////////////////////
					  |
					  |SELECT ALLOWED
					  |	1 AS Priority,
					  |	&ByItemKeys AS PriceDefinitionType
					  |into tmpPriceDefinitionTypes
					  |
					  |UNION ALL
					  |
					  |SELECT
					  |	2 AS Priority,
					  |	&ByProperties AS PriceTypeDefinition
					  |
					  |UNION ALL
					  |
					  |SELECT
					  |	3 AS Priority,
					  |	&ByItems AS PriceTypeDefinition
					  |
					  |UNION ALL
					  |
					  |SELECT
					  |	0 AS Priority,
					  |	"""" AS PriceTypeDefinition");
	Query.TempTablesManager = New TempTablesManager();
	Query.SetParameter("PricePeriod", ?(ValueIsFilled(PricePeriod), EndOfDay(PricePeriod), EndOfDay(CurrentDate())));

	Query.SetParameter("PriceOwner", PriceOwner);
	Query.SetParameter("PriceOwnerIsItem", TypeOf(PriceOwner) = Type("CatalogRef.Items"));

	Query.SetParameter("ByItemKeys", R().Form_022);
	Query.SetParameter("ByProperties", R().Form_023);
	Query.SetParameter("ByItems", R().Form_024);

	Query.Execute();

	Query.Text = GetQueryTextForSpecifications();
	Query.Execute();

	Query.Text = GetQueryTextForNotSpecifications();
	Query.Execute();

	Query.Text =
	"SELECT ALLOWED
	|	tmpPriceDefinitionTypes.Priority AS Priority,
	|	tmpPriceDefinitionTypes.PriceDefinitionType AS PriceDefinitionType,
	|	Table.PriceDefinitionReason AS PriceDefinitionReason,
	|	Table.Item AS Item,
	|	Table.ItemKey AS ItemKey,
	|	Table.PriceType AS PriceType,
	|	Table.Price AS Price
	|INTO tmpAllPrices
	|FROM
	|	tmpPriceDefinitionTypes AS tmpPriceDefinitionTypes
	|		LEFT JOIN (SELECT
	|			Table.PriceDefinitionType AS PriceDefinitionType,
	|			Table.PriceDefinitionReason AS PriceDefinitionReason,
	|			Table.Item AS Item,
	|			Table.ItemKey AS ItemKey,
	|			Table.PriceType AS PriceType,
	|			Table.Price AS Price
	|		FROM
	|			tmp_Specification AS Table
	|
	|		UNION ALL
	|
	|		SELECT
	|			Table.PriceDefinitionType AS PriceDefinitionType,
	|			Table.PriceDefinitionReason AS PriceDefinitionReason,
	|			Table.Item AS Item,
	|			Table.ItemKey AS ItemKey,
	|			Table.PriceType AS PriceType,
	|			Table.Price AS Price
	|		FROM
	|			tmp_NotSpecification AS Table) AS Table
	|		ON Table.PriceDefinitionType = tmpPriceDefinitionTypes.PriceDefinitionType
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	MIN(Table.Priority) AS Priority,
	|	Table.Item AS Item,
	|	Table.ItemKey AS ItemKey,
	|	Table.PriceType AS PriceType
	|INTO tmpPriorityPrices
	|FROM
	|	tmpAllPrices AS Table
	|WHERE
	|	NOT Table.Price IS NULL
	|GROUP BY
	|	Table.Item,
	|	Table.ItemKey,
	|	Table.PriceType
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	(NOT tmpPriorityPrices.Priority IS NULL) AS IsPriority,
	|	Table.PriceDefinitionType AS PriceDefinitionType,
	|	Table.PriceDefinitionReason AS PriceDefinitionReason,
	|	CASE
	|		WHEN Table.PriceDefinitionType = &ByItemKeys
	|			THEN &ItemKeyName
	|		WHEN Table.PriceDefinitionType = &ByProperties
	|			THEN &PropertyName
	|		WHEN Table.PriceDefinitionType = &ByItems
	|			THEN &ItemName
	|		WHEN Table.PriceDefinitionType = """"
	|			THEN &SpecificationName
	|		ELSE """"
	|	END AS PriceDefinitionReasonString,
	|	Table.Item AS Item,
	|	Table.ItemKey AS ItemKey,
	|	Table.PriceType AS PriceType,
	|	Table.Price AS Price
	|FROM
	|	tmpAllPrices AS Table
	|		LEFT JOIN tmpPriorityPrices AS tmpPriorityPrices
	|		ON Table.Priority = tmpPriorityPrices.Priority
	|		AND Table.Item = tmpPriorityPrices.Item
	|		AND Table.ItemKey = tmpPriorityPrices.ItemKey
	|		AND Table.PriceType = tmpPriorityPrices.PriceType";
	Query.SetParameter("ItemKeyName", R().R_001);
	Query.SetParameter("PropertyName", R().R_002);
	Query.SetParameter("ItemName", R().R_003);
	Query.SetParameter("SpecificationName", R().R_004);
	
	PriceInfoTable = Query.Execute().Unload();	
		
	///////////////////////////

	CompositionTemplate = TemplateComposer.Execute(DataCompositionSchema, Settings, DetailsData);

	DataSets = New Structure("PriceInfoTable", PriceInfoTable);

	Processor = New DataCompositionProcessor();
	Processor.Initialize(CompositionTemplate, DataSets, DetailsData, True);

	OutputProcessor = New DataCompositionResultSpreadsheetDocumentOutputProcessor();
	OutputProcessor.SetDocument(ResultDocument);

	OutputProcessor.Output(Processor, True);

EndProcedure

Function GetQueryTextForSpecifications()
	Return "SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Item AS Item,
		   |	Table.Specification AS Specification,
		   |	ItemKeysSpecificationAffectPricingMD5.Key AS Key,
		   |	ItemKeysSpecificationAffectPricingMD5.AffectPricingMD5 AS AffectPricingMD5,
		   |	PriceTypes.Ref AS PriceType
		   |INTO t_ItemKeys
		   |FROM
		   |	tmp_ItemKeys AS Table
		   |		INNER JOIN Catalog.ItemKeys.SpecificationAffectPricingMD5 AS ItemKeysSpecificationAffectPricingMD5
		   |		ON Table.ItemKey = ItemKeysSpecificationAffectPricingMD5.Ref
		   |		AND Table.IsSpecification
		   |		LEFT JOIN Catalog.PriceTypes AS PriceTypes
		   |		ON TRUE
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	MAX(CASE
		   |		WHEN Table.Specification.Type = VALUE(Enum.SpecificationType.Bundle)
		   |			THEN SpecificationsDataSet.Item
		   |		ELSE Table.Item
		   |	END) AS Item,
		   |	Table.Specification AS Specification,
		   |	ISNULL(SpecificationsDataQuantity.Quantity, 0) AS Quantity,
		   |	Table.Key AS Key,
		   |	Table.PriceType AS PriceType,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5
		   |INTO t_SpecificationRows
		   |FROM
		   |	t_ItemKeys AS Table
		   |		LEFT JOIN Catalog.Specifications.DataSet AS SpecificationsDataSet
		   |		ON Table.Specification = SpecificationsDataSet.Ref
		   |		AND Table.Key = SpecificationsDataSet.Key
		   |		LEFT JOIN Catalog.Specifications.DataQuantity AS SpecificationsDataQuantity
		   |		ON Table.Specification = SpecificationsDataQuantity.Ref
		   |		AND Table.Key = SpecificationsDataQuantity.Key
		   |GROUP BY
		   |	Table.ItemKey,
		   |	Table.Item,
		   |	Table.Specification,
		   |	ISNULL(SpecificationsDataQuantity.Quantity, 0),
		   |	Table.Key,
		   |	Table.PriceType,
		   |	Table.AffectPricingMD5
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
		   |		LEFT JOIN InformationRegister.PricesByItemKeys.SliceLast(&PricePeriod, (ItemKey) IN
		   |			(SELECT
		   |				T.ItemKey
		   |			FROM
		   |				t_ItemKeys AS T)) AS PricesByItemKeysSliceLast
		   |		ON SpecificationRows.ItemKey = PricesByItemKeysSliceLast.ItemKey
		   |		AND SpecificationRows.PriceType = PricesByItemKeysSliceLast.PriceType
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
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
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	PriceKeys.Ref AS PriceKey,
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Specification AS Specification,
		   |	Table.Quantity AS Quantity,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5,
		   |	Table.PriceType AS PriceType,
		   |	Table.Key AS Key,
		   |	Table.Item AS Item
		   |INTO t_PriceKeys
		   |FROM
		   |	tmp2 AS Table
		   |		LEFT JOIN Catalog.PriceKeys AS PriceKeys
		   |		ON Table.AffectPricingMD5 = PriceKeys.AffectPricingMD5
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.PriceKey AS PriceKey,
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Specification AS Specification,
		   |	Table.Quantity AS Quantity,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5,
		   |	Table.Key AS Key,
		   |	Table.Item AS Item,
		   |	Table.PriceType,
		   |	ISNULL(PricesByPropertiesSliceLast.Price, 0) * Table.Quantity AS Price
		   |INTO t_PricesByProperties
		   |FROM
		   |	t_PriceKeys AS Table
		   |		LEFT JOIN InformationRegister.PricesByProperties.SliceLast(&PricePeriod, (PriceKey) IN
		   |			(SELECT
		   |				T.PriceKey
		   |			FROM
		   |				t_PriceKeys AS T)) AS PricesByPropertiesSliceLast
		   |		ON Table.PriceKey = PricesByPropertiesSliceLast.PriceKey
		   |		AND Table.PriceType = PricesByPropertiesSliceLast.PriceType
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
		   |	tmp3.PriceType AS PriceType
		   |INTO tmp3
		   |FROM
		   |	t_PricesByProperties AS tmp3
		   |WHERE
		   |	tmp3.Price = 0
		   |;
		   |
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Specification AS Specification,
		   |	Table.Quantity AS Quantity,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5,
		   |	Table.Key AS Key,
		   |	Table.Item AS Item,
		   |	Table.PriceType AS PriceType,
		   |	ISNULL(PricesByItemsSliceLast.Price, 0) * Table.Quantity AS Price
		   |INTO t_PricesByItems
		   |FROM
		   |	tmp3 AS Table
		   |		LEFT JOIN InformationRegister.PricesByItems.SliceLast(&PricePeriod, (Item) IN
		   |			(SELECT
		   |				T.Item
		   |			FROM
		   |				t_ItemKeys AS T)) AS PricesByItemsSliceLast
		   |		ON Table.Item = PricesByItemsSliceLast.Item
		   |		AND Table.PriceType = PricesByItemsSliceLast.PriceType
		   |;
		   |
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	SpecificationRows.ItemKey AS ItemKey,
		   |	SpecificationRows.Item AS Item,
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
		   |SELECT ALLOWED
		   |	"""" AS PriceDefinitionType,
		   |	t_PriceDetails.ItemKey AS PriceDefinitionReason,
		   |	t_PriceDetails.Item AS Item,
		   |	t_PriceDetails.ItemKey AS ItemKey,
		   |	t_PriceDetails.PriceType AS PriceType,
		   |	MAX(t_PriceDetails.PriceByItemKeys) + SUM(t_PriceDetails.PriceByProperties) + SUM(t_PriceDetails.PriceByItems) AS
		   |		Price
		   |into tmp_Specification
		   |FROM
		   |	t_PriceDetails AS t_PriceDetails
		   |GROUP BY
		   |	t_PriceDetails.Item,
		   |	t_PriceDetails.ItemKey,
		   |	t_PriceDetails.PriceType
		   |HAVING
		   |	MAX(t_PriceDetails.PriceByItemKeys) + SUM(t_PriceDetails.PriceByProperties) + SUM(t_PriceDetails.PriceByItems) <> 0";
EndFunction

Function GetQueryTextForNotSpecifications()
	Return "
		   |DROP t_ItemKeys;
		   |DROP t_PriceKeys;
		   |DROP t_PricesByItemKeys;
		   |DROP t_PricesByProperties;
		   |DROP t_PricesByItems;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Item AS Item,
		   |	Table.Specification AS Specification,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5
		   |INTO t_ItemKeys
		   |FROM
		   |	tmp_ItemKeys AS Table
		   |WHERE
		   |	Not Table.IsSpecification
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Specification AS Specification,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5,
		   |	Table.Item AS Item,
		   |	PricesByItemKeysSliceLast.PriceType AS PriceType,
		   |	PricesByItemKeysSliceLast.Price AS Price
		   |INTO t_PricesByItemKeys
		   |FROM
		   |	t_ItemKeys AS Table
		   |		INNER JOIN InformationRegister.PricesByItemKeys.SliceLast(&PricePeriod, (ItemKey) IN
		   |			(SELECT
		   |				T.ItemKey
		   |			FROM
		   |				t_ItemKeys AS T)) AS PricesByItemKeysSliceLast
		   |		ON Table.ItemKey = PricesByItemKeysSliceLast.ItemKey
		   |;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	PriceKeys.Ref AS PriceKey,
		   |	Table.ItemKey AS ItemKey,
		   |	Table.AffectPricingMD5 AS AffectPricingMD5,
		   |	Table.Item AS Item
		   |INTO t_PriceKeys
		   |FROM
		   |	t_ItemKeys AS Table
		   |		LEFT JOIN Catalog.PriceKeys AS PriceKeys
		   |		ON Table.AffectPricingMD5 = PriceKeys.AffectPricingMD5
		   |;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	Table.PriceKey AS PriceKey,
		   |	Table.Item AS Item,
		   |	PricesByPropertiesSliceLast.PriceType AS PriceType,
		   |	PricesByPropertiesSliceLast.Price AS Price
		   |INTO t_PricesByProperties
		   |FROM
		   |	t_PriceKeys AS Table
		   |		INNER JOIN InformationRegister.PricesByProperties.SliceLast(&PricePeriod, (PriceKey) IN
		   |			(SELECT
		   |				T.PriceKey
		   |			FROM
		   |				t_PriceKeys AS T)) AS PricesByPropertiesSliceLast
		   |		ON Table.PriceKey = PricesByPropertiesSliceLast.PriceKey
		   |;
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	Table.ItemKey AS ItemKey,
		   |	Table.Item AS Item,
		   |	PricesByItemsSliceLast.PriceType AS PriceType,
		   |	PricesByItemsSliceLast.Price AS Price
		   |INTO t_PricesByItems
		   |FROM
		   |	t_ItemKeys AS Table
		   |		INNER JOIN InformationRegister.PricesByItems.SliceLast(&PricePeriod, (Item) IN
		   |			(SELECT
		   |				T.Item
		   |			FROM
		   |				t_ItemKeys AS T)) AS PricesByItemsSliceLast
		   |		ON Table.Item = PricesByItemsSliceLast.Item
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT ALLOWED
		   |	&ByItemKeys AS PriceDefinitionType,
		   |	Table.ItemKey AS PriceDefinitionReason,
		   |	Table.Item AS Item,
		   |	Table.ItemKey AS ItemKey,
		   |	Table.PriceType AS PriceType,
		   |	MAX(Table.Price) AS Price
		   |into tmp_NotSpecification
		   |FROM
		   |	t_PricesByItemKeys AS Table
		   |GROUP BY
		   |	Table.Item,
		   |	Table.ItemKey,
		   |	Table.PriceType
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	&ByProperties AS PriceDefinitionType,
		   |	MAX(Table.PriceKey) AS PriceDefinitionReason,
		   |	Table.Item AS Item,
		   |	Table.ItemKey AS ItemKey,
		   |	Table.PriceType AS PriceType,
		   |	MAX(Table.Price)
		   |FROM
		   |	t_PricesByProperties AS Table
		   |GROUP BY
		   |	Table.Item,
		   |	Table.ItemKey,
		   |	Table.PriceType
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	&ByItems AS PriceDefinitionType,
		   |	Table.Item AS PriceDefinitionReason,
		   |	Table.Item AS Item,
		   |	Table.ItemKey AS ItemKey,
		   |	Table.PriceType AS PriceType,
		   |	MAX(Table.Price)
		   |FROM
		   |	t_PricesByItems AS Table
		   |GROUP BY
		   |	Table.Item,
		   |	Table.ItemKey,
		   |	Table.PriceType";
EndFunction