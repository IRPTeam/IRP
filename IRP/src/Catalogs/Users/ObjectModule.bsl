Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	PreviousInfobaseUserID = InfobaseUserID;
	AdminFunctionsPrivileged.CreateUser(ThisObject);
	If PreviousInfobaseUserID <> InfobaseUserID Then
		AdditionalProperties.Insert("isCreated", True);
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not Cancel Then
		If Disable Then
			User = InfoBaseUsers.FindByUUID(InfobaseUserID);
			If Not User = Undefined Then
				User.Delete();
			EndIf;
		EndIf;
		If Not Disable And AdditionalProperties.Property("isCreated") Then
			Result = New Structure("Success, ArrayOfResults", True, New Array());
			UsersEvent.UpdateUserRole(ThisObject.Ref, Result);
		EndIf;
	EndIf;
	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure