Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.PaymentList);
	For Each Row In ThisObject.PaymentList Do
		Parameters = CurrenciesClientServer.GetParameters_V2(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
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
