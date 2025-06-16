// @strict-types

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CreateDescriptionItems();
	
	FormNamesArray = StrSplit(ThisObject.FormName, ".");
	CatalogFullName = FormNamesArray[0] + "." + FormNamesArray[1];
	
	ExternalCommandsServer.CreateCommands(ThisObject, CatalogFullName, Enums.FormTypes.ObjectForm);
	InternalCommandsServer.CreateCommands(ThisObject, Object, CatalogFullName, Enums.FormTypes.ObjectForm);

	If Not Object.Ref.IsEmpty() Then
		ThisObject.ReadOnly = True;
	EndIf;
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	RefreshTaskAdressing();
	ReadFlowchart();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	If EventName = "RefreshTaskAdressing" Then
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
Procedure TemplateOnChange(Item)
	TemplateOnChangeAtServer();
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

&AtServer
Procedure TemplateOnChangeAtServer()
	
	ServerObject = FormAttributeToValue("Object");
	ServerObject.Fill(Object.Template);
	
	ValueToFormAttribute(ServerObject, "Object");
	RefreshTaskAdressing();

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

&AtServer
Procedure ReadFlowchart()
	
	If Object.Ref.IsEmpty() Then
		Items.PageFlowchart.Visible = False;
		Return;
	EndIf;
	
	Items.PageFlowchart.Visible = True;
	FlowchartDocument = BusinessProcesses.ExecutionProcesses.GetExecutionFlowchart(Object.Ref);

EndProcedure

#EndRegion
