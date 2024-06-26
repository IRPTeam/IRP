
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocEmployeeHiringServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.SalaryType = ?(ValueIsFilled(Object.PersonalSalary),"Personal", "ByPosition");
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocEmployeeHiringServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	
	ThisObject.SalaryType = ?(ValueIsFilled(Object.PersonalSalary),"Personal", "ByPosition");
	
	ThisObject.VacationDaysCompany = 
		InformationRegisters.T9545S_VacationDaysLimits.GetLimit(Object.Date, Object.Company);
	If ValueIsFilled(ThisObject.VacationDays) Then
		ThisObject.VacationDays = Object.VacationDayLimit;
		ThisObject.VacationDaysType = "Personal";
	Else
		ThisObject.VacationDays = ThisObject.VacationDaysCompany;
		ThisObject.VacationDaysType = "ByCompany";
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocEmployeeHiringServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocEmployeeHiringClient.OnOpen(Object, ThisObject, Cancel);
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

&AtClient
Procedure AfterWrite(WriteParameters)
	DocEmployeeHiringClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)	
	If Form.SalaryType = "Personal" Then
		Form.Items.GroupSalaryAmount.CurrentPage = Form.Items.GroupPerosnalSalary;
	Else
		Form.Items.GroupSalaryAmount.CurrentPage = Form.Items.GroupSalaryByPosition;
	EndIf;
	
	If Form.VacationDaysType = "Personal" Then
		Form.Items.VacationDays.ReadOnly = False;
	Else
		Form.Items.VacationDays.ReadOnly = True;
	EndIf;
EndProcedure

&AtClient
Procedure SalaryTypeOnChange(Item)
	If ThisObject.SalaryType = "ByPosition" Then
		Object.PersonalSalary = 0;
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure VacationDaysTypeOnChange(Item)
	If ThisObject.VacationDaysType = "ByCompany" Then
		Object.VacationDayLimit = 0;
		ThisObject.VacationDays = ThisObject.VacationDaysCompany;
	Else
		Object.VacationDayLimit = ThisObject.VacationDays;
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure VacationDaysOnChange(Item)
	Object.VacationDayLimit = ThisObject.VacationDays;
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

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocEmployeeHiringClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocEmployeeHiringClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region EMPLOYEE

&AtClient
Procedure EmployeeOnChange(Item)
	DocEmployeeHiringClient.EmployeeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region POSITION

&AtClient
Procedure PositionOnChange(Item)
	DocEmployeeHiringClient.PositionOnChange(Object, ThisObject, Item);	
EndProcedure

#EndRegion

#Region ACCRUAL_TYPE

&AtClient
Procedure AccrualTypeOnChange(Item)
	DocEmployeeHiringClient.AccrualTypeOnChange(Object, ThisObject, Item);		
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocEmployeeHiringClient);
	Str.Insert("Server", DocEmployeeHiringServer);
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

#EndRegion
