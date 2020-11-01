
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure