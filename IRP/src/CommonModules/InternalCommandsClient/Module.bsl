// @strict-types

#Region Internal

// Run command action.
// 
// Parameters:
//  Command - FormCommand - Command
//  Form - ClientApplicationForm - Form
//  MainAttribute - FormAttribute - Main form attribute
//  Targets - AnyRef, Array - Command target
//  AddInfo - Undefined -  Add info
Procedure RunCommandAction(Command, Form, MainAttribute, Targets, AddInfo = Undefined) Export

	CommandName = Command.Name; // String
	InternalCommandModule = Eval(CommandName + "_Client");
	
	CommandDescription = Form.InternalCommands[CommandName]; // See InternalCommandsServer.GetCommandDescription
	
	If CommandDescription.HasActionBeforeRunning Then
		InternalCommandModule.BeforeRunning(Form, MainAttribute, Targets, AddInfo);
	EndIf;
	
	InternalCommandModule.RunCommandAction(Form, MainAttribute, Targets, AddInfo);
	
	If CommandDescription.HasActionAfterRunning Then
		InternalCommandModule.AfterRunning(Form, MainAttribute, Targets, AddInfo);
	EndIf;
	
	FormItem = Form.Items.Find(CommandName);
	FormItem.Check = Not FormItem.Check;
	If FormItem.Check Then
		FormItem.Title = 
			?(IsBlankString(CommandDescription.TitleCheck), 
				CommandDescription.Title, 
				CommandDescription.TitleCheck);
		If Not IsBlankString(CommandDescription.PictureCheck) Then
			FormItem.Picture = PictureLib[CommandDescription.PictureCheck];
		ElsIf Not IsBlankString(CommandDescription.Picture) Then
			FormItem.Picture = PictureLib[CommandDescription.Picture];
		EndIf;
	Else
		FormItem.Title = CommandDescription.Title;
		If Not IsBlankString(CommandDescription.Picture) Then
			FormItem.Picture = PictureLib[CommandDescription.Picture];
		EndIf;
	EndIf; 
	
EndProcedure

#EndRegion
