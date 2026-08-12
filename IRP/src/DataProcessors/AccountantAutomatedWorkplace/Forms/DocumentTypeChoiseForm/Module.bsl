
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillDocumentTypes();
	For Each Row In ThisObject.DocumentTypeTable Do
		If Parameters.SelectedDocumentTypes.Find(Row.DocumentType) <> Undefined Then
			Row.Use = True;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure("SelectedDocumentTypes",  New ValueList());
	For Each Row In ThisObject.DocumentTypeTable Do
		If Row.Use Then
			Result.SelectedDocumentTypes.Add(Row.DocumentType, Row.DocumentName);
		EndIf;
	EndDo;
	Close(Result);
EndProcedure

&AtClient
Procedure CheckAll(Command)
	For Each Row In ThisObject.DocumentTypeTable Do
		Row.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	For Each Row In ThisObject.DocumentTypeTable Do
		Row.Use = False;
	EndDo;
EndProcedure

&AtServer
Procedure FillDocumentTypes()
	ThisObject.DocumentTypeTable.Clear();

	RecorderMetadatas = New Array;
	RecorderTypes = Metadata.Documents.JournalEntry.Attributes.Basis.Type.Types();
	For Each RecorderType In RecorderTypes Do
		RecorderMetadatas.Add(Metadata.FindByType(RecorderType));
	EndDo;
	
	For Each DocMetadata In RecorderMetadatas Do
		NewRow = ThisObject.DocumentTypeTable.Add();
		NewRow.DocumentType = DocMetadata.Name;
		NewRow.DocumentName = DocMetadata.Synonym;
	EndDo;
	
	ThisObject.DocumentTypeTable.Sort("DocumentType");
EndProcedure
