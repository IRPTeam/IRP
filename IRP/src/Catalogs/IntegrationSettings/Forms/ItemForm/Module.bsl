&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not ValueIsFilled(Object.Ref) Then
		FillByDefaultAtServer();
	EndIf;
	PutSettingsToTempStorage();
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	SetVisible();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure CopyFromProd(Command)
	CopyFromProdAtServer();
EndProcedure

&AtServer
Procedure CopyFromProdAtServer()
	Object.ConnectionSettingTest.Load(Object.ConnectionSetting.Unload());
EndProcedure

&AtClient
Procedure FillByDefault(Command)
	FillByDefaultAtServer();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure TestConnection(Command)
	TestConnectionCall();
EndProcedure

&AtClient
Procedure TestConnectionCall()
	If Object.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		TestRow = Object.ConnectionSetting.FindRows(New Structure("Key", "AddressPath"));
		IntegrationServer.SaveFileToFileStorage(TestRow[0].Value, "Test.png", PictureLib.DataHistory.GetBinaryData());
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	ElsIf Object.IntegrationType = PredefinedValue("Enum.IntegrationType.Email") Then
		ConnectionSetting = IntegrationServer.ConnectionSettingTemplate(Object.IntegrationType);
		For Each Str In Object.ConnectionSetting Do
			FillPropertyValues(ConnectionSetting, New Structure(Str.Key, Str.Value));
		EndDo;
#If Not WebClient Then
		eMail = New InternetMailMessage();
		eMail.Texts.Add("<h1> Test </h1>", InternetMailTextType.HTML);
		eMail.Subject = "Test";
		eMail.SenderName = ConnectionSetting.SenderName;
		eMail.To.Add(ConnectionSetting.eMailForTest);
		//@skip-warning
		Answer = IntegrationClientServer.SendEmail(ConnectionSetting, eMail);
		If Not Answer.Count() Then
			CommonFunctionsClientServer.ShowUsersMessage(CommonFunctionsServer.SerializeJSON(Answer));
		Else
			CommonFunctionsClientServer.ShowUsersMessage(R().S_028);
		EndIf;
#Else
			CommonFunctionsClientServer.ShowUsersMessage(R().S_029);
#EndIf
	ElsIf ExtensionCall_TestConnectionCall() = Undefined Then
		ConnectionSetting = IntegrationServer.ConnectionSettingTemplate();

		SettingsSource = Object.ConnectionSetting;
		If Not ServiceSystemServer.isProduction() Then
			SettingsSource = Object.ConnectionSettingTest;
		EndIf; 		  
		For Each Str In SettingsSource Do
			FillPropertyValues(ConnectionSetting, New Structure(Str.Key, Str.Value));
		EndDo;
		
		ConnectionSetting.QueryType = "GET";
		ConnectionSetting.IntegrationSettingsRef = Object.Ref;
		ConnectionSetting.Insert("Headers", New Map);
		
		ResourceParameters = New Structure();
		ResourceParameters.Insert("MetadataName", "TestConnection");
		ServerResponse = IntegrationClientServer.SendRequest(ConnectionSetting, ResourceParameters);
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_016, ServerResponse.Message,
			ServerResponse.StatusCode, ServerResponse.ResponseBody));
	EndIf;
EndProcedure

&AtClient
Function ExtensionCall_TestConnectionCall()
	Return Undefined;
EndFunction

&AtClient
Procedure Login(Command)
	ExtensionCall_Login();
EndProcedure

&AtClient
Procedure ExtensionCall_Login()
	Return;
EndProcedure

&AtServer
Procedure FillByDefaultAtServer()
	ConnectionSetting = IntegrationServer.ConnectionSettingTemplate(Object.IntegrationType);
	For Each Str In ConnectionSetting Do
		Filter = New Structure("Key", Str.Key);
		Rows = Object.ConnectionSetting.FindRows(Filter);
		If Not Rows.Count() Then
			NewRow = Object.ConnectionSetting.Add();
			NewRow.Key = Str.Key;
			NewRow.Value = Str.Value;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure ConnectionSettingBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtServer
Procedure SetVisible()
	If Object.IntegrationType = Enums.IntegrationType.CurrencyRates Then
		VisibleExternalDataProc = True;
	Else
		VisibleExternalDataProc = False;
	EndIf;
	Items.ExternalDataProc.Visible = VisibleExternalDataProc;
	Items.ExternalDataProcSettings.Visible = VisibleExternalDataProc;
EndProcedure

&AtClient
Procedure IntegrationTypeOnChange(Item)
	If Object.IntegrationType <> PredefinedValue("Enum.IntegrationType.CurrencyRates") Then
		Object.ExternalDataProc = Undefined;
	EndIf;
	SetVisible();
EndProcedure

#Region ExternalDataProc

&AtClient
Procedure ExternalDataProcOnChange(Item)
	If ValueIsFilled(Object.ExternalDataProc) Then
		ExternalDataProcOnChangeAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure ExternalDataProcOnChangeAtServer()
	Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If Not AddDataProc = Undefined Then
		ConnectionSettings = AddDataProc.ConnectionSettings();
		Object.ConnectionSetting.Clear();
		For Each KeyValue In ConnectionSettings Do
			NewRow = Object.ConnectionSetting.Add();
			NewRow.Key = KeyValue.Key;
			NewRow.Value = KeyValue.Value;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure ExternalDataProcSettings(Command)
	Info = AddDataProcServer.AddDataProcInfo(Object.ExternalDataProc);
	Info.Insert("Settings", ThisObject.AddressResult);
	CallMethodAddDataProc(Info);

	NotifyDescription = New NotifyDescription("OpenFormProcSettingsEnd", ThisObject);
	AddDataProcClient.OpenFormAddDataProc(Info, NotifyDescription, "Settings");
EndProcedure

&AtServer
Procedure PutSettingsToTempStorage()
	ThisObject.AddressResult = PutToTempStorage(FormAttributeToValue("Object").ExternalDataProcSettings.Get(),
		ThisObject.UUID);
EndProcedure

&AtServerNoContext
Procedure CallMethodAddDataProc(Info)
	AddDataProcServer.CallMethodAddDataProc(Info);
EndProcedure

&AtClient
Procedure OpenFormProcSettingsEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Modified = True;
	OpenFormProcSettingsEndServer(Result);
EndProcedure

&AtServer
Procedure OpenFormProcSettingsEndServer(Result)
	Obj = FormAttributeToValue("Object");
	Obj.ExternalDataProcSettings = New ValueStorage(Result, New Deflation(9));
	Obj.Write();
	PutToTempStorage(Result, ThisObject.AddressResult);
	ValueToFormAttribute(Obj, "Object");
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion
