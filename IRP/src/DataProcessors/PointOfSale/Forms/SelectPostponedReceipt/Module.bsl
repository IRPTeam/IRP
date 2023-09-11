
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	BranchParameter = Receipts.Parameters.Items[0]; 
	BranchParameter.Value = Parameters.Branch;
	BranchParameter.Use = True;

EndProcedure

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

&AtClient
Procedure CancelReceipts(Command)

	RefsArray = New Array;
	For Each Row In Items.Receipts.SelectedRows Do
		RefsArray.Add(Row);
	EndDo;
	If RefsArray.Count() = 0 Then
		Return;
	EndIf;	
	
	NumberOfCanceled = CancelingPostponedReceipts(RefsArray);
	CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().POS_CancelPostponed, NumberOfCanceled));

	Items.Receipts.Refresh();
EndProcedure

&AtServerNoContext
Function CancelingPostponedReceipts(RefsArray)
	Result = 0;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.Ref
	|FROM
	|	Document.RetailSalesReceipt AS RetailSalesReceipt
	|WHERE
	|	RetailSalesReceipt.Ref in (&RefsArray)
	|	AND RetailSalesReceipt.StatusType IN (&Postponed, &PostponedWithReserve)
	|
	|UNION ALL
	|
	|SELECT
	|	RetailReturnReceipt.Ref
	|FROM
	|	Document.RetailReturnReceipt AS RetailReturnReceipt
	|WHERE
	|	RetailReturnReceipt.Ref in (&RefsArray)
	|	AND RetailReturnReceipt.StatusType IN (&Postponed, &PostponedWithReserve)";
	
	Query.SetParameter("RefsArray", RefsArray);
	Query.SetParameter("PostponedWithReserve", Enums.RetailReceiptStatusTypes.PostponedWithReserve);
	Query.SetParameter("Postponed", Enums.RetailReceiptStatusTypes.Postponed);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ReceiptObject = QuerySelection.Ref.GetObject(); // DocumentObject.RetailSalesReceipt
		ReceiptObject.StatusType = Enums.RetailReceiptStatusTypes.Canceled;
		//@skip-check empty-except-statement
		Try
			ReceiptObject.Write(DocumentWriteMode.Posting);
			Result = Result + 1;
		Except EndTry;
	EndDo;
	
	Return Result;
EndFunction
