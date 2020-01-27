

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	If Parameters.Property("Ref") And ValueIsFilled(Parameters.Ref) Then
		List.Parameters.SetParameterValue("EndOfPeriod", New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		List.Parameters.SetParameterValue("EndOfPeriod",
			?(Parameters.Property("EndDate"), Parameters.EndDate, CurrentDate()));
	EndIf;
	
	If Parameters.Property("ArrayOfChoisedDocuments") 
		And Parameters.ArrayOfChoisedDocuments.Count() Then
		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", True);
		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Parameters.ArrayOfChoisedDocuments);
	Else
		List.Parameters.SetParameterValue("UseArrayOfChoisedDocuments", False);
		List.Parameters.SetParameterValue("ArrayOfChoisedDocuments", Undefined);
	EndIf;
EndProcedure
