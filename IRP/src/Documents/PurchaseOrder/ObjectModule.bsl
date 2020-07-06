Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
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
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "InternalSupplyRequest" Then
			Filling_BasedOn(FillingData);
		EndIf;
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesOrder" Then
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	ThisObject.Company = FillingData.Company;
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
		If ValueIsFilled(Row.Unit) And ValueIsFilled(Row.Unit.Quantity) Then
			NewRow.Quantity = Row.Quantity / Row.Unit.Quantity;
		EndIf;
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
EndProcedure