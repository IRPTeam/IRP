Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load = True Then
		Return;
	EndIf;
	If TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.BundlingBoxing")
			OR TransactionType = PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.InventoryTransfer") Then
		Partner = Undefined;
		LegalName = Undefined;
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
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Boxing" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.BundlingBoxing;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Bundling" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.BundlingBoxing;
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
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Unboxing" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.BundlingBoxing;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Unbundling" Then
			TransactionType = Enums.ShipmentConfirmationTransactionTypes.BundlingBoxing;
			Filling_BasedOn(FillingData);
		EndIf;
	EndIf;
	
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData, "Company, Partner, LegalName");
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;	
	EndIf;
EndProcedure

