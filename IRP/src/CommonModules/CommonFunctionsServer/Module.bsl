
// @strict-types

#Region RegExp

// Regex.
// 
// Parameters:
//  String - String - String
//  Facet - String - RegExp
// 
// Returns:
//  Boolean - is string match regexp
Function Regex(String, Facet) Export
	
	Return True;

EndFunction

// Regex.
// 
// Parameters:
//  String - String - String
//  Facet - String - RegExp
// 
// Returns:
//  Array of String - strings match regexp
Function RegExpFindMatch(String, Facet) Export
	
	Return New Array;

EndFunction

#EndRegion

#Region JSON

// Prepare JSON for XDTOReader:
//  Remove all empty arrays ex. []
// 	Repalce {} with null
// 	
// Parameters:
//  JSON - String - JSON
// 
// Returns:
//  String
Function PrepareJSONForXDTOReader(Val JSON) Export

  Facet = "(\""[^""]*\""\s*:\s*\[\s*\]\s*,)";
	Array = RegExpFindMatch(JSON, Facet);
	For Each Row In Array Do
		JSON = StrReplace(JSON, Row, "");
	EndDo;
	
	Facet = "(,\s*\""[^""]*\""\s*:\s*\[\s*\][\s*^,])";
	Array = RegExpFindMatch(JSON, Facet);
	For Each Row In Array Do
		JSON = StrReplace(JSON, Row, "");
	EndDo;
	
	Facet = "(\""[^""]*\""\s*:\s*\[\s*\])";
	Array = RegExpFindMatch(JSON, Facet);
	For Each Row In Array Do
		JSON = StrReplace(JSON, Row, "");
	EndDo;
	
	Facet = "\""[^""]*\""\s*:\s*(\{\s*\})";
	Array = RegExpFindMatch(JSON, Facet);
	For Each Row In Array Do
		If StrStartsWith(TrimAll(Row), "{") Then
			JSON = StrReplace(JSON, Row, "null");
		EndIf;
	EndDo;
  
	Return JSON;
EndFunction

// Serialize JSON.
// 
// Parameters:
//  Value  - Arbitrary - Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Serialize JSON
Function SerializeJSON(Value, AddInfo = Undefined) Export
	Settings = New JSONWriterSettings(, Chars.Tab);
	Writer = New JSONWriter();
	Writer.SetString(Settings);
	WriteJSON(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

// Serialize JSONUse XDTO.
// 
// Parameters:
//  Value - Arbitrary -  Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Serialize JSONUse XDTO
Function SerializeJSONUseXDTO(Value, AddInfo = Undefined) Export
	Settings = New JSONWriterSettings(, Chars.Tab);
	Writer = New JSONWriter();
	Writer.SetString(Settings);
	XDTOSerializer.WriteJSON(Writer, Value, XMLTypeAssignment.Explicit);
	Result = Writer.Close();
	Return Result;
EndFunction

// Deserialize JSONUse XDTO.
// 
// Parameters:
//  Value - String - Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Arbitrary - Deserialize JSONUse XDTO
Function DeserializeJSONUseXDTO(Value, AddInfo = Undefined) Export
	Reader = New JSONReader();
	Reader.SetString(Value);
	Result = XDTOSerializer.ReadJSON(Reader);
	Reader.Close();
	Return Result;
EndFunction

// Serialize JSONUse XDTOFactory.
// 
// Parameters:
//  Value - Arbitrary - Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Serialize JSONUse XDTOFactory
Function SerializeJSONUseXDTOFactory(Value, AddInfo = Undefined) Export
	Settings = New JSONWriterSettings(, Chars.Tab);
	Writer = New JSONWriter();
	Writer.SetString(Settings);
	XDTOFactory.WriteJSON(Writer, Value);
	ResultTmp = Writer.Close();
	LenValuePart = 14;
	Result = Mid(ResultTmp, LenValuePart, StrLen(ResultTmp) - LenValuePart - 1);
	Return Result;
EndFunction

// Deserialize JSON.
// 
// Parameters:
//  Value - String - Value
//  IsMap - Boolean - Is map
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Arbitrary - Deserialize JSON
Function DeserializeJSON(Value, IsMap = False, AddInfo = Undefined) Export
	Reader = New JSONReader();
	Reader.SetString(Value);
	Result = ReadJSON(Reader, IsMap);
	Reader.Close();
	Return Result;
EndFunction

// Deserialize JSONUse XDTOFactory.
// 
// Parameters:
//  Value - Arbitrary - Value
//  Type - XDTOObjectType, XDTOValueType - Type
//  AddInfo - Undefined - Add info
//  WSName - WSDefinitions, String - WSName
// 
// Returns:
//  XDTODataObject
Function DeserializeJSONUseXDTOFactory(Value, Type = Undefined, AddInfo = Undefined, WSName = Undefined) Export
	
	ValueTmp = "{""#value"":" + Value + "}";
	
	Reader = New JSONReader();
	Reader.SetString(ValueTmp);
	Result = XDTOFactory.ReadJSON(Reader, Type); // XDTODataObject
	Reader.Close();
	Return Result;
EndFunction

#EndRegion

#Region XML
// Serialize XMLUse XDTO.
// 
// Parameters:
//  Value - Arbitrary -  Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Serialize XMLUse XDTO
Function SerializeXMLUseXDTO(Value, AddInfo = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOSerializer.WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

// Serialize XMLUse XDTOFactory.
// 
// Parameters:
//  Value - Arbitrary - Value
//  LocalName - String - Local name
//  URI - String - URI
//  AddInfo - Structure - Add info
//  WSName - String, WSDefinitions - WSName
// 
// Returns:
//  String - Serialize XMLUse XDTOFactory
Function SerializeXMLUseXDTOFactory(Value, LocalName = Undefined, URI = Undefined, AddInfo = Undefined,
	WSName = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	XDTOFactoryObject(WSName).WriteXML(Writer, Value, LocalName, URI);
	Result = Writer.Close();
	Return Result;
EndFunction

// Deserialize XMLUse XDTO.
// 
// Parameters:
//  Value - String - Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  XDTODataObject - Deserialize XML use XDTO
Function DeserializeXMLUseXDTO(Value, AddInfo = Undefined) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOSerializer.ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

// Deserialize XML use XDTOFactory.
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
	Result = XDTOFactoryObject(WSName).ReadXML(Reader, Type); // XDTODataObject
	Reader.Close();
	Return Result;
EndFunction

// Serialize XML.
// 
// Parameters:
//  Value - Arbitrary - Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  String - Serialize XML
Function SerializeXML(Value, AddInfo = Undefined) Export
	Writer = New XMLWriter();
	Writer.SetString();
	WriteXML(Writer, Value);
	Result = Writer.Close();
	Return Result;
EndFunction

// Deserialize XML.
// 
// Parameters:
//  Value - String - Value
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Arbitrary - Deserialize XML
Function DeserializeXML(Value, AddInfo = Undefined) Export
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = ReadXML(Reader);
	Reader.Close();
	Return Result;
EndFunction

#EndRegion

#Region ValidateAndCheck

// Is metadata available by current functional options.
// 
// Parameters:
//  ValidatedMetadata - MetadataObjectAttribute, MetadataObjectCommonAttribute - Validated metadata
//  hasType - Boolean - has type
// 
// Returns:
//  Boolean - Is metadata available by current functional options
Function isMetadataAvailableByCurrentFunctionalOptions(ValidatedMetadata, hasType = False) Export
	
	MetadataByType = Undefined;
	If hasType And ValidatedMetadata.Type.Types().Count() = 1 Then
		MetadataByType = Metadata.FindByType(ValidatedMetadata.Type.Types()[0]);
	EndIf;
	If MetadataByType = Undefined Then
		MetadataByType = ValidatedMetadata;
	EndIf;
	
	UsedInFunctionalOptions = False;
    
    For Each FunctionalOption In Metadata.FunctionalOptions Do
        If FunctionalOption.Content.Contains(ValidatedMetadata) Or FunctionalOption.Content.Contains(MetadataByType) Then
            UsedInFunctionalOptions = True;
            If GetFunctionalOption(FunctionalOption.Name) = True Then
                Return True;
            EndIf;
        EndIf;
    EndDo;
    
    Return Not UsedInFunctionalOptions;
    	
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
	If Metadata.CommonAttributes.Find(Name) = Undefined Then
		Return False;
	EndIf;
	
	Attr = Metadata.CommonAttributes[Name];
	Content = Attr.Content.Find(MetadataFullName);
	UseAtContent = Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Use;
	AutoUseAndUseAtContent = Content.Use = Metadata.ObjectProperties.CommonAttributeUse.Auto 
		And Attr.AutoUse = Metadata.ObjectProperties.CommonAttributeAutoUse.Use;
	NotSeparate = Attr.DataSeparation = Metadata.ObjectProperties.CommonAttributeDataSeparation.DontUse;
		
	Return (UseAtContent Or AutoUseAndUseAtContent) And NotSeparate;
EndFunction

// Check HASH is changed.
// 
// Parameters:
//  Object - ChartOfCharacteristicTypesObjectChartOfCharacteristicTypesName, CatalogObjectCatalogName, DocumentObjectDocumentName -
// 
// Returns:
//  Boolean - Object has difference
Function CheckHASHisChanged(Object, AttrHashName = "HASH") Export
	CurrentHASH = Object[AttrHashName]; // String
	Object[AttrHashName] = "";
	HASH = GetMD5(Object, True, True);
	
	If Not HASH = CurrentHASH Then
		Object[AttrHashName] = HASH;
		Return True;
	Else
		Return False
	EndIf;
EndFunction

// Validate email.
// @skip-check property-return-type, invocation-parameter-type-intersect
// 
// Parameters:
//  Address - String - Address
//  RaiseOnFalse - Boolean - Raise on false
// 
// Returns:
//  Boolean - Validate email
Function ValidateEmail(Val Address, RaiseOnFalse = True) Export

	
	LatinCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    Digits = "0123456789";
    ValidSymbols = "-._@";
    
    ErrorArray = New Array; // Array Of String

	If IsBlankString(Address) Then
		ErrorArray.Add(R().EmailIsEmpty);
	EndIf;

    PartMail = StrSplit(Address, "@", False);
    If PartMail.Count() <> 2 Then
    	ErrorArray.Add(R().Only1SymbolAtCanBeSet);
    EndIf;
    
    If ErrorArray.Count() = 0 Then // Skip if we have error from top lvl
        DomainPart = PartMail[1];
	    LocalPart = PartMail[0];
	
	    If StrLen(LocalPart) < 1 OR StrLen(LocalPart) > 64 Then
	        ErrorArray.Add(R().InvalidLengthOfLocalPart);
	    EndIf;
	
	    If StrLen(DomainPart) < 1 OR StrLen(DomainPart) > 255 Then
	        ErrorArray.Add(R().InvalidLengthOfDomainPart);
	    EndIf;
	                     
	    If Left(LocalPart, 1) = "." OR Right(LocalPart, 1) = "." Then
	        ErrorArray.Add(R().LocalPartStartEndDot);
	    EndIf;
	
	    If Find(LocalPart, "..") > 0 Then
	        ErrorArray.Add(R().LocalPartConsecutiveDots);
	    EndIf;
	
	    If Left(DomainPart, 1) = "." Then
	        ErrorArray.Add(R().DomainPartStartsWithDot);
	    EndIf;
	
	    If Find(DomainPart, "..") > 0 Then
	        ErrorArray.Add(R().DomainPartConsecutiveDots);
	    EndIf; 
	
		If StrOccurrenceCount(DomainPart, ".") = 0 Then
	        ErrorArray.Add(R().DomainPartMin1Dot);
	    EndIf;
	
	    DomainPartIdentifiers = StrSplit(DomainPart, ".");
	    For Each DomainIdentifier IN DomainPartIdentifiers Do
	        If StrLen(DomainIdentifier) > 63 Then
	            ErrorArray.Add(R().DomainIdentifierExceedsLength);
	        EndIf;
	    EndDo;
    EndIf;
    
	For Index = 1 To StrLen(Address) Do
		Symbol = Mid(Address, Index, 1);
		If StrFind(LatinCharacters + Digits + ValidSymbols, Symbol) = 0 Then
			ErrorArray.Add(StrTemplate(R().InvalidCharacterInAddress, Symbol));
		EndIf;
	EndDo;

    If ErrorArray.Count() > 0 Then
        ErrorMessage = StrConcat(ErrorArray, Chars.LF);
        If RaiseOnFalse Then
            Raise ErrorMessage;
        Else
            Message(ErrorMessage);
            Return False;
        EndIf;
    EndIf;

  	Return True;
EndFunction

// Is primitive value.
// 
// Parameters:
//  Value - Arbitrary - Value
// 
// Returns:
//  Boolean - Is primitive value
Function IsPrimitiveValue(Value) Export
	Return Metadata.FindByType(TypeOf(Value)) = Undefined;
EndFunction

// Is document ref.
// 
// Parameters:
//  Value - Arbitrary -  Value
// 
// Returns:
//  Boolean - Is document ref
Function IsDocumentRef(Value) Export
	Return Documents.AllRefsType().ContainsType(TypeOf(Value));
EndFunction

// Form have attribute.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  AttributeName - String - Attribute name
// 
// Returns:
//  Boolean - Form have attribute
Function FormHaveAttribute(Form, AttributeName) Export
	For Each FormAttribute In Form.GetAttributes() Do
		If FormAttribute.Name = AttributeName Then
			Return True;
		EndIf;
	EndDo;
	Return False;
EndFunction

#EndRegion

#Region WorkWithDate

Function GetStandardTimeOffset() Export
	Return StandardTimeOffset(SessionTimeZone(), CurrentUniversalDate()) / (60 * 60);
EndFunction	

// Get current universal date.
// 
// Returns:
//  Date - Get current universal date
Function GetCurrentUniversalDate() Export
	Return CurrentUniversalDate();
EndFunction

// Get current session date.
// 
// Returns:
//  Date - Get current session date
Function GetCurrentSessionDate() Export
	Return CurrentSessionDate();
EndFunction

#EndRegion

#Region Common

// Sort array.
// 
// Parameters:
//  Array - Array - Array
// 
// Returns:
//  Array - Sort array
Function SortArray(Array) Export
	VL = New ValueList();
	VL.LoadValues(Array);
	VL.SortByValue();
	Return VL.UnloadValues();
EndFunction	

// Delete from array if present.
// 
// Parameters:
//  Array - Array
//  Value - Arbitrary
Procedure DeleteFormArrayIfPresent(Array, Value) Export
	Index = Array.Find(Value);
	If Index <> Undefined Then
		Array.Delete(Index);
	EndIf;
EndProcedure	

// Pause.
// 
// Parameters:
//  Time - Number - Time in second
Procedure Pause(Time) Export

    If Time < 1 Then
    	Return;
    EndIf;

    Job = GetCurrentInfoBaseSession().GetBackgroundJob();

    If Job = Undefined Then
        Params = New Array; // Array Of Number
        Params.Add(Time);
        MethodName = "CommonFunctionsServer.Pause";
        Job = ConfigurationExtensions.ExecuteBackgroundJobWithoutExtensions(MethodName, Params);
    EndIf;

    Job.WaitForExecutionCompletion(Time);

EndProcedure

#EndRegion

#Region GetData

// Get common template by name.
// 
// Parameters:
//  Name - String - Name
//  GetFromStorage - Boolean - Get from storage
// 
// Returns:
//  COMObject, DataCompositionParameterValue, DataCompositionSettingsParameterValue, SpreadsheetDocument, TextDocument, ActiveDocumentShell, HTMLDocumentShell, BinaryData, GeographicalSchema, GraphicalSchema, DataCompositionSchema, DataCompositionAppearanceTemplate - Get common template by name
Function GetCommonTemplateByName(Name, GetFromStorage = False) Export
	If GetFromStorage Then
		Return GetCommonTemplate(Name).Get();
	Else
		Return GetCommonTemplate(Name);
	EndIf;
EndFunction

// Get ref attribute.
// 
// Parameters:
//  Ref - AnyRef - Ref
//  Name - String - Name
// 
// Returns:
//   Arbitrary
Function GetRefAttribute(Ref, Name) Export
	Parts = StrSplit(Name, ".");
	Data = Ref;
	For Each Attr In Parts Do
		//@skip-check statement-type-change
		Data = Data[Attr];
	EndDo;
	Return Data;
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

// Get MD5.
// 
// Parameters:
//  Object - Arbitrary - Object
//  ReturnAsGUID - Boolean
//  UseXML - Boolean - Get string from XML
// 
// Returns:
//  String - Get MD5
Function GetMD5(Object, ReturnAsGUID = True, UseXML = False) Export
	If TypeOf(Object) = Type("String") Then
		DataToString = Object;
	Else
		If UseXML Then
			DataToString = SerializeXMLUseXDTO(Object);
		Else
			DataToString = ValueToStringInternal(Object);
		EndIf;
	EndIf;

	DataHashing = New DataHashing(HashFunction.MD5);
	DataHashing.Append(DataToString);
	HashSumString = StrReplace(String(DataHashing.HashSum), " ", "");
	If ReturnAsGUID Then
		HashSumStringUUID = Left(HashSumString, 8) 	  + "-" + 
						Mid(HashSumString, 9, 4)  + "-" + 
						Mid(HashSumString, 15, 4) + "-" + 
						Mid(HashSumString, 18, 4) + "-" + 
						Right(HashSumString, 12);
	Else
		HashSumStringUUID = HashSumString;
	EndIf;
	Return Upper(HashSumStringUUID);
EndFunction

// Get URLFrom navigation link.
// 
// Parameters:
//  Link - String - Link
// 
// Returns:
//  AnyRef - Get URLFrom navigation link
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

// Get attributes from ref. If there is no attribute, or there is no access, 
// then the structure key will be Undefined, otherwise the required value.
// 
// Parameters:
//  Ref - AnyRef - Ref to get properties
//  Attributes - String, FixedStructure, Structure, FixedArray, Array of String - List of attributes
//  OnlyAllowed - Boolean - Requesting the value of attributes, taking into account rights at the record level
// 
// Returns:
//   Structure - response description:
//   * Key - String - property name
//   * Value - Arbitrary - property value
Function GetAttributesFromRef(Ref, Attributes, OnlyAllowed = False) Export
	
	If TypeOf(Ref) = Type("Structure") Then
		Return Ref;
	EndIf;
	
	Result = New Structure;
	
	AttributesStructure = New Structure;
	If TypeOf(Attributes) = Type("String") Then
		If IsBlankString(Attributes) Then
			Return Result;
		EndIf;
		Attributes = StrReplace(Attributes, " ", "");
		Attributes = StrReplace(Attributes, Chars.LF, "");
		AttributeParts = StrSplit(Attributes, ",");
		For Each AttributPart In AttributeParts Do
			Alias = StrReplace(AttributPart, ".", "");
			AttributesStructure.Insert(Alias, AttributPart);
		EndDo; 
	ElsIf TypeOf(Attributes) = Type("Array") Or TypeOf(Attributes) = Type("FixedArray") Then
		For Each AttributPart In Attributes Do
			Alias = StrReplace(AttributPart, ".", "");
			AttributesStructure.Insert(Alias, AttributPart);
		EndDo;
	ElsIf TypeOf(Attributes) = Type("Structure") Or TypeOf(Attributes) = Type("FixedStructure") Then
		AttributesStructure = Attributes;
	Else
		//@skip-check property-return-type
		Raise R().Error_004;
	EndIf;
	
	If AttributesStructure.Count() = 0 Then
		Return Result;
	EndIf;
	
	FullTableName = Ref.Metadata().FullName();
	
	QueryFields = New Array; // Array of String
	For Each ItemAttribute In AttributesStructure Do
		
		FieldName = ?(ValueIsFilled(ItemAttribute.Value), ItemAttribute.Value, ItemAttribute.Key); // String
		FieldAlias = ItemAttribute.Key;
		QueryFields.Add(FieldName + " AS " + FieldAlias);
		
		CurrentResult = Result;
		FieldParts = StrSplit(FieldName, ".");
		For Index = 0 To FieldParts.UBound() Do
			If Not CurrentResult.Property(FieldParts[Index]) Then
				CurrentResult.Insert(FieldParts[Index], Undefined);
			EndIf;
			If Index < FieldParts.UBound() Then
				If CurrentResult[FieldParts[Index]] = Undefined Then
					CurrentResult[FieldParts[Index]] = New Structure;
				EndIf; 
				CurrentResult = CurrentResult[FieldParts[Index]]; // Structure
			EndIf;
		EndDo;
	EndDo;
	
	If QueryFields.Count() = 0 Then
		Return Result;
	EndIf;
	
	If Ref.IsEmpty() Then
		For Each Attr In CurrentResult Do
			CurrentResult[Attr.Key] = Ref[Attr.Key];
		EndDo;
		Return Result;
	EndIf;
	
	Query = New Query;
	Query.Parameters.Insert("Ref", Ref);
	Query.Text = StrTemplate(
		"SELECT %1
			|	%2
			|FROM %3 AS Table
			|WHERE Table.Ref = &Ref", 
		?(OnlyAllowed, "ALLOWED", ""), 
		StrConcat(QueryFields, "," + Chars.CR + Chars.Tab),
		FullTableName
	);
	
	SelectionDetailRecords = Query.Execute().Select();
	If SelectionDetailRecords.Next() Then
		For Each ItemAttribute In AttributesStructure Do
			CurrentResult = Result;
			FieldName = ?(ValueIsFilled(ItemAttribute.Value), ItemAttribute.Value, ItemAttribute.Key); // String
			FieldParts = StrSplit(FieldName, ".");
			For Index = 0 To FieldParts.UBound() - 1 Do
				CurrentResult = CurrentResult[FieldParts[Index]]; // Structure 
			EndDo;
			CurrentResult[FieldParts[FieldParts.UBound()]] = SelectionDetailRecords[ItemAttribute.Key];
		EndDo;
	Else
		For Each ItemAttribute In AttributesStructure Do
			Result[FieldParts[FieldParts.UBound()]] = Ref[ItemAttribute.Key];
		EndDo;
	EndIf;
	
	//@skip-check constructor-function-return-section
	Return Result;
	
EndFunction

// Get related documents.
// 
// Parameters:
//  DocumentRef - DocumentRef - ref to document
//  WithoutDeleted - Boolean - without documents marked for deletion
// 
// Returns:
//  Array of DocumentRef - Get related documents
Function GetRelatedDocuments(DocumentRef, WithoutDeleted = False) Export
	Query = New Query();
	Query.SetParameter("DocumentRef", DocumentRef);
	Query.Text =
	"SELECT Ref
	|FROM FilterCriterion.RelatedDocuments(&DocumentRef)";
	If WithoutDeleted Then
		Query.Text = Query.Text + "
		|WHERE NOT Ref.DeletionMark";
	EndIf;
	Return Query.Execute().Unload().UnloadColumn(0);
EndFunction

#EndRegion

#Region XDTO

Function GetXMLAsStructure(XML) Export
	XDTO = DeserializeXMLUseXDTOFactory(XML);
	Str = New Structure;
	For Each Prop In XDTO.Properties() Do
		Str.Insert(Prop.Name, XDTO[Prop.Name]);
	EndDo;
	Return Str;
EndFunction

Function GetXMLAsStructure_Recurse()
	
EndFunction

// XDTOFactory object.
// 
// Parameters:
//  WSName - Undefined, WSDefinitions, String - WSName
// 
// Returns:
//  XDTOFactory - XDTOFactory object
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

// XSLTransformation.
// 
// Parameters:
//  XML - String - XML
//  XSLT - String - XSLT
// 
// Returns:
//  String - XSLTransformation
Function XSLTransformation(XML, XSLT) Export
	XSLTransform = New XSLTransform();
	XSLTransform.LoadFromString(XSLT);
	Return XSLTransform.TransformFromString(XML);
EndFunction

#EndRegion

#Region Base64

// Base64 from string.
// 
// Parameters:
//  String - String - String
//  ReturnBinary - Boolean - Return binary
// 
// Returns:
//  String, BinaryData - Base64 from string
Function Base64FromString(String, ReturnBinary = False) Export
	
	MemoryStream = New MemoryStream();
	DataWriter = New DataWriter(MemoryStream, TextEncoding.UTF8);
	DataWriter.WriteLine(String);
	DataWriter.Close();
	BD = MemoryStream.CloseAndGetBinaryData();
	
	If ReturnBinary Then
		Return BD;
	Else
		Return Base64String(BD);
	EndIf;
	
EndFunction

// String to base64 ZIP.
// 
// Parameters:
//  String - String - String
//  FileName - String - File name
//  ReturnBinary - Boolean - Return binary
// 
// Returns:
//  String, BinaryData - String to base64 ZIP
Function StringToBase64ZIP(String, FileName, ReturnBinary = False) Export
	TmpFileName = TempFilesDir() + FileName + ".xml";
	DataWriter = New DataWriter(TmpFileName, TextEncoding.UTF8);
	DataWriter.WriteLine(String, TextEncoding.UTF8);
	DataWriter.Close();
	
	MStream = New MemoryStream();
	ZIP = New ZipFileWriter(MStream, , , ZIPCompressionMethod.Deflate);
	ZIP.Add(TmpFileName);
	ZIP.Write();
	BD = MStream.CloseAndGetBinaryData();
	DeleteFiles(TmpFileName);
	If ReturnBinary Then
		Return BD;
	Else
		Return GetBase64StringFromBinaryData(BD);
	EndIf;
EndFunction

// String from base64 ZIP.
// 
// Parameters:
//  Base64Zip - String - Base64 zip
//  FileName - String - File name. If empty - return first file
// 
// Returns:
//  BinaryData - String from base64 ZIP
Function StringFromBase64ZIP(Base64Zip, FileName = Undefined) Export
	MStream = New MemoryStream(GetBinaryDataBufferFromBase64String(Base64Zip));
	ZIP = New ZipFileReader(MStream);
	TmpFileName = TempFilesDir();
	ZIP.Extract(ZIP.Items[0], TmpFileName);
	If FileName = Undefined Then
		FileName = ZIP.Items[0].FullName;
	EndIf;
	Zip.Close();
	MStream.CloseAndGetBinaryData();
	BD = New BinaryData(TmpFileName + FileName);
	DeleteFiles(TmpFileName + FileName);
	Return BD;
EndFunction

#EndRegion

#Region EvalExpression

// Recalculate expression.
// 
// Parameters:
//  Params - See GetRecalculateExpressionParams
// 
// Returns:
//  See CommonFunctionsServer.RecalculateExpressionResult
Function RecalculateExpression(Params) Export
	
	ResultInfo = RecalculateExpressionResult();
	
	Try
		Result = Undefined;
		If Params.SafeMode Then
			SetSafeMode(True);
		EndIf;
		If Params.Type = Enums.ExternalFunctionType.Eval Then
			// @skip-check server-execution-safe-mode
			Result = Eval(Params.Expression);
		ElsIf Params.Type = Enums.ExternalFunctionType.Execute Then
			Result = ExecuteCode(Params.Expression, Params, ResultInfo);
		ElsIf Params.Type = Enums.ExternalFunctionType.RegExp Then
			Params.RegExpResult = RegExpFindMatch(Params.RegExpString, Params.RegExp);
			If Not IsBlankString(Params.Expression) Then
				Result = ExecuteCode(Params.Expression, Params, ResultInfo);
			EndIf;
		ElsIf Params.Type = Enums.ExternalFunctionType.ReturnResultByRegExpMatch Then
			For Each Row In Params.CaseParameters Do
				//@skip-check invocation-parameter-type-intersect
				If Regex(Params.RegExpString, Row.Value) Then
					Result = Row.Key;
					Break;
				EndIf;
			EndDo;
		Else
			Raise "Wrong External function type.";
		EndIf;
		ResultInfo.Result = Result;
	Except
		ResultInfo.isError = True;
		ResultInfo.Description = ErrorProcessing.DetailErrorDescription(ErrorInfo());
	EndTry;
	
	Return ResultInfo;
EndFunction

Function ExecuteCode(Expression, Params, ResultInfo)
	Result = Undefined;
	// @skip-check server-execution-safe-mode
	Execute(Expression);
	Return Result;
EndFunction

// Create schedule.
// 
// Parameters:
//  ExternalFunction - CatalogRef.ExternalFunctions - External function
Procedure CreateScheduledJob(ExternalFunction) Export
	
	If Not ExternalFunction.isSchedulerSet Then
		DeleteScheduledJob(ExternalFunction);
		Return;
	EndIf;

	If Not ExternalFunction.ExternalFunctionType = Enums.ExternalFunctionType.Execute Then
		Return;
	EndIf;
	
	NewScheduledJobs = ScheduledJobs.CreateScheduledJob(Metadata.ScheduledJobs.AddExternalFunctionsToJobQueue);
	NewScheduledJobs.Description = ExternalFunction.Description;
	NewScheduledJobs.Key = String(ExternalFunction.UUID());
	NewScheduledJobs.Use = ExternalFunction.isSchedulerSet;
	JobSchedule = ExternalFunction.JobSchedule.Get(); // JobSchedule
	NewScheduledJobs.Schedule = JobSchedule;
	//@skip-check typed-value-adding-to-untyped-collection
	NewScheduledJobs.Parameters.Add(ExternalFunction);
	NewScheduledJobs.Write();
EndProcedure

Procedure DeleteScheduledJob(ExternalFunction) Export
	ScheduledJobsToDelete = ScheduledJobs.GetScheduledJobs(New Structure("Key", ExternalFunction.UUID()));
	For Each Job In ScheduledJobsToDelete Do
		Job.Delete();
	EndDo;
EndProcedure

// Get recalculate expression params.
// 
// Parameters:
//  ExternalFunction - CatalogRef.ExternalFunctions, CatalogObject.ExternalFunctions - Ref
// 
// Returns:
//  Structure - Get recalculate expression params:
// * RegExpString - String -
// * RegExp - String -
// * RegExpResult - Array -
// * Expression - String -
// * Result - Undefined -
// * CaseParameters - Map:
// ** Key - Arbitrary - Resturned result
// ** Value - String - RegExp string divided by | symbol
// * SafeMode - Boolean -
// * Job - CatalogRef.ExternalFunctions -
// * AddInfo - Structure -
// * Type - EnumRef.ExternalFunctionType -
Function GetRecalculateExpressionParams(ExternalFunction = Undefined) Export
	
	Structure = New Structure;
	Structure.Insert("RegExpString", "");
	Structure.Insert("RegExp", "");
	Structure.Insert("RegExpResult", New Array);

	Structure.Insert("Expression", "");
	Structure.Insert("Result", Undefined);

	Structure.Insert("CaseParameters", New Map);

	Structure.Insert("SafeMode", True);
	Structure.Insert("Job", Catalogs.ExternalFunctions.EmptyRef());

	Structure.Insert("AddInfo", New Structure);
	Structure.Insert("Type", Enums.ExternalFunctionType.Eval);
	
	If Not ExternalFunction = Undefined Then
		Structure.SafeMode = ExternalFunction.SafeModeIsOn;
		Structure.Expression = ExternalFunction.ExternalCode;
		Structure.Job = ExternalFunction.Ref;
		Structure.Type = ExternalFunction.ExternalFunctionType;
		Structure.RegExp = ExternalFunction.RegExp;
		
		MatchStr = New Map;
		For Each Row In ExternalFunction.ResultMatches Do
			MatchStr.Insert(Row.Result, Row.RegExp);
		EndDo;
		Structure.Insert("CaseParameters", MatchStr);
	EndIf;
	
	Return Structure;
	
EndFunction

// Recalculate expression result.
// 
// Returns:
//  Structure - Recalculate expression result:
// * isError - Boolean -
// * Description - String -
// * Result - Arbitrary, Undefined -
// * Log - Array of String - Log
Function RecalculateExpressionResult() Export
	
	Structure = New Structure;
	Structure.Insert("isError", False);
	Structure.Insert("Description", "");
	Structure.Insert("Result", Undefined);
	Structure.Insert("Log", New Array);
	
	Return Structure;
	
EndFunction

#EndRegion

#Region QueryBuilder

// Query table.
// 
// Parameters:
//  ObjectName - String -  Object name
//  ObjectServerModule - CommonModule - Object server module
//  CustomParameters - Structure -  Custom parameters:
//  * OptionsString - String
//  * Fields - Array of KeyAndValue
//  * Filters - Filter
//  * ComplexFilters - Array of Structure
// 
// Returns:
//  ValueTable - Query table
Function QueryTable(ObjectName, ObjectServerModule, CustomParameters) Export
	QueryText = GetQueryText(ObjectName, CustomParameters.OptionsString, CustomParameters.Fields);
	QueryBuilder = New QueryBuilder(QueryText);
	QueryBuilder.FillSettings();
	SetQueryBuilderFilters(QueryBuilder, CustomParameters.Filters);
	Query = QueryBuilder.GetQuery();
	//@skip-check unknown-method-property
	//@skip-check dynamic-access-method-not-found
	ObjectServerModule.SetQueryComplexFilters(Query, CustomParameters.ComplexFilters);
	QueryTable = Query.Execute().Unload();
	Return QueryTable;
EndFunction

// Get query text.
// 
// Parameters:
//  ObjectName - String - Object name
//  QueryOptionsString - String - Query options string
//  Fields - Array of KeyAndValue - Fields:
//  * Key - String
//  * Value - String 
// 
// Returns:
//  String - Get query text
Function GetQueryText(ObjectName, QueryOptionsString, Fields) Export
	QueryTextArray = New Array(); // Array of String
	QueryTextArray.Add("SELECT ALLOWED " + QueryOptionsString);

	QueryFieldsArray = New Array(); // Array of String
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

// Set query builder filters.
// 
// Parameters:
//  QueryBuilder - QueryBuilder - Query builder
//  QueryFilters - Filter - Query filters
Procedure SetQueryBuilderFilters(QueryBuilder, QueryFilters)
	QueryBuilderFilter = QueryBuilder.Filter;
	For Each QueryFilter In QueryFilters Do
		//@skip-check property-return-type
		//@skip-check invocation-parameter-type-intersect
		FoundedFilter = QueryBuilderFilter.Find(QueryFilter.FieldName);
		If FoundedFilter = Undefined Then
			//@skip-check property-return-type
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
