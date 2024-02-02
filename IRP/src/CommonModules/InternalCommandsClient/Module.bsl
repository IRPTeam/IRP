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

	CommandName = Mid(Command.Name, StrLen("InternalCommand_") + 1);
	InternalCommandModule = GetForm("DataProcessor.InternalCommands.Form." + CommandName); // See DataProcessor.InternalCommands.Form.CommandTemplate
	
	//@skip-check property-return-type
	CommandDescription = InternalCommandModule.CommandDescription; // See InternalCommandsServer.GetCommandDescription
	
	If CommandDescription.HasActionBeforeRunning Then
		//@skip-check dynamic-access-method-not-found
		InternalCommandModule.BeforeRunning(Form, MainAttribute, Targets, AddInfo);
	EndIf;
	
	//@skip-check dynamic-access-method-not-found
	InternalCommandModule.RunCommandAction(Form, MainAttribute, Targets, AddInfo);
	
	If CommandDescription.HasActionAfterRunning Then
		//@skip-check dynamic-access-method-not-found
		InternalCommandModule.AfterRunning(Form, MainAttribute, Targets, AddInfo);
	EndIf;
	
	FormItem = Form.Items.Find(Command.Name);
	FormItem.Check = Not FormItem.Check;
	If FormItem.Check Then
		FormItem.Title = 
			?(IsBlankString(CommandDescription.TitleCheck), 
				CommandDescription.Title, 
				CommandDescription.TitleCheck);
		If Not IsBlankString(CommandDescription.PictureCheck) Then
			CommandPicture = PictureLib[CommandDescription.PictureCheck]; // Picture
			FormItem.Picture = CommandPicture;
		ElsIf Not IsBlankString(CommandDescription.Picture) Then
			CommandPicture = PictureLib[CommandDescription.Picture]; // Picture
			FormItem.Picture = CommandPicture;
		EndIf;
	Else
		FormItem.Title = CommandDescription.Title;
		If Not IsBlankString(CommandDescription.Picture) Then
			CommandPicture = PictureLib[CommandDescription.Picture]; // Picture
			FormItem.Picture = CommandPicture;
		EndIf;
	EndIf; 
	
EndProcedure

#EndRegion

#Region Internal

// Run action before running.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  Targets - AnyRef, Array of AnyRef - Command target
//  AddInfo - Undefined - Add info
Procedure Form_BeforeRunning(Form, MainAttribute, Targets, AddInfo = Undefined) Export
	Return;
EndProcedure

// Run command action.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  Targets - AnyRef, Array of AnyRef - Command target
//  AddInfo - Undefined -  Add info
Procedure Form_RunCommandAction(Form, MainAttribute, Targets, AddInfo = Undefined) Export
	Return;
EndProcedure

// Run action after running.
// 
// Parameters:
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute, DynamicList - Main form attribute
//  Targets - AnyRef, Array of AnyRef - Command target
//  AddInfo - Undefined - Add info
Procedure Form_AfterRunning(Form, MainAttribute, Targets, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion