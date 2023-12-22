
// Open shift.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
Async Function OpenShift(ConsolidatedRetailSales) Export
	
	StatusData = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "Posted");
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	OpenShiftSettings = EquipmentFiscalPrinterAPIClient.OpenShiftSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
	If Not CRS.Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.New") Then
		OpenShiftSettings.Info.Error = R().InfoMessage_CanOpenOnlyNewStatus;
		Return OpenShiftSettings;
	EndIf;
	
	If CRS.FiscalPrinter.isEmpty() Then
		OpenShiftSettings.Out.OutputParameters.DateTime = CommonFunctionsServer.GetCurrentSessionDate();
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
	
	StatusData = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "Posted");
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	CloseShiftSettings = EquipmentFiscalPrinterAPIClient.CloseShiftSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
	If Not CRS.Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.Open") Then
		CloseShiftSettings.Info.Error = R().InfoMessage_CanCloseOnlyOpenStatus;
		Return CloseShiftSettings;
	EndIf;

	If CRS.FiscalPrinter.isEmpty() Then
		CloseShiftSettings.Out.OutputParameters.DateTime = CommonFunctionsServer.GetCurrentSessionDate();
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
	If TypeOf(ConsolidatedRetailSales) = Type("DocumentRef.ConsolidatedRetailSales") Then
		StatusData = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "Posted");
		If Not StatusData.Posted Then
			Raise R().EqFP_CannotPrintNotPosted;
		EndIf;
	EndIf;

	PrintXReportSettings = EquipmentFiscalPrinterAPIClient.PrintXReportSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
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

// Process correction check.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailReceiptCorrection -
//
// Returns:
//  See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
Async Function ProcessCorrectionCheck(ConsolidatedRetailSales, DataSource) Export
	ValidateProcessCheck(DataSource);
	
	ProcessCheckSettings = EquipmentFiscalPrinterAPIClient.ProcessCheckSettings();
	ProcessCheckSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
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
	
	BasisDocument = CommonFunctionsServer.GetRefAttribute(DataSource,"BasisDocument");
	
	isReverse = Not TypeOf(BasisDocument) = Type("DocumentRef.RetailReceiptCorrection");
	If isReverse Then
		isReturn = Not TypeOf(BasisDocument) = Type("DocumentRef.RetailReturnReceipt");
	Else
		isReturn = TypeOf(CommonFunctionsServer.GetRefAttribute(BasisDocument,"BasisDocument")) = Type("DocumentRef.RetailReturnReceipt");
	EndIf;
	
	ControlOnCorresction = False;
	If ControlOnCorresction Then
		CodeStringList = EquipmentFiscalPrinterServer.GetMarkingCode(DataSource);
	
		If Not CodeStringList.Count() = 0 Then
			CheckControlStrings = Await CheckControlStrings(DataSource, CRS, isReturn, CodeStringList);
	
			If Not CheckControlStrings.Info.Success Then
				Return CheckControlStrings;
			EndIf;
		EndIf;
	EndIf;
			
	ProcessCheckSettings.In.CheckPackage = CheckPackage;
	If Await EquipmentFiscalPrinterAPIClient.ProcessCorrectionCheck(CRS.FiscalPrinter, ProcessCheckSettings) Then
		DataPresentation = String(ProcessCheckSettings.Out.DocumentOutputParameters.ShiftNumber) + " " + ProcessCheckSettings.Out.DocumentOutputParameters.DateTime;
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.Printed"), ProcessCheckSettings, DataPresentation);
	Else
		EquipmentFiscalPrinterServer.SetFiscalStatus(DataSource, PredefinedValue("Enum.DocumentFiscalStatuses.FiscalReturnedError"), ProcessCheckSettings);
	EndIf;

	Return ProcessCheckSettings;
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
	ValidateProcessCheck(DataSource);
	
	ProcessCheckSettings = EquipmentFiscalPrinterAPIClient.ProcessCheckSettings();
	ProcessCheckSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
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
		CodeStringList = EquipmentFiscalPrinterServer.GetMarkingCode(DataSource);
	
		If Not CodeStringList.Count() = 0 Then
			CheckControlStrings = Await CheckControlStrings(DataSource, CRS, isReturn, CodeStringList);
	
			If Not CheckControlStrings.Info.Success Then
				Return CheckControlStrings;
			EndIf;
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

Procedure ValidateProcessCheck(DataSource)
	StatusData = EquipmentFiscalPrinterServer.GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;
	
	If TypeOf(DataSource) = Type("DocumentRef.RetailSalesReceipt")
		OR TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt")
		OR TypeOf(DataSource) = Type("DocumentRef.RetailReceiptCorrection")
		 Then
	
		StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "StatusType, Posted, DeletionMark");
		
		If Not StatusData.StatusType = PredefinedValue("Enum.RetailReceiptStatusTypes.Completed") Then
			Raise R().EqFP_CanPrintOnlyComplete;
		EndIf;
		
		If TypeOf(DataSource) = Type("DocumentRef.RetailReceiptCorrection") Then
			StatusData.Posted = Not StatusData.DeletionMark;
		EndIf;
		
	Else
		StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "Posted");
	EndIf;
	
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
EndProcedure

//@skip-check function-should-return-value
Async Function CheckControlStrings(DataSource, CRS, isReturn, CodeStringList)
	
	Result = New Structure("Info", New Structure("Success", True));
	
	OpenSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKMSettings();
	If Not Await EquipmentFiscalPrinterAPIClient.OpenSessionRegistrationKM(CRS.FiscalPrinter, OpenSessionRegistrationKMSettings) Then
		OpenSessionRegistrationKMSettings.Info.Error = OpenSessionRegistrationKMSettings.Info.Error + Chars.LF + R().EqFP_CanNotOpenSessionRegistrationKM;
		Return OpenSessionRegistrationKMSettings;
	EndIf;

	ArrayForApprove = New Array; // Array Of String
	For Each CodeString In CodeStringList Do
		RequestKMSettings = EquipmentFiscalPrinterAPIClient.RequestKMInput(isReturn);
		RequestKMSettings.MarkingCode = CodeString;
		RequestKMSettings.Quantity = 1;
		CheckResult = Await CheckKM(CRS.FiscalPrinter, RequestKMSettings); // See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings
		If Not CheckResult.Info.Success Then
			CloseSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKMSettings();
			Await EquipmentFiscalPrinterAPIClient.CloseSessionRegistrationKM(CRS.FiscalPrinter, CloseSessionRegistrationKMSettings);
			Return CheckResult;
		EndIf;

		If Not CheckResult.Info.Approved Then
			CheckResult.Info.Error = CheckResult.Info.Error + Chars.LF + StrTemplate(R().EqFP_ProblemWhileCheckCodeString, GetStringFromBinaryData(Base64Value(RequestKMSettings.MarkingCode)));
			Return CheckResult;
		EndIf;
		ArrayForApprove.Add(RequestKMSettings.GUID);
	EndDo;

	For Each ApproveUUID In ArrayForApprove Do
		ConfirmKMSettings = EquipmentFiscalPrinterAPIClient.ConfirmKMSettings();
		ConfirmKMSettings.In.GUID = ApproveUUID;
		If Not Await EquipmentFiscalPrinterAPIClient.ConfirmKM(CRS.FiscalPrinter, ConfirmKMSettings) Then
			ConfirmKMSettings.Info.Error = ConfirmKMSettings.Info.Error + Chars.LF + StrTemplate(R().EqFP_ErrorWhileConfirmCode, ApproveUUID);
			Return ConfirmKMSettings
		EndIf;
	EndDo;
	
	Return Result;
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

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
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

	StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "Posted");
	
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();
	CashInOutcomeSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
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
	
	StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "Posted");
	
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings();
	CashInOutcomeSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status");
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
Async Function CheckKM(Hardware, RequestKM) Export

	RequestKMSettings = EquipmentFiscalPrinterAPIClient.RequestKMSettings();
	RequestKMSettings.In.RequestKM = RequestKM;
	If Not Await EquipmentFiscalPrinterAPIClient.RequestKM(Hardware, RequestKMSettings) Then
		RequestKMSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_CanNotRequestKM;
		Return RequestKMSettings;
	EndIf;

	ResultIsCorrect = False;
	For Index = 0 To 5 Do
		CommonFunctionsServer.Pause(2);

		GetProcessingKMResultSettings = EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings();
		GetProcessingKMResultSettings.Info.GUID = RequestKMSettings.In.RequestKM.GUID;
		If Not Await EquipmentFiscalPrinterAPIClient.GetProcessingKMResult(Hardware, GetProcessingKMResultSettings) Then
			GetProcessingKMResultSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_CanNotGetProcessingKMResult;
			Return GetProcessingKMResultSettings;
		EndIf;

		If GetProcessingKMResultSettings.Out.RequestStatus = 2 Then
			GetProcessingKMResultSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_GetWrongAnswerFromProcessingKM;
			Return GetProcessingKMResultSettings;
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

	If Not ResultIsCorrect Then
		GetProcessingKMResultSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_GetWrongAnswerFromProcessingKM;
		Return GetProcessingKMResultSettings;
	EndIf;

	GetProcessingKMResultSettings.Info.Approved = HardwareClient.GetAPIModule(Hardware).isCodeStringApproved(GetProcessingKMResultSettings);

	If RequestKMSettings.In.RequestKM.MarkingCode = "TestFalseString"
		OR RequestKMSettings.In.RequestKM.MarkingCode = "VGVzdEZhbHNlU3RyaW5n" Then

		GetProcessingKMResultSettings.Info.Approved = False;
	ElsIf RequestKMSettings.In.RequestKM.MarkingCode = "RiseTestFalseString"
		OR RequestKMSettings.In.RequestKM.MarkingCode = "UmlzZVRlc3RGYWxzZVN0cmluZw==" Then
	
		Raise "RiseTestFalseString";
	EndIf;

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
Async Function GetCurrentStatus(CRS, Val InputParameters, WaitForStatus) Export
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClient.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	CurrentStatusSettings.Info.CRS = CRS;
	If Await EquipmentFiscalPrinterAPIClient.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
		ShiftData = CurrentStatusSettings.Out.OutputParameters;
		CurrentStatusSettings.Info.Success = False;
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
