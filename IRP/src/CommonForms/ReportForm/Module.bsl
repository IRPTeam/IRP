
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocumentsClientServer.ChangeTitleCollapse(, ThisObject);
	ReportName = ReportName();
	ExternalCommandsServer.CreateCommands(ThisObject, ReportName, Catalogs.ConfigurationMetadata.Reports, Enums.FormTypes.ObjectForm);	
EndProcedure

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedPictureClick(, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedLabelClick(, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedPictureClick(, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedLabelClick(, ThisObject, Item);
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


#EndRegion