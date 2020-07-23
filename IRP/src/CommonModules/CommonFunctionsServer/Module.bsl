Procedure SetConditionalAppearanceDataField(ThisObject,
		AttributeFullName = "List.Date", ItemName = "Date") Export
	
	PartsOfFullName = StrSplit(AttributeFullName, ".");
	NeedPartsOfFullName = 2;
	If PartsOfFullName.Count() <> NeedPartsOfFullName Then
		// Invalid value for the FullRequireName parameter.
		// The name of the attribute must be In the format "" <ListName>. <FieldName> "" '));
		Return;
	EndIf;
	
	ListAttribute = ThisObject[PartsOfFullName[0]];
	
	If TypeOf(ListAttribute) = Type("DynamicList") Then
		// DynamicList allows you to set conditional formatting using your own linker.
		// In this case, the ElementName parameter is ignored because the dynamic list composer
		// does Not know how the details of the list will be displayed, 
		// therefore the path to the details And values of selection And design
		// is the name of the attribute of the dynamic list.
		ConditionalAppearance = ListAttribute.ConditionalAppearance;
		PathToAttribute = PartsOfFullName[1];
		AppearanceFieldName = PathToAttribute;
	Else
		// Other lists, for example, Form DataTree:
		// do Not have their own linker, so they use the linker of the form itself.
		ConditionalAppearance = ThisObject.ConditionalAppearance;
		PathToAttribute = AttributeFullName;
		AppearanceFieldName = ItemName;
	EndIf;
	
	If Not ValueIsFilled(ConditionalAppearance.UserSettingID) Then
		ConditionalAppearance.UserSettingID = "BasicAppearance";
	EndIf;
	
	// By default, the view "06/10/2012" is used.
	ItemOfAppearance = ConditionalAppearance.Items.Add();
	ItemOfAppearance.Use = True;
	ItemOfAppearance.Appearance.SetParameterValue("Format", "DLF=D;");
	
	AppearanceField = ItemOfAppearance.Fields.Items.Add();
	AppearanceField.Field = New DataCompositionField(AppearanceFieldName);
	
	// For today, the views "09:46" are used.
	ItemOfAppearance = ConditionalAppearance.Items.Add();
	ItemOfAppearance.Use = True;
	ItemOfAppearance.Appearance.SetParameterValue("Format", "DF=HH:mm;");
	
	AppearanceField = ItemOfAppearance.Fields.Items.Add();
	AppearanceField.Field = New DataCompositionField(AppearanceFieldName);
	
	ItemOfFilter = ItemOfAppearance.Filter.Items.Add(Type("DataCompositionFilterItem"));
	ItemOfFilter.LeftValue = New DataCompositionField(PathToAttribute);
	ItemOfFilter.ComparisonType = DataCompositionComparisonType.GreaterOrEqual;
	ItemOfFilter.RightValue = New StandardBeginningDate(StandardBeginningDateVariant.BeginningOfThisDay);
	
	ItemOfFilter = ItemOfAppearance.Filter.Items.Add(Type("DataCompositionFilterItem"));
	ItemOfFilter.LeftValue = New DataCompositionField(PathToAttribute);
	ItemOfFilter.ComparisonType = DataCompositionComparisonType.Less;
	ItemOfFilter.RightValue = New StandardBeginningDate(StandardBeginningDateVariant.BeginningOfNextDay);
EndProcedure

Function IsPrimitiveValue(Value) Export
	Return Metadata.FindByType(TypeOf(Value)) = Undefined;
EndFunction

Function IsDocumentRef(Value) Export
	Return Documents.AllRefsType().ContainsType(TypeOf(Value));
EndFunction

Function SerializeJSON(Value, AddInfo = Undefined) Export
	Writer = New JSONWriter();
	Writer.SetString();
	WriteJSON(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

Function SerializeXMLUseXDTO(Value, AddInfo = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOSerializer.WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

Function SerializeXMLUseXDTOFactory(Value, LocalName = Undefined, URI = Undefined, AddInfo = Undefined, WSName = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOFactoryObject(WSName).WriteXML(Writer, Value, LocalName, URI);
	Result = Writer.Close();
	Return Result;
EndFunction

Function XDTOFactoryObject(WSName = Undefined) Export
	If NOT ValueIsFilled(WSName) Then
		Return XDTOFactory;
	Else
		Return WSReferences[WSName].GetWSDefinitions().XDTOFactory;
	EndIf;
EndFunction

Function DeserializeJSON(Value, AddInfo = Undefined) Export
	Reader = New JSONReader();
	Reader.SetString(Value);
	Result = ReadJSON(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function DeserializeXMLUseXDTO(Value, AddInfo = Undefined) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOSerializer.ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function DeserializeXMLUseXDTOFactory(Value, Type = Undefined, AddInfo = Undefined, WSName = Undefined) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOFactoryObject(WSName).ReadXML(Reader, Type);
	Reader.Close();
	Return Result;
EndFunction

Function SerializeXML(Value, AddInfo = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

Function DeserializeXML(Value, AddInfo = Undefined) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function GetCurrentUniversalDate() Export
	Return CurrentUniversalDate();
EndFunction

Function GetCurrentSessionDate() Export
	Return CurrentSessionDate();
EndFunction

Function FormHaveAttribute(Form, AttributeName) Export
	For Each FormAttribute In Form.GetAttributes() Do
		If FormAttribute.Name = AttributeName Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction

Function XSLTransformation(XML, XSLT) Export
	XSLTransform = New XSLTransform;
    XSLTransform.LoadFromString(XSLT);
    Return XSLTransform.TransformFromString(XML);
EndFunction

#Region QueryBuilder

Function QueryTable(ObjectName, ObjectServerModule, CustomParameters) Export
	QueryText = GetQueryText(ObjectName, CustomParameters.OptionsString, CustomParameters.Fields);
	QueryBuilder = New QueryBuilder(QueryText);
	QueryBuilder.FillSettings();
	SetQueryBuilderFilters(QueryBuilder, CustomParameters.Filters);
	Query = QueryBuilder.GetQuery();
	ObjectServerModule.SetQueryComplexFilters(Query, CustomParameters.ComplexFilters);	
	QueryTable = Query.Execute().Unload();
	Return QueryTable;
EndFunction

Function GetQueryText(ObjectName, QueryOptionsString, Fields) Export
	QueryTextArray = New Array;		
	QueryTextArray.Add("SELECT " + QueryOptionsString);		

	QueryFieldsArray = New Array;
	For Each Field In Fields Do
		QueryFieldsArray.Add("Table." + Field.Value + ?(Field.Key <> Field.Value, " AS " + Field.Key, ""));
	EndDo;	
	QueryFieldsString = StrConcat(QueryFieldsArray, "," + Chars.LF);
	
	QueryFieldsString = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(QueryFieldsString);
	QueryTextArray.Add(QueryFieldsString);
	
	QueryTextArray.Add("FROM " + ObjectName + " AS Table");
	QueryTextArray.Add("WHERE");
	QueryTextArray.Add("TRUE");
	QueryText = StrConcat(QueryTextArray, Chars.LF);	
	
	Return QueryText;
EndFunction

Procedure SetQueryBuilderFilters(QueryBuilder, QueryFilters)
	QueryBuilderFilter = QueryBuilder.Filter;
	For Each QueryFilter In QueryFilters Do
		FoundedFilter = QueryBuilderFilter.Find(QueryFilter.FieldName);
		If FoundedFilter = Undefined Then
			FilterItem = QueryBuilderFilter.Add("Ref." + QueryFilter.FieldName);
		Else
			FilterItem = FoundedFilter;
		EndIf;
		FilterItem.Use = True;
		FilterItem.ComparisonType = QueryFilter.ComparisonType;
		FilterItem.Value = QueryFilter.Value;
	EndDo;	
EndProcedure

#EndRegion