
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	
	If FOServer.IsUseWorkOrders() Then
		ChoiceData.Add(Enums.BillOfMaterialsTypes.Work);
	EndIf;
	
	If FOServer.IsUseManufacturing() Then
		ChoiceData.Add(Enums.BillOfMaterialsTypes.Product);
	EndIf;
EndProcedure
