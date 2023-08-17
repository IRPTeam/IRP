#Region MainFunctions

// Open shift.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
Async Function OpenShift(ConsolidatedRetailSales) Export

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	//@skip-check module-unused-local-variable
	LineLength = 0;
	LineLengthSettings = EquipmentFiscalPrinterAPIClient.GetLineLengthSettings();
	If Await EquipmentFiscalPrinterAPIClient.GetLineLength(CRS.FiscalPrinter, LineLengthSettings) Then
		LineLength = LineLengthSettings.Out.LineLength;
	EndIf;

	DataKKTSettings = EquipmentFiscalPrinterAPIClient.GetDataKKTSettings();
	DataKKTSettings.Info.CRS = ConsolidatedRetailSales;
	If Not Await EquipmentFiscalPrinterAPIClient.GetDataKKT(CRS.FiscalPrinter, DataKKTSettings) Then
		CommonFunctionsClientServer.ShowUsersMessage(DataKKTSettings.Info.Error);
		Raise "Can not get data KKT";
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 1);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	OpenShiftSettings = EquipmentFiscalPrinterAPIClient.OpenShiftSettings();
	OpenShiftSettings.In.InputParameters = InputParameters;
	Await EquipmentFiscalPrinterAPIClient.OpenShift(CRS.FiscalPrinter, OpenShiftSettings);

	Return OpenShiftSettings;
EndFunction

Async Function CloseShift(ConsolidatedRetailSales) Export
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 4);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CloseShiftSettings = EquipmentFiscalPrinterAPIClient.CloseShiftSettings();
	CloseShiftSettings.In.InputParameters = InputParameters;
	Await EquipmentFiscalPrinterAPIClient.CloseShift(CRS.FiscalPrinter, CloseShiftSettings);

	Return CloseShiftSettings;
EndFunction

Async Function PrintXReport(ConsolidatedRetailSales) Export
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	PrintXReportSettings = EquipmentFiscalPrinterAPIClient.PrintXReportSettings();
	PrintXReportSettings.In.InputParameters = InputParameters;
	Await EquipmentFiscalPrinterAPIClient.PrintXReport(CRS.FiscalPrinter, PrintXReportSettings);

	Return PrintXReportSettings;
EndFunction

// Process check.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReturnReceipt -
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
Async Function ProcessCheck(ConsolidatedRetailSales, DataSource) Export
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

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
		EndIf;
	EndIf;

	CheckPackage = EquipmentFiscalPrinterAPIClient.CheckPackage();
	EquipmentFiscalPrinterServer.FillData(DataSource, CheckPackage);

	ProcessCheckSettings = EquipmentFiscalPrinterAPIClient.ProcessCheckSettings();
	ProcessCheckSettings.In.CheckPackage = CheckPackage;
	If Await EquipmentFiscalPrinterAPIClient.ProcessCheck(CRS.FiscalPrinter, ProcessCheckSettings) Then
		DataPresentation = String(ProcessCheckSettings.Out.DocumentOutputParameters.ShiftNumber) + " " + ProcessCheckSettings.Out.DocumentOutputParameters.DateTime;
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource,PredefinedValue("Enum.DocumentFiscalStatuses.Printed"), ProcessCheckSettings, DataPresentation);
	Else
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.FiscalReturnedError"), ProcessCheckSettings);
	EndIf;

	Return ProcessCheckSettings;
EndFunction

// Print check copy.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailSalesReceipt -
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.PrintCheckCopySettings
Async Function PrintCheckCopy(ConsolidatedRetailSales, DataSource) Export
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource); // See InformationRegisters.DocumentFiscalStatus.GetStatusData
	If Not StatusData.IsPrinted Then
		Raise R().EqFP_DocumentNotPrintedOnFiscal;
	EndIf;

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	PrintCheckCopySettings = EquipmentFiscalPrinterAPIClient.PrintCheckCopySettings();
	PrintCheckCopySettings.In.CheckNumber = StatusData.CheckNumber;
	Await EquipmentFiscalPrinterAPIClient.PrintCheckCopy(CRS.FiscalPrinter, PrintCheckCopySettings);

	Return PrintCheckCopySettings;
