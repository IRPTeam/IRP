
Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
			
	CurrenciesClientServer.DeleteUnusedRowsFromCurrenciesTable(ThisObject.Currencies, ThisObject.Records);
	For Each Row In ThisObject.Records Do
		Parameters = CurrenciesClientServer.GetParameters_V15(ThisObject, Row);
		CurrenciesClientServer.DeleteRowsByKeyFromCurrenciesTable(ThisObject.Currencies, Row.Key);
		CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	EndDo;	
	
	ThisObject.AdditionalProperties.Insert("WriteMode", WriteMode);				
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	WriteMode = CommonFunctionsClientServer.GetFromAddInfo(ThisObject.AdditionalProperties, "WriteMode");
	If FOServer.IsUseAccounting() And WriteMode = DocumentWriteMode.Posting Then
		AccountingServer.OnWrite(ThisObject, Cancel, "Records");
	EndIf;
	
	SetDeletionMarkForJournalEntry(WriteMode);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	Return;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

// Set deletion mark for journal entry.
// 
// Parameters:
//  WriteMode - DocumentWriteMode - Write mode
Procedure SetDeletionMarkForJournalEntry(WriteMode)
	If WriteMode = DocumentWriteMode.Posting Then
		Return;
	EndIf;	
	UndoPostJournalEntry = False; 
	If DeletionMark Or Not Posted Then
		UndoPostJournalEntry = True;			
	EndIf;
	If Not UndoPostJournalEntry Then
		Return;
	EndIf;		
		
	Query = New Query;
	Query.SetParameter("Basis", Ref);
	Query.Text = "SELECT
	|	JournalEntry.DeletionMark,
	|	JournalEntry.Posted,
	|	JournalEntry.Ref
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	JournalEntry.Basis = &Basis";
	Selection = Query.Execute().Select(); 
	While Selection.Next() Do
		If Not  Selection.DeletionMark Then
			JournalEntryObject = Selection.Ref.GetObject(); //DocumentObject.JournalEntry			
			JournalEntryObject.SetDeletionMark(True);							
		EndIf;	 		 
	EndDo;	
EndProcedure	