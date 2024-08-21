Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
	CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
	AmountsInfo.TotalAmount.Value = CalculationServer.CalculateDocumentAmount(ItemList, "TotalAmount");
	AmountsInfo.NetAmount.Value   = CalculationServer.CalculateDocumentAmount(ItemList, "NetAmount");
	AmountsInfo.TaxAmount.Value   = CalculationServer.CalculateDocumentAmount(ItemList, "TaxAmount");
	TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
	CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
	
	ThisObject.DocumentAmount = CalculationServer.CalculateDocumentAmount(ItemList);
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
	If Not IsNew() And Modified() Then
		ClosingOrder = DocWorkOrderClosingServer.GetLastWorkOrderClosingByWorkOrder(Ref);
		If Not ClosingOrder.IsEmpty() Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_022, ClosingOrder));
		EndIf;
	EndIf;

	If ValueIsFilled(ThisObject.Company) Then
		Query = New Query;
		Query.Text =
		"SELECT
		|	Materials.LineNumber AS LineNumber,
		|	Materials.Key AS Key,
		|	CAST(Materials.Store AS Catalog.Stores) AS Store
		|into ttMaterials
		|FROM
		|	&Materials AS Materials
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
		|	Materials.LineNumber AS LineNumber,
		|	Materials.Store AS Store,
		|	Materials.Store.Company AS StoreCompany,
		|	RowIDInfo.Basis AS Basis
		|FROM
		|	ttMaterials AS Materials
		|		LEFT JOIN ttRowIDInfo AS RowIDInfo
		|		ON Materials.Key = RowIDInfo.Key
		|
		|ORDER BY
		|	LineNumber";
		Query.SetParameter("Materials", ThisObject.Materials.Unload());
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
					"Object.Materials[" + (QuerySelection.LineNumber - 1) + "].Store", 
					"Object.Materials");
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
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
		FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
	EndIf;
EndProcedure
