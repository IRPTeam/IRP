
&AtClient
Procedure DocumentsNamesSelection(Item, RowSelected, Field, StandardProcessing)
	Close(Item.CurrentData.DocumentName);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FillFormWithDocsNames();
	
EndProcedure

&AtServer
Procedure FillFormWithDocsNames()
	
	For Each MetaDoc In Metadata.Documents Do
		NewRow = DocumentsNames.Add();
		NewRow.DocumentName = MetaDoc.Name;
		NewRow.DocumentSynonym = MetaDoc.Synonym;
	EndDo;
	
EndProcedure
