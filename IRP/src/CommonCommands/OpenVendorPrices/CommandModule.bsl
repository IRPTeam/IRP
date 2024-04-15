
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	
	Filter = New Structure("ItemKey, Partner");
	Filter.ItemKey = GetItemKeyArray(CommandParameter);
	Filter.Partner = CommonFunctionsServer.GetRefAttribute(CommandParameter, "Partner");
	
	FormParameters = New Structure;
	FormParameters.Insert("Filter", Filter);
	FormParameters.Insert("GenerateOnOpen", True);
	
	OpenForm("Report.S1001L_VendorsPrices.Form", 
		FormParameters,
		CommandExecuteParameters.Source,
		CommandExecuteParameters.Uniqueness,
		CommandExecuteParameters.Window,
		CommandExecuteParameters.URL);
EndProcedure
	
&AtServer
Function GetItemKeyArray(DocRef)
	
	If CommonFunctionsClientServer.ObjectHasProperty(DocRef, "ItemList") Then
				
		TempTable = DocRef.ItemList.Unload();
		Array = TempTable.UnloadColumn("ItemKey");
		
		Return Array;
		
	EndIf;
	
EndFunction