EndFunction

// Cash in come.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales - Consolidated retail sales
//  DataSource - DocumentRef.CashReceipt - Data source
//  Amount - Number - Amount
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings
Async Function CashInCome(ConsolidatedRetailSales, DataSource, Amount) Export
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();
	CashInOutcomeSettings.In.Amount = Amount;
	CashInOutcomeSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.CashInOutcome(CRS.FiscalPrinter, CashInOutcomeSettings) Then
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource,
						, PredefinedValue("Enum.DocumentFiscalStatuses.Printed")
						, CashInOutcomeSettings);
	Else
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.FiscalReturnedError"), CashInOutcomeSettings);
	EndIf;

	Return CashInOutcomeSettings;
EndFunction

// Cash out come.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales - Consolidated retail sales
//  DataSource - DocumentRef.MoneyTransfer, DocumentRef.CashPayment - Data source
//  Amount - Number - Amount
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings
Async Function CashOutCome(ConsolidatedRetailSales, DataSource, Amount) Export
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();
	CashInOutcomeSettings.In.Amount = -Amount;
	CashInOutcomeSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.CashInOutcome(CRS.FiscalPrinter, CashInOutcomeSettings) Then
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.Printed"));
	Else
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.FiscalReturnedError"), CashInOutcomeSettings);
	EndIf;

	Return CashInOutcomeSettings;
EndFunction

// Print text document.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales, Structure - Consolidated retail sales
//  DocumentPackage - See EquipmentFiscalPrinterAPIClient.DocumentPackage
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
Async Function PrintTextDocument(ConsolidatedRetailSales, DocumentPackage) Export
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter");
	If CRS.FiscalPrinter.isEmpty() Then
		Raise R().EqFP_FiscalDeviceIsEmpty;
	EndIf;

	PrintTextDocumentSettings = EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings();
	PrintTextDocumentSettings.In.DocumentPackage = DocumentPackage;

	// If nothing to print - skip
	If DocumentPackage.TextString.Count() = 0 And IsBlankString(DocumentPackage.Barcode.Value) Then
		PrintTextDocumentSettings.Info.Success = True;
		Return PrintTextDocumentSettings;
	EndIf;

	Await EquipmentFiscalPrinterAPIClient.PrintTextDocument(CRS.FiscalPrinter, PrintTextDocumentSettings);

	Return PrintTextDocumentSettings;
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

// Get current status.
//
// Parameters:
//  CRS - DocumentRef.ConsolidatedRetailSales
//  InputParameters - See InputParameters
//  WaitForStatus - Number -  Wait for status
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings
Async Function GetCurrentStatus(CRS, Val InputParameters, WaitForStatus)
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = CurrentStatusSettings.Out.OutputParameters;
		If ShiftData.ShiftState = WaitForStatus Then
			CurrentStatusSettings.Info.Success = True;
			Return CurrentStatusSettings;
		ElsIf WaitForStatus = 4 Then
			If ShiftData.ShiftState = 2 OR ShiftData.ShiftState = 3 Then
				CurrentStatusSettings.Info.Success = True;
				Return CurrentStatusSettings;
			EndIf;
		EndIf;
		If ShiftData.ShiftState = 1 Then
			CurrentStatusSettings.Info.Error = R().EqFP_ShiftAlreadyClosed;
		ElsIf ShiftData.ShiftState = 2 Then
			CurrentStatusSettings.Info.Error = R().EqFP_ShiftAlreadyOpened;
		ElsIf ShiftData.ShiftState = 3 Then
			CurrentStatusSettings.Info.Error = R().EqFP_ShiftIsExpired;
		EndIf;
	EndIf;
	Return CurrentStatusSettings;
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

Procedure FillDataFromDeviceResponse(Data, DeviceResponse) Export
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

Function ToXMLString(Data)
	// @skip-check Undefined function
	Return XMLString(Data);
EndFunction

#EndRegion
