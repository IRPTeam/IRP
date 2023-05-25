Function GetNotCheckedAttributes(Ref) Export
	Result = New Array;
	
	If Ref = ManualPriceType Then
		Result.Add("Currency");
		Result.Add("Source");
	EndIf;
	
	Return Result;
EndFunction
