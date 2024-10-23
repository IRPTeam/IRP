&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure FillDefaultDescriptions(Command)
	FillDefaultDescriptionsAtServer();
EndProcedure

&AtServer
Procedure FillDefaultDescriptionsAtServer()
	Query = New Query;
	Query.Text =
		"SELECT
		|	AddAttributeAndPropertySets.Ref
		|FROM
		|	Catalog.AddAttributeAndPropertySets AS AddAttributeAndPropertySets";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		Obj = SelectionDetailRecords.Ref.GetObject(); // CatalogObject.AddAttributeAndPropertySets
		CurrentUserLang = ?(IsBlankString(SessionParameters.LocalizationCode), "en", SessionParameters.LocalizationCode);
		
		Segments = StrSplit(Obj.PredefinedDataName, "_");
		If Segments.Count() = 2 Then
			DataType = Metadata.FindByFullName(StrReplace(Obj.PredefinedDataName, "_", "."));
		Else
			DataType = Metadata.FindByFullName(Segments[0]+"."+Segments[1]+"_"+Segments[2]);
		EndIf;
		If DataType = Undefined Then
			Continue;
		EndIf;
		
		Obj["Description_" + CurrentUserLang] = DataType.Synonym;
		
		Obj.Write();
	EndDo;
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion