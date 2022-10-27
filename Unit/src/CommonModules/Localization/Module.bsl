

// Strings.
// 
// Parameters:
//  Lang - String - Lang
// 
// Returns:
//  Structure - Unit strings:
// * Mock_Info_EmptyFile - String - Empty file!
// * Mock_Info_NotFound - String - Not Found
// * Mock_Info_FoundOut - String - Found out
// * Mock_Info_StartAddressCheck - String - Start address check
// * Mock_Info_StartHeadersCheck - String - Start headers check
// * Mock_Info_StartBodyCheck - String - Start body check
// * Mock_Info_StartVariablesCheck - String - Start variables check
// * Mock_Info_StartBodyVariablesCheck - String - Start body´s variables check
// * Mock_Info_StartGettingVariables - String - Start getting variables from the request
// * Mock_Info_StartCalculationOf - String - Calculation of %1
// * Mock_Info_CheckPassedSuccessfully - String - Check passed successfully
// * Mock_Info_AllChecskPassedSuccessfully - String - All checks passed successfully
// * Mock_Error_NeedMoreAddressParts - String - Error: There are more parts in the address pattern
// * Mock_Error_DifferenceInAddressPart - String - Error: Difference in %1-th part of the address
// * Mock_Error_NotFound_Header - String - Error: Header Not found - %1
// * Mock_Error_Difference_Header - String - Error: Difference in meaning of header - %1
// * Mock_Error_Difference_MD5 - String - Error: Difference in meaning of MD5
// * Mock_Info_MD5_Binary - String - MD5 binary
// * Mock_Info_MD5_String - String - MD5 string
// * Mock_Error_NotFound_Variable - String - Error: Variable Not found - %1
// * Mock_Error_Difference_Variable - String - Error: Difference in meaning of variable - %1
// * Mock_Info_RequiredValue - String - Required value
// * Mock_Info_FoundValue - String - Found value
// * Mock_Info_InputAddress - String - Input address
// * Mock_Info_PatternAddress - String - Pattern address
// * Mock_Info_StatusCodeNotMatch - String - Status code does not match!
// * Mock_Info_HeaderNotMatch - String - Headers do not match!
// * Mock_Info_BodyNotMatch - String - Body does not match!
// * Mock_Error_NotFound_SetResult - String - Result value setting not found
&Around("Strings")
Function Unit_Strings(Lang) Export
	Strings = ProceedWithCall(Lang); // Structure
	Strings.Insert("Mock_Info_EmptyFile", NStr("en = 'Empty file!'", Lang));
	Strings.Insert("Mock_Info_NotFound", NStr("en = 'Not Found'", Lang));
	Strings.Insert("Mock_Info_FoundOut", NStr("en = 'Found out'", Lang));
	Strings.Insert("Mock_Info_StartAddressCheck", NStr("en = 'Start address check'", Lang));
	Strings.Insert("Mock_Info_StartHeadersCheck", NStr("en = 'Start headers check'", Lang));
	Strings.Insert("Mock_Info_StartBodyCheck", NStr("en = 'Start body check'", Lang));
	Strings.Insert("Mock_Info_StartVariablesCheck", NStr("en = 'Start variables check'", Lang));
	Strings.Insert("Mock_Info_StartBodyVariablesCheck", NStr("en = 'Start body´s variables check'", Lang));
	Strings.Insert("Mock_Info_StartGettingVariables", NStr("en = 'Start getting variables from the request'", Lang));
	Strings.Insert("Mock_Info_StartCalculationOf", NStr("en = 'Calculation of %1'", Lang));
	Strings.Insert("Mock_Info_CheckPassedSuccessfully", NStr("en = 'Check passed successfully'", Lang));
	Strings.Insert("Mock_Info_AllChecskPassedSuccessfully", NStr("en = 'All checks passed successfully'", Lang));
	Strings.Insert("Mock_Error_NeedMoreAddressParts", NStr("en = 'Error: There are more parts in the address pattern'", Lang));
	Strings.Insert("Mock_Error_DifferenceInAddressPart", NStr("en = 'Error: Difference in %1-th part of the address'", Lang));
	Strings.Insert("Mock_Error_NotFound_Header", NStr("en = 'Error: Header Not found - %1'", Lang));
	Strings.Insert("Mock_Error_Difference_Header", NStr("en = 'Error: Difference in meaning of header - %1'", Lang));
	Strings.Insert("Mock_Error_Difference_MD5", NStr("en = 'Error: Difference in meaning of MD5'", Lang));
	Strings.Insert("Mock_Info_MD5_Binary", NStr("en = 'MD5 binary'", Lang));
	Strings.Insert("Mock_Info_MD5_String", NStr("en = 'MD5 string'", Lang));
	Strings.Insert("Mock_Error_NotFound_Variable", NStr("en = 'Error: Variable Not found - %1'", Lang));
	Strings.Insert("Mock_Error_Difference_Variable", NStr("en = 'Error: Difference in meaning of variable - %1'", Lang));
	Strings.Insert("Mock_Info_RequiredValue", NStr("en = 'Required value'", Lang));
	Strings.Insert("Mock_Info_FoundValue", NStr("en = 'Found value'", Lang));
	Strings.Insert("Mock_Info_InputAddress", NStr("en = 'Input address'", Lang));
	Strings.Insert("Mock_Info_PatternAddress", NStr("en = 'Pattern address'", Lang));
	Strings.Insert("Mock_Info_StatusCodeNotMatch", NStr("en = 'Status code does not match!'", Lang));
	Strings.Insert("Mock_Info_HeaderNotMatch", NStr("en = 'Headers do not match!'", Lang));
	Strings.Insert("Mock_Info_BodyNotMatch", NStr("en = 'Body does not match!'", Lang));
	Strings.Insert("Mock_Error_NotFound_SetResult", NStr("en = 'Result value setting not found'", Lang));
	Return Strings;
EndFunction
