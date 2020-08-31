Function GetDefaultSettings(EquipmentType) Export
	Settings = New Structure;
	If EquipmentType = PredefinedValue("Enum.EquipmentTypes.InputDevice") Then
		Settings.Insert("COMEncoding", "UTF-8");
		Settings.Insert("DataBits", 8);
		Settings.Insert("GSSymbolKey", -1);
		Settings.Insert("IgnoreKeyboardState", True);
		Settings.Insert("OutputDataType", 0);
		Settings.Insert("Port", 3);
		Settings.Insert("Prefix", -1);
		Settings.Insert("Speed", 9600);
		Settings.Insert("StopBit", 0);
		Settings.Insert("Suffix", 13);
		Settings.Insert("Timeout", 75);
		Settings.Insert("TimeoutCOM", 5);
	EndIf;
	Return Settings;
EndFunction

Procedure BeginGetDriver(NotifyOnClose, DriverInfo) Export
	ObjectName = StrSplit(DriverInfo.AddInID, ".");
	ObjectName.Add(ObjectName[1]);
	Params = New Structure("ProgID, NotifyOnClose, EquipmentDriver", StrConcat(ObjectName,  "."), NotifyOnClose, DriverInfo.Driver);
	NotifyDescription = New NotifyDescription("BeginAttachingAddIn_End", ThisObject, Params);

	LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
	BeginAttachingAddIn(NotifyDescription, LinkOnDriver, ObjectName[1]);
EndProcedure

Procedure BeginAttachingAddIn_End(Connected, AddInfo) Export
	
	DriverObject = Undefined;
	
	If Connected Then 
		DriverObject = Новый (AddInfo.ProgID);
		If DriverObject <> Undefined Then
			globalEquipments.Drivers.Insert(AddInfo.EquipmentDriver, DriverObject);
			DriverObject = globalEquipments.Drivers[AddInfo.EquipmentDriver];
		EndIf;
		ExecuteNotifyProcessing(AddInfo.NotifyOnClose, DriverObject);
		Return;
	EndIf;
	
	ExecuteNotifyProcessing(AddInfo.NotifyOnClose, Undefined);
	
EndProcedure

Procedure InstallDriver(ID, NotifyOnCloseArchive = Undefined) Export
	
	DriversData = HardwareServer.GetDriverSettings(ID);
	

	DriverRef = GetURL(DriversData.EquipmentDriver, "Driver");
	BeginInstallAddIn(NotifyOnCloseArchive, DriverRef);

EndProcedure

////////////////////////////////////////////////////////

Procedure BeginStartAdditionalComand(NotifyOnClose, Команда, ВходныеПараметры, Идентификатор, Параметры) Export
	
	// Поиск подключенного устройства.
	ПодключенноеУстройство = ПолучитьПодключенноеУстройство(globalEquipments.ConnectionSettings, Идентификатор);
	                                                       
	If ПодключенноеУстройство = Undefined Then
		ДанныеОборудования = HardwareServer.GetConnectionSettings(Идентификатор);
		ПараметрыКоманды = Новый Структура();
		ПараметрыКоманды.Insert("Команда"           , Команда);
		ПараметрыКоманды.Insert("ВходныеПараметры"  , ВходныеПараметры);
		ПараметрыКоманды.Insert("Параметры"         , Параметры);
		ПараметрыКоманды.Insert("ДанныеОборудования", ДанныеОборудования);
		ПараметрыКоманды.Insert("NotifyOnClose", NotifyOnClose);
		Оповещение = Новый ОписаниеОповещения("BeginStartAdditionalComand_Завершение", ЭтотОбъект, ПараметрыКоманды);
		BeginGetDriver(Оповещение, ДанныеОборудования);
	Else
		// Сообщить об ошибке, что устройство подключено.
		ТекстОшибки = НСтр("ru='Устройство подключено. Перед выполнением операции устройство должно быть отключено.'");
		ВыходныеПараметры = Новый Массив();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ТекстОшибки);
		ВыходныеПараметры.Добавить(НСтр("ru='Установлен'"));
		РезультатВыполнения = ПараметрыВыполненияОперацииНаОборудовании(Ложь, ТекстОшибки, Идентификатор); 
		РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
		ExecuteNotifyProcessing(NotifyOnClose, РезультатВыполнения);
	EndIf;
	
EndProcedure

Function ПараметрыВыполненияОперацииНаОборудовании(Результат = Ложь, ОписаниеОшибки = Undefined, ИдентификаторУстройства = Undefined) Export; 
	
	РезультатВыполнения = Новый Структура();
	РезультатВыполнения.Insert("Result"              , Результат);
	РезультатВыполнения.Insert("ОписаниеОшибки"         , ОписаниеОшибки);
	РезультатВыполнения.Insert("ИдентификаторУстройства", ИдентификаторУстройства);
	РезультатВыполнения.Insert("ВыходныеПараметры"      , Undefined);
	Возврат РезультатВыполнения;
	
EndFunction

Function ПолучитьПодключенноеУстройство(СписокПодключений, Идентификатор) Export
	
	ПодключенноеУстройство = Undefined;
	
	Для Каждого Подключение Из СписокПодключений Цикл
		If Подключение.Ref = Идентификатор Then
			ПодключенноеУстройство = Подключение;
			Прервать;
		EndIf;
	КонецЦикла;
	
	Возврат ПодключенноеУстройство;
	
EndFunction

Procedure BeginStartAdditionalComand_Завершение(ОбъектДрайвера, ПараметрыКоманды) Export
	
	If ОбъектДрайвера = Undefined Then
		// Сообщить об ошибке, что не удалось загрузить драйвер.
		ТекстОшибки = НСтр("ru='Не удалось загрузить драйвер устройства.
								|Проверьте, что драйвер корректно установлен и зарегистрирован в системе.'");
		ВыходныеПараметры = Новый Массив();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ТекстОшибки);
		ВыходныеПараметры.Добавить(НСтр("ru='Не установлен'"));
		РезультатВыполнения = ПараметрыВыполненияОперацииНаОборудовании(Ложь, ТекстОшибки); 
		РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
		ExecuteNotifyProcessing(ПараметрыКоманды.NotifyOnClose, РезультатВыполнения);
	Else
		
		ДанныеОборудования = ПараметрыКоманды.ДанныеОборудования; 
		ОбработчикДрайвераМодуль = ПолучитьОбработчикДрайвера(ДанныеОборудования.EquipmentType);
		
//		If ОбработчикДрайвераМодуль = Undefined Then
//			// Сообщить об ошибке, что не удалось подключить обработчик драйвера.
//			ТекстОшибки = НСтр("en='Can`t connect proccesing module'");
//			ВыходныеПараметры = Новый Массив();
//			ВыходныеПараметры.Добавить(999);
//			ВыходныеПараметры.Добавить(ТекстОшибки);
//			ВыходныеПараметры.Добавить(НСтр("en='Not installed'"));
//			РезультатВыполнения = ПараметрыВыполненияОперацииНаОборудовании(Ложь, ТекстОшибки); 
//			РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
//			ExecuteNotifyProcessing(ПараметрыКоманды.NotifyOnClose, РезультатВыполнения);
//		Else
			времПараметрыПодключения = Новый Структура();
			времПараметрыПодключения.Insert("EquipmentType", "СканерШтрихкода");
			
			ТекстОшибки = "";
			ВыходныеПараметры = Undefined;
			Результат = ОбработчикДрайвераМодуль.ВыполнитьКоманду(ПараметрыКоманды.Команда, ПараметрыКоманды.ВходныеПараметры,
				ВыходныеПараметры, ОбъектДрайвера, ПараметрыКоманды.Параметры, времПараметрыПодключения);
			If Не Результат Then
				If ВыходныеПараметры.Количество() >= 2 Then
					ТекстОшибки = ВыходныеПараметры[1];
				EndIf;
				ВыходныеПараметры.Добавить(НСтр("en='Installed'"));
			EndIf;
			РезультатВыполнения = ПараметрыВыполненияОперацииНаОборудовании(Результат); 
			РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
			ExecuteNotifyProcessing(ПараметрыКоманды.NotifyOnClose, РезультатВыполнения);

			
//		EndIf
	EndIf;
	
EndProcedure

Function ПолучитьОбработчикДрайвера(EquipmentType)
	Return HardwareInputDevice;
EndFunction

///////////////////////////////////////////////////////

Procedure BeginConnectEquipment(ОповещениеПриПодключении) Export
	   
	ОбъектДрайвера = Undefined;
	
	Устройство = HardwareServer.GetConnectionSettings(, "BarcodeScanner");
			
	// Проверим, не подключено ли устройство ранее.
	ПодключенноеУстройство = ПолучитьПодключенноеУстройство(globalEquipments.ConnectionSettings, Устройство.Hardware);
	
	If ПодключенноеУстройство = Undefined Then // If устройство не было подключено ранее.
		
		ОбработчикДрайвераМодуль = ПолучитьОбработчикДрайвера(Устройство.EquipmentType);
		

		// Синхронные
		ОбъектДрайвера = GetDriverObject(Устройство);
