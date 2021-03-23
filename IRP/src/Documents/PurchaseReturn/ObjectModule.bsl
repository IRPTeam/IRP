Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	

	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		FillPropertyValues(ThisObject, FillingData, RowIDInfoServer.GetSeperatorColumns(ThisObject.Metadata()));
		RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		
//		If FillingData.Property("BasedOn") And FillingData.BasedOn = "PurchaseInvoice" Then
//			Filling_BasedOnPurchaseInvoice(FillingData);
//		EndIf;
//		If FillingData.Property("BasedOn") And FillingData.BasedOn = "PurchaseReturnOrder" Then
//			Filling_BasedOnPurchaseReturnOrder(FillingData);
//		EndIf;
//		If FillingData.Property("BasedOn") And FillingData.BasedOn = "ShipmentConfirmation" Then
//			Filling_BasedOnShipmentConfirmation(FillingData);
//		EndIf;
	EndIf;
EndProcedure

//Procedure Filling_BasedOnPurchaseInvoice(FillingData)
//	FillPropertyValues(ThisObject, FillingData,
//		"Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
//	
//	For Each Row In FillingData.ItemList Do
//		NewRow = ThisObject.ItemList.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//	For Each Row In FillingData.TaxList Do
//		NewRow = ThisObject.TaxList.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//	For Each Row In FillingData.SpecialOffers Do
//		NewRow = ThisObject.SpecialOffers.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//	For Each Row In FillingData.SerialLotNumbers Do
//		NewRow = ThisObject.SerialLotNumbers.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//EndProcedure
//
//Procedure Filling_BasedOnPurchaseReturnOrder(FillingData)
//	FillPropertyValues(ThisObject, FillingData,
//		"Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
//	
//	For Each Row In FillingData.ItemList Do
//		NewRow = ThisObject.ItemList.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//	For Each Row In FillingData.TaxList Do
//		NewRow = ThisObject.TaxList.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//	For Each Row In FillingData.SpecialOffers Do
//		NewRow = ThisObject.SpecialOffers.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//EndProcedure
//
//Procedure Filling_BasedOnShipmentConfirmation(FillingData)
//	FillPropertyValues(ThisObject, FillingData, "Company,Partner,LegalName");
//	
//	For Each Row In FillingData.ItemList Do
//		NewRow = ThisObject.ItemList.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;
//	For Each Row In FillingData.ShipmentConfirmations Do
//		NewRow = ThisObject.ShipmentConfirmations.Add();
//		FillPropertyValues(NewRow, Row);
//	EndDo;	
//EndProcedure

Procedure OnCopy(CopiedObject)
	
	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(TaxList);
	LinkedTables.Add(Currencies);
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);
	
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;	
	EndIf;
	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;	
EndProcedure
