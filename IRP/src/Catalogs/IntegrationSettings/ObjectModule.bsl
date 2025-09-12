Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	UpdateSecureStorage();
	
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

Procedure UpdateSecureStorage()
	If ThisObject.StoreInSecureStorage Then
		For Each Row In ThisObject.ConnectionSetting Do
			If Row.Hide Then
				SetPrivilegedMode(True);
				SecureDataStorage.Add(ThisObject.Ref, Row.Key, Row.Value);
				SetPrivilegedMode(False);
				Row.Value = SecureDataStorage.PlaceHolder();
			EndIf;
		EndDo;
		For Each Row In ThisObject.ConnectionSettingTest Do
			If Row.Hide Then
				SetPrivilegedMode(True);
				SecureDataStorage.Add(ThisObject.Ref, "Test_" + Row.Key, Row.Value);
				SetPrivilegedMode(False);
				Row.Value = SecureDataStorage.PlaceHolder();
			EndIf;
		EndDo;
	EndIf;
EndProcedure