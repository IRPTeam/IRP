Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	If TransactionType = Enums.ShipmentConfirmationTransactionTypes.InventoryTransfer Then
		Partner = Undefined;
		LegalName = Undefined;
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
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		FillingPropertiesHeader = RowIDInfoServer.GetSeperatorColumns(ThisObject.Metadata());
		FillPropertyValues(ThisObject, FillingData, FillingPropertiesHeader);
		FillingPropertiesTables = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		//====================================
		ArrayOfPropertiesHeader = New Array();
		For Each PropertyName In StrSplit(FillingPropertiesHeader, ",") Do
			PropertyName = TrimAll(PropertyName);
			If CommonFunctionsClientServer.ObjectHasProperty(ThisObject, PropertyName)
				And ValueIsFilled(ThisObject[PropertyName])
				And ArrayOfPropertiesHeader.Find(PropertyName) = Undefined Then
				ArrayOfPropertiesHeader.Add(PropertyName);
			EndIf;
		EndDo;
		//====================================
		ThisObject.AdditionalProperties.Insert("ReadOnlyProperties", 
			StrConcat(ArrayOfPropertiesHeader, ",") + ", " + FillingPropertiesTables);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;
	
	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
	
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_SC(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(,"Key, LineNumber, ItemKey, Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
EndProcedure