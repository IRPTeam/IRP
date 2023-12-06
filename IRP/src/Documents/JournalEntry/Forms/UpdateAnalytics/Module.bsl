
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
Procedure UpdateAnalytics(Command)
	For Each Row In ThisObject.TableDocuments Do
		If Row.Use Then
			UpdateAnalyticsAtServer(Row.Name);
		EndIf;
	EndDo;
EndProcedure

&AtServer
Procedure UpdateAnalyticsAtServer(DocumentName)
	AccountingServer.UpdateAnalyticsJE_ByDocumentName(DocumentName, 
		ThisObject.Company, 
		ThisObject.Period.StartDate, 
		ThisObject.Period.EndDate);
	
//	Query = New Query();
//	Query_Text = 
//	"SELECT
//	|	Doc.Ref
//	|FROM
//	|	Document.%1 AS Doc
//	|WHERE
//	|	Doc.Posted
//	|	AND Doc.Date BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
//	|	AND Doc.Company = &Company";
//	
//	Query.Text = StrTemplate(Query_Text, DocumentName);
//	Query.SetParameter("StartDate"  , ThisObject.Period.StartDate);
//	Query.SetParameter("EndDate"    , ThisObject.Period.EndDate);
//	Query.SetParameter("Company"    , ThisObject.Company);
//	
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
//	While QuerySelection.Next() Do
//		RecordSet_T9050S = InformationRegisters.T9050S_AccountingRowAnalytics.CreateRecordSet();
//		RecordSet_T9050S.Filter.Document.Set(QuerySelection.Ref);
//		RecordSet_T9050S.Read();
//		_AccountingRowAnalytics = RecordSet_T9050S.Unload();
//		
//		RecordSet_T9051S = InformationRegisters.T9051S_AccountingExtDimensions.CreateRecordSet();
//		RecordSet_T9051S.Filter.Document.Set(QuerySelection.Ref);
//		RecordSet_T9051S.Read();
//		_AccountingExtDimensions = RecordSet_T9051S.Unload();
//					
//		AccountingClientServer.UpdateAccountingTables(QuerySelection.Ref, 
//													  _AccountingRowAnalytics, 
//													  _AccountingExtDimensions, 
//													  AccountingClientServer.GetDocumentMainTable(QuerySelection.Ref));
//													  
//		_AccountingRowAnalytics.FillValues(True, "Active");
//		_AccountingExtDimensions.FillValues(True, "Active");
//		
//		RecordSet_T9050S.Load(_AccountingRowAnalytics);
//		RecordSet_T9050S.Write();
//		
//		RecordSet_T9051S.Load(_AccountingExtDimensions);
//		RecordSet_T9051S.Write();		
//	EndDo;
EndProcedure
