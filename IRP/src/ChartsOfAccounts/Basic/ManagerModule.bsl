
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If Parameters.Property("Filter") 
		And Parameters.Filter.Property("LedgerType") Then
		
		If ValueIsFilled(Parameters.Filter.LedgerType) Then			
			Parameters.Filter.Insert("LedgerTypeVariant", Parameters.Filter.LedgerType.LedgerTypeVariant);
		EndIf;
		
		Parameters.Filter.Delete("LedgerType");
	EndIf;	
EndProcedure
