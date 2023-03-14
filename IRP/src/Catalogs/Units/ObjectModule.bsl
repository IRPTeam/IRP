Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;

	If Not Item.IsEmpty() And BasisUnit.IsEmpty() Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_088);
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure