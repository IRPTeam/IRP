// @strict-types


#Region Public

#Region Info

Function Tests() Export
	TestList = New Array;
	Return TestList;
EndFunction

#EndRegion

// Compose answer to request.
// 
// Parameters:
//  Request - HTTPServiceRequest - Request
// 
// Returns:
//  HTTPServiceResponse - Compose answer to request
Function ComposeAnswerToRequest(Request) Export
	
	RequestStructure = GetStructureRequest();
	
	RequestStructure.Type = Request.HTTPMethod; 
	RequestStructure.Address = Request.RelativeURL;
	RequestStructure.Options = Request.QueryOptions;
	RequestStructure.Headers = Request.Headers;
	RequestStructure.BodyBinary = Request.GetBodyAsBinaryData();
	RequestStructure.BodyString = Request.GetBodyAsString();
	
	Return ComposeAnswerToRequestStructure(RequestStructure);
	
EndFunction

// Compose answer to structure of  request.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
//  MockData - CatalogRef.Unit_MockServiceData
// 
// Returns:
//  HTTPServiceResponse - Compose answer to request
Function ComposeAnswerToRequestStructure(RequestStructure, MockData=Undefined, RequestVariables=Undefined) Export
	
	If MockData = Undefined Then
		MockDataInfo = getMockDataByRequest(RequestStructure);
		MockData = MockDataInfo.MockData;
		RequestVariables = MockDataInfo.RequestVariables;
	EndIf;
	
	If RequestVariables = Undefined Then
		RequestVariables = getRequestVariables(RequestStructure, MockData, "");
	EndIf;
	
	If Not ValueIsFilled(MockData) Then
		Return New HTTPServiceResponse(404, R().Mock_002);
	EndIf;
	
	Response = New HTTPServiceResponse(MockData.Answer_StatusCode, MockData.Answer_Message);
	For Each HeaderItem In MockData.Answer_Headers Do
		Response.Headers.Insert(HeaderItem.Key, TransformationValue(HeaderItem.Value, RequestVariables));
	EndDo;
	
	BodyRowValue = MockData.Answer_Body.Get(); // BinaryData
	If MockData.Answer_BodyIsText Then
		BodyString = "";
		If TypeOf(BodyRowValue) = Type("BinaryData") Then
			BodyString = GetStringFromBinaryData(BodyRowValue);
		Else
			BodyString = String(BodyRowValue);
		EndIf;
		Response.SetBodyFromString(TransformationValue(BodyString, RequestVariables));
	Else
		Response.SetBodyFromBinaryData(BodyRowValue);
	EndIf;
	
	Return Response;
	
EndFunction

// Check request to mock data.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
//  Selection - See Unit_MockService.GetSelectionMockStructure
//  RequestVariables - Structure - Request variables
// 
// Returns:
//  Structure - Check request to mock data:
// * Successfully - Boolean -
// * Logs - String -
Function CheckRequestToMockData(RequestStructure, Selection, RequestVariables) Export
	
	Result = New Structure("Successfully, Logs", False, "");
	
	If Not AddressCheck(RequestStructure.Address, Selection.Address, Result.Logs) Then
		Return Result;
	EndIf;
	
	MockDataRef = Selection.Ref; // CatalogRef.Unit_MockServiceData
	If Selection.isHeaderFilter And Not HeadersCheck(RequestStructure.Headers, MockDataRef, Result.Logs) Then
		Return Result;
	EndIf;
	
	If Selection.BodyAsFilter And Not BodyCheck(RequestStructure, Selection.BodyMD5, Result.Logs) Then
		Return Result;
	EndIf;
	
	If Selection.isVariablesFilter Or Selection.isVariablesBodyFilter Then
		RequestVariables = getRequestVariables(RequestStructure, MockDataRef, Result.Logs);
		If Selection.isVariablesFilter And Not VariablesCheck(RequestVariables, MockDataRef, Result.Logs) Then
			Return Result;
		EndIf;
		If Selection.isVariablesBodyFilter And Not VariablesBodyCheck(RequestVariables, MockDataRef, Result.Logs) Then
			Return Result;
		EndIf;
	EndIf;
	
	If RequestVariables.Count() = 0 Then
		RequestVariables = getRequestVariables(RequestStructure, MockDataRef, Result.Logs);
	EndIf;
	
	AddLineToLogs(Result.Logs, R().Mock_012, True);
	Result.Successfully = True;
	Return Result;
	
