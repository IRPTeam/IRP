
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If CurrenciesServer.NeedUpdateCurrenciesTable(ThisObject) Then
		
		Parameters = CurrenciesClientServer.GetParameters_V13(ThisObject);
		Parameters.Insert("DocObject", ThisObject);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);

	EndIf;
	
	Result = DocTaxesOperationServer.CalculateTaxDifference(ThisObject);
	ThisObject.TaxesDifference.Clear();
	For Each Row In Result Do
		FillPropertyValues(ThisObject.TaxesDifference.Add(), Row);
	EndDo;
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;	
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel, "TaxesDifference");
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
	Return;
EndProcedure
