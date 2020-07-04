
Procedure CreateCommands(Form, ObjectName, ObjectType, FormType, AddInfo = Undefined) Export	
	
	Query = New Query;
	Query.Text = "SELECT
	|	ExternalCommands.ExternalDataProc,
	|	ExternalCommands.InterfaceGroup
	|FROM
	|	InformationRegister.ExternalCommands AS ExternalCommands
	|WHERE
	|	ExternalCommands.ConfigurationMetadata = &ConfigurationMetadata
	|	AND (ExternalCommands.FormType = &FormType
	|	OR ExternalCommands.FormType = VALUE(Enum.FormTypes.EmptyRef))";
	ConfigurationMetadata = Catalogs.ConfigurationMetadata.FindByDescription(ObjectName, True, ObjectType);
	Query.SetParameter("ConfigurationMetadata", ConfigurationMetadata);
	Query.SetParameter("FormType", FormType);
	QueryExecution = Query.Execute();
	
	If QueryExecution.IsEmpty() Then
		Return;
	EndIf;
	
	CommandGroupParent = Form.CommandBar;
	
	QuerySelection = QueryExecution.Select();
	While QuerySelection.Next() Do
		
		ExternalDataProc = QuerySelection.ExternalDataProc;
		
		CommandInfo = FormItemInfo(ExternalDataProc);
		CommandForm = Form.Commands.Add(CommandInfo.Name);
		CommandForm.Title = CommandInfo.Title;
		CommandForm.Action = "GeneratedFormCommandActionByName";
		
		If ValueIsFilled(QuerySelection.InterfaceGroup) Then
			GroupInfo = FormItemInfo(QuerySelection.InterfaceGroup);
			FoundedGroup = Form.CommandBar.ChildItems.Find(GroupInfo.Name);
			If FoundedGroup = Undefined Then
				FoundedGroup = Form.Items.Add(GroupInfo.Name, Type("FormGroup"), CommandGroupParent);
				FoundedGroup.Type = FormGroupType.Popup;
				FoundedGroup.Title = GroupInfo.Title;
			EndIf;
			CommandParent = FoundedGroup;
		Else
			CommandParent = CommandGroupParent;
		EndIf;
		
		CommandButton = Form.Items.Add(CommandForm.Name, Type("FormButton"), CommandParent);
		CommandButton.CommandName = CommandForm.Name;
		
	EndDo;
	
EndProcedure

Function FormItemInfo(ItemRef)
	Result = New Structure();
	Name = "_" + StrReplace(ItemRef.UUID(), "-", "_");
	Result.Insert("Name", Name);
	Result.Insert("Title", String(ItemRef));
	Return Result;
EndFunction

Procedure GeneratedFormCommandActionByName(Object, Form, CommandName, AddInfo = Undefined) Export	
	ExtProc = GetRefOfExternalDataProcByName(CommandName);	
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If Not AddDataProc = Undefined Then
		AddDataProc.CommandProcedure(Object, Form);
	EndIf;
EndProcedure

Procedure GeneratedListChoiceFormCommandActionByName(SelectedRows, Form, CommandName, AddInfo = Undefined) Export	
	ExtProc = GetRefOfExternalDataProcByName(CommandName);	
	Info = AddDataProcServer.AddDataProcInfo(ExtProc);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If Not AddDataProc = Undefined Then
		AddDataProc.CommandProcedure(SelectedRows, Form);	
	EndIf;
EndProcedure

Function GetRefOfExternalDataProcByName(CommandName) Export
	
	UUIDRow = Mid(StrReplace(CommandName, "_", "-"), 2, 36);
	UUIDCat = New UUID(UUIDRow);
	ExtProc = Catalogs.ExternalDataProc.GetRef(UUIDCat);
	
	Return ExtProc;
	
EndFunction

