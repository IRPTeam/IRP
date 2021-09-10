Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	If ThisObject.PriceListType <> Enums.PriceListTypes.PriceByItemKeys Then
		ThisObject.ItemKeyList.Clear();
	EndIf;

	If ThisObject.PriceListType <> Enums.PriceListTypes.PriceByItems Then
		ThisObject.ItemList.Clear();
	EndIf;

	If ThisObject.PriceListType <> Enums.PriceListTypes.PriceByProperties Then
		ThisObject.DataSet.Clear();
		ThisObject.DataPrice.Clear();
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	ThisObject.PriceListType = Enums.PriceListTypes.PriceByItems;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.PriceListType <> Enums.PriceListTypes.PriceByProperties Then
		RemoveCheckedAttribute("ItemType", CheckedAttributes);
	EndIf;
	If ThisObject.PriceListType <> Enums.PriceListTypes.PriceByItemKeys Then
		RemoveCheckedAttribute("ItemKeyList.ItemKey", CheckedAttributes);
	EndIf;
	If ThisObject.PriceListType <> Enums.PriceListTypes.PriceByItems Then
		RemoveCheckedAttribute("ItemList.Item", CheckedAttributes);
	EndIf;
EndProcedure

Procedure RemoveCheckedAttribute(Name, CheckedAttributes)
	Index = CheckedAttributes.Find(Name);
	If Index <> Undefined Then
		CheckedAttributes.Delete(Index);
	EndIf;
EndProcedure