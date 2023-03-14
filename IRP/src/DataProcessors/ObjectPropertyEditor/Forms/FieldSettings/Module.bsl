
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ColumnsData = Parameters.ColumnsData;
	If ColumnsData = Undefined Then
		Cancel = True;
		Return;
	EndIf;
	
	ThisObject.ShowServiceAttributes = Parameters.ShowServiceAttributes;
	ThisObject.ShowServiceTables = Parameters.ShowServiceTables;
	
	ThisObject.WritingMode = 0;
	If Parameters.UpdateRelatedFieldsWhenWriting Then
		ThisObject.WritingMode = 1;
	ElsIf Parameters.ForcedWriting Then
		ThisObject.WritingMode = 2;
	EndIf;
	
	For Each FieldData In ColumnsData Do
		FieldRow = ThisObject.FieldsTable.Add();
		FieldRow.Field = FieldData.Key;
		FieldRow.Name = FieldData.Value.Presentation;
		FieldRow.Type = String(FieldData.Value.ValueType);
		FieldRow.isVisible = FieldData.Value.isVisible;
		FieldRow.isServiceAttribute = FieldData.Value.isServiceAttribute;
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
		
	ThisObject.FormOwner.FormDataCash.ShowServiceAttributes = ThisObject.ShowServiceAttributes;
	ThisObject.FormOwner.FormDataCash.ShowServiceTables = ThisObject.ShowServiceTables;
	
	ThisObject.FormOwner.FormDataCash.UpdateRelatedFieldsWhenWriting = (ThisObject.WritingMode = 1);
	ThisObject.FormOwner.FormDataCash.ForcedWriting = (ThisObject.WritingMode = 2);
	
	ColumnsData = ThisObject.FormOwner.FormDataCash.ColumnsData;
	
	For Each FieldItem In FieldsTable Do
		ColumnsData[FieldItem.Field].isVisible = FieldItem.isVisible;
		If FieldItem.isServiceAttribute And Not ThisObject.ShowServiceAttributes Then
			ColumnsData[FieldItem.Field].isVisible = False;	
		EndIf;
	EndDo;
	
	Close(True);

EndProcedure
