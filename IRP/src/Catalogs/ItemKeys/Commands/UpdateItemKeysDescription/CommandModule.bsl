
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	UpdateAllDescriptions();
	RefreshReusableValues();
EndProcedure

&AtServer
Procedure UpdateAllDescriptions()
	ItemKeys = Catalogs.ItemKeys.Select();
	While ItemKeys.Next() Do
		DescriptionUpdated = False;
		ItemKey = ItemKeys.GetObject();
		Catalogs.ItemKeys.UpdateDescriptions(ItemKey, DescriptionUpdated);
		If DescriptionUpdated Then
			ItemKey.Write();
		EndIf;			
	EndDo;
EndProcedure
