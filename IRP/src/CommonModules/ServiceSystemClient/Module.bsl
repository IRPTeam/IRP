Procedure SetSessionParameter(Name, Value, AddInfo = Undefined) Export
	ServiceSystemServer.SetSessionParameter(Name, Value, AddInfo);
EndProcedure

Function GetProgramTitle() Export
	Return ServiceSystemServer.GetProgramTitle();
EndFunction