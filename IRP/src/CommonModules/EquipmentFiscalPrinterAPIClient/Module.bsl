// @strict-types

#Region API

// GetDataKKT - Getting data from the KKT for the registration of the fiscal memory and subsequent work
//
// Returns:
//  Structure - GetDataKKT:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
// ** TableParametersKKT - String - Registration data of the fiscal memory module
Function GetDataKKTSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetDataKKT");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("TableParametersKKT", "");
    
    Return Str;
EndFunction

// OperationFN - Operation with the fiscal drive. After the operation, a report on the conduct of the corresponding operation is printed.
//
// Returns:
//  Structure - OperationFN:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** OperationType - Number - Type of operation:
//  1 = Registration
//  2 = Change of registration parameters
//  3 = Closure of the FN
// ** ParametersFiscal - String - Data for the fiscalization of the fiscal drive
// * InOut - Structure -
// * Out - Structure:
Function OperationFNSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OperationFN");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("OperationType", 0);
    Str.In.Insert("ParametersFiscal", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// OpenShift - Opens a new shift and prints a report on the KKT about the opening of the shift.
//
// Returns:
//  Structure - OpenShift:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - String - Input parameters of the operation
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - String - Output parameters of the operation
Function OpenShiftSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OpenShift");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", "");
    
    Return Str;
EndFunction

// CloseShift - Closes the previously opened shift and prints a report on the KKT about the closing of the shift.
//
// Returns:
//  Structure - CloseShift:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - String - Input parameters of the operation
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - String - Output parameters of the operation
Function CloseShiftSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "CloseShift");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", "");
    
    Return Str;
EndFunction

// ProcessCheck - Formation of a check in batch mode. A structure is passed that describes the type of check being opened, fiscal and text lines, barcodes that will be printed. Also, payment amounts are passed to close the check.
//
// Returns:
//  Structure - ProcessCheck:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** Electronically - Boolean - Formation of a check only in electronic form. The check is not printed.
// ** CheckPackage - String - XML structure - check description.
// * InOut - Structure -
// * Out - Structure:
// ** DocumentOutputParameters - String - Output parameters of the operation
Function ProcessCheckSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ProcessCheck");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("Electronically", False);
    Str.In.Insert("CheckPackage", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("DocumentOutputParameters", "");
    
    Return Str;
EndFunction

// ProcessCorrectionCheck - Formation of a correction check in batch mode. A structure is passed that describes the type of check being opened and the attributes of the check.
//
// Returns:
//  Structure - ProcessCorrectionCheck:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** CheckPackage - String - XML structure - correction check description.
// * InOut - Structure -
// * Out - Structure:
// ** DocumentOutputParameters - String - Output parameters of the operation
Function ProcessCorrectionCheckSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ProcessCorrectionCheck");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("CheckPackage", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("DocumentOutputParameters", "");
    
    Return Str;
EndFunction

// PrintTextDocument - Printing a text document (text slip-check, information receipt)
//
// Returns:
//  Structure - PrintTextDocument:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** DocumentPackage - String - XML structure - text document description.
// * InOut - Structure -
// * Out - Structure:
Function PrintTextDocumentSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "PrintTextDocument");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("DocumentPackage", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// CashInOutcome - Prints a cash deposit / withdrawal check (depends on the amount passed). Amount >= 0 - deposit, Amount < 0 - withdrawal.
//
// Returns:
//  Structure - CashInOutcome:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - String - Input parameters of the operation
// ** Amount - Number - Deposit / withdrawal amount
// * InOut - Structure -
// * Out - Structure:
Function CashInOutcomeSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "CashInOutcome");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", "");
    Str.In.Insert("Amount", 0);
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// PrintXReport - Prints a shift report without closing the cash shift.
//
// Returns:
//  Structure - PrintXReport:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - String - Input parameters of the operation
// * InOut - Structure -
// * Out - Structure:
Function PrintXReportSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "PrintXReport");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// PrintCheckCopy - Prints a printed duplicate of a previously fiscalized check.
//
// Returns:
//  Structure - PrintCheckCopy:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** CheckNumber - String - Fiscal check number
// * InOut - Structure -
// * Out - Structure:
Function PrintCheckCopySettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "PrintCheckCopy");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("CheckNumber", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// GetCurrentStatus - Getting the current status of the KKT.
//
// Returns:
//  Structure - GetCurrentStatus:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - String - Input parameters of the operation
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - String - XML structure - description of status parameters.
Function GetCurrentStatusSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetCurrentStatus");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", "");
    
    Return Str;
EndFunction

// ReportCurrentStatusOfSettlements - Forms a report on the current state of settlements.
//
// Returns:
//  Structure - ReportCurrentStatusOfSettlements:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** InputParameters - String - Input parameters of the operation
// * InOut - Structure -
// * Out - Structure:
// ** OutputParameters - String - Output parameters of the operation
Function ReportCurrentStatusOfSettlementsSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ReportCurrentStatusOfSettlements");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("InputParameters", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("OutputParameters", "");
    
    Return Str;
EndFunction

// OpenCashDrawer - Opens the cash drawer connected to the fiscal registrar.
//
// Returns:
//  Structure - OpenCashDrawer:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
Function OpenCashDrawerSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OpenCashDrawer");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// GetLineLength - Gets the width of the check line in characters.
//
// Returns:
//  Structure - GetLineLength:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
// ** LineLength - Number - Line width in characters
Function GetLineLengthSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetLineLength");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("LineLength", 0);
    
    Return Str;
EndFunction

// OpenSessionRegistrationKM - Opens a registration session for the control module.
//
// Returns:
//  Structure - OpenSessionRegistrationKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
Function OpenSessionRegistrationKMSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "OpenSessionRegistrationKM");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// CloseSessionRegistrationKM - Closes the registration session for the control module.
//
// Returns:
//  Structure - CloseSessionRegistrationKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
Function CloseSessionRegistrationKMSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "CloseSessionRegistrationKM");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
EndFunction

// RequestKM - Sends a request to the control module.
//
// Returns:
//  Structure - RequestKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** RequestKM - String - Request data
// * InOut - Structure -
// * Out - Structure:
// ** RequestKMResult - String - Response data
Function RequestKMSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "RequestKM");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("RequestKM", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("RequestKMResult", "");
    
    Return Str;
EndFunction

// GetProcessingKMResult - Gets the results of processing the control module.
//
// Returns:
//  Structure - GetProcessingKMResult:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// * InOut - Structure -
// * Out - Structure:
// ** ProcessingKMResult - String - Result of the request
// ** RequestStatus - Number - Request status: 
// 0 = result received, 
// 1 = result not yet received,
// 2 = result cannot be received
Function GetProcessingKMResultSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "GetProcessingKMResult");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    Str.Out.Insert("ProcessingKMResult", "");
    Str.Out.Insert("RequestStatus", 0);
    
    Return Str;
EndFunction

// ConfirmKM - Confirms or cancels the previously checked KM as part of a document on the sale of marked goods. KM must have been previously checked by the RequestKM method.
//
// Returns:
//  Structure - ConfirmKM:
// * Info - Structure:
// ** Name - String - Function name
// ** Error - String - Error, if result false
// * In - Structure:
// ** DeviceID - String - Device ID
// ** GUID - String - Unique identifier of the KM request, which was previously made by the RequestKM method
// ** ConfirmationType - Number - 
// 	0 = KM will be implemented as part of a document on the sale of marked goods. 
// 	1 = KM will not be implemented. Will NOT be included in the document on the sale of marked goods.
// * InOut - Structure -
// * Out - Structure:
Function ConfirmKMSettings() Export
    Str = New Structure;
    
    Str.Insert("Info", New Structure);
    Str.Info.Insert("Error", "");
    Str.Info.Insert("Name", "ConfirmKM");
    
    Str.Insert("In", New Structure);
    Str.In.Insert("DeviceID", "");
    Str.In.Insert("GUID", "");
    Str.In.Insert("ConfirmationType", 0);
    
    Str.Insert("InOut", New Structure);
    
    Str.Insert("Out", New Structure);
    
    Return Str;
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
//  Settings - See OperationFNSettings 
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
//  Settings - See OpenShiftSettings 
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
//  Settings - See CloseShiftSettings 
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
//  Settings - See ProcessCheckSettings 
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
//  Settings - See ProcessCorrectionCheckSettings 
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
//  Settings - See PrintTextDocumentSettings 
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
//  Settings - See CashInOutcomeSettings 
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
//  Settings - See PrintXReportSettings 
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
//  Settings - See PrintCheckCopySettings 
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
//  Settings - See GetCurrentStatusSettings 
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
//  Settings - See ReportCurrentStatusOfSettlementsSettings 
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
//  Settings - See OpenCashDrawerSettings 
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
//  Settings - See GetLineLengthSettings 
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
//  Settings - See OpenSessionRegistrationKMSettings 
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
//  Settings - See CloseSessionRegistrationKMSettings 
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
//  Settings - See RequestKMSettings 
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
//  Settings - See GetProcessingKMResultSettings 
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
//  Settings - See ConfirmKMSettings 
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
