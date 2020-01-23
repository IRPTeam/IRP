&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("InfoGoodsReceipt") Then
		FillGoodsReceiptTree(Parameters.InfoGoodsReceipt);
	Else
		Cancel = True;
	EndIf;
EndProcedure

&AtServer
Procedure FillGoodsReceiptTree(InfoGoodsReceip)
	ThisObject.GoodsReceiptTree.GetItems().Clear();
	
	For Each Row_Order In InfoGoodsReceip Do
		NewRow_Order = ThisObject.GoodsReceiptTree.GetItems().Add();
		NewRow_Order.Order = Row_Order.Order;
		For Each Row_GoodsReceipt In Row_Order.Rows Do
			NewRow_GoodsReceipt = NewRow_Order.GetItems().Add();
			NewRow_GoodsReceipt.GoodsReceipt = Row_GoodsReceipt.GoodsReceipt;
			For Each Row_Item In Row_GoodsReceipt.Rows Do
				NewRow_Item = NewRow_GoodsReceipt.GetItems().Add();
				NewRow_Item.Item = Row_Item.Item;
				NewRow_Item.ItemKey = Row_Item.ItemKey;
				NewRow_Item.RowKey = Row_Item.RowKey;
				NewRow_Item.Unit = Row_Item.Unit;
				NewRow_Item.Quantity = Row_Item.Quantity;
			EndDo;
		EndDo;
	EndDo;
	
EndProcedure

&AtClient
Procedure GoodsReceiptTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure GoodsReceiptTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(GetSelectedGoodsReceipt());
EndProcedure

&AtServer
Function GetSelectedGoodsReceipt()
	Result = New Array();
	For Each Row_Order In ThisObject.GoodsReceiptTree.GetItems() Do
		For Each Row_GoodsReceipt In Row_Order.GetItems() Do
			If Row_GoodsReceipt.Use Then
				Result.Add(Row_GoodsReceipt.GoodsReceipt);
			EndIf;
		EndDo;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure SelectAll(Command)
	For Each Row_Order In ThisObject.GoodsReceiptTree.GetItems() Do
		For Each Row_GoodsReceipt In Row_Order.GetItems() Do
			Row_GoodsReceipt.Use = True;
		EndDo;
	EndDo;
EndProcedure

