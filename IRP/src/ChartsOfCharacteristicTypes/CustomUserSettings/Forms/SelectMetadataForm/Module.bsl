&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ArrayOfSelectedObjects = Parameters.ArrayOfSelectedObjects;
	For Each MetadataObject In Metadata.Documents Do
		NewRow = ThisObject.MetadataObjectsTable.Add();
		NewRow.Synonym = MetadataObject.Synonym;
		NewRow.FullName = MetadataObject.FullName();
		NewRow.PictureIndex = 1;
		NewRow.Use = ArrayOfSelectedObjects.Find(NewRow.FullName) <> Undefined;
	EndDo;
	For Each MetadataObject In Metadata.Catalogs Do
		NewRow = ThisObject.MetadataObjectsTable.Add();
		NewRow.Synonym = MetadataObject.Synonym;
		NewRow.FullName = MetadataObject.FullName();
		NewRow.PictureIndex = 8;
		NewRow.Use = ArrayOfSelectedObjects.Find(NewRow.FullName) <> Undefined;
	EndDo;
EndProcedure

&AtClient
Procedure MetadataObjectsTableBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure MetadataObjectsTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Ok(Command)
	ArrayOfSelectedObjects = New Array();
	For Each Row In ThisObject.MetadataObjectsTable Do
		If Row.Use Then
			ArrayOfSelectedObjects.Add(New Structure("FullName, Synonym", Row.FullName, Row.Synonym));
		EndIf;
	EndDo;
	Close(New Structure("ArrayOfSelectedObjects", ArrayOfSelectedObjects));
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure