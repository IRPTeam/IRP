// @strict-types

Procedure BeforeExecute(Cancel)
	
	CurrentExecutor = SessionParameters.CurrentUser;
	ExecutionDate = CommonFunctionsServer.GetCurrentSessionDate();
	
	If AcceptetionForExecutionDate = Date(1,1,1) Then
		AcceptetionForExecutionDate = ExecutionDate;
	EndIf;

EndProcedure

