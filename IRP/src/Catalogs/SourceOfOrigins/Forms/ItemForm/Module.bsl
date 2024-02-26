
&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		FillParamsOnCreate();
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.Owner.Visible = Form.OwnerSelect = "Manual";
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	ThisObject.OwnerSelect = "Manual";
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure OwnerSelectOnChange(Item)
	UpdateAttributesByOwner();
EndProcedure

&AtClient
Procedure OwnerOnChange(Item)
	UpdateAttributesByOwner();
EndProcedure

&AtClient
Procedure UpdateAttributesByOwner()
	If OwnerSelect <> "Manual" Then
		Object.SourceOfOriginOwner = ThisObject[OwnerSelect];
	EndIf;
EndProcedure

&AtServer
Procedure FillParamsOnCreate()
	ThisObject.OwnerSelect = "Manual";

	If Not Parameters.ItemType.IsEmpty() Then
		ThisObject.ItemType = Parameters.ItemType;
		Object.SourceOfOriginOwner = Parameters.ItemType;
		Items.OwnerSelect.ChoiceList.Add("ItemType", ThisObject.ItemType);
		ThisObject.OwnerSelect = "ItemType";
	EndIf;
	
	If Not Parameters.Item.IsEmpty() Then
		ThisObject.Item = Parameters.Item;
		Object.SourceOfOriginOwner = Parameters.Item;
		Items.OwnerSelect.ChoiceList.Add("Item", ThisObject.Item);
		ThisObject.OwnerSelect = "Item";
	EndIf;
	
	If Not Parameters.ItemKey.IsEmpty() Then
		ThisObject.ItemKey = Parameters.ItemKey;
		Object.SourceOfOriginOwner = Parameters.ItemKey;
		Items.OwnerSelect.ChoiceList.Add("ItemKey", ThisObject.ItemKey);
		ThisObject.OwnerSelect = "ItemKey";
	EndIf;
		
	// delete manual, if have other types
	If Items.OwnerSelect.ChoiceList.Count() > 1 Then
		Items.OwnerSelect.ChoiceList.Delete(0);
	EndIf;
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

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion