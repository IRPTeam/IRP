
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
Procedure LedgerTypeVariantOnChange(Item)
	SetCodeMask();
EndProcedure

&AtServer
Procedure SetCodeMask()
	If ValueIsFilled(Object.LedgerTypeVariant) And ValueIsFilled(Object.LedgerTypeVariant.AccountChartsCodeMask) Then
		Items.Code.Mask = Object.LedgerTypeVariant.AccountChartsCodeMask;
	EndIf;
EndProcedure
