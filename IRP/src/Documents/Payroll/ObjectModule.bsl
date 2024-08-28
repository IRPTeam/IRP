Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;

	For Each Row In ThisObject.AccrualList Do
		Parameters = CurrenciesClientServer.GetParameters_V5(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	
	For Each Row In ThisObject.DeductionList Do
		Parameters = CurrenciesClientServer.GetParameters_V5(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	
	For Each Row In ThisObject.CashAdvanceDeductionList Do
		Parameters = CurrenciesClientServer.GetParameters_V7(ThisObject, 
	                                                         Row.Key, 
	                                                         ThisObject.Currency, 
	                                                         Row.Amount, 
	                                                         Row.Agreement);
		
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	
	For Each Row In ThisObject.SalaryTaxList Do
		Parameters = CurrenciesClientServer.GetParameters_V5(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
		
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	
	ThisObject.DocumentAmount = 
	ThisObject.AccrualList.Total("Amount")
	- ThisObject.DeductionList.Total("Amount") 
	- ThisObject.CashAdvanceDeductionList.Total("Amount");
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel, "AccrualList");
		AccountingServer.OnWrite(ThisObject, Cancel, "DeductionList");
		AccountingServer.OnWrite(ThisObject, Cancel, "CashAdvanceDeductionList");
		AccountingServer.OnWrite(ThisObject, Cancel, "SalaryTaxList");
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
	Return;
EndProcedure
