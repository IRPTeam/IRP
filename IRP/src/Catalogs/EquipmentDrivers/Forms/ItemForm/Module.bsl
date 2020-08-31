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
	ExtensionServer.AddAtributesFromExtensions(ThisObject, Object.Ref);
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

&НаКлиенте
Процедура UpdateDriverStatus()
	
	ДанныеДрайвера = Новый Структура();
	ДанныеДрайвера.Вставить("Driver"       , Object.Ref);
	ДанныеДрайвера.Вставить("AddInID"      , Object.AddInID);
	
	Оповещение = Новый ОписаниеОповещения("BeginGetDriverEnd", ЭтотОбъект);
	HardwareClient.BeginGetDriver(Оповещение, ДанныеДрайвера);
	
КонецПроцедуры




&НаКлиенте
Процедура BeginGetDriverEnd(ОбъектДрайвера, Параметры) Экспорт
	Если ПустаяСтрока(ОбъектДрайвера) Тогда
		CurrentStatus = НСтр("en='Not installed:'") + Символы.НПП + Object.AddInID;
	Иначе
	
		ОповещениеМетода = Новый ОписаниеОповещения("GetVersionEnd", ЭтотОбъект);
		ОбъектДрайвера.НачатьВызовПолучитьНомерВерсии(ОповещениеМетода);
	
		CurrentVersion = "";
		НаименованиеДрайвера      = "";
		ОписаниеДрайвера          = "";
		ТипОборудования           = "";
		ИнтеграционныйКомпонент   = Ложь;
		ОсновнойДрайверУстановлен = Ложь;
		РевизияИнтерфейса         = 3003;
		URLЗагрузкиДрайвера       = "";
		ОповещениеМетода = Новый ОписаниеОповещения("ПолучитьОписаниеЗавершение", ЭтотОбъект);
		ОбъектДрайвера.НачатьВызовПолучитьОписание(ОповещениеМетода, НаименованиеДрайвера, ОписаниеДрайвера, ТипОборудования, РевизияИнтерфейса, 
										ИнтеграционныйКомпонент, ОсновнойДрайверУстановлен, URLЗагрузкиДрайвера);
	EndIf;							
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьОписаниеЗавершение(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт;
	
	НоваяАрхитектура = Истина;
	НаименованиеДрайвера = ПараметрыВызова[0];
	ОписаниеДрайвера     = ПараметрыВызова[1];
	ТипОборудования      = ПараметрыВызова[2]; 
	РевизияИнтерфейса    = ПараметрыВызова[3];
	ИнтеграционныйКомпонент   = ПараметрыВызова[4];
	ОсновнойДрайверУстановлен = ПараметрыВызова[5];
	URLЗагрузкиДрайвера       = ПараметрыВызова[6];
	
	
КонецПроцедуры


&НаКлиенте
Процедура UpdateCurrentStatusDriver()
	
	CurrentStatus = НСтр("en='Installed on current PC.'");
	
	Если Не ПустаяСтрока(CurrentVersion) Тогда
		Элементы.CurrentStatus.Видимость = Истина;
	Иначе
		Элементы.CurrentStatus.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура GetVersionEnd(РезультатВызова, ПараметрыВызова, ДополнительныеПараметры) Экспорт;
	
	Если Не ПустаяСтрока(РезультатВызова) Тогда
		CurrentVersion = РезультатВызова;
		UpdateCurrentStatusDriver();
	КонецЕсли;
	
КонецПроцедуры


&AtClient
Procedure Install(Command)
	Если Модифицированность Тогда
		Текст = НСтр("ru='Save data and continue?'");
		Оповещение = Новый ОписаниеОповещения("УстановитьДрайверКоманда_Завершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет);
	Иначе
		УстановитьДрайвер();
	КонецЕсли

EndProcedure

&НаКлиенте
Процедура УстановитьДрайверКоманда_Завершение(Результат, Параметры) Экспорт 
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		Если Модифицированность И НЕ Записать() Тогда
			Возврат;
		КонецЕсли;
		УстановитьДрайвер();
	КонецЕсли;  
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайвер()
	
	ОчиститьСообщения(); 
	
	ОповещенияДрайверИзАрхиваПриЗавершении = Новый ОписаниеОповещения("УстановитьДрайверИзАрхиваПриЗавершении", ЭтотОбъект);
	
	HardwareClient.InstallDriver(Object.AddInID, ОповещенияДрайверИзАрхиваПриЗавершении);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДрайверИзАрхиваПриЗавершении(Результат) Экспорт 
	
	UpdateDriverStatus();
	
КонецПроцедуры

#EndRegion 

