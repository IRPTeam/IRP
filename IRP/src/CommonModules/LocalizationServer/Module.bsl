Function Strings(LangCode = "en") Export
	StringsStructure = Localization.Strings(LangCode);
	If LangCode <> "en" Then
		LocalisationStrings_df = Localization.Strings("en");
		For Each StringsStructureItem In StringsStructure Do
			If Not ValueIsFilled(StringsStructureItem.Value) Then
				StringsStructure[StringsStructureItem.Key] = LocalisationStrings_df[StringsStructureItem.Key];
			EndIf;
		EndDo; 
	EndIf;
	Return StringsStructure;
EndFunction

Function CatalogDescription(Ref, LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.GetLocalizationCode());
	If Not UseMultiLanguage(Ref.Metadata().FullName(), LangCode, AddInfo) Then
		Return Strings(Ref);
	EndIf;
	
	UsersL = Ref["Description_" + LangCode];
	If ValueIsFilled(UsersL) Then
		Return UsersL;
	EndIf;
	
	If ValueIsFilled(Ref["Description_en"]) Then
		Return Ref["Description_en"];
	EndIf;
	
	Return StrTemplate(R().Error_002, LangCode);
EndFunction

Function CatalogDescriptionWithAddAttributes(Ref, LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.UserLanguageCode());
	UsersL = New Array();
	For Each AddAttribute In Ref.AddAttributes Do
		If StrStartsWith("Catalog", Ref.Metadata().FullName()) Then
			UsersL.Add(LocalizationReuse.CatalogDescription(AddAttribute.Value, LangCode, AddInfo));
		Else
			UsersL.Add(String(AddAttribute.Value));
		EndIf;
	EndDo;
	
	UsersLStr = StrConcat(UsersL, "/");
	If ValueIsFilled(UsersLStr) Then
		Return UsersLStr;
	EndIf;
	
	If (TypeOf(Ref) = Type("CatalogRef.ItemKeys") Or TypeOf(Ref) = Type("CatalogRef.PriceKeys")) Then
		If ValueIsFilled(Ref.Item) Then
			Return LocalizationServer.CatalogDescription(Ref.Item, LangCode, AddInfo);
		EndIf;
	EndIf;
	Return StrTemplate(R().Error_005, LangCode);
EndFunction

Function AllDescription(AddInfo = Undefined) Export
	Array = New Array;
	For Each Description In Metadata.CommonAttributes Do
		If StrStartsWith(Description.Name, "Description_") Then
			Array.Add(Description.Name);
		EndIf;
	EndDo;
	Return Array;
EndFunction

Function UseMultiLanguage(MetadataFullName, LangCode = "", AddInfo = Undefined) Export
	LangCode = ?(ValueIsFilled(LangCode), LangCode, LocalizationReuse.UserLanguageCode());
	MetadataFullName = StrReplace(MetadataFullName, "Manager.", "Ref.");
	MetadataObject = Metadata.FindByFullName(MetadataFullName);
	DescriptionAttr = Metadata.CommonAttributes["Description_" + LangCode];
	Content = DescriptionAttr.Content.Find(MetadataObject);
	
	If NOT Content = Undefined Then
		If Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use
			Or (Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Auto
				And DescriptionAttr.AutoUse = Metadata.ObjectProperties.CommonAttributeAutoUse.Use) Then
			Return True;
		EndIf;
	EndIf;
	
	Return False;
EndFunction

Function GetLocalizationCode(AddInfo = Undefined) Export
	Return TrimAll(SessionParameters.LocalizationCode);
EndFunction

Function FieldsListForDescriptions(Val Source) Export
	Fields = New Array;
	If TypeOf(Source) = Type("CatalogManager.Currencies") Then
		Fields.Add("Code");
		Return Fields;
	ElsIf TypeOf(Source) = Type("CatalogManager.ItemKeys") Then
		Fields.Add("Specification");
		Fields.Add("Item");
		Fields.Add("Ref");
	ElsIf TypeOf(Source) = Type("CatalogManager.PriceKeys") Then
		Fields.Add("Ref");
		Return Fields;
	ElsIf TypeOf(Source) = Type("CatalogManager.IDInfoAddresses") Then
		Fields.Add("FullDescription");
		Return Fields;
	ElsIf NOT LocalizationReuse.UseMultiLanguage(Metadata.FindByType(TypeOf(Source)).FullName()) Then
		Fields.Add("Description");
		Return Fields;
	EndIf;
	For Each DescriptionName In AllDescription() Do
		Fields.Add(DescriptionName);
	EndDo;
	Return Fields;
EndFunction