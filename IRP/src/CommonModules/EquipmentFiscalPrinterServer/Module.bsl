// @strict-types

#Region Public

// Open shift.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetOpenShiftSettings
Function OpenShift(ConsolidatedRetailSales) Export
	
	StatusData = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "Posted");
	//@skip-check property-return-type
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	OpenShiftSettings = EquipmentFiscalPrinterAPIClientServer.GetOpenShiftSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If Not CRS.Status = Enums.ConsolidatedRetailSalesStatuses.New Then
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
	LineLengthSettings = EquipmentFiscalPrinterAPIClientServer.GetLineLengthSettings();
	If EquipmentFiscalPrinterAPIServer.GetLineLength(CRS.FiscalPrinter, LineLengthSettings) Then
		LineLength = LineLengthSettings.Out.LineLength;
	EndIf;

	DataKKTSettings = EquipmentFiscalPrinterAPIClientServer.GetDataKKTSettings();
	DataKKTSettings.Info.CRS = ConsolidatedRetailSales;
	If Not EquipmentFiscalPrinterAPIServer.GetDataKKT(CRS.FiscalPrinter, DataKKTSettings) Then
		CommonFunctionsClientServer.ShowUsersMessage(DataKKTSettings.Info.Error);
              Raise R().CannotGetDataKKT;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = GetCurrentStatus(CRS, InputParameters, 1);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	OpenShiftSettings.In.InputParameters = InputParameters;
	EquipmentFiscalPrinterAPIServer.OpenShift(CRS.FiscalPrinter, OpenShiftSettings);

	Return OpenShiftSettings;
EndFunction

// Close shift.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetCloseShiftSettings
Function CloseShift(ConsolidatedRetailSales) Export
	
	StatusData = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "Posted");
	//@skip-check property-return-type
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	CloseShiftSettings = EquipmentFiscalPrinterAPIClientServer.GetCloseShiftSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If Not CRS.Status = Enums.ConsolidatedRetailSalesStatuses.Open Then
		CloseShiftSettings.Info.Error = R().InfoMessage_CanCloseOnlyOpenStatus;
		Return CloseShiftSettings;
	EndIf;

	If CRS.FiscalPrinter.isEmpty() Then
		CloseShiftSettings.Out.OutputParameters.DateTime = CommonFunctionsServer.GetCurrentSessionDate();
		CloseShiftSettings.Info.Success = True;
		Return CloseShiftSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = GetCurrentStatus(CRS, InputParameters, 4);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CloseShiftSettings.In.InputParameters = InputParameters;
	EquipmentFiscalPrinterAPIServer.CloseShift(CRS.FiscalPrinter, CloseShiftSettings);

	Return CloseShiftSettings;
EndFunction

// Process check.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReturnReceipt -
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings
Function ProcessCheck(ConsolidatedRetailSales, DataSource) Export
	ValidateProcessCheck(DataSource);
	
	ProcessCheckSettings = EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings();
	ProcessCheckSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If CRS.FiscalPrinter.isEmpty() Then
		ProcessCheckSettings.Info.Success = True;
		Return ProcessCheckSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CheckPackage = EquipmentFiscalPrinterAPIClientServer.CheckPackage();
	FillData(DataSource, CheckPackage);
	
	If TypeOf(DataSource) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt") Then
		
		isReturn = TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt");
		CodeStringList = GetMarkingCode(DataSource);
	
		If Not CodeStringList.Count() = 0 Then
			CheckControlStrings = CheckControlStrings(DataSource, CRS, isReturn, CodeStringList);
	
			If Not CheckControlStrings.Info.Success Then
				Return CheckControlStrings;
			EndIf;
		EndIf;
	EndIf;			
			
	ProcessCheckSettings.In.CheckPackage = CheckPackage;
	If EquipmentFiscalPrinterAPIServer.ProcessCheck(CRS.FiscalPrinter, ProcessCheckSettings) Then
		DataPresentation = String(ProcessCheckSettings.Out.DocumentOutputParameters.ShiftNumber) + " " + ProcessCheckSettings.Out.DocumentOutputParameters.DateTime;
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.Printed, ProcessCheckSettings, DataPresentation);
	Else
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.FiscalReturnedError, ProcessCheckSettings);
	EndIf;

	Return ProcessCheckSettings;
EndFunction

