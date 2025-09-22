Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(ThisObject.PartnerUUID) Then
		ThisObject.PartnerUUID = New UUID();
	EndIf;

	If Not ValueIsFilled(ThisObject.TaxUUID) Then
		ThisObject.TaxUUID = New UUID();
	EndIf;
	
	TotalTable = New ValueTable();
	TotalTable.Columns.Add("Key");
	TotalTable.Add().Key = ThisObject.PartnerUUID;
	TotalTable.Add().Key = ThisObject.TaxUUID;
	
	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, TotalTable);
		
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.PartnerUUID, ThisObject.Currency, 
			ThisObject.ItemList.Total("TotalAmount"), ThisObject.Agreement);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.PartnerUUID);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
			
		AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
		AmountsInfo.TotalAmount.Value = ThisObject.ItemList.Total("TotalAmount");
		AmountsInfo.NetAmount.Value   = ThisObject.ItemList.Total("NetAmount");
		AmountsInfo.TaxAmount.Value   = ThisObject.ItemList.Total("TaxAmount");
		TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
		CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);
		
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, ThisObject.TaxUUID, ThisObject.Currency, 
		ThisObject.ItemList.Total("WithholdingTaxAmount"), ThisObject.TaxAgreement);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, ThisObject.TaxUUID);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
		
	EndIf;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	
	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
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
	If FillingData = Undefined Then
		FillingData = New Structure();
		FillPropertyValues(ThisObject, FillingData);
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	IsFilled_WithholdingTaxAmount = False;
	For Each Row In ThisObject.ItemList Do
		If ValueIsFilled(Row.WithholdingTaxAmount) Then
			IsFilled_WithholdingTaxAmount = True;
			Break;
		EndIf;
	EndDo;
	If IsFilled_WithholdingTaxAmount Then
		CheckedAttributes.Add("TaxPartner");
		CheckedAttributes.Add("TaxAgreement");
		CheckedAttributes.Add("TaxLegalName");
	EndIf;
EndProcedure
