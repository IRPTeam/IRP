
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocumentsClientServer.ChangeTitleCollapse(, ThisObject);
	SplitedFormName = StrSplit(ThisObject.FormName, ".");
	SplitedFormName.Delete(SplitedFormName.UBound());
	ReportName = SplitedFormName.Get(SplitedFormName.UBound());
	ExternalCommandsServer.CreateCommands(ThisObject, ReportName, Catalogs.ConfigurationMetadata.Reports, Enums.FormTypes.ObjectForm);	
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedPictureClick(, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedLalelClick(, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedPictureClick(, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedLalelClick(, ThisObject, Item);
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