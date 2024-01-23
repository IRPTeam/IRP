&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SetVisible();
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure SetVisible()
	Items.SpecialOfferType.Visible = Object.OfferGroupType = Enums.OfferGroupType.UseExternalCalculation;
EndProcedure

&AtClient
Procedure OfferGroupTypeOnChange(Item)
	SetVisible();
EndProcedure
