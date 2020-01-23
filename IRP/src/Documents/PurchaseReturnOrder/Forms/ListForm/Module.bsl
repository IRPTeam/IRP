#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPurchaseReturnOrderServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

#EndRegion


#Region Commands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

#EndRegion
