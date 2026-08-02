
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	ChoiceData.Add(LandedCost);
	If FOServer.IsUseBatchReallocate() Then
		ChoiceData.Add(LandedCostBatchReallocate);
	EndIf;
EndProcedure
