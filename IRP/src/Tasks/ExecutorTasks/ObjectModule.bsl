// @strict-types

Procedure BeforeExecute(Cancel)
	
	CurrentExecutor = SessionParameters.CurrentUser;
	ExecutionDate = CommonFunctionsServer.GetCurrentSessionDate();

EndProcedure

