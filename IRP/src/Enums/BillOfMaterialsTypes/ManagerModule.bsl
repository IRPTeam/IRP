
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	
	If FOServer.IsUseWorkOrders() Then
		ChoiceData.Add(Work);
	EndIf;
	
	If FOServer.IsUseManufacturing() Then
		ChoiceData.Add(Product);
	EndIf;
EndProcedure
