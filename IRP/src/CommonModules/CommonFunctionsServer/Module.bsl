Function IsPrimitiveValue(Value) Export
	Return Metadata.FindByType(TypeOf(Value)) = Undefined;
EndFunction

Function IsDocumentRef(Value) Export
	Return Documents.AllRefsType().ContainsType(TypeOf(Value));
EndFunction

Function GetCommonTemplateByName(Name, GetFromStorage = False) Export
	If GetFromStorage Then
		Return GetCommonTemplate(Name).Get();
	Else
		Return GetCommonTemplate(Name);
	EndIf;
EndFunction

Function GetRefAttribute(Ref, Name) Export
	Return Ref[Name];
EndFunction

Function SerializeJSON(Value, AddInfo = Undefined) Export
	Writer = New JSONWriter();
	Writer.SetString();
	WriteJSON(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

Function SerializeJSONUseXDTO(Value, AddInfo = Undefined) Export
	Writer = New JSONWriter();
	Writer.SetString();
	XDTOSerializer.WriteJSON(Writer, Value, XMLTypeAssignment.Explicit);
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

Function DeserializeJSONUseXDTO(Value, AddInfo = Undefined) Export
	Reader = New JSONReader();
	Reader.SetString(Value);
	Result = XDTOSerializer.ReadJSON(Reader);
	Reader.Close();
	Return Result;
EndFunction

Function SerializeJSONUseXDTOFactory(Value, AddInfo = Undefined) Export
	Writer = New JSONWriter();
	Writer.SetString();
	XDTOFactory.WriteJSON(Writer, Value);
	ResultTmp = Writer.Close();
	Object = DeserializeJSON(ResultTmp, True, AddInfo);
	Result = SerializeJSON(Object.Get("#value"), AddInfo);
	Return Result;
EndFunction

Function SerializeXMLUseXDTOFactory(Value, LocalName = Undefined, URI = Undefined, AddInfo = Undefined,
	WSName = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOFactoryObject(WSName).WriteXML(Writer, Value, LocalName, URI);
	Result = Writer.Close();
	Return Result;
EndFunction

Function XDTOFactoryObject(WSName = Undefined) Export
	If IsBlankString(WSName) Then
		Return XDTOFactory;
	Else
		If TypeOf(WSName) = Type("String") Then
			Return WSReferences[WSName].GetWSDefinitions().XDTOFactory;
		Else
			Return WSName.XDTOFactory;
		EndIf;
	EndIf;
EndFunction

Function DeserializeJSON(Value, IsMap = False, AddInfo = Undefined) Export
	Reader = New JSONReader();
	Reader.SetString(Value);
	Result = ReadJSON(Reader, IsMap);
	Reader.Close();
	Return Result;
EndFunction

Function DeserializeJSONUseXDTOFactory(Value, Type = Undefined, AddInfo = Undefined, WSName = Undefined) Export
	
	ValueTmp = "{""#value"":" + Value + "}";
	
	Reader = New JSONReader();
	Reader.SetString(ValueTmp);
	Result = XDTOFactory.ReadJSON(Reader, Type);
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

// Deserialize XMLUse XDTOFactory.
// 
// Parameters:
//  Value - String - Value
//  Type - XDTOValueType, XDTOObjectType, Undefined - XDTO Type
//  AddInfo - Structure - Add info
//  WSName - WSDefinitions, Undefined - WSName
// 
// Returns:
//  XDTODataObject
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
	XSLTransform = New XSLTransform();
	XSLTransform.LoadFromString(XSLT);
	Return XSLTransform.TransformFromString(XML);
EndFunction

// Get style by name.
// 
// Parameters:
//  Name - String - Name
// 
// Returns:
//  Color
Function GetStyleByName(Name) Export
	Return StyleColors[Name];
EndFunction

Function GetMD5(Object) Export
	DataToString = ValueToStringInternal(Object);
	DataHashing = New DataHashing(HashFunction.MD5);
	DataHashing.Append(DataToString);
	HashSumString = StrReplace(String(DataHashing.HashSum), " ", "");
	HashSumStringUUID = Left(HashSumString, 8) 	  + "-" + 
						Mid(HashSumString, 9, 4)  + "-" + 
						Mid(HashSumString, 15, 4) + "-" + 
						Mid(HashSumString, 18, 4) + "-" + 
						Right(HashSumString, 12);
	Return Upper(HashSumStringUUID);
EndFunction

Procedure Pause(Time) Export

    If Number(Time) < 1 Then
    	Return;
    EndIf;

    Job = GetCurrentInfoBaseSession().GetBackgroundJob();

    If Job = Undefined Then
        Params = New Array;
        Params.Add(Time);
        MethodName = "CommonFunctionsServer.Pause";
        Job = ConfigurationExtensions.ExecuteBackgroundJobWithoutExtensions(MethodName, Params);
    EndIf;

    Job.WaitForExecutionCompletion(Time);

EndProcedure

Function GetURLFromNavigationLink(Link) Export
	Five = 5;
	Nine = 9;
	Eleven = 11;
    FirstDot = StrFind(Link, "e1cib/data/");
    Predefined = StrFind(Link, "?refName=");
    If Predefined Then
		SecondDot = Predefined;
	Else
    	SecondDot = StrFind(Link, "?ref=");
    EndIf;    
    TypePresentation = Mid(Link, FirstDot + Eleven, SecondDot - FirstDot - Eleven);
    If Predefined Then
    	ValueTemplate = ValueToStringInternal(PredefinedValue(TypePresentation + "." + Mid(Link, SecondDot + Nine)));
    	LinkValue = ValueTemplate;
    Else
    	ValueTemplate = ValueToStringInternal(PredefinedValue(TypePresentation + ".EmptyRef"));
    	LinkValue = StrReplace(ValueTemplate, "00000000000000000000000000000000", Mid(Link, SecondDot + Five));
    EndIf;
    Return ValueFromStringInternal(LinkValue);    
EndFunction

// Is common attribute use for metadata.
// 
// Parameters:
//  Name - String - Name of common attribute
//  MetadataFullName - MetadataObject - Metadata full name
// 
// Returns:
//  Boolean - Is common attribute use for metadata
Function isCommonAttributeUseForMetadata(Name, MetadataFullName) Export
	Attr = Metadata.CommonAttributes[Name];
	Content = Attr.Content.Find(MetadataFullName);
	UseAtContent = Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use;
	AutoUseAndUseAtContent = Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Auto 
		And Attr.AutoUse = Metadata.ObjectProperties.CommonAttributeAutoUse.Use;
	NotSeparate = Attr.DataSeparation = Metadata.ObjectProperties.CommonAttributeDataSeparation.DontUse;
		
	Return (UseAtContent Or AutoUseAndUseAtContent) And NotSeparate;
EndFunction

#Region QueryBuilder
// for remove
//Function QueryTable(ObjectName, ObjectServerModule, CustomParameters) Export
//	QueryText = GetQueryText(ObjectName, CustomParameters.OptionsString, CustomParameters.Fields);
//	QueryBuilder = New QueryBuilder(QueryText);
//	QueryBuilder.FillSettings();
//	SetQueryBuilderFilters(QueryBuilder, CustomParameters.Filters);
//	Query = QueryBuilder.GetQuery();
//	ObjectServerModule.SetQueryComplexFilters(Query, CustomParameters.ComplexFilters);
//	QueryTable = Query.Execute().Unload();
//	Return QueryTable;
//EndFunction
// for remove
//Function GetQueryText(ObjectName, QueryOptionsString, Fields) Export
//	QueryTextArray = New Array();
//	QueryTextArray.Add("SELECT " + QueryOptionsString);
//
//	QueryFieldsArray = New Array();
//	For Each Field In Fields Do
//		QueryFieldsArray.Add("Table." + Field.Value + ?(Field.Key <> Field.Value, " AS " + Field.Key, ""));
//	EndDo;
//	QueryFieldsString = StrConcat(QueryFieldsArray, "," + Chars.LF);
//
//	QueryFieldsString = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(QueryFieldsString);
//	QueryTextArray.Add(QueryFieldsString);
//
//	QueryTextArray.Add("FROM " + ObjectName + " AS Table");
//	QueryTextArray.Add("WHERE");
//	QueryTextArray.Add("TRUE");
//	QueryText = StrConcat(QueryTextArray, Chars.LF);
//
//	Return QueryText;
//EndFunction
// for remove
//Procedure SetQueryBuilderFilters(QueryBuilder, QueryFilters)
//	QueryBuilderFilter = QueryBuilder.Filter;
//	For Each QueryFilter In QueryFilters Do
//		FoundedFilter = QueryBuilderFilter.Find(QueryFilter.FieldName);
//		If FoundedFilter = Undefined Then
//			FilterItem = QueryBuilderFilter.Add("Ref." + QueryFilter.FieldName);
//		Else
//			FilterItem = FoundedFilter;
//		EndIf;
//		FilterItem.Use = True;
//		FilterItem.ComparisonType = QueryFilter.ComparisonType;
//		FilterItem.Value = QueryFilter.Value;
//	EndDo;
//EndProcedure

#EndRegion