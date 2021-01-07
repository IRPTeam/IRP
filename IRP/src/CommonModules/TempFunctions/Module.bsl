
Procedure BeforeWrite_FillQuantityBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	Actions = New Structure("CalculateQuantityInBaseUnit");
	For Each Row In Source.ItemList Do
		CalculationStringsClientServer.CalculateItemsRow(Source, Row, Actions);
	EndDo;
EndProcedure
