

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If ThisObject.Parameters.Property("EndDate") Then
		List.Parameters.SetParameterValue("EndOfPeriod",ThisObject.Parameters.EndDate);
	Else
		List.Parameters.SetParameterValue("EndOfPeriod",CurrentDate());
	EndIf;
	
	If ThisObject.Parameters.Property("ArrayOfChoisedDocuments") 
		And ThisObject.Parameters.ArrayOfChoisedDocuments.Count() Then
		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", True);
		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", ThisObject.Parameters.ArrayOfChoisedDocuments);
	Else
		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", False);
		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Undefined);
	EndIf;
EndProcedure
