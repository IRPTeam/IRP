// @strict-types


// Terminal parameters.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See TerminalParametersSettings
// 
// Returns:
//  Boolean - Возвращает параметры работы терминала
Function TerminalParameters(Hardware, Settings) Export
	
EndFunction

// Terminal parameters settings.
// 
// Returns:
//  Structure - Terminal parameters settings:
// * In - Structure:
// ** DeviceID - String - Идентификатор устройства
// * Out - Structure:
// ** PrintSlipOnTerminal - Boolean - Будет ли терминал самостоятельно печатать квитанции на своем принтере для операций.
// ** ShortSlip - Boolean - Терминал возвращает короткие слип-чеки, которые будут выводиться в теле фискального чека.
// ** CashWithdrawal - Boolean - Терминал поддерживает функцию выдачи наличных денежных средств.
// ** ElectronicCertificates - Boolean - Терминал поддерживает оплату электронными сертификатами ФЭС НСПК
Function TerminalParametersSettings() Export
	Str = New Structure;
	Str.Insert("In", New Structure);
	Str.In.Insert("DeviceID", "");
	Str.Insert("Out", New Structure);
	Str.Out.Insert("PrintSlipOnTerminal", False);
	Str.Out.Insert("ShortSlip", False);
	Str.Out.Insert("CashWithdrawal", False);
	Str.Out.Insert("ElectronicCertificates", False);
	Return Str;
EndFunction

// Pay by payment card.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PayByPaymentCardSettings
// 
// Returns:
//  Boolean - Метод осуществляет авторизацию оплаты по карте
Async Function PayByPaymentCard(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.PayByPaymentCard(
		ConnectParameters.ID,
		Settings.In.MerchantNumber,
		Settings.In.Amount,
		Settings.InOut.CardNumber,
		Settings.InOut.ReceiptNumber,
		Settings.Out.RRNCode,
		Settings.Out.AuthorizationCode,
		Settings.Out.Slip
	); // Boolean
	
	Connections = Await HardwareClient.DisconnectHardware(Hardware);
	Return Result;
EndFunction

// Pay by payment card settings.
// 
// Returns:
//  Structure - Pay by payment card settings:
// * In - Structure:
// ** DeviceID - String - Идентификатор устройства
// ** MerchantNumber - Number - Номер мерчанта, доступного для данного эквайрингового терминала.
// ** Amount - Number - Сумма операции по карте
// * InOut - Structure:
// ** CardNumber - String - Номер Карты / Данные карты / Маскированный номер карты
// ** ReceiptNumber - String - Номер чека 
// * Out - Structure:
// ** RRNCode - String - Уникальный код транзакции RRN 
// ** AuthorizationCode - String - Код авторизации транзакции
// ** Slip - String - Текст квитанции по операции сформированный эквайринговым ПО. В случае отказа по операции возвращается текст квитанции отказа.
Function PayByPaymentCardSettings() Export
	Str = New Structure;
	Str.Insert("In", New Structure);
	Str.In.Insert("DeviceID", "");
	Str.In.Insert("MerchantNumber", 0);
	Str.In.Insert("Amount", 0);
	Str.Insert("InOut", New Structure);
	Str.InOut.Insert("CardNumber", "");
	Str.InOut.Insert("ReceiptNumber", "");
	Str.Insert("Out", New Structure);
	Str.Out.Insert("RRNCode", "");
	Str.Out.Insert("AuthorizationCode", "");
	Str.Out.Insert("Slip", "");
	Return Str;
EndFunction

// Return payment by payment card.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ReturnPaymentByPaymentCardSettings
// 
// Returns:
//  Boolean - Метод осуществляет возврат платежа по карте
Function ReturnPaymentByPaymentCard(Hardware, Settings) Export
	
EndFunction

// Return payment by payment card settings.
// 
// Returns:
//  Structure - Return payment by payment card settings:
// * In - Structure:
// ** DeviceID - String - Идентификатор устройства
// ** MerchantNumber - Number - Номер мерчанта, доступного для данного эквайрингового терминала.
// ** Amount - Number - Сумма операции по карте
// * InOut - Structure:
// ** CardNumber - String - Номер Карты / Данные карты / Маскированный номер карты
// ** ReceiptNumber - String - Номер чека 
// ** RRNCode - String - Уникальный код транзакции RRN 
// * Out - Structure:
// ** AuthorizationCode - String - Код авторизации транзакции
// ** Slip - String - Текст квитанции по операции сформированный эквайринговым ПО. В случае отказа по операции возвращается текст квитанции отказа.
Function ReturnPaymentByPaymentCardSettings() Export
	Str = New Structure;
	
	Str.Insert("In", New Structure);
	Str.In.Insert("DeviceID", "");
	Str.In.Insert("MerchantNumber", Undefined);
	Str.In.Insert("Amount", Undefined);
	
	Str.Insert("InOut", New Structure);
	Str.InOut.Insert("CardNumber", Undefined);
	Str.InOut.Insert("ReceiptNumber", Undefined);
	Str.InOut.Insert("RRNCode", "");
	
	Str.Insert("Out", New Structure);
	Str.Out.Insert("AuthorizationCode", "");
	Str.Out.Insert("Slip", "");
	Return Str;
EndFunction

// Cancel payment by payment card.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CancelPaymentByPaymentCardSettings
// 
// Returns:
//  Boolean - Метод осуществляет отмену платежа по карте
Function CancelPaymentByPaymentCard(Hardware, Settings) Export
	
EndFunction

// Cancel payment by payment card settings.
// 
// Returns:
//  Structure - Pay by payment card settings:
// * In - Structure:
// ** DeviceID - String - Идентификатор устройства
// ** MerchantNumber - Number - Номер мерчанта, доступного для данного эквайрингового терминала.
// ** Amount - Number - Сумма операции по карте
// * InOut - Structure:
// ** CardNumber - String - Номер Карты / Данные карты / Маскированный номер карты
// ** ReceiptNumber - String - Номер чека 
// * Out - Structure:
// ** RRNCode - String - Уникальный код транзакции RRN 
// ** AuthorizationCode - String - Код авторизации транзакции
// ** Slip - String - Текст квитанции по операции сформированный эквайринговым ПО. В случае отказа по операции возвращается текст квитанции отказа.
Function CancelPaymentByPaymentCardSettings() Export
	Str = New Structure;
	Str.Insert("In", New Structure);
	Str.In.Insert("DeviceID", "");
	Str.In.Insert("MerchantNumber", Undefined);
	Str.In.Insert("Amount", Undefined);
	Str.Insert("InOut", New Structure);
	Str.InOut.Insert("CardNumber", Undefined);
	Str.InOut.Insert("ReceiptNumber", Undefined);
	Str.Insert("Out", New Structure);
	Str.Out.Insert("RRNCode", "");
	Str.Out.Insert("AuthorizationCode", "");
	Str.Out.Insert("Slip", "");
	Return Str;
EndFunction

// Emergency reversal.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EmergencyReversalSettings
// 
// Returns:
//  Boolean - Метод отменяет последнюю транзакцию
Function EmergencyReversal(Hardware, Settings) Export
	
EndFunction

// Emergency reversal settings.
// 
// Returns:
//  Structure - Emergency reversal settings:
// * In - Structure:
// ** DeviceID - String - Идентификатор устройства
Function EmergencyReversalSettings() Export
	Str = New Structure;
	Str.Insert("In", New Structure);
	Str.In.Insert("DeviceID", "");
	Return Str;
EndFunction

// Settlement.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See SettlementSettings
// 
// Returns:
//  Boolean - Производится сверка итогов дня
Function Settlement(Hardware, Settings) Export
	
EndFunction

// Settlement settings.
// 
// Returns:
//  Structure - Settlement settings:
// * In - Structure:
// ** DeviceID - String - Идентификатор устройства
// * Out - Structure:
// ** Slip - String - Текст квитанции, сформированный Эквайринговым ПО
Function SettlementSettings() Export
	Str = New Structure;
	Str.Insert("In", New Structure);
	Str.In.Insert("DeviceID", "");
	Str.Insert("Out", New Structure);
	Str.Out.Insert("Slip", "");
	Return Str;
EndFunction
