Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;
	
	// Cut last symblos if it came from Excel
	If StrEndsWith(Parameters.SearchString, "¶") Then 
		Parameters.SearchString = Left(Parameters.SearchString, StrLen(Parameters.SearchString) - 1);
	EndIf;
	
	QueryTable = GetChoiceDataTable(Parameters);

	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);
EndProcedure

Function GetArrayOfParents(Partner, OnlyHierarchy = False) Export
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	Partners.Ref AS Ref
	|FROM
	|	Catalog.Partners AS Partners
	|WHERE
	|	Partners.Ref = &Partner
	|TOTALS
	|BY
	|	Ref ONLY HIERARCHY";
	Query.SetParameter("Partner", Partner);
	Selection = Query.Execute().Select();

	ArrayParents = New Array();
	While Selection.Next() Do
		If (OnlyHierarchy And Selection.Ref = Partner) Or Not ValueIsFilled(Selection.Ref) Then
			Continue;
		EndIf;
		ArrayParents.Add(Selection.Ref);
	EndDo;
	Return ArrayParents;
EndFunction

Function GetCompaniesForPartner(Partner) Export
	PartnerHierarchy = Catalogs.Partners.GetArrayOfParents(Partner);
	TempTable = New ValueTable();
	TempTable.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	TempTable.Columns.Add("Level", New TypeDescription("Number"));
	For i = 0 To PartnerHierarchy.UBound() Do
		NewRow = TempTable.Add();
		NewRow.Level = i;
		NewRow.Partner = PartnerHierarchy[i];
	EndDo;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Table.Partner AS Partner,
	|	Table.Level As Level
	|INTO TempPartners
	|FROM
	|	&TempTable AS Table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED
	|	Table.Ref AS Ref,
	|	Table.Partner,
	|	TempPartners.Level
	|INTO TempCompanies
	|FROM
	|	Catalog.Companies AS Table
	|		INNER JOIN TempPartners AS TempPartners
	|		ON Table.Partner = TempPartners.Partner
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	TempCompanies.Ref AS Ref
	|FROM
	|	TempCompanies AS TempCompanies
	|		INNER JOIN (SELECT
	|			MAX(Table.Level) AS Level
	|		FROM
	|			TempCompanies AS Table) AS Levels
	|		ON Levels.Level = TempCompanies.Level";
	Query.SetParameter("TempTable", TempTable);
	Return Query.Execute().Unload().UnloadColumn("Ref");
EndFunction

Function GetChoiceDataTable(Parameters) Export

	Filter = "
			 |	AND CASE
			 |		WHEN &FilterPartnersByCompanies
			 |			THEN Table.Ref IN (&PartnersByCompanies)
			 |		ELSE TRUE
			 |	END
			 |";

	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.Partners);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
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
	QueryParametersStr = New Structure("FilterPartnersByCompanies,
									   |PartnersByCompanies", False, New Array());
	FillPropertyValues(QueryParametersStr, AdditionalParameters);
	If QueryParametersStr.FilterPartnersByCompanies Then
		CompaniesArray = New Array();
		CompaniesArray.Add(AdditionalParameters.Company);
		PartnersArray = CatPartnersServer.GetPartnersByCompanies(CompaniesArray);
		QueryParametersStr.Insert("PartnersByCompanies", PartnersArray);
	EndIf;
	For Each QueryParameter In QueryParametersStr Do
		Query.SetParameter(QueryParameter.Key, QueryParameter.Value);
	EndDo;
	
	// parameters search by code
	AccessSymbols = ".,- ¶" + Chars.LF + Chars.NBSp + Chars.CR;
	SearchStringNumber = CommonFunctionsClientServer.GetNumberPartFromString(Parameters.SearchString, AccessSymbols);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);
	
	Return Query.Execute().Unload();
EndFunction

Function GetDefaultChoiceRef(Parameters) Export
	QueryTable = GetChoiceDataTable(New Structure("SearchString, Filter", "", Parameters));
	If QueryTable.Count() = 1 Then
		Return QueryTable[0].Ref;
	EndIf;
	Return Undefined;
EndFunction

Function GetPartnerInfo(Partner) Export
	Query = New Query();
	Query.Text =
	"SELECT ALLOWED TOP 1
	|	Table.Ref AS Partner
	|FROM
	|	Catalog.Partners AS Table
	|WHERE
	|	Table.Ref = &Ref";
	Query.SetParameter("Ref", Partner);
	QueryResult = Query.Execute();

	Result = New Structure();
	For Each Column In QueryResult.Columns Do
		Result.Insert(Column.Name);
	EndDo;

	Selection = QueryResult.Select();
	If Selection.Next() Then
		FillPropertyValues(Result, Selection);
	EndIf;
	Return Result;
EndFunction