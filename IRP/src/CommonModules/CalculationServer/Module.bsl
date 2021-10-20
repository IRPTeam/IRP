Function OfferHaveManualInputValue(OfferRef) Export
	Return OffersServer.OfferHaveManualInputValue(OfferRef);
EndFunction

Function ArrayOfStructuresToValueTable(ArrayOfStructures, ColumnNames) Export
	ValueTable = New ValueTable();
	ArrayOfColumnNames = StrSplit(ColumnNames, ",");
	For Each ColumnName In ArrayOfColumnNames Do
		ValueTable.Columns.Add(TrimAll(ColumnName));
	EndDo;
	For Each Row In ArrayOfStructures Do
		FillPropertyValues(ValueTable.Add(), Row);
	EndDo;
	Return ValueTable;
EndFunction

Function ValueTableToArrayOfStructures(ValueTable, ColumnNames) Export
	ArrayOfStructures = New Array();
	For Each Row In ValueTable Do
		NewRow = New Structure(ColumnNames);
		FillPropertyValues(NewRow, Row);
		ArrayOfStructures.Add(NewRow);
	EndDo;
	Return ArrayOfStructures;
EndFunction

Procedure CalculateItemsRows(Object, ItemRows, Actions, ArrayOfTaxInfo = Undefined, AddInfo = Undefined) Export
	IsItemListExists      = Object.Property("ItemList");
	IsPaymentListExists   = Object.Property("PaymentList");
	IsTaxListExists       = Object.Property("TaxList");
	IsSpecialOffersExists = Object.Property("SpecialOffers");
	
	If IsItemListExists Then
		ColumnNames_ItemList = CalculationStringsClientServer.GetColumnNames_ItemList(ArrayOfTaxInfo);
		Object.ItemList      = ArrayOfStructuresToValueTable(Object.ItemList, ColumnNames_ItemList);
	EndIf;
	
	If IsPaymentListExists Then
		ColumnNames_PaymentList = CalculationStringsClientServer.GetColumnNames_PaymentList(ArrayOfTaxInfo);
		Object.PaymentList      = ArrayOfStructuresToValueTable(Object.PaymentList, ColumnNames_PaymentList);
	EndIf;
	
	If IsTaxListExists Then
		ColumnNames_TaxList = CalculationStringsClientServer.GetColumnNames_TaxList();
		Object.TaxList      = ArrayOfStructuresToValueTable(Object.TaxList, ColumnNames_TaxList);
	EndIf;
	
	If IsSpecialOffersExists Then
		ColumnNames_SpecialOffers = CalculationStringsClientServer.GetColumnNames_SpecialOffers();
		Object.SpecialOffers = ArrayOfStructuresToValueTable(Object.SpecialOffers, ColumnNames_SpecialOffers);
	EndIf;
	
	If IsItemListExists Then
		For Each ItemRow In Object.ItemList Do
			CalculationStringsClientServer.CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo, AddInfo);
		EndDo;
	EndIf;
	
	If IsPaymentListExists Then
		For Each ItemRow In Object.PaymentList Do
			CalculationStringsClientServer.CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo, AddInfo);
		EndDo;
	EndIf;
	
	If IsItemListExists Then
		Object.ItemList = ValueTableToArrayOfStructures(Object.ItemList, ColumnNames_ItemList);
	EndIf;
	
	If IsPaymentListExists Then
		Object.PaymentList = ValueTableToArrayOfStructures(Object.PaymentList, ColumnNames_PaymentList);
	EndIf;
	
	If IsTaxListExists Then
		Object.TaxList = ValueTableToArrayOfStructures(Object.TaxList, ColumnNames_TaxList);
	EndIf;
	
	If IsSpecialOffersExists Then
		Object.SpecialOffers = ValueTableToArrayOfStructures(Object.SpecialOffers, ColumnNames_SpecialOffers);
	EndIf;
EndProcedure

Function CalculateDocumentAmount(ItemList, AddInfo = Undefined) Export

	TotalAmount = ItemList.Total("TotalAmount");
	CanceledRows = ItemList.FindRows(New Structure("Cancel", True));
	For Each CanceledRow In CanceledRows Do
		TotalAmount = TotalAmount - CanceledRow.TotalAmount;
	EndDo;
	Return TotalAmount;

EndFunction