Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	
EndProcedure

Function GetChoiceDataTable(Parameters) Export
	Filter = " AND
			 |	((CAST(Table.SourceOfOriginOwner AS Catalog.ItemTypes)) = &ItemType
			 |		OR (CAST(Table.SourceOfOriginOwner AS Catalog.Items)) = &Item
			 |		OR (CAST(Table.SourceOfOriginOwner AS Catalog.ItemKeys)) = &ItemKey
			 |		OR Table.SourceOfOriginOwner.Ref IS NULL)";

	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.SourceOfOrigins);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);

	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	Query.SetParameter("ItemType", AdditionalParameters.ItemType);
	Query.SetParameter("Item"    , AdditionalParameters.Item);
	Query.SetParameter("ItemKey" , AdditionalParameters.ItemKey);
	
	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);
	
	Return Query.Execute().Unload();
EndFunction
