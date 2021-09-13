
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillPropertyValues(ThisObject, Parameters.FillingData);
	ParamsData = Parameters.FillingData;
EndProcedure

&AtClient
Procedure OK()
	ParamsData.Quantity = ScannedQuantity;
	Close(ParamsData);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("SetActiveField", 1, True);
EndProcedure

&AtClient
Procedure SetActiveField() Export
	ThisObject.CurrentItem = Items.ScannedQuantity;
#If MobileClient Then
	BeginEditingItem();
#EndIf

EndProcedure

&AtClient
Procedure ScannedQuantityOnChange(Item)
	OK();
EndProcedure
