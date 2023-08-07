// @strict-types

Procedure OpenChangePasswordForm() Export
	
	If Not UsersEvent.GetChangePasswordOnNextLogin() Then
		Return;
	EndIf;
	
	OpenForm("Catalog.Users.Form.InputPassword", 
		New Structure("Password", ""), 
		ThisObject, , , , 
		New NotifyDescription("CloseChangePasswordForm", ThisObject));
	
EndProcedure

// Close change password form.
// 
// Parameters:
//  Result - Structure:
//  * Password - String
//  AdditionalParameters - Undefined - Additional parameters
Procedure CloseChangePasswordForm(Result, AdditionalParameters) Export
	
	If Result = Undefined Then
		Exit(False);
	EndIf;

	If Not UsersEvent.DoneChangePasswordOnLogon(Result.Password) Then
		OpenChangePasswordForm();
	EndIf;
	
EndProcedure