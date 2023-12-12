
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("MultipleDocuments") And Parameters.MultipleDocuments Then
		ThisObject.IsMultipleDocuments = True;
		For Each LedgerType In Parameters.ArrayOfLedgerTypes Do
			NewRow = ThisObject.JournalEntries.Add();
			NewRow.LedgerType   = LedgerType;
		EndDo;
		
		Items.JournalEntriesUse.Visible = True;
		Items.JournalEntriesJournalEntry.Visible = False;
		
	Else
		For Each Row In Parameters.ArrayOfJournalEntries Do
			NewRow = ThisObject.JournalEntries.Add();
			NewRow.JournalEntry = Row.JournalEntry;
			NewRow.LedgerType   = Row.LedgerType;
			NewRow.Icon = Not ValueIsFilled(Row.JournalEntry);
		EndDo;
		
		Items.JournalEntriesUse.Visible = False;
		Items.JournalEntriesJournalEntry.Visible = True;
		
	EndIf;
EndProcedure

&AtClient
Procedure Ok(Command)
	If ThisObject.IsMultipleDocuments Then
		ArrayOfLedgerTypes = New Array();
		For Each Row In JournalEntries Do
			If Row.Use Then
				ArrayOfLedgerTypes.Add(Row.LedgerType);
			EndIf;
		EndDo;
		
		If ArrayOfLedgerTypes.Count() > 0 Then
			Close(New Structure("ArrayOfLedgerTypes", ArrayOfLedgerTypes));
		Else
			Close(Undefined);
		EndIf;
	Else
		CloseAndReturnResult();
	EndIf;
EndProcedure

&AtClient
Procedure JournalEntriesSelection(Item, RowSelected, Field, StandardProcessing)
	If Not ThisObject.IsMultipleDocuments Then
		CloseAndReturnResult();
	EndIf;
EndProcedure

&AtClient
Procedure CloseAndReturnResult()
	CurrentData = Items.JournalEntries.CurrentData;
	If CurrentData = Undefined Then
		Close(Undefined);
		Return;
	EndIf;
	
	Result = New Structure();
	Result.Insert("JournalEntryRef" , CurrentData.JournalEntry); 
	Result.Insert("LedgerTypeRef"   , CurrentData.LedgerType);
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure JournalEntriesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure JournalEntriesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure
