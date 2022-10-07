
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	For Each Row In Parameters.ArrayOfJournalEntrys Do
		NewRow = ThisObject.JournalEntrys.Add();
		NewRow.JournalEntry = Row.JournalEntry;
		NewRow.LedgerType   = Row.LedgerType;
		NewRow.Icon = Not ValueIsFilled(Row.JournalEntry);
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	CloseAnrReturnResult();
EndProcedure

&AtClient
Procedure JournalEntrysSelection(Item, RowSelected, Field, StandardProcessing)
	CloseAnrReturnResult();
EndProcedure

&AtClient
Procedure CloseAnrReturnResult()
	CurrentData = Items.JournalEntrys.CurrentData;
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
Procedure JournalEntrysBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure JournalEntrysBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure


