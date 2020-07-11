#Region FormEvents

Procedure AfterWriteAtServer(Object, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object);
EndProcedure

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	DocumentsServer.FillItemList(Object);
	DocLabelingServer.CreateCommandsAndItems(Object);
EndProcedure

#EndRegion

#Region GenerateBarcode

Procedure CreateCommandsAndItems(Object) Export
	Return;
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