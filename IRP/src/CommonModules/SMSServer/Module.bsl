// @strict-types

// SMS.
// @skip-check dynamic-access-method-not-found
// 
// Parameters:
//  DataStructure - Structure - Data structure
//  Method - String -
//  IntegarationSettings - CatalogRef.IntegrationSettings - Integaration settings
// 
// Returns:
//  Structure
Function SMS(DataStructure, Method, IntegarationSettings = Undefined) Export
	
#Region CheckData
	If Not ValueIsFilled(IntegarationSettings) Then
		IntegarationSettings = Constants.DefaultSMSProvider.Get();
		If IntegarationSettings.IsEmpty() Then
			Raise "Fill constant default SMS provider";
		EndIf;
	EndIf;
	
	Module = GetModule(IntegarationSettings);
	
	If Module = Undefined Then
		Raise "Can not find SMS module"
	EndIf;
#EndRegion
	
	ConnectionSettings = GetConnectionSettings(IntegarationSettings);
	
	If Method = "SendSMS" Then
		Return Module.SendSMS(ConnectionSettings, DataStructure);
	ElsIf Method = "TestConnection" Then
		Return Module.TestConnection(ConnectionSettings, DataStructure);
	Else
		Raise "Not supported method: " + Method;
	EndIf;
	
EndFunction

// Get connection settings.
// 
// Parameters:
//  IntegarationSettings - CatalogRef.IntegrationSettings - Integaration settings
// 
// Returns:
//  Structure, Undefined - Get connection settings:
// * IntegrationSettingsRef - CatalogRef.IntegrationSettings -
// * QueryType - String -
// * ResourceAddress - String -
// * Ip - String -
// * Port - Number -
// * User - String -
// * Password - String -
// * Proxy - Undefined -
// * TimeOut - Number -
// * SecureConnection - Undefined -
// * UseOSAuthentication - Boolean -
// * Headers - Map -
// * AddData - Structure -
// * ApiKey - String -
// * SenderName - String -
// * PhoneNumberForTest - String -
Function GetConnectionSettings(IntegarationSettings) Export
	//@skip-check constructor-function-return-section
	Return IntegrationClientServer.ConnectionSetting(IntegarationSettings).Value;
EndFunction

Function GetModule(IntegarationSettings)
	Return Undefined;
EndFunction

// Test connection params.
// 
// Returns:
//  Structure - Test connection params:
// * Result - See SMSServer.TestConnectionResult
Function TestConnectionParams() Export
	Str = New Structure;
	Str.Insert("Result", TestConnectionResult());
	Return Str;	
EndFunction

// Test connection result.
// 
// Returns:
//  Structure - Test connection result:
// * Success - Boolean -
// * Msg - String -
Function TestConnectionResult() Export
	Str = New Structure;
	Str.Insert("Success", False);
	Str.Insert("Msg", "");
	Return Str;
EndFunction

// Send SMSParams.
// 
// Returns:
//  Structure - Send SMSParams:
// * PhoneList - Array of String -
// * Text - String -
// * PredefinedText - String - Can be: TextOnApproveAction, TextOnRegistration
// * Result - See SMSServer.SendSMSResult
Function SendSMSParams() Export
	Str = New Structure;
	Str.Insert("PhoneList", New Array);
	Str.Insert("Text", "");
	Str.Insert("PredefinedText", "");
	Str.Insert("Result", SendSMSResult());
	Return Str;	
EndFunction

// Send SMSResult.
// 
// Returns:
//  Structure - Send SMSResult:
// * Success - Boolean -
// * Msg - String -
Function SendSMSResult() Export
	Str = New Structure;
	Str.Insert("Success", False);
	Str.Insert("Msg", "");
	Return Str;
EndFunction