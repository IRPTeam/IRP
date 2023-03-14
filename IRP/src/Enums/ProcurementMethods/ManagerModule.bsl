
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.WorkOrder") Then
		ChoiceData.Add(Stock);
		ChoiceData.Add(NoReserve);
	Else
		ChoiceData.Add(Stock);	
		ChoiceData.Add(Purchase);
		ChoiceData.Add(NoReserve);
		ChoiceData.Add(IncomingReserve);
	EndIf;
EndProcedure
