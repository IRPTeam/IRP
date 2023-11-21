
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Date              = Parameters.Date;	
	ThisObject.RowKey            = Parameters.RowKey;
	ThisObject.ActuallyDaysHours = Parameters.ActuallyDaysHours;
	ThisObject.CountDaysHours    = Parameters.CountDaysHours;
EndProcedure

&AtClient
Procedure Ok(Command)
	ThisObject.Close(New Structure("RowKey, ActuallyDaysHours", ThisObject.RowKey, ThisObject.ActuallyDaysHours));
EndProcedure

&AtClient
Procedure Cancel(Command)
	ThisObject.Close(Undefined);
EndProcedure


