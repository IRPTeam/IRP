
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	If Object.Parent <> Catalogs.ConfigurationMetadata.Documents Then
		Items.ELedgerLongDescription.Visible = False;
		Items.ELedgerShortDescription.Visible = False;
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	
	Query = New Query;
	Query.SetParameter("Ref", Object.Ref);
	Query.Text =
	"SELECT
	|	ObjectsPrintTemplates.PrintTemplate
	|FROM
	|	InformationRegister.ObjectsPrintTemplates AS ObjectsPrintTemplates
	|WHERE
	|	ObjectsPrintTemplates.Object = &Ref";
	
	PrintTemplates.Clear();
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		PrintTemplates.Add(QuerySelection.PrintTemplate);
	EndDo;

EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)

	ObjectRecords = InformationRegisters.ObjectsPrintTemplates.CreateRecordSet();
	ObjectRecords.Filter.Object.Set(CurrentObject.Ref, True);
	
	For Each PrintTemplateItem In PrintTemplates Do
		Record = ObjectRecords.Add();
		Record.Object = CurrentObject.Ref;
		Record.PrintTemplate = PrintTemplateItem.Value;
	EndDo;
	
	ObjectRecords.Write(True);

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

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion