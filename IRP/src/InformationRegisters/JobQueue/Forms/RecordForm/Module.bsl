
// @strict-types

&AtServer
Procedure OnReadAtServer(CurrentObject)
	LogArray = CurrentObject.Log.Get(); // Array of Strings
	If TypeOf(LogArray) = Type("Array") Then
		Logs = StrConcat(LogArray, Chars.LF);
	EndIf;
	DataParameters = CommonFunctionsServer.SerializeJSON(CurrentObject.Parameters.Get());
	Result = CommonFunctionsServer.SerializeJSON(CurrentObject.Result.Get());
EndProcedure
