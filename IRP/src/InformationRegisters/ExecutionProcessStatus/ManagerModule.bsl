#Region AccessObject

// Get access key.
// See Role.TemplateInformationRegisters
// 
// Returns:
//  Structure - Get access key:
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Get last status.
// 
// Parameters:
//  ExecutionProcess - BusinessProcessRef.ExecutionProcesses - Execution process
// 
// Returns:
//  Structure - Get last status:
//	* ExecutionProcess - BusinessProcessRef.ExecutionProcesses
//	* Period - Date
//	* StatusTime - Number
//	* CurrentStage - UUID
//	* CurrentTask - UUID
//	* IterationNumber - Number
Function GetLastStatus(ExecutionProcess) Export
	
	Query = New Query;
	Query.Text =
	"SELECT TOP 1
	|	ExecutionProcessStatus.ExecutionProcess,
	|	ExecutionProcessStatus.Period AS Period,
	|	ExecutionProcessStatus.StatusTime AS StatusTime,
	|	ExecutionProcessStatus.CurrentStage,
	|	ExecutionProcessStatus.CurrentTask,
	|	ExecutionProcessStatus.IterationNumber
	|FROM
	|	InformationRegister.ExecutionProcessStatus AS ExecutionProcessStatus
	|WHERE
	|	ExecutionProcessStatus.ExecutionProcess = &ExecutionProcess
	|
	|ORDER BY
	|	Period DESC,
	|	StatusTime DESC";
	
	Query.SetParameter("ExecutionProcess", ExecutionProcess);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection;
	EndIf;
	
	Return InformationRegisters.ExecutionProcessStatus.GetLast(, New Structure("ExecutionProcess", ExecutionProcess));
	
EndFunction