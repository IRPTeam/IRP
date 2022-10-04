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

// Compose answer to structure of request.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest 
//  MockData - CatalogRef.Unit_MockServiceData -
//  RequestVariables - Structure - Request variables
// 
// Returns:
//  HTTPServiceResponse - Compose answer to request
Function ComposeAnswerToRequestStructure(RequestStructure, MockData = Undefined, RequestVariables = Undefined) Export
	
	If MockData = Undefined Then
		MockDataInfo = getMockDataByRequest(RequestStructure);
		MockData = MockDataInfo.MockData;
		RequestVariables = MockDataInfo.RequestVariables;
	EndIf;
	
	If RequestVariables = Undefined Then
		RequestVariables = getRequestVariables(RequestStructure, MockData, "");
	EndIf;
	
	If Not ValueIsFilled(MockData) Then
		Return New HTTPServiceResponse(404, R().Mock_Info_NotFound);
	EndIf;
	
	Response = New HTTPServiceResponse(MockData.Answer_StatusCode, MockData.Answer_Message);
	For Each HeaderItem In MockData.Answer_Headers Do
		Response.Headers.Insert(HeaderItem.Key, TransformationText(HeaderItem.Value, RequestVariables));
	EndDo;
	
	BodyRowValue = MockData.Answer_Body.Get(); // BinaryData
	If MockData.Answer_BodyIsText Then
		BodyString = "";
		If TypeOf(BodyRowValue) = Type("BinaryData") Then
			BodyString = GetStringFromBinaryData(BodyRowValue);
		Else
			BodyString = String(BodyRowValue);
		EndIf;
		Response.SetBodyFromString(TransformationText(BodyString, RequestVariables));
	Else
		Response.SetBodyFromBinaryData(BodyRowValue);
	EndIf;
	
	Return Response;
	
EndFunction

// Get mock data by request.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest 
// 
// Returns:
//  Structure - Get mock data by request:
// * MockData - CatalogRef.Unit_MockServiceData -
// * RequestVariables - Structure -
Function getMockDataByRequest(RequestStructure) Export
	
	Result = New Structure;
	Result.Insert("MockData", Catalogs.Unit_MockServiceData.EmptyRef());
	Result.Insert("RequestVariables", New Structure);
	
	SelectionStructures = RunQueryForSearchMockData(RequestStructure);
	For Each SelectionStructure In SelectionStructures Do
		CheckingResult = CheckRequestToMockData(RequestStructure, SelectionStructure, Result.RequestVariables); 
		If CheckingResult.Successfully Then
			Result.MockData = SelectionStructure.Ref;
			Break;
		EndIf;  
	EndDo;
	
	Return Result;
	
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
	
	AddLineToLogs(Result.Logs, R().Mock_Info_AllChecskPassedSuccessfully, True);
	Result.Successfully = True;
	Return Result;
	
EndFunction

