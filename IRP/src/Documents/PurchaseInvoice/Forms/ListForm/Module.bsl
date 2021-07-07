#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPurchaseInvoiceServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
	ThisObject.List.Parameters.SetParameterValue("StatusClosed"    , R().Status_Closed);
	ThisObject.List.Parameters.SetParameterValue("StatusAwaiting"  , R().Status_Awaiting);
	ThisObject.List.Parameters.SetParameterValue("StatusInvoicing" , R().Status_Invoicing);
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