// Process correction check.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailReceiptCorrection -
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings
Function ProcessCorrectionCheck(ConsolidatedRetailSales, DataSource) Export
	ValidateProcessCheck(DataSource);
	
	ProcessCheckSettings = EquipmentFiscalPrinterAPIClientServer.GetProcessCheckSettings();
	ProcessCheckSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If CRS.FiscalPrinter.isEmpty() Then
		ProcessCheckSettings.Info.Success = True;
		Return ProcessCheckSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CheckPackage = EquipmentFiscalPrinterAPIClientServer.CheckPackage();
	FillData(DataSource, CheckPackage);
	
	BasisDocument = CommonFunctionsServer.GetRefAttribute(DataSource,"BasisDocument"); // DocumentRef.RetailReturnReceipt
	
	isReturn = False;
	isReverse = Not TypeOf(BasisDocument) = Type("DocumentRef.RetailReceiptCorrection");
	If isReverse Then
		isReturn = Not TypeOf(BasisDocument) = Type("DocumentRef.RetailReturnReceipt");
	Else
		isReturn = TypeOf(CommonFunctionsServer.GetRefAttribute(BasisDocument, "BasisDocument")) = Type("DocumentRef.RetailReturnReceipt");
	EndIf;
	
	ControlOnCorresction = False;
	If ControlOnCorresction Then
		CodeStringList = GetMarkingCode(DataSource);
	
		If Not CodeStringList.Count() = 0 Then
			CheckControlStrings = CheckControlStrings(DataSource, CRS, isReturn, CodeStringList);
	
			If Not CheckControlStrings.Info.Success Then
				Return CheckControlStrings;
			EndIf;
		EndIf;
	EndIf;
			
	ProcessCheckSettings.In.CheckPackage = CheckPackage;
	If EquipmentFiscalPrinterAPIServer.ProcessCorrectionCheck(CRS.FiscalPrinter, ProcessCheckSettings) Then
		DataPresentation = String(ProcessCheckSettings.Out.DocumentOutputParameters.ShiftNumber) + " " + ProcessCheckSettings.Out.DocumentOutputParameters.DateTime;
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.Printed, ProcessCheckSettings, DataPresentation);
	Else
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.FiscalReturnedError, ProcessCheckSettings);
	EndIf;

	Return ProcessCheckSettings;
EndFunction

// Print X-report.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetPrintXReportSettings
Function PrintXReport(ConsolidatedRetailSales) Export
	If TypeOf(ConsolidatedRetailSales) = Type("DocumentRef.ConsolidatedRetailSales") Then
		StatusData = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "Posted");
		//@skip-check property-return-type
		If Not StatusData.Posted Then
			Raise R().EqFP_CannotPrintNotPosted;
		EndIf;
	EndIf;

	PrintXReportSettings = EquipmentFiscalPrinterAPIClientServer.GetPrintXReportSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If CRS.FiscalPrinter.isEmpty() Then
		PrintXReportSettings.Info.Success = True;
		Return PrintXReportSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	PrintXReportSettings.In.InputParameters = InputParameters;
	EquipmentFiscalPrinterAPIServer.PrintXReport(CRS.FiscalPrinter, PrintXReportSettings);

	Return PrintXReportSettings;
EndFunction

// Print check copy.
//
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
//  DataSource - DocumentRef.RetailSalesReceipt -
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetPrintCheckCopySettings
Function PrintCheckCopy(ConsolidatedRetailSales, DataSource) Export
	StatusData = GetStatusData(DataSource); // See InformationRegisters.DocumentFiscalStatus.GetStatusData
	If Not StatusData.IsPrinted Then
		Raise R().EqFP_DocumentNotPrintedOnFiscal;
	EndIf;

	PrintCheckCopySettings = EquipmentFiscalPrinterAPIClientServer.GetPrintCheckCopySettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If CRS.FiscalPrinter.isEmpty() Then
		PrintCheckCopySettings.Info.Success = True;
		Return PrintCheckCopySettings;
	EndIf;

	PrintCheckCopySettings.In.CheckNumber = StatusData.CheckNumber;
	EquipmentFiscalPrinterAPIServer.PrintCheckCopy(CRS.FiscalPrinter, PrintCheckCopySettings);

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
//  See EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings
Function CashInCome(ConsolidatedRetailSales, DataSource, Amount) Export
	StatusData = GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;

	StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "Posted"); // DocumentRef.CashReceipt
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings();
	CashInOutcomeSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If CRS.FiscalPrinter.isEmpty() Then
		CashInOutcomeSettings.Info.Success = True;
		Return CashInOutcomeSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CashInOutcomeSettings.In.Amount = Amount;
	CashInOutcomeSettings.In.InputParameters = InputParameters;
	If EquipmentFiscalPrinterAPIServer.CashInOutcome(CRS.FiscalPrinter, CashInOutcomeSettings) Then
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.Printed, CashInOutcomeSettings);
	Else
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.FiscalReturnedError, CashInOutcomeSettings);
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
//  See EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings
Function CashOutCome(ConsolidatedRetailSales, DataSource, Amount) Export
	StatusData = GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;
	
	StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "Posted"); // DocumentRef.CashPayment
	If Not StatusData.Posted Then
		Raise R().EqFP_CannotPrintNotPosted;
	EndIf;
	
	CashInOutcomeSettings = EquipmentFiscalPrinterAPIClientServer.GetCashInOutcomeSettings();
	CashInOutcomeSettings.Info.Document = DataSource;
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author, Ref, Status"); // DocumentRef.ConsolidatedRetailSales
	If CRS.FiscalPrinter.isEmpty() Then
		CashInOutcomeSettings.Info.Success = True;
		Return CashInOutcomeSettings;
	EndIf;

	InputParameters = EquipmentFiscalPrinterAPIClientServer.InputParameters();
	FillInputParameters(ConsolidatedRetailSales, InputParameters);

	CurrentStatus = GetCurrentStatus(CRS, InputParameters, 2);
	If Not CurrentStatus.Info.Success Then
		Return CurrentStatus;
	EndIf;

	CashInOutcomeSettings.In.Amount = -Amount;
	CashInOutcomeSettings.In.InputParameters = InputParameters;
	If EquipmentFiscalPrinterAPIServer.CashInOutcome(CRS.FiscalPrinter, CashInOutcomeSettings) Then
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.Printed);
	Else
		SetFiscalStatus(DataSource, Enums.DocumentFiscalStatuses.FiscalReturnedError, CashInOutcomeSettings);
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
//  See EquipmentFiscalPrinterAPIClientServer.GetPrintTextDocumentSettings
Function PrintTextDocument(ConsolidatedRetailSales, DocumentPackage) Export

	PrintTextDocumentSettings = EquipmentFiscalPrinterAPIClientServer.GetPrintTextDocumentSettings();

	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter"); // DocumentRef.ConsolidatedRetailSales
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

	EquipmentFiscalPrinterAPIServer.PrintTextDocument(CRS.FiscalPrinter, PrintTextDocumentSettings);

	Return PrintTextDocumentSettings;
