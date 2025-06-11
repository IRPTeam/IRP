// @strict-types

#Region Device

// GetDataKKT.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetDataKKTSettings
//
// Returns:
//  Boolean - Getting data from the KKT for the registration of the fiscal memory and subsequent work
Function GetDataKKT(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.GetDataKKT(Hardware, Settings);
EndFunction

// OperationFN.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOperationFNSettings
//
// Returns:
//  Boolean - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
Function OperationFN(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.OperationFN(Hardware, Settings);
EndFunction

// OpenShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOpenShiftSettings
//
// Returns:
//  Boolean - Opening of the shift in the KKT. After the operation, a shift opening report is printed.
Function OpenShift(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.OpenShift(Hardware, Settings);
EndFunction

// CloseShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCloseShiftSettings
//
// Returns:
//  Boolean - Closing of the shift in the KKT. After the operation, a shift closing report is printed.
Function CloseShift(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.CloseShift(Hardware, Settings);
EndFunction

// ProcessCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings
//
// Returns:
//  Boolean - Formation of a check (receipt) in the KKT. After the operation, a check (receipt) is printed.
Function ProcessCheck(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.ProcessCheck(Hardware, Settings);
EndFunction

// ProcessCorrectionCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessCorrectionCheckSettings
//
// Returns:
//  Boolean - Formation of a correction check in the KKT. After the operation, a correction check is printed.
Function ProcessCorrectionCheck(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.ProcessCorrectionCheck(Hardware, Settings);
EndFunction

// PrintTextDocument.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetPrintTextDocumentSettings
//
// Returns:
//  Boolean - Printing a text document on the KKT.
Function PrintTextDocument(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.PrintTextDocument(Hardware, Settings);
EndFunction

// CashInOutcome.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings
//
// Returns:
//  Boolean - Printing a check of income or withdrawal of cash from the cash register.
Function CashInOutcome(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.CashInOutcome(Hardware, Settings);
EndFunction

// PrintXReport.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetPrintXReportSettings
//
// Returns:
//  Boolean - Printing a report without resetting.
Function PrintXReport(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.PrintXReport(Hardware, Settings);
EndFunction

// PrintCheckCopy.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetPrintCheckCopySettings
//
// Returns:
//  Boolean - Printing a copy of the check.
Function PrintCheckCopy(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.PrintCheckCopy(Hardware, Settings);
EndFunction

// GetCurrentStatus.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCurrentStatusSettings
//
// Returns:
//  Boolean - Getting the current state of the KKT.
Function GetCurrentStatus(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.GetCurrentStatus(Hardware, Settings);
EndFunction

// ReportCurrentStatusOfSettlements.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetReportCurrentStatusOfSettlementsSettings
//
// Returns:
//  Boolean - Getting a report on the current state of settlements.
Function ReportCurrentStatusOfSettlements(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.ReportCurrentStatusOfSettlements(Hardware, Settings);
EndFunction

// OpenCashDrawer.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOpenCashDrawerSettings
//
// Returns:
//  Boolean - Opening the cash drawer.
Function OpenCashDrawer(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.OpenCashDrawer(Hardware, Settings);
EndFunction

// GetLineLength.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetLineLengthSettings
//
// Returns:
//  Boolean - Getting the line length for the KKT.
Function GetLineLength(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.GetLineLength(Hardware, Settings);
EndFunction

// OpenSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetOpenSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Opening a registration session in the control module.
Function OpenSessionRegistrationKM(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.OpenSessionRegistrationKM(Hardware, Settings);
EndFunction

// CloseSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetCloseSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Closing a registration session in the control module.
Function CloseSessionRegistrationKM(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.CloseSessionRegistrationKM(Hardware, Settings);
EndFunction

// RequestKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetRequestKMSettings
//
// Returns:
//  Boolean - Sending a request to the control module.
Function RequestKM(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.RequestKM(Hardware, Settings);
EndFunction

// GetProcessingKMResult.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings
//
// Returns:
//  Boolean - The method requests the results of the marking code check in the OISM.
Function GetProcessingKMResult(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.GetProcessingKMResult(Hardware, Settings);
EndFunction

// ConfirmKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetConfirmKMSettings
//
// Returns:
//  Boolean - Confirms or cancels the previously checked KM as part of the document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
Function ConfirmKM(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.ConfirmKM(Hardware, Settings);
EndFunction

// Is code string approved
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings
//
// Returns:
//  Boolean -  Is code string approved
Function isCodeStringApproved(Hardware, Settings) Export
	APIModule = HardwareServer.GetAPIModule(Hardware); // See HardwareServer 
	Return APIModule.isCodeStringApproved(Hardware, Settings);
EndFunction

#EndRegion
