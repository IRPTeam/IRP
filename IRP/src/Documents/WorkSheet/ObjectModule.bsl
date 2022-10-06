Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
		
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.ItemList);
	For Each Row In ThisObject.ItemList Do
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, Row.Key, ThisObject.Currency, 0);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	MaterialsStoreSynonym = Metadata.Documents.WorkSheet.TabularSections.Materials.Attributes.Store.Synonym;
	
	For Each Row In ThisObject.Materials Do
		If Row.CostWriteOff = Enums.MaterialsCostWriteOff.IncludeToWorkCost 
			And Not ValueIsFilled(Row.Store) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_047, MaterialsStoreSynonym),
			"Materials[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].Store", ThisObject);
		EndIf;
	EndDo;
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_WS(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(,"Key, LineNumber, ItemKey");
		ItemListTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
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
		PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
		FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
	EndIf;
EndProcedure


