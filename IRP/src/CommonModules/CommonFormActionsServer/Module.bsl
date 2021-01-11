
Function RestoreFillingData(Val FillingData) Export
	If Not ValueIsFilled(FillingData) Then
		Return Undefined;
	EndIf;
	Return CommonFunctionsServer.DeserializeXMLUseXDTO(FillingData);
EndFunction

Function QuerySearchInputByString(Settings) Export

	QueryText = 
		"SELECT ALLOWED TOP 10
		|	Table.Ref AS Ref,
		|	Table.Presentation AS Presentation,
		|	3 AS Sort
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
		|	1 AS Sort
		|INTO TempVT
		|FROM
		|	%1 AS Table
		|WHERE
		|	Table.Description%3 LIKE &SearchString + ""%%""
		| %2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED TOP 10
		|	Table.Ref AS Ref,
		|	Table.Presentation AS Presentation,
		|	2 AS Sort
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
		| %2
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

	If Not Settings.MetadataObject.DescriptionLength Then
		IDSearch = "False";
		If Settings.MetadataObject = Metadata.Catalogs.Items Then
			IDSearch = "Table.Ref.ItemID LIKE &SearchString + ""%%""";
		EndIf;
		
		
		QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter , "_" + "en", IDSearch);
		QueryField = "CASE WHEN %1.Description%2 = """" THEN %1.Description_en ELSE %1.Description%2 END ";
		QueryField = StrTemplate(QueryField, "Table", "_" + LocalizationReuse.GetLocalizationCode());
		QueryText = StrReplace(QueryText, StrTemplate("%1.Description_en", "Table"), QueryField);
	Else
		QueryText = StrTemplate(QueryText, Settings.MetadataObject.FullName(), Settings.Filter, "");
	EndIf;
	Return 	QueryText;
EndFunction

