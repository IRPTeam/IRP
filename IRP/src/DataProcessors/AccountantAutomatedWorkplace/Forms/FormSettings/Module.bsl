
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	VisibleSettings = DataProcessors.AccountantAutomatedWorkplace.GetSettings();
	
	FillPropertyValues(ThisObject, VisibleSettings);
	
EndProcedure

&AtClient
Procedure Save(Command)
	
	SaveAtServer();
	Close();
	
EndProcedure

&AtServer
Procedure SaveAtServer()

	VisibleSettings = DataProcessors.AccountantAutomatedWorkplace.GetSettings();
	
	FillPropertyValues(VisibleSettings, ThisObject);
	
	DataProcessors.AccountantAutomatedWorkplace.SaveSettings(VisibleSettings);

EndProcedure