&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	If Parameters.Filter.Property("Item") Then
		List.Parameters.SetParameterValue("Item", Parameters.Filter.Item);
		List.Parameters.SetParameterValue("Unit", Parameters.Filter.Item.Unit);
		List.Parameters.SetParameterValue("Filter", True);
	Else
		List.Parameters.SetParameterValue("Filter", False);
		List.Parameters.SetParameterValue("Item", Catalogs.Items.EmptyRef());
		List.Parameters.SetParameterValue("Unit", Catalogs.Units.EmptyRef());
	EndIf;
	If Parameters.Filter.Property("Quantity") Then
		List.Parameters.SetParameterValue("FilterForItemsAndKeys", True);
	Else
		List.Parameters.SetParameterValue("FilterForItemsAndKeys", False);
	EndIf;
	Parameters.Filter.Delete("Item");
EndProcedure