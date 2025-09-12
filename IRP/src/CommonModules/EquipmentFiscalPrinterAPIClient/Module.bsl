// @strict-types

#Region API

// GetDataKKT - Getting data from the KKT for the registration of the fiscal memory and subsequent work
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetDataKKTSettings
Function GetDataKKTSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetDataKKTSettings();
EndFunction

// OperationFN - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetOperationFNSettings
Function OperationFNSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetOperationFNSettings();
EndFunction

// OpenShift - Opens a new shift and prints a report on the KKT about the opening of the shift.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetOpenShiftSettings
Function OpenShiftSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetOpenShiftSettings();
EndFunction

// CloseShift - Closes the previously opened shift and prints a report on the KKT about the closing of the shift.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetCloseShiftSettings
Function CloseShiftSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetCloseShiftSettings();
EndFunction

// ProcessCheck - Formation of a check in batch mode. A structure is passed that describes the type of check being opened, fiscal and text lines, barcodes that will be printed. Also, payment amounts are passed to close the check.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings
Function ProcessCheckSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings();
EndFunction

// ProcessCorrectionCheck - Formation of a correction check in batch mode. A structure is passed that describes the type of check being opened and the attributes of the check.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetProcessCorrectionCheckSettings
Function ProcessCorrectionCheckSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetProcessCorrectionCheckSettings();
EndFunction

// PrintTextDocument - Printing a text document (text slip-check, information receipt)
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetPrintTextDocumentSettings
Function PrintTextDocumentSettings() Export
	Return EquipmentFiscalPrinterAPIClientServer.GetPrintTextDocumentSettings();
EndFunction

// CashInOutcome - Prints a cash deposit / withdrawal check (depends on the amount passed). Amount >= 0 - deposit, Amount < 0 - withdrawal.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings
Function CashInOutcomeSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings();
EndFunction

// PrintXReport - Prints a shift report without closing the cash shift.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetPrintXReportSettings
Function PrintXReportSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetPrintXReportSettings();
EndFunction

// PrintCheckCopy - Prints a printed duplicate of a previously fiscalized check.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetPrintCheckCopySettings
Function PrintCheckCopySettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetPrintCheckCopySettings();
EndFunction

// GetCurrentStatus - Getting the current status of the KKT.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetCurrentStatusSettings
Function GetCurrentStatusSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetCurrentStatusSettings();
EndFunction

// ReportCurrentStatusOfSettlements - Forms a report on the current state of settlements.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetReportCurrentStatusOfSettlementsSettings
Function ReportCurrentStatusOfSettlementsSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetReportCurrentStatusOfSettlementsSettings();
EndFunction

// OpenCashDrawer - Opens the cash drawer connected to the fiscal registrar.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetOpenCashDrawerSettings
Function OpenCashDrawerSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetOpenCashDrawerSettings();
EndFunction

// GetLineLength - Gets the width of the check line in characters.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetLineLengthSettings
Function GetLineLengthSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetLineLengthSettings();
EndFunction

// OpenSessionRegistrationKM - Opens a registration session for the control module.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetOpenSessionRegistrationKMSettings
Function OpenSessionRegistrationKMSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetOpenSessionRegistrationKMSettings();
EndFunction

// CloseSessionRegistrationKM - Closes the registration session for the control module.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetCloseSessionRegistrationKMSettings
Function CloseSessionRegistrationKMSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetCloseSessionRegistrationKMSettings();
EndFunction

// RequestKM - Sends a request to the control module.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetRequestKMSettings
Function RequestKMSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetRequestKMSettings();
EndFunction

// GetProcessingKMResult - Gets the results of processing the control module.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings
Function GetProcessingKMResultSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings();
EndFunction

// ConfirmKM - Confirms or cancels the previously checked KM as part of a document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetConfirmKMSettings
Function ConfirmKMSettings() Export
    Return EquipmentFiscalPrinterAPIClientServer.GetConfirmKMSettings();
EndFunction

#EndRegion

#Region Additional

// Processing KM Result.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.ProcessingKMResult
Function ProcessingKMResult() Export
    Return EquipmentFiscalPrinterAPIClientServer.ProcessingKMResult();
EndFunction

// Request KM.
//
// Parameters:
//  isReturn - Boolean - Is return
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.RequestKMInput
Function RequestKMInput(isReturn = False) Export
    Return EquipmentFiscalPrinterAPIClientServer.RequestKMInput(isReturn);
EndFunction

// Request KM Result.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.RequestKMResult
Function RequestKMResult() Export
    Return EquipmentFiscalPrinterAPIClientServer.RequestKMResult();
EndFunction

// Table parameters KKT. Registration data of the fiscal memory module.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.TableParametersKKT
Function TableParametersKKT() Export
	Return EquipmentFiscalPrinterAPIClientServer.TableParametersKKT();
EndFunction

// Input parameters.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.InputParameters
Function InputParameters() Export
	Return EquipmentFiscalPrinterAPIClientServer.InputParameters();
EndFunction

// Check package.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.CheckPackage
Function CheckPackage() Export
    Return EquipmentFiscalPrinterAPIClientServer.CheckPackage();
EndFunction

// Check package - Fiscal string.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.CheckPackage_FiscalString
Function CheckPackage_FiscalString() Export
    Return EquipmentFiscalPrinterAPIClientServer.CheckPackage_FiscalString();
EndFunction

