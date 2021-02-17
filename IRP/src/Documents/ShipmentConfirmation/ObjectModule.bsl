Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	

	If TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Bundling")
			OR TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.InventoryTransfer") Then
		Partner = Undefined;
		LegalName = Undefined;
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

Procedure Posting(Cancel, PostingMode)
	
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure UndoPosting(Cancel)
	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Bundling" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.Bundling;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "InventoryTransfer" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.InventoryTransfer;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "PurchaseReturn" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesInvoice" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.Sales;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesOrder" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.Sales;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Unbundling" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.Bundling;
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
	
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData, "Company, Partner, LegalName");
	
	If FillingData.Property("ItemList") Then
		For Each Row In FillingData.ItemList Do
			NewRow = ThisObject.ItemList.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndIf;
	
	If FillingData.Property("RowIDInfo") Then
		For Each Row In FillingData.RowIDInfo Do
			NewRow = ThisObject.RowIDInfo.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;	
	EndIf;
EndProcedure
