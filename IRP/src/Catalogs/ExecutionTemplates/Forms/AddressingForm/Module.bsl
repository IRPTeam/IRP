
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FillPropertyValues(ThisObject, Parameters.TaskRow);

EndProcedure

&AtClient
Procedure OK(Command)
	
	TaskRow = FormOwner.Object[TableName].FindByID(TableRow);
	FillPropertyValues(TaskRow, ThisObject);
	
	Notify("RefreshTaskAdressing");
	
	Close();

EndProcedure
