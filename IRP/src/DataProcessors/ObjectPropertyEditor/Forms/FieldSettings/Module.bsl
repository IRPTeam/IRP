
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ColumnsData = Parameters.ColumnsData;
	If ColumnsData = Undefined Then
		Cancel = True;
		Return;
	EndIf;
	
	ThisObject.ShowServiceAttributes = Parameters.ShowServiceAttributes;
	ThisObject.UpdateRelatedFieldsWhenWriting = Parameters.UpdateRelatedFieldsWhenWriting;
	ThisObject.ForcedWriting = Parameters.ForcedWriting;
	
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
Procedure SaveSettings(Command)
	Items.GroupOfSaveSettings.Visible = Not Items.GroupOfSaveSettings.Visible;
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
	ThisObject.FormOwner.FormDataCash.UpdateRelatedFieldsWhenWriting = ThisObject.UpdateRelatedFieldsWhenWriting;
	ThisObject.FormOwner.FormDataCash.ForcedWriting = ThisObject.ForcedWriting;
	
	ColumnsData = ThisObject.FormOwner.FormDataCash.ColumnsData;
	
	For Each FieldItem In FieldsTable Do
		ColumnsData[FieldItem.Field].isVisible = FieldItem.isVisible;
		If FieldItem.isServiceAttribute And Not ThisObject.ShowServiceAttributes Then
			ColumnsData[FieldItem.Field].isVisible = False;	
		EndIf;
	EndDo;
	
	Close(True);

EndProcedure

&AtClient
Procedure UpdateRelatedFieldsWhenWritingOnChange(Item)
	If ThisObject.UpdateRelatedFieldsWhenWriting Then
		ThisObject.ForcedWriting = False;
	EndIf;
EndProcedure

&AtClient
Procedure ForcedWritingOnChange(Item)
	If ThisObject.ForcedWriting Then
		ThisObject.UpdateRelatedFieldsWhenWriting = False;
	EndIf;
EndProcedure

