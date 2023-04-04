&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	If Parameters.Filter.Property("Item") Then
		If TypeOf(Parameters.Filter.Item) = Type("CatalogRef.Items") Then
			Item = Parameters.Filter.Item;
		Else
			Item = Parameters.Filter.Item.Item;
		EndIf;
		List.Parameters.SetParameterValue("Item", Item);
		List.Parameters.SetParameterValue("Unit", Item.Unit);
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