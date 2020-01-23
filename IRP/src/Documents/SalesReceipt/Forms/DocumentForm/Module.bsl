&AtClient
Procedure PrintFiscalReceipt(Command)
	Return;
EndProcedure

&AtClient
Procedure InstallPrinterComponent(Command)
	EquipmentClient.InstallPrinterComponent();
EndProcedure


&AtClient
Procedure OpenDraw(Command)
	EquipmentClient.OpenDraw();
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

