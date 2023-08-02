#Region MainFunctions

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
	
	//@skip-check module-unused-local-variable
	LineLength = 0;
	LineLengthSettings = EquipmentFiscalPrinterAPIClient.GetLineLengthSettings();
	If Await EquipmentFiscalPrinterAPIClient.GetLineLength(CRS.FiscalPrinter, LineLengthSettings) Then
		LineLength = LineLengthSettings.Out.LineLength;
	EndIf;
			
	DataKKTSettings = EquipmentFiscalPrinterAPIClient.GetDataKKTSettings();
	If Not Await EquipmentFiscalPrinterAPIClient.GetDataKKT(CRS.FiscalPrinter, DataKKTSettings) Then
		CommonFunctionsClientServer.ShowUsersMessage(DataKKTSettings.Info.Error);
		Raise "Can not get data KKT";
	EndIf;
	ShiftGetXMLOperationSettings = EquipmentFiscalPrinterServer.ShiftGetXMLOperationSettings(ConsolidatedRetailSales);
	InputParameters = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);

#Region GetCurrentStatus	
	
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CurrentStatusSettings.Out.OutputParameters);
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
		Result.ErrorDescription = CurrentStatusSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion

#Region OpenShift 
	
	OpenShiftSettings = EquipmentFiscalPrinterAPIClient.OpenShiftSettings();
	OpenShiftSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.OpenShift(CRS.FiscalPrinter, OpenShiftSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, OpenShiftSettings.Out.OutputParameters);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		Result.ErrorDescription = OpenShiftSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion

	Return Result;
EndFunction

Async Function CloseShift(ConsolidatedRetailSales) Export
	Result = ShiftResultStructure();
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	
	ShiftGetXMLOperationSettings = EquipmentFiscalPrinterServer.ShiftGetXMLOperationSettings(ConsolidatedRetailSales);
	InputParameters = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);

#Region GetCurrentStatus	
		
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CurrentStatusSettings.Out.OutputParameters);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then

		ElsIf ShiftData.ShiftState = 3 Then
			
		EndIf;
	Else
		Result.ErrorDescription = CurrentStatusSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion
	
#Region CloseShift

	CloseShiftSettings = EquipmentFiscalPrinterAPIClient.CloseShiftSettings();
	CloseShiftSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.CloseShift(CRS.FiscalPrinter, CloseShiftSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CloseShiftSettings.Out.OutputParameters);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		Result.ErrorDescription = CloseShiftSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion

	Return Result;
EndFunction

Async Function PrintXReport(ConsolidatedRetailSales) Export
	Result = ShiftResultStructure();
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
		
	ShiftGetXMLOperationSettings = EquipmentFiscalPrinterServer.ShiftGetXMLOperationSettings(ConsolidatedRetailSales);
	InputParameters = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
#Region GetCurrentStatus	
		
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CurrentStatusSettings.Out.OutputParameters);
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
		Result.ErrorDescription = CurrentStatusSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion

#Region PrintXReport
	PrintXReportSettings = EquipmentFiscalPrinterAPIClient.PrintXReportSettings();
	PrintXReportSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.PrintXReport(CRS.FiscalPrinter, PrintXReportSettings) Then
		Result.Success = True;
	Else
		Result.ErrorDescription = PrintXReportSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion
	
	Return Result;
EndFunction

// Process check.
// 
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailSalesReceipt -
// 
// Returns:
//  See EquipmentFiscalPrinterClient.ReceiptResultStructure
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
		
	XMLOperationSettings = EquipmentFiscalPrinterServer.ShiftGetXMLOperationSettings(DataSource);
	InputParameters = ShiftGetXMLOperation(XMLOperationSettings);
	
#Region GetCurrentStatus	
		
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CurrentStatusSettings.Out.OutputParameters);
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
		Result.Status = "FiscalReturnedError";
		Result.ErrorDescription = CurrentStatusSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion
	
	If TypeOf(DataSource) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt") Then
		isReturn = TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt");
		CodeStringList = EquipmentFiscalPrinterServer.GetStringCode(DataSource);
		
		If CodeStringList.Count() > 0 Then
			OpenSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKMSettings();
			If Not Await EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKM(CRS.FiscalPrinter, OpenSessionRegistrationKMSettings) Then
				CommonFunctionsClientServer.ShowUsersMessage(OpenSessionRegistrationKMSettings.Info.Error);
				Raise R().EqFP_CanNotOpenSessionRegistrationKM;
			EndIf;
			
			ArrayForApprove = New Array; // Array Of String
			For Each CodeString In EquipmentFiscalPrinterServer.GetStringCode(DataSource) Do
				RequestKMSettings = RequestKMSettingsInfo(isReturn);
				RequestKMSettings.MarkingCode = CodeString;
				RequestKMSettings.Quantity = 1;
				CheckResult = Await Device_CheckKM(CRS.FiscalPrinter, RequestKMSettings, False);
				If Not CheckResult.Approved Then
					Raise StrTemplate(R().EqFP_ProblemWhileCheckCodeString, GetStringFromBinaryData(Base64Value(RequestKMSettings.MarkingCode)));
				EndIf;
				ArrayForApprove.Add(RequestKMSettings.GUID);
			EndDo;
			
			For Each ApproveUUID In ArrayForApprove Do
				ConfirmKMSettings = EquipmentFiscalPrinterAPIClient.ConfirmKMSettings();
				ConfirmKMSettings.In.GUID = ApproveUUID;
				If Not Await EquipmentFiscalPrinterAPIClient.ConfirmKM(CRS.FiscalPrinter, ConfirmKMSettings) Then
					CommonFunctionsClientServer.ShowUsersMessage(ConfirmKMSettings.Info.Error);
					Raise StrTemplate(R().EqFP_ErrorWhileConfirmCode, ApproveUUID);
				EndIf;
			EndDo;
			
//			CloseSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKMSettings();
//			If Not Await EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKM(CRS.FiscalPrinter, CloseSessionRegistrationKMSettings) Then
//				CommonFunctionsClientServer.ShowUsersMessage(CloseSessionRegistrationKMSettings.Info.Error);
//				Raise R().EqFP_CanNotCloseSessionRegistrationKM;
//			EndIf;
			
		EndIf;
	EndIf;
	
	XMLOperationSettings = ReceiptGetXMLOperationSettings(DataSource);
	CheckPackage = ReceiptGetXMLOperation(XMLOperationSettings);
	
	ProcessCheckSettings = EquipmentFiscalPrinterAPIClient.ProcessCheckSettings();
	ProcessCheckSettings.In.CheckPackage = CheckPackage;
	If Await EquipmentFiscalPrinterAPIClient.ProcessCheck(CRS.FiscalPrinter, ProcessCheckSettings) Then
		ReceiptData = ReceiptResultStructure();
		FillDataFromDeviceResponse(ReceiptData, ProcessCheckSettings.Out.DocumentOutputParameters);
		ReceiptData.Status = "Printed";
		ReceiptData.DataPresentation = " " + Result.ShiftNumber + " " + Result.DateTime;
		ReceiptData.FiscalResponse = ProcessCheckSettings.Out.DocumentOutputParameters;
		ReceiptData.Success = True;
		FillPropertyValues(Result, ReceiptData);
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource
						, Result.Status
						, ReceiptData
						, " " + Result.ShiftNumber + " " + Result.DateTime);
	Else
		Result.ErrorDescription = ProcessCheckSettings.Info.Error;
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, Result.Status, Result.ErrorDescription);
		
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

// Print check copy.
// 
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailSalesReceipt -
// 
// Returns:
//  See EquipmentFiscalPrinterClient.ReceiptResultStructure
Async Function PrintCheckCopy(ConsolidatedRetailSales, DataSource) Export
	Result = ReceiptResultStructure();
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource); // See InformationRegisters.DocumentFiscalStatus.GetStatusData
	If Not StatusData.IsPrinted Then
		Result.Status = StatusData.Status;
		Result.DataPresentation = StatusData.DataPresentation;
		Result.FiscalResponse = StatusData.FiscalResponse;
		Result.Success = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_DocumentNotPrintedOnFiscal);
		Return Result;
	EndIf;
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Result.Success = True;
		Return Result;
	EndIf;
	
	PrintCheckCopySettings = EquipmentFiscalPrinterAPIClient.PrintCheckCopySettings();
	PrintCheckCopySettings.In.CheckNumber = StatusData.CheckNumber;
	If Await EquipmentFiscalPrinterAPIClient.PrintCheckCopy(CRS.FiscalPrinter, PrintCheckCopySettings) Then
		Result.Status = "Printed";
		Result.Success = True;
	Else
		Result.ErrorDescription = PrintCheckCopySettings.Info.Error;
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CashInCome(ConsolidatedRetailSales, DataSource, Amount) Export
	Result = ShiftResultStructure();
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
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
	ShiftGetXMLOperationSettings = EquipmentFiscalPrinterServer.ShiftGetXMLOperationSettings(DataSource);
	InputParameters = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
#Region GetCurrentStatus	
		
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CurrentStatusSettings.Out.OutputParameters);
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
		Result.ErrorDescription = CurrentStatusSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
#EndRegion	
	
	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();
	CashInOutcomeSettings.In.Amount = Amount;
	CashInOutcomeSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.CashInOutcome(CRS.FiscalPrinter, CashInOutcomeSettings) Then
		Result.Status = "Printed";
		Result.Success = True;
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, Result.Status);
	Else
		Result.ErrorDescription = CashInOutcomeSettings.Info.Error;
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, Result.Status, Result.ErrorDescription);
						
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CashOutCome(ConsolidatedRetailSales, DataSource, Amount) Export
	Result = ShiftResultStructure();
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
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
	
	ShiftGetXMLOperationSettings = EquipmentFiscalPrinterServer.ShiftGetXMLOperationSettings(DataSource);
	InputParameters = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
#Region GetCurrentStatus	
		
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, CurrentStatusSettings.Out.OutputParameters);
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
		Result.ErrorDescription = CurrentStatusSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;

#EndRegion
	
	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();
	CashInOutcomeSettings.In.Amount = -Amount;
	CashInOutcomeSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.CashInOutcome(CRS.FiscalPrinter, CashInOutcomeSettings) Then
		Result.Status = "Printed";
		Result.Success = True;
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, Result.Status);
	Else
		Result.ErrorDescription = CashInOutcomeSettings.Info.Error;
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, Result.Status, Result.ErrorDescription);
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
	
	XMLOperationSettings = PrintTextGetXMLOperationSettings(DataSource);
	If Not XMLOperationSettings.TextStrings.Count() Then
		Result.Success = True;
		Return Result;
	EndIf;
	
	DocumentPackage = PrintTextGetXMLOperation(XMLOperationSettings);
	
	PrintTextDocumentSettings = EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings();
	PrintTextDocumentSettings.In.DocumentPackage = DocumentPackage;
																	
	If Await EquipmentFiscalPrinterAPIClient.PrintTextDocument(CRS.FiscalPrinter, PrintTextDocumentSettings) Then
		Result.Success = True;		
	Else
		Result.ErrorDescription = PrintTextDocumentSettings.Info.Error;
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

// Request KM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware - 
//  RequestKMSettingsInfo - See RequestKMSettingsInfo
// 
// Returns:
//  See EquipmentFiscalPrinterClient.ProcessingKMResult
Async Function CheckKM(Hardware, RequestKMSettings) Export
	Return Await Device_CheckKM(Hardware, RequestKMSettings);
EndFunction

// Request KM settings.
// 
// Returns:
//  Structure - Request KMSettings:
// * GUID - String -
// * WaitForResult - Boolean -
// * MarkingCode - String -
// * PlannedStatus - Number -
// * Quantity - Number -
Function RequestKMSettingsInfo(isReturn = False) Export
	Str = New Structure;
	Str.Insert("GUID", String(New UUID()));
	Str.Insert("WaitForResult", True);
	Str.Insert("MarkingCode", "");
	Str.Insert("PlannedStatus", ?(isReturn, 3, 1));
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

#Region Check

