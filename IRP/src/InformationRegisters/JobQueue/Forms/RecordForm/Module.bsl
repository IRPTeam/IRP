
// @strict-types

&AtServer
Procedure OnReadAtServer(CurrentObject)
	LogArray = CurrentObject.Log.Get(); // Array of Strings
	Log = StrConcat(LogArray, Chars.LF);
	DataParameters = CommonFunctionsServer.SerializeJSON(CurrentObject.Parameters.Get());
	Result = CommonFunctionsServer.SerializeJSON(CurrentObject.Result.Get());
EndProcedure
