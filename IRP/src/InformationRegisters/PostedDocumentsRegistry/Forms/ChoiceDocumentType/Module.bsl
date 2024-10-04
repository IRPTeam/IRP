
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each DocMetadata In Metadata.Documents Do
		NewRow = ThisObject.DocumentTypes.Add();
		NewRow.DocumentName = DocMetadata.Name;
		NewRow.Presentation = DocMetadata.Synonym;
		NewRow.Use = (Parameters.DocumentNames.Find(DocMetadata.Name) <> Undefined);
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	SelectedDocuments = New ValueList();
	
	For Each Row In ThisObject.DocumentTypes Do
		If Not Row.Use Then
			Continue;
		EndIf;
		SelectedDocuments.Add(Row.DocumentName, Row.Presentation);
	EndDo;
	
	Close(New Structure("SelectedDocuments", SelectedDocuments));
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure DocumentTypesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentTypesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure
