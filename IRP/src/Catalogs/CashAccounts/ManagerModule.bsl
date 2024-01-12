Function GetCashAccountInfo(CashAccount) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	CashAccounts.Currency,
	|	CashAccounts.Ref,
	|	CashAccounts.BankName,
	|	CashAccounts.Type,
	|	CashAccounts.Company
	|FROM
	|	Catalog.CashAccounts AS CashAccounts
	|WHERE
	|	CashAccounts.Ref = &Ref";
	Query.SetParameter("Ref", CashAccount);
	QueryResult = Query.Execute();

	Result = New Structure();
	For Each Column In QueryResult.Columns Do
		Result.Insert(Column.Name);
	EndDo;

	Selection = QueryResult.Select();
	If Selection.Next() Then
		FillPropertyValues(Result, Selection);
	EndIf;
	Return Result;
EndFunction

Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	If TypeOf(Parameters) <> Type("Structure") Or Not ValueIsFilled(Parameters.SearchString)
		Or Not Parameters.Filter.Property("AdditionalParameters") Then
		Return;
	EndIf;

	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	CatalogsServer.SetParametersForDataChoicing(Catalogs.CashAccounts, Parameters);
	QueryTable = GetChoiceDataTable(Parameters);
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);	
EndProcedure

Function GetChoiceDataTable(Parameters)
	Filter = "";
	For Each FilterItem In Parameters.Filter Do
		Filter = Filter
			+ "
		|	AND Table." + FilterItem.Key + " = &" + FilterItem.Key;
	EndDo;			 
	Settings = New Structure();
	Settings.Insert("MetadataObject", Metadata.Catalogs.CashAccounts);
	Settings.Insert("Filter", Filter);
	// enable search by code
	Settings.Insert("UseSearchByCode", True);
	
	QueryBuilderText = CommonFormActionsServer.QuerySearchInputByString(Settings);
	QueryBuilder = New QueryBuilder(QueryBuilderText);
	QueryBuilder.FillSettings();
	CommonFormActionsServer.SetCustomSearchFilter(QueryBuilder, Parameters);
	
	Query = QueryBuilder.GetQuery();
	
	Query.SetParameter("SearchString", Parameters.SearchString);

	// parameters search by code
	SearchStringNumber = CommonFunctionsClientServer.GetSearchStringNumber(Parameters.SearchString);
	Query.SetParameter("SearchStringNumber", SearchStringNumber);
	For Each Filter In Parameters.Filter Do
		Query.SetParameter(Filter.Key, Filter.Value);
	EndDo;

	Return Query.Execute().Unload();	
EndFunction

Function GetDefaultChoiceRef(Parameters) Export
	QueryTable = GetChoiceDataTable(New Structure("SearchString, Filter", "", Parameters));

	If QueryTable.Count() = 1 Then
		Return QueryTable[0].Ref;
	Else
		If Parameters.Property("CashAccount") Then
			Rows = QueryTable.FindRows(New Structure("Ref", Parameters.CashAccount));
			If Rows.Count() = 0 Then
				Return PredefinedValue("Catalog.CashAccounts.EmptyRef");
			Else
				Return Parameters.CashAccount;
			EndIf;
		Else
			Return PredefinedValue("Catalog.CashAccounts.EmptyRef");
		EndIf;
	EndIf;
EndFunction

