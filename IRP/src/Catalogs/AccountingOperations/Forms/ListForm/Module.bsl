
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure FillDefaultDescriptions(Command)
	FillDefaultDescriptionsAtServer()
EndProcedure

&AtServer
Procedure FillDefaultDescriptionsAtServer()
	Query = New Query;
	Query.Text =
	"SELECT
	|	AccountingOperations.Ref
	|FROM
	|	Catalog.AccountingOperations AS AccountingOperations";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		Obj = QuerySelection.Ref.GetObject();
		CurrentUserLang = ?(IsBlankString(SessionParameters.LocalizationCode), "en", SessionParameters.LocalizationCode);
		DataType = Metadata.FindByFullName(StrReplace(Obj.PredefinedDataName, "_", "."));
		
		If DataType <> Undefined Then
			Obj["Description_" + CurrentUserLang] = DataType.Synonym;
			Obj.Write();
			Continue;
		EndIf;

		If ValueIsFilled(Obj.PredefinedDataName) And R(CurrentUserLang).Property(Obj.PredefinedDataName) Then
			Obj["Description_" + CurrentUserLang] = R(CurrentUserLang)[Obj.PredefinedDataName];
			Obj.Write();
		EndIf;
		
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
