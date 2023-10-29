&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupMainPages);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ObjectAccessDoNotControlOnChange(Item)
	CurrentRow = Items.ObjectAccess.CurrentData;
	CurrentRow.ValueRef = Undefined;
EndProcedure

&AtClient
Procedure CopySettings(Command)
	NotifyOnClose = New NotifyDescription("CopySettingsAfterSelect", ThisObject);
	OpenForm("Catalog.AccessGroups.ChoiceForm", , , , , , NotifyOnClose);
EndProcedure

&AtClient
Procedure CopySettingsAfterSelect(Result, AddInfo) Export
	If Not ValueIsFilled(Result) Then
		Return;
	EndIf;
	CopySettingsAtServer(Result);
EndProcedure

// Copy settings at server.
// 
// Parameters:
//  SelectedAG - CatalogRef.AccessGroups -
&AtServer
Procedure CopySettingsAtServer(SelectedAG)
	For Each Row In SelectedAG.ObjectAccess Do
		FillPropertyValues(Object.ObjectAccess.Add(), Row);
	EndDo;
EndProcedure

&AtClient
Procedure ObjectAccessAccessKeyOnChange(Item)
	CurrentRow = Items.ObjectAccess.CurrentData;
	CurrentRow.Key = String(CurrentRow.AccessKey);
EndProcedure

#Region AddAttributes

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