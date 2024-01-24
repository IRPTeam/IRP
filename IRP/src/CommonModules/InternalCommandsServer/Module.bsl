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
		
		CommandButton = Form.Items.Add(CommandName, Type("FormButton"), Form.CommandBar); // FormButton
		CommandButton.CommandName = CommandName;
		CommandLocationInCommandBar = ButtonLocationInCommandBar[Command.LocationInCommandBar]; // ButtonLocationInCommandBar 
		CommandButton.LocationInCommandBar = CommandLocationInCommandBar;
		
		//@skip-check structure-consructor-too-many-keys
		DataProcessors.InternalCommands.OnCommandCreate(
			Command.Name,
			New Structure(
				"CommandButton, CommandDescription, Form, MainAttribute, ObjectFullName, FormType",
				CommandButton, Command, Form, MainAttribute, ObjectFullName, FormType), 
			AddInfo);
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
	
	Targets = New Array; // Array of String
	CommandDescription.Insert("Targets", Targets);
	
	Return CommandDescription;
	
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
