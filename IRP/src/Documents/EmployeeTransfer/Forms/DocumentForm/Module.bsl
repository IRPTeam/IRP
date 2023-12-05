

#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocEmployeeTransferServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.FromSalaryType = ?(ValueIsFilled(Object.FromPersonalSalary),"Personal", "ByPosition");
	ThisObject.ToSalaryType = ?(ValueIsFilled(Object.ToPersonalSalary),"Personal", "ByPosition");
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocEmployeeTransferServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	ThisObject.FromSalaryType = ?(ValueIsFilled(Object.FromPersonalSalary),"Personal", "ByPosition");
	ThisObject.ToSalaryType = ?(ValueIsFilled(Object.ToPersonalSalary),"Personal", "ByPosition");
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocEmployeeTransferServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocEmployeeTransferClient.OnOpen(Object, ThisObject, Cancel);
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
	DocEmployeeTransferClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	If Form.FromSalaryType = "Personal" Then
		Form.Items.GroupFromSalaryAmount.CurrentPage = Form.Items.GroupFromPerosnalSalary;
	Else
		Form.Items.GroupFromSalaryAmount.CurrentPage = Form.Items.GroupFromSalaryByPosition;
	EndIf;
	
	If Form.ToSalaryType = "Personal" Then
		Form.Items.GroupToSalaryAmount.CurrentPage = Form.Items.GroupToPerosnalSalary;
	Else
		Form.Items.GroupToSalaryAmount.CurrentPage = Form.Items.GroupToSalaryByPosition;
	EndIf;
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
	DocEmployeeTransferClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocEmployeeTransferClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region EMPLOYEE

&AtClient
Procedure EmployeeOnChange(Item)
	DocEmployeeTransferClient.EmployeeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure ToPositionOnChange(Item)
	DocEmployeeTransferClient.ToPositionOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ToAccrualTypeOnChange(Item)
	DocEmployeeTransferClient.ToAccrualTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ToSalaryTypeOnChange(Item)
	If ThisObject.ToSalaryType = "ByPosition" Then
		Object.ToPersonalSalary = 0;
	EndIf;
	
	SetVisibilityAvailability(Object, ThisObject);	
EndProcedure

&AtClient
Procedure FillAsFrom(Command)
	If Not ValueIsFilled(Object.ToPosition) Then
		Object.ToPosition = Object.FromPosition;
	EndIf;
	
	If Not ValueIsFilled(Object.ToEmployeeSchedule) Then
		Object.ToEmployeeSchedule = Object.FromEmployeeSchedule;
	EndIf;
	
	If Not ValueIsFilled(Object.ToProfitLossCenter) Then
		Object.ToProfitLossCenter = Object.FromProfitLossCenter;
	EndIf;
	
	If Not ValueIsFilled(Object.ToBranch) Then
		Object.ToBranch = Object.Branch;
	EndIf;
	
	ThisObject.ToSalaryType = ThisObject.FromSalaryType;
	
	Object.ToAccrualType    = Object.FromAccrualType;
	Object.ToSalary         = Object.FromSalary;
	Object.ToPersonalSalary = Object.FromPersonalSalary;
	
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocEmployeeTransferClient);
	Str.Insert("Server", DocEmployeeTransferServer);
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
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