// Get value of body variable by path.
// 
// Parameters:
//  PathToValue - String - Path to value
//  DataForValue - Arbitrary
//  AllCommands - See getAllContentCommands
//  RowData - Boolean
// 
// Returns:
//  String - Get value of body variable by path
Function getValueOfBodyVariableByPath(PathToValue, DataForValue, AllCommands = Undefined, RowData = False) Export
	
	If AllCommands = Undefined Then
		AllCommands = getAllContentCommands();
	EndIf;
	
	ArrayOfSegments = StrSplit(PathToValue, "/");
	
	If ArrayOfSegments.Count() = 0 Then
		Return ?(RowData, DataForValue, GetPresentationArbitrary(DataForValue));
	EndIf;
	
	CurrentDataType = ArrayOfSegments[0];
	NextPath = Mid(PathToValue, StrLen(CurrentDataType) + 2);
	
	If TypeOf(DataForValue) = Type("String") Then
		
		If CurrentDataType = AllCommands.XML Then
			Reader = New XMLReader();
			Reader.SetString(DataForValue);
			ValueXML = XDTOFactory.ReadXML(Reader); // Arbitrary
			Reader.Close();
			Return getValueOfBodyVariableByPath(NextPath, ValueXML, AllCommands, RowData);
			
		ElsIf CurrentDataType = AllCommands.JSON Then
			ValueJSON = CommonFunctionsServer.DeserializeJSON(DataForValue, True);
			Return getValueOfBodyVariableByPath(NextPath, ValueJSON, AllCommands, RowData);
			
		ElsIf CurrentDataType = AllCommands.File Then
			ValueBase64 = Base64Value(DataForValue);
			Return getValueOfBodyVariableByPath(NextPath, ValueBase64, AllCommands, RowData);
			
		ElsIf StrStartsWith(CurrentDataType, "[csv") Then
			Separator = ",";
			If CurrentDataType <> AllCommands.CSV Then
				Separator = Mid(CurrentDataType, 6, StrLen(CurrentDataType) - 6);
			EndIf; 
			Return getValueOfBodyVariableByPath(NextPath, StrSplit(DataForValue, Separator, True), AllCommands, RowData);
			
		Else
			Return ?(RowData, DataForValue, GetPresentationArbitrary(DataForValue));
			
		EndIf;
	
	ElsIf TypeOf(DataForValue) = Type("BinaryData") Then
		
		If CurrentDataType = AllCommands.Text Then
			ValueText = GetStringFromBinaryData(DataForValue);
			Return getValueOfBodyVariableByPath(NextPath, ValueText, AllCommands, RowData);
		
		ElsIf CurrentDataType = AllCommands.File Then
			Return getValueOfBodyVariableByPath(NextPath, DataForValue, AllCommands, RowData);
				
		ElsIf CurrentDataType = AllCommands.ZIP Then
	 		ReadStream = New MemoryStream(GetBinaryDataBufferFromBinaryData(DataForValue));
	 		ZIP = New ZipFileReader(ReadStream);
	 		TempFile = TempFilesDir() + String(New UUID);
	 		If ArrayOfSegments.Count() > 1 Then
				FileName = ArrayOfSegments[1];
				NextPath = Mid(NextPath, StrLen(FileName)+2);
		 		ZIP.ExtractAll(TempFile, ZIPRestoreFilePathsMode.DontRestore);
		 		NewBinaryData = New BinaryData(TempFile + "/" + FileName); // String, BinaryData
		 		DeleteFiles(TempFile);
	 		Else
	 			NewBinaryData = "ZIP:";
	 			For Each ZipItem In ZIP.Items Do
	 				NewBinaryData = NewBinaryData + Chars.CR + "* " + ZipItem.FullName; 
	 			EndDo;
	 		EndIf;
	 		ZIP.Close();
	 		ReadStream.Close();
			Return getValueOfBodyVariableByPath(NextPath, NewBinaryData, AllCommands, RowData);
			
		Else
			Return ?(RowData, DataForValue, GetPresentationArbitrary(DataForValue));
			
		EndIf;
	
	ElsIf TypeOf(DataForValue) = Type("XDTODataObject") Then
		
		If IsBlankString(CurrentDataType) Then
			Return ?(RowData, DataForValue, GetPresentationXDTODataObject(DataForValue));
			
		ElsIf IsBlankString(NextPath) Then
			If CurrentDataType = AllCommands.Text Then
				CurrentValue = DataForValue.Sequence().GetText(0);
			Else
				CurrentValue = DataForValue[CurrentDataType]; // XDTODataObject, String
			EndIf;
			If TypeOf(CurrentValue) = Type("XDTODataObject") Then
				Return ?(RowData, CurrentDataType, GetPresentationXDTODataObject(CurrentValue));
			ElsIf TypeOf(CurrentValue) = Type("XDTOList") Then
				Return getValueOfBodyVariableByPath(NextPath, CurrentValue, AllCommands, RowData);
			Else
				Return ?(RowData, CurrentValue, GetPresentationArbitrary(CurrentValue));
			EndIf;
			
		Else
			Return getValueOfBodyVariableByPath(NextPath, DataForValue[CurrentDataType], AllCommands, RowData);
			
		EndIf;
	
	Else // get object property
	 
	 	If TypeOf(DataForValue) = Type("Array") Or TypeOf(DataForValue) = Type("XDTOList") Then
	 		If IsBlankString(CurrentDataType) Then
	 			Return ?(RowData, DataForValue, GetPresentationArbitrary(DataForValue));
	 		Else
	 			NumberKey = Number(CurrentDataType);
				PropertyValue = DataForValue[NumberKey]; // Arbitrary
	 		EndIf
	 	ElsIf TypeOf(DataForValue) = Type("Map") Then
	 		If IsBlankString(CurrentDataType) Then
	 			Return ?(RowData, DataForValue, GetPresentationArbitrary(DataForValue));
	 		Else
	 			PropertyValue = DataForValue[CurrentDataType]; // Arbitrary
	 		EndIf
	 	Else
			PropertyValue = DataForValue[CurrentDataType]; // Arbitrary
	 	EndIf;
	 
		If IsBlankString(NextPath) Then
			If TypeOf(PropertyValue) = Type("XDTODataObject") Then
				Return ?(RowData, PropertyValue, GetPresentationXDTODataObject(PropertyValue));
			Else
				Return ?(RowData, PropertyValue, GetPresentationArbitrary(PropertyValue));
			EndIf;
		Else
			Return getValueOfBodyVariableByPath(NextPath, PropertyValue, AllCommands, RowData);
		EndIf;
	EndIf;
	
