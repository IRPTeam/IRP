
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocJournalEntryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocJournalEntryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocJournalEntryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocJournalEntryClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.DecorationSaveDocument.Visible = Not ValueIsFilled(Object.Ref);
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

#Region ItemDate

&AtClient
Procedure DateOnChange(Item)
	DocJournalEntryClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocJournalEntryClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocJournalEntryClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocJournalEntryClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLedgerType

&AtClient
Procedure LedgerTypeOnChange(Item)
	DocJournalEntryClient.LedgerTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region SwitchRecordsActivity

&AtClient
Procedure SwitchRecordsActivity(Command)
	SwitchRecordsActivityAtServer();
EndProcedure

&AtServer
Procedure SwitchRecordsActivityAtServer()
	Records = Object.RegisterRecords.Basic;
	For Each Record In Records Do
		Record.Active = Not Record.Active;
	EndDo;
EndProcedure

#EndRegion

#Region ItemBasis

&AtClient
Procedure BasisOnChange(Item)
	DocJournalEntryClient.BasisOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region Service

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocJournalEntryClient);
	Str.Insert("Server", DocJournalEntryServer);
	Return Str;
EndFunction

#EndRegion
