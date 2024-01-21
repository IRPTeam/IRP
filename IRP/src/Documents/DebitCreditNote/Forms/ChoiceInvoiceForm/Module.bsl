
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.List.Parameters.SetParameterValue("Period", 
		New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding));
		
EndProcedure