EndFunction

// Get available commands.
// 
// Parameters:
//  CurrentCommands - String - Current commands
// 
// Returns:
//  Array of String - Get available commands
Function getAvailableCommands(CurrentCommands) Export
	
	ContentCommands = getAllContentCommands();
	
	Result = New Array;
	
	If CurrentCommands = ContentCommands.File Then
		Result.Add(ContentCommands.Text);
		Result.Add(ContentCommands.ZIP);
	
	ElsIf CurrentCommands = ContentCommands.Text Then
		Result.Add(ContentCommands.XML);
		Result.Add(ContentCommands.JSON);
		Result.Add(ContentCommands.CSV);
		Result.Add(ContentCommands.CSV_Any);
	
	ElsIf StrStartsWith(CurrentCommands, "[csv") Then
		Result.Add(ContentCommands.Zero);
		Result.Add(ContentCommands.First);
		Result.Add(ContentCommands.Second);
		Result.Add(ContentCommands.Third);
		Result.Add(ContentCommands.Any);
	
	ElsIf CurrentCommands = ContentCommands.ZIP Then
	ElsIf CurrentCommands = ContentCommands.XML Then
	ElsIf CurrentCommands = ContentCommands.JSON Then
	
	Else
		Result.Add(ContentCommands.File);
		Result.Add(ContentCommands.ZIP);
		Result.Add(ContentCommands.Text);
		Result.Add(ContentCommands.XML);
		Result.Add(ContentCommands.JSON);
		Result.Add(ContentCommands.CSV);
		Result.Add(ContentCommands.CSV_Any);
	
	EndIf;
	
	Return Result;
	
EndFunction
	
// Get all content commands.
// 
// Returns:
//  Structure - Get all content commands:
// * Text - String - [text]
// * File - String - [file]
// * ZIP - String - [zip]
// * XML - String - [xml]
// * JSON - String - [json]
// * CSV - String - [csv]
// * CSV_Any - String - [csv=?]
// * Zero - String - 0
// * First - String - 1
// * Second - String - 2
// * Third - String - 3
// * Any - String - ?
Function getAllContentCommands() Export
	
	Result = New Structure;
	
	Result.Insert("Text", "[text]");
	Result.Insert("File", "[file]");
	Result.Insert("ZIP", "[zip]");
	Result.Insert("XML", "[xml]");
	Result.Insert("JSON", "[json]");
	Result.Insert("CSV", "[csv]");
	Result.Insert("CSV_Any", "[csv=?]");
	Result.Insert("Zero", "0");
	Result.Insert("First", "1");
	Result.Insert("Second", "2");
	Result.Insert("Third", "3");
	Result.Insert("Any", "?");

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
// * BodyMD5 - String -
// * BodyAsFilter - Boolean -
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

	AddLineToLogs(Logs, R().Mock_Info_StartAddressCheck, True);
	AddLineToLogs(Logs, StrTemplate("%1: %2", R().Mock_Info_InputAddress, Address));
	AddLineToLogs(Logs, StrTemplate("%1: %2", R().Mock_Info_PatternAddress, Pattern));

	AddressParts = StrSplit(Address, "/", False);
	PatternParts = StrSplit(Pattern, "/", False);
	
	If AddressParts.Count() < PatternParts.Count() Then
		AddLineToLogs(Logs, R().Mock_Error_NeedMoreAddressParts);
		Return False;
	Else
		NumberExtraSections = AddressParts.Count() - PatternParts.Count();
		AnyString = GetAnyString();
		For Index = 1 To NumberExtraSections Do
			PatternParts.Add(AnyString);
		EndDo; 
	EndIf;
	
	For Index = 0 To AddressParts.Count() - 1 Do
		If Not StringEqualsCheck(AddressParts[Index], PatternParts[Index]) Then
			AddLineToLogs(Logs, StrTemplate(R().Mock_Error_DifferenceInAddressPart, Index + 1));
			AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_RequiredValue, PatternParts[Index]));
			AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_FoundValue, AddressParts[Index]));
			Return False;
		EndIf;
	EndDo;

	AddLineToLogs(Logs, R().Mock_Info_CheckPassedSuccessfully);
	Return True;
	
EndFunction 

// Headers check.
// 
// Parameters:
//  Headers - FixedMap - Headers
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
//  Logs - String - Logs
// 
// Returns:
//  Boolean - Headers check
Function HeadersCheck(Headers, MockData, Logs)
	
	AddLineToLogs(Logs, R().Mock_Info_StartHeadersCheck, True);
	
	For Each MockHeaderItem In MockData.Request_Headers Do
		
		If MockHeaderItem.ValueAsFilter And ValueIsFilled(MockHeaderItem.Value) Then
			
			HeadersValue = Headers.Get(MockHeaderItem.Key); //String
			If HeadersValue = Undefined Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_Error_NotFound_Header, MockHeaderItem.Key));
				Return False;
			EndIf;  
			
			If Not StringEqualsCheck(HeadersValue, MockHeaderItem.Value) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_Error_Difference_Header, MockHeaderItem.Key));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_RequiredValue, MockHeaderItem.Value));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_FoundValue, HeadersValue));
				Return False;
			EndIf;

		EndIf;
		 
	EndDo;
	
	AddLineToLogs(Logs, R().Mock_Info_CheckPassedSuccessfully);
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
	
	AddLineToLogs(Logs, R().Mock_Info_StartBodyCheck, True);
	
	BodyBinaryMD5 = CommonFunctionsServer.GetMD5(RequestStructure.BodyBinary);
	BodyStringMD5 = CommonFunctionsServer.GetMD5(GetBinaryDataFromString(RequestStructure.BodyString));
	
	If BodyBinaryMD5 <> MockBodyMD5 And BodyStringMD5 <> MockBodyMD5 Then
		AddLineToLogs(Logs, R().Mock_Error_Difference_MD5);
		AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_RequiredValue, MockBodyMD5));
		AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_MD5_Binary, BodyBinaryMD5));
		AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_MD5_String, BodyStringMD5));
		Return False;
	EndIf;
	
	AddLineToLogs(Logs, R().Mock_Info_CheckPassedSuccessfully);
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
	
	AddLineToLogs(Logs, R().Mock_Info_StartVariablesCheck, True);
	
	For Each VareablesItem In MockData.Request_Variables Do
		If VareablesItem.ValueAsFilter Then
			VariableValue = "";
			If Not RequestVariables.Property(VareablesItem.VariableName, VariableValue) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_Error_NotFound_Variable, VareablesItem.VariableName));
				Return False;
			EndIf;  
			If Not StringEqualsCheck(VariableValue, VareablesItem.Value) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_Error_Difference_Variable, VareablesItem.VariableName));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_RequiredValue, VareablesItem.Value));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_FoundValue, VariableValue));
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
	
	AddLineToLogs(Logs, R().Mock_Info_CheckPassedSuccessfully);
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
	
	AddLineToLogs(Logs, R().Mock_Info_StartBodyVariablesCheck, True);
	
	For Each VareablesItem In MockData.Request_BodyVariables Do
		If VareablesItem.ValueAsFilter Then
			VariableValue = "";
			If Not RequestVariables.Property(VareablesItem.VariableName, VariableValue) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_Error_NotFound_Variable, VareablesItem.VariableName));
				Return False;
			EndIf;  
			If Not StringEqualsCheck(VariableValue, VareablesItem.Value) Then
				AddLineToLogs(Logs, StrTemplate(R().Mock_Error_Difference_Variable, VareablesItem.VariableName));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_RequiredValue, VareablesItem.Value));
				AddLineToLogs(Logs, StrTemplate(" * %1: %2", R().Mock_Info_FoundValue, VariableValue));
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
	
	AddLineToLogs(Logs, R().Mock_Info_CheckPassedSuccessfully);
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
Procedure AddLineToLogs(Logs, NewLine, isHeader = False)
	Logs = Logs + ?(IsBlankString(Logs), "", Chars.CR);
	If isHeader Then
		Logs = Logs + "=== " + NewLine + " ===";
	Else
		Logs = Logs + NewLine;
	EndIf; 
