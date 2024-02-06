
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocJournalEntryServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure CreateDocuments(Command)
	OpenForm("Document.JournalEntry.Form.CreateDocuments", , ThisObject, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure UpdateAnalytics(Command)
	OpenForm("Document.JournalEntry.Form.UpdateAnalytics", , ThisObject, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

#EndRegion