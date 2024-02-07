// @strict-types

#Region Public

// Set session parameters.
Procedure SetSessionParameters() Export
	
	InternalCommandsArray = New Array; // Array of FixedStructure
	
	For Each CommandFormDescription In Metadata.DataProcessors.InternalCommands.Forms Do
		If CommandFormDescription = Metadata.DataProcessors.InternalCommands.Forms.CommandTemplate Then
			Continue;
		EndIf;
		
		CommandName = CommandFormDescription.Name;
		CommandDescription = New FixedStructure(
			DataProcessors.InternalCommands.GetCommandDescription(CommandName));
		
		InternalCommandsArray.Add(CommandDescription);
	EndDo;
	
	SessionParameters.InternalCommands = New FixedArray(InternalCommandsArray);
	
EndProcedure

// Create commands.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute, DynamicList - Main attribute
//  ObjectFullName - String - Object full name
//  FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
Procedure CreateCommands(Form, MainAttribute, ObjectFullName, FormType, AddInfo = Undefined) Export
	
	CommandArray = New Array; // Array of See GetCommandDescription
	For Each ContentItem In SessionParameters.InternalCommands Do // See GetCommandDescription
		If FormType = Enums.FormTypes.ObjectForm And Not ContentItem.UsingObjectForm Then
			Continue;
		ElsIf FormType = Enums.FormTypes.ListForm And Not ContentItem.UsingListForm Then
			Continue;
		ElsIf FormType = Enums.FormTypes.ChoiceForm And Not ContentItem.UsingChoiceForm Then
			Continue;
		EndIf;
		If ContentItem.Targets.Find(ObjectFullName) <> Undefined Then
			CommandArray.Add(ContentItem);
		EndIf;
	EndDo;
	
	For Each Command In CommandArray Do
		CommandName = "InternalCommand_" + Command.Name;
		CommandForm = Form.Commands.Add(CommandName); // FormCommand
		CommandForm.Action = "InternalCommandAction";
		CommandForm.Title = Command.Title;
		CommandForm.ToolTip = Command.ToolTip;
		If Not IsBlankString(Command.Picture) Then
			CommandPicture = PictureLib[Command.Picture]; // Picture
			CommandForm.Picture = CommandPicture;
		EndIf;
		CommandRepresentation = ButtonRepresentation[Command.Representation]; // ButtonRepresentation
		CommandForm.Representation = CommandRepresentation;
		
		CommandButton = Form.Items.Add(CommandName, Type("FormButton"), GetFormGroupByName(Form, Command.LocationGroup)); // FormButton
		CommandButton.CommandName = CommandName;
		CommandLocationInCommandBar = ButtonLocationInCommandBar[Command.LocationInCommandBar]; // ButtonLocationInCommandBar 
		CommandButton.LocationInCommandBar = CommandLocationInCommandBar;
		
		IntenalCommandsParams = New Structure;
		IntenalCommandsParams.Insert("CommandButton", CommandButton);
		IntenalCommandsParams.Insert("CommandDescription", Command);
		IntenalCommandsParams.Insert("Form", Form);
		IntenalCommandsParams.Insert("MainAttribute", MainAttribute);
		IntenalCommandsParams.Insert("ObjectFullName", ObjectFullName);
		IntenalCommandsParams.Insert("FormType", FormType);
		
		DataProcessors.InternalCommands.OnCommandCreate(Command.Name, IntenalCommandsParams, AddInfo);
	EndDo;
	
EndProcedure

#EndRegion

#Region Internal

// Get command description.
// 
// Returns:
//  Structure - Get command description:
// * Name - String - 
// * Title - String - 
// * ToolTip - String - 
// * Picture - String - 
// * TitleCheck - String - 
// * PictureCheck - String - 
// * Representation - String - 
// * LocationInCommandBar - String - 
// * ModifiesStoredData - Boolean - 
// * LocationGroup - String - 
// * ForTables - Boolean - 
// * ForContextMenu - Boolean - 
// * SpecificTables - String - 
// * HasActionInitialization - Boolean - 
// * HasActionOnCommandCreate - Boolean - 
// * HasActionBeforeRunning - Boolean - 
// * HasActionAfterRunning - Boolean - 
// * UsingObjectForm - Boolean - 
// * UsingListForm - Boolean - 
// * UsingChoiceForm - Boolean - 
// * Targets - Array of String
//           - FixedArray of String 
Function GetCommandDescription() Export
	
	CommandDescription = New Structure;
	
	CommandDescription.Insert("Name", "");
	
	CommandDescription.Insert("Title", "");
	CommandDescription.Insert("TitleCheck", "");
	CommandDescription.Insert("Picture", "");
	CommandDescription.Insert("PictureCheck", "");
	CommandDescription.Insert("ToolTip", "");
	
	//CommandDescription.Insert("Representation", ButtonRepresentation.Auto);
	CommandDescription.Insert("Representation", "Auto");
	//CommandDescription.Insert("LocationInCommandBar", ButtonLocationInCommandBar.Auto);
	CommandDescription.Insert("LocationInCommandBar", "Auto");
	CommandDescription.Insert("ModifiesStoredData", False);
	
	CommandDescription.Insert("LocationGroup", "CommandBar");
	CommandDescription.Insert("ForTables", False);
	CommandDescription.Insert("ForContextMenu", False);
	CommandDescription.Insert("SpecificTables", "");
	
	CommandDescription.Insert("HasActionInitialization", False);
	CommandDescription.Insert("HasActionOnCommandCreate", False);
	CommandDescription.Insert("HasActionBeforeRunning", False);
	CommandDescription.Insert("HasActionAfterRunning", False);
	
	CommandDescription.Insert("UsingObjectForm", False);
	CommandDescription.Insert("UsingListForm", False);
	CommandDescription.Insert("UsingChoiceForm", False);
	
	Targets = New Array; // Array of String (Object.Metadata.FullName())
	CommandDescription.Insert("Targets", Targets);
	
	Return CommandDescription;
	