EndFunction

// Get structure of request.
// 
// Returns:
//  Structure - Get structure request:
// * Type - String -
// * Address - String -
// * BodyBinary - BinaryData -
// * BodyString - String -
// * Headers - FixedMap -
// * Options - FixedMap -
Function GetStructureRequest() Export
	Result = New Structure;
	Result.Insert("Type", "");
	Result.Insert("Address", "");
	Result.Insert("BodyBinary");
	Result.Insert("BodyString", "");
	Result.Insert("Headers");
	Result.Insert("Options");
	Return Result;
EndFunction

// Get selection mock structure.
// 
// Returns:
//  Structure - Get selection mock structure:
// * Ref - CatalogRef.Unit_MockServiceData -
// * Address - String -
// * isHeaderFilter - Boolean -
// * isVariablesFilter - Boolean -
// * isVariablesBodyFilter - Boolean -
Function GetSelectionMockStructure() Export
	Result = New Structure;
	Result.Insert("Ref", Catalogs.Unit_MockServiceData.EmptyRef());
	Result.Insert("Address", "");
	Result.Insert("BodyMD5", "");
	Result.Insert("BodyAsFilter", False);
	Result.Insert("isHeaderFilter", False);
	Result.Insert("isVariablesFilter", False);
	Result.Insert("isVariablesBodyFilter", False);
	Return Result;
EndFunction

#EndRegion 


#Region Private

// Wildcard address check.
// 
// Parameters:
//  Address - String - Address
//  Pattern - String - Pattern of address
//  Logs - String
// 
// Returns:
//  Boolean - address matches
Function AddressCheck(Address, Pattern, Logs)

	AddLineToLogs(Logs, R().Mock_004, True);
	AddLineToLogs(Logs, StrTemplate("%1: %2", R().Mock_024, Address));
	AddLineToLogs(Logs, StrTemplate("%1: %2", R().Mock_025, Pattern));

	AddressParts = StrSplit(Address, "/", False);
	PatternParts = StrSplit(Pattern, "/", False);
	
	If AddressParts.Count() < PatternParts.Count() Then
		AddLineToLogs(Logs, R().Mock_013);
		Return False;
	Else
		NumberExtraSections = AddressParts.Count() - PatternParts.Count();
		AnyString = GetAnyString();
		For index = 1 To NumberExtraSections Do
			PatternParts.Add(AnyString);
		EndDo; 
	EndIf;
	
	For index = 0 To AddressParts.Count() - 1 Do
		If Not StringEqualsCheck(AddressParts[index], PatternParts[index]) Then
			AddLineToLogs(Logs, StrTemplate(R().Mock_014, index+1));
			AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_022, PatternParts[index]));
			AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_023, AddressParts[index]));
			Return False;
		EndIf;
	EndDo;

	AddLineToLogs(Logs, R().Mock_011);
	Return True;
	
EndFunction 

// Headers check.
// 
// Parameters: Address - String - Address
// Pattern - String - Pattern of address
//  Headers - FixedMap - Headers
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
//  Logs - String
// 
// Returns:
//  Boolean - address matches
Function HeadersCheck(Headers, MockData, Logs)
	
	AddLineToLogs(Logs, R().Mock_005, True);
	
	For Each MockHeaderItem In MockData.Request_Headers Do
		
		If MockHeaderItem.ValueAsFilter And ValueIsFilled(MockHeaderItem.Value) Then
			
			HeadersValue = Headers.Get(MockHeaderItem.Key); //String
			If HeadersValue = Undefined Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_015, MockHeaderItem.Key));
				Return False;
			EndIf;  
			
			If Not StringEqualsCheck(HeadersValue, MockHeaderItem.Value) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_016, MockHeaderItem.Key));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_022, MockHeaderItem.Value));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_023, HeadersValue));
				Return False;
			EndIf;

		EndIf;
		 
	EndDo;
	
	AddLineToLogs(Logs, R().Mock_011);
	Return True;
	
EndFunction 

// Body check according to MD5
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
//  MockBodyMD5 - String - Mock body md5
//  Logs - String - Logs
// 
// Returns:
//  Boolean - Body checked
Function BodyCheck(RequestStructure, MockBodyMD5, Logs)
	
	AddLineToLogs(Logs, R().Mock_006, True);
	
	BodyBinaryMD5 = CommonFunctionsServer.GetMD5(RequestStructure.BodyBinary);
	BodyStringMD5 = CommonFunctionsServer.GetMD5(GetBinaryDataFromString(RequestStructure.BodyString));
	
	If BodyBinaryMD5 <> MockBodyMD5 And BodyStringMD5 <> MockBodyMD5 Then
		AddLineToLogs(Logs, R().Mock_017);
		AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_022, MockBodyMD5));
		AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_018, BodyBinaryMD5));
		AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_019, BodyStringMD5));
		Return False;
	EndIf;
	
	AddLineToLogs(Logs, R().Mock_011);
	Return True;
	
EndFunction

// Variables check.
// 
// Parameters:
//  RequestVariables - Structure
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
//  Logs - String
// 
// Returns:
//  Boolean - Variables checked
Function VariablesCheck(RequestVariables, MockData, Logs)
	
	AddLineToLogs(Logs, R().Mock_007, True);
	
	For Each VareablesItem In MockData.Request_Variables Do
		If VareablesItem.ValueAsFilter Then
			VariableValue = "";
			If Not RequestVariables.Property(VareablesItem.VariableName, VariableValue) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_020, VareablesItem.VariableName));
				Return False;
			EndIf;  
			If Not StringEqualsCheck(VariableValue, VareablesItem.Value) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_021, VareablesItem.VariableName));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_022, VareablesItem.Value));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_023, VariableValue));
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
	
	AddLineToLogs(Logs, R().Mock_011);
	Return True;
	
EndFunction

// Body variables check.
// 
// Parameters:
//  RequestVariables - Structure
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
//  Logs - String
// 
// Returns:
//  Boolean - Body variables checked
Function VariablesBodyCheck(RequestVariables, MockData, Logs)
	
	AddLineToLogs(Logs, R().Mock_008, True);
	
	For Each VareablesItem In MockData.Request_BodyVariables Do
		If VareablesItem.ValueAsFilter Then
			VariableValue = "";
			If Not RequestVariables.Property(VareablesItem.VariableName, VariableValue) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_020, VareablesItem.VariableName));
				Return False;
			EndIf;  
			If Not StringEqualsCheck(VariableValue, VareablesItem.Value) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_021, VareablesItem.VariableName));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_022, VareablesItem.Value));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_023, VariableValue));
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
	
	AddLineToLogs(Logs, R().Mock_011);
	Return True;
	
EndFunction

// String equals check.
// 
// Parameters:
//  InputString - String - Input string
//  PatternString - String - Pattern string
// 
// Returns:
//  Boolean - Strings are equal
Function StringEqualsCheck(Val InputString, Val PatternString)
	
	AnyString = GetAnyString();
	
	If StrFind(PatternString, AnyString) > 0 Then
		ValidSize = StrFind(PatternString, AnyString) - 1;
		If ValidSize = 0 Then
			Return True;
		EndIf;
		InputString = Mid(InputString, 1, ValidSize);
		PatternString = Mid(PatternString, 1, ValidSize); 
	EndIf;
	
	Return StrCompare(InputString, PatternString) = 0;
		
EndFunction

// Get any string.
// 
// Returns:
//  String - Any string
Function GetAnyString()
	Return "*";
EndFunction

