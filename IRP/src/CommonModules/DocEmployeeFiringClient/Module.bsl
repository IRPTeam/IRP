#Region FORM

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region EMPLOYEE

Procedure EmployeeOnChange(Object, Form, Item) Export
	ViewClient_V2.EmployeeOnChange(Object, Form, "");
EndProcedure

#EndRegion
