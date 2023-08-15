// @strict-types

#Region Public

// Fill data.
// 
// Parameters:
//  SourceData - DocumentRefDocumentName -
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
// 
// Returns:
//  Structure - Fill data:
// * Parameters - Structure -
// * Positions - Structure -
// * Payments - Structure -
// * OperationType - Number -
// * TaxationSystem - Number -
// * FiscalStrings - Array -
// * Cash - Number -
// * ElectronicPayment - Number -
// * PrePayment - Number -
// * PostPayment - Number -
// * Barter - Number -
// * TextStrings - Array -
Function FillData(SourceData, CheckPackage) Export
	ReturnData = New Structure;
	If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(SourceData.Ref) = Type("DocumentRef.RetailReturnReceipt") Then
		FillCheckPackageByRetailSalesReceipt(SourceData, CheckPackage);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.CashReceipt") Then
		ReturnData = PrepareReceiptDataByCashReceipt(SourceData, CheckPackage);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.CashPayment") Then
		ReturnData = PrepareReceiptDataByCashPayment(SourceData, CheckPackage);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.BankReceipt") Then
		ReturnData = PrepareReceiptDataByBankReceipt(SourceData, CheckPackage);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.BankPayment") Then
		ReturnData = PrepareReceiptDataByBankPayment(SourceData, CheckPackage);
	EndIf;
	Return ReturnData;
EndFunction

// Prepare receipt data by retail sales receipt.
// 
// Parameters:
//  SourceData - DocumentRef.RetailSalesReceipt -
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
Procedure FillCheckPackageByRetailSalesReceipt(SourceData, CheckPackage) Export
	FillInputParameters(SourceData, CheckPackage.Parameters);
	
	If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
		CheckPackage.Parameters.OperationType = 1;
	Else
		CheckPackage.Parameters.OperationType = 2;
	EndIf;
	CheckPackage.Parameters.TaxationSystem = 0;	//TODO: TaxSystem choice 
	
	For Each ItemRow In SourceData.ItemList Do
		RowFilter = New Structure();
		RowFilter.Insert("Key", ItemRow.Key);
		
		CCSRows = SourceData.ControlCodeStrings.FindRows(RowFilter);
		TaxRows = SourceData.TaxList.FindRows(RowFilter);
 		If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
 			CBRows = SourceData.ConsignorBatches.FindRows(RowFilter);
 		Else
 			CBRows = New Array;
 		EndIf;		
		FiscalStringData = CommonFunctionsServer.DeserializeJSON(CheckPackage.Positions.FiscalStringJSON); // See EquipmentAcquiringAPIClient.CheckPackage_FiscalString
		FiscalStringData.AmountWithDiscount = ItemRow.TotalAmount;
		FiscalStringData.DiscountAmount = ItemRow.OffersAmount;
		// TODO: Get from ItemType (or Item) CalculationSubject
		If ItemRow.isControlCodeString Then
			If CCSRows.Count() = 0 Then
				Raise "Control string code not filled. Row: " + ItemRow.LineNumber;
			ElsIf Not CCSRows.Count() = ItemRow.Quantity Then
				Raise "Control string code count not the same as item quantity. Row: " + ItemRow.LineNumber;
			ElsIf CCSRows.Count() > 1 Then // TODO: Fix this
				Raise "Not suppoted send more then 1 control code by each row. Row: " + ItemRow.LineNumber;
			ElsIf CCSRows[0].NotCheck Then
				// Not check an not send
				FiscalStringData.CalculationSubject = 1;
			Else
				CodeString = CCSRows[0].CodeString;
				If Not CommonFunctionsClientServer.isBase64Value(CodeString) Then
					CodeString = Base64String(GetBinaryDataFromString(CodeString, TextEncoding.UTF8, False));
				EndIf;
				FiscalStringData.MarkingCode = CodeString;
				FiscalStringData.CalculationSubject = 33;	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			EndIf;
		Else
			FiscalStringData.CalculationSubject = 1;	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject	
		EndIf;
		FiscalStringData.MeasureOfQuantity = "255";
		FiscalStringData.Name = String(ItemRow.Item) + " " + String(ItemRow.ItemKey);
		FiscalStringData.Quantity = ItemRow.Quantity;
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
		FiscalStringData.PriceWithDiscount = Round(ItemRow.TotalAmount / ItemRow.Quantity, 2);
		If TaxRows.Count() > 0 Then
			If TaxRows[0].TaxRate.NoRate Then
				FiscalStringData.VATRate = "none";
				FiscalStringData.VATAmount = 0;  
			Else
				FiscalStringData.VATRate = Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;");
				FiscalStringData.VATAmount = TaxRows[0].Amount;
			EndIf;
			
		Else
			Raise("Tax isn't found!");
		EndIf;
		If CBRows.Count() > 0 Then
			If TypeOf(CBRows[0].Batch) = Type("DocumentRef.OpeningEntry") Then
				FiscalStringData.VendorData.VendorINN = CBRows[0].Batch.LegalNameConsignor.TaxID;
				FiscalStringData.VendorData.VendorName = String(CBRows[0].Batch.LegalNameConsignor);
				FiscalStringData.VendorData.VendorPhone = "";
			Else
				FiscalStringData.VendorData.VendorINN = CBRows[0].Batch.LegalName.TaxID;
				FiscalStringData.VendorData.VendorName = String(CBRows[0].Batch.LegalName);
				FiscalStringData.VendorData.VendorPhone = "";
			EndIf;
			FiscalStringData.CalculationAgent = "5";
		EndIf;
		
		If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
			If Not ItemRow.Consignor.IsEmpty() Then
				FiscalStringData.VendorData.VendorINN = ItemRow.Consignor.TaxID;
				FiscalStringData.VendorData.VendorName = String(ItemRow.Consignor);
				FiscalStringData.VendorData.VendorPhone = "";
				FiscalStringData.CalculationAgent = "5";
			EndIf;
		EndIf; 
		
		CheckPackage.Positions.FiscalStrings.Add(FiscalStringData);
	EndDo;
	
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
			Else
				CheckPackage.Payments.Cash = CheckPackage.Payments.Cash + Payment.Amount;
			EndIf;
		EndIf;
	EndDo;
	
	If SessionParametersServer.GetSessionParameter("Workstation").PrintBarcodeWithDocumentUUID Then
		Str = New Structure();
		Str.Insert("POS", New Structure);
		Str.POS.Insert("Type", ?(CheckPackage.Parameters.OperationType = 1, "RSR", "RRR"));
		Str.POS.Insert("Code", String(SourceData.UUID()));
		CheckPackage.Positions.Barcode.Value = CommonFunctionsServer.SerializeJSON(Str);
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

// Prepare receipt data by cash receipt.
// 
// Parameters:
//  SourceData - DocumentRef.CashReceipt
// 
// Returns:
//  Structure - Prepare receipt data by cash receipt
Function PrepareReceiptDataByCashReceipt(SourceData, CheckPackage) Export
	
	FillInputParameters(SourceData, CheckPackage);
	CheckPackage.Insert("OperationType", 1);
	CheckPackage.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.IncomingPaymentTransactionType.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		CheckPackage.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", 10);	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			FiscalStringData.Insert("MeasureOfQuantity", "255");
			FiscalStringData.Insert("Name", "Аванс от: " + String(SourceData.PaymentList[0].RetailCustomer));
			FiscalStringData.Insert("Quantity", 1);
			FiscalStringData.Insert("PaymentMethod", 3);
			FiscalStringData.Insert("PriceWithDiscount", Item.TotalAmount);
			If TaxRows.Count() > 0 Then
				If TaxRows[0].TaxRate.NoRate Then
					FiscalStringData.Insert("VATRate", "none");
					FiscalStringData.Insert("VATAmount", 0);  
				Else
					FiscalStringData.Insert("VATRate", Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;"));
					FiscalStringData.Insert("VATAmount", TaxRows[0].Amount);
				EndIf;
			Else
				//Raise("Tax isn't found!");
				FiscalStringData.Insert("VATRate", "none");
				FiscalStringData.Insert("VATAmount", 0);
			EndIf;
			FiscalStrings.Add(FiscalStringData);
		EndDo;
	EndIf; 
	
	CheckPackage.Insert("FiscalStrings", FiscalStrings);
	CheckPackage.Insert("TextStrings", New Array);
	
	CheckPackage.Insert("Cash", SourceData.PaymentList.Total("TotalAmount"));
	CheckPackage.Insert("ElectronicPayment", 0);
	CheckPackage.Insert("PrePayment", 0);
	CheckPackage.Insert("PostPayment", 0);
	CheckPackage.Insert("Barter", 0);
	
	Return CheckPackage;
EndFunction

// Prepare receipt data by cash payment.
// 
// Parameters:
//  SourceData - DocumentRef.CashPayment
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
// 
// Returns:
//  Structure - Prepare receipt data by cash payment
Function PrepareReceiptDataByCashPayment(SourceData, CheckPackage) Export
	
	FillInputParameters(SourceData, CheckPackage);
	CheckPackage.Insert("OperationType", 2);
	CheckPackage.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.OutgoingPaymentTransactionTypes.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		CheckPackage.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", 10);	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			FiscalStringData.Insert("MeasureOfQuantity", "255");
			FiscalStringData.Insert("Name", "Аванс от: " + String(SourceData.PaymentList[0].RetailCustomer));
			FiscalStringData.Insert("Quantity", 1);
			FiscalStringData.Insert("PaymentMethod", 3);
			FiscalStringData.Insert("PriceWithDiscount", Item.TotalAmount);
			If TaxRows.Count() > 0 Then
				If TaxRows[0].TaxRate.NoRate Then
					FiscalStringData.Insert("VATRate", "none");
					FiscalStringData.Insert("VATAmount", 0);  
				Else
					FiscalStringData.Insert("VATRate", Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;"));
					FiscalStringData.Insert("VATAmount", TaxRows[0].Amount);
				EndIf;
			Else
				//Raise("Tax isn't found!");
				FiscalStringData.Insert("VATRate", "none");
				FiscalStringData.Insert("VATAmount", 0);
			EndIf;
			FiscalStrings.Add(FiscalStringData);
		EndDo;
	EndIf; 
	
	CheckPackage.Insert("FiscalStrings", FiscalStrings);
	CheckPackage.Insert("TextStrings", New Array);
	
	CheckPackage.Insert("Cash", SourceData.PaymentList.Total("TotalAmount"));
	CheckPackage.Insert("ElectronicPayment", 0);
	CheckPackage.Insert("PrePayment", 0);
	CheckPackage.Insert("PostPayment", 0);
	CheckPackage.Insert("Barter", 0);
	
	Return CheckPackage;
EndFunction

// Prepare receipt data by bank receipt.
// 
// Parameters:
//  SourceData - DocumentRef.BankReceipt
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
// 
// Returns:
//  Structure - Prepare receipt data by bank receipt
Function PrepareReceiptDataByBankReceipt(SourceData, CheckPackage) Export
	
	FillInputParameters(SourceData, CheckPackage);
	CheckPackage.Insert("OperationType", 1);
	CheckPackage.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.IncomingPaymentTransactionType.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		CheckPackage.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", 10);	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			FiscalStringData.Insert("MeasureOfQuantity", "255");
			FiscalStringData.Insert("Name", "Аванс от: " + String(SourceData.PaymentList[0].RetailCustomer));
			FiscalStringData.Insert("Quantity", 1);
			FiscalStringData.Insert("PaymentMethod", 3);
			FiscalStringData.Insert("PriceWithDiscount", Item.TotalAmount);
			If TaxRows.Count() > 0 Then
				If TaxRows[0].TaxRate.NoRate Then
					FiscalStringData.Insert("VATRate", "none");
					FiscalStringData.Insert("VATAmount", 0);  
				Else
					FiscalStringData.Insert("VATRate", Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;"));
					FiscalStringData.Insert("VATAmount", TaxRows[0].Amount);
				EndIf;
			Else
				//Raise("Tax isn't found!");
				FiscalStringData.Insert("VATRate", "none");
				FiscalStringData.Insert("VATAmount", 0);
			EndIf;
			FiscalStrings.Add(FiscalStringData);
		EndDo;
	EndIf; 
	
	CheckPackage.Insert("FiscalStrings", FiscalStrings);
	CheckPackage.Insert("TextStrings", New Array);
	
	CheckPackage.Insert("Cash", 0);
	CheckPackage.Insert("ElectronicPayment", SourceData.PaymentList.Total("TotalAmount"));
	CheckPackage.Insert("PrePayment", 0);
	CheckPackage.Insert("PostPayment", 0);
	CheckPackage.Insert("Barter", 0);
	
	Return CheckPackage;
EndFunction

// Prepare receipt data by bank payment.
// 
// Parameters:
//  SourceData - DocumentRef.BankPayment
//  CheckPackage - See EquipmentFiscalPrinterAPIClient.CheckPackage
// 
// Returns:
//  Structure - Prepare receipt data by bank payment
Function PrepareReceiptDataByBankPayment(SourceData, CheckPackage) Export
	
	FillInputParameters(SourceData, CheckPackage);
	CheckPackage.Insert("OperationType", 2);
	CheckPackage.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.OutgoingPaymentTransactionTypes.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		CheckPackage.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", 10);	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			FiscalStringData.Insert("MeasureOfQuantity", "255");
			FiscalStringData.Insert("Name", "Аванс от: " + String(SourceData.PaymentList[0].RetailCustomer));
			FiscalStringData.Insert("Quantity", 1);
			FiscalStringData.Insert("PaymentMethod", 3);
			FiscalStringData.Insert("PriceWithDiscount", Item.TotalAmount);
			If TaxRows.Count() > 0 Then
				If TaxRows[0].TaxRate.NoRate Then
					FiscalStringData.Insert("VATRate", "none");
					FiscalStringData.Insert("VATAmount", 0);  
				Else
					FiscalStringData.Insert("VATRate", Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;"));
					FiscalStringData.Insert("VATAmount", TaxRows[0].Amount);
				EndIf;
			Else
				//Raise("Tax isn't found!");
				FiscalStringData.Insert("VATRate", "none");
				FiscalStringData.Insert("VATAmount", 0);
			EndIf;
			FiscalStrings.Add(FiscalStringData);
		EndDo;
	EndIf; 
	
	CheckPackage.Insert("FiscalStrings", FiscalStrings);
	CheckPackage.Insert("TextStrings", New Array);
	
	CheckPackage.Insert("Cash", 0);
	CheckPackage.Insert("ElectronicPayment", SourceData.PaymentList.Total("TotalAmount"));
	CheckPackage.Insert("PrePayment", 0);
	CheckPackage.Insert("PostPayment", 0);
	CheckPackage.Insert("Barter", 0);
	
	Return CheckPackage;
EndFunction

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
			PaymentInfo = CommonFunctionsServer.DeserializeJSON(Payment.PaymentInfo);
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

Procedure SetFiscalStatus(DocumentRef, Status = "Prepaired", FiscalResponse = Undefined, DataPresentation = "") Export
	
	If FiscalResponse = Undefined Then
		FiscalResponse = New Structure;
	EndIf;	
	
	If Status = "Prepaired" Then
		InformationRegisters.DocumentFiscalStatus.SetStatus(DocumentRef
																, Enums.DocumentFiscalStatuses.Prepaired
																, FiscalResponse);
	ElsIf Status = "Printed" Then
		InformationRegisters.DocumentFiscalStatus.SetStatus(DocumentRef
																, Enums.DocumentFiscalStatuses.Printed
																, FiscalResponse
																, DataPresentation);
	ElsIf Status = "FiscalReturnedError" Then
		InformationRegisters.DocumentFiscalStatus.SetStatus(DocumentRef
																, Enums.DocumentFiscalStatuses.FiscalReturnedError
																, FiscalResponse);
	ElsIf Status = "NotPrinted" Then
		InformationRegisters.DocumentFiscalStatus.SetStatus(DocumentRef
																, Enums.DocumentFiscalStatuses.NotPrinted
																, FiscalResponse);
	EndIf;
EndProcedure

Function GetStatusData(DocumentRef) Export
	FiscalStatus = InformationRegisters.DocumentFiscalStatus.GetStatusData(DocumentRef);
	Return FiscalStatus;
EndFunction

// Get string code.
// 
// Parameters:
//  DocumentRef - DocumentRef.RetailReturnReceipt, DocumentRef.RetailSalesReceipt -
// 
// Returns:
//  Array Of String
Function GetStringCode(DocumentRef) Export
	Array = New Array; // Array Of String
	For Each Row In DocumentRef.ControlCodeStrings Do
		
		If Row.NotCheck Then
			Continue;
		EndIf;
		
		Array.Add(Row.CodeString);
	EndDo;
	Return Array;
EndFunction

// Shift get XMLOperation settings.
// 
// Parameters:
//  Ref - DocumentRef.RetailSalesReceipt, DocumentRef.ConsolidatedRetailSales -
//  InputParameters - See EquipmentFiscalPrinterAPIClient.FillInputParameters
// 
// Returns:
//  Structure - Shift get XMLOperation settings::
// * CashierName - DefinedType.typeDescription -
// * CashierINN - String -
// * SaleAddress - String -
// * SaleLocation - String -
// @skip-check reading-attribute-from-database
Procedure FillInputParameters(Ref, InputParameters) Export
	InputParameters.CashierName = Ref.Author.Partner.Description_ru;
	
	If IsBlankString(InputParameters.CashierName) Then
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
	