//		If ОбъектДрайвера = Undefined Then
//			If ОповещениеПриПодключении <> Undefined Then
//				// Сообщить об ошибке, что не удалось загрузить драйвер.
//				ОписаниеОшибки = НСтр("ru='%Наименование%: Не удалось загрузить драйвер устройства.
//									|Проверьте, что драйвер корректно установлен и зарегистрирован в системе.'");
//				ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%Наименование%", Устройство.Hardware);
//				РезультатВыполнения = ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
//				ExecuteNotifyProcessing(ОповещениеПриПодключении, РезультатВыполнения);
//			EndIf;
//			Return;
//		Else
			ВыходныеПараметры = Undefined;
			Результат = ОбработчикДрайвераМодуль.ПодключитьУстройство(ОбъектДрайвера, Устройство.ConnectParameters, ВыходныеПараметры);
			
//			If Результат Then
				
				If ВыходныеПараметры.Количество() >= 2 Then
					Устройство.Insert("ИсточникСобытия", ВыходныеПараметры[0]);
					Устройство.Insert("ИменаСобытий",    ВыходныеПараметры[1]);
				Else
					Устройство.Insert("ИсточникСобытия", "");
					Устройство.Insert("ИменаСобытий",    Undefined);
				EndIf;

				МассивПараметровПодключения = globalEquipments.ConnectionSettings; //Массив - 
				МассивПараметровПодключения.Добавить(Устройство);
				
				If ОповещениеПриПодключении <> Undefined Then
					ОписаниеОшибки = НСтр("ru='Ошибок нет.'");
					РезультатВыполнения = Новый Структура("Result, ОписаниеОшибки, ПараметрыПодключения", Истина, ОписаниеОшибки, Устройство.ConnectParameters);
					ExecuteNotifyProcessing(ОповещениеПриПодключении, РезультатВыполнения);
				EndIf;
//				
//			Else
//				// Сообщим пользователю о том, что не удалось подключить устройство.
//				If ОповещениеПриПодключении <> Undefined Then
//					ОписаниеОшибки = НСтр("ru='Не удалось подключить устройство ""%Наименование%"": %ОписаниеОшибки% (%КодОшибки%)'");
//					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%ОписаниеОшибки%", ВыходныеПараметры[1]);
//					ОписаниеОшибки = СтрЗаменить(ОписаниеОшибки, "%КодОшибки%"     , ВыходныеПараметры[0]);
//					РезультатВыполнения = ПараметрыВыполненияОперацииНаОборудовании(Ложь, ОписаниеОшибки);
//					ExecuteNotifyProcessing(ОповещениеПриПодключении, РезультатВыполнения);
//				EndIf;
//			EndIf;
//		EndIf;
	

	
	Else // Устройство было подключено ранее.
		ПодключенноеУстройство.КоличествоПодключенных = ПодключенноеУстройство.КоличествоПодключенных + 1;
		If ОповещениеПриПодключении <> Undefined Then
			ОписаниеОшибки = НСтр("ru='Ошибок нет.'");
			РезультатВыполнения = Новый Структура("Результат, ОписаниеОшибки, ПараметрыПодключения", Истина, ОписаниеОшибки, ПодключенноеУстройство.ПараметрыПодключения);
			ExecuteNotifyProcessing(ОповещениеПриПодключении, РезультатВыполнения);
		EndIf;
	EndIf;
			


EndProcedure

Function GetDriverObject(DriverInfo, ТекстОшибки = Undefined)
	
	ОбъектДрайвера = Undefined;
	
	Для Каждого ДрайверПО Из globalEquipments.Drivers Цикл
		If ДрайверПО.Ключ = DriverInfo.Driver  Then
			ОбъектДрайвера = ДрайверПО.Значение;
			Возврат ОбъектДрайвера;
		EndIf;
	КонецЦикла;
	
	If ОбъектДрайвера = Undefined Then

		ObjectName = StrSplit(DriverInfo.AddInID, ".");
		ObjectName.Add(ObjectName[1]);

		LinkOnDriver = GetURL(DriverInfo.Driver, "Driver");
		Результат = AttachAddIn(LinkOnDriver, ObjectName[1]);

		ОбъектДрайвера = New (StrConcat(ObjectName, "."));
	EndIf;

		
	If ОбъектДрайвера <> Undefined Then
		globalEquipments.Drivers.Insert(DriverInfo.Driver, ОбъектДрайвера);
		ОбъектДрайвера = globalEquipments.Drivers[DriverInfo.Driver];
	EndIf;   
		
	Возврат ОбъектДрайвера;
	
EndFunction

