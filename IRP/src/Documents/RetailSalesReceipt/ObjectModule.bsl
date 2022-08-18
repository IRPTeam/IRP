Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	Payments_Amount = ThisObject.Payments.Total("Amount");
	ItemList_Amount = ThisObject.ItemList.Total("TotalAmount");
	If ItemList_Amount <> Payments_Amount Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_095, Payments_Amount, ItemList_Amount));
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	If WriteMode = DocumentWriteMode.Posting Then
		AccountingClientServer.UpdateAccountingTables(ThisObject, "ItemList");
	EndIf;

	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
	
	ValuesBeforeWrite = New Structure();
	ValuesBeforeWrite.Insert("Posted", ThisObject.Ref.Posted);
	ValuesBeforeWrite.Insert("DeletionMark", ThisObject.Ref.DeletionMark);
	
	ThisObject.AdditionalProperties.Insert("ValuesBeforeWrite", ValuesBeforeWrite);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If DocConsolidatedRetailSalesServer.IsClosedRetailDocument(ThisObject.Ref) Then
		ValuesBeforeWrite = ThisObject.AdditionalProperties.ValuesBeforeWrite;
		IsDeletionMark = ThisObject.DeletionMark <> ValuesBeforeWrite.DeletionMark;
		IsUnposting = Not ThisObject.Ref.Posted And ValuesBeforeWrite.Posted;
		
		If IsDeletionMark Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_115, ThisObject.ConsolidatedRetailSales));
		ElsIf IsUnposting Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_116, ThisObject.ConsolidatedRetailSales));
		EndIf;
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

Procedure OnCopy(CopiedObject)
	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(TaxList);
	LinkedTables.Add(Currencies);
	LinkedTables.Add(SerialLotNumbers);
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetilaSales(ThisObject.Branch) 
		And Not ValueIsFilled(ThisObject.ConsolidatedRetailSales) Then
		Cancel = True;
		FieldName = ThisObject.Metadata().Attributes.ConsolidatedRetailSales.Synonym;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_047, FieldName), "ConsolidatedRetailSales", ThisObject);
	EndIf;
EndProcedure