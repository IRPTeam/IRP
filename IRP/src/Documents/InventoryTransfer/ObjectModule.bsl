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
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
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
EndProcedure