// Builds a structure based on the provided shift information table.
//	CountersOperationType1 - Income
//	CountersOperationType2 - Return income
//	CountersOperationType3 - Outcome
//	CountersOperationType4 - Return outcome
//	
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.OutputParameters
Function OutputParameters() Export
    Return EquipmentFiscalPrinterAPIClientServer.OutputParameters();
EndFunction

// Operation сounters.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.OperationCounters
Function OperationCounters() Export
    Return EquipmentFiscalPrinterAPIClientServer.OperationCounters();
EndFunction

// Document package.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.DocumentPackage
Function DocumentPackage() Export
    Return EquipmentFiscalPrinterAPIClientServer.DocumentPackage();
EndFunction

// Document Output Parameters constructor.
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.DocumentOutputParameters
Function DocumentOutputParameters() Export
    Return EquipmentFiscalPrinterAPIClientServer.DocumentOutputParameters();
EndFunction

#EndRegion

#Region Device

// GetDataKKT.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetDataKKTSettings
//
// Returns:
//  Boolean - Getting data from the KKT for the registration of the fiscal memory and subsequent work
Async Function GetDataKKT(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetDataKKT(Hardware, Settings);
EndFunction

// OperationFN.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OperationFNSettings
//
// Returns:
//  Boolean - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
Async Function OperationFN(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OperationFN(Hardware, Settings);
EndFunction

// OpenShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OpenShiftSettings
//
// Returns:
//  Boolean - Opening of the shift in the KKT. After the operation, a shift opening report is printed.
Async Function OpenShift(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OpenShift(Hardware, Settings);
EndFunction

// CloseShift.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CloseShiftSettings
//
// Returns:
//  Boolean - Closing of the shift in the KKT. After the operation, a shift closing report is printed.
Async Function CloseShift(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.CloseShift(Hardware, Settings);
EndFunction

// ProcessCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ProcessCheckSettings
//
// Returns:
//  Boolean - Formation of a check (receipt) in the KKT. After the operation, a check (receipt) is printed.
Async Function ProcessCheck(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ProcessCheck(Hardware, Settings);
EndFunction

// ProcessCorrectionCheck.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ProcessCorrectionCheckSettings
//
// Returns:
//  Boolean - Formation of a correction check in the KKT. After the operation, a correction check is printed.
Async Function ProcessCorrectionCheck(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ProcessCorrectionCheck(Hardware, Settings);
EndFunction

// PrintTextDocument.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PrintTextDocumentSettings
//
// Returns:
//  Boolean - Printing a text document on the KKT.
Async Function PrintTextDocument(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.PrintTextDocument(Hardware, Settings);
EndFunction

// CashInOutcome.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CashInOutcomeSettings
//
// Returns:
//  Boolean - Printing a check of income or withdrawal of cash from the cash register.
Async Function CashInOutcome(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.CashInOutcome(Hardware, Settings);
EndFunction

// PrintXReport.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PrintXReportSettings
//
// Returns:
//  Boolean - Printing a report without resetting.
Async Function PrintXReport(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.PrintXReport(Hardware, Settings);
EndFunction

// PrintCheckCopy.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See PrintCheckCopySettings
//
// Returns:
//  Boolean - Printing a copy of the check.
Async Function PrintCheckCopy(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.PrintCheckCopy(Hardware, Settings);
EndFunction

// GetCurrentStatus.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetCurrentStatusSettings
//
// Returns:
//  Boolean - Getting the current state of the KKT.
Async Function GetCurrentStatus(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetCurrentStatus(Hardware, Settings);
EndFunction

// ReportCurrentStatusOfSettlements.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ReportCurrentStatusOfSettlementsSettings
//
// Returns:
//  Boolean - Getting a report on the current state of settlements.
Async Function ReportCurrentStatusOfSettlements(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ReportCurrentStatusOfSettlements(Hardware, Settings);
EndFunction

// OpenCashDrawer.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OpenCashDrawerSettings
//
// Returns:
//  Boolean - Opening the cash drawer.
Async Function OpenCashDrawer(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OpenCashDrawer(Hardware, Settings);
EndFunction

// GetLineLength.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetLineLengthSettings
//
// Returns:
//  Boolean - Getting the line length for the KKT.
Async Function GetLineLength(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetLineLength(Hardware, Settings);
EndFunction

// OpenSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See OpenSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Opening a registration session in the control module.
Async Function OpenSessionRegistrationKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.OpenSessionRegistrationKM(Hardware, Settings);
EndFunction

// CloseSessionRegistrationKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See CloseSessionRegistrationKMSettings
//
// Returns:
//  Boolean - Closing a registration session in the control module.
Async Function CloseSessionRegistrationKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.CloseSessionRegistrationKM(Hardware, Settings);
EndFunction

// RequestKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See RequestKMSettings
//
// Returns:
//  Boolean - Sending a request to the control module.
Async Function RequestKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.RequestKM(Hardware, Settings);
EndFunction

// GetProcessingKMResult.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See GetProcessingKMResultSettings
//
// Returns:
//  Boolean - The method requests the results of the marking code check in the OISM.
Async Function GetProcessingKMResult(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.GetProcessingKMResult(Hardware, Settings);
EndFunction

// ConfirmKM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware - Hardware
//  Settings - See ConfirmKMSettings
//
// Returns:
//  Boolean - Confirms or cancels the previously checked KM as part of the document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
Async Function ConfirmKM(Hardware, Settings) Export
	Return Await HardwareClient.GetAPIModule(Hardware)
		.ConfirmKM(Hardware, Settings);
EndFunction

#EndRegion
