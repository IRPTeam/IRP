
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocJournalEntryServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocJournalEntryServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocJournalEntryServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
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
	Records = Object.RegisterRecords.R6010A_Master;
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
	DocItemStockAdjustmentClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocItemStockAdjustmentClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocItemStockAdjustmentClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocItemStockAdjustmentClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocItemStockAdjustmentClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
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
