// @strict-types

// Copy to clipboard.
// 
// Parameters:
//  Object - DocumentObjectDocumentName - Object
//  Form - ClientApplicationForm - Form
// 
// Returns:
//  See CopySettings
Function CopyToClipboard(Object, Form) Export

	Return CopySettings();
EndFunction

// Copy settings.
// 
// Returns:
//  Structure - Copy settings:
// * CopySelectedRows - Boolean -
Function CopySettings() Export
	
	Str = New Structure;
	Str.Insert("CopySelectedRows", True);
	
	Return Str;
EndFunction

// After copy.
// 
// Parameters:
//  CopyPastResult - See CopyPasteServer.BufferSettings
Procedure AfterCopy(CopyPastResult) Export
	If CopyPastResult.isError And IsBlankString(CopyPastResult.Message) Then
		Return;
	EndIf;
	
	If Not CopyPastResult.isError Then
		Status(R().CP_004, , CopyPastResult.Message, PictureLib.AppearanceFlagGreen);
	Else
		Status(R().CP_005, , CopyPastResult.Message, PictureLib.AppearanceFlagRed);
	EndIf;
EndProcedure
