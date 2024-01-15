#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	IDInfoServer.AfterWriteAtServer(ThisObject, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	IDInfoClient.NotificationProcessing(ThisObject, Object.Ref, EventName, Parameter, Source);
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	If EventName = "UpdateIDInfo" Then
		IDInfoCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	IDInfoServer.OnCreateAtServer(ThisObject, "GroupContactInformation");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref, Items.GroupPages);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
EndProcedure

#EndRegion

&AtClient
Procedure UseGoodsReceiptOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure UseShipmentConfirmationOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#Region IDInfo

&AtClient
Procedure IDInfoOpening(Item, StandardProcessing) Export
	IDInfoClient.IDInfoOpening(Item, StandardProcessing, Object, ThisObject);
EndProcedure

&AtClient
Procedure StartEditIDInfo(Result, Parameters) Export
	IDInfoClient.StartEditIDInfo(ThisObject, Result, Parameters);
EndProcedure

&AtClient
Procedure EndEditIDInfo(Result, Parameters) Export
	IDInfoClient.EndEditIDInfo(Object, Result, Parameters);
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

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

&AtServer
Procedure IDInfoCreateFormControl()
	IDInfoServer.CreateFormControls(ThisObject);
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion