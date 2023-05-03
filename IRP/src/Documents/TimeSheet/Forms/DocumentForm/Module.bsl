
#Region FORM

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocTimeSheetServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	FillWorkersAtServer();
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocTimeSheetServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
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
	DocPayrollServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocTimeSheetClient.OnOpen(Object, ThisObject, Cancel);
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
	DocTimeSheetClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
	SetVisibleRowsTimeSheetList();
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.FillTimeSheet.Enabled = Not Form.ReadOnly;
EndProcedure

#EndRegion

#Region _DATE

&AtClient
Procedure DateOnChange(Item)
	DocTimeSheetClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region COMPANY

&AtClient
Procedure CompanyOnChange(Item)
	DocTimeSheetClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocTimeSheetClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocTimeSheetClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region TIME_SHEET_LIST

&AtClient
Procedure TimeSheetListSelection(Item, RowSelected, Field, StandardProcessing)
	DocTimeSheetClient.TimeSheetListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure TimeSheetListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocTimeSheetClient.TimeSheetListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
	CurrentData = Items.Workers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FillingValues = New Structure();
	FillingValues.Insert("Employee", CurrentData.Employee);
	FillingValues.Insert("Position", CurrentData.Position);
	
	ViewClient_V2.TimeSheetListAddFilledRow(Object, ThisObject, FillingValues);
	SetVisibleRowsTimeSheetList();
EndProcedure

&AtClient
Procedure TimeSheetListBeforeDeleteRow(Item, Cancel)
	DocTimeSheetClient.TimeSheetListBeforeDeleteRow(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure TimeSheetListAfterDeleteRow(Item)
	DocTimeSheetClient.TimeSheetListAfterDeleteRow(Object, ThisObject, Item);
	FillWorkersAtClient();
EndProcedure

#Region TIME_SHEET_LIST_COLUMNS

#EndRegion

#EndRegion

#Region WORKERS

&AtClient
Procedure SetVisibleRowsTimeSheetList()
	CurrentData = Items.Workers.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	For Each Row In Object.TimeSheetList Do
		Row.Visible = 
			(Row.Employee = CurrentData.Employee)
			And (Row.Position = CurrentData.Position);
	EndDo;
	
	For Each Row In Object.TimeSheetList Do
		If Row.Visible Then
			Items.TimeSheetList.CurrentRow = Row.GetID();
			Break;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure WorkersOnActivateRow(Item)
	SetVisibleRowsTimeSheetList();
EndProcedure

&AtClient
Procedure WorkersBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure WorkersBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

#EndRegion

#Region SERVICE

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocTimeSheetClient);
	Str.Insert("Server", DocTimeSheetServer);
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
Async Procedure FillTimeSheet(Command)	
	TableIsFilled = Object.TimeSheetList.Count() > 0;
	
	If TableIsFilled Then
		Answer = Await DoQueryBoxAsync(R().QuestionToUser_015, QuestionDialogMode.OKCancel);
	EndIf;
	
	If Not TableIsFilled Or Answer = DialogReturnCode.OK Then
		Result = FillTimeSheetAtServer();
		Object.TimeSheetList.Clear();	
		ViewClient_V2.TimeSheetListLoad(Object, ThisObject, Result.Address, Result.GroupColumn, Result.SumColumn);
		ThisObject.Modified = True;
		FillWorkersAtClient();
	EndIf;
EndProcedure

&AtServer
Function FillTimeSheetAtServer()
	FillingParameters = New Structure();
	FillingParameters.Insert("Company"   , Object.Company);
	FillingParameters.Insert("Branch"    , Object.Branch);
	FillingParameters.Insert("BeginDate" , Object.BeginDate);
	FillingParameters.Insert("EndDate"   , Object.EndDate);
	
	Result = DocTimeSheetServer.GetTimeSheet(FillingParameters);
	Address = PutToTempStorage(Result.Table, ThisObject.UUID);
	Return New Structure("Address, GroupColumn, SumColumn", Address, Result.GroupColumn, Result.SumColumn);
EndFunction

&AtClient
Procedure FillWorkersAtClient()
	CurrentData = Items.Workers.CurrentData;
	CurrentData_Employee = Undefined;
	CurrentData_Position = Undefined;
	CurrentData_ProfitLisCenter = Undefined;
	If CurrentData <> Undefined Then
		CurrentData_Employee = CurrentData.Employee;
		CurrentData_Position = CurrentData.Position;
		CurrentData_ProfitLisCenter = CurrentData.ProfitLossCenter;
	EndIf;
	FillWorkersAtServer(CurrentData_Employee, CurrentData_Position, CurrentData_ProfitLisCenter);
EndProcedure

&AtServer
Procedure FillWorkersAtServer(CurrentData_Employee = Undefined, 
							  CurrentData_Position = Undefined, 
							  CurrentData_ProfitLossCenter = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	TimeSheetList.Employee,
	|	TimeSheetList.Position,
	|	TimeSheetList.ProfitLossCenter,
	|	TimeSheetList.Date
	|into TimeSheetList
	|From
	|	&TimeSheetList AS TimeSheetList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TimeSheetList.Employee,
	|	TimeSheetList.Position,
	|	TimeSheetList.ProfitLossCenter,
	|	MIN(TimeSheetList.Date) AS BeginDate,
	|	MAX(TimeSheetList.Date) AS EndDate
	|FROM
	|	TimeSheetList AS TimeSheetList
	|GROUP BY
	|	TimeSheetList.Employee,
	|	TimeSheetList.Position,
	|	TimeSheetList.ProfitLossCenter
	|
	|ORDER BY
	|	Employee";
	Query.SetParameter("TimeSheetList", Object.TimeSheetList.Unload());
	QueryResult = Query.Execute();
	
	ThisObject.Workers.Load(QueryResult.Unload());
	
	CurrentRowIsSet = False;
	If CurrentData_Employee <> Undefined 
		And CurrentData_Position <> Undefined 
		And CurrentData_ProfitLossCenter <> Undefined Then
		
		For Each Row In ThisObject.Workers Do
			If Row.Employee = CurrentData_Employee
				And Row.Position = CurrentData_Position
				And Row.ProfitLossCenter = CurrentData_ProfitLossCenter Then
				Items.Workers.CurrentRow = Row.GetID();
				CurrentRowIsSet = True;
				Break;
			EndIf;
		EndDo;
	EndIf;
	
	If ThisObject.Workers.Count() And Not CurrentRowIsSet Then
		Items.Workers.CurrentRow = ThisObject.Workers[0].GetID();
	EndIf;
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
