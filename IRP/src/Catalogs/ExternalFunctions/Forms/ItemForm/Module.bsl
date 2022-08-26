// @strict-types

&AtClient
Procedure Run(Command)
	RunAtServer();
EndProcedure

&AtServer
Procedure RunAtServer()
	
	Params = CommonFunctionsServer.GetRecalculateExpressionParams();
	Params.Eval = Object.ExternalFunctionType = Enums.ExternalFunctionType.Eval;
	Params.SafeMode = Object.SafeModeIsOn;
	Params.Expression = Object.ExternalCode;
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	
	Result = ResultInfo.Result;
	Items.Result.ToolTip = String(TypeOf(ResultInfo.Result));

	If ResultInfo.isError Then
		CommonFunctionsClientServer.ShowUsersMessage(ResultInfo.Description);
	EndIf;

	ResultJSON = CommonFunctionsServer.SerializeJSON(Result);
	
EndProcedure
