// @strict-types

#Region Public

// Fill data.
//
// Parameters:
//  SourceData - DocumentRef.RetailSalesReceipt, DocumentRef.RetailReturnReceipt, DocumentRef.CashReceipt -
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
			Raise "CorrectionDescription has to be filled.";
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
		Raise "Unknown transaction type";
	EndIf;

	PaymentListData = SourceData.PaymentList.Unload();
	PaymentListData.GroupBy("RetailCustomer");
	If PaymentListData.Count() > 1 Then
		Raise("A few retail customer found!");
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
//  DocumentRef - DocumentRef.RetailReturnReceipt, DocumentRef.RetailSalesReceipt -
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

Procedure FillControlString(CCSRows, ItemRow, FiscalStringData)
	If CCSRows.Count() = 0 Then
		Raise "Control string code not filled. Row: " + ItemRow.LineNumber;
	ElsIf Not CCSRows.Count() = ItemRow.Quantity Then
		Raise "Control string code count not the same as item quantity. Row: " + ItemRow.LineNumber;
	ElsIf CCSRows.Count() > 1 Then // TODO: Fix this
		Raise "Not suppoted send more then 1 control code by each row. Row: " + ItemRow.LineNumber;
	ElsIf CCSRows[0].NotCheck And CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.MarkingCode Then
		// Not check and not send
		FiscalStringData.CalculationSubject = 1;
	Else
		CodeString = CCSRows[0].CodeString;
		If CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.None Then
			Raise "Can not fiscalize item with Control Code String Type as None. Select type in item, or switch off Control string";
		ElsIf CCSRows[0].ControlCodeStringType.IsEmpty() Then
			Raise "Can not fiscalize item while Control Code String Type is Empty. Select type in item, or switch off Control string";
		ElsIf CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.MarkingCode Then
			FiscalStringData.MarkingCode = ControlCodeStringServer.GetMarkingCodeString(CodeString);
		ElsIf CCSRows[0].ControlCodeStringType = Enums.ControlCodeStringType.GoodCodeData Then
			FiscalStringData.GoodCodeData.Insert(CCSRows[0].Prefix, CodeString);
		Else
			Raise "Unknown ControlCodeStringType";
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
