Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each Row In ThisObject.Payments Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = String(New UUID());
		EndIf;
	EndDo;
	
	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
		AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
		AmountsInfo.TotalAmount.Value = CalculationServer.CalculateDocumentAmount(ItemList, "TotalAmount");
		AmountsInfo.NetAmount.Value   = CalculationServer.CalculateDocumentAmount(ItemList, "NetAmount");
		AmountsInfo.TaxAmount.Value   = CalculationServer.CalculateDocumentAmount(ItemList, "TaxAmount");
		TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
		CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);

	EndIf;
	
	ThisObject.DocumentAmount = CalculationServer.CalculateDocumentAmount(ItemList);
	ThisObject.DocumentNumber = DocumentsServer.GenerateDocumentNumber(ThisObject);
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.TransactionType <> Enums.SalesTransactionTypes.RetailSales Then
		CommonFunctionsServer.DeleteFormArrayIfPresent(CheckedAttributes, "RetailCustomer");
	EndIf;
	
	If Not IsNew() And Modified() Then
		ClosingOrder = DocOrderClosingServer.GetClosingBySalesOrder(Ref);
		If Not ClosingOrder.IsEmpty() Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_022, ClosingOrder));
		EndIf;
	EndIf;

	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	For RowIndex = 0 To (ThisObject.ItemList.Count() - 1) Do
		Row = ThisObject.ItemList[RowIndex];
		If Not ValueIsFilled(Row.ProcurementMethod) And Row.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Product Then
			MessageText = StrTemplate(R().Error_010, R().S_023);
			CommonFunctionsClientServer.ShowUsersMessage(MessageText, "Object.ItemList[" + RowIndex
				+ "].ProcurementMethod", "Object.ItemList");
			Cancel = True;
		EndIf;

		If Row.Cancel And Row.CancelReason.IsEmpty() Then
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_093, "Object.ItemList[" + RowIndex
				+ "].CancelReason", "Object.ItemList");
			Cancel = True;
		EndIf;
	EndDo;

	If Not Cancel = True Then
		If ThisObject.TransactionType = Enums.SalesTransactionTypes.ShipmentToTradeAgent Then
			ItemListTable = CommissionTradeServer.GetItemListTable(ThisObject);
			CommissionTradeServer.FillCheckProcessing_ShipmentToTradeAgent(Cancel, ItemListTable, ThisObject.TransactionType);
		EndIf;
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

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.Posting_RowID(ThisObject, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.UndoPosting_RowIDUndoPosting(ThisObject, Cancel);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		FillingData = New Structure();
		FillingData.Insert("TransactionType", Enums.SalesTransactionTypes.Sales);
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
	Else	
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
		Number = Undefined;
		Date = Undefined;
	EndIf;
EndProcedure
