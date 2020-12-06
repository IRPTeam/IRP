
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ReportName = ReportName();
	ExternalCommandsServer.CreateCommands(ThisObject, ReportName, Catalogs.ConfigurationMetadata.Reports, Enums.FormTypes.ObjectForm);	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	CustomParametersSwitch();
	EditReportSwitch();
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure CustomParameters(Command)
	Items.FormCustomParameters.Check = Not Items.FormCustomParameters.Check;
	CustomParametersSwitch();
EndProcedure

&AtClient
Procedure EditReport(Command)
	Items.FormEditReport.Check = Not Items.FormEditReport.Check;
	EditReportSwitch();
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Report, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);	
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Report, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region Private

&AtServer
Function ReportName()
	SplittedFormName = StrSplit(ThisObject.FormName, ".");
	SplittedFormName.Delete(SplittedFormName.UBound());
	Return SplittedFormName.Get(SplittedFormName.UBound());
EndFunction

&AtClient
Procedure CustomParametersSwitch()
	Items.GroupCustomParameters.Visible = Items.FormCustomParameters.Check;
EndProcedure

&AtClient
Procedure EditReportSwitch()
	Items.GroupResultCommandBar.Visible = Items.FormEditReport.Check;
	Items.Result.Edit = Items.FormEditReport.Check;
EndProcedure

#EndRegion