EndProcedure

// Run query for search mock data.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
// 
// Returns:
//  Array of See Unit_MockService.GetSelectionMockStructure
Function RunQueryForSearchMockData(RequestStructure)
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	Unit_MockServiceData.Ref AS Ref,
	|	Unit_MockServiceData.Request_ResourceAddress AS Address,
	|	Unit_MockServiceData.Request_BodyAsFilter AS BodyAsFilter,
	|	Unit_MockServiceData.Request_BodyMD5 AS BodyMD5,
	|	Unit_MockServiceData.Priority
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
	|			OR Unit_MockServiceData.Request_BodyMD5 = &BodyStringMD5)
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
	|		ON ttMockData.Ref = ttVariablesBodyFilter.Ref
	|
	|ORDER BY
	|	ttMockData.Priority DESC,
	|	ttMockData.Ref";
	
	Query.SetParameter("Request_Type", RequestStructure.Type);
	
	Query.SetParameter("BodyBinaryMD5", CommonFunctionsServer.GetMD5(RequestStructure.BodyBinary));
	Query.SetParameter("BodyStringMD5", CommonFunctionsServer.GetMD5(GetBinaryDataFromString(RequestStructure.BodyString)));
	
	Return Query.Execute().Unload();
	
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
	
	AddLineToLogs(Logs, R().Mock_Info_StartGettingVariables, True);
	
	Result = New Structure;
	For Each Element In MockData.Request_Variables Do
		RequestValue = RequestStructure.Options.Get(Element.VariableName);
		If Not RequestValue = Undefined Then
			Result.Insert(Element.VariableName, RequestValue);
			AddLineToLogs(Logs, StrTemplate("%1 - %2", R().Mock_Info_FoundOut, Element.VariableName));
		Else
			AddLineToLogs(Logs, StrTemplate("%1 - %2", R().Mock_Info_NotFound, Element.VariableName));
		EndIf;
	EndDo;
	
	For Each Element In MockData.Request_BodyVariables Do
		AddLineToLogs(Logs, StrTemplate(R().Mock_Info_StartCalculationOf, Element.VariableName));
		RequestValue = getValueOfBodyVariable(RequestStructure, Element.PathToValue, Element.Value, Result);
		Result.Insert(Element.VariableName, RequestValue);
	EndDo;
	
	For Each Element In MockData.Request_AddressParts Do
		AddLineToLogs(Logs, StrTemplate(R().Mock_Info_StartCalculationOf, Element.VariableName));
		AddressParts = StrSplit(RequestStructure.Address, "/");
		ValuePart = "";
		If Element.PartNumber < AddressParts.Count() Then 
			ValuePart = AddressParts[Element.PartNumber];
		EndIf;
		Result.Insert(Element.VariableName, ValuePart);
		If Element.AsUrlVariable Then
			AddressParts = StrSplit(ValuePart, "&");
			For Each AddressPart In AddressParts Do
				KeyValue = StrSplit(AddressPart, "=");
				If KeyValue.Count() = 1 Then
					Result.Insert(KeyValue[0], "");
				Else
					Result.Insert(KeyValue[0], KeyValue[1]);
				EndIf;
			EndDo;
		EndIf;
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
	
	NewPath = "";
	NewData = Undefined;
	
	If StrStartsWith(PathToValue, "[text]") Then
		NewPath = Mid(PathToValue,8);
		NewData = RequestStructure.BodyString;
	ElsIf StrStartsWith(PathToValue, "[file]") Then
		NewPath = Mid(PathToValue,8);
		NewData = RequestStructure.BodyBinary;
	Else
		Return "";
	EndIf;
	
	Try
		Return getValueOfBodyVariableByPath(NewPath, NewData);
	Except
		Return "";
	EndTry;
	
EndFunction

