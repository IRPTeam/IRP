
&AtClient
Procedure CommandProcessing(DocumentRef, CommandExecuteParameters)
	JournalEntryInfo = GetJournalEntryInfo(DocumentRef);
	
	If JournalEntryInfo.ArrayOfJournalEntries.Count() = 1 Then
		AccountingClient.OpenFormJournalEntry(CommandExecuteParameters.Source, 
			DocumentRef,
			JournalEntryInfo.ArrayOfJournalEntries[0].JournalEntry, 			
			JournalEntryInfo.ArrayOfJournalEntries[0].LedgerType);
	ElsIf JournalEntryInfo.ArrayOfJournalEntries.Count() > 1 Then
		AccountingClient.OpenFormSelectLedgerType(CommandExecuteParameters.Source, 
			DocumentRef, 
			JournalEntryInfo.ArrayOfJournalEntries);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_112, JournalEntryInfo.Company), MessageStatus.Information);
	EndIf;
EndProcedure

&AtServer
Function GetLedgerTypeByCompany(Ref, Date, Company)
	Return AccountingServer.GetLedgerTypesByCompany(Ref, Date, Company);
EndFunction

&AtServer
Function GetJournalEntryInfo(DocumentRef)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypes.Ref AS LedgerType
	|INTO LedgerTypes
	|FROM
	|	Catalog.LedgerTypes AS LedgerTypes
	|WHERE
	|	LedgerTypes.Ref IN (&LedgerTypes)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	JournalEntry.Ref,
	|	LedgerTypes.LedgerType
	|FROM
	|	LedgerTypes AS LedgerTypes
	|		LEFT JOIN Document.JournalEntry AS JournalEntry
	|		ON JournalEntry.Basis = &Basis
	|		AND NOT JournalEntry.DeletionMark
	|		AND JournalEntry.LedgerType = LedgerTypes.LedgerType";
	
	LedgerTypes = GetLedgerTypeByCompany(DocumentRef, DocumentRef.Date, DocumentRef.Company);
	
	Query.SetParameter("Basis"      , DocumentRef);
	Query.SetParameter("LedgerTypes" , LedgerTypes);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfJournalEntries = New Array();
	While QuerySelection.Next() Do
		NewRow = New Structure("JournalEntry, LedgerType", 
			QuerySelection.Ref, QuerySelection.LedgerType);
		ArrayOfJournalEntries.Add(NewRow);
	EndDo;
	Result = New Structure();
	Result.Insert("ArrayOfJournalEntries", ArrayOfJournalEntries);
	Result.Insert("Company", DocumentRef.Company);
	Return Result;
EndFunction
