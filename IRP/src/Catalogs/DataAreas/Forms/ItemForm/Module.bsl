
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Object.Ref.IsEmpty() Then
		Object.AdminPassword = UserSettingsServer.GeneratePassword();
	EndIf;
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure
