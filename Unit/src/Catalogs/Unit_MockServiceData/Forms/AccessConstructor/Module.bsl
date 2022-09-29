// @strict-types


#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.PathToValue = Parameters.PathToValue;
	ThisObject.AddressBody = Parameters.AddressBody;
	
	PatchPartsString = StrSplit(ThisObject.PathToValue, "/");
	ThisObject.PatchParts.LoadValues(PatchPartsString);
	
	ReloadContent();

EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

// Del command.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure DelCommand(Command)

	If ThisObject.PatchParts.Count() = 0 Then
		Return;
	EndIf;
	
	ThisObject.PatchParts.Delete(ThisObject.PatchParts.Count()-1);
	ThisObject.PathToValue = StrConcat(ThisObject.PatchParts.UnloadValues(), "/");

	ReloadContent();

EndProcedure

// Add command.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure AddCommand(Command)

	TextCommand = Items[Command.Name].Title;
	If StrFind(TextCommand, "?") Then
		ShowInputString(New NotifyDescription("AfterInputString", ThisObject, TextCommand), "");
		Return;
	EndIf;

	ThisObject.PatchParts.Add(Items[Command.Name].Title);
	ThisObject.PathToValue = StrConcat(ThisObject.PatchParts.UnloadValues(), "/");
	
	ReloadContent();

EndProcedure

&AtClient
Procedure OK(Command)
	
	ThisObject.NotifyChoice(ThisObject.PathToValue);
	
EndProcedure

&AtClient
Async Procedure AddWord(Command)
	
	ShowInputString(New NotifyDescription("AfterInputString", ThisObject, Undefined), "");
	
EndProcedure


#EndRegion


#Region Private

// After input string.
// 
// Parameters:
//  NewWord - String - New word
//  Parameters - Undefined, String - Parameters
&AtClient
Procedure AfterInputString(NewWord, Parameters) Export
    If ValueIsFilled(NewWord) Then
    	TextCommand = NewWord;
    	If TypeOf(Parameters) = Type("String") Then
    		TextCommand = StrReplace(Parameters, "?", NewWord);
    	EndIF;
		ThisObject.PatchParts.Add(TextCommand);
		ThisObject.PathToValue = StrConcat(ThisObject.PatchParts.UnloadValues(), "/");
		ReloadContent();
    EndIf;
EndProcedure

&AtServer
Procedure ReloadContent()
	
	OldItems = New Array; // Array of FormButton
	OldCommands = New Array;  // Array of String
	For Each Item In Items.GroupOfPathCommands.ChildItems Do
		If StrStartsWith(Item.Name, "Add_") Then
			OldItems.Add(Item);
			OldCommands.Add(Item.CommandName);
		EndIf
	EndDo;
	
	For Each OldItem In OldItems Do
		Items.Delete(OldItem);
	EndDo;
	For Each OldCommand In OldCommands Do
		Commands.Delete(Commands.Find(OldCommand));
	EndDo;
	
	TypeResult = Type("Undefined");
	Try
		OriginalResult = Unit_MockService.getValueOfBodyVariableByPath(
			ThisObject.PathToValue, GetFromTempStorage(ThisObject.AddressBody));
		TypeResult = TypeOf(OriginalResult);
		ThisObject.Results = String(OriginalResult);
	Except
		ThisObject.Results = ErrorDescription();
	EndTry;
	
	CurrentCommand = ?(ThisObject.PatchParts.Count() = 0, "", ThisObject.PatchParts.Get(ThisObject.PatchParts.Count() - 1).Value);
	AddInfo = ?(StrFind(ThisObject.Results, "* ") = 0, "", ThisObject.Results);
	If CurrentCommand = "[zip]" Then
		TypeResult = Type("ZipFileReader");
	ElsIf CurrentCommand = "[file]" Then
		TypeResult = Type("BinaryData");
	EndIf;
	
	AvailableCommands = Unit_MockService.getAvailableCommands(CurrentCommand, TypeResult, AddInfo);
	
	CurrentTime = CurrentUniversalDateInMilliseconds();
	For Each DescriptionCommand In AvailableCommands Do
		NewNameCommand = "Add_" + Format(CurrentTime, "NG=;");
		NewCommand = Commands.Add(NewNameCommand);
		NewCommand.Title = DescriptionCommand;
		NewCommand.Action = "AddCommand";
		
		NewItem = Items.Add(NewNameCommand, Type("FormButton"), Items.GroupOfPathCommands);
		NewItem.Title = DescriptionCommand;
		NewItem.CommandName = NewNameCommand;
		
		CurrentTime = CurrentTime + 1;
	EndDo;
	
EndProcedure

#EndRegion
