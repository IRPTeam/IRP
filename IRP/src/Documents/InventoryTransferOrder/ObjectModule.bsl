Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
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
		PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
		FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_ITO(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(, "Key, LineNumber, ItemKey");
		ItemListTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
		ItemListTable.FillValues(ThisObject.StoreReceiver, "Store");
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
	
	If Not ThisObject.Company.IsEmpty() Then
		If Not ThisObject.StoreReceiver.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreReceiver, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreReceiver,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreReceiver", 
					"Object");
			EndIf;
		EndIf;
		If Not ThisObject.StoreSender.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreSender, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreSender,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreSender", 
					"Object");
			EndIf;
		EndIf;
	EndIf;
EndProcedure
