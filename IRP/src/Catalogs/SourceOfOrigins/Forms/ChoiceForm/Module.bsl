
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerChoiceForm(ThisObject, List, Cancel, StandardProcessing);
	
	If Parameters.Property("FillingData") Then
		ThisObject.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(Parameters.FillingData);
	EndIf;

	If Parameters.ItemType.IsEmpty() And Parameters.Item.IsEmpty() And Parameters.ItemKey.IsEmpty() Then
		ThisObject.List.Parameters.SetParameterValue("UseFilter" , False);
		ThisObject.List.Parameters.SetParameterValue("ItemType"  , Undefined);
		ThisObject.List.Parameters.SetParameterValue("Item"      , Undefined);
		ThisObject.List.Parameters.SetParameterValue("ItemKey"   , Undefined);
	Else
		If Parameters.ItemType.IsEmpty() AND Not Parameters.ItemKey.IsEmpty() Then
			ItemType = Parameters.ItemKey.Item.ItemType;
		Else
			ItemType = Parameters.ItemType;
		EndIf;
		
		If Parameters.Item.IsEmpty() AND Not Parameters.ItemKey.IsEmpty() Then
			Item = Parameters.ItemKey.Item;
		Else
			Item = Parameters.Item;
		EndIf;
		
		ThisObject.List.Parameters.SetParameterValue("UseFilter" , True);
		ThisObject.List.Parameters.SetParameterValue("ItemType"  , ItemType);
		ThisObject.List.Parameters.SetParameterValue("Item"      , Item);
		ThisObject.List.Parameters.SetParameterValue("ItemKey"   , Parameters.ItemKey);
	EndIf;
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If IsFolder Then
		Return;
	EndIf;
	CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter,
		"Catalog.SourceOfOrigins.ObjectForm");
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