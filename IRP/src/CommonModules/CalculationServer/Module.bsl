Function OfferHaveManualInputValue(OfferRef) Export
	Return OffersServer.OfferHaveManualInputValue(OfferRef);
EndFunction

Function CalculateDocumentAmount(ItemList, AddInfo = Undefined) Export

	TotalAmount = ItemList.Total("TotalAmount");
	CanceledRows = ItemList.FindRows(New Structure("Cancel", True));
	For Each CanceledRow In CanceledRows Do
		TotalAmount = TotalAmount - CanceledRow.TotalAmount;
	EndDo;
	Return TotalAmount;

EndFunction
