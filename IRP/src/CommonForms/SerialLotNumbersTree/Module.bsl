
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.SerialLotNumbersTree.GetItems().Clear();
	For Each RowItemList In Parameters.Object.ItemList Do
		ArrayOfSerialLotNumbers = Parameters.Object.SerialLotNumbers.FindRows(New Structure("Key", RowItemList.Key));
		If ArrayOfSerialLotNumbers.Count() Then
			NewRow0 = ThisObject.SerialLotNumbersTree.GetItems().Add();
			NewRow0.Level           = 1;
			NewRow0.Key             = RowItemList.Key;
			NewRow0.Item            = RowItemList.Item;
			NewRow0.ItemKey         = RowItemList.ItemKey;
			NewRow0.ItemKeyQuantity = RowItemList.Quantity;

			For Each RowSerialLotNumber In ArrayOfSerialLotNumbers Do
				NewRow1 = NewRow0.GetItems().Add();
				NewRow1.Level           = 2;
				NewRow1.Key             = RowItemList.Key;
				NewRow1.SerialLotNumber = RowSerialLotNumber.SerialLotNumber;
				NewRow1.Quantity        = RowSerialLotNumber.Quantity;
				NewRow0.Quantity        = NewRow0.Quantity + RowSerialLotNumber.Quantity;
			EndDo;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("ExpandTree", 1, True);
EndProcedure

&AtClient
Procedure ExpandTree() Export
	If ThisObject.Items.SerialLotNumbersTree.Visible Then
		For Each ItemTreeRows In ThisObject.SerialLotNumbersTree.GetItems() Do
			ThisObject.Items.SerialLotNumbersTree.Expand(ItemTreeRows.GetID());
		EndDo;
	EndIf;
EndProcedure

