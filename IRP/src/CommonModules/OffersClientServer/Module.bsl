
Procedure CalculateAndLoadOffers_ForRow(Object, OffersAddress, ItemListRowKey) Export
	OffersInfo = New Structure();
	OffersInfo.Insert("OffersAddress"  , OffersAddress);
	OffersInfo.Insert("ItemListRowKey" , ItemListRowKey);
	
	TreeByOneOfferAddress = OffersServer.CalculateOffersTreeAndPutToTmpStorage_ForRow(Object, OffersInfo);
	
	ArrayOfOffers = OffersServer.GetArrayOfAllOffers_ForRow(Object, TreeByOneOfferAddress, ItemListRowKey);
	
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

Procedure CalculateAndLoadOffers_ForDocument(Object, OffersAddress) Export
	OffersInfo = New Structure();
	OffersInfo.Insert("OffersAddress", OffersAddress);
	
	OffersAddress = OffersServer.CalculateOffersTreeAndPutToTmpStorage_ForDocument(Object, OffersInfo);
	
	ArrayOfOffers = OffersServer.GetArrayOfAllOffers_ForDocument(Object, OffersAddress);
	
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

Procedure RecalculateAppliedOffers_ForRow(Object, AddInfo = Undefined) Export
	For Each Row In Object.SpecialOffers Do
		
		isOfferRow = ValueIsFilled(Row.Offer) 
			And OffersServer.IsOfferForRow(Row.Offer) 
			And ValueIsFilled(Row.Percent)
			And ValueIsFilled(Row.Key);
			
		If isOfferRow Then

			ArrayOfOffers = New Array();
			ArrayOfOffers.Add(Row.Offer);

			TreeByOneOfferAddress = OffersServer.CreateOffersTreeAndPutToTmpStorage(Object, 
																					Object.ItemList,
																					Object.SpecialOffers,
																					ArrayOfOffers,
																					Row.Key);

			CalculateAndLoadOffers_ForRow(Object, TreeByOneOfferAddress, Row.Key);

		EndIf;
	EndDo;
EndProcedure
