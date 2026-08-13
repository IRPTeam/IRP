
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
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

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.Ref = ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency
	 Or ThisObject.Ref = ChartsOfCharacteristicTypes.CurrencyMovementType.Default_Legal
	 Or ThisObject.Ref = ChartsOfCharacteristicTypes.CurrencyMovementType.Default_PartnerTerm Then
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Currency");	
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Source");	
		CommonFunctionsClientServer.DeleteValueFromArray(CheckedAttributes, "Type");	
	EndIf;
EndProcedure
