#Region Public

Function PrepareReceiptData(RetailSalesReceipt) Export
	Var Str;
	Str = New Structure;
	Str.Insert("CashierName", String(RetailSalesReceipt.Author));
	Str.Insert("OperationType", 1);
	Str.Insert("TaxationSystem", 0);	//TODO: TaxSystem choice
	
	FiscalStrings = New Array;
	For Each Item In RetailSalesReceipt.ItemList Do
		RowFilter = New Structure();
		RowFilter.Insert("Key", Item.Key);
		SLNRows = RetailSalesReceipt.SerialLotNumbers.FindRows(RowFilter);
		TaxRows = RetailSalesReceipt.TaxList.FindRows(RowFilter);
		FiscalStringData = New Structure();
		FiscalStringData.Insert("AmountWithDiscount", Item.TotalAmount);
		FiscalStringData.Insert("DiscountAmount", Item.OffersAmount);
		If SLNRows.Count() = 1 Then
			FiscalStringData.Insert("MarkingCode", String(SLNRows[0].SerialLotNumber));	//TODO: Marking defenition
		ElsIf SLNRows.Count() = 1 Then
			Raise("A few SerialLotNumber found!");
		EndIf;
		FiscalStringData.Insert("MeasureOfQuantity", "255");
		FiscalStringData.Insert("Name", String(Item.Item));
		FiscalStringData.Insert("Quantity", Item.Quantity);
		If RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.FullPrepayment Then
			FiscalStringData.Insert("PaymentMethod", 1);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.PartialPrepayment Then
			FiscalStringData.Insert("PaymentMethod", 2);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.AdvancePayment Then
			FiscalStringData.Insert("PaymentMethod", 3);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation Then
			FiscalStringData.Insert("PaymentMethod", 4);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.PartialSettlementAndCredit Then
			FiscalStringData.Insert("PaymentMethod", 5);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.TransferOnCredit Then
			FiscalStringData.Insert("PaymentMethod", 6);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.LoanPayment Then
			FiscalStringData.Insert("PaymentMethod", 7);
		EndIf;
		FiscalStringData.Insert("PriceWithDiscount", Round(Item.TotalAmount / Item.Quantity, 2));
		If TaxRows.Count() > 0 Then
			FiscalStringData.Insert("VATRate", Format(TaxRows[0].TaxRate.Rate, "NZ=0; NG=0;"));
			FiscalStringData.Insert("VATAmount", TaxRows[0].Amount);
		Else
			Raise("Tax isn't found!");
		EndIf;
		FiscalStrings.Add(FiscalStringData);
	EndDo;
	
	Str.Insert("FiscalStrings", FiscalStrings);
	Str.Insert("TextStrings", New Array);
	
	Str.Insert("Cash", 0);
	Str.Insert("ElectronicPayment", 0);
	Str.Insert("PrePayment", 0);
	Str.Insert("PostPayment", 0);
	Str.Insert("Barter", 0);
	
	For Each Payment In RetailSalesReceipt.Payments Do
		If RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.FullPrepayment Then
			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.PartialPrepayment Then
			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.AdvancePayment Then
			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.FullCalculation Then
			If Payment.PaymentType.Type = Enums.PaymentTypes.Cash Then
				Str.Insert("Cash", Str.Cash + Payment.Amount);
			ElsIf Payment.PaymentType.Type = Enums.PaymentTypes.Card Then
				Str.Insert("ElectronicPayment", Str.ElectronicPayment + Payment.Amount);
			EndIf;
//		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.PartialSettlementAndCredit Then
//			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
//		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.TransferOnCredit Then
//			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
//		ElsIf RetailSalesReceipt.PaymentMethod = Enums.ReceiptPaymentMethods.LoanPayment Then
//			Str.Insert("PrePayment", Str.PrePayment + Payment.Amount);
		EndIf;
	EndDo;
	
	Return Str;
EndFunction

#EndRegion
	