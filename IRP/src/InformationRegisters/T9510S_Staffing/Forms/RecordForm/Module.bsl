
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Record, ThisObject);
	EndIf;
	
	If Parameters.FillingValues.Property("Employee") 
		And ValueIsFilled(Parameters.FillingValues.Employee) Then
		ThisObject.Items.Employee.ReadOnly = True;
	EndIf; 
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Record, ThisObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Record, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Record, Form)
	Form.Items.Company.Visible  = Not Record.Fired;
	Form.Items.Branch.Visible   = Not Record.Fired;
	Form.Items.Position.Visible = Not Record.Fired;
EndProcedure

&AtClient
Procedure FiredOnChange(Item)
	If Record.Fired Then
		Record.Company  = Undefined;
		Record.Branch   = Undefined;
		Record.Position = Undefined;
	EndIf;
	SetVisibilityAvailability(Record, ThisObject);
EndProcedure

