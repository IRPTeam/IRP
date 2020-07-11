&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Not ValueIsFilled(Object.Ref) Then
		FillByDefaultAtServer();
	EndIf;
	PutSettingsToTempStorage();
	SetVisible();
EndProcedure

&AtClient
Procedure FillByDefault(Command)
	FillByDefaultAtServer();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "GoogleDriveToken" AND Source = UUID Then
		
		TestRow = Object.ConnectionSetting.FindRows(New Structure("Key", "AddressPath"));
		If TestRow.Count() Then
			Object.ConnectionSetting.Delete(TestRow[0]);
		EndIf;
		
		NewRow = Object.ConnectionSetting.Add();
		NewRow.Key = "refresh_token";
		NewRow.Value = 	Parameter.refresh_token;
		
		Modified = True;
	EndIf;
EndProcedure

&AtClient
Procedure TestConnection(Command)
	If Object.IntegrationType = PredefinedValue("Enum.IntegrationType.LocalFileStorage") Then
		TestRow = Object.ConnectionSetting.FindRows(New Structure("Key", "AddressPath"));
		IntegrationServer.SaveFileToFileStorage(TestRow[0].Value, "Test.png", PictureLib.DataHistory.GetBinaryData());	
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
	ElsIf Object.IntegrationType = PredefinedValue("Enum.IntegrationType.GoogleDrive") Then 
		CurrentActiveToken = GoogleDriveServer.CurrentActiveToken(Object.Ref);
		If ValueIsFilled(CurrentActiveToken) Then
			CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_005);
		EndIf;	
	Else
		ConnectionSetting = IntegrationServer.ConnectionSettingTemplate();
		For Each Str In Object.ConnectionSetting Do
			FillPropertyValues(ConnectionSetting, New Structure(Str.Key, Str.Value));
		EndDo;
		ConnectionSetting.QueryType = "GET";
		ResourceParameters = New Structure();
		ResourceParameters.Insert("MetadataName", "TestConnection");
		ServerResponse = IntegrationClientServer.SendRequest(ConnectionSetting, ResourceParameters);
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_016,
				ServerResponse.Message,
				ServerResponse.StatusCode,
				ServerResponse.ResponseBody));
	EndIf;
EndProcedure

&AtClient
Procedure Login(Command)
	If Object.IntegrationType = PredefinedValue("Enum.IntegrationType.GoogleDrive") Then
		GoogleDriveClient.Auth(ThisObject);
	EndIf;
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
	Items.ConnectionSettingLogin.Visible = Object.IntegrationType = Enums.IntegrationType.GoogleDrive;
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
	ThisObject.AddressResult = PutToTempStorage(FormAttributeToValue("Object").ExternalDataProcSettings.Get()
			, ThisObject.UUID);
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