
// Open shift.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
Async Function OpenShift(ConsolidatedRetailSales) Export
	OpenShiftSettings = EquipmentFiscalPrinterAPIClient.OpenShiftSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		OpenShiftSettings.Info.Success = True;
		Return OpenShiftSettings;
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

	OpenShiftSettings.In.InputParameters = InputParameters;
	Await EquipmentFiscalPrinterAPIClient.OpenShift(CRS.FiscalPrinter, OpenShiftSettings);

	Return OpenShiftSettings;
EndFunction

Async Function CloseShift(ConsolidatedRetailSales) Export

	CloseShiftSettings = EquipmentFiscalPrinterAPIClient.CloseShiftSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		CloseShiftSettings.Info.Success = True;
		Return CloseShiftSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 4);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CloseShiftSettings.In.InputParameters = InputParameters;
	Await EquipmentFiscalPrinterAPIClient.CloseShift(CRS.FiscalPrinter, CloseShiftSettings);

	Return CloseShiftSettings;
EndFunction

Async Function PrintXReport(ConsolidatedRetailSales) Export

	PrintXReportSettings = EquipmentFiscalPrinterAPIClient.PrintXReportSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		PrintXReportSettings.Info.Success = True;
		Return PrintXReportSettings;
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

	ProcessCheckSettings = EquipmentFiscalPrinterAPIClient.ProcessCheckSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		ProcessCheckSettings.Info.Success = True;
		Return ProcessCheckSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CheckPackage = EquipmentFiscalPrinterAPIClient.CheckPackage();
	EquipmentFiscalPrinterServer.FillData(DataSource, CheckPackage);

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
				RequestKMSettings = EquipmentFiscalPrinterAPIClient.RequestKMInput(isReturn);
				RequestKMSettings.MarkingCode = CodeString;
				RequestKMSettings.Quantity = 1;
				CheckResult = Await CheckKM(CRS.FiscalPrinter, RequestKMSettings, False); // See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings
				If Not CheckResult.Info.Success Then
					Raise CheckResult.Info.Error;
				EndIf;

				If Not CheckResult.Info.Approved Then
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

	ProcessCheckSettings.In.CheckPackage = CheckPackage;
	If Await EquipmentFiscalPrinterAPIClient.ProcessCheck(CRS.FiscalPrinter, ProcessCheckSettings) Then
		DataPresentation = String(ProcessCheckSettings.Out.DocumentOutputParameters.ShiftNumber) + " " + ProcessCheckSettings.Out.DocumentOutputParameters.DateTime;
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.Printed"), ProcessCheckSettings, DataPresentation);
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

	PrintCheckCopySettings = EquipmentFiscalPrinterAPIClient.PrintCheckCopySettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		PrintCheckCopySettings.Info.Success = True;
		Return PrintCheckCopySettings;
	EndIf;

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

	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		CashInOutcomeSettings.Info.Success = True;
		Return CashInOutcomeSettings;
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
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.Printed"), CashInOutcomeSettings);
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

	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	If CRS.FiscalPrinter.isEmpty() Then
		CashInOutcomeSettings.Info.Success = True;
		Return CashInOutcomeSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClient.InputParameters();
	EquipmentFiscalPrinterServer.FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = Await GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

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

	PrintTextDocumentSettings = EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter");
	If CRS.FiscalPrinter.isEmpty() Then
		PrintTextDocumentSettings.Info.Success = True;
		Return PrintTextDocumentSettings;
	EndIf;

	PrintTextDocumentSettings.In.DocumentPackage = DocumentPackage;

	// If nothing to print - skip
	If DocumentPackage.TextString.Count() = 0 And IsBlankString(DocumentPackage.Barcode.Value) Then
		PrintTextDocumentSettings.Info.Success = True;
		Return PrintTextDocumentSettings;
	EndIf;

	Await EquipmentFiscalPrinterAPIClient.PrintTextDocument(CRS.FiscalPrinter, PrintTextDocumentSettings);

	Return PrintTextDocumentSettings;
EndFunction

// Check KM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware -
//  RequestKMInput - See EquipmentFiscalPrinterAPIClient.RequestKMInput
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings
Async Function CheckKM(Hardware, RequestKM, OpenAndClose = False) Export

	If OpenAndClose Then
		OpenSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKMSettings();
		If Not Await EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKM(Hardware, OpenSessionRegistrationKMSettings) Then
			CommonFunctionsClientServer.ShowUsersMessage(OpenSessionRegistrationKMSettings.Info.Error);
			Raise R().EqFP_CanNotOpenSessionRegistrationKM;
		EndIf;
	EndIf;

	RequestKMSettings = EquipmentFiscalPrinterAPIClient.RequestKMSettings();
	RequestKMSettings.In.RequestKM = RequestKM;
	If Not Await EquipmentFiscalPrinterAPIClient.RequestKM(Hardware, RequestKMSettings) Then
		CommonFunctionsClientServer.ShowUsersMessage(RequestKMSettings.Info.Error);
		Raise R().EqFP_CanNotRequestKM;
	EndIf;

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

		If Not RequestKM.GUID = GetProcessingKMResultSettings.Out.ProcessingKMResult.GUID Then
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

	GetProcessingKMResultSettings.Info.Approved = HardwareClient.GetAPIModule(Hardware).isCodeStringApproved(GetProcessingKMResultSettings);

	Return GetProcessingKMResultSettings;
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
