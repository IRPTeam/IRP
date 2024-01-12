// @strict-types

#Region Public

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
// * HasOwnSessionParameters - Boolean - 
// * UsingObjectForm - Boolean - 
// * UsingListForm - Boolean - 
// * UsingChoiceForm - Boolean - 
// * Targets - Array, FixedArray - 
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

#EndRegion

#Region Internal

Procedure SetSessionParameters() Export
	
	InternalCommandsArray = New Array; // Array of FixedStructure
	
	CommandPrefix = "InternalCommand_";
	CommandSuffix = "_Server";
	
	For Each CommonModuleDescription In Metadata.CommonModules Do
		CommandName = CommonModuleDescription.Name;
		If Not StrStartsWith(CommandName, CommandPrefix) Or Not StrEndsWith(CommandName, CommandSuffix) Then
			Continue;
		EndIf;
		
		CommonModule = Eval(CommandName);
		CommandDescription = CommonModule.GetCommandDescription(); //  See GetCommandDescription
		InternalCommandsArray.Add(CommandDescription);
		
		If CommandDescription.HasActionInitialization Then
			CommonModule.Initialization();
		EndIf;
	EndDo;
	
	SessionParameters.InternalCommands = New FixedArray(InternalCommandsArray);
	
EndProcedure

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
		If ContentItem.Targets.Find(ObjectFullName) Then
			CommandArray.Add(ContentItem);
		EndIf;
	EndDo;
	
	CommandMap = New Map;
	For Each Command In CommandArray Do
		CommandName = "InternalCommand_" + Command.Name;
		CommandForm = Form.Commands.Add(CommandName); // FormCommand
		CommandForm.Action = "InternalCommandAction";
		CommandForm.Title = Command.Title;
		CommandForm.ToolTip = Command.ToolTip;
		If Not IsBlankString(Command.Picture) Then
			CommandForm.Picture = PictureLib[Command.Picture];
		EndIf;
		CommandForm.Representation = ButtonRepresentation[Command.Representation];
		
		CommandButton = Form.Items.Add(CommandName, Type("FormButton"), Form.CommandBar); // FormButton
		CommandButton.CommandName = CommandName;
		CommandButton.LocationInCommandBar = ButtonLocationInCommandBar[Command.LocationInCommandBar];
		
		If Command.HasActionOnCommandCreate Then
			InternalCommandModule = Eval(CommandName + "_Server");
			InternalCommandModule.OnCommandCreate(CommandButton, Command, Form, MainAttribute, ObjectFullName, FormType, AddInfo);
		EndIf;
		
		CommandMap.Insert(CommandName, Command);
	EndDo;
	
	If CommandMap.Count() > 0 Then
		NewAttribute = New FormAttribute("InternalCommands", New TypeDescription(""));
		NewAttributes = New Array; // Array of FormAttribute 
		NewAttributes.Add(NewAttribute);
		Form.ChangeAttributes(NewAttributes);
		Form.InternalCommands = New FixedMap(CommandMap);
	EndIf;
	
EndProcedure

#EndRegion