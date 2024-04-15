
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	ChoiceData = New ValueList();
	ChoiceData.Add(VAT);
	
	If FOServer.IsUseSalary() Then
		ChoiceData.Add(Salary);
	EndIf;	
EndProcedure