// Get presentation XDTOData object.
// 
// Parameters:
//  XDTODataObject - XDTODataObject - XDTOData object
// 
// Returns:
//	String - presentation XDTOData object  
Function GetPresentationXDTODataObject(XDTODataObject)
	
	Result = "[XDTODataObject]";
	
	For Each XDTOProperty In XDTODataObject.Properties() Do
		Result = Result + Chars.CR + "* " + XDTOProperty.LocalName; 
	EndDo;
	
	Try
		CurrentValue = XDTODataObject.Sequence().GetText(0);
		Result = Result + Chars.CR + "* [text] = " + CurrentValue;
	Except
		// There is no text!!!
	EndTry;

	Return Result;
	
EndFunction

// Get presentation map.
// 
// Parameters:
//  MapObject - Map - Map object
// 
// Returns:
//  String - Get presentation map
Function GetPresentationMap(MapObject)
	
	Result = "[Map]";
	
	For Each KeyValue In MapObject Do
		Result = Result + Chars.CR + "* " + KeyValue.Key; 
	EndDo;
	
	Return Result;
	
EndFunction

// Get presentation arbitrary.
// 
// Parameters:
//  ArbitraryObject - Arbitrary - object
// 
// Returns:
//  String - Get presentation
Function GetPresentationArbitrary(ArbitraryObject)
	
	If TypeOf(ArbitraryObject) = Type("Array")
			Or TypeOf(ArbitraryObject) = Type("XDTOList")
			Or TypeOf(ArbitraryObject) = Type("ValueList")
			Or TypeOf(ArbitraryObject) = Type("ValueTable") Then
		Return "Collection";
		
	ElsIf TypeOf(ArbitraryObject) = Type("Map") Then
		Return GetPresentationMap(ArbitraryObject);
		
	ElsIf TypeOf(ArbitraryObject) = Type("XDTODataObject") Then
		Return GetPresentationXDTODataObject(ArbitraryObject);
		
	EndIf;
	 
	Return String(ArbitraryObject);
	
EndFunction

// Get array from text.
// 
// Parameters:
//  Text - String
//  Start - String
//  End - String
// 
// Returns:
//  Array of String - Get array from text
Function GetArrayFromText(Text, Start, End)
	Result = New Array;
	
	CurrentPosition = 1;
	While CurrentPosition <= StrLen(Text) Do
		
		StartPosition = StrFind(Text, Start, SearchDirection.FromBegin, CurrentPosition);
		If StartPosition = 0 Then
			Break;
		EndIf;
		ValueStart = StartPosition + StrLen(Start);
		
		EndPosition = StrFind(Text, End, SearchDirection.FromBegin, ValueStart);
		If EndPosition = 0 Then
			Break;
		EndIf;
		CurrentPosition = EndPosition + StrLen(End);
		
		Value = Mid(Text, StartPosition, CurrentPosition - StartPosition);
		Result.Add(Value);
		
	EndDo;
	
	Return Result;
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
		KeyName = Mid(SomeValue, 4, StrLen(SomeValue) - 6);
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
		Params.Expression = Mid(SomeValue, 4, StrLen(SomeValue) - 6);
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

// Transformation text.
// 
// Parameters:
//  SomeText - String - Some value
//  RequestVariables - Structure - existing variables
// 
// Returns:
//  String - Transformation value
Function TransformationText(Val SomeText, RequestVariables)
	
	If IsBlankString(SomeText) Then
		Return "";
	EndIF;
	
	ArrayVarriables = GetArrayFromText(SomeText, "$$$", "$$$");
	MapVarriables = New Map;
	For Each ItemVariable In ArrayVarriables Do // String, String
		MapVarriables.Insert(ItemVariable, TransformationValue(ItemVariable, RequestVariables));
	EndDo;
	For Each KeyValue In MapVarriables Do
		SomeText = StrReplace(SomeText, KeyValue.Key, KeyValue.Value);
	EndDo;
	
	ArrayVarriables = GetArrayFromText(SomeText, "{{{", "}}}");
	MapVarriables = New Map;
	For Each ItemVariable In ArrayVarriables Do // String, String
		MapVarriables.Insert(ItemVariable, TransformationValue(ItemVariable, RequestVariables));
	EndDo;
	For Each KeyValue In MapVarriables Do
		SomeText = StrReplace(SomeText, KeyValue.Key, KeyValue.Value);
	EndDo;
	
	Return SomeText;
	
EndFunction


#EndRegion