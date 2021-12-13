
Function GetParameters(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("ArrayOfLadgerTypes", AccountingServer.GetLadgerTypesByCompany(Object.Ref, Object.Date, Object.Company));
	Return Parameters;
EndFunction