#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ItemsVisibility();
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdateAddAttributeAndPropertySets", New Structure(), ThisObject);
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ChildFormItemsGroupOnChange(Item)
	ItemsVisibility();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure ItemsVisibility()
	Items.Collapsed.Visible = Object.Behavior = Enums.InterfaceGroupBehaviors.Collapsible;
EndProcedure

#EndRegion