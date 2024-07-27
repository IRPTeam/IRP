Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
	RowIDInfoPrivileged.BeforeWrite_RowID(ThisObject, Cancel, WriteMode, PostingMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoPrivileged.OnWrite_RowID(ThisObject, Cancel);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.Posting_RowID(ThisObject, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.UndoPosting_RowIDUndoPosting(ThisObject, Cancel);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") Then
			If FillingData.BasedOn = "ProductionPlanning" Then
				ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
				FillPropertyValues(ThisObject, FillingData);
				For Each Row In FillingData.ItemList Do
					NewRow = ThisObject.ItemList.Add();
					NewRow.Key = String(New UUID());
					FillPropertyValues(NewRow, Row);
				EndDo;
			ElsIf FillingData.BasedOn = "PurchaiceInvoice" Then
				ObjectRef = FillingData.Basis[0];
				If TypeOf(ObjectRef) = Type("DocumentRef.PurchaseInvoice") Then
					DocInventoryTransferServer.FillByPI(FillingData.Basis, ThisObject);
				EndIf;		
			Else
				PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
				FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
				LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
				ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.UseShipmentConfirmation And Not ThisObject.UseGoodsReceipt Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_094, "UseGoodsReceipt");
		Cancel = True;
	EndIf;
	
	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_IT(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(, "Key, LineNumber, ItemKey");
		ItemListTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
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
		If Not ThisObject.StoreTransit.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreTransit, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreTransit,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreTransit", 
					"Object");
			EndIf;
		EndIf;
	EndIf;
EndProcedure