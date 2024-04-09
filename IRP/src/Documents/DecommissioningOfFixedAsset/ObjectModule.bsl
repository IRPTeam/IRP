
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.ItemList);
	For Each Row In ThisObject.ItemList Do
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, Row.Key, CurrenciesServer.GetLandedCostCurrency(ThisObject.Company), Row.Amount);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel);
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
	Return;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;
	EndIf;

	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
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
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Store AS Store,
		|	ItemList.Store.Company AS StoreCompany
		|FROM
		|	ttItemList AS ItemList
		|ORDER BY
		|	LineNumber";
		Query.SetParameter("ItemList", ThisObject.ItemList.Unload());
		QuerySelection = Query.Execute().Select();
		While QuerySelection.Next() Do
			If ValueIsFilled(QuerySelection.StoreCompany) And Not QuerySelection.StoreCompany = ThisObject.Company Then
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
