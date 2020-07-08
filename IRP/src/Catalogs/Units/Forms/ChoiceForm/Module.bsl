&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
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