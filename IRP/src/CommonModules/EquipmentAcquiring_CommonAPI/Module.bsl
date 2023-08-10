// @strict-types

#Region Device

// Terminal parameters.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentAcquiringAPIClient.TerminalParametersSettings
// 
// Returns:
//  Boolean - Resturn result
Function TerminalParameters(Hardware, Settings) Export
	Return False;
EndFunction

// Pay by payment card.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentAcquiringAPIClient.PayByPaymentCardSettings
// 
// Returns:
//  Boolean
Async Function PayByPaymentCard(Hardware, Settings) Export
	Result = False;
	LockData = Settings.Form;
	Settings.Delete("Form");
	EquipmentAcquiringAPIClient.LockForm(LockData, True);
	Try
		Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
		ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
		If ConnectParameters.WriteLog Then
			HardwareServer.WriteLog(Hardware, "PayByPaymentCard", True, Settings);
		EndIf;
		If Connections.ConnectParameters.OldRevision Then
			// @skip-check dynamic-access-method-not-found
			Result = ConnectParameters.DriverObject.PayByPaymentCard(
				ConnectParameters.ID,
				Settings.InOut.CardNumber,
				Settings.In.Amount,
				Settings.InOut.ReceiptNumber,
				Settings.Out.RRNCode,
				Settings.Out.AuthorizationCode,
				Settings.Out.Slip
			); // Boolean
		Else
			// @skip-check dynamic-access-method-not-found
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
		EndIf;
		If Not Result Then
			Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		EndIf;
		If ConnectParameters.WriteLog Then
			HardwareServer.WriteLog(Hardware, "PayByPaymentCard", False, Settings, Result);
		EndIf;		
		Connections = Await HardwareClient.DisconnectHardware(Hardware);
		
	Except
		Error = ErrorInfo();
		CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.DetailErrorDescription(Error));
	EndTry;
	EquipmentAcquiringAPIClient.LockForm(LockData, False);
	
	Return Result;
EndFunction

// Return payment by payment card.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentAcquiringAPIClient.ReturnPaymentByPaymentCardSettings
// 
// Returns:
//  Boolean
Async Function ReturnPaymentByPaymentCard(Hardware, Settings) Export
	Result = False;
	LockData = Settings.Form;
	Settings.Delete("Form");
	EquipmentAcquiringAPIClient.LockForm(LockData, True);
	Try
		Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
		ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
		If ConnectParameters.WriteLog Then
			HardwareServer.WriteLog(Hardware, "ReturnPaymentByPaymentCard", True, Settings);
		EndIf;
		If Connections.ConnectParameters.OldRevision Then
			//@skip-check dynamic-access-method-not-found
			Result = ConnectParameters.DriverObject.ReturnPaymentByPaymentCard(
				ConnectParameters.ID,
				Settings.InOut.CardNumber,
				Settings.In.Amount,
				Settings.InOut.ReceiptNumber,
				Settings.InOut.RRNCode,
				Settings.In.AuthorizationCode,
				Settings.Out.Slip
			); // Boolean
		Else
			//@skip-check dynamic-access-method-not-found
			Result = ConnectParameters.DriverObject.ReturnPaymentByPaymentCard(
				ConnectParameters.ID,
				Settings.In.MerchantNumber,
				Settings.In.Amount,
				Settings.InOut.CardNumber,
				Settings.InOut.ReceiptNumber,
				Settings.InOut.RRNCode,
				Settings.In.AuthorizationCode,
				Settings.Out.Slip
			); // Boolean
		EndIf;
		If Not Result Then
			Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		EndIf;
		If ConnectParameters.WriteLog Then
			HardwareServer.WriteLog(Hardware, "ReturnPaymentByPaymentCard", False, Settings, Result);
		EndIf;
		Connections = Await HardwareClient.DisconnectHardware(Hardware);
	Except
		Error = ErrorInfo();
		CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.DetailErrorDescription(Error));
	EndTry;
	
	EquipmentAcquiringAPIClient.LockForm(LockData, False);
	Return Result;
EndFunction

// Cancel payment by payment card.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentAcquiringAPIClient.CancelPaymentByPaymentCardSettings
// 
// Returns:
//  Boolean
Async Function CancelPaymentByPaymentCard(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CancelPaymentByPaymentCard", True, Settings);
	EndIf;
	If Connections.ConnectParameters.OldRevision Then
		//@skip-check dynamic-access-method-not-found
		Result = ConnectParameters.DriverObject.CancelPaymentByPaymentCard(
			ConnectParameters.ID,
			Settings.InOut.CardNumber,
			Settings.In.Amount,
			Settings.InOut.ReceiptNumber,
			Settings.In.RRNCode,
			Settings.In.AuthorizationCode,
			Settings.Out.Slip
		); // Boolean
	Else
		//@skip-check dynamic-access-method-not-found
		Result = ConnectParameters.DriverObject.CancelPaymentByPaymentCard(
			ConnectParameters.ID,
			Settings.In.MerchantNumber,
			Settings.In.Amount,
			Settings.InOut.CardNumber,
			Settings.InOut.ReceiptNumber,
			Settings.In.RRNCode,
			Settings.In.AuthorizationCode,
			Settings.Out.Slip
		); // Boolean
	EndIf;
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CancelPaymentByPaymentCard", False, Settings, Result);
	EndIf;
	Connections = Await HardwareClient.DisconnectHardware(Hardware);
	Return Result;
EndFunction

// Emergency reversal.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentAcquiringAPIClient.EmergencyReversalSettings
// 
// Returns:
//  Boolean
Async Function EmergencyReversal(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "EmergencyReversal", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.EmergencyReversal(
		ConnectParameters.ID,
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "EmergencyReversal", False, Settings, Result);
	EndIf;	
	Connections = Await HardwareClient.DisconnectHardware(Hardware);
	Return Result;
EndFunction

// Settlement.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentAcquiringAPIClient.SettlementSettings
// 
// Returns:
//  Boolean
Async Function Settlement(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "Settlement", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.Settlement(
		ConnectParameters.ID,
		Settings.Out.Slip
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "Settlement", False, Settings, Result);
	EndIf;		
	Connections = Await HardwareClient.DisconnectHardware(Hardware);
	Return Result;
EndFunction

#EndRegion
