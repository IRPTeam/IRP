Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;	
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	CatalogsServer.SetParametersForDataChoosing(Catalogs.Companies, Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	
EndProcedure

Function GetChoiceDataTable(Parameters) Export
	Filter = "
			 |	AND CASE
			 |		WHEN &FilterByPartnerHierarchy
			 |			THEN Table.Ref IN (&CompaniesByPartnerHierarchy)
			 |		ELSE TRUE
			 |	END";
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "CustomSearchFilter" OR FilterItem.Key = "AdditionalParameters" Then
			Continue; // Service properties
		EndIf;
		If FilterItem.Key = "LegalName" Then
			Continue; // Additional parameters
		EndIf;
		Filter = Filter
			+ "
		|	AND Table." + FilterItem.Key + " = &" + FilterItem.Key;
	EndDo;			 
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.Companies);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();

	Query.SetParameter("SearchString", Parameters.SearchString);
	For Each Filter In Parameters.Filter Do
		Query.SetParameter(Filter.Key, Filter.Value);
	EndDo;

	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	QueryParametersStr = New Structure("FilterByPartnerHierarchy,
									   |CompaniesByPartnerHierarchy", False, New Array());
	FillPropertyValues(QueryParametersStr, AdditionalParameters);
	If QueryParametersStr.FilterByPartnerHierarchy Then
		CompaniesByPartnerHierarchy = Catalogs.Partners.GetCompaniesForPartner(AdditionalParameters.Partner);
		QueryParametersStr.Insert("CompaniesByPartnerHierarchy", CompaniesByPartnerHierarchy);
	EndIf;
	For Each QueryParameter In QueryParametersStr Do
		Query.SetParameter(QueryParameter.Key, QueryParameter.Value);
	EndDo;

	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);

	Return Query.Execute().Unload();
EndFunction

Function GetDefaultChoiceRef(Parameters) Export
	QueryTable = GetChoiceDataTable(New Structure("SearchString, Filter", "", Parameters));

	If QueryTable.Count() = 1 Then
		Return QueryTable[0].Ref;
	Else
		If Parameters.Property("LegalName") Then
			Rows = QueryTable.FindRows(New Structure("Ref", Parameters.LegalName));
			If Rows.Count() = 0 Then
				Return PredefinedValue("Catalog.Companies.EmptyRef");
			Else
				Return Parameters.LegalName;
			EndIf;
		Else
			Return PredefinedValue("Catalog.Companies.EmptyRef");
		EndIf;
	EndIf;
EndFunction

Function GetLegalCurrencies(CompanyRef) Export
	Array = New Array();
	Array.Add(New Structure("CurrencyMovementType", CompanyRef.LegalCurrencyMovementType));
	Return Array;
EndFunction

Function GetReportingCurrencies(CompanyRef) Export
	Return GetCurrenciesByType(CompanyRef, Enums.CurrencyType.Reporting);
EndFunction

Function GetBudgetingCurrencies(CompanyRef) Export
	Return GetCurrenciesByType(CompanyRef, Enums.CurrencyType.Budgeting);
EndFunction

Function GetCurrenciesByType(CompanyRef, Type)
	Query = New Query();
	Query.Text =
	"SELECT
	|	CompaniesCurrencies.MovementType AS CurrencyMovementType
	|FROM
	|	Catalog.Companies.Currencies AS CompaniesCurrencies
	|WHERE
	|	CompaniesCurrencies.Ref = &Ref
	|	AND CompaniesCurrencies.MovementType.Type = &Type";
	Query.SetParameter("Ref", CompanyRef);
	Query.SetParameter("Type", Type);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		Result = New Structure();
		Result.Insert("CurrencyMovementType", QuerySelection.CurrencyMovementType);
		ArrayOfResults.Add(Result);
	EndDo;
	Return ArrayOfResults;
EndFunction
