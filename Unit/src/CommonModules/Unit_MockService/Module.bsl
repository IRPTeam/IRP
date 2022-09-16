// @strict-types

#Region Public

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
Function ComposeAnswerToRequestStructure(RequestStructure, MockData=Undefined) Export
	
	If MockData=Undefined Then
		MockDataInfo = getMockDataByRequest(RequestStructure);
		MockData = MockDataInfo.MockData;
		RequestVariables = MockDataInfo.RequestVariables;
	Else
		RequestVariables = getRequestVariables(RequestStructure, MockData);
	EndIf;
	
	If not ValueIsFilled(MockData) Then
		Return New HTTPServiceResponse(404, "Not Found");
	EndIf;
	
	Response = New HTTPServiceResponse(MockData.Answer_StatusCode, MockData.Answer_Message);
	For Each HeaderItem In MockData.Answer_Headers Do
		// TODO: need calculate header with variables
		Response.Headers.Insert(HeaderItem.Key, HeaderItem.Value);
	EndDo;
	
	BodyRowValue = MockData.Answer_Body.Get(); // BinaryData
	If MockData.Answer_BodyIsText Then
		// TODO: need calculate body with variables
		If TypeOf(BodyRowValue) = Type("BinaryData") Then
			Response.SetBodyFromString(GetStringFromBinaryData(BodyRowValue));
		Else
			Response.SetBodyFromString(String(BodyRowValue));
		EndIf;
	Else
		Response.SetBodyFromBinaryData(BodyRowValue);
	EndIf;
	
	Return Response;
	
EndFunction

// Wildcard address check.
// 
// Parameters:
//  Address - String - Address
//  Pattern - String - Pattern of address
// 
// Returns:
//  Boolean - address matches
Function AddressCheck(Address, Pattern) Export

	AddressParts = StrSplit(Address, "/", False);
	PatternParts = StrSplit(Pattern, "/", False);
	
	If AddressParts.Count() < PatternParts.Count() Then
		Return False;
	Else
		NumberExtraSections = AddressParts.Count() - PatternParts.Count();
		AnyString = GetAnyString();
		For index = 1 To NumberExtraSections Do
			PatternParts.Add(AnyString);
		EndDo; 
	EndIf;
	
	For index = 0 To AddressParts.Count()-1 Do
		If Not StringEqualsCheck(AddressParts[index], PatternParts[index]) Then
			Return False;
		EndIf;
	EndDo;

	Return True;
	
EndFunction 

// Headers check.
// 
// Parameters: Address - String - Address
// Pattern - String - Pattern of address
//  Headers - FixedMap - Headers
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
// 
// Returns:
//  Boolean - address matches
Function HeadersCheck(Headers, MockData) Export
	For Each MockHeaderItem In MockData.Request_Headers Do
		If MockHeaderItem.ValueAsFilter and ValueIsFilled(MockHeaderItem.Value) Then
			HeadersValue = Headers.Get(MockHeaderItem.Key); //String
			If HeadersValue = Undefined Then
				Return False;
			EndIf;  
			If Not StringEqualsCheck(HeadersValue, MockHeaderItem.Value) Then
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
	Return True;
EndFunction 

// Variables check.
// 
// Parameters:
//  RequestVariables - Structure
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
// 
// Returns:
//  Boolean - Variables checked
Function VariablesCheck(RequestVariables, MockData) Export
	For Each VareablesItem In MockData.Request_Variables Do
		If VareablesItem.ValueAsFilter Then
			VariableValue = "";
			If RequestVariables.Property(VareablesItem.VariableName, VariableValue) Then
				Return False;
			EndIf;  
			If Not StringEqualsCheck(VariableValue, VareablesItem.Value) Then
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
	Return True;
EndFunction

// Body variables check.
// 
// Parameters:
//  RequestVariables - Structure
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
// 
// Returns:
//  Boolean - Body variables checked
Function VariablesBodyCheck(RequestVariables, MockData) Export
	For Each VareablesItem In MockData.Request_BodyVariables Do
		If VareablesItem.ValueAsFilter Then
			VariableValue = "";
			If RequestVariables.Property(VareablesItem.VariableName, VariableValue) Then
				Return False;
			EndIf;  
			If Not StringEqualsCheck(VariableValue, VareablesItem.Value) Then
				Return False;
			EndIf;  
		EndIf; 
	EndDo;
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
Function StringEqualsCheck(Val InputString, Val PatternString) Export
	
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
Function GetAnyString() Export
	Return "*";
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

#EndRegion 


#Region Private

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
	|	Unit_MockServiceData.Request_ResourceAddress AS Address
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
		
		If not AddressCheck(RequestStructure.Address, String(Selection.Address)) Then
			Continue;
		EndIf;
		
		MockDataRef = Selection.Ref; // CatalogRef.Unit_MockServiceData
		If Selection.isHeaderFilter and not HeadersCheck(RequestStructure.Headers, MockDataRef) Then
			Continue;
		EndIf;
		
		RequestVariables = Undefined;
		If Selection.isVariablesFilter or Selection.isVariablesBodyFilter Then
			RequestVariables = getRequestVariables(RequestStructure, MockDataRef);
			If Selection.isVariablesFilter and not VariablesCheck(RequestVariables, MockDataRef) Then
				Continue;
			EndIf;
			If Selection.isVariablesBodyFilter and not VariablesBodyCheck(RequestVariables, MockDataRef) Then
				Continue;
			EndIf;
		EndIf;
		If RequestVariables = Undefined Then
			RequestVariables = getRequestVariables(RequestStructure, MockDataRef);
		EndIf;
		
		Result.MockData = MockDataRef;
		Result.RequestVariables = RequestVariables;
		Break;  
		
	EndDo;
	
	Return Result;
	
EndFunction

// Get request variables.
// 
// Parameters:
//  RequestStructure - See Unit_MockService.GetStructureRequest
//  MockData - CatalogRef.Unit_MockServiceData - Mock data
// 
// Returns:
//  Structure - request variables
Function getRequestVariables(RequestStructure, MockData)
	Result = new Structure;
	For Each Element In MockData.Request_Variables Do
		RequestValue = RequestStructure.Options.Get(Element.VariableName);
		If ValueIsFilled(RequestValue) Then
			Result.Insert(Element.VariableName, RequestValue);
		EndIf;
	EndDo;
	For Each Element In MockData.Request_BodyVariables Do
		RequestValue = RequestStructure.Options.Get(Element.VariableName);
		If ValueIsFilled(RequestValue) Then
			Result.Insert(Element.VariableName, RequestValue);
		EndIf;
	EndDo;
	Return Result;
EndFunction


#EndRegion