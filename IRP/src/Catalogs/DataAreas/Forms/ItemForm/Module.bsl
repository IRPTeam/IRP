
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Object.Ref.IsEmpty() Then
		Object.AdminPassword = UserSettingsServer.GeneratePassword();
	EndIf;
	
	FillExistsLangs();
EndProcedure

&AtServer
Procedure FillExistsLangs()
	
	For Each Lang In Metadata.Languages Do
		Items.AdminLocalization.ChoiceList.Add(Lower(Lang.LanguageCode), Lang.Synonym);
		Items.InterfaceLocalizationCode.ChoiceList.Add(Lower(Lang.LanguageCode), Lang.Synonym);
	EndDo;
	
EndProcedure