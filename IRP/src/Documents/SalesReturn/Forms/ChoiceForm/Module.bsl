#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesReturnServer.OnCreateAtServerChoiceForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

#EndRegion


#Region Commands

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

#EndRegion
