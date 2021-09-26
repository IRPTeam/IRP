Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
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

	If Not Cancel Then
		IsBasedOnInternalSupplyRequest = False;
		For Each Row In ThisObject.ItemList Do
			If ValueIsFilled(Row.InternalSupplyRequest) Then
				IsBasedOnInternalSupplyRequest = True;
			EndIf;
		EndDo;
		If IsBasedOnInternalSupplyRequest Then
			StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
			If StatusInfo.Posting Then
				RecordSet = InformationRegisters.CreatedProcurementOrders.CreateRecordSet();
				RecordSet.Filter.Order.Set(Ref);
				RecordSet.Clear();
				RecordSet.Write();
			Else
				RecordSet = InformationRegisters.CreatedProcurementOrders.CreateRecordSet();
				RecordSet.Filter.Order.Set(Ref);
				RecordSet.Add().Order = Ref;
				RecordSet.Write(True);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		FillPropertyValues(ThisObject, FillingData, RowIDInfoServer.GetSeperatorColumns(ThisObject.Metadata()));
		RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_ITO(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(,"Key, LineNumber, ItemKey");
		ItemListTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
		ItemListTable.FillValues(ThisObject.StoreReceiver, "Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
EndProcedure

