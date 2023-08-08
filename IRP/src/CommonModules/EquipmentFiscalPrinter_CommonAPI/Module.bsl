// @strict-types

#Region Device

// GetDataKKT.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.GetDataKKTSettings 
// 
// Returns:
//  Boolean - Getting data from the KKT for the registration of the fiscal memory and subsequent work
Async Function GetDataKKT(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetDataKKT", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetDataKKT(
		ConnectParameters.ID,
		Settings.Out.TableParametersKKT
	); // Boolean
	
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetDataKKT", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// OperationFN.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.OperationFNSettings 
// 
// Returns:
//  Boolean - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
Async Function OperationFN(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OperationFN", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.OperationFN(
		ConnectParameters.ID,
		Settings.In.OperationType,
		Settings.In.ParametersFiscal
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OperationFN", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// OpenShift.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.OpenShiftSettings 
// 
// Returns:
//  Boolean - Opening of the shift in the KKT. After the operation, a shift opening report is printed.
Async Function OpenShift(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OpenShift", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.OpenShift(
		ConnectParameters.ID,
		Settings.In.InputParameters,
		Settings.Out.OutputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OpenShift", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// CloseShift.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.CloseShiftSettings 
// 
// Returns:
//  Boolean - Closing of the shift in the KKT. After the operation, a shift closing report is printed.
Async Function CloseShift(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CloseShift", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.CloseShift(
		ConnectParameters.ID,
		Settings.In.InputParameters,
		Settings.Out.OutputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CloseShift", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// ProcessCheck.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings 
// 
// Returns:
//  Boolean - Formation of a check (receipt) in the KKT. After the operation, a check (receipt) is printed.
Async Function ProcessCheck(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ProcessCheck", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ProcessCheck(
		ConnectParameters.ID,
		Settings.In.Electronically,
		Settings.In.CheckPackage,
		Settings.Out.DocumentOutputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ProcessCheck", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// ProcessCorrectionCheck.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.ProcessCorrectionCheckSettings 
// 
// Returns:
//  Boolean - Formation of a correction check in the KKT. After the operation, a correction check is printed.
Async Function ProcessCorrectionCheck(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ProcessCorrectionCheck", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ProcessCorrectionCheck(
		ConnectParameters.ID,
		Settings.In.CheckPackage,
		Settings.Out.DocumentOutputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ProcessCorrectionCheck", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// PrintTextDocument.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings 
// 
// Returns:
//  Boolean - Printing a text document on the KKT.
Async Function PrintTextDocument(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "PrintTextDocument", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.PrintTextDocument(
		ConnectParameters.ID,
		Settings.In.DocumentPackage
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "PrintTextDocument", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// CashInOutcome.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings 
// 
// Returns:
//  Boolean - Printing a check of income or withdrawal of cash from the cash register.
Async Function CashInOutcome(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CashInOutcome", True, Settings);
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.CashInOutcome(
		ConnectParameters.ID,
		Settings.In.InputParameters,
		Settings.In.Amount
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CashInOutcome", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// PrintXReport.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.PrintXReportSettings 
// 
// Returns:
//  Boolean - Printing a report without resetting.
Async Function PrintXReport(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "PrintXReport", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.PrintXReport(
		ConnectParameters.ID,
		Settings.In.InputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "PrintXReport", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// PrintCheckCopy.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.PrintCheckCopySettings 
// 
// Returns:
//  Boolean - Printing a copy of the check.
Async Function PrintCheckCopy(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "PrintCheckCopy", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.PrintCheckCopy(
		ConnectParameters.ID,
		Settings.In.CheckNumber
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "PrintCheckCopy", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// GetCurrentStatus.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings 
// 
// Returns:
//  Boolean - Getting the current state of the KKT.
Async Function GetCurrentStatus(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetCurrentStatus", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetCurrentStatus(
		ConnectParameters.ID,
		Settings.In.InputParameters,
		Settings.Out.OutputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetCurrentStatus", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// ReportCurrentStatusOfSettlements.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.ReportCurrentStatusOfSettlementsSettings 
// 
// Returns:
//  Boolean - Getting a report on the current state of settlements.
Async Function ReportCurrentStatusOfSettlements(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ReportCurrentStatusOfSettlements", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ReportCurrentStatusOfSettlements(
		ConnectParameters.ID,
		Settings.In.InputParameters,
		Settings.Out.OutputParameters
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ReportCurrentStatusOfSettlements", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// OpenCashDrawer.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.OpenCashDrawerSettings 
// 
// Returns:
//  Boolean - Opening the cash drawer.
Async Function OpenCashDrawer(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OpenCashDrawer", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.OpenCashDrawer(
		ConnectParameters.ID
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OpenCashDrawer", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// GetLineLength.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.GetLineLengthSettings 
// 
// Returns:
//  Boolean - Getting the line length for the KKT.
Async Function GetLineLength(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetLineLength", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetLineLength(
		ConnectParameters.ID,
		Settings.Out.LineLength
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetLineLength", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// OpenSessionRegistrationKM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKMSettings 
// 
// Returns:
//  Boolean - Opening a registration session in the control module.
Async Function OpenSessionRegistrationKM(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OpenSessionRegistrationKM", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.OpenSessionRegistrationKM(
		ConnectParameters.ID
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "OpenSessionRegistrationKM", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// CloseSessionRegistrationKM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKMSettings 
// 
// Returns:
//  Boolean - Closing a registration session in the control module.
Async Function CloseSessionRegistrationKM(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CloseSessionRegistrationKM", True, Settings);
	EndIf;
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.CloseSessionRegistrationKM(
		ConnectParameters.ID
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "CloseSessionRegistrationKM", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// RequestKM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.RequestKMSettings 
// 
// Returns:
//  Boolean - Sending a request to the control module.
Async Function RequestKM(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "RequestKM", True, Settings);
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.RequestKM(
		ConnectParameters.ID,
		Settings.In.RequestKM,
		Settings.Out.RequestKMResult
	); // Boolean
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "RequestKM", False, Settings, Result);
	EndIf;		
	
	Return Result;
EndFunction

// GetProcessingKMResult.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings 
// 
// Returns:
//  Boolean - The method requests the results of the marking code check in the OISM.
Async Function GetProcessingKMResult(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetProcessingKMResult", True, Settings);
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetProcessingKMResult(
		ConnectParameters.ID,
		Settings.Out.ProcessingKMResult,
		Settings.Out.RequestStatus
	); // Boolean
	
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "GetProcessingKMResult", False, Settings, Result);
	EndIf;	
		
	Return Result;
EndFunction

// ConfirmKM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClient.ConfirmKMSettings 
// 
// Returns:
//  Boolean - Confirms or cancels the previously checked KM as part of the document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
Async Function ConfirmKM(Hardware, Settings) Export
	Connections = Await HardwareClient.ConnectHardware(Hardware); // See HardwareClient.ConnectHardware
	ConnectParameters = Connections.ConnectParameters; // See HardwareClient.GetDriverObject

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ConfirmKM", True, Settings);
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ConfirmKM(
		ConnectParameters.ID,
		Settings.In.GUID,
		Settings.In.ConfirmationType
	); // Boolean
	
	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;
	
	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ConfirmKM", False, Settings, Result);
	EndIf;	

	Return Result;
EndFunction


#EndRegion
