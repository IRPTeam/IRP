Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	If Not Ref.IsEmpty() Then
		PrintInfo = EquipmentFiscalPrinterServer.GetStatusData(Ref);
		If PrintInfo.IsPrinted And (DeletionMark OR WriteMode = DocumentWriteMode.UndoPosting) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().POS_ERROR_NoDeletingPrintedReceipt, Ref));
		EndIf; 
	EndIf;

	If ThisObject.StatusType = Enums.RetailReceiptStatusTypes.Completed Then
		Payments_Amount = ThisObject.Payments.Total("Amount");
		ItemList_Amount = ThisObject.ItemList.Total("TotalAmount");
		If ItemList_Amount <> Payments_Amount Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_095, Payments_Amount, ItemList_Amount));
		EndIf;
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	For Each Row In ThisObject.Payments Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = String(New UUID());
		EndIf;
	EndDo;
	
	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
	AmountsInfo.TotalAmount.Value = ThisObject.ItemList.Total("TotalAmount");
	AmountsInfo.NetAmount.Value   = ThisObject.ItemList.Total("NetAmount");
	AmountsInfo.TaxAmount.Value   = ThisObject.ItemList.Total("TaxAmount");
	TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
	CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	
	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
	
	ValuesBeforeWrite = New Structure();
	ValuesBeforeWrite.Insert("Posted", ThisObject.Ref.Posted);
	ValuesBeforeWrite.Insert("DeletionMark", ThisObject.Ref.DeletionMark);
	
	ThisObject.AdditionalProperties.Insert("ValuesBeforeWrite", ValuesBeforeWrite);
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
	RowIDInfoPrivileged.BeforeWrite_RowID(ThisObject, Cancel, WriteMode, PostingMode);
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
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_118, ThisObject.ConsolidatedRetailSales));
		ElsIf IsUnposting Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_116, ThisObject.ConsolidatedRetailSales));
		EndIf;
	EndIf;
	RowIDInfoPrivileged.OnWrite_RowID(ThisObject, Cancel);
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel);
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	PrintInfo = EquipmentFiscalPrinterServer.GetStatusData(Ref);
	If PrintInfo.IsPrinted Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(
			StrTemplate(R().POS_ERROR_NoDeletingPrintedReceipt, Ref));
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
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
		ArrayOfProperties = StrSplit(PropertiesHeader, ",");
						
		If FillingData.Property("PriceIncludeTax") And FillingData.PriceIncludeTax = Undefined Then
			FillingData.Delete("PriceIncludeTax");
				
			Index = 0;
			For Each Property In ArrayOfProperties Do
				If Upper(TrimAll(Property)) = Upper("PriceIncludeTax") Then
					ArrayOfProperties.Delete(Index);
					Break;
				EndIf;
				Index = Index + 1;
			EndDo;
					
		EndIf;
		
		PropertiesHeader = StrConcat(ArrayOfProperties, ",");
		
		FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
	EndIf;
EndProcedure

Procedure OnCopy(CopiedObject)
	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(Currencies);
	LinkedTables.Add(SerialLotNumbers);
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);
	
	For Each Row In Payments Do
		Row.RRNCode = "";
		Row.PaymentInfo = "";
	EndDo;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
		
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(ThisObject.Branch) 
		And Not ValueIsFilled(ThisObject.ConsolidatedRetailSales) Then
		Cancel = True;
		FieldName = ThisObject.Metadata().Attributes.ConsolidatedRetailSales.Synonym;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_047, FieldName), "ConsolidatedRetailSales", ThisObject);
	EndIf;

	If ValueIsFilled(ThisObject.Company) Then
		Query = New Query;
		Query.Text =
		"SELECT
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS Key,
		|	CAST(ItemList.Store AS Catalog.Stores) AS Store
		|into ttItemList
		|FROM
		|	&ItemList AS ItemList
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	RowIDInfo.Key AS Key,
		|	RowIDInfo.Basis AS Basis
		|into ttRowIDInfo
		|FROM
		|	&RowIDInfo AS RowIDInfo
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Store AS Store,
		|	ItemList.Store.Company AS StoreCompany,
		|	RowIDInfo.Basis AS Basis
		|FROM
		|	ttItemList AS ItemList
		|		LEFT JOIN ttRowIDInfo AS RowIDInfo
		|		ON ItemList.Key = RowIDInfo.Key
		|
		|ORDER BY
		|	LineNumber";
		Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
		Query.SetParameter("RowIDInfo", ThisObject.RowIDInfo.Unload());
		QuerySelection = Query.Execute().Select();
		While QuerySelection.Next() Do
			If ValueIsFilled(QuerySelection.Basis) Then
				Continue;
			ElsIf ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company_Row,
					QuerySelection.Store,
					ThisObject.Company, 
					QuerySelection.LineNumber);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.ItemList[" + (QuerySelection.LineNumber - 1) + "].Store", 
					"Object.ItemList");
			EndIf;
		EndDo;
	EndIf;
EndProcedure