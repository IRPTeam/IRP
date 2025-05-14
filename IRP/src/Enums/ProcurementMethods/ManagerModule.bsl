
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	StandardProcessing = False;
	ChoiceData = New ValueList();
	If Parameters.Filter.Property("Ref") And TypeOf(Parameters.Filter.Ref) = Type("DocumentRef.WorkOrder") Then
		ChoiceData.Add(Stock);
		ChoiceData.Add(NoReserve);
	ElsIf Parameters.Filter.Property("IsService") And Parameters.Filter.IsService = True Then
		ChoiceData.Add(EmptyRef());
		ChoiceData.Add(Purchase);
	Else
		ChoiceData.Add(Stock);	
		ChoiceData.Add(Purchase);
		ChoiceData.Add(NoReserve);
		ChoiceData.Add(IncomingReserve);
	EndIf;
EndProcedure
