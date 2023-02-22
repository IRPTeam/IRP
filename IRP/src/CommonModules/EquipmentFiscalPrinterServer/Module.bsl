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
	
	For Each Item In SourceData.ItemList Do
		RowFilter = New Structure();
		RowFilter.Insert("Key", Item.Key);
		SLNRows = SourceData.SerialLotNumbers.FindRows(RowFilter);
		TaxRows = SourceData.TaxList.FindRows(RowFilter);
		If TypeOf(SourceData.Ref) = Type("DocumentRef.RetailSalesReceipt") Then
			CBRows = SourceData.ConsignorBatches.FindRows(RowFilter);
		Else
			CBRows = New Array;
		EndIf;
		FiscalStringData = New Structure();
		FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
		FiscalStringData.Insert("DiscountAmount", Item.OffersAmount);
		If SLNRows.Count() = 1 Then
			If IsBlankString(SLNRows[0].SerialLotNumber.CodeString) Then
				FiscalStringData.Insert("CalculationSubject", "32");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject	
			Else
				FiscalStringData.Insert("MarkingCode", SLNRows[0].SerialLotNumber.CodeString);	//TODO: Marking defenition
				FiscalStringData.Insert("CalculationSubject", "33");	//https://its.1c.ru/db/metod8dev#content:4829:hdoc:signcalculationobject
			EndIf;
		ElsIf SLNRows.Count() > 1 Then
			Raise("A few SerialLotNumber found!");
		EndIf;
		FiscalStringData.Insert("MeasureOfQuantity", "255");
		FiscalStringData.Insert("Name", String(Item.Item) + " " + String(Item.ItemKey));
		FiscalStringData.Insert("Quantity", Item.Quantity);
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
		FiscalStringData.Insert("PriceWithDiscount", Round(Item.TotalAmount / Item.Quantity, 2));
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
		FiscalStrings.Add(FiscalStringData);
	EndDo;
	
	Str.Insert("FiscalStrings", FiscalStrings);
	
	Str.Insert("Cash", 0);
	Str.Insert("ElectronicPayment", 0);
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	For Each Payment In SourceData.Payments Do
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

#EndRegion
	