
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.WorkOrder") Then
		ChoiceData.Add(Enums.ProcurementMethods.Stock);
		ChoiceData.Add(Enums.ProcurementMethods.NoReserve);
	Else
		ChoiceData.Add(Enums.ProcurementMethods.Stock);	
		ChoiceData.Add(Enums.ProcurementMethods.Purchase);
		ChoiceData.Add(Enums.ProcurementMethods.NoReserve);
		ChoiceData.Add(Enums.ProcurementMethods.IncomingReserve);
	EndIf;
EndProcedure
