Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	AdminFunctionsPrivileged.CreateUser(ThisObject);
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
		Else
			Result = New Structure("Success, ArrayOfResults", True, New Array());
			UsersEvent.UpdateUserRole(ThisObject.Ref, Result)
		EndIf;
	EndIf;
	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure