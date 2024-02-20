&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);

	List.Parameters.SetParameterValue("isItemKey", False);
	List.Parameters.SetParameterValue("isItem", False);
	List.Parameters.SetParameterValue("isItemType", False);
	List.Parameters.SetParameterValue("ItemKeyRef", Catalogs.ItemKeys.EmptyRef());
	List.Parameters.SetParameterValue("ItemRef", Catalogs.Items.EmptyRef());
	List.Parameters.SetParameterValue("ItemType", Catalogs.ItemTypes.EmptyRef());
	
	If Parameters.Property("SerialLotNumberOwner") Then
		ThisObject.SerialLotNumberOwner = Parameters.SerialLotNumberOwner;
		If TypeOf(Parameters.SerialLotNumberOwner) = Type("CatalogRef.ItemKeys") Then
			List.Parameters.SetParameterValue("isItemKey", True);
			List.Parameters.SetParameterValue("ItemKeyRef", Parameters.SerialLotNumberOwner);
			List.Parameters.SetParameterValue("ItemRef", Parameters.SerialLotNumberOwner.Item);
			List.Parameters.SetParameterValue("ItemType", Parameters.SerialLotNumberOwner.Item.ItemType);
		ElsIf TypeOf(Parameters.SerialLotNumberOwner) = Type("CatalogRef.Items") Then
			List.Parameters.SetParameterValue("isItem", True);
			List.Parameters.SetParameterValue("ItemRef", Parameters.SerialLotNumberOwner);
			List.Parameters.SetParameterValue("ItemType", Parameters.SerialLotNumberOwner.ItemType);
		ElsIf TypeOf(Parameters.SerialLotNumberOwner) = Type("CatalogRef.ItemTypes") Then
			List.Parameters.SetParameterValue("isItemType", True);
			List.Parameters.SetParameterValue("ItemType", Parameters.SerialLotNumberOwner);
		EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	
	Cancel = True;
	FormParameters = New Structure("SerialLotNumberOwner", ThisObject.SerialLotNumberOwner);
	Filter = New Structure("FillingValues", FormParameters);
	OpenForm("Catalog.SerialLotNumbers.ObjectForm", Filter);
	
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