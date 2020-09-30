&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Spreadsheet = New SpreadsheetDocument;
	PrintQR(Spreadsheet, CommandParameter);

	Spreadsheet.ShowGrid = False;
	Spreadsheet.Protection = False;	
	Spreadsheet.ReadOnly = False;	
	Spreadsheet.ShowHeaders = False;
	Spreadsheet.Show();
EndProcedure

&AtServer
Procedure PrintQR(Spreadsheet, CommandParameter)
	Documents.PhysicalCountByLocation.PrintQR(Spreadsheet, CommandParameter);
EndProcedure
