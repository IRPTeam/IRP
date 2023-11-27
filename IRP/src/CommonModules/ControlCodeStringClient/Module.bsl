// @strict-types

// Validate code string.
// 
// Parameters:
//  ControlCodeStringType - EnumRef.ControlCodeStringType - Control code string type
//  StringCode - String - Str code
// 
// Returns:
//  Boolean - Validate code string
Function ValidateCodeString(ControlCodeStringType, StringCode) Export
	If StrLen(StringCode) < 20 Then
		Return False;
	EndIf;

	Return True;
EndFunction

// Check good code data.
// 
// Parameters:
//  StringCode - String - String code
//  Hardware - CatalogRef.Hardware - Hardware
//  isReturn - Boolean - Is return
// 
// Returns:
//  Boolean
Function CheckGoodCodeData(StringCode, Hardware, isReturn) Export
	If StringCode = "TestFalseString" Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().EqFP_ProblemWhileCheckCodeString, StringCode));
		Return False;
	EndIf;
	Return True;
EndFunction

// Check marking code.
// 
// Parameters:
//  StringCode - String - String code
//  Hardware - CatalogRef.Hardware - Hardware
//  isReturn - Boolean - Is return
// 
// Returns:
//  Promise - Check marking code
Async Function CheckMarkingCode(StringCode, Hardware, isReturn) Export
	RequestKMSettings = EquipmentFiscalPrinterAPIClient.RequestKMInput(isReturn);
	RequestKMSettings.Quantity = 1;
	RequestKMSettings.MarkingCode = StringCode;
	Result = Await EquipmentFiscalPrinterClient.CheckKM(Hardware, RequestKMSettings, True); // See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings

	If Not Result.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(Result.Info.Error);
		Return False;
	EndIf;

	If Not Result.Info.Approved Then
		//@skip-check transfer-object-between-client-server
		Log.Write("CodeStringCheck.CheckKM.Approved.False", Result, , , Hardware);
		//@skip-check invocation-parameter-type-intersect, property-return-type
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().EqFP_ProblemWhileCheckCodeString, StringCode));
		Return False;
	EndIf;
	
	Return Result.Info.Approved
EndFunction

