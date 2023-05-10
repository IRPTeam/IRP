#Region API

// Open shift.
// 
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
// 
// Returns:
//  See OpenShiftResult
Async Function OpenShift(ConsolidatedRetailSales) Export
	
	Result = ShiftResultStructure();
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	LineLength = 0;
	DriverObject = Settings.ConnectedDriver.DriverObject;
	DriverObject.GetLineLength(Settings.ConnectedDriver.ID, LineLength);
	
	DataKKT = "";
	DataKKTResult = DriverObject.GetDataKKT(Settings.ConnectedDriver.ID
																		, DataKKT);
	If Not DataKKTResult Then
		Raise "Can not get data KKT";
	EndIf;

	ResultInfo = DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			
		ElsIf ShiftData.ShiftState = 2 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyOpened;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = DriverObject.OpenShift(Settings.ConnectedDriver.ID
																	, Parameters.ParametersXML
																	, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CloseShift(ConsolidatedRetailSales) Export
	Result = ShiftResultStructure();
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	DriverObject = Settings.ConnectedDriver.DriverObject;
	ResultInfo = DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then

		ElsIf ShiftData.ShiftState = 3 Then
			
		EndIf;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = DriverObject.CloseShift(Settings.ConnectedDriver.ID, Parameters.ParametersXML, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function PrintXReport(ConsolidatedRetailSales) Export
	Result = ShiftResultStructure();
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	DriverObject = Settings.ConnectedDriver.DriverObject;
	ResultInfo = DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = DriverObject.PrintXReport(Settings.ConnectedDriver.ID, Parameters.ParametersXML);
	If ResultInfo Then
		Result.Success = True;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function ProcessCheck(ConsolidatedRetailSales, DataSource) Export
	Result = ReceiptResultStructure();
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Result.Status = StatusData.Status;
		Result.DataPresentation = StatusData.DataPresentation;
		Result.FiscalResponse = StatusData.FiscalResponse;
		Result.Success = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_DocumentAlreadyPrinted);
		Return Result;
	EndIf;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	XMLOperationSettings = ShiftGetXMLOperationSettings();
	
	Parameters.ParametersXML = ShiftGetXMLOperation(XMLOperationSettings);
	DriverObject = Settings.ConnectedDriver.DriverObject;
	ResultInfo = DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	If TypeOf(DataSource) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt") Then
		
		CodeStringList = EquipmentFiscalPrinterServer.GetStringCode(DataSource);
		
		If CodeStringList.Count() > 0 Then
			If Not DriverObject.OpenSessionRegistrationKM(Settings.ConnectedDriver.ID) = True Then
				Raise R().EqFP_CanNotOpenSessionRegistrationKM;
			EndIf;
			
			ArrayForApprove = New Array; // Array Of String
			For Each CodeString In EquipmentFiscalPrinterServer.GetStringCode(DataSource) Do
				RequestKMSettings = RequestKMSettings();
				RequestKMSettings.MarkingCode = CodeString;
				RequestKMSettings.Quantity = 1;
				CheckResult = Device_CheckKM(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, RequestKMSettings, False);
				If Not CheckResult.Approved Then
					Raise StrTemplate(R().EqFP_ProblemWhileCheckCodeString, GetStringFromBinaryData(Base64Value(RequestKMSettings.MarkingCode)));
				EndIf;
				ArrayForApprove.Add(RequestKMSettings.GUID);
			EndDo;
			
			For Each ApproveUUID In ArrayForApprove Do
				If Not DriverObject.ConfirmKM(Settings.ConnectedDriver.ID, ApproveUUID, 0) Then
					Raise StrTemplate(R().EqFP_ErrorWhileConfirmCode, ApproveUUID);
				EndIf;
			EndDo;
			
			If Not DriverObject.CloseSessionRegistrationKM(Settings.ConnectedDriver.ID) = True Then
				Raise R().EqFP_CanNotCloseSessionRegistrationKM;
			EndIf;
			
		EndIf;
	EndIf;
	Parameters = ReceiptSettings();
	XMLOperationSettings = ReceiptGetXMLOperationSettings(DataSource);
	
	Parameters.ParametersXML = ReceiptGetXMLOperation(XMLOperationSettings);
	
	ResultInfo = DriverObject.ProcessCheck(Settings.ConnectedDriver.ID
																	, False
																	, Parameters.ParametersXML
																	, Parameters.ResultXML);
	If ResultInfo Then
		ReceiptData = ReceiptResultStructure();
		FillDataFromDeviceResponse(ReceiptData, Parameters.ResultXML);
		FillPropertyValues(Result, ReceiptData);
		Result.Status = "Printed";
		Result.DataPresentation = " " + Result.ShiftNumber + " " + Result.DateTime;
		Result.FiscalResponse = Parameters.ResultXML;
		Result.Success = True;
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource
						, Result.Status
						, Result.FiscalResponse
						, " " + Result.ShiftNumber + " " + Result.DateTime);
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource
						, Result.Status
						, Result.ErrorDescription);
		
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CashInCome(ConsolidatedRetailSales, PrintDocument, Summ) Export
	Result = ShiftResultStructure();
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(PrintDocument);
	If StatusData.IsPrinted Then
		Result.Status = StatusData.Status;
		Result.Success = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_DocumentAlreadyPrinted);
		Return Result;
	EndIf;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	DriverObject = Settings.ConnectedDriver.DriverObject;
	ResultInfo = DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = DriverObject.CashInOutcome(Settings.ConnectedDriver.ID
																		, Parameters.ParametersXML
																		, Summ);
	If ResultInfo Then
		Result.Status = "Printed";
		Result.Success = True;
		EquipmentFiscalPrinterServer.SetFiscalStatus(PrintDocument
						, Result.Status);
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(PrintDocument
						, Result.Status
						, Result.ErrorDescription);
						
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CashOutCome(ConsolidatedRetailSales, PrintDocument, Summ) Export
	Result = ShiftResultStructure();
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(PrintDocument);
	If StatusData.IsPrinted Then
		Result.Status = StatusData.Status;
		Result.Success = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_DocumentAlreadyPrinted);
		Return Result;
	EndIf;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	DriverObject = Settings.ConnectedDriver.DriverObject;
	ResultInfo = DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = DriverObject.CashInOutcome(Settings.ConnectedDriver.ID
																		, Parameters.ParametersXML
																		, -Summ);
	If ResultInfo Then
		Result.Status = "Printed";
		Result.Success = True;
		EquipmentFiscalPrinterServer.SetFiscalStatus(PrintDocument
						, Result.Status);
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(PrintDocument
						, Result.Status
						, Result.ErrorDescription);
						
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function PrintTextDocument(ConsolidatedRetailSales, DataSource) Export
	Result = PrintTextResultStructure();
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
	
	Parameters = ReceiptSettings();	
	XMLOperationSettings = PrintTextGetXMLOperationSettings(DataSource);
	If Not XMLOperationSettings.TextStrings.Count() Then
		Result.Success = True;
		Return Result;
	EndIf;
	
	Parameters.ParametersXML = PrintTextGetXMLOperation(XMLOperationSettings);
	
	DriverObject = Settings.ConnectedDriver.DriverObject;
	ResultInfo = DriverObject.PrintTextDocument(Settings.ConnectedDriver.ID
																	, Parameters.ParametersXML);
																	
	If ResultInfo Then
		Result.Success = True;		
	Else
		DriverObject.GetLastError(Result.ErrorDescription);
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

// Request KM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - 
//  RequestKMSettings - See RequestKMSettings
// 
// Returns:
//  See EquipmentFiscalPrinterClient.ProcessingKMResult
Async Function CheckKM(Hardware, RequestKMSettings) Export
	Settings = Await HardwareClient.FillDriverParametersSettings(Hardware); // See HardwareClient.FillDriverParametersSettings
	Return Device_CheckKM(Settings.ConnectedDriver, Settings.ConnectedDriver.DriverObject, RequestKMSettings);
EndFunction

// Request KM settings.
// 
// Returns:
//  Structure - Request KMSettings:
// * GUID - UUID -
// * WaitForResult - Boolean -
// * MarkingCode - String -
// * PlannedStatus - Number -
// * Quantity - Number -
Function RequestKMSettings() Export
	Str = New Structure;
	Str.Insert("GUID", String(New UUID()));
	Str.Insert("WaitForResult", True);
	Str.Insert("MarkingCode", "");
	Str.Insert("PlannedStatus", 1);
	Str.Insert("Quantity", 1);
	Return Str;
EndFunction

// Request KMSettings result.
// 
// Returns:
//  Structure - Request KMSettings result:
// * Checking - Boolean -
// * CheckingResult - Boolean -
Function RequestKMSettingsResult() 
	Str = New Structure;
	Str.Insert("Checking", False);
	Str.Insert("CheckingResult", False);
	Return Str;
