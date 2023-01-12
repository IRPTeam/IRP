
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ColumnsData = Parameters.ColumnsData;
	If ColumnsData = Undefined Then
		Cancel = True;
		Return;
	EndIf;
	
	For Each FieldData In ColumnsData Do
		FieldRow = ThisObject.FieldsTable.Add();
		FieldRow.Field = FieldData.Key;
		FieldRow.Name = FieldData.Value.Presentation;
		FieldRow.Type = String(FieldData.Value.ValueType);
		FieldRow.isVisible = FieldData.Value.isVisible;
	EndDo;

EndProcedure

&AtClient
Procedure CheckAll(Command)
	For Each TableItem In FieldsTable Do
		TableItem.isVisible = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	For Each TableItem In FieldsTable Do
		TableItem.isVisible = False;
	EndDo;
EndProcedure

&AtClient
Procedure ApplySetting(Command)
		
	ColumnsData = ThisObject.FormOwner.FormDataCash.ColumnsData;
	
	For Each FieldItem In FieldsTable Do
		ColumnsData[FieldItem.Field].isVisible = FieldItem.isVisible;
	EndDo;
	
	Close(True);

EndProcedure