EndFunction

// Check KM.
//
// Parameters:
//  Hardware - CatalogRef.Hardware -
//  RequestKMInput - See EquipmentFiscalPrinterAPIClient.RequestKMInput
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings
Function CheckKM(Hardware, RequestKM) Export

	RequestKMSettings = EquipmentFiscalPrinterAPIClientServer.GetRequestKMSettings();
	RequestKMSettings.In.RequestKM = RequestKM;
	If Not EquipmentFiscalPrinterAPIServer.RequestKM(Hardware, RequestKMSettings) Then
		RequestKMSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_CanNotRequestKM;
		Return RequestKMSettings;
	EndIf;

	ResultIsCorrect = False;
	For Index = 0 To 5 Do
		CommonFunctionsServer.Pause(2);

		ProcessingKMResultSettings = EquipmentFiscalPrinterAPIClientServer.GetProcessingKMResultSettings();
		ProcessingKMResultSettings.Info.GUID = RequestKMSettings.In.RequestKM.GUID;
		If Not EquipmentFiscalPrinterAPIServer.GetProcessingKMResult(Hardware, ProcessingKMResultSettings) Then
			ProcessingKMResultSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_CanNotGetProcessingKMResult;
			Return ProcessingKMResultSettings;
		EndIf;

		If ProcessingKMResultSettings.Out.RequestStatus = 2 Then
			ProcessingKMResultSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_GetWrongAnswerFromProcessingKM;
			Return ProcessingKMResultSettings;
		EndIf;

		If ProcessingKMResultSettings.Out.RequestStatus = 1 Then
			Continue;
		EndIf;

		If Not RequestKM.GUID = ProcessingKMResultSettings.Out.ProcessingKMResult.GUID Then
			Continue;
		EndIf;

		ResultIsCorrect = True;
		Break;
	EndDo;

	If Not ResultIsCorrect Then
		ProcessingKMResultSettings.Info.Error = RequestKMSettings.Info.Error + Chars.LF + R().EqFP_GetWrongAnswerFromProcessingKM;
		Return ProcessingKMResultSettings;
	EndIf;

	ProcessingKMResultSettings.Info.Approved = EquipmentFiscalPrinterAPIServer.isCodeStringApproved(Hardware, ProcessingKMResultSettings);

	If RequestKMSettings.In.RequestKM.MarkingCode = "TestFalseString"
		OR RequestKMSettings.In.RequestKM.MarkingCode = "VGVzdEZhbHNlU3RyaW5n" Then

		ProcessingKMResultSettings.Info.Approved = False;
        ElsIf RequestKMSettings.In.RequestKM.MarkingCode = "RiseTestFalseString"
                OR RequestKMSettings.In.RequestKM.MarkingCode = "UmlzZVRlc3RGYWxzZVN0cmluZw==" Then

                Raise R().RiseTestFalseString;
        EndIf;

	Return ProcessingKMResultSettings;
EndFunction

// Fill data.
//
// Parameters:
//  SourceData - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReturnReceipt, DocumentRef.RetailReceiptCorrection, DocumentRef.CashReceipt -
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
Procedure FillData(SourceData, CheckPackage) Export
	If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt")
		OR TypeOf(SourceData.Ref) = Type("DocumentRef.RetailReturnReceipt") 
		OR TypeOf(SourceData.Ref) = Type("DocumentRef.RetailReceiptCorrection") Then
		FillCheckPackageByRetailReceipt(SourceData, CheckPackage);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.CashReceipt")
		OR TypeOf(SourceData.Ref) = Type("DocumentRef.CashPayment") Then
		FillCheckPackageByPayment(SourceData, CheckPackage, True);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.BankReceipt")
		OR TypeOf(SourceData.Ref) = Type("DocumentRef.BankPayment") Then
		FillCheckPackageByPayment(SourceData, CheckPackage, False);
	EndIf;
EndProcedure

// Prepare receipt data by retail receipt.
//
// Parameters:
//  SourceData - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReceiptCorrection -
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
Procedure FillCheckPackageByRetailReceipt(Val SourceData, CheckPackage) Export
	
	isCorrection = TypeOf(SourceData.Ref) = Type("DocumentRef.RetailReceiptCorrection");
	
	If isCorrection Then
		
		CheckPackage.Parameters.AdditionalAttribute = SourceData.BasisDocumentFiscalNumber;
		
		isReverse = Not TypeOf(SourceData.BasisDocument) = Type("DocumentRef.RetailReceiptCorrection");
		DocumentWithCorrectionInfo = SourceData;
		If isReverse Then
			If TypeOf(SourceData.BasisDocument) = Type("DocumentRef.RetailSalesReceipt") Then
				CheckPackage.Parameters.OperationType = 2;
			Else
				CheckPackage.Parameters.OperationType = 1;
			EndIf;
		Else
			If TypeOf(SourceData.BasisDocument.BasisDocument) = Type("DocumentRef.RetailSalesReceipt") Then
				CheckPackage.Parameters.OperationType = 1;
			Else
				CheckPackage.Parameters.OperationType = 2;
			EndIf;
			DocumentWithCorrectionInfo = SourceData.BasisDocument;
		EndIf;
		
		CheckPackage.Parameters.CorrectionData.Type = DocumentWithCorrectionInfo.CorrectionType;
		CheckPackage.Parameters.CorrectionData.Description = DocumentWithCorrectionInfo.CorrectionDescription;
		CheckPackage.Parameters.CorrectionData.Date = DocumentWithCorrectionInfo.Date;
		CheckPackage.Parameters.CorrectionData.Number = DocumentWithCorrectionInfo.NumberTaxAuthorityPrescription;
		
		If IsBlankString(CheckPackage.Parameters.CorrectionData.Number) Then
			CheckPackage.Parameters.CorrectionData.Number = "0";
		EndIf;
		
                If IsBlankString(CheckPackage.Parameters.CorrectionData.Description) Then
                        Raise R().CorrectionDescriptionRequired;
                EndIf;
		
	Else
		CheckPackage.Parameters.CorrectionData = New Structure();
		If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
			CheckPackage.Parameters.OperationType = 1;
		Else
			CheckPackage.Parameters.OperationType = 2;
		EndIf;		
	EndIf;

	FillInputParameters(SourceData, CheckPackage.Parameters);
	
	CheckPackage.Parameters.TaxationSystem = 0;	//TODO: TaxSystem choice

	If Not SourceData.RetailCustomer.IsEmpty() Then

		CheckPackage.Parameters.CustomerEmail = SourceData.RetailCustomer.Email;
		CheckPackage.Parameters.CustomerPhone = SourceData.RetailCustomer.Code;
	
		CheckPackage.Parameters.CustomerDetail.DateOfBirth = Format(SourceData.RetailCustomer.BirthDate, "DF=dd.MM.yyyy;");
		CheckPackage.Parameters.CustomerDetail.Info = String(SourceData.RetailCustomer);
		CheckPackage.Parameters.CustomerDetail.INN = SourceData.RetailCustomer.TaxID;
		
	EndIf;

	For Each ItemRow In SourceData.ItemList Do
		RowFilter = New Structure();
		RowFilter.Insert("Key", ItemRow.Key);

		CCSRows = SourceData.ControlCodeStrings.FindRows(RowFilter);

		FiscalStringData = CommonFunctionsServer.DeserializeJSON(CheckPackage.Positions.FiscalStringJSON); // See EquipmentFiscalPrinterAPIClient.CheckPackage_FiscalString
		FiscalStringData.AmountWithDiscount = ItemRow.TotalAmount;
		FiscalStringData.DiscountAmount = ItemRow.OffersAmount;
		
		// TODO: Get from ItemType (or Item) CalculationSubject
		If ItemRow.isControlCodeString And Not isCorrection Then
			FillControlString(CCSRows, ItemRow, FiscalStringData);
			FillIndustryAttribute(CCSRows, FiscalStringData);
		Else
			If ItemRow.Item.ItemType.Type = Enums.ItemTypes.Certificate Then
				FiscalStringData.CalculationSubject = 10;
			Else
				FiscalStringData.CalculationSubject = 1;	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			EndIf;
		EndIf;
		
		FiscalStringData.MeasureOfQuantity = 255;
		FiscalStringData.MeasureOfQuantityRef = ItemRow.Unit.UOM;
		
		Name = GenerateItemName(SourceData, ItemRow);
		FiscalStringData.Name = StrConcat(Name, " ");

		FiscalStringData.Quantity = ItemRow.Quantity;
		
		FillPaymentType(SourceData, FiscalStringData, ItemRow);
		
		FiscalStringData.PriceWithDiscount = Round(ItemRow.TotalAmount / ItemRow.Quantity, 2);
		
		FillVatRate(ItemRow, FiscalStringData);
		
		FillConsignor(FiscalStringData, ItemRow);
		
		CheckPackage.Positions.FiscalStrings.Add(FiscalStringData);
	EndDo;

	FillPayments(SourceData, CheckPackage);

	If SessionParameters.Workstation.PrintBarcodeWithDocumentUUID Then
		CheckPackage.Positions.Barcode.Value = BarcodeServer.GetDocumentBarcode(SourceData);
	EndIf;

	// TODO: Fix
	isEmulator = StrStartsWith(SourceData.ConsolidatedRetailSales.FiscalPrinter.Driver.AddInID, "AddIn.Modul_KKT");
	If isEmulator Then
		For Each Row In CheckPackage.Positions.FiscalStrings Do
			If Row.CalculationSubject = 33 Then
				Row.CalculationSubject = 1;
			EndIf;
		EndDo;
	EndIf;

	CheckPackage.Positions.FiscalStringJSON = "";

EndProcedure

// Fill check package by payment.
//
// Parameters:
//  SourceData - DocumentRef.CashPayment, DocumentRef.CashReceipt, DocumentRef.BankReceipt, DocumentRef.BankPayment -
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
//  isCash - Boolean - is cash payment
Procedure FillCheckPackageByPayment(SourceData, CheckPackage, isCash)

	FillInputParameters(SourceData, CheckPackage.Parameters);
	CheckPackage.Parameters.TaxationSystem = 0;	//TODO: TaxSystem choice

	If SourceData.TransactionType = Enums.OutgoingPaymentTransactionTypes.RetailCustomerAdvance Then
		CheckPackage.Parameters.OperationType = 2;
	ElsIf SourceData.TransactionType = Enums.IncomingPaymentTransactionType.RetailCustomerAdvance Then
		CheckPackage.Parameters.OperationType = 1;
	Else
            Raise R().UnknownTransactionType;
	EndIf;

	PaymentListData = SourceData.PaymentList.Unload();
	PaymentListData.GroupBy("RetailCustomer");
       If PaymentListData.Count() > 1 Then
               Raise R().FewRetailCustomerFound;
       EndIf;
	RetailCustomer = PaymentListData[0].RetailCustomer;
	If Not RetailCustomer.IsEmpty() Then

		CheckPackage.Parameters.CustomerEmail = RetailCustomer.Email;
		CheckPackage.Parameters.CustomerPhone = RetailCustomer.Code;
	
		CheckPackage.Parameters.CustomerDetail.DateOfBirth = Format(RetailCustomer.BirthDate, "DF=dd.MM.yyyy;");
		CheckPackage.Parameters.CustomerDetail.Info = String(RetailCustomer);
		CheckPackage.Parameters.CustomerDetail.INN = RetailCustomer.TaxID;
		
	EndIf;

	For Each Item In SourceData.PaymentList Do
		RowFilter = New Structure();
		RowFilter.Insert("Key", Item.Key);
		FiscalStringData = CommonFunctionsServer.DeserializeJSON(CheckPackage.Positions.FiscalStringJSON); // See EquipmentFiscalPrinterAPIClient.CheckPackage_FiscalString
		FiscalStringData.AmountWithDiscount = Item.TotalAmount;
		FiscalStringData.DiscountAmount = 0;
		FiscalStringData.CalculationSubject = 10;	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
		FiscalStringData.MeasureOfQuantity = 255;
		FiscalStringData.MeasureOfQuantityRef = Catalogs.UnitsOfMeasurement.EmptyRef();
		FiscalStringData.Name = String(RetailCustomer);
		FiscalStringData.Quantity = 1;
		FiscalStringData.PaymentMethod = 3;
		FiscalStringData.PriceWithDiscount = Item.TotalAmount;
		
		If ValueIsFilled(Item.VatRate) Then
			If Item.VatRate.NoRate Then
				FiscalStringData.VATRate = "none";
				FiscalStringData.VATAmount = 0;
			Else
				FiscalStringData.VATRate = Format(Item.VatRate.Rate, "NZ=0; NG=0;");
				FiscalStringData.VATAmount = Item.TaxAmount;
			EndIf;
		Else
			FiscalStringData.VATRate = "none";
			FiscalStringData.VATAmount = 0;
		EndIf;
		
		CheckPackage.Positions.FiscalStrings.Add(FiscalStringData);
	EndDo;

	If isCash Then
		CheckPackage.Payments.Cash = SourceData.PaymentList.Total("TotalAmount");
	Else
		CheckPackage.Payments.ElectronicPayment = SourceData.PaymentList.Total("TotalAmount");
	EndIf;
EndProcedure

// Fill document package.
//
// Parameters:
//  SourceData - DocumentRef.RetailSalesReceipt - Source data
//  DocumentPackage - See EquipmentFiscalPrinterAPIClient.DocumentPackage
Procedure FillDocumentPackage(SourceData, DocumentPackage) Export

	For Each Payment In SourceData.Payments Do
		TextString = "";
		If TypeOf(Payment.PaymentInfo) = Type("String") Then
			If IsBlankString(Payment.PaymentInfo) Then
				Continue;
			EndIf;
			PaymentInfo = CommonFunctionsServer.DeserializeJSON(Payment.PaymentInfo); // See EquipmentAcquiringAPIClient.SettlementSettings
		Else
			PaymentInfo = Payment.PaymentInfo;
		EndIf;
		If PaymentInfo.Property("Out")
			And	PaymentInfo.Out.Property("Slip") Then
			TextString = PaymentInfo.Out.Slip;
		Else
			Continue;
		EndIf;

		If IsBlankString(TextString) Then
			Continue;
		EndIf;

		For Each Text In StrSplit(TextString, Chars.LF, True) Do
			DocumentPackage.TextString.Add(Text);
		EndDo;
	EndDo;

