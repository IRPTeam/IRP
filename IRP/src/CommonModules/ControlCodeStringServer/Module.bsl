// @strict-types

// Get marking code string.
// 
// Parameters:
//  CodeString - String - Code string
// 
// Returns:
//  String
Function GetMarkingCodeString(Val CodeString) Export
	If Not CommonFunctionsClientServer.isBase64Value(CodeString) Then
		CodeString = Base64String(GetBinaryDataFromString(CodeString, TextEncoding.UTF8, False));
	EndIf;
	Return CodeString;
EndFunction

// Get good data.
// 
// Parameters:
//  ControlCodeStringType - EnumRef.ControlCodeStringType -
//  CodeString - String - Code string
// 
// Returns:
//  Structure - Fill good data:
// * Type - String - 
// * CodeString - String -
Function GetGoodData(ControlCodeStringType, Val CodeString) Export
	Result = New Structure;
	Result.Insert("Type", "NotIdentified");
	Result.Insert("CodeString", CodeString);
	//@skip-check property-return-type
	If ControlCodeStringType = Enums.ControlCodeStringType.GoodCodeData Then
		If Not CommonFunctionsClientServer.isBase64Value(CodeString) Then
			Result.CodeString = Base64String(GetBinaryDataFromString(CodeString, TextEncoding.UTF8, False));
		EndIf;
	EndIf;
	Return Result;
EndFunction