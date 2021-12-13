
Function GetLadgerTypesByCompany(Ref, Date, Company) Export
	If Not ValueIsFilled(Company) Then
		Return New Array();
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CompanyLadgerTypesSliceLast.LadgerType
	|FROM
	|	InformationRegister.CompanyLadgerTypes.SliceLast(&Period, Company = &Company) AS CompanyLadgerTypesSliceLast
	|WHERE
	|	CompanyLadgerTypesSliceLast.Use";
	Period = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Ref, Date);
	Query.SetParameter("Period", Period);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ArrayOfLadgerTypes = QueryTable.UnloadColumn("LadgerType");
	Return ArrayOfLadgerTypes;
EndFunction