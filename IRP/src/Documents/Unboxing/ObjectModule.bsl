Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	ThisObject.WriteOff = True;
	
	If FillingData = Undefined Then
		Return;
	EndIf;
	
	ItemBox = FillingData.Basis.ItemBox;
	ItemKeyBox = Catalogs.ItemKeys.GetRefByBoxing(FillingData.Basis, ItemBox);
	TableOfItemKeys = Catalogs.ItemKeys.GetTableByBoxContent(ItemKeyBox);
	
	ThisObject.ItemKeyBox = ItemKeyBox;
	
	ThisObject.ItemList.Clear();
	
	For Each TableOfItemKeysRow In TableOfItemKeys Do
		NewRowItemKey = ThisObject.ItemList.Add();
		NewRowItemKey.Key = New UUID();
		NewRowItemKey.ItemKey = TableOfItemKeysRow.ItemKey;
		NewRowItemKey.Unit = TableOfItemKeysRow.Unit;
		NewRowItemKey.Quantity = TableOfItemKeysRow.Quantity;
	EndDo;
EndProcedure

