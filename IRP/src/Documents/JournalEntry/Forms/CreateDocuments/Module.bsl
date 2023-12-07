
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ArrayOfDocuments = AccountingServer.GetSupportedDocuments();
	
	For Each Doc In ArrayOfDocuments Do
		NewRow = ThisObject.TableDocuments.Add();
		NewRow.Name = Doc.Name;
		NewRow.Presentation = Doc.Synonym;
	EndDo;
EndProcedure

&AtClient
Procedure DocumentsBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentsBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CheckAll(Command)
	ChangeCheck(True);
EndProcedure

&AtClient
Procedure UncheckAll(Command)
	ChangeCheck(False);
EndProcedure

&AtClient
Procedure ChangeCheck(Value)
	For Each Row In ThisObject.TableDocuments Do
		Row.Use = Value;
	EndDo;
EndProcedure

&AtClient
Procedure CreateDocuments(Command)
	For Each Row In ThisObject.TableDocuments Do
		If Row.Use Then
			CreateDocumentsAtServer(Row.Name);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure CreateDocumentsAtServer(DocumentName)
	AccountingServer.CreateJE_ByDocumentName(DocumentName, 
		ThisObject.Company, 
		ThisObject.LedgerType, 
		ThisObject.Period.StartDate,
		ThisObject.Period.EndDate);
EndProcedure
