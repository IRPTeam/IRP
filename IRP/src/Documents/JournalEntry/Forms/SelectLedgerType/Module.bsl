
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each Row In Parameters.ArrayOfJournalEntries Do
		NewRow = ThisObject.JournalEntries.Add();
		NewRow.JournalEntry = Row.JournalEntry;
		NewRow.LedgerType   = Row.LedgerType;
		NewRow.Icon = Not ValueIsFilled(Row.JournalEntry);
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	CloseAndReturnResult();
EndProcedure

&AtClient
Procedure JournalEntriesSelection(Item, RowSelected, Field, StandardProcessing)
	CloseAndReturnResult();
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