// Add line to logs.
// 
// Parameters:
//  Logs - String
//  NewLine - String
//  isHeader - Boolean
Procedure AddLineToLogs(Logs, NewLine, isHeader=False)
	Logs = Logs + ?(IsBlankString(Logs), "", Chars.CR);
	If isHeader Then
		Logs = Logs + "=== " + NewLine + " ===";
	Else
		Logs = Logs + NewLine;
	EndIf; 
EndProcedure

// Get mock data by request.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest 
// 
// Returns:
//  Structure - Get mock data by request:
// * MockData - CatalogRef.Unit_MockServiceData -
// * RequestVariables - Structure -
Function getMockDataByRequest(RequestStructure)
	
	Result = New Structure("MockData, RequestVariables", Catalogs.Unit_MockServiceData.EmptyRef(), New Structure);
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	Unit_MockServiceData.Ref AS Ref,
	|	Unit_MockServiceData.Request_ResourceAddress AS Address,
	|	Unit_MockServiceData.Request_BodyAsFilter AS BodyAsFilter,
	|	Unit_MockServiceData.Request_BodyMD5 AS BodyMD5
	|INTO ttMockData
	|FROM
	|	Catalog.Unit_MockServiceData AS Unit_MockServiceData
	|WHERE
	|	NOT Unit_MockServiceData.DeletionMark
	|	AND NOT Unit_MockServiceData.IsFolder
	|	AND Unit_MockServiceData.Request_Type = &Request_Type
	|	AND CASE
	|		WHEN Unit_MockServiceData.Request_BodyAsFilter
	|			THEN (Unit_MockServiceData.Request_BodyMD5 = &BodyBinaryMD5
	|			or Unit_MockServiceData.Request_BodyMD5 = &BodyStringMD5)
	|		ELSE TRUE
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	Unit_MockServiceDataRequest_Headers.Ref
	|INTO ttHeaderFilter
	|FROM
	|	Catalog.Unit_MockServiceData.Request_Headers AS Unit_MockServiceDataRequest_Headers
	|		INNER JOIN ttMockData AS ttMockData
	|		ON Unit_MockServiceDataRequest_Headers.Ref = ttMockData.Ref
	|WHERE
	|	Unit_MockServiceDataRequest_Headers.ValueAsFilter
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	Unit_MockServiceDataRequest_Variables.Ref
	|INTO ttVariablesFilter
	|FROM
	|	Catalog.Unit_MockServiceData.Request_Variables AS Unit_MockServiceDataRequest_Variables
	|		INNER JOIN ttMockData AS ttMockData
	|		ON Unit_MockServiceDataRequest_Variables.Ref = ttMockData.Ref
	|WHERE
	|	Unit_MockServiceDataRequest_Variables.ValueAsFilter
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	Unit_MockServiceDataRequest_BodyVariables.Ref
	|INTO ttVariablesBodyFilter
	|FROM
	|	Catalog.Unit_MockServiceData.Request_BodyVariables AS Unit_MockServiceDataRequest_BodyVariables
	|		INNER JOIN ttMockData AS ttMockData
	|		ON Unit_MockServiceDataRequest_BodyVariables.Ref = ttMockData.Ref
	|WHERE
	|	Unit_MockServiceDataRequest_BodyVariables.ValueAsFilter
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ttMockData.Ref,
	|	ttMockData.Address,
	|	ttMockData.BodyMD5,
	|	ttMockData.BodyAsFilter,
	|	NOT ttHeaderFilter.Ref IS NULL AS isHeaderFilter,
	|	NOT ttVariablesFilter.Ref IS NULL AS isVariablesFilter,
	|	NOT ttVariablesBodyFilter.Ref IS NULL AS isVariablesBodyFilter
	|FROM
	|	ttMockData AS ttMockData
	|		LEFT JOIN ttHeaderFilter AS ttHeaderFilter
	|		ON ttMockData.Ref = ttHeaderFilter.Ref
	|		LEFT JOIN ttVariablesFilter AS ttVariablesFilter
	|		ON ttMockData.Ref = ttVariablesFilter.Ref
	|		LEFT JOIN ttVariablesBodyFilter AS ttVariablesBodyFilter
	|		ON ttMockData.Ref = ttVariablesBodyFilter.Ref";
	
	Query.SetParameter("Request_Type", RequestStructure.Type);
	
	Query.SetParameter("BodyBinaryMD5", CommonFunctionsServer.GetMD5(RequestStructure.BodyBinary));
	Query.SetParameter("BodyStringMD5", CommonFunctionsServer.GetMD5(GetBinaryDataFromString(RequestStructure.BodyString)));
	
	Selection = Query.Execute().Select();
	While Selection.Next() Do
		RequestVariables = New Structure;
		SelectionStructure = GetSelectionMockStructure();
		FillPropertyValues(SelectionStructure, Selection);
		CheckingResult = CheckRequestToMockData(RequestStructure, SelectionStructure, RequestVariables); 
		If CheckingResult.Successfully Then
			MockDataRef = Selection.Ref; // CatalogRef.Unit_MockServiceData
			Result.MockData = MockDataRef;
			Result.RequestVariables = RequestVariables;
			Break;
		EndIf;  
	EndDo;
	
	Return Result;
	
