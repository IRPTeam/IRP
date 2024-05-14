Function RestoreFillingData(Val FillingData) Export
	If Not ValueIsFilled(FillingData) Then
		Return Undefined;
	EndIf;
	Return CommonFunctionsServer.DeserializeXMLUseXDTO(FillingData);
EndFunction

// Query search input by string.
//
// Parameters:
//  Settings - Structure:
//  	* MetadataObject - MetadataObjectCatalog -
//  	* Filter - String -
//
// Returns:
//  String - Query search input by string
Function QuerySearchInputByString(Settings) Export

	QueryText =
	"SELECT ALLOWED TOP 10
	|	Table.Ref AS Ref,
	|	Table.Presentation AS Presentation,
	|	1 AS Sort
	|INTO TempVTViaID
	|FROM
	|	%1 AS Table
	|WHERE
	|	%4
	|;
	|
	|SELECT ALLOWED TOP 10
	|	Table.Ref AS Ref,
	|	Table.Presentation AS Presentation,
	|	0 AS Sort
	|INTO TempVTViaNumber
	|FROM
	|	%1 AS Table
	|WHERE
	|	%5 %2
	|;
	|
	|SELECT ALLOWED TOP 10
	|	Table.Ref AS Ref,
	|	Table.Presentation AS Presentation,
	|	2 AS Sort
	|INTO TempVT
	|FROM
	|	%1 AS Table
	|WHERE
	|	Table.Description%3 LIKE &SearchString + ""%%""
	|%2
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT ALLOWED TOP 10
	|	Table.Ref AS Ref,
	|	Table.Presentation AS Presentation,
	|	3 AS Sort
	|INTO TempVTSecond
	|FROM
	|	%1 AS Table
	|WHERE
	|	Table.Description%3 LIKE ""%%"" + &SearchString + ""%%""
	|	AND NOT Table.Ref IN
	|				(SELECT
	|					T.Ref
	|				FROM
	|					TempVT AS T)
	|%2
	|
	|;
	|
	|SELECT TOP 10 DISTINCT
	|	TempVT.Ref AS Ref,
	|	TempVT.Presentation AS Presentation,
	|	TempVT.Sort AS Sort
	|FROM
	|	TempVTViaID AS TempVT
	|
	|UNION
	|
	|SELECT TOP 10 DISTINCT
	|	TempVTViaNumber.Ref AS Ref,
	|	TempVTViaNumber.Presentation AS Presentation,
	|	TempVTViaNumber.Sort AS Sort
	|FROM
	|	TempVTViaNumber AS TempVTViaNumber
	|
	|UNION
	|
	|SELECT TOP 10
	|	TempVT.Ref AS Ref,
	|	TempVT.Presentation AS Presentation,
	|	TempVT.Sort AS Sort
	|FROM
	|	TempVT AS TempVT
	|
	|UNION
	|
	|SELECT TOP 10
	|	TempVTSecond.Ref,
	|	TempVTSecond.Presentation,
	|	TempVTSecond.Sort
	|FROM
	|	TempVTSecond AS TempVTSecond
	|ORDER BY
	|	Sort,
	|	Presentation";

	IDSearch = "False";
	NumberSearch = "False";
	UseDescriptionSearch = Settings.MetadataObject.DescriptionLength > 0;
	
	If Settings.MetadataObject = Metadata.Catalogs.Items Then
		IDSearch = "Table.Ref.ItemID LIKE &SearchString + ""%%""";

		If Settings.MetadataObject.CodeLength And Settings.MetadataObject.CodeType = Metadata.ObjectProperties.CatalogCodeType.Number Then
			NumberSearch = "Table.Ref.Code = &SearchStringNumber";
		EndIf;
	ElsIf Settings.MetadataObject = Metadata.Catalogs.Users Then
		IDSearch = "Table.Description LIKE &SearchString + ""%%""";
		UseDescriptionSearch = False;
	ElsIf Settings.MetadataObject = Metadata.ChartsOfAccounts.Basic Then
		IDSearch = "Table.Ref.SearchCode LIKE &SearchString + ""%%""";
	EndIf;
	
	If Settings.Property("UseSearchByCode") And Settings.UseSearchByCode Then
		NumberSearch = "Table.Ref.Code = &SearchStringNumber";
	EndIf;
	
	If Not UseDescriptionSearch Then
		If CommonFunctionsServer.isCommonAttributeUseForMetadata("Description_en", Settings.MetadataObject) Then
			QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter, "_" + "en", IDSearch, NumberSearch);
			QueryField = "CASE WHEN %1.Description%2 = """" THEN %1.Description_en ELSE %1.Description%2 END ";
			QueryField = StrTemplate(QueryField, "Table", "_" + LocalizationReuse.GetLocalizationCode());
			QueryText = StrReplace(QueryText, StrTemplate("%1.Description_en", "Table"), QueryField);
		Else
			QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter, "", IDSearch, NumberSearch);
			QueryText = StrReplace(QueryText, "Table.Description LIKE &SearchString + ""%""", " FALSE ");
			QueryText = StrReplace(QueryText, "Table.Description LIKE ""%"" + &SearchString + ""%""", " FALSE ");
		EndIf;
	Else
		QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter, "", IDSearch, NumberSearch);
	EndIf;

	Return QueryText;
