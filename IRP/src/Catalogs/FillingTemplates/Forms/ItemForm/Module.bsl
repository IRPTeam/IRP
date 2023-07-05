
// @strict-types

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	TemplateActions.SettingsComposer.Settings.Filter.Items[0].RightValue = Object.Ref;
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - Arbitrary - Parameter
//  Source - Arbitrary - Source
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	AddAttributesCreateFormControl();
	TemplateActions.SettingsComposer.Settings.Filter.Items[0].RightValue = Object.Ref;
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdatedFillingTemplate", New Structure("Ref", Object.Ref));
EndProcedure

// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region AddAttributes

// Add attribute start choice.
// 
// Parameters:
//  Item - FormField - Item
//  ChoiceData - ValueList - Choice data
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion