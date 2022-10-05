// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.PathToValue = Parameters.PathToValue;
	ThisObject.AddressBody = Parameters.AddressBody;
	
	If IsBlankString(ThisObject.AddressBody) Then
		Items.GroupPages.CurrentPage = Items.GroupLoadData;
	EndIf;
	
	If Not IsBlankString(ThisObject.PathToValue) Then
		PatchPartsString = StrSplit(ThisObject.PathToValue, "/");
		ThisObject.PathParts.LoadValues(PatchPartsString);
	EndIf;
	
	AvailableCommands = Unit_MockService.getAllContentCommands();
	For Each DescriptionCommand In AvailableCommands Do
		NameNewCommand = "Add_" + DescriptionCommand.Key;
		TileNewCommand = "" + DescriptionCommand.Value;
		
		NewCommand = Commands.Add(NameNewCommand);
		NewCommand.Title = TileNewCommand;
		NewCommand.Action = "AddCommand";
		
		NewItem = Items.Add(NameNewCommand, Type("FormButton"), Items.GroupOfPathCommands);
		NewItem.Title = TileNewCommand;
		NewItem.CommandName = NameNewCommand;
		NewItem.Visible = False;
	EndDo;
	
	ReloadContent();

EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	
	For Each Item In PathTree.GetItems() Do
		ItemID = Item.GetID();
		Items.PathTree.Expand(ItemID, True);
	EndDo;

EndProcedure


#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure LoadText(Command)
	
	LoadTextAtServer();

	For Each Item In PathTree.GetItems() Do
		ItemID = Item.GetID();
		Items.PathTree.Expand(ItemID, True);
	EndDo;

EndProcedure

&AtClient
Procedure LoadFile(Command)
	
	BeginPutFileToServer(
		New NotifyDescription("AfterPutFileToServer", ThisObject), , , , 
		New PutFilesDialogParameters(), 
		ThisObject.UUID);
	
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

	TryingAddCommand(Items[Command.Name].Title);

EndProcedure

&AtClient
Procedure OK(Command)
	
	ThisObject.NotifyChoice(ThisObject.PathToValue);
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure PathTreeOnActivateRow(Item)
	
	If Items.PathTree.CurrentRow = Undefined Then
		Return;
	EndIf;
	
	PreviosState = ThisObject.PathToValue;
	
	CurrentBranchID = Items.PathTree.CurrentRow; // Number
	CurrentBranch = ThisObject.PathTree.FindByID(CurrentBranchID);
	
	ThisObject.PathParts.Clear();
	While True Do
		ThisObject.PathParts.Insert(0, CurrentBranch.Part);
		If CurrentBranch.GetParent() = Undefined Then
			Break;
		EndIf;
		CurrentBranch = CurrentBranch.GetParent();
	EndDo;
	ThisObject.PathToValue = StrConcat(ThisObject.PathParts.UnloadValues(), "/");
	
	If Not ThisObject.PathToValue = PreviosState Then
		ReloadContent();
		Items.PathTree.Expand(CurrentBranchID, True);
	EndIf;

EndProcedure

&AtClient
Procedure ResultPagesOnCurrentPageChange(Item, CurrentPage)
	
	If Items.ResultPages.CurrentPage = Items.ResultHTML Then 
		ThisObject.ResultsHTML = GetHTML(ThisObject.Results);
	EndIf;

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
    	EndIf;
    	TryingAddCommand(TextCommand);
    EndIf;
EndProcedure

// Trying add command.
// 
// Parameters:
//  TextCommand - String - Text command
&AtClient
Procedure TryingAddCommand(TextCommand)
	
	If Items.PathTree.CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentBranchID = Items.PathTree.CurrentRow; // Number
	CurrentBranch = ThisObject.PathTree.FindByID(CurrentBranchID);
	
	isExist = False;
	For Each Child In CurrentBranch.GetItems() Do
		If Child.Part = TextCommand Then
			Items.PathTree.CurrentRow = Child.GetID(); 
			isExist = True;
			Break;
		EndIf;
	EndDo;
	
	If Not isExist Then
		NewBranch = CurrentBranch.GetItems().Add();
		NewBranch.Part = TextCommand;
		NewBranch.Manual = True;
		Items.PathTree.CurrentRow = NewBranch.GetID();
	EndIf;
	
EndProcedure

&AtServer
Procedure ReloadContent()
	
	If IsBlankString(ThisObject.AddressBody) Then
		Return;
	EndIf;
	
	isInitTree = False;
	If ThisObject.PathTree.GetItems().Count() = 0 Then
		InitPathTree();
		isInitTree = True;
	EndIf;
	
	AllCommands = Unit_MockService.getAllContentCommands();
	
	CurrentBranchID = Items.PathTree.CurrentRow; // Number
	CurrentBranch = ThisObject.PathTree.FindByID(CurrentBranchID);
	
	Try
		ThisObject.Results = Unit_MockService.getValueOfBodyVariableByPath(
			ThisObject.PathToValue, GetFromTempStorage(ThisObject.AddressBody));
		CurrentBranch.Error = False;
	Except
		CurrentBranch.Error = True;
		ThisObject.Results = ErrorDescription();
	EndTry;
	
	If Items.ResultPages.CurrentPage = Items.ResultHTML Then 
		ThisObject.ResultsHTML = GetHTML(ThisObject.Results);
	EndIf;
	
	CurrentCommand = ThisObject.PathParts.Get(ThisObject.PathParts.Count() - 1).Value; // String
	AvailableCommands = Unit_MockService.getAvailableCommands(CurrentCommand);
	For Each CommandItem In Items.GroupOfPathCommands.ChildItems Do
		If CommandItem = Items.FormOK Then
			Continue;
		EndIf;
		CommandItem.Visible = Not CurrentBranch.Error And Not AvailableCommands.Find(CommandItem.Title) = Undefined;
	EndDo;
	
	If Not CurrentBranch.Error Then
		If Not isInitTree And CurrentBranch.GetItems().Count() = 0 Then
			ConstructTreeBranch(CurrentBranch);
		EndIf;
	EndIf;
	
EndProcedure

&AtServer
Procedure LoadTextAtServer()
	
	ThisObject.AddressBody = PutToTempStorage(GetBinaryDataFromString(ThisObject.InputText), ThisObject.UUID);
	
	ThisObject.InputText = "";
	Items.GroupPages.CurrentPage = Items.GroupAnalyze;
	
	ThisObject.PathToValue = Unit_MockService.getAllContentCommands().Text;
	ThisObject.PathParts.Add(ThisObject.PathToValue);
	
	ReloadContent();

EndProcedure

// After put file to server.
// 
// Parameters:
//  FileDescription - Structure:
//  * PutFileCanceled - Boolean
//  * Address - String
//  AddParameters - Undefined
&AtClient
Procedure AfterPutFileToServer(FileDescription, AddParameters) Export
	
	If FileDescription.PutFileCanceled Then
		Return;
	EndIf;
	
	ThisObject.AddressBody = FileDescription.Address;
	
	Items.GroupPages.CurrentPage = Items.GroupAnalyze;
	
	ReloadContent();
	
	For Each Item In PathTree.GetItems() Do
		ItemID = Item.GetID();
		Items.PathTree.Expand(ItemID, True);
	EndDo;

EndProcedure

&AtServer
Procedure InitPathTree()
	
	AllCommands = Unit_MockService.getAllContentCommands();
	
	If IsBlankString(ThisObject.PathToValue) Then
		ThisObject.PathToValue = AllCommands.File;
		ThisObject.PathParts.Add(ThisObject.PathToValue);
	EndIf;
	
	RootTree = ThisObject.PathTree.GetItems().Add();
	RootTree.Part = ThisObject.PathParts[0].Value;
	
	ConstructTreeBranch(RootTree, AllCommands);
	
	CurrentBranches = ThisObject.PathTree.GetItems();
	For Index = 1 To ThisObject.PathParts.Count() Do
		CurrentCommand = ThisObject.PathParts.Get(Index - 1).Value;
		isFound = False;
		For Each TreeItem In CurrentBranches Do
			If TreeItem.Part = CurrentCommand Then
				isFound = True;
				Items.PathTree.CurrentRow = TreeItem.GetID();
				CurrentBranches = TreeItem.GetItems();
				Break; 
			EndIf;
		EndDo;
		If Not isFound Then
			CommonFunctionsClientServer.ShowUsersMessage(
				CurrentCommand + " - " + R().Mock_Info_NotFound, 
				"PathToValue", ThisObject);
			Break;
		EndIf;
	EndDo;
	
EndProcedure	

// Init path tree.
// 
// Parameters:
//  TreeBranch - FormDataTreeItem - a Branch of Tree
//  AllCommands - See Unit_MockService.getAllContentCommands
&AtServer
Procedure ConstructTreeBranch(TreeBranch, AllCommands = Undefined)
	
	If AllCommands = Undefined Then
		AllCommands = Unit_MockService.getAllContentCommands();
	EndIf;
	
	CurrentCommand = TreeBranch.Part; // String
	CurrentCommandPath = GetBranchCommandPath(TreeBranch);
	
	PreviousCommand = "";
	PreviousBranch = TreeBranch.GetParent();
	While Not PreviousBranch = Undefined Do
		BranchCommand = PreviousBranch.Part;
		If isTransformCommand(BranchCommand) Then
			PreviousCommand = BranchCommand;
			Break;
		EndIf;
		PreviousBranch = PreviousBranch.GetParent();
	EndDo;
	
	NewChildren = New Array; // Array of FormDataTreeItem
	
	Try
		CurrentResults = Unit_MockService.getValueOfBodyVariableByPath(
			CurrentCommandPath, GetFromTempStorage(ThisObject.AddressBody), AllCommands);
		TreeBranch.Error = False;
	Except
		CurrentResults = "";
		TreeBranch.Error = True;
		Return;
	EndTry;
	
	If isAutoGeneratedContent(CurrentCommand, PreviousCommand, AllCommands) And Not CurrentResults = "Collection" Then
		If StrLen(CurrentResults) > 22 Then
			Try
				CurrentValue = Base64Value(CurrentResults);
				If TypeOf(CurrentValue) = Type("BinaryData") And CurrentValue.Size() > 22 Then
					NewChild = TreeBranch.GetItems().Add();
					NewChild.Part = AllCommands.File;
					NewChildren.Add(NewChild);
					CurrentResults = "";
				EndIf;
			Except
				CurrentValue = Undefined;
			EndTry;
		EndIf;
			
		If StrFind(CurrentResults, Chars.CR + "* ") Then
			Descriptions = StrSplit(CurrentResults, Chars.CR);
			For Index = 1 To Descriptions.Count() - 1 Do
				NameNewCommand = Descriptions.Get(Index);
				If StrStartsWith(NameNewCommand, "* [text] = ") Then
					NewChild = TreeBranch.GetItems().Insert(0);
					NewChild.Part = AllCommands.Text;
					NewChildren.Add(NewChild);
				ElsIf StrStartsWith(NameNewCommand, "* ") Then
					NameNewCommand = Mid(NameNewCommand, 3);
					NewChild = TreeBranch.GetItems().Add();
					NewChild.Part = NameNewCommand;
					NewChildren.Add(NewChild);
				EndIf;
			EndDo;
			If Descriptions[0] = "XDTODataObject" Then
				NewChild = TreeBranch.GetItems().Add();
				NewChild.Part = AllCommands.Text;
				NewChildren.Add(NewChild);
			EndIf;
		EndIf;
		
	Else
		
		CurrentObjectResults = Undefined; // Arbitrary
		Try
			CurrentObjectResults = Unit_MockService.getValueOfBodyVariableByPath(
				CurrentCommandPath, GetFromTempStorage(ThisObject.AddressBody), AllCommands, True);
		Except
			Return;
		EndTry;
		
		NameNewCommand = "";
		
		If TypeOf(CurrentObjectResults) = Type("BinaryData") Then
			BinarySteam = CurrentObjectResults.OpenStreamForRead();
			BinaryBuffer = New BinaryDataBuffer(4);
			BinarySteam.Read(BinaryBuffer, 0, 4);
			If BinaryBuffer.Get(0) = 80 
					And BinaryBuffer.Get(1) = 75
					And BinaryBuffer.Get(2) = 3
					And BinaryBuffer.Get(3) = 4 Then 
				NameNewCommand = AllCommands.ZIP;
			ElsIf Not PreviousCommand = AllCommands.Text Then
				NameNewCommand = AllCommands.Text;
			EndIf;
			BinarySteam.Close();
			
		ElsIf TypeOf(CurrentObjectResults) = Type("String") Then
			
			If IsBlankString(NameNewCommand) And StrStartsWith(CurrentObjectResults, "<") Then
				Try
					XMLReader = New XMLReader();
					XMLReader.SetString(CurrentObjectResults);
					XMLResult = XDTOFactory.ReadXML(XMLReader); // Arbitrary
					XMLReader.Close();
					NameNewCommand = AllCommands.XML;
				Except
					XMLResult = Undefined;
					XMLReader = Undefined;
				EndTry;
			EndIf;
			
			If IsBlankString(NameNewCommand) And 
					(StrStartsWith(CurrentObjectResults, "{") Or StrStartsWith(CurrentObjectResults, "[")) Then
				Try
					JSONReader = New JSONReader();
					JSONReader.SetString(CurrentObjectResults);
					JSONResult = ReadJSON(JSONReader, True);
					JSONReader.Close();
					NameNewCommand = AllCommands.JSON;
				Except
					JSONResult = Undefined;
					JSONReader = Undefined;
				EndTry;
			EndIf;
			
			If IsBlankString(NameNewCommand) Then
				Try
					CurrentValue = Base64Value(CurrentObjectResults);
					If TypeOf(CurrentValue) = Type("BinaryData") And CurrentValue.Size() > 22 Then
						NameNewCommand = AllCommands.File;
					EndIf;
				Except
					CurrentValue = Undefined;
				EndTry;
			EndIf;
			
		ElsIf TypeOf(CurrentObjectResults) = Type("Array") Then
			For Index = 0 To CurrentObjectResults.UBound() Do
				NewChild = TreeBranch.GetItems().Add();
				NewChild.Part = Format(Index, "NZ=; NG=;");
				NewChildren.Add(NewChild);
			EndDo;
			
		ElsIf TypeOf(CurrentObjectResults) = Type("XDTOList") Then
			For Index = 0 To CurrentObjectResults.Count() - 1 Do
				NewChild = TreeBranch.GetItems().Add();
				NewChild.Part = Format(Index, "NZ=; NG=;");
				NewChildren.Add(NewChild);
			EndDo;
			
		EndIf;
		
		If Not IsBlankString(NameNewCommand) Then
			NewChild = TreeBranch.GetItems().Add();
			NewChild.Part = NameNewCommand;
			NewChildren.Add(NewChild);
		EndIf;	

	EndIf;
	
	For Each Child In NewChildren Do
		ConstructTreeBranch(Child, AllCommands);
	EndDo;
	
EndProcedure	

// Is transform command.
// 
// Parameters:
//  CommandName - String
// 
// Returns:
//  Boolean - Is transform command
&AtServer
Function isTransformCommand(CommandName)
	Return StrStartsWith(CommandName, "[");
EndFunction

// Is auto generated content.
// 
// Parameters:
//  CurrentCommand - String - Current command
//  PreviousCommand - String - Previous command
//  AllCommands - See Unit_MockService.getAllContentCommands
// 
// Returns:
//  Boolean - Is auto generated content
&AtServer
Function isAutoGeneratedContent(CurrentCommand, PreviousCommand, AllCommands)

	If CurrentCommand = AllCommands.ZIP Or CurrentCommand = AllCommands.XML Or CurrentCommand = AllCommands.JSON Then
		Return True;
	EndIf;
	
	If Not isTransformCommand(CurrentCommand) And
			(PreviousCommand = AllCommands.XML Or PreviousCommand = AllCommands.JSON) Then
		Return True;
	EndIf;
	
	Return False;

EndFunction

// Get branch command path.
// 
// Parameters:
//  TreeBranch - FormDataTreeItem - Tree branch
// 
// Returns:
//  String - Command path
&AtServer
Function GetBranchCommandPath(TreeBranch)
	ResultPath = New Array;
	CurrentBranch = TreeBranch;
	While Not CurrentBranch = Undefined Do
		ResultPath.Insert(0, CurrentBranch.Part);
		CurrentBranch = CurrentBranch.GetParent();
	EndDo;
	Return StrConcat(ResultPath, "/");
EndFunction

// Get HTML from some text.
// 
// Parameters:
//  SomeText - String - Some text
//  isXML - Boolean - Is XML
// 
// Returns:
//  String - Get HTML
&AtServerNoContext
Function GetHTML(Val SomeText)
	If StrStartsWith(TrimL(SomeText), "<") and StrEndsWith(TrimR(SomeText), ">") Then
		TempFile = GetTempFileName("xml");
		XMLWriter = New XMLWriter;
		XMLWriter.OpenFile(TempFile);
        XMLWriter.WriteRaw(SomeText);
        XMLWriter.Close();
        Return TempFile;
	Else
		Template = "<html><body>%1</body></html>";
		SomeText = StrReplace(SomeText, Chars.CR, "<br />");
		StrTemplate(Template, SomeText);
	EndIf;
	Return StrTemplate(Template, SomeText);
EndFunction

#EndRegion
