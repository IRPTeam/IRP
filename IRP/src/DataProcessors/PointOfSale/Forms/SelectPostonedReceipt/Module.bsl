
&AtClient
Procedure ReceiptsOnActivateRow(Item)
	ReceiptsOnActivateRowAtServer(Items.Receipts.CurrentRow);
EndProcedure

&AtServer
Procedure ReceiptsOnActivateRowAtServer(Receipt)
	
	ItemList.Clear();
	If Receipt = Undefined Then
		Return;
	EndIf;

	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceiptItemList.Item,
	|	RetailSalesReceiptItemList.ItemKey,
	|	RetailSalesReceiptItemList.Unit,
	|	RetailSalesReceiptItemList.Quantity,
	|	RetailSalesReceiptItemList.Price,
	|	RetailSalesReceiptItemList.TaxAmount,
	|	RetailSalesReceiptItemList.OffersAmount,
	|	RetailSalesReceiptItemList.NetAmount,
	|	RetailSalesReceiptItemList.TotalAmount,
	|	RetailSalesReceiptItemList.LineNumber AS LineNumber
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref
	|
	|UNION ALL
	|
	|SELECT
	|	RetailReturnReceiptItemList.Item,
	|	RetailReturnReceiptItemList.ItemKey,
	|	RetailReturnReceiptItemList.Unit,
	|	RetailReturnReceiptItemList.Quantity,
	|	RetailReturnReceiptItemList.Price,
	|	RetailReturnReceiptItemList.TaxAmount,
	|	RetailReturnReceiptItemList.OffersAmount,
	|	RetailReturnReceiptItemList.NetAmount,
	|	RetailReturnReceiptItemList.TotalAmount,
	|	RetailReturnReceiptItemList.LineNumber AS LineNumber
	|FROM
	|	Document.RetailReturnReceipt.ItemList AS RetailReturnReceiptItemList
	|WHERE
	|	RetailReturnReceiptItemList.Ref = &Ref
	|
	|ORDER BY
	|	LineNumber";
	
	Query.SetParameter("Ref", Receipt);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		FillPropertyValues(ItemList.Add(), QuerySelection);
	EndDo;
	
EndProcedure
