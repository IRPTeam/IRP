#Region FormEventHandlers

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If IsTempStorageURL(FileAddress) Then
		CurrentObject.Driver = New ValueStorage(GetFromTempStorage(FileAddress));
		CurrentObject.DriverLoaded = True;
	EndIf;
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Object.DriverLoaded Then
		UpdateDriverStatus();
	EndIf;
EndProcedure
#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure AddFile(Command)
	PutFilesDialogParameters = New PutFilesDialogParameters();
	EndCall			= New NotifyDescription("AddFileEndCall", ThisObject);
	ProgressCall    = New NotifyDescription("AddFileProgressCall", ThisObject);
	BeforeStartCall = New NotifyDescription("AddFileBeforeStartCall", ThisObject);
	BeginPutFileToServer(EndCall, ProgressCall, BeforeStartCall, , PutFilesDialogParameters, ThisObject.UUID);
EndProcedure

&AtClient
Procedure SaveFile(Command)
	If Parameters.Key.IsEmpty() Then
		QuestionToUserNotify = New NotifyDescription("SaveFileNewObjectContinue", ThisObject);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
		Return;
	EndIf;
	SaveFileContinue();
EndProcedure

&AtClient
Procedure Install(Command)
	If Modified Then
		NotifyDescription = New NotifyDescription("InstallDriver_End", ThisObject);
		ShowQueryBox(NotifyDescription, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		InstallDriver();
	EndIf;
EndProcedure

#EndRegion

#Region Internal

&AtClient
Procedure AddFileEndCall(FileDescription, AddInfo) Export
	If FileDescription = Undefined Or FileDescription.PutFileCanceled Then
		Return;
	EndIf;

	FileAddress = FileDescription.Address;
	Object.Description = FileDescription.FileRef.File.BaseName;
EndProcedure

&AtClient
Procedure AddFileProgressCall(PuttingFile, PutProgress, CancelPut, AddInfo) Export
#If Not MobileClient And Not MobileAppClient Then
	Status(PuttingFile.Name, PutProgress);
#EndIf
EndProcedure

&AtClient
Procedure AddFileBeforeStartCall(PuttingFile, CancelPut, AddInfo) Export
	Return;
EndProcedure

&AtClient
Procedure SaveFileNewObjectContinue(Result, AddInfo = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		SaveFileContinue();
	EndIf;
EndProcedure

#Region Driver

&AtClient
Async Procedure BeginGetDriverEnd(DriverObject, Params) Export
	If IsBlankString(DriverObject) Then
		CurrentStatus = R().Eq_002 + ": " + Chars.NBSp + Object.AddInID;
	Else

		Settings = New Structure();
		Settings.Insert("WriteLog", False);
		Try
			Settings = HardwareClient.Device_GetDescription_2000(Settings, DriverObject);
			If Not Object.RevisionNumber = Settings.InterfaceRevision Then
				Object.RevisionNumber = Settings.InterfaceRevision;
				ThisObject.Modified = True;
			EndIf;
			Array = New Array;
			Array.Add(Settings);
			BeginGetDriverEndAfter(True, Array, Undefined);
		Except
			InterfaceRevision = HardwareClient.Device_GetInterfaceRevision(Settings, DriverObject);
			If Not Object.RevisionNumber = InterfaceRevision Then
				Object.RevisionNumber = InterfaceRevision;
				ThisObject.Modified = True;
			EndIf;
			Notify = New NotifyDescription("BeginGetDriverEndAfter", ThisObject);
			HardwareClient.Device_GetDescription_Begin(Settings, DriverObject, Notify);
		EndTry;
	EndIf;
EndProcedure

&AtClient
Procedure BeginGetDriverEndAfter(Result, Params, AddInfo) Export
	FillDriverInfo(Params);
	CurrentStatus = R().Eq_006;
EndProcedure

&AtServer
Procedure FillDriverInfo(Val Params)
	Array = New Array;
	For Each Param In Params Do
		If TypeOf(Param) = Type("String") Then
			DriverInfoObj = CommonFunctionsServer.DeserializeXMLUseXDTOFactory(Param); // XDTODataObject
			For Each KeyRow In DriverInfoObj.Properties() Do
				Array.Add(KeyRow.Name + ": " + DriverInfoObj[KeyRow.Name]);
			EndDo;
		Else
			DriverInfoObj = Param;
			For Each KeyRow In DriverInfoObj Do
				Array.Add(KeyRow.Key + ": " + KeyRow.Value);
			EndDo;
		EndIf;
	EndDo;
	DriverInfo = StrConcat(Array, Chars.LF);
EndProcedure

&AtClient
Procedure InstallDriver_End(Result, Params) Export
	Если Result = DialogReturnCode.Yes Then
		If Modified And Not Write() Then
			Return;
		EndIf;
		InstallDriver();
	EndIf;
EndProcedure

&AtClient
Procedure InstallDriverFromZIPEnd(Result) Export
	UpdateDriverStatus();
EndProcedure

#EndRegion

#EndRegion

#Region Private

&AtClient
Procedure SaveFileContinue()
	BeginGetFileFromServer(GetURL(Object.Ref, "Driver"), Object.Description);
EndProcedure

#Region Driver

&AtClient
Procedure UpdateDriverStatus()
	DriverData = New Structure();
	DriverData.Insert("Driver", Object.Ref);
	DriverData.Insert("AddInID", Object.AddInID);

	Notify = New NotifyDescription("BeginGetDriverEnd", ThisObject);
	HardwareClient.BeginGetDriver(Notify, DriverData);
EndProcedure

&AtClient
Procedure InstallDriver()
	ClearMessages();

	If Not CheckFillingDriver() Then
		Return;
	EndIf;

	Notify = New NotifyDescription("InstallDriverFromZIPEnd", ThisObject);

	HardwareClient.InstallDriver(Object.Ref, Notify);
EndProcedure

&AtClient
Function CheckFillingDriver()
	If Not StrOccurrenceCount(Object.AddInID, ".") Then
		CommonFunctionsClientServer.ShowUsersMessage(R().EqError_003, "Object.AddInID");
		Return False;
	EndIf;
	If Not Object.DriverLoaded Then
		CommonFunctionsClientServer.ShowUsersMessage(R().EqError_004);
		Return False;
	EndIf;
	Return True;
EndFunction

#EndRegion

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
