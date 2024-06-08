#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	MoneyDocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	MoneyDocumentsServer.OnReadAtServer(Object, Form, CurrentObject);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	AccountingServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	MoneyDocumentsServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	AccountingServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion
