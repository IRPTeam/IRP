&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	If Object.Ref = ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency Then
		Items.DeferredCalculation.Visible = False;
		Items.Currency.Visible = False;
		Items.Source.Visible = False;
		Items.Type.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure