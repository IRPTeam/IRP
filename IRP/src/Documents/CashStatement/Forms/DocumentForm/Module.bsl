#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocCashStatementServer.AfterWriteAtServer(Object, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocCashStatementServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocCashStatementClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocCashStatementClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocCashStatementClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocCashStatementClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocCashStatementClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocCashStatementClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
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

#Region ItemFormEvents

&AtClient
Procedure DataPeriodOnChange(Item)
	DocCashStatementClient.DataPeriodOnChange(Object, DataPeriod);
EndProcedure

&AtClient
Procedure StatusOnChange(Item)
	DocCashStatementClient.StatusOnChange(ThisObject);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	DocCashStatementClient.CompanyOnChange(ThisObject);
EndProcedure

&AtClient
Procedure BranchOnChange(Item)
	DocCashStatementClient.BranchOnChange(ThisObject);
EndProcedure

&AtClient
Procedure DateOnChange(Item)
	DocCashStatementClient.DateOnChange(ThisObject);
EndProcedure

&AtClient
Procedure NumberOnChange(Item)
	DocCashStatementClient.NumberOnChange(ThisObject);
EndProcedure

&AtClient
Procedure FillTransactions(Command)
	FillTransactionsAtServer();
EndProcedure

&AtServer
Procedure FillTransactionsAtServer()
	DocCashStatementServer.FillTransactions(Object);
EndProcedure

&AtClient
Procedure BasisDocumentOnChange(Item)
	BasisDocumentOnChangeAtServer();
EndProcedure

&AtServer
Procedure BasisDocumentOnChangeAtServer()
	DocCashStatementServer.FillOnBasisDocument(Object);
EndProcedure

&AtClient
Procedure PaymentListOnChange(Item, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion
