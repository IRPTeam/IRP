
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
	
//	Query = New Query();
//	Query_Text = 
//	"SELECT
//	|	Doc.Ref
//	|INTO Documents
//	|FROM
//	|	Document.%1 AS Doc
//	|WHERE
//	|	Doc.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
//	|	AND Doc.Company = &Company
//	|;
//	|
//	|////////////////////////////////////////////////////////////////////////////////
//	|SELECT
//	|	Documents.Ref AS Basis,
//	|	JournalEntry.Ref AS JournalEntry
//	|FROM
//	|	Documents AS Documents
//	|		LEFT JOIN Document.JournalEntry AS JournalEntry
//	|		ON Documents.Ref = JournalEntry.Basis
//	|		AND NOT JournalEntry.DeletionMark
//	|		AND JournalEntry.LedgerType = &LedgerType";
//	Query.Text = StrTemplate(Query_Text, DocumentName);
//	Query.SetParameter("StartDate"  , ThisObject.Period.StartDate);
//	Query.SetParameter("EndDate"    , ThisObject.Period.EndDate);
//	Query.SetParameter("Company"    , ThisObject.Company);
//	Query.SetParameter("LedgerType" , ThisObject.LedgerType);
//	
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
//	While QuerySelection.Next() Do
//		If ValueIsFilled(QuerySelection.JournalEntry) Then
//			DocObject = QuerySelection.JournalEntry.GetObject();
//			DocObject.Write(DocumentWriteMode.Write);
//		Else
//			DocObject = Documents.JournalEntry.CreateDocument();
//			DocObject.Fill(New Structure("Basis, LedgerType", QuerySelection.Basis, ThisObject.LedgerType));
//			DocObject.Date = QuerySelection.Basis.Date;
//			DocObject.Write(DocumentWriteMode.Write);
//		EndIf;
//	EndDo;
EndProcedure