EndProcedure

// Set fiscal status.
//
// Parameters:
//  DocumentRef - DocumentRefDocumentName - Document ref
//  Status - EnumRef.DocumentFiscalStatuses - Document status
//  FiscalResponse - See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
//  DataPresentation - String -  Data presentation
Procedure SetFiscalStatus(DocumentRef, Status, FiscalResponse = Undefined, DataPresentation = "") Export

	If FiscalResponse = Undefined Then
		FiscalResponse = New Structure;
	EndIf;

	InformationRegisters.DocumentFiscalStatus.SetStatus(DocumentRef, Status, FiscalResponse, DataPresentation);
EndProcedure

// Get status data.
//
// Parameters:
//  DocumentRef - DocumentRefDocumentName - Document ref
//
// Returns:
//  See InformationRegisterManager.DocumentFiscalStatus.GetStatusData
Function GetStatusData(DocumentRef) Export
	FiscalStatus = InformationRegisters.DocumentFiscalStatus.GetStatusData(DocumentRef);
	Return FiscalStatus;
EndFunction

// Get marking code.
//
// Parameters:
//  DocumentRef - DocumentRef.RetailReturnReceipt, DocumentRef.RetailSalesReceipt, DocumentRef.RetailReceiptCorrection -
//
// Returns:
//  Array Of String
Function GetMarkingCode(DocumentRef) Export
	Array = New Array; // Array Of String
	For Each Row In DocumentRef.ControlCodeStrings Do

		If Row.NotCheck Then
			Continue;
		EndIf;

		If Not Row.ControlCodeStringType = Enums.ControlCodeStringType.MarkingCode Then
			Continue;
		EndIf;
		
		Array.Add(Row.CodeString);
	EndDo;
	Return Array;
EndFunction

// Fill input parameters.
//
// Parameters:
//  Ref - DocumentRef.RetailSalesReceipt, DocumentRef.ConsolidatedRetailSales -
//  InputParameters - See EquipmentFiscalPrinterAPIClient.InputParameters
Procedure FillInputParameters(Ref, InputParameters) Export
	InputParameters.CashierName = Ref.Author.Partner.Description_ru;

	If IsBlankString(InputParameters.CashierName) Then
		//@skip-check property-return-type
		Raise R().EqFP_CashierNameCanNotBeEmpty;
	EndIf;

	InputParameters.CashierINN = Ref.Author.Partner.TaxID;
	If TypeOf(Ref) = Type("DocumentRef.ConsolidatedRetailSales")
		OR (TypeOf(Ref) = Type("Structure")	AND Ref.Property("FiscalPrinter")) Then
		InputParameters.SaleAddress = Ref.FiscalPrinter.SaleAddress;
		InputParameters.SaleLocation = Ref.FiscalPrinter.SaleLocation;
	Else
		InputParameters.SaleAddress = Ref.ConsolidatedRetailSales.FiscalPrinter.SaleAddress;
		InputParameters.SaleLocation = Ref.ConsolidatedRetailSales.FiscalPrinter.SaleLocation;
	EndIf;
EndProcedure

// Validate process check.
// 
// Parameters:
//  DataSource - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReturnReceipt, DocumentRef.RetailReceiptCorrection, AnyRef - Data source
Procedure ValidateProcessCheck(DataSource)
	StatusData = GetStatusData(DataSource);
	If StatusData.IsPrinted Then
		Raise R().EqFP_DocumentAlreadyPrinted;
	EndIf;
	
	If TypeOf(DataSource) = Type("DocumentRef.RetailSalesReceipt")
		OR TypeOf(DataSource) = Type("DocumentRef.RetailReturnReceipt")
		OR TypeOf(DataSource) = Type("DocumentRef.RetailReceiptCorrection")
		 Then
	
		StatusData = CommonFunctionsServer.GetAttributesFromRef(DataSource, "StatusType, Posted, DeletionMark"); // DocumentRef.RetailReceiptCorrection
		
		If Not StatusData.StatusType = Enums.RetailReceiptStatusTypes.Completed Then
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

// Check control strings.
// 
// Parameters:
//  DataSource - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReceiptCorrection - Data source
//  CRS - DocumentRef.ConsolidatedRetailSales - CRS
//  isReturn - Boolean - Is return
//  CodeStringList - Array of String - Code string list
// 
// Returns:
//  Structure - Check control strings:
// * Info - Structure - :
// ** Success - Boolean - 
Function CheckControlStrings(DataSource, CRS, isReturn, CodeStringList)
	
	Result = New Structure("Info", New Structure("Success", True));
	
	OpenSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClientServer.GetOpenSessionRegistrationKMSettings();
	If Not EquipmentFiscalPrinterAPIServer.OpenSessionRegistrationKM(CRS.FiscalPrinter, OpenSessionRegistrationKMSettings) Then
		OpenSessionRegistrationKMSettings.Info.Error = OpenSessionRegistrationKMSettings.Info.Error + Chars.LF + R().EqFP_CanNotOpenSessionRegistrationKM;
		Return OpenSessionRegistrationKMSettings;
	EndIf;

	ArrayForApprove = New Array; // Array Of String
	For Each CodeString In CodeStringList Do
		RequestKMSettings = EquipmentFiscalPrinterAPIClientServer.RequestKMInput(isReturn);
		RequestKMSettings.MarkingCode = CodeString;
		RequestKMSettings.Quantity = 1;
		CheckResult = CheckKM(CRS.FiscalPrinter, RequestKMSettings); // See EquipmentFiscalPrinterAPIClient.GetProcessingKMResultSettings
		If Not CheckResult.Info.Success Then
			CloseSessionRegistrationKMSettings = EquipmentFiscalPrinterAPIClientServer.GetCloseSessionRegistrationKMSettings();
			EquipmentFiscalPrinterAPIServer.CloseSessionRegistrationKM(CRS.FiscalPrinter, CloseSessionRegistrationKMSettings);
			Return CheckResult;
		EndIf;

		If Not CheckResult.Info.Approved Then
			CheckResult.Info.Error = CheckResult.Info.Error + Chars.LF + StrTemplate(R().EqFP_ProblemWhileCheckCodeString, GetStringFromBinaryData(Base64Value(RequestKMSettings.MarkingCode)));
			Return CheckResult;
		EndIf;
		ArrayForApprove.Add(RequestKMSettings.GUID);
	EndDo;

	For Each ApproveUUID In ArrayForApprove Do
		ConfirmKMSettings = EquipmentFiscalPrinterAPIClientServer.GetConfirmKMSettings();
		ConfirmKMSettings.In.GUID = ApproveUUID;
		If Not EquipmentFiscalPrinterAPIServer.ConfirmKM(CRS.FiscalPrinter, ConfirmKMSettings) Then
			ConfirmKMSettings.Info.Error = ConfirmKMSettings.Info.Error + Chars.LF + StrTemplate(R().EqFP_ErrorWhileConfirmCode, ApproveUUID);
			Return ConfirmKMSettings
		EndIf;
	EndDo;
	
	Return Result;
EndFunction

// Get current status.
//
// Parameters:
//  CRS - DocumentRef.ConsolidatedRetailSales
//  InputParameters - See EquipmentFiscalPrinterAPIClientServer.InputParameters
//  WaitForStatus - Number -  Wait for status
//
// Returns:
//  See EquipmentFiscalPrinterAPIClientServer.GetCurrentStatusSettings
Function GetCurrentStatus(CRS, Val InputParameters, WaitForStatus) Export
	CurrentStatusSettings = EquipmentFiscalPrinterAPIClientServer.GetCurrentStatusSettings();
	CurrentStatusSettings.In.InputParameters = InputParameters;
	CurrentStatusSettings.Info.CRS = CRS;
	If EquipmentFiscalPrinterAPIServer.GetCurrentStatus(CRS.FiscalPrinter, CurrentStatusSettings) Then
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

#EndRegion

#Region Service

Procedure FillConsignor(FiscalStringData, ItemRow)
	If ValueIsFilled(ItemRow.Consignor) Then
		FiscalStringData.VendorData.VendorINN = ItemRow.Consignor.TaxID;
		FiscalStringData.VendorData.VendorName = ItemRow.Consignor.LocalFullDescription;
		FiscalStringData.VendorData.VendorPhone = ItemRow.Consignor.MainPhoneNumber;
		FiscalStringData.CalculationAgent = 5;
	EndIf;
	
	If FiscalStringData.CalculationAgent = 5 Then
		If IsBlankString(FiscalStringData.VendorData.VendorINN)
			OR IsBlankString(FiscalStringData.VendorData.VendorName) Then
				Raise StrTemplate(R().Error_047, "VendorINN, VendorName");
		EndIf;
	EndIf;
EndProcedure

Procedure FillVatRate(ItemRow, FiscalStringData)
	If ValueIsFilled(ItemRow.VatRate) Then
		If ItemRow.VatRate.NoRate Then
			FiscalStringData.VATRate = "none";
			FiscalStringData.VATAmount = 0;
		Else
			FiscalStringData.VATRate = Format(ItemRow.VatRate.Rate, "NZ=0; NG=0;");
			FiscalStringData.VATAmount = ItemRow.TaxAmount;
		EndIf;
	Else
		FiscalStringData.VATRate = "none";
		FiscalStringData.VATAmount = 0;
	EndIf;
EndProcedure

Function GenerateItemName(SourceData, ItemRow)
	Name = New Array; // Array Of String
	Name.Add(String(ItemRow.Item));
	If Not String(ItemRow.Item) = String(ItemRow.ItemKey) Then
		Name.Add(String(ItemRow.ItemKey));
	EndIf;
	
	SearchSerial = SourceData.SerialLotNumbers.FindRows(New Structure("Key", ItemRow.Key));
	If SearchSerial.Count() > 0 Then
		SerialName = New Array; // Array Of String
		For Each Serial In SearchSerial Do
			SerialName.Add(String(Serial.SerialLotNumber));
		EndDo;
		Name.Add("[" + StrConcat(SerialName, ",") + "]");
	EndIf;
	Return Name;
