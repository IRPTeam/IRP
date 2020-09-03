Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	

	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
EndProcedure

Procedure Posting(Cancel, PostingMode)	
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);	
EndProcedure

Procedure UndoPosting(Cancel)	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);	
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "RetailSalesReceipt" Then
			Filling_BasedOnRetailSalesReceipt(FillingData);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOnRetailSalesReceipt(FillingData)
	FillPropertyValues(ThisObject, FillingData,
		"Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
	
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	For Each Row In FillingData.TaxList Do
		NewRow = ThisObject.TaxList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	For Each Row In FillingData.SpecialOffers Do
		NewRow = ThisObject.SpecialOffers.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	For Each Row In FillingData.SerialLotNumbers Do
		NewRow = ThisObject.SerialLotNumbers.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;	
EndProcedure

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
