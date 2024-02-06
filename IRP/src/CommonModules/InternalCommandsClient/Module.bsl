// @strict-types

#Region Public

// Run command action.
// 
// Parameters:
//  Command - FormCommand - Command
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  Targets - AnyRef, Array of AnyRef - Command target
//  AddInfo - Undefined -  Add info
Procedure RunCommandAction(Command, Form, MainAttribute, Targets, AddInfo = Undefined) Export

	CommandFormItem = Form.Items.Find(Command.Name);
	
	CommandName = Mid(Command.Name, StrLen("InternalCommand_") + 1);
	//@skip-check use-non-recommended-method
	InternalCommandModule = GetForm("DataProcessor.InternalCommands.Form." + CommandName); // See DataProcessor.InternalCommands.Form.CommandTemplate
	
	//@skip-check property-return-type
	CommandDescription = InternalCommandModule.CommandDescription; // See InternalCommandsServer.GetCommandDescription
	
	If CommandDescription.HasActionBeforeRunning Then
		//@skip-check dynamic-access-method-not-found
		InternalCommandModule.BeforeRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo);
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	InternalCommandModule.RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo);
	
	If CommandDescription.HasActionAfterRunning Then
		//@skip-check dynamic-access-method-not-found
		InternalCommandModule.AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo);
	EndIf;
	
	If CommandDescription.EnableChecking Then
		CommandFormItem.Check = Not CommandFormItem.Check;
	EndIf;
	If CommandFormItem.Check Then
		CommandFormItem.Title = 
			?(IsBlankString(CommandDescription.TitleCheck), 
				CommandDescription.Title, 
				CommandDescription.TitleCheck);
		If Not IsBlankString(CommandDescription.PictureCheck) Then
			CommandPicture = PictureLib[CommandDescription.PictureCheck]; // Picture
			CommandFormItem.Picture = CommandPicture;
		ElsIf Not IsBlankString(CommandDescription.Picture) Then
			CommandPicture = PictureLib[CommandDescription.Picture]; // Picture
			CommandFormItem.Picture = CommandPicture;
		EndIf;
	Else
		CommandFormItem.Title = CommandDescription.Title;
		If Not IsBlankString(CommandDescription.Picture) Then
			CommandPicture = PictureLib[CommandDescription.Picture]; // Picture
			CommandFormItem.Picture = CommandPicture;
		EndIf;
	EndIf; 
	
EndProcedure

#EndRegion

#Region Internal

// Run action before running.
// 
// Parameters:
//  Targets - AnyRef, Array of AnyRef - Command target
//  Form - ClientApplicationForm - Form
//  CommandFormItem - FormButton - Command form item
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  AddInfo - Undefined - Add info
Procedure Form_BeforeRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

// Run command action.
// 
// Parameters:
//  Targets - AnyRef, Array of AnyRef - Command target
//  Form - ClientApplicationForm - Form
//  CommandFormItem - FormButton - Command form item
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  AddInfo - Undefined -  Add info
Procedure Form_RunCommandAction(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

// Run action after running.
// 
// Parameters:
//  Targets - AnyRef, Array of AnyRef - Command target
//  Form - ClientApplicationForm - Form
//  CommandFormItem - FormButton - Command form item
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  AddInfo - Undefined - Add info
Procedure Form_AfterRunning(Targets, Form, CommandFormItem, MainAttribute, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion