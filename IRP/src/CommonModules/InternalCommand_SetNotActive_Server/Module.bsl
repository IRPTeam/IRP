// @strict-types

#Region Public

// See InternalCommandsServer.GetCommandDescription 
//@skip-check statement-type-change, property-return-type
Function GetCommandDescription() Export
	
	CommandDescription = InternalCommandsServer.GetCommandDescription();
	
	CommandDescription.Name = "SetNotActive";
	CommandDescription.Title = R().InternalCommands_SetNotActive;
	CommandDescription.TitleCheck = R().InternalCommands_SetNotActive_Check;
	CommandDescription.ToolTip = CommandDescription.Title; 
	CommandDescription.Picture = "IconSetNotActive";
	CommandDescription.PictureCheck = "IconSetActive";
	
	CommandDescription.LocationInCommandBar = "InAdditionalSubmenu"; //ButtonLocationInCommandBar.InAdditionalSubmenu
	CommandDescription.ModifiesStoredData = True;
	
	CommandDescription.UsingObjectForm = True;
	
	CommandDescription.HasActionOnCommandCreate = True;
	CommandDescription.HasActionAfterRunning = True;
	
	Targets = CommandDescription.Targets;
	For Each ContentItem In Metadata.CommonAttributes.NotActive.Content Do
		If ContentItem.Use = Metadata.ObjectProperties.CommonAttributeUse.Use  Then
			Targets.Add(ContentItem.Metadata.FullName());
		EndIf;
	EndDo;
	CommandDescription.Targets = New FixedArray(Targets);
	
	Return New FixedStructure(CommandDescription);
	
EndFunction

#EndRegion

#Region Internal

// On command create.
// 
// Parameters:
//  CommandButton - FormButton - Command button
//  CommandDescription - See InternalCommandsServer.GetCommandDescription
//  Form - ClientApplicationForm - Form
//  MainAttribute - DynamicList - Main attribute
//  ObjectFullName - String - Object full name
//  FormType - EnumRef.FormTypes - Form type
//  AddInfo - Undefined - Add info
//@skip-check statement-type-change, property-return-type
Procedure OnCommandCreate(CommandButton, CommandDescription, Form, MainAttribute, ObjectFullName, FormType, AddInfo = Undefined) Export
	
	CommandButton.Check = MainAttribute.NotActive;
	
	If CommandButton.Check Then
		CommandButton.Title = 
			?(IsBlankString(CommandDescription.TitleCheck), 
				CommandDescription.Title, 
				CommandDescription.TitleCheck);
		If Not IsBlankString(CommandDescription.PictureCheck) Then
			CommandButton.Picture = PictureLib[CommandDescription.PictureCheck];
		ElsIf Not IsBlankString(CommandDescription.Picture) Then
			CommandButton.Picture = PictureLib[CommandDescription.Picture];
		EndIf;
	EndIf; 
	
EndProcedure

// Command processing at server.
// 
// Parameters:
//  CommandParameter - AnyRef, Array of AnyRef - Command parameter
//  AddInfo - Undefined - Add info
Procedure CommandProcessingAtServer(CommandParameter, AddInfo = Undefined) Export
	
	If Not ValueIsFilled(CommandParameter) Then
		Return;
	EndIf;
	
	If TypeOf(CommandParameter) = Type("Array") Then
		For Each CommandItem In CommandParameter Do
			ChangeNotActive(CommandItem);
		EndDo;
	Else
		ChangeNotActive(CommandParameter);
	EndIf;
	
EndProcedure

#EndRegion

#Region Private

// Change not active.
// 
// Parameters:
//  CommandParameter - AnyRef - Command parameter
Procedure ChangeNotActive(CommandParameter)
	
	CatalogObject = CommandParameter.GetObject();
	CatalogObject.NotActive = Not CatalogObject.NotActive;
	
	CatalogObject.DataExchange.Load = True;
	CatalogObject.Write();
	
EndProcedure

#EndRegion