EndFunction

// Get command group description.
// 
// Returns:
//  Structure - Get command group description:
// * Name - String - 
// * Title - String - 
// * ToolTip - String - 
// * LocationGroup - String - 
// * Type - String - 
// * Representation - String - 
Function GetCommandGroupDescription() Export
	
	CommandGroupDescription = New Structure;
	
	CommandGroupDescription.Insert("Name", "");
	CommandGroupDescription.Insert("Title", "");
	CommandGroupDescription.Insert("ToolTip", "");
	
	CommandGroupDescription.Insert("LocationGroup", "");
	
	// FormGroupType.ButtonGroup, FormGroupType.Popup (for submenu), FormGroupType.CommandBar
	CommandGroupDescription.Insert("Type", "ButtonGroup"); 
	
	// ButtonGroupRepresentation.Auto, ButtonRepresentation.Auto (for submenu)
	CommandGroupDescription.Insert("Representation", "Auto"); 
	
	Return CommandGroupDescription;
	
EndFunction

// On command create.
// 
// Parameters:
// 	CommandName - String - Command name
// 	CommandParameters - Structure - Command parameters:
//  * CommandButton - FormButton - Command button
//  * CommandDescription - See InternalCommandsServer.GetCommandDescription
//  * Form - ClientApplicationForm - Form
//  * MainAttribute - FormAttribute, DynamicList - Main attribute
//  * ObjectFullName - String - Object full name
//  * FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
Procedure OnCommandCreate(CommandName, CommandParameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Private

// Get form group by name.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  LocationGroup - String - Location group
//  TableName - String - Table name
// 
// Returns:
//  Undefined, FormGroup - Get form group by name
Function GetFormGroupByName(Form, LocationGroup, TableName = "")
	
	CommandGroupDescription = DataProcessors.InternalCommands.GetCommandGroupDescription(LocationGroup);
	If CommandGroupDescription.Name = "" Then
		Return Undefined;
	EndIf;
	
	If CommandGroupDescription.Name = "CommandBar" Then
		If TableName = "" Then
			Return Form.CommandBar;
		EndIf;
		
		TableFormItem = Form.Items.Find(TableName); // FormTable
		If TableFormItem = Undefined Then
			Raise StrTemplate(R().Exc_010, TableName); 
		Else
			Return TableFormItem.CommandBar;
		EndIf;
		
	ElsIf CommandGroupDescription.Name = "ContextMenu" Then
		If TableName = "" Then
			Raise R().Exc_002;
		EndIf;
		
		TableFormItem = Form.Items.Find(TableName); // FormTable
		If TableFormItem = Undefined Then
			Raise StrTemplate(R().Exc_010, TableName); 
		Else
			Return TableFormItem.ContextMenu;
		EndIf;
	
	EndIf;
	
	FormName = ?(TableName = "", CommandGroupDescription.Name, TableName + "_" + CommandGroupDescription.Name);
	FormGroup = Form.Items.Find(FormName);
	If FormGroup <> Undefined Then
		Return FormGroup;
	EndIf;
	
	FormGroup = Form.Items.Add(
		FormName, Type("FormGroup"), GetFormGroupByName(Form, CommandGroupDescription.LocationGroup, TableName));
			
	FormGroup.Title = CommandGroupDescription.Title;
	FormGroup.ToolTip = CommandGroupDescription.ToolTip;
	
	GroupType = FormGroupType[CommandGroupDescription.Type];  // FormGroupType
	FormGroup.Type = GroupType;
	
	If GroupType = FormGroupType.ButtonGroup Then
		ButtonGroupRepresentationValue = ButtonGroupRepresentation[CommandGroupDescription.Representation]; // ButtonGroupRepresentation
		//@skip-check statement-type-change
		FormGroup.Representation = ButtonGroupRepresentationValue;
	ElsIf GroupType = FormGroupType.Popup Then
		ButtonRepresentationValue = ButtonRepresentation[CommandGroupDescription.Representation]; // ButtonRepresentation
		FormGroup.Representation = ButtonRepresentationValue;
	EndIf;
	
	Return FormGroup;
	
EndFunction

#EndRegion
