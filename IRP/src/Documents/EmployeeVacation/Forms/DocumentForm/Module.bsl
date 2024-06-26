
#Region FORM
//++
&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocEmployeeVacationServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	For Each EmployeeRow In Object.EmployeeList Do
		CalculateEmployeeRowAtServer(EmployeeRow.GetID());
	EndDo;
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure
//++
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocEmployeeVacationServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure
//++
&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocEmployeeVacationServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	For Each EmployeeRow In Object.EmployeeList Do
		CalculateEmployeeRowAtServer(EmployeeRow.GetID());
	EndDo;
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

//++
&AtClient
Procedure OnOpen(Cancel)
	DocEmployeeVacationClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure
//++
&AtClient
Procedure AfterWrite(WriteParameters)
	DocEmployeeVacationClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Return
EndProcedure

&AtClient
Procedure _IdeHandler()
	ViewClient_V2.ViewIdleHandler(ThisObject, Object);
EndProcedure

&AtClient
Procedure _AttachIdleHandler() Export
	AttachIdleHandler("_IdeHandler", 1);
EndProcedure

&AtClient 
Procedure _DetachIdleHandler() Export
	DetachIdleHandler("_IdeHandler");
EndProcedure

#EndRegion

#Region FORM_ITEMS

#Region _DATE
//++
&AtClient
Procedure DateOnChange(Item)
	DocEmployeeVacationClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY
//++
&AtClient
Procedure CompanyOnChange(Item)
	DocEmployeeVacationClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure EmployeeListEmployeeOnChange(Item)
	CalculateEmployeeRow(Items.EmployeeList.CurrentData);
EndProcedure

&AtClient
Procedure EmployeeListEndDateOnChange(Item)
	CalculateEmployeeRow(Items.EmployeeList.CurrentData);
EndProcedure

&AtClient
Procedure EmployeeListBeginDateOnChange(Item)
	CalculateEmployeeRow(Items.EmployeeList.CurrentData);
EndProcedure

&AtClient
Procedure EmployeeListPaidDaysOnChange(Item)
	EmployeeRow = Items.EmployeeList.CurrentData;
	If EmployeeRow.PaidDays > EmployeeRow.TotalDays Then
		EmployeeRow.PaidDays = EmployeeRow.TotalDays;
	EndIf;
	EmployeeRow.OwnCostDays = EmployeeRow.TotalDays - EmployeeRow.PaidDays;
EndProcedure

#EndRegion

#Region SERVICE
//++
&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocEmployeeVacationClient);
	Str.Insert("Server", DocEmployeeVacationServer);
	Return Str;
EndFunction

#Region DESCRIPTION

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	CommonFormActions.EditMultilineText(ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, True);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClientServer.ChangeTitleCollapse(Object, ThisObject, False);
EndProcedure

#EndRegion

#Region ADD_ATTRIBUTES

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

&AtClient
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region EXTERNAL_COMMANDS

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

#Region COMMANDS

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

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

&AtClient
Procedure CalculateEmployeeRow(EmployeeRow)
	If NOT ValueIsFilled(EmployeeRow.Employee)
			OR NOT ValueIsFilled(EmployeeRow.BeginDate)
			OR NOT ValueIsFilled(EmployeeRow.EndDate)
			OR EmployeeRow.EndDate < EmployeeRow.BeginDate Then
		EmployeeRow.TotalDays = 0;
		EmployeeRow.PaidDays = 0;
		EmployeeRow.OwnCostDays = 0;
		Return;
	EndIf;
	CalculateEmployeeRowAtServer(EmployeeRow.GetID());
EndProcedure

&AtServer
Procedure CalculateEmployeeRowAtServer(EmployeeRowID)
	EmployeeRow = Object.EmployeeList.FindByID(EmployeeRowID);
	EmployeeRow.TotalDays = Max((EmployeeRow.EndDate - EmployeeRow.BeginDate) / 86400 + 1, 0);
	If EmployeeRow.PaidDays = 0 Or EmployeeRow.PaidDays > EmployeeRow.TotalDays Then
		EmployeeRow.PaidDays = EmployeeRow.TotalDays;
	EndIf;
	EmployeeRow.OwnCostDays = EmployeeRow.TotalDays - EmployeeRow.PaidDays;
EndProcedure
	
#EndRegion
