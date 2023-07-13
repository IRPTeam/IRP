
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.JobTitle = ThisObject.Parameters.BackgroundJobTitle;
EndProcedure