EndFunction

Procedure CutLastSymbolsIfCameFromExcel(Parameters) Export
	If StrEndsWith(Parameters.SearchString, "¶") Then 
		Parameters.SearchString = Left(Parameters.SearchString, StrLen(Parameters.SearchString) - 1);
	EndIf;
EndProcedure

Procedure SetCustomSearchFilter(QueryBuilder, Parameters) Export
	If TypeOf(Parameters) = Type("Structure") And Parameters.Filter.Property("CustomSearchFilter") Then
		ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
		For Each Filter In ArrayOfFilters Do
			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
			NewFilter.Use = True;
			NewFilter.ComparisonType = Filter.ComparisonType;
			NewFilter.Value = Filter.Value;
		EndDo;
	EndIf;
EndProcedure

// Set standard search filter.
// 
// Parameters:
//  QueryBuilder - QueryBuilder - Query builder
//  Parameters - Structure - Parameters
//  SourceMetadata - MetadataObjectCatalog - Source metadata
Procedure SetStandardSearchFilter(QueryBuilder, Parameters, SourceMetadata) Export
	If TypeOf(Parameters) = Type("Structure") Then
		For Each Filter In Parameters.Filter Do
			If Upper(Filter.Key) = Upper("CustomSearchFilter") Then
				Continue;
			EndIf;
			
			// When current search into add attribute field
			If Filter.Key = "Owner" And Not SourceMetadata.Owners.Contains(Filter.Value.Metadata()) Then
				Continue;
			EndIf;
			
			NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.Key);
			NewFilter.Use = True;
			NewFilter.ComparisonType = ComparisonType.Equal;
			NewFilter.Value = Filter.Value;
		EndDo;
	EndIf;
EndProcedure

Function QueryTableToChoiceData(QueryTable) Export
	ChoiceData = New ValueList();

	For Each Row In QueryTable Do
		If Not ChoiceData.FindByValue(Row.Ref) = Undefined Then
			Continue;
		EndIf;
		
		If Row.Sort = 0 Then
			ChoiceData.Add(Row.Ref, "[" + Row.Ref.Code + "] " + Row.Presentation, False, PictureLib.AddToFavorites);
		ElsIf Row.Sort = 1 Then
			If TypeOf(Row.Ref) = Type("CatalogRef.Items") And Not IsBlankString(Row.Ref.ItemID) Then
				ChoiceData.Add(Row.Ref, "(" + Row.Ref.ItemID + ") " + Row.Presentation, False, PictureLib.Price);
			ElsIf TypeOf(Row.Ref) = Type("CatalogRef.Users") Then
				ChoiceData.Add(Row.Ref, Row.Presentation + " (" + Row.Ref.Description + ")", False, PictureLib.AddToFavorites);
			ElsIf TypeOf(Row.Ref) = Type("ChartOfAccountsRef.Basic") And Not IsBlankString(Row.Ref.SearchCode) Then
				ChoiceData.Add(Row.Ref, "(" + Row.Ref.SearchCode + ") " + Row.Presentation, False, PictureLib.ChartOfAccounts);
			Else
				ChoiceData.Add(Row.Ref, Row.Presentation, False, PictureLib.Price);
			EndIf;
		Else
			ChoiceData.Add(Row.Ref, Row.Presentation);
		EndIf;
	EndDo;
	
	Return ChoiceData;
EndFunction

Function GetMetadataFullName(Ref) Export
	Return Ref.Metadata().FullName();
EndFunction
