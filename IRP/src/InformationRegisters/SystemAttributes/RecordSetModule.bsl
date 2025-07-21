
Procedure BeforeWrite(Cancel, Replacing)
	
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not (ThisObject.AdditionalProperties.Property("SystemRecord")
		And ThisObject.AdditionalProperties.SystemRecord = True) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_180);
		Cancel = True;
	EndIf;
EndProcedure
