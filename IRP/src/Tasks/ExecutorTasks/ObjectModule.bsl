// @strict-types

Procedure BeforeExecute(Cancel)
	
	If AcceptetionForExecutionDate = Date(1,1,1) Then
		AcceptetionForExecutionDate = ExecutionDate;
	EndIf;

EndProcedure

Procedure OnWrite(Cancel)
	
	If AutoExecute And Not Executed Then
		AutoExecute = False;
		ExecuteTask();
	EndIf;

EndProcedure

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If Executed Then
		If CurrentExecutor.IsEmpty() Then
			CurrentExecutor = SessionParameters.CurrentUser;
		EndIf;
		If ExecutionDate = Date(1,1,1) Then
			ExecutionDate = CommonFunctionsServer.GetCurrentSessionDate();
		EndIf;
	EndIf;
	
EndProcedure
