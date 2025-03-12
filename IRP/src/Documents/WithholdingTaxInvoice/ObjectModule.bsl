Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		Parameters = CurrenciesClientServer.GetParameters_V3(ThisObject);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	
		AmountsInfo = CurrenciesClientServer.GetLocalTotalAountsInfo();	
		AmountsInfo.TotalAmount.Value = ThisObject.ItemList.Total("TotalAmount");
		AmountsInfo.NetAmount.Value   = ThisObject.ItemList.Total("NetAmount");
		AmountsInfo.TaxAmount.Value   = ThisObject.ItemList.Total("TaxAmount");
		TotalAmounts = CurrenciesServer.GetLocalTotalAmounts(ThisObject, Parameters, AmountsInfo);
		CurrenciesServer.UpdateLocalTotalAmounts(ThisObject, TotalAmounts, AmountsInfo);

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
	Return;
EndProcedure
