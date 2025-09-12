
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	csv = DocELedgerRegistryServer.CreateCSV(CommandParameter);
	csv.Show("eLedger");
EndProcedure
