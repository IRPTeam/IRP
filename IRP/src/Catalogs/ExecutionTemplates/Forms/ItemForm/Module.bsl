// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CreateDescriptionItems();
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	LocalizationEvents.FillDescription(Parameters.FillingText, Object);
	AddAttributesAndPropertiesServer.OnCreateAtServer(ThisObject);
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	RefreshTaskAdressing();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
		
	ElsIf EventName = "RefreshTaskAdressing" Then
		RefreshTaskAdressing()
		
	EndIf;
	
EndProcedure

#EndRegion

#Region FormItemsEvents

// Description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

// Execution stages description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure ExecutionStagesDescriptionOpening(Item, StandardProcessing)
	CurrentRow = Items.ExecutionStages.CurrentData;
	LocalizationClient.DescriptionInTableOpening(CurrentRow, ThisObject, Item, StandardProcessing);
EndProcedure

// Stages tasks description opening.
// 
// Parameters:
//  Item - FormField - Item
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure StagesTasksDescriptionOpening(Item, StandardProcessing)
	CurrentRow = Items.StagesTasks.CurrentData;
	LocalizationClient.DescriptionInTableOpening(CurrentRow, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure ExecutionObjectsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	
	Cancel = True;

	NewRow = Object.ExecutionObjects.Add();
	If Clone Then
		CurrentRow = Items.ExecutionObjects.CurrentData;
		FillPropertyValues(NewRow, CurrentRow);
	EndIf;
	
	NewRow.AutostartProcesses = PredefinedValue("Enum.AutostartProcessTypes.NotUsed");

	Items.ExecutionObjects.Refresh();
	ThisObject.CurrentItem = Items.ExecutionObjects;
	Items.ExecutionObjects.CurrentRow = NewRow.GetID();

EndProcedure

// Execution stages on activate row.
// 
// Parameters:
//  Item - FormTable - Item
&AtClient
Procedure ExecutionStagesOnActivateRow(Item)
	
	CurrentStage = New UUID("00000000-0000-0000-0000-000000000000");
	If Items.ExecutionStages.CurrentData <> Undefined Then
		CurrentStage = Items.ExecutionStages.CurrentData.StageID;
	EndIf;
	
	Items.StagesTasks.RowFilter = New FixedStructure("StageID", CurrentStage);

EndProcedure

&AtClient
Procedure ExecutionStagesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	
	Cancel = True;

	NewRow = Object.ExecutionStages.Add();
	If Clone Then
		CurrentRow = Items.ExecutionStages.CurrentData;
		FillPropertyValues(NewRow, CurrentRow);
	EndIf;
	
	NewRow.StageID = New UUID();

	Items.ExecutionStages.Refresh();
	ThisObject.CurrentItem = Items.ExecutionStages;
	Items.ExecutionStages.CurrentRow = NewRow.GetID();

EndProcedure

&AtClient
Procedure StagesTasksBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	
	Cancel = True;
	
	If Items.ExecutionStages.CurrentData = Undefined Then
		Return;
	EndIf;
	
	NewRow = Object.StagesTasks.Add();
	If Clone Then
		CurrentRow = Items.StagesTasks.CurrentData;
		FillPropertyValues(NewRow, CurrentRow);
	EndIf;
	
	NewRow.TaskID = New UUID();
	NewRow.StageID = Items.ExecutionStages.CurrentData.StageID;
	If NewRow.TaskType.IsEmpty() Then
		NewRow.TaskType = PredefinedValue("Enum.TaskTypes.Execution");
	EndIf;
	
	Items.StagesTasks.Refresh();
	ThisObject.CurrentItem = Items.StagesTasks;
	Items.StagesTasks.CurrentRow = NewRow.GetID();

EndProcedure

&AtClient
Procedure StagesTasksAddressingOpening(Item, StandardProcessing)
	StandardProcessing = False;
	OpenForm("Catalog.ExecutionTemplates.Form.AddressingForm", 
		New Structure("TaskRow", 
			New Structure("Executor,UserGroup,Position,Branch,ProfitLossCenter,TableName,TableRow",
				Items.StagesTasks.CurrentData.Executor,
				Items.StagesTasks.CurrentData.UserGroup,
				Items.StagesTasks.CurrentData.Position,
				Items.StagesTasks.CurrentData.Branch,
				Items.StagesTasks.CurrentData.ProfitLossCenter,
				"StagesTasks",
				Items.StagesTasks.CurrentData.GetID())), 
		ThisObject, , , , , 
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure StagesTasksDetailingOpening(Item, StandardProcessing)
	StandardProcessing = False;

	EditingParameters = New Structure(
		"ItemName, TableName, TableIndex", 
		"Detailing", "StagesTasks", Object.StagesTasks.IndexOf(Items.StagesTasks.CurrentData));
		
	OpenForm("CommonForm.EditMultilineText", 
		EditingParameters, ThisObject, , , ,
		New CallbackDescription(
			"OnEditedMultilineTextEnd", 
			ThisObject, 
			EditingParameters),
		FormWindowOpeningMode.LockOwnerWindow);

EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
//@skip-check method-param-value-type
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject);
EndProcedure

&AtClient
//@skip-check method-param-value-type
Procedure AddAttributeButtonClick(Item) Export
	AddAttributesAndPropertiesClient.AddAttributeButtonClick(ThisObject, Item);
EndProcedure

#EndRegion

#Region COMMANDS

// Generated form command action by name.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

// Generated form command action by name server.
// 
// Parameters:
//  CommandName - String - Command name
&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

// Internal command action.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

// Internal command action with server context.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

// Internal command action with server context at server.
// 
// Parameters:
//  CommandName - String - Command name
&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion

#Region Other

&AtServer
Procedure CreateDescriptionItems()
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	
	LocalizationCode = LocalizationReuse.GetLocalizationCode();
	
	NewAttribute = Items.Insert("ExecutionStagesDescription", Type("FormField"), Items.ExecutionStages, Items.ExecutionStagesTasksStartTogether); // FormFieldExtensionForATextBox
	NewAttribute.Type = FormFieldType.InputField;
	NewAttribute.DataPath = "Object.ExecutionStages.Description_" + LocalizationCode;
	NewAttribute.SetAction("Opening", "ExecutionStagesDescriptionOpening");
	NewAttribute.OpenButton = True;
	
	NewAttribute = Items.Insert("StagesTasksDescription", Type("FormField"), Items.StagesTasks, Items.StagesTasksAddressing); // FormFieldExtensionForATextBox
	NewAttribute.Type = FormFieldType.InputField;
	NewAttribute.DataPath = "Object.StagesTasks.Description_" + LocalizationCode;
	NewAttribute.SetAction("Opening", "StagesTasksDescriptionOpening");
	NewAttribute.OpenButton = True;
	
EndProcedure

&AtServer
Procedure RefreshTaskAdressing()
	For Each TaskRow In Object.StagesTasks Do
		AdressingArray = New Array; // Array of String
		If Not TaskRow.Executor.IsEmpty() Then
			AdressingArray.Add(String(TaskRow.Executor));
		EndIf;
		If Not TaskRow.UserGroup.IsEmpty() Then
			AdressingArray.Add(String(TaskRow.UserGroup));
		EndIf;
		If Not TaskRow.Position.IsEmpty() Then
			AdressingArray.Add(String(TaskRow.Position));
		EndIf;
		If Not TaskRow.Branch.IsEmpty() Then
			AdressingArray.Add(String(TaskRow.Branch));
		EndIf;
		If Not TaskRow.ProfitLossCenter.IsEmpty() Then
			AdressingArray.Add(String(TaskRow.ProfitLossCenter));
		EndIf;
		TaskRow.Addressing = StrConcat(AdressingArray, ", ");
	EndDo;
EndProcedure

// On edited multiline text end.
// 
// Parameters:
//  Result - String - Result
//  AddInfo - Structure:
//	* ItemName - String - Item name
//	* TableName - String - Table name
//	* TableIndex - Number - Table index
&AtClient
Procedure OnEditedMultilineTextEnd(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	Modified = True;
	Object[AddInfo.TableName][AddInfo.TableIndex][AddInfo.ItemName] = Result;
	
EndProcedure

#EndRegion