EndFunction

// Get request variables.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
//  Logs - String
// 
// Returns:
//  Structure - request variables
Function getRequestVariables(RequestStructure, MockData, Logs)
	
	AddLineToLogs(Logs, R().Mock_009, True);
	
	Result = new Structure;
	For Each Element In MockData.Request_Variables Do
		RequestValue = RequestStructure.Options.Get(Element.VariableName);
		If ValueIsFilled(RequestValue) Then
			Result.Insert(Element.VariableName, RequestValue);
			AddLineToLogs(Logs, StrTemplate("%1 - %2", R().Mock_003, Element.VariableName));
		Else
			AddLineToLogs(Logs, StrTemplate("%1 - %2", R().Mock_002, Element.VariableName));
		EndIf;
	EndDo;
	
	For Each Element In MockData.Request_BodyVariables Do
		AddLineToLogs(Logs, StrTemplate(R().Mock_010, Element.VariableName));
		RequestValue = getValueOfBodyVariable(RequestStructure, Element.PathToValue, Element.Value, Result);
		Result.Insert(Element.VariableName, RequestValue);
	EndDo;
	
	Return Result;
	
EndFunction

// Get value of body variable.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
//  PathToValue - String - Path to value
//  MockValue - String - Mock value
//  RequestVariables - Structure - existing variables
// 
// Returns:
//  String - Value of body variable
Function getValueOfBodyVariable(RequestStructure, PathToValue, MockValue, RequestVariables)
	
	If IsBlankString(PathToValue) Then
		Return TransformationValue(MockValue, RequestVariables);
	EndIf;
	
	Try
		Return getValueOfBodyVariableByPath(PathToValue, RequestStructure, True);
	Except
		Return "";
	EndTry;
	
EndFunction

// Get value of body variable by path.
// 
// Parameters:
//  PathToValue - String - Path to value
//  DataForValue - Arbitrary
//  isFirst - Boolean
// 
// Returns:
//  String - Get value of body variable by path
Function getValueOfBodyVariableByPath(PathToValue, DataForValue, isFirst=False)
	
	If isFirst Then
		If StrStartsWith(PathToValue, "[text]") Then
			Return getValueOfBodyVariableByPath(Mid(PathToValue,8), DataForValue.BodyString);
		ElsIf StrStartsWith(PathToValue, "[file]") Then
			Return getValueOfBodyVariableByPath(Mid(PathToValue,8), DataForValue.BodyBinary);
		Else
			Return "";
		EndIf;
	EndIf;
	
	ArrayOfSegments = StrSplit(PathToValue, "/");
	
	If ArrayOfSegments.Count() = 0 Then
		Return String(DataForValue);
	EndIf;
	
	CurrentDataType = ArrayOfSegments[0];
	NextPath = Mid(PathToValue, StrLen(CurrentDataType)+2);
	
	If TypeOf(DataForValue) = Type("String") Then
		
		If CurrentDataType = "[xml]" Then
			ReaderXML = New XMLReader();
			ReaderXML.SetString(DataForValue);
			ValueXML = XDTOFactory.ReadXML(ReaderXML); // Arbitrary
			Return getValueOfBodyVariableByPath(NextPath, ValueXML);
			
		ElsIf CurrentDataType = "[json]" Then
			ReaderJSON = New JSONReader();
			ReaderJSON.SetString(DataForValue);
			ValueJSON = ReadJSON(ReaderJSON);
			Return getValueOfBodyVariableByPath(NextPath, ValueJSON);
			
		ElsIf CurrentDataType = "[base64]" Then
			ValueBase64 = Base64Value(DataForValue);
			Return getValueOfBodyVariableByPath(NextPath, ValueBase64);
			
		Else
			Return String(DataForValue);
			
		EndIf;
	
	ElsIf TypeOf(DataForValue) = Type("BinaryData") Then
		
		If CurrentDataType = "[text]" Then
			ValueText = GetStringFromBinaryData(DataForValue);
			Return getValueOfBodyVariableByPath(NextPath, ValueText);
			
		ElsIf CurrentDataType = "[zip]" Then
			FileName = ArrayOfSegments[1];
			NextPath = Mid(NextPath, StrLen(FileName)+2);
	 		ReadStream = New MemoryStream(GetBinaryDataBufferFromBinaryData(DataForValue));
	 		ZIP = New ZipFileReader(ReadStream);
	 		TempFile = TempFilesDir() + String(New UUID);
	 		ZIP.ExtractAll(TempFile, ZIPRestoreFilePathsMode.DontRestore);
	 		FileName = ?(FileName="[0]", ZIP.Items[0].Name, FileName);
	 		NewBinaryData = New BinaryData(TempFile + "/" + FileName);
	 		ZIP.Close();
	 		ReadStream.Close();
	 		DeleteFiles(TempFile);
			Return getValueOfBodyVariableByPath(NextPath, NewBinaryData);
			
		Else
			Return String(DataForValue);
			
		EndIf;
	
	ElsIf StrStartsWith(CurrentDataType, "[") Then
		// TODO: Other operation 
		
	Else // get object property 
		PropertyValue = DataForValue[CurrentDataType]; // Arbitrary
		If IsBlankString(NextPath) Then
			Return String(PropertyValue);
		Else
			Return getValueOfBodyVariableByPath(NextPath, PropertyValue);
		EndIf;
	EndIf;
	
	Return "";
	
EndFunction

// Transformation value.
// 
// Parameters:
//  SomeValue - String - Some value
//  RequestVariables - Structure - existing variables
// 
// Returns:
//  String - Transformation value
Function TransformationValue(SomeValue, RequestVariables)
	
	If IsBlankString(SomeValue) Then
		Return "";
	EndIF;
	
	IF StrLen(SomeValue) > 6 And StrStartsWith(SomeValue, "$$$") And StrEndsWith(SomeValue, "$$$") Then
		KeyName = Mid(SomeValue, 4, StrLen(SomeValue)-6);
		Try
			Return RequestVariables[KeyName];
		Except
			Return "";
		EndTry; 
	EndIf;
	 
	IF StrLen(SomeValue) > 6 And StrStartsWith(SomeValue, "{{{") And StrEndsWith(SomeValue, "}}}") Then
		Params = CommonFunctionsServer.GetRecalculateExpressionParams();
		Params.Eval = True;
		Params.SafeMode = True;
		Params.Expression = Mid(SomeValue, 4, StrLen(SomeValue)-6);
		Params.AddInfo = RequestVariables;
		ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
		If ResultInfo.isError Then
			Return "";
		Else
			Return ResultInfo.Result;
		EndIf; 
	EndIf;
	
	Return SomeValue;
	
EndFunction

#EndRegion