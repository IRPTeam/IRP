
Procedure UpdateDatabase() Export
	If UpdateManagerServer.NeedOpenForm_UpdateDataBase() Then
		OpenForm("DataProcessor.UpdateDatabase.Form");
	EndIf;
EndProcedure