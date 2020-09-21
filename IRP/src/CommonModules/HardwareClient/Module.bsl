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

Procedure BeginStartAdditionalComand(NotifyOnClose, Command, IncomingParams, ID, Parameters) Export
	
	// Поиск подключенного устройства.
	ПодключенноеУстройство = GetConnectedDevice(globalEquipments.ConnectionSettings, ID);
	                                                       
	If ПодключенноеУстройство = Undefined Then
		ДанныеОборудования = HardwareServer.GetConnectionSettings(ID);
		ПараметрыКоманды = Новый Структура();
		ПараметрыКоманды.Insert("Команда"           , Command);
		ПараметрыКоманды.Insert("ВходныеПараметры"  , IncomingParams);
		ПараметрыКоманды.Insert("Параметры"         , Parameters);
		ПараметрыКоманды.Insert("ДанныеОборудования", ДанныеОборудования);
		ПараметрыКоманды.Insert("NotifyOnClose", NotifyOnClose);
		Оповещение = Новый ОписаниеОповещения("BeginStartAdditionalComand_End", ЭтотОбъект, ПараметрыКоманды);
		BeginGetDriver(Оповещение, ДанныеОборудования);
	Else
		// Сообщить об ошибке, что устройство подключено.
		ВыходныеПараметры = Новый Массив();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(R().EqError_001);
		ВыходныеПараметры.Добавить(R().Eq_001);
		РезультатВыполнения = RunningOperationOnEquipmentParams(Ложь, R().EqError_001, ID); 
		РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
		ExecuteNotifyProcessing(NotifyOnClose, РезультатВыполнения);
	EndIf;
	
EndProcedure

Function RunningOperationOnEquipmentParams(Result = False, Error = Undefined, ID = Undefined) Export; 
	
	РезультатВыполнения = Новый Структура();
	РезультатВыполнения.Insert("Result"                 , Result);
	РезультатВыполнения.Insert("ОписаниеОшибки"         , Error);
	РезультатВыполнения.Insert("ИдентификаторУстройства", ID);
	РезультатВыполнения.Insert("ВыходныеПараметры"      , Undefined);
	Возврат РезультатВыполнения;
	
EndFunction

Function GetConnectedDevice(ConnectionsList, ID) Export
	
	ПодключенноеУстройство = Undefined;
	
	Для Каждого Подключение Из ConnectionsList Цикл
		If Подключение.Hardware = ID Then
			ПодключенноеУстройство = Подключение;
			Прервать;
		EndIf;
	КонецЦикла;
	
	Возврат ПодключенноеУстройство;
	
EndFunction

Procedure BeginStartAdditionalComand_End(DriverObject, CommandParameters) Export
	
	If DriverObject = Undefined Then
		// Сообщить об ошибке, что не удалось загрузить драйвер.
		ТекстОшибки = R().EqError_002;
		ВыходныеПараметры = Новый Массив();
		ВыходныеПараметры.Добавить(999);
		ВыходныеПараметры.Добавить(ТекстОшибки);
		ВыходныеПараметры.Добавить(R().Eq_002);
		РезультатВыполнения = RunningOperationOnEquipmentParams(Ложь, ТекстОшибки); 
		РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
		ExecuteNotifyProcessing(CommandParameters.NotifyOnClose, РезультатВыполнения);
	Else
		
		ДанныеОборудования = CommandParameters.ДанныеОборудования; 
		ОбработчикДрайвераМодуль = GetProccessingModule(ДанныеОборудования.EquipmentType);
		
		времПараметрыПодключения = Новый Структура();
		времПараметрыПодключения.Insert("EquipmentType", "СканерШтрихкода");
		
		ТекстОшибки = "";
		ВыходныеПараметры = Undefined;
		Результат = ОбработчикДрайвераМодуль.ВыполнитьКоманду(CommandParameters.Команда, CommandParameters.ВходныеПараметры,
			ВыходныеПараметры, DriverObject, CommandParameters.Параметры, времПараметрыПодключения);
		If Не Результат Then
			If ВыходныеПараметры.Количество() >= 2 Then
				ТекстОшибки = ВыходныеПараметры[1];
			EndIf;
			ВыходныеПараметры.Добавить(R().Eq_001);
		EndIf;
		РезультатВыполнения = RunningOperationOnEquipmentParams(Результат); 
		РезультатВыполнения.ВыходныеПараметры = ВыходныеПараметры;
		ExecuteNotifyProcessing(CommandParameters.NotifyOnClose, РезультатВыполнения);

	EndIf;
	
EndProcedure

Function GetProccessingModule(EquipmentType)
	Return Undefined;
EndFunction

///////////////////////////////////////////////////////

Procedure BeginConnectEquipment(ConnectionNotify) Export
	   
	ОбъектДрайвера = Undefined;
	
	Устройство = HardwareServer.GetConnectionSettings(, "BarcodeScanner");
			
	// Проверим, не подключено ли устройство ранее.
	ПодключенноеУстройство = GetConnectedDevice(globalEquipments.ConnectionSettings, Устройство.Hardware);
	
	If ПодключенноеУстройство = Undefined Then // If устройство не было подключено ранее.
		
		ОбработчикДрайвераМодуль = GetProccessingModule(Устройство.EquipmentType);
		

		// Синхронные
		ОбъектДрайвера = GetDriverObject(Устройство);
		ВыходныеПараметры = Undefined;
		Результат = ОбработчикДрайвераМодуль.ПодключитьУстройство(ОбъектДрайвера, Устройство.ConnectParameters, ВыходныеПараметры);

			
		If ВыходныеПараметры.Количество() >= 2 Then
			Устройство.Insert("ИсточникСобытия", ВыходныеПараметры[0]);
			Устройство.Insert("ИменаСобытий",    ВыходныеПараметры[1]);
		Else
			Устройство.Insert("ИсточникСобытия", "");
			Устройство.Insert("ИменаСобытий",    Undefined);
		EndIf;

		МассивПараметровПодключения = globalEquipments.ConnectionSettings; //Массив - 
		МассивПараметровПодключения.Добавить(Устройство);
		
		If ConnectionNotify <> Undefined Then
			ОписаниеОшибки = R().Eq_003;
			РезультатВыполнения = Новый Структура("Result, ОписаниеОшибки, ПараметрыПодключения", Истина, ОписаниеОшибки, Устройство.ConnectParameters);
			ExecuteNotifyProcessing(ConnectionNotify, РезультатВыполнения);
		EndIf;


	
	Else // Устройство было подключено ранее.
		If ConnectionNotify <> Undefined Then
			ОписаниеОшибки = R().Eq_003;
			РезультатВыполнения = Новый Структура("Result, ОписаниеОшибки, ПараметрыПодключения", Истина, ОписаниеОшибки, ПодключенноеУстройство.ConnectParameters);
			ExecuteNotifyProcessing(ConnectionNotify, РезультатВыполнения);
		EndIf;
	EndIf;
			


EndProcedure

Function GetDriverObject(DriverInfo, ErrorText = Undefined)
	
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
		Result = AttachAddIn(LinkOnDriver, ObjectName[1]);

		ОбъектДрайвера = New (StrConcat(ObjectName, "."));
	EndIf;

		
	If ОбъектДрайвера <> Undefined Then
		globalEquipments.Drivers.Insert(DriverInfo.Driver, ОбъектДрайвера);
		ОбъектДрайвера = globalEquipments.Drivers[DriverInfo.Driver];
	EndIf;   
		
	Возврат ОбъектДрайвера;
	
EndFunction

