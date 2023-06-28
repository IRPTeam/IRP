#Region Public

Function PrepareReceiptData(SourceData) Export
	ReturnData = New Structure;
	If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(SourceData.Ref) = Type("DocumentRef.RetailReturnReceipt") Then
		ReturnData = PrepareReceiptDataByRetailSalesReceipt(SourceData);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.CashReceipt") Then
		ReturnData = PrepareReceiptDataByCashReceipt(SourceData);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.CashPayment") Then
		ReturnData = PrepareReceiptDataByCashPayment(SourceData);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.BankReceipt") Then
		ReturnData = PrepareReceiptDataByBankReceipt(SourceData);
	ElsIf TypeOf(SourceData.Ref) = Type("DocumentRef.BankPayment") Then
		ReturnData = PrepareReceiptDataByBankPayment(SourceData);
	EndIf;
	Return ReturnData;
EndFunction

// Prepare receipt data by retail sales receipt.
// 
// Parameters:
//  SourceData - DocumentRef.RetailSalesReceipt -
// 
// Returns:
//  Structure - Prepare receipt data by retail sales receipt:
// * CashierName - String -
// * OperationType - Number -
// * TaxationSystem - Number -
// * FiscalStrings - Array -
// * Cash - Number -
// * ElectronicPayment - Number -
// * PrePayment - Number -
// * PostPayment - Number -
// * Barter - Number -
// * Cash - Number -
// * TextStrings - Array -
Function PrepareReceiptDataByRetailSalesReceipt(SourceData) Export
	Str = New Structure;
	Str.Insert("CashierName", String(SourceData.Author));
	If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
		Str.Insert("OperationType", 1);
	Else
		Str.Insert("OperationType", 2);
	EndIf;
	Str.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice 
	
	FiscalStrings = New Array;
	TextStrings = New Array;
	
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
		FiscalStringData = New Structure();
		FiscalStringData.Insert("AmountWithDiscount", ItemRow.TotalAmount);
		FiscalStringData.Insert("DiscountAmount", ItemRow.OffersAmount);
		If ItemRow.isControlCodeString Then
			If CCSRows.Count() = 0 Then
				Raise "Control string code not filled. Row: " + ItemRow.LineNumber;
			ElsIf Not CCSRows.Count() = ItemRow.Quantity Then
				Raise "Control string code count not the same as item quantity. Row: " + ItemRow.LineNumber;
			ElsIf CCSRows.Count() > 1 Then // TODO: Fix this
				Raise "Not suppoted send more then 1 control code by each row. Row: " + ItemRow.LineNumber;
			ElsIf CCSRows[0].NotCheck Then
				// Not check an not send
			Else
				CodeString = CCSRows[0].CodeString;
				If Not CommonFunctionsClientServer.isBase64Value(CodeString) Then
					CodeString = Base64String(GetBinaryDataFromString(CodeString, TextEncoding.UTF8, False));
				EndIf;
				FiscalStringData.Insert("MarkingCode", CodeString);
				FiscalStringData.Insert("CalculationSubject", "33");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			EndIf;
		Else
			FiscalStringData.Insert("CalculationSubject", "32");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject	
		EndIf;
		FiscalStringData.Insert("MeasureOfQuantity", "255");
		FiscalStringData.Insert("Name", String(ItemRow.Item) + " " + String(ItemRow.ItemKey));
		FiscalStringData.Insert("Quantity", ItemRow.Quantity);
		If SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullPrepayment Then
			FiscalStringData.Insert("PaymentMethod", 1);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.PartialPrepayment Then
			FiscalStringData.Insert("PaymentMethod", 2);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.AdvancePayment Then
			FiscalStringData.Insert("PaymentMethod", 3);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation Then
			FiscalStringData.Insert("PaymentMethod", 4);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.PartialSettlementAndCredit Then
			FiscalStringData.Insert("PaymentMethod", 5);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.TransferOnCredit Then
			FiscalStringData.Insert("PaymentMethod", 6);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.LoanPayment Then
			FiscalStringData.Insert("PaymentMethod", 7);
		Else
			FiscalStringData.Insert("PaymentMethod", 4);
		EndIf;
		FiscalStringData.Insert("PriceWithDiscount", Round(ItemRow.TotalAmount / ItemRow.Quantity, 2));
		If TaxRows.Count() > 0 Then
			If TaxRows[0].TaxRate.NoRate Then
				FiscalStringData.Insert("VATRate", "none");
				FiscalStringData.Insert("VATAmount", 0);  
			Else
				FiscalStringData.Insert("VATRate", Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;"));
				FiscalStringData.Insert("VATAmount", TaxRows[0].Amount);
			EndIf;
			
		Else
			Raise("Tax isn't found!");
		EndIf;
		If CBRows.Count() > 0 Then
			VendorData = New Structure;
			If TypeOf(CBRows[0].Batch) = Type("DocumentRef.OpeningEntry") Then
				VendorData.Insert("VendorINN", CBRows[0].Batch.LegalNameConsignor.TaxID);
				VendorData.Insert("VendorName", String(CBRows[0].Batch.LegalNameConsignor));
				VendorData.Insert("VendorPhone", "");
			Else
				VendorData.Insert("VendorINN", CBRows[0].Batch.LegalName.TaxID);
				VendorData.Insert("VendorName", String(CBRows[0].Batch.LegalName));
				VendorData.Insert("VendorPhone", "");
			EndIf;
			FiscalStringData.Insert("CalculationAgent", "5");
			FiscalStringData.Insert("VendorData", VendorData);
		EndIf;
		
		If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
			If Not ItemRow.Consignor.IsEmpty() Then
				VendorData = New Structure;
				VendorData.Insert("VendorINN", ItemRow.Consignor.TaxID);
				VendorData.Insert("VendorName", String(ItemRow.Consignor));
				VendorData.Insert("VendorPhone", "");
				FiscalStringData.Insert("CalculationAgent", "5");
				FiscalStringData.Insert("VendorData", VendorData);
			EndIf;
		EndIf; 
		
		FiscalStrings.Add(FiscalStringData);
	EndDo;
	
	Str.Insert("FiscalStrings", FiscalStrings);
	
	Str.Insert("Cash", 0);
	Str.Insert("ElectronicPayment", 0);
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	For Each Payment In SourceData.Payments Do
		If Payment.Amount < 0 Then
			Continue;
		EndIf;
		
		If SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullPrepayment Then
			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.PartialPrepayment Then
			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.AdvancePayment Then
			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		ElsIf SourceData.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation Then
			If Payment.PaymentType.Type = Enums.PaymentTypes.Cash Then
				Str.Insert("Cash", Str.Cash + Payment.Amount);
			ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Card Then
				Str.Insert("ElectronicPayment", Str.ElectronicPayment + Payment.Amount);
			ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.PaymentAgent Then
				Str.Insert("PostPayment", Str.PostPayment + Payment.Amount);
			Else
				Str.Insert("Cash", Str.Cash + Payment.Amount);
			EndIf;
		Else
			If Payment.PaymentType.Type = Enums.PaymentTypes.Cash Then
				Str.Insert("Cash", Str.Cash + Payment.Amount);
			ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Card Then
				Str.Insert("ElectronicPayment", Str.ElectronicPayment + Payment.Amount);
			ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.PaymentAgent Then
				Str.Insert("PostPayment", Str.PostPayment + Payment.Amount);
			Else
				Str.Insert("Cash", Str.Cash + Payment.Amount);
			EndIf;
		EndIf;
	EndDo;
	
	Str.Insert("TextStrings", TextStrings);
	
	Return Str;
EndFunction

Function PrepareReceiptDataByCashReceipt(SourceData) Export
	
	Str = New Structure;
	Str.Insert("CashierName", String(SourceData.Author));
	Str.Insert("OperationType", 1);
	Str.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.IncomingPaymentTransactionType.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		Str.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", "10");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
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
	
	Str.Insert("FiscalStrings", FiscalStrings);
	Str.Insert("TextStrings", New Array);
	
	Str.Insert("Cash", SourceData.PaymentList.Total("TotalAmount"));
	Str.Insert("ElectronicPayment", 0);
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	Return Str;
EndFunction

Function PrepareReceiptDataByCashPayment(SourceData) Export
	
	Str = New Structure;
	Str.Insert("CashierName", String(SourceData.Author));
	Str.Insert("OperationType", 2);
	Str.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.OutgoingPaymentTransactionTypes.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		Str.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", "10");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
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
	
	Str.Insert("FiscalStrings", FiscalStrings);
	Str.Insert("TextStrings", New Array);
	
	Str.Insert("Cash", SourceData.PaymentList.Total("TotalAmount"));
	Str.Insert("ElectronicPayment", 0);
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	Return Str;
EndFunction

Function PrepareReceiptDataByBankReceipt(SourceData) Export
	
	Str = New Structure;
	Str.Insert("CashierName", String(SourceData.Author));
	Str.Insert("OperationType", 1);
	Str.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.IncomingPaymentTransactionType.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		Str.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", "10");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
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
	
	Str.Insert("FiscalStrings", FiscalStrings);
	Str.Insert("TextStrings", New Array);
	
	Str.Insert("Cash", 0);
	Str.Insert("ElectronicPayment", SourceData.PaymentList.Total("TotalAmount"));
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	Return Str;
EndFunction

Function PrepareReceiptDataByBankPayment(SourceData) Export
	
	Str = New Structure;
	Str.Insert("CashierName", String(SourceData.Author));
	Str.Insert("OperationType", 2);
	Str.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	
	If SourceData.TransactionType = Enums.OutgoingPaymentTransactionTypes.CustomerAdvance Then
		PaymentListData = SourceData.PaymentList.Unload();
		PaymentListData.GroupBy("RetailCustomer");
		If PaymentListData.Count() > 1 Then
			Raise("A few retail customer found!");
		EndIf;
		CustomerDetail = New Structure;
		CustomerDetail.Insert("Info", String(SourceData.PaymentList[0].RetailCustomer));
		CustomerDetail.Insert("INN", PaymentListData[0].RetailCustomer.TaxID);
		Str.Insert("CustomerDetail", CustomerDetail);	
	
		FiscalStrings = New Array;
		For Each Item In SourceData.PaymentList Do
			RowFilter = New Structure();
			RowFilter.Insert("Key", Item.Key);
			TaxRows = SourceData.TaxList.FindRows(RowFilter);
			FiscalStringData = New Structure();
			FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
			FiscalStringData.Insert("DiscountAmount", 0);
			FiscalStringData.Insert("CalculationSubject", "10");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
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
	
	Str.Insert("FiscalStrings", FiscalStrings);
	Str.Insert("TextStrings", New Array);
	
	Str.Insert("Cash", 0);
	Str.Insert("ElectronicPayment", SourceData.PaymentList.Total("TotalAmount"));
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	Return Str;
EndFunction

Function PreparePrintTextData(SourceData) Export
	Str = New Structure;
	
	TextStrings = New Array;
	
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
			TextStringData = New Structure();
			TextStringData.Insert("Text", Text);
			TextStrings.Add(TextStringData);
		EndDo;
	EndDo;
	
	Str.Insert("TextStrings", TextStrings);
	
	Return Str;
EndFunction

Procedure SetFiscalStatus(DocumentRef, Status = "Prepaired", FiscalResponse = "", DataPresentation = "") Export
	If Status = "Prepaired" Then
		InformationRegisters.DocumentFiscalStatus.SetStatus(DocumentRef
																, Enums.DocumentFiscalStatuses.Prepaired);
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
																, Enums.DocumentFiscalStatuses.NotPrinted);
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

#EndRegion
	