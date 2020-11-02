#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	If IsTempStorageURL(FileAddress) Then
		CurrentObject.Driver = New ValueStorage(GetFromTempStorage(FileAddress));
		CurrentObject.DriverLoaded = True;
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If Object.DriverLoaded Then
		UpdateDriverStatus();
	EndIf;
EndProcedure
#EndRegion

#Region CommandInterface

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

#EndRegion

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
	#If Not MobileClient AND Not MobileAppClient Then
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

&AtClient
Procedure SaveFileContinue()
	BeginGetFileFromServer(GetURL(Object.Ref, "Driver"), Object.Description);
EndProcedure

#Region Driver

&AtClient
Procedure UpdateDriverStatus()
	
	ДанныеДрайвера = Новый Структура();
	ДанныеДрайвера.Вставить("Driver"       , Object.Ref);
	ДанныеДрайвера.Вставить("AddInID"      , Object.AddInID);
	
	Оповещение = Новый ОписаниеОповещения("BeginGetDriverEnd", ЭтотОбъект);
	HardwareClient.BeginGetDriver(Оповещение, ДанныеДрайвера);
	
EndProcedure

&AtClient
Procedure BeginGetDriverEnd(DriverObject, Params) Export
	Если ПустаяСтрока(DriverObject) Тогда
		CurrentStatus =R().Eq_002 + ": " + Символы.НПП + Object.AddInID;
	Else
	
		ОповещениеМетода = Новый ОписаниеОповещения("GetVersionEnd", ЭтотОбъект);
		DriverObject.НачатьВызовПолучитьНомерВерсии(ОповещениеМетода);
	
		CurrentVersion = "";
		НаименованиеДрайвера      = "";
		ОписаниеДрайвера          = "";
		ТипОборудования           = "";
		ИнтеграционныйКомпонент   = Ложь;
		ОсновнойДрайверУстановлен = Ложь;
		РевизияИнтерфейса         = 3003;
		URLЗагрузкиДрайвера       = "";
		ОповещениеМетода = Новый ОписаниеОповещения("BeginGetDriverEndAfter", ЭтотОбъект);
		DriverObject.НачатьВызовПолучитьОписание(ОповещениеМетода, НаименованиеДрайвера, ОписаниеДрайвера, ТипОборудования, РевизияИнтерфейса, 
										ИнтеграционныйКомпонент, ОсновнойДрайверУстановлен, URLЗагрузкиДрайвера);
	EndIf;							
EndProcedure

&AtClient
Procedure BeginGetDriverEndAfter(Result, Params, AddInfo) Export;
	Return;
EndProcedure

&AtClient
Procedure UpdateCurrentStatusDriver()
	
	CurrentStatus = НСтр("en='Installed on current PC.'");
	
	Если Не ПустаяСтрока(CurrentVersion) Тогда
		Элементы.CurrentStatus.Видимость = Истина;
	Else
		Элементы.CurrentStatus.Видимость = Ложь;
	КонецЕсли;
	
EndProcedure

&AtClient
Procedure GetVersionEnd(Result, Params, AddInfo) Export;
	
	Если Не ПустаяСтрока(Result) Тогда
		CurrentVersion = Result;
		UpdateCurrentStatusDriver();
	КонецЕсли;
	
EndProcedure

&AtClient
Procedure Install(Command)
	Если Модифицированность Тогда
		Оповещение = Новый ОписаниеОповещения("InstallDriver_End", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, R().QuestionToUser_001, РежимДиалогаВопрос.ДаНет);
	Else
		InstallDriver();
	КонецЕсли

EndProcedure

&AtClient
Procedure InstallDriver_End(Result, Params) Export 
	
	Если Result = КодВозвратаДиалога.Да Тогда
		Если Модифицированность И НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
		InstallDriver();
	КонецЕсли;  
	
EndProcedure

&AtClient
Procedure InstallDriver()
	
	ОчиститьСообщения(); 
	
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("InstallDriverFromZIPEnd", ЭтотОбъект);
	
	HardwareClient.InstallDriver(Object.AddInID, ОповещенияДрайверИзАрхиваПриЗавершении);
	
EndProcedure

&AtClient
Procedure InstallDriverFromZIPEnd(Result) Export 
	
	UpdateDriverStatus();
	
EndProcedure

#EndRegion 

