
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Date              = Parameters.Date;	
	ThisObject.RowKey            = Parameters.RowKey;
	ThisObject.ActuallyDaysHours = Parameters.ActuallyDaysHours;
	ThisObject.CountDaysHours    = Parameters.CountDaysHours;
	ThisObject.IsSickLeave       = Parameters.IsSickLeave;
	ThisObject.IsVacation        = Parameters.IsVacation;
	
	ThisObject.Items.ActuallyDaysHours.ReadOnly = (ThisObject.IsVacation Or ThisObject.IsSickLeave);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetBackColor();
EndProcedure

&AtClient
Procedure ActuallyDaysHoursOnChange(Item)
	SetBackColor();
EndProcedure

&AtClient
Procedure SetBackColor()
	If Not ValueIsFilled(ThisObject.CountDaysHours)
		And Not ValueIsFilled(ThisObject.ActuallyDaysHours) Then
		ThisObject.Items.GroupActually.BackColor = WebColors.LightPink;
		
	ElsIf ValueIsFilled(ThisObject.ActuallyDaysHours)
			And Not ThisObject.IsVacation 
			And Not ThisObject.IsSickLeave Then			
		ThisObject.Items.GroupActually.BackColor = WebColors.LightGreen;
					
	ElsIf ValueIsFilled(ThisObject.CountDaysHours) 
			And Not ValueIsFilled(ThisObject.ActuallyDaysHours) Then
		ThisObject.Items.GroupActually.BackColor = WebColors.LightGray;
			
	ElsIf ValueIsFilled(ThisObject.CountDaysHours) 
			And ValueIsFilled(ThisObject.ActuallyDaysHours)
			And ThisObject.IsVacation Then	
		ThisObject.Items.GroupActually.BackColor = WebColors.LightBlue;
			
	ElsIf ValueIsFilled(ThisObject.CountDaysHours) 
			And ValueIsFilled(ThisObject.ActuallyDaysHours)
			And ThisObject.IsSickLeave Then	
		ThisObject.Items.GroupActually.BackColor = WebColors.PeachPuff;	
	EndIf;
EndProcedure	

&AtClient
Procedure Ok(Command)
	ThisObject.Close(New Structure("RowKey, ActuallyDaysHours", ThisObject.RowKey, ThisObject.ActuallyDaysHours));
EndProcedure

&AtClient
Procedure Cancel(Command)
	ThisObject.Close(Undefined);
EndProcedure

