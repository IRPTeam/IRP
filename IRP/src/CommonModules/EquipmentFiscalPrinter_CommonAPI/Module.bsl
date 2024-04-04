
// @strict-types

#Region Stadard

// Device open.
//
// Parameters:
//  Settings - See HardwareClient.GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  ID - String - ID
//
// Returns:
//  Boolean
//
// @skip-check dynamic-access-method-not-found
Function Device_Open(Settings, DriverObject, ID) Export
	Return HardwareClient.Device_Open(Settings, DriverObject, ID)
EndFunction

// Device close.
//
// Parameters:
//  Settings - See HardwareClient.GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  ID - String - ID
//
// Returns:
//  Boolean
//
// @skip-check dynamic-access-method-not-found
Function Device_Close(Settings, DriverObject, ID) Export
	Return HardwareClient.Device_Close(Settings, DriverObject, ID);
EndFunction

// Is code string approved.
//
// Parameters:
//  GetProcessingKMResultSettings - See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings
//
// Returns:
//  Boolean -  Is code string approved
Function isCodeStringApproved(GetProcessingKMResultSettings) Export
	Return GetProcessingKMResultSettings.Out.ProcessingKMResult.ResultCode = 15;
EndFunction

#EndRegion

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

	TableParametersKKT = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetDataKKT(
		ConnectParameters.ID,
		TableParametersKKT
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check statement-type-change, wrong-type-expression
		Settings.Out.TableParametersKKT = TableParametersKKT;
	Else
		TableParametersKKTPrepared = EquipmentFiscalPrinterAPIClient.TableParametersKKT();
		FillDataFromDeviceResponse(Hardware, TableParametersKKTPrepared, TableParametersKKT);
		Settings.Out.TableParametersKKT = TableParametersKKTPrepared;
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

	Settings.Info.Success = Result;

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

	OutputParameters = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.OpenShift(
		ConnectParameters.ID,
		InputParameters_ToXML(Settings.In.InputParameters),
		OutputParameters
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.OutputParameters = OutputParameters;
	Else
		OutputParametersPrepared = EquipmentFiscalPrinterAPIClient.OutputParameters();
		FillDataFromDeviceResponse(Hardware, OutputParametersPrepared, OutputParameters);
		Settings.Out.OutputParameters = OutputParametersPrepared;
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

	OutputParameters = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.CloseShift(
		ConnectParameters.ID,
		InputParameters_ToXML(Settings.In.InputParameters),
		OutputParameters
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.OutputParameters = OutputParameters;
	Else
		OutputParametersPrepared = EquipmentFiscalPrinterAPIClient.OutputParameters();
		FillDataFromDeviceResponse(Hardware, OutputParametersPrepared, OutputParameters);
		Settings.Out.OutputParameters = OutputParametersPrepared;
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

	DocumentOutputParameters = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ProcessCheck(
		ConnectParameters.ID,
		Settings.In.Electronically,
		CheckPackage_ToXML(Settings.In.CheckPackage),
		DocumentOutputParameters
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.DocumentOutputParameters = DocumentOutputParameters;
	Else
		FillDataFromDeviceResponse(Hardware, Settings.Out.DocumentOutputParameters, DocumentOutputParameters);
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

	DocumentOutputParameters = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ProcessCorrectionCheck(
		ConnectParameters.ID,
		CheckPackage_ToXML(Settings.In.CheckPackage),
		DocumentOutputParameters
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.DocumentOutputParameters = DocumentOutputParameters;
	Else
		//@skip-check invocation-parameter-type-intersect
		FillDataFromDeviceResponse(Hardware, Settings.Out.DocumentOutputParameters, DocumentOutputParameters);
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
		DocumentPackage_ToXML(Settings.In.DocumentPackage)
	); // Boolean

	Settings.Info.Success = Result;

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
		InputParameters_ToXML(Settings.In.InputParameters),
		Settings.In.Amount
	); // Boolean

	Settings.Info.Success = Result;

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
		InputParameters_ToXML(Settings.In.InputParameters)
	); // Boolean

	Settings.Info.Success = Result;

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

	Settings.Info.Success = Result;

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

	OutputParameters = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetCurrentStatus(
		ConnectParameters.ID,
		InputParameters_ToXML(Settings.In.InputParameters),
		OutputParameters
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.OutputParameters = OutputParameters;
	Else
		OutputParametersPrepared = EquipmentFiscalPrinterAPIClient.OutputParameters();
		FillDataFromDeviceResponse(Hardware, OutputParametersPrepared, OutputParameters);
		Settings.Out.OutputParameters = OutputParametersPrepared;
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

	// @skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.ReportCurrentStatusOfSettlements(
		ConnectParameters.ID,
		InputParameters_ToXML(Settings.In.InputParameters),
		Settings.Out.OutputParameters
	); // Boolean

	Settings.Info.Success = Result;

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

	Settings.Info.Success = Result;

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

	Settings.Info.Success = Result;

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

	Settings.Info.Success = Result;

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

	Settings.Info.Success = Result;

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

	RequestKMResult = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.RequestKM(
		ConnectParameters.ID,
		RequestXML_ToXML(Settings.In.RequestKM),
		RequestKMResult
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.RequestKMResult = RequestKMResult;
	Else
		FillDataFromDeviceResponse(Hardware, Settings.Out.RequestKMResult, RequestKMResult);
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

	ProcessingKMResult = "";

	//@skip-check dynamic-access-method-not-found
	Result = ConnectParameters.DriverObject.GetProcessingKMResult(
		ConnectParameters.ID,
		ProcessingKMResult,
		Settings.Out.RequestStatus
	); // Boolean

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
		//@skip-check wrong-type-expression, statement-type-change
		Settings.Out.ProcessingKMResult = ProcessingKMResult;
	Else
		FillDataFromDeviceResponse(Hardware, Settings.Out.ProcessingKMResult, ProcessingKMResult);
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

	Settings.Info.Success = Result;

	If Not Result Then
		Settings.Info.Error = Await HardwareClient.GetLastError(Hardware);
	EndIf;

	If ConnectParameters.WriteLog Then
		HardwareServer.WriteLog(Hardware, "ConfirmKM", False, Settings, Result);
	EndIf;

	Return Result;
EndFunction

#EndRegion

#Region Private

// Request XML to XML.
//
// Parameters:
//  RequestKMSettings - See EquipmentFiscalPrinterAPIClient.RequestKMInput
//
// Returns:
//  String -  Request XML
Function RequestXML_ToXML(RequestKMSettings)
	CodeString = RequestKMSettings.MarkingCode;
	If Not CommonFunctionsClientServer.isBase64Value(CodeString) Then
		CodeString = Base64String(GetBinaryDataFromString(CodeString, TextEncoding.UTF8, False));
	EndIf;

	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("RequestKM");
	XMLWriter.WriteAttribute("GUID" , ToXMLString(RequestKMSettings.GUID));
	XMLWriter.WriteAttribute("MarkingCode" , ToXMLString(CodeString));
	XMLWriter.WriteAttribute("PlannedStatus" , ToXMLString(RequestKMSettings.PlannedStatus));
	XMLWriter.WriteEndElement();

	RequestXML = XMLWriter.Close();
	Return RequestXML
EndFunction

// Input parameters to XML.
//
// Parameters:
//  InputParameters - See EquipmentFiscalPrinterAPIClient.InputParameters
//
// Returns:
//  String - Input parameters to XML
Function InputParameters_ToXML(InputParameters)

	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("InputParameters");

	XMLWriter.WriteStartElement("Parameters");
	XMLWriter.WriteAttribute("CashierName", ToXMLString(InputParameters.CashierName));
	If Not IsBlankString(InputParameters.CashierINN) Then
		XMLWriter.WriteAttribute("CashierINN" , ToXMLString(InputParameters.CashierINN));
	EndIf;
	If Not IsBlankString(InputParameters.SaleAddress) Then
		XMLWriter.WriteAttribute("SaleAddress", ToXMLString(InputParameters.SaleAddress));
	EndIf;
	If Not IsBlankString(InputParameters.SaleLocation) Then
		XMLWriter.WriteAttribute("SaleLocation", ToXMLString(InputParameters.SaleLocation));
	EndIf;
	XMLWriter.WriteEndElement();

	XMLWriter.WriteEndElement();

	Return XMLWriter.Close();
EndFunction

// Print text get XMLOperation.
//
// Parameters:
//  DocumentPackage - See EquipmentFiscalPrinterAPIClient.DocumentPackage
//
// Returns:
//  String - Print text get XMLOperation
Function DocumentPackage_ToXML(DocumentPackage)

	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("Document");

	XMLWriter.WriteStartElement("Positions");
	For Each Text In DocumentPackage.TextString Do
		XMLWriter.WriteStartElement("TextString");
		XMLWriter.WriteAttribute("Text", ToXMLString(Text));
		XMLWriter.WriteEndElement();
	EndDo;

	If Not IsBlankString(DocumentPackage.Barcode.Value) Then
		XMLWriter.WriteStartElement("Barcode");
		XMLWriter.WriteAttribute("Type", ToXMLString(DocumentPackage.Barcode.Type));
		Base64 = GetBase64StringFromBinaryData(GetBinaryDataFromString(DocumentPackage.Barcode.Value));
		Base64 = StrReplace(Base64, Chars.LF, "");
		Base64 = StrReplace(Base64, Chars.CR, "");
		XMLWriter.WriteAttribute("ValueBase64", Base64);
		XMLWriter.WriteEndElement();
	EndIf;

	XMLWriter.WriteEndElement();

	XMLWriter.WriteEndElement();

	Return XMLWriter.Close();

EndFunction

// Receipt get XMLOperation.
//
// Parameters:
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
//
// Returns:
//  String - Receipt get XMLOperation
Function CheckPackage_ToXML(CheckPackage)

	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("CheckPackage");

	XMLWriter.WriteStartElement("Parameters");
	XMLWriter.WriteAttribute("CashierName", ToXMLString(CheckPackage.Parameters.CashierName));
	XMLWriter.WriteAttribute("CashierINN" , ToXMLString(CheckPackage.Parameters.CashierINN));
	XMLWriter.WriteAttribute("SaleAddress" , ToXMLString(CheckPackage.Parameters.SaleAddress));
	XMLWriter.WriteAttribute("SaleLocation" , ToXMLString(CheckPackage.Parameters.SaleLocation));
	XMLWriter.WriteAttribute("OperationType" , ToXMLString(CheckPackage.Parameters.OperationType));
	XMLWriter.WriteAttribute("TaxationSystem" , ToXMLString(CheckPackage.Parameters.TaxationSystem));
	XMLWriter.WriteAttribute("AdditionalAttribute" , ToXMLString(CheckPackage.Parameters.AdditionalAttribute));
	
	If CheckPackage.Parameters.CorrectionData.Property("Description") 
		AND Not IsBlankString(CheckPackage.Parameters.CorrectionData.Description) Then
		XMLWriter.WriteStartElement("CorrectionData");
		XMLWriter.WriteAttribute("Type", ToXMLString(CheckPackage.Parameters.CorrectionData.Type));
		XMLWriter.WriteAttribute("Number" , ToXMLString(CheckPackage.Parameters.CorrectionData.Number));
		XMLWriter.WriteAttribute("Description" , ToXMLString(CheckPackage.Parameters.CorrectionData.Description));
		XMLWriter.WriteAttribute("Date" , ToXMLString(Format(CheckPackage.Parameters.CorrectionData.Date, "DF=yyyy-MM-ddTHH:mm:ss;")));
		XMLWriter.WriteEndElement();
	EndIf;
	
	XMLWriter.WriteEndElement();

	XMLWriter.WriteStartElement("Positions");
	For Each Item In CheckPackage.Positions.FiscalStrings Do // See EquipmentFiscalPrinterAPIClient.CheckPackage_FiscalString
		XMLWriter.WriteStartElement("FiscalString");
		XMLWriter.WriteAttribute("AmountWithDiscount", ToXMLString(Item.AmountWithDiscount));
		XMLWriter.WriteAttribute("DiscountAmount", ToXMLString(Item.DiscountAmount));
		If Not IsBlankString(Item.MarkingCode) Then
			XMLWriter.WriteAttribute("MarkingCode", ToXMLString(Item.MarkingCode));
		EndIf;
		XMLWriter.WriteAttribute("MeasureOfQuantity", ToXMLString(Item.MeasureOfQuantity));
		XMLWriter.WriteAttribute("CalculationSubject", ToXMLString(Item.CalculationSubject));
		XMLWriter.WriteAttribute("Name", ToXMLString(Item.Name));
		XMLWriter.WriteAttribute("Quantity", ToXMLString(Item.Quantity));
		XMLWriter.WriteAttribute("PaymentMethod", ToXMLString(Item.PaymentMethod));
		XMLWriter.WriteAttribute("PriceWithDiscount", ToXMLString(Item.PriceWithDiscount));
		XMLWriter.WriteAttribute("VATRate", ToXMLString(Item.VATRate));
		XMLWriter.WriteAttribute("VATAmount", ToXMLString(Item.VATAmount));
		If Not Item.CalculationAgent = -1 Then
			XMLWriter.WriteAttribute("CalculationAgent", ToXMLString(Item.CalculationAgent));
		EndIf;
		If Not IsBlankString(Item.VendorData.VendorINN) Then
			XMLWriter.WriteStartElement("VendorData");
			XMLWriter.WriteAttribute("VendorINN", ToXMLString(Item.VendorData.VendorINN));
			XMLWriter.WriteAttribute("VendorName", ToXMLString(Item.VendorData.VendorName));
			XMLWriter.WriteAttribute("VendorPhone", ToXMLString(Item.VendorData.VendorPhone));
			XMLWriter.WriteEndElement();
		EndIf;
		For Each GoodCodeData In Item.GoodCodeData Do
			XMLWriter.WriteStartElement("GoodCodeData");
			XMLWriter.WriteAttribute(GoodCodeData.Key, ToXMLString(GoodCodeData.Value));
			XMLWriter.WriteEndElement();
		EndDo;
		XMLWriter.WriteEndElement();
	EndDo;
	For Each Text In CheckPackage.Positions.TextStrings Do
		XMLWriter.WriteStartElement("TextString");
		XMLWriter.WriteAttribute("Text", ToXMLString(Text));
		XMLWriter.WriteEndElement();
	EndDo;
	If Not IsBlankString(CheckPackage.Positions.Barcode.Value) Then
		XMLWriter.WriteStartElement("Barcode");
		XMLWriter.WriteAttribute("Type", ToXMLString(CheckPackage.Positions.Barcode.Type));
		Base64 = GetBase64StringFromBinaryData(GetBinaryDataFromString(CheckPackage.Positions.Barcode.Value));
		Base64 = StrReplace(Base64, Chars.LF, "");
		Base64 = StrReplace(Base64, Chars.CR, "");
		XMLWriter.WriteAttribute("ValueBase64", Base64);
		XMLWriter.WriteEndElement();
	EndIf;
	XMLWriter.WriteEndElement();

	XMLWriter.WriteStartElement("Payments");
	XMLWriter.WriteAttribute("Cash", ToXMLString(CheckPackage.Payments.Cash));
	XMLWriter.WriteAttribute("ElectronicPayment", ToXMLString(CheckPackage.Payments.ElectronicPayment));
	XMLWriter.WriteAttribute("PrePayment", ToXMLString(CheckPackage.Payments.PrePayment));
	XMLWriter.WriteAttribute("PostPayment", ToXMLString(CheckPackage.Payments.PostPayment));
	XMLWriter.WriteAttribute("Barter", ToXMLString(CheckPackage.Payments.Barter));
	XMLWriter.WriteEndElement();

	XMLWriter.WriteEndElement();

	Return XMLWriter.Close();

EndFunction

// Fill data from device response.
//
// Parameters:
//  Hardware - CatalogRef.Hardware
//  Data - Structure
//  DeviceResponse - String -  Device response
Procedure FillDataFromDeviceResponse(Hardware, Data, DeviceResponse) Export
	Try
		Result = ReadXMLReponse(DeviceResponse);
	Except
		Error = ErrorProcessing.DetailErrorDescription(ErrorInfo());
		Str = New Structure;
		Str.Insert("Description", Error);
		Str.Insert("DeviceResponse", DeviceResponse);
		HardwareServer.WriteLog(Hardware, "Parsing result", False, Str, Result);
		Raise R().EqFP_ReceivedWrongAnswerFromDevice;
	EndTry;
	If Not Result.Properties().Get("Parameters") = Undefined Then
		//@skip-check property-return-type
		DeviceResponseParameters = Result.Parameters; // XDTODataObject
	Else
		DeviceResponseParameters = Result;
	EndIf;

	For Each DataItem In Data Do
		If Not DeviceResponseParameters.Properties().Get(DataItem.Key) = Undefined Then
			//@skip-check invocation-parameter-type-intersect
			Data.Insert(DataItem.Key, TransformToTypeBySource(DeviceResponseParameters[DataItem.Key], DataItem.Value));
		EndIf;
	EndDo;
EndProcedure

Function ReadXMLReponse(DeviceResponse)
	Reader = New XMLReader();
	Reader.SetString(DeviceResponse);
	Result = XDTOFactory.ReadXML(Reader); // XDTODataObject
	Reader.Close();
	Return Result;
EndFunction

// Transform to type by source.
// @skip-check property-return-type, dynamic-access-method-not-found, variable-value-type, invocation-parameter-type-intersect
//
// Parameters:
//  Data - Boolean, Number, Date, Structure - Data
//  Source - Arbitrary -  Source
//
// Returns:
//  Boolean, Number, Date, Structure -  Transform to type by source
Function TransformToTypeBySource(Data, Source)
	If Data = "" Then
		Return Data;
	EndIf;
	If TypeOf(Source) = Type("Boolean") Then
		Return Boolean(Data);
	ElsIf TypeOf(Source) = Type("Number") Then
		Return Number(Data);
	ElsIf TypeOf(Source) = Type("Date") Then
		//@skip-check invocation-parameter-type-intersect
		Return ReadJSONDate(Data, JSONDateFormat.ISO);
	ElsIf TypeOf(Source) = Type("Structure") Then
		Structure = New Structure();
		For Each Item In Data.Parameters.Properties() Do
			//@skip-check invocation-parameter-type-intersect
			Structure.Insert(Item.Name, Data.Parameters[Item.Name]);
		EndDo;
		Return Structure;
	Else
		Return Data;
	EndIf;
EndFunction

Function ToXMLString(Data)
	// @skip-check undefined-function
	Return XMLString(Data);
EndFunction

#EndRegion