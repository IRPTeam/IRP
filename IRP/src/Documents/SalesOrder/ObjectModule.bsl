Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	ThisObject.DocumentAmount = ItemList.Total("TotalAmount");
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;	
	EndIf;
EndProcedure


Procedure Posting(Cancel, PostingMode)
	
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure UndoPosting(Cancel)
	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	
EndProcedure


Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If FillingData = Undefined Then
		Return;
	EndIf;

	FillPropertyValues(ThisObject, FillingData);
	Number = Undefined;
	Date = Undefined;
EndProcedure


Procedure OnCopy(CopiedObject)
	
	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(TaxList);
	LinkedTables.Add(Currencies);
	DocumentsServer.SetNewTabelUUID(ItemList, LinkedTables);
	
EndProcedure