// Device request KM.
// 
// Parameters:
//  Hardware - CatalogRef.Hardware -
//  RequestKMSettingsInfo - See RequestKMSettingsInfo
//  OpenAndClose - Boolean -
// 
// Returns:
//  See ProcessingKMResult
Async Function Device_CheckKM(Hardware, RequestKMData, OpenAndClose = True)
	
	RequestXML = RequestXML(RequestKMData);
	ProcessingKMResult = ProcessingKMResult();
	
	If OpenAndClose Then
		OpenSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKMSettings();
		If Not Await EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKM(Hardware, OpenSessionRegistrationKMSettings) Then
			CommonFunctionsClientServer.ShowUsersMessage(OpenSessionRegistrationKMSettings.Info.Error);
			Raise R().EqFP_CanNotOpenSessionRegistrationKM;
		EndIf;
	EndIf;
	
	RequestKMSettings = EquipmentFiscalPrinterAPIClient.RequestKMSettings();
	RequestKMSettings.In.RequestKM = RequestXML;
	If Not Await EquipmentFiscalPrinterAPIClient.RequestKM(Hardware, RequestKMSettings) Then
		CommonFunctionsClientServer.ShowUsersMessage(RequestKMSettings.Info.Error);
		Raise R().EqFP_CanNotRequestKM;
	EndIf;

	RequestKMResult = RequestXMLResponse(RequestKMSettings.Out.RequestKMResult);

	ResultIsCorrect = False;
	For Index = 0 To 5 Do
		CommonFunctionsServer.Pause(2);
		
		GetProcessingKMResultSettings = EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings();
		If Not Await EquipmentFiscalPrinterAPIClient.GetProcessingKMResult(Hardware, GetProcessingKMResultSettings) Then
			CommonFunctionsClientServer.ShowUsersMessage(RequestKMSettings.Info.Error);
			Raise R().EqFP_CanNotGetProcessingKMResult;
		EndIf;
		
		If GetProcessingKMResultSettings.Out.RequestStatus = 2 Then
			Raise R().EqFP_GetWrongAnswerFromProcessingKM;
		EndIf;
		
		If GetProcessingKMResultSettings.Out.RequestStatus = 1 Then
			Continue;
		EndIf; 

		If IsBlankString(GetProcessingKMResultSettings.Out.ProcessingKMResult) Then
			Continue;	
		EndIf;
		
		ProcessingKMResult = ProcessingKMResultResponse(GetProcessingKMResultSettings.Out.ProcessingKMResult);
		
		If Not ProcessingKMResult.GUID = RequestKMData.GUID Then
			Continue;
		EndIf;
		
		ResultIsCorrect = True;
		Break;
	EndDo;
	
	If OpenAndClose Then
		CloseSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKMSettings();
		If Not Await EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKM(Hardware, CloseSessionRegistrationKMSettings) Then
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
	//XMLWriter.WriteAttribute("WaitForResult" , ToXMLString(RequestKMSettingsInfo.WaitForResult));
	//XMLWriter.WriteAttribute("Quantity" , ToXMLString(RequestKMSettingsInfo.Quantity));
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

Function ReceiptResultStructure() Export
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

// Receipt get XMLOperation.
// 
// Parameters:
//  CommonParameters - See EquipmentFiscalPrinterServer.PrepareReceiptDataByRetailSalesReceipt
// 
// Returns:
//  String - Receipt get XMLOperation
Function ReceiptGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("CheckPackage");
	
	XMLWriter.WriteStartElement("Parameters");
	XMLWriter.WriteAttribute("CashierName", ?(Not IsBlankString(CommonParameters.CashierName), ToXMLString(CommonParameters.CashierName), "Administrator"));
	XMLWriter.WriteAttribute("CashierINN" , ToXMLString(CommonParameters.CashierINN));
	XMLWriter.WriteAttribute("SaleAddress" , ToXMLString(CommonParameters.SaleAddress));
	XMLWriter.WriteAttribute("SaleLocation" , ToXMLString(CommonParameters.SaleLocation));
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
		XMLWriter.WriteAttribute("CalculationSubject", ToXMLString(Item.CalculationSubject));
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
	