
Function CalculateDocumentAmount(ItemList) Export
	TotalAmount = ItemList.Total("TotalAmount");
	CanceledRows = ItemList.FindRows(New Structure("Cancel", True));
	For Each CanceledRow In CanceledRows Do
		TotalAmount = TotalAmount - CanceledRow.TotalAmount;
	EndDo;
	Return TotalAmount;
EndFunction
