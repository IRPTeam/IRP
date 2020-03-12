Procedure DescriptionsFillCheckProcessing(Source, Cancel, CheckedAttributes) Export
	If Cancel Or TypeOf(Source) = Type("Structure")
		Or Not LocalizationReuse.UseMultiLanguage(Source.Metadata().FullName()) Then
		Return;
	EndIf;
	
	IsFilledDescription = False;
	For Each Attribute In LocalizationReuse.AllDescription() Do
		If ValueIsFilled(Source[Attribute]) Then
			IsFilledDescription = True;
			Break;
		EndIf;
	EndDo;
	If NOT IsFilledDescription Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_003);
	EndIf;
EndProcedure

Procedure FindDataForInputStringChoiceDataGetProcessing(Source, ChoiceData, Parameters, StandardProcessing) Export
	
	If Not StandardProcessing Or Not ValueIsFilled(Parameters.SearchString) Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	
	QueryBuilderText =
		"SELECT ALLOWED TOP 50
		|	Table.Ref,
		|	Table.Presentation
		|FROM
		|	TableType.%1 AS Table
		|WHERE
		|	Table.Description_en LIKE ""%2"" + &SearchString + ""%2""";
	
	MetadataObject = Metadata.FindByType(Type(Source));
	If Metadata.Catalogs.Contains(MetadataObject) Then
		QueryBuilderText = StrReplace(QueryBuilderText, "TableType", "Catalog");
	ElsIf Metadata.ChartsOfCharacteristicTypes.Contains(MetadataObject) Then
		QueryBuilderText = StrReplace(QueryBuilderText, "TableType", "ChartOfCharacteristicTypes");
	Else
		Raise R().Error_004;
	EndIf;
	
	QueryBuilderText = StrTemplate(QueryBuilderText, MetadataObject.Name, "%");
	QueryBuilderText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(QueryBuilderText);
	
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	
	UserSettingFilterParameters = New Structure();
	UserSettingFilterParameters.Insert("AttributeName", UserSettingsServer.GetPredefinedUserSettingNames().USE_OBJECT_WITH_DELETION_MARK);
	UserSettingFilterParameters.Insert("MetadataObject", Source.EmptyRef().Metadata());
	UserSettings = UserSettingsServer.GetUserSettings(Undefined, UserSettingFilterParameters);

	UseObjectWithDeletionMark = True;
	If UserSettings.Count() Then
		UseObjectWithDeletionMark = UserSettings[0].Value;
	EndIf;
	
	If Not UseObjectWithDeletionMark Then
		NewFilter = QueryBuilder.Filter.Add("Ref.DeletionMark");
		NewFilter.Use = True;
		NewFilter.ComparisonType = ComparisonType.NotEqual;
		NewFilter.Value = True;
	EndIf;	
	
	If TypeOf(Parameters) = Type("Structure") Then
		For Each Filter In Parameters.Filter Do
			If Upper(Filter.Key) = Upper("CustomSearchFilter") Then
				ArrayOfFilters = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.Filter.CustomSearchFilter);
				For Each Filter In ArrayOfFilters Do
					NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.FieldName);
					NewFilter.Use = True;
					NewFilter.ComparisonType = Filter.ComparisonType;
					NewFilter.Value = Filter.Value;
				EndDo;
			Else
				NewFilter = QueryBuilder.Filter.Add("Ref." + Filter.Key);
				NewFilter.Use = True;
				NewFilter.ComparisonType = ComparisonType.Equal;
				NewFilter.Value = Filter.Value;
			EndIf;
		EndDo;
	EndIf;
	Query = QueryBuilder.GetQuery();
	
	Query.SetParameter("SearchString", Parameters.SearchString);
	
	ChoiceData = New ValueList();
	QueryTable = Query.Execute().Unload();
	For Each Row In QueryTable Do
		ChoiceData.Add(Row.Ref, Row.Presentation);
	EndDo;
EndProcedure


Procedure GetCatalogPresentation(Source, Data, Presentation, StandardProcessing) Export
	If Not StandardProcessing Then
		Return;
	EndIf;
	StandardProcessing = False;
	SourceType = TypeOf(Source);
	If SourceType = Type("CatalogManager.ItemKeys") Then		
		If ValueIsFilled(Data.Specification) Then
			Presentation = String(Data.Item) + "/" + String(Data.Specification);
		Else
			Presentation = LocalizationReuse.CatalogDescriptionWithAddAttributes(Data.Ref);
		EndIf;
	ElsIf SourceType = Type("CatalogManager.Currencies") Then		
		Presentation = Data.Code;
	ElsIf SourceType = Type("CatalogManager.PriceKeys") Then
		Presentation = LocalizationReuse.CatalogDescriptionWithAddAttributes(Data.Ref);
	ElsIf Data.Property("Description") Then
		Presentation = Data["Description"];
	ElsIf Data.Property("FullDescription") Then
		Presentation = Data["FullDescription"];
	Else
		Presentation = Data["Description_" + LocalizationReuse.UserLanguageCode()];
		If Presentation = "" Then
			For Each KeyData In Data Do
				If KeyData.Value = "" Then 
					Continue;
				EndIf;
				Presentation = KeyData.Value;				
			EndDo;
			
			If Presentation = "" Then
				Presentation = StrTemplate(R().Error_002, LocalizationReuse.UserLanguageCode());
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Function ReplaceDescriptionLocalizationPrefix(QueryText, TableName = "Table") Export
	QueryField = "CASE WHEN %1.Description_%2 = """" THEN %1.Description_en ELSE %1.Description_%2 END ";
	QueryField = StrTemplate(QueryField, TableName, LocalizationReuse.GetLocalizationCode());
	Return StrReplace(QueryText, StrTemplate("%1.Description_en", TableName), QueryField);
EndFunction

Procedure RefreshReusableValuesBeforeWrite(Source, Cancel) Export
	RefreshReusableValues();
EndProcedure

Procedure CreateMainFormItemDescription(Form, GroupName, AddInfo = Undefined) Export
	ParentGroup = Form.Items.Find(GroupName);
	ParentGroup.Group = ChildFormItemsGroup.Vertical;
	
	If ParentGroup = Undefined Then
		Return;
	EndIf;
	
	LocalizationCode = LocalizationReuse.GetLocalizationCode();
	If Upper(TrimAll(LocalizationCode)) <> Upper(TrimAll("en")) Then
		NewAttribute = Form.Items.Add("Description_en", Type("FormField"), ParentGroup);
		NewAttribute.Type = FormFieldType.LabelField;
		NewAttribute.Hyperlink = True;
		NewAttribute.DataPath = "Object.Description_en";
		NewAttribute.SetAction("Click", "DescriptionOpening");
	EndIf;
	
	For Each Attribute In LocalizationReuse.AllDescription() Do
		If Form.Items.Find(Attribute) <> Undefined Then
			Continue;
		EndIf;
		
		If StrEndsWith(Attribute, LocalizationCode) Then
			NewAttribute = Form.Items.Add(Attribute, Type("FormField"), ParentGroup);
			NewAttribute.Type = FormFieldType.InputField;
			NewAttribute.DataPath = "Object." + Attribute;
			NewAttribute.OpenButton = True;
			NewAttribute.AutoMarkIncomplete = True;
			NewAttribute.SetAction("Opening", "DescriptionOpening");
		EndIf;
	EndDo;
EndProcedure

Procedure CreateSubFormItemDescription(Form, Values, GroupName, AddInfo = Undefined) Export
	ParentGroup = Form.Items.Find(GroupName);
	ParentGroup.Group = ChildFormItemsGroup.Vertical;
	
	If ParentGroup = Undefined Then
		Return;
	EndIf;
	
	AttributeNames = LocalizationReuse.AllDescription();
	
	ArrayOfNewFormAttributes = New Array();
	
	For Each AttributeName In AttributeNames Do
		MetadataInfo = Metadata.CommonAttributes[AttributeName];
		
		ArrayOfNewFormAttributes.Add(New FormAttribute(MetadataInfo.Name
				, MetadataInfo.Type
				,
				, String(MetadataInfo)
				, True));
	EndDo;
	
	Form.ChangeAttributes(ArrayOfNewFormAttributes);
	
	For Each AttributeName In AttributeNames Do
		MetadataInfo = Metadata.CommonAttributes[AttributeName];
		If Form.Items.Find(AttributeName) = Undefined Then
			NewAttribute = Form.Items.Add(MetadataInfo.Name, Type("FormField"), ParentGroup);
			NewAttribute.Type = FormFieldType.InputField;
			NewAttribute.DataPath = MetadataInfo.Name;
			
			Form[MetadataInfo.Name] = Values[MetadataInfo.Name];
		EndIf;
	EndDo;
EndProcedure

Procedure GetCatalogPresentationFieldsPresentationFieldsGetProcessing(Source, Fields, StandardProcessing) Export
	If Not StandardProcessing Then
		Return;
	EndIf;
	StandardProcessing = False;
	Fields = LocalizationServer.FieldsListForDescriptions(Source);
	
EndProcedure



