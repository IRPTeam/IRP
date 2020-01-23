&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("InfoShipmentConfirmations") Then
		FillShipmentConfirmationTree(Parameters.InfoShipmentConfirmations);
	Else
		Cancel = True;
	EndIf;
EndProcedure

&AtServer
Procedure FillShipmentConfirmationTree(InfoShipmentConfirmations)
	ThisObject.ShipmentConfirmationsTree.GetItems().Clear();
	
	For Each Row_Order In InfoShipmentConfirmations Do
		NewRow_Order = ThisObject.ShipmentConfirmationsTree.GetItems().Add();
		NewRow_Order.Order = Row_Order.Order;
		For Each Row_ShipmentConfirmation In Row_Order.Rows Do
			NewRow_ShipmentConfirmation = NewRow_Order.GetItems().Add();
			NewRow_ShipmentConfirmation.ShipmentConfirmation = Row_ShipmentConfirmation.ShipmentConfirmation;
			For Each Row_Item In Row_ShipmentConfirmation.Rows Do
				NewRow_Item = NewRow_ShipmentConfirmation.GetItems().Add();
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
Procedure ShipmentConfirmationsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure ShipmentConfirmationsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Ok(Command)
	Close(GetSelectedShipmentConfirmations());
EndProcedure

&AtServer
Function GetSelectedShipmentConfirmations()
	Result = New Array();
	For Each Row_Order In ThisObject.ShipmentConfirmationsTree.GetItems() Do
		For Each Row_ShipmentConfirmation In Row_Order.GetItems() Do
			If Row_ShipmentConfirmation.Use Then
				Result.Add(Row_ShipmentConfirmation.ShipmentConfirmation);
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
	SetUseValue(True);
EndProcedure

&AtClient
Procedure UnselectAll(Command)
	SetUseValue(False);
EndProcedure

&AtClient
Procedure SetUseValue(UseValue)
	For Each Row_Order In ThisObject.ShipmentConfirmationsTree.GetItems() Do
		For Each Row_ShipmentConfirmation In Row_Order.GetItems() Do
			Row_ShipmentConfirmation.Use = UseValue;
		EndDo;
	EndDo;
EndProcedure

