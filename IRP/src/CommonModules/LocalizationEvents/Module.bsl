
#Region Public

Procedure FindDataForInputStringChoiceDataGetProcessing(Source, ChoiceData, Parameters, StandardProcessing) Export
	
	If Not StandardProcessing Or Not ValueIsFilled(Parameters.SearchString) Then
		Return;
	EndIf;
	
	StandardProcessing = False;

	MetadataObject = Metadata.FindByType(Type(Source));
	Settings = New Structure;
	Settings.Insert("MetadataObject", MetadataObject);
	Settings.Insert("Filter", "");
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	
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

Function ReplaceDescriptionLocalizationPrefix(QueryText, TableName = "Table") Export
	QueryField = "CASE WHEN %1.Description_%2 = """" THEN %1.Description_en ELSE %1.Description_%2 END ";
	QueryField = StrTemplate(QueryField, TableName, LocalizationReuse.GetLocalizationCode());
	Return StrReplace(QueryText, StrTemplate("%1.Description_en", TableName), QueryField);
EndFunction

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
		MetadataValue = Metadata.CommonAttributes[AttributeName];
		
		ArrayOfNewFormAttributes.Add(New FormAttribute(MetadataValue.Name
				, MetadataValue.Type
				,
				, String(MetadataValue)
				, True));
	EndDo;
	
	Form.ChangeAttributes(ArrayOfNewFormAttributes);
	
	For Each AttributeName In AttributeNames Do
		MetadataValue = Metadata.CommonAttributes[AttributeName];
		If Form.Items.Find(AttributeName) = Undefined Then
			NewAttribute = Form.Items.Add(MetadataValue.Name, Type("FormField"), ParentGroup);
			NewAttribute.Type = FormFieldType.InputField;
			NewAttribute.DataPath = MetadataValue.Name;
			
			Form[MetadataValue.Name] = Values[MetadataValue.Name];
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

Procedure BeforeWrite_DescriptionsCheckFilling(Source, Cancel) Export
	CheckDescriptionFilling(Source, Cancel);
	CheckDescriptionDuplicate(Source, Cancel);
EndProcedure

Procedure FillCheckProcessing_DescriptionCheckFilling(Source, Cancel, CheckedAttributes) Export
	CheckDescriptionFilling(Source, Cancel);
	CheckDescriptionDuplicate(Source, Cancel);
EndProcedure

#EndRegion

#Region Private

Procedure CheckDescriptionFilling(Source, Cancel)
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

Procedure CheckDescriptionDuplicate(Source, Cancel)
	If Cancel
		Or TypeOf(Source) = Type("Structure")
		Or Not CatConfigurationMetadataServer.CheckDescriptionDuplicateEnabled(Source) Then
		Return;
	EndIf;
	
	SourceMetadata = Source.Metadata();	
	UseMultiLanguage = LocalizationReuse.UseMultiLanguage(SourceMetadata.FullName());
	If UseMultiLanguage Then
		AllDescription = LocalizationReuse.AllDescription();
	Else
		AllDescription = New Array;
		If	ServiceSystemClientServer.ObjectHasAttribute("Description", Source)
			And ValueIsFilled(Source.Description) Then
			AllDescription.Add("Description");
		EndIf;
	EndIf;
	QueryFieldsSection = New Array;
	QueryConditionsSection = New Array;
	DescriptionAttributes = New Array;
	
	Query = New Query;
	Query.Text = "SELECT
		|	""%1"",
		|	%2
		|FROM
		|	Catalog.%1 AS Cat
		|WHERE
		|	(%3)
		|	AND Cat.Ref <> &Ref
		|GROUP BY
		|	""%1""";
	For Each Attribute In AllDescription Do
		If ValueIsFilled(Source[Attribute]) Then
			FieldLeftString = "Cat." + Attribute + " = &" + Attribute;
			FieldString = "ISNUll(MAX(" + FieldLeftString + "), FALSE) AS " + Attribute;
			QueryFieldsSection.Add(FieldString);
			QueryConditionsSection.Add(FieldLeftString);
			Query.SetParameter(Attribute, Source[Attribute]);
			DescriptionAttributes.Add(Attribute);
		EndIf;
	EndDo;
	If Not DescriptionAttributes.Count() Then
		Return;
	EndIf;
	QueryFields = StrConcat(QueryFieldsSection, "," + Chars.LF + "	");
	QueryConditions = StrConcat(QueryConditionsSection, Chars.LF + "	OR ");
	Query.Text = StrTemplate(Query.Text, SourceMetadata.Name, QueryFields, QueryConditions);
	Query.SetParameter("Ref", Source.Ref);
	
	QueryExecution = Query.Execute();
	QuerySelection = QueryExecution.Select();
	QuerySelection.Next();
	For Each DescriptionAttribute In DescriptionAttributes Do
		If QuerySelection[DescriptionAttribute] Then
			If Not Cancel Then
				Cancel = True;
			EndIf;
			LangCode = StrReplace(DescriptionAttribute, "Description", "");
			DescriptionLanguage = ?(IsBlankString(LangCode), "", " (" + StrReplace(LangCode, "_", "") + ")");
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_089, DescriptionLanguage, Source[DescriptionAttribute]));
		EndIf;
	EndDo;
EndProcedure

#EndRegion