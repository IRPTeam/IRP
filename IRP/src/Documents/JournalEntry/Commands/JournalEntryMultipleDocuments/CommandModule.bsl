
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	ArrayOfLedgerTypes = GetArrayOfLedgerTypes();
	If ArrayOfLedgerTypes.Count() > 0 Then	
		AccountingClient.OpenFormSelectLedgerType_MultipleDocuments(CommandExecuteParameters.Source,  
			CommandParameter, ArrayOfLedgerTypes);
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().AccountingError_05, MessageStatus.Information);
	EndIf;
	
EndProcedure

&AtServer
Function GetArrayOfLedgerTypes()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypes.Ref AS LedgerType
	|FROM
	|	Catalog.LedgerTypes AS LedgerTypes
	|WHERE
	|	NOT LedgerTypes.DeletionMark";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ArrayOfLedgerTypes = QueryTable.UnloadColumn("LedgerType");
	
	Return ArrayOfLedgerTypes;
EndFunction