EndFunction

Procedure FillPaymentType(SourceData, FiscalStringData, ItemRow)
	If SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullPrepayment Then
		FiscalStringData.PaymentMethod = 1;
	ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.PartialPrepayment Then
		FiscalStringData.PaymentMethod = 2;
	ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.AdvancePayment Then
		FiscalStringData.PaymentMethod = 3;
	ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation Then
		FiscalStringData.PaymentMethod = 4;
	ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.PartialSettlementAndCredit Then
		FiscalStringData.PaymentMethod = 5;
	ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.TransferOnCredit Then
		FiscalStringData.PaymentMethod = 6;
	ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.LoanPayment Then
		FiscalStringData.PaymentMethod = 7;
	Else
		FiscalStringData.PaymentMethod = 4;
	EndIf;
	
	If ItemRow.Item.ItemType.Type = Enums.ItemTypes.Certificate Then
		FiscalStringData.PaymentMethod = 3;
	EndIf;
EndProcedure

// @skip-check statement-type-change, property-return-type
Procedure FillIndustryAttribute(CCSRows, FiscalStringData)
	If Not IsBlankString(CCSRows[0].IndustryAttribute) Then
		IndustryAttribute = CommonFunctionsServer.DeserializeJSON(CCSRows[0].IndustryAttribute); // Structure
		FiscalStringData.IndustryAttribute.AttributeValue = IndustryAttribute.AttributeValue;
		FiscalStringData.IndustryAttribute.DocumentDate = IndustryAttribute.DocumentDate;
		FiscalStringData.IndustryAttribute.DocumentNumber = IndustryAttribute.DocumentNumber;
		FiscalStringData.IndustryAttribute.IdentifierFOIV = IndustryAttribute.IdentifierFOIV;
	EndIf;
EndProcedure

Procedure FillControlString(CCSRows, ItemRow, FiscalStringData)
	If CCSRows.Count() = 0 Then
                Raise StrTemplate(R().ControlStringCodeNotFilled, ItemRow.LineNumber);
	ElsIf Not CCSRows.Count() = ItemRow.Quantity Then
                Raise StrTemplate(R().ControlStringCodeCountMismatch, ItemRow.LineNumber);
	ElsIf CCSRows.Count() > 1 Then // TODO: Fix this
                Raise StrTemplate(R().ControlStringMultipleRowsNotSupported, ItemRow.LineNumber);
	ElsIf CCSRows[0].NotCheck And CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.MarkingCode Then
		// Not check and not send
		FiscalStringData.CalculationSubject = 1;
	Else
		CodeString = CCSRows[0].CodeString;
		If CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.None Then
                        Raise R().CannotFiscalizeCCSTypeNone;
		ElsIf CCSRows[0].ControlCodeStringType.IsEmpty() Then
                        Raise R().CannotFiscalizeCCSTypeEmpty;
		ElsIf CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.MarkingCode Then
			FiscalStringData.MarkingCode = ControlCodeStringServer.GetMarkingCodeString(CodeString);
		ElsIf CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.GoodCodeData Then
			FiscalStringData.GoodCodeData.Insert(CCSRows[0].Prefix, CodeString);
		Else
                        Raise R().UnknownControlCodeStringType;
		EndIf;
		FiscalStringData.CalculationSubject = 33;	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
	EndIf;
EndProcedure

Procedure FillPayments(SourceData, CheckPackage)
	For Each Payment In SourceData.Payments Do
			If Payment.Amount < 0 Then
				Continue;
			EndIf;
	
			If SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullPrepayment Then
				CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
			ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.PartialPrepayment Then
				CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
			ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.AdvancePayment Then
				CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
			ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation Then
				If Payment.PaymentType.Type = Enums.PaymentTypes.Cash Then
					CheckPackage.Payments.Cash = CheckPackage.Payments.Cash + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Card Then
					CheckPackage.Payments.ElectronicPayment = CheckPackage.Payments.ElectronicPayment + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.PaymentAgent Then
					CheckPackage.Payments.PostPayment = CheckPackage.Payments.PostPayment + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Advance Then
					CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Certificate Then
					CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
				Else
					CheckPackage.Payments.Cash = CheckPackage.Payments.Cash + Payment.Amount;
				EndIf;
			Else
				If Payment.PaymentType.Type = Enums.PaymentTypes.Cash Then
					CheckPackage.Payments.Cash = CheckPackage.Payments.Cash + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Card Then
					CheckPackage.Payments.ElectronicPayment = CheckPackage.Payments.ElectronicPayment + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.PaymentAgent Then
					CheckPackage.Payments.PostPayment = CheckPackage.Payments.PostPayment + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Advance Then
					CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
				ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Certificate Then
					CheckPackage.Payments.PrePayment = CheckPackage.Payments.PrePayment + Payment.Amount;
				Else
					CheckPackage.Payments.Cash = CheckPackage.Payments.Cash + Payment.Amount;
				EndIf;
			EndIf;
		EndDo;
EndProcedure

#EndRegion
