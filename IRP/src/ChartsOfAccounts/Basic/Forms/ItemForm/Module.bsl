
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	SetCodeMask();
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure VariantOnChange(Item)
	SetCodeMask();
EndProcedure

&AtServer
Procedure SetCodeMask()
	If ValueIsFilled(Object.Variant) And ValueIsFilled(Object.Variant.AccountChartsCodeMask) Then
		Items.Code.Mask = Object.Variant.AccountChartsCodeMask;
	EndIf;
EndProcedure
