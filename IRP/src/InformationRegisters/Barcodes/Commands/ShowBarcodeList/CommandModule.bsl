&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

	FormParameters = New Structure("FillingData, Filter", New Structure(), New Structure());
	ArrayItemKeys = New Array();
	If TypeOf(CommandParameter) = Type("CatalogRef.ItemKeys") Then
		ArrayItemKeys.Add(CommandParameter);
		FormParameters.Insert("ItemKey", CommandParameter);
		FormParameters.FillingData.Insert("ItemKey", CommandParameter);
		FormParameters.Filter.Insert("ItemKey", ArrayItemKeys);
	EndIf;
	If TypeOf(CommandParameter) = Type("CatalogRef.Items") Then
		ArrayItemKeys = CatItemsServer.GetArrayOfItemKeysByItem(CommandParameter);
		FormParameters.Insert("Item", CommandParameter);
		FormParameters.Insert("UseItemFilter", True);
		FormParameters.Filter.Insert("ItemKey", ArrayItemKeys);
	EndIf;
	If TypeOf(CommandParameter) = Type("CatalogRef.SerialLotNumbers") Then
		FormParameters.FillingData.Insert("SerialLotNumber", CommandParameter);
		FormParameters.Filter.Insert("SerialLotNumber", CommandParameter);
	EndIf;

	OpenForm("InformationRegister.Barcodes.ListForm", FormParameters, CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness, CommandExecuteParameters.Window, CommandExecuteParameters.URL);
EndProcedure