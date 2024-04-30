// @strict-types

Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each Row In ThisObject.CostList Do
		Parameters = CurrenciesClientServer.GetParameters_V5(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
	
	ThisObject.DocumentAmount = ThisObject.CostList.Total("Amount");
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	TypesToControl = New Array; // Array of EnumRef.AccrualsTransactionType
	TypesToControl.Add(Enums.AccrualsTransactionType.Void);
	TypesToControl.Add(Enums.AccrualsTransactionType.Reverse);
	
	If TypesToControl.Find(TransactionType) <> Undefined Then
		CheckedAttributes.Add("Basis");
	EndIf;
	
EndProcedure

