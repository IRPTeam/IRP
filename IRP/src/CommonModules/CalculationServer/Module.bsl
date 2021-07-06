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
	
	ColumnNames_ItemList      = CalculationStringsClientServer.GetColumnNames_ItemList(ArrayOfTaxInfo);
	ColumnNames_TaxList       = CalculationStringsClientServer.GetColumnNames_TaxList();
	ColumnNames_SpecialOffers = CalculationStringsClientServer.GetColumnNames_SpecialOffers();
	
	Object.ItemList      = ArrayOfStructuresToValueTable(Object.ItemList      , ColumnNames_ItemList);
	Object.TaxList       = ArrayOfStructuresToValueTable(Object.TaxList       , ColumnNames_TaxList);	
	Object.SpecialOffers = ArrayOfStructuresToValueTable(Object.SpecialOffers , ColumnNames_SpecialOffers);
	
	For Each ItemRow In Object.ItemList Do
		CalculationStringsClientServer.CalculateItemsRow(Object, ItemRow, Actions, ArrayOfTaxInfo, AddInfo);
	EndDo;
	
	Object.ItemList      = ValueTableToArrayOfStructures(Object.ItemList      , ColumnNames_ItemList);
	Object.TaxList       = ValueTableToArrayOfStructures(Object.TaxList       , ColumnNames_TaxList);	
	Object.SpecialOffers = ValueTableToArrayOfStructures(Object.SpecialOffers , ColumnNames_SpecialOffers);
	
EndProcedure

Function CalculateDocumentAmount(ItemList, AddInfo = Undefined) Export
	
	TotalAmount = ItemList.Total("TotalAmount");
	CanceledRows = ItemList.FindRows(New Structure("Cancel", True));
	For Each CanceledRow In CanceledRows Do
		TotalAmount = TotalAmount - CanceledRow.TotalAmount;
	EndDo;
	Return TotalAmount;

EndFunction
