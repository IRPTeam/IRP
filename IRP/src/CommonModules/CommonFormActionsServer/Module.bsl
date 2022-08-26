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
	|	%5
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
	If Settings.MetadataObject = Metadata.Catalogs.Items Then
		IDSearch = "Table.Ref.ItemID LIKE &SearchString + ""%%""";

		If Settings.MetadataObject.CodeLength And Settings.MetadataObject.CodeType = Metadata.ObjectProperties.CatalogCodeType.Number Then
			NumberSearch = "Table.Ref.Code = &SearchStringNumber";
		EndIf;
	EndIf;
	
	If Settings.Property("UseSearchByCode") And Settings.UseSearchByCode Then
		NumberSearch = "Table.Ref.Code = &SearchStringNumber";
	EndIf;
	
	If Not Settings.MetadataObject.DescriptionLength Then
		QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter, "_" + "en", IDSearch, NumberSearch);
		QueryField = "CASE WHEN %1.Description%2 = """" THEN %1.Description_en ELSE %1.Description%2 END ";
		QueryField = StrTemplate(QueryField, "Table", "_" + LocalizationReuse.GetLocalizationCode());
		QueryText = StrReplace(QueryText, StrTemplate("%1.Description_en", "Table"), QueryField);
	Else
		QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter, "", IDSearch, NumberSearch);
	EndIf;

	Return QueryText;
EndFunction

Function QueryTableToChoiceData(QueryTable) Export
	ChoiceData = New ValueList();

	For Each Row In QueryTable Do
		If Not ChoiceData.FindByValue(Row.Ref) = Undefined Then
			Continue;
		EndIf;
		
		If Row.Sort = 0 Then
			ChoiceData.Add(Row.Ref, "[" + Row.Ref.Code + "] " + Row.Presentation, False, PictureLib.AddToFavorites);
		ElsIf Row.Sort = 1 Then
			If IsBlankString(Row.Ref.ItemID) Then
				ChoiceData.Add(Row.Ref, Row.Presentation, False, PictureLib.Price);
			Else
				ChoiceData.Add(Row.Ref, "(" + Row.Ref.ItemID + ") " + Row.Presentation, False, PictureLib.Price);
			EndIf;
		Else
			ChoiceData.Add(Row.Ref, Row.Presentation);
		EndIf;
	EndDo;
	
	Return ChoiceData;
EndFunction


