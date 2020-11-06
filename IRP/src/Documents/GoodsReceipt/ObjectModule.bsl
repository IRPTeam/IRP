
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	If DataExchange.Load = True Then
		Return;
	EndIf;
	If TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.Bundling")
			OR TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.InventoryTransfer") Then
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
			TransactionType = Enums.GoodsReceiptTransactionTypes.Bundling;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "InventoryTransfer" Then
			TransactionType = Enums.GoodsReceiptTransactionTypes.InventoryTransfer;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "PurchaseInvoice" Then
			TransactionType = Enums.GoodsReceiptTransactionTypes.Purchase;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "PurchaseOrder" Then
			TransactionType = Enums.GoodsReceiptTransactionTypes.Purchase;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesReturn" Then
			TransactionType = Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer;
			Filling_BasedOn(FillingData);
		EndIf;
		
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "Unbundling" Then
			TransactionType = Enums.GoodsReceiptTransactionTypes.Bundling;
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
	EndDo;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;	
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	tmp.ReceiptBasis AS ReceiptBasis
	|into tmp
	|FROM
	|	&ItemList AS tmp
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.ReceiptBasis.Currency AS Currency,
	|	SUM(1) AS CountCurrencies
	|FROM
	|	tmp AS tmp
	|WHERE
	|	NOT tmp.ReceiptBasis.Date IS NULL
	|GROUP BY
	|	tmp.ReceiptBasis.Currency";
	Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() > 1 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().S_022);
		Cancel = True;
	EndIf;
EndProcedure