EndFunction

// Processing KMResult.
// 
// Returns:
//  Structure - Processing KMResult:
// * GUID - String -
// * Result - Boolean -
// * ResultCode - Number -
// * StatusInfo - Number -
// * HandleCode - Number -
// * Approved - Boolean -
Function ProcessingKMResult() Export
	Str = New Structure;
	Str.Insert("GUID", "");
	Str.Insert("Result", False);
	Str.Insert("ResultCode", -1);
	Str.Insert("StatusInfo", 0);
	Str.Insert("HandleCode", -1);
	Str.Insert("Approved", False);
	
	Return Str;
EndFunction

#EndRegion

#Region Device

// Device request KM.
// 
// Parameters:
//  Settings - See HardwareClient.GetDriverObject
//  DriverObject - Arbitrary - Driver object
//  RequestKMSettings - See RequestKMSettings
//  OpenAndClose - Boolean -
// 
// Returns:
//  See ProcessingKMResult
Function Device_CheckKM(Settings, DriverObject, RequestKMSettings, OpenAndClose = True)
	
	RequestXML = RequestXML(RequestKMSettings);
	
	ResultXML = "";
	RequestStatus = 0;
	ProcessingKMResultXML = "";
	ProcessingKMResult = ProcessingKMResult();
	
	If OpenAndClose Then
		If Not DriverObject.OpenSessionRegistrationKM(Settings.ID) = True Then
			Raise R().EqFP_CanNotOpenSessionRegistrationKM;
		EndIf;
	EndIf;
	
	If Not DriverObject.RequestKM(Settings.ID, RequestXML, ResultXML) = True Then
		DriverObject.CloseSessionRegistrationKM(Settings.ID);
		Raise R().EqFP_CanNotRequestKM;
	EndIf;

	RequestKMResult = RequestXMLResponse(ResultXML);

	ResultIsCorrect = False;
	For Index = 0 To 5 Do
		CommonFunctionsServer.Pause(2);
		If Not DriverObject.GetProcessingKMResult(Settings.ID, ProcessingKMResultXML, RequestStatus) = True Then
			DriverObject.CloseSessionRegistrationKM(Settings.ID);
			Raise R().EqFP_CanNotGetProcessingKMResult;
		EndIf;
		
		If RequestStatus = 2 Then
			Raise R().EqFP_GetWrongAnswerFromProcessingKM;
		EndIf;
		
		If RequestStatus = 1 Then
			Continue;
		EndIf; 

		If IsBlankString(ProcessingKMResultXML) Then
			Continue;	
		EndIf;
		
		ProcessingKMResult = ProcessingKMResultResponse(ProcessingKMResultXML);
		
		If Not ProcessingKMResult.GUID = RequestKMSettings.GUID Then
			Continue;
		EndIf;
		
		ResultIsCorrect = True;
		Break;
	EndDo;
	
	If OpenAndClose Then
		If Not DriverObject.CloseSessionRegistrationKM(Settings.ID) = True Then
			Raise R().EqFP_CanNotCloseSessionRegistrationKM;
		EndIf;
	EndIf;
	
	If Not ResultIsCorrect Then
		Raise R().EqFP_GetWrongAnswerFromProcessingKM;
	EndIf;
	
	ProcessingKMResult.Approved = isApproved(ProcessingKMResult);
	
	Return ProcessingKMResult;
	
EndFunction

Function isApproved(ProcessingKMResult)
	Return ProcessingKMResult.ResultCode = 15;
EndFunction

#EndRegion

#Region Private

Function RequestXML(RequestKMSettings)
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
	//XMLWriter.WriteAttribute("WaitForResult" , ToXMLString(RequestKMSettings.WaitForResult));
	//XMLWriter.WriteAttribute("Quantity" , ToXMLString(RequestKMSettings.Quantity));
	XMLWriter.WriteEndElement();
	
	RequestXML = XMLWriter.Close();
	Return RequestXML
EndFunction

Function RequestXMLResponse(ResultXML)
	
	Result = RequestKMSettingsResult();
	
	Reader = New XMLReader();
	Reader.SetString(ResultXML);
	XDTO = XDTOFactory.ReadXML(Reader);
	Reader.Close();
		
	For Each DataItem In Result Do
		If Not XDTO.Properties().Get(DataItem.Key) = Undefined Then
			Result[DataItem.Key] = TransformToTypeBySource(XDTO[DataItem.Key], DataItem.Value);
		EndIf;
	EndDo;
	
	Return Result;
	
EndFunction

Function ProcessingKMResultResponse(ResultXML)
	
	Result = ProcessingKMResult();
	
	Reader = New XMLReader();
	Reader.SetString(ResultXML);
	XDTO = XDTOFactory.ReadXML(Reader);
	Reader.Close();
		
	For Each DataItem In Result Do
		If Not XDTO.Properties().Get(DataItem.Key) = Undefined Then
			Result[DataItem.Key] = TransformToTypeBySource(XDTO[DataItem.Key], DataItem.Value);
		EndIf;
	EndDo;
	
	Return Result;
	
EndFunction

Function ShiftSettings() Export
	Str = New Structure();
	Str.Insert("ParametersXML", "");
	Str.Insert("ResultXML", "");	
	Return Str;
EndFunction

Function ShiftGetXMLOperationSettings()
	Str = New Structure;
	Str.Insert("CashierName", "");	//Mandatory
	Str.Insert("CashierINN", "");
	Str.Insert("SaleAddress", "");
	Str.Insert("SaleLocation", "");
	Return Str;
EndFunction

Function ShiftResultStructure()
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	ReturnValue.Insert("ErrorDescription", "");
	ReturnValue.Insert("Status", "");
	
	ReturnValue.Insert("BacklogDocumentFirstDateTime", Date(1, 1, 1));
	ReturnValue.Insert("BacklogDocumentFirstNumber", 0);
	ReturnValue.Insert("BacklogDocumentsCounter", 0);
	ReturnValue.Insert("CashBalance", 0);
	ReturnValue.Insert("CheckNumber", 0);
	ReturnValue.Insert("CountersOperationType1", GetCountersOperationType());
	ReturnValue.Insert("CountersOperationType2", GetCountersOperationType());
	ReturnValue.Insert("CountersOperationType3", GetCountersOperationType());
	ReturnValue.Insert("CountersOperationType4", GetCountersOperationType());
	ReturnValue.Insert("DateTime", CommonFunctionsServer.GetCurrentSessionDate());
	ReturnValue.Insert("FNError", False);
	ReturnValue.Insert("FNFail", False);
	ReturnValue.Insert("FNOverflow", False);
	ReturnValue.Insert("ShiftClosingCheckNumber", 0);
	ReturnValue.Insert("ShiftNumber", 0);
	ReturnValue.Insert("ShiftState", 0);	//1 closed, 2 opened, 3 expired
	Return ReturnValue;
EndFunction

Function ReceiptResultStructure()
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	ReturnValue.Insert("ErrorDescription", "");
	ReturnValue.Insert("Status", "");
	ReturnValue.Insert("FiscalResponse", "");
	ReturnValue.Insert("DataPresentation", "");
	
	ReturnValue.Insert("AddressSiteInspections", "");
	ReturnValue.Insert("CheckNumber", 0);
	ReturnValue.Insert("DateTime", CommonFunctionsServer.GetCurrentSessionDate());
	ReturnValue.Insert("FiscalSign", "");
	ReturnValue.Insert("ShiftClosingCheckNumber", 0);
	ReturnValue.Insert("ShiftNumber", 0);
	
	Return ReturnValue;
EndFunction

Function ReceiptSettings() Export
	Str = New Structure();
	Str.Insert("ParametersXML", "");
	Str.Insert("ResultXML", "");	
	Return Str;	
EndFunction

Function PrintTextResultStructure()
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	ReturnValue.Insert("ErrorDescription", "");
	ReturnValue.Insert("Status", "");
	ReturnValue.Insert("FiscalResponse", "");
	ReturnValue.Insert("DataPresentation", "");	
	Return ReturnValue;
EndFunction

Function ReceiptGetXMLOperationSettings(RSR)
	Return EquipmentFiscalPrinterServer.PrepareReceiptData(RSR);
EndFunction

Function PrintTextGetXMLOperationSettings(RSR)
	Return EquipmentFiscalPrinterServer.PreparePrintTextData(RSR);
EndFunction

Function GetCountersOperationType()
	ReturnData = New Structure();
	ReturnData.Insert("CheckCount", 0);
	ReturnData.Insert("TotalChecksAmount", 0);
	ReturnData.Insert("CorrectionCheckCount", 0);
	ReturnData.Insert("TotalCorrectionChecksAmount", 0);	
	Return ReturnData;
EndFunction

Procedure FillDataFromDeviceResponse(Data, DeviceResponse)
	Reader = New XMLReader();
	Reader.SetString(DeviceResponse);
	Result = XDTOFactory.ReadXML(Reader);
	Reader.Close();
	DeviceResponseParameters = Result.Parameters;
		
	For Each DataItem In Data Do
		If Not DeviceResponseParameters.Properties().Get(DataItem.Key) = Undefined Then
			Data.Insert(DataItem.Key, TransformToTypeBySource(DeviceResponseParameters[DataItem.Key], DataItem.Value));
		EndIf;
	EndDo;
EndProcedure

Function TransformToTypeBySource(Data, Source)
	If Data = "" Then
		Return Data;
	EndIf;
	If TypeOf(Source) = Type("Boolean") Then
		Return Boolean(Data);
	ElsIf TypeOf(Source) = Type("Number") Then
		Return Number(Data);
	ElsIf TypeOf(Source) = Type("Date") Then
		Return ReadJSONDate(Data, JSONDateFormat.ISO);
	ElsIf TypeOf(Source) = Type("Structure") Then
		Structure = New Structure();
		For Each Item In Data.Parameters.Properties() Do 
			Structure.Insert(Item.Name, Data.Parameters[Item.Name]);
		EndDo;
		Return Structure;
	Else
		Return Data;
	EndIf;
EndFunction

Function ShiftGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("InputParameters");
	
	XMLWriter.WriteStartElement("Parameters");
	//@skip-check Undefined function
	XMLWriter.WriteAttribute("CashierName", ?(Not IsBlankString(CommonParameters.CashierName), ToXMLString(CommonParameters.CashierName), "Administrator"));
	If Not IsBlankString(CommonParameters.CashierINN) Then
		XMLWriter.WriteAttribute("CashierINN" , ToXMLString(CommonParameters.CashierINN));
	EndIf;
	If Not IsBlankString(CommonParameters.SaleAddress) Then   
		XMLWriter.WriteAttribute("SaleAddress", ToXMLString(CommonParameters.SaleAddress));
	EndIf;
	If Not IsBlankString(CommonParameters.SaleLocation) Then  
		XMLWriter.WriteAttribute("SaleLocation", ToXMLString(CommonParameters.SaleLocation));
	EndIf;
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteEndElement();
	
	Return XMLWriter.Close();
	
EndFunction

Function ReceiptGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("CheckPackage");
	
	XMLWriter.WriteStartElement("Parameters");
	XMLWriter.WriteAttribute("CashierName", ?(Not IsBlankString(CommonParameters.CashierName), ToXMLString(CommonParameters.CashierName), "Administrator"));
	XMLWriter.WriteAttribute("OperationType" , ToXMLString(CommonParameters.OperationType));
	XMLWriter.WriteAttribute("TaxationSystem" , ToXMLString(CommonParameters.TaxationSystem));
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteStartElement("Positions");
	For Each Item In CommonParameters.FiscalStrings Do
		XMLWriter.WriteStartElement("FiscalString");
		XMLWriter.WriteAttribute("AmountWithDiscount", ToXMLString(Item.AmountWithDiscount));
		XMLWriter.WriteAttribute("DiscountAmount", ToXMLString(Item.DiscountAmount));
		If Item.Property("MarkingCode") Then
			XMLWriter.WriteAttribute("MarkingCode", ToXMLString(Item.MarkingCode));
		EndIf;
		XMLWriter.WriteAttribute("MeasureOfQuantity", ToXMLString(Item.MeasureOfQuantity));
		XMLWriter.WriteAttribute("Name", ToXMLString(Item.Name));
		XMLWriter.WriteAttribute("Quantity", ToXMLString(Item.Quantity));
		XMLWriter.WriteAttribute("PaymentMethod", ToXMLString(Item.PaymentMethod));
		XMLWriter.WriteAttribute("PriceWithDiscount", ToXMLString(Item.PriceWithDiscount));
		XMLWriter.WriteAttribute("VATRate", ToXMLString(Item.VATRate));
		XMLWriter.WriteAttribute("VATAmount", ToXMLString(Item.VATAmount));
		If Item.Property("CalculationAgent") Then
			XMLWriter.WriteAttribute("CalculationAgent", ToXMLString(Item.CalculationAgent));
		EndIf;
		If Item.Property("VendorData") Then
			XMLWriter.WriteStartElement("VendorData");
			XMLWriter.WriteAttribute("VendorINN", ToXMLString(Item.VendorData.VendorINN));
			XMLWriter.WriteAttribute("VendorName", ToXMLString(Item.VendorData.VendorName));
			XMLWriter.WriteAttribute("VendorPhone", ToXMLString(Item.VendorData.VendorPhone));
			XMLWriter.WriteEndElement();
		EndIf;
		XMLWriter.WriteEndElement();
	EndDo;
	For Each Item In CommonParameters.TextStrings Do
		XMLWriter.WriteStartElement("TextString");
		XMLWriter.WriteAttribute("Text", ToXMLString(Item.Text));
		XMLWriter.WriteEndElement();
	EndDo;
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteStartElement("Payments");
	XMLWriter.WriteAttribute("Cash", ToXMLString(CommonParameters.Cash));
	XMLWriter.WriteAttribute("ElectronicPayment", ToXMLString(CommonParameters.ElectronicPayment));
	XMLWriter.WriteAttribute("PrePayment", ToXMLString(CommonParameters.PrePayment));
	XMLWriter.WriteAttribute("PostPayment", ToXMLString(CommonParameters.PostPayment));
	XMLWriter.WriteAttribute("Barter", ToXMLString(CommonParameters.Barter));
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteEndElement();
	
	Return XMLWriter.Close();
	
EndFunction

Function PrintTextGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("Document");
	
	XMLWriter.WriteStartElement("Positions");
	For Each Item In CommonParameters.TextStrings Do
		XMLWriter.WriteStartElement("TextString");
		XMLWriter.WriteAttribute("Text", ToXMLString(Item.Text));
		XMLWriter.WriteEndElement();
	EndDo;
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteEndElement();
	
	Return XMLWriter.Close();
	
EndFunction

Function ToXMLString(Data)
	// @skip-check Undefined function
	Return XMLString(Data);
EndFunction

#EndRegion
	