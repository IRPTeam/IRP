&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	List.Parameters.SetParameterValue("ShowAllUnits", False);
	If Parameters.Filter.Property("Item") Then
		List.Parameters.SetParameterValue("Item", Parameters.Filter.Item);
		List.Parameters.SetParameterValue("Unit", Parameters.Filter.Item.Unit);
		List.Parameters.SetParameterValue("Filter", True);
		Parameters.Filter.Delete("Item");
		
	Else
		List.Parameters.SetParameterValue("Filter", False);
		List.Parameters.SetParameterValue("Item", Catalogs.Items.EmptyRef());
		List.Parameters.SetParameterValue("Unit", Catalogs.Units.EmptyRef());
	EndIf;
EndProcedure

&AtClient
Procedure ShowAllUnits(Command)
	Items.FormShowAllUnits.Check = Not Items.FormShowAllUnits.Check;
	List.Parameters.SetParameterValue("ShowAllUnits", Items.FormShowAllUnits.Check);
EndProcedure
