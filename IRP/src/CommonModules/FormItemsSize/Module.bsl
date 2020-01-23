Function ItemsWidthSize() Export
	Return FormItemsSizeReuse.ItemWidthSizeSettings();
EndFunction

Procedure SetItemsWidthSize(ItemsForm, ItemsArray, Size) Export
	
	For Each Item In ItemsArray Do
		ItemsForm[Item].MaxWidth = FormItemsSize.ItemsWidthSize()[Size];
		ItemsForm[Item].AutoMaxWidth = False;
	EndDo;
	
EndProcedure