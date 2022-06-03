
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("Key", GetjournalEntryRef(CommandParameter));
	FillingValues = New Structure();
	FillingValues.Insert("Basis", CommandParameter);
	FormParameters.Insert("FillingValues", FillingValues);
	OpenForm("Document.JournalEntry.ObjectForm", FormParameters, CommandExecuteParameters.Source, CommandExecuteParameters.Uniqueness);
EndProcedure

&AtServer
Function GetjournalEntryRef(BasisRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	JournalEntry.Ref
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	JournalEntry.Basis = &Basis
	|	AND NOT JournalEntry.DeletionMark";
	Query.SetParameter("Basis", BasisRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Documents.JournalEntry.EmptyRef();
	EndIf;
EndFunction