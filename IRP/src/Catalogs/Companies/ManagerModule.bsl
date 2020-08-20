Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	
	If TypeOf(Parameters) <> Type("Structure")
		Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = New ValueList();
	For Each Row In QueryTable Do
		ChoiceData.Add(Row.Ref, Row.Presentation);
	EndDo;
EndProcedure

Function GetChoiceDataTable(Parameters) Export
	Filter = "
		|	AND CASE
		|		WHEN &FilterByPartnerHierarchy
		|			THEN Table.Ref IN (&CompaniesByPartnerHierarchy)
		|		ELSE TRUE
		|	END";
	Settings = New Structure;
	Settings.Insert("MetadataObject", Metadata.Catalogs.Companies);
	Settings.Insert("Filter", Filter);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
		
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	If TypeOf(Parameters) = Type("Structure") And Parameters.Filter.Property("CustomSearchFilter") Then
		ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
		For Each Filter In ArrayOfFilters Do
			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
			NewFilter.Use = True;
			NewFilter.ComparisonType = Filter.ComparisonType;
			NewFilter.Value = Filter.Value;
		EndDo;
	EndIf;
	Query = QueryBuilder.GetQuery();
	
	Query.SetParameter("SearchString", Parameters.SearchString);
	
	AdditionalParameters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.AdditionalParameters);
	QueryParametersStr = New Structure("FilterByPartnerHierarchy,
			|CompaniesByPartnerHierarchy", False, New Array);
	FillPropertyValues(QueryParametersStr, AdditionalParameters);
	If QueryParametersStr.FilterByPartnerHierarchy Then
		CompaniesByPartnerHierarchy = Catalogs.Partners.GetCompaniesForPartner(AdditionalParameters.Partner);
		QueryParametersStr.Insert("CompaniesByPartnerHierarchy", CompaniesByPartnerHierarchy);
	EndIf;
	For Each QueryParameter In QueryParametersStr Do
		Query.SetParameter(QueryParameter.Key, QueryParameter.Value);
	EndDo;
	
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
	Return GetCurrenciesByType(CompanyRef, Enums.CurrencyType.Legal);
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