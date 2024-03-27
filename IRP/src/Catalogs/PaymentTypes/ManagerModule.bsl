
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	FilterIsSet = (TypeOf(Parameters) = Type("Structure") 
		And ValueIsFilled(Parameters.SearchString)
		And Parameters.Filter.Property("BankTerm"));
		
	If Not FilterIsSet Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	CatalogsServer.SetParametersForDataChoosing(Catalogs.PaymentTypes, Parameters);
	
	Filter = "";
	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "CustomSearchFilter" OR FilterItem.Key = "AdditionalParameters" Then
			Continue; // Service properties
		EndIf;
		If FilterItem.Key = "BankTerm" Then
			Continue; // Additional parameters
		EndIf;
		Filter = Filter
			+ "
		|	AND Table." + FilterItem.Key + " = &" + FilterItem.Key;
	EndDo;			 
	
	Query = New Query;
	If ValueIsFilled(Parameters.Filter.BankTerm) Then
		Query.Text = GetQueryText_Filter(Filter);
		Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, "Table.PaymentType");
	Else
		Query.Text = GetQueryText_All(Filter);
		Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text);
	EndIf;
	
	For Each Filter In Parameters.Filter Do
		Query.SetParameter(Filter.Key, Filter.Value);
	EndDo;
	Query.SetParameter("BankTerm", Parameters.Filter.BankTerm);
	Query.SetParameter("SearchString", Parameters.SearchString);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);
EndProcedure

Function GetQueryText_Filter(Filter)
	Return
		"SELECT
		|	2 AS Sort,
		|	Table.PaymentType.Description_en AS Presentation,
		|	Table.PaymentType AS Ref
		|FROM
		|	Catalog.BankTerms.PaymentTypes AS Table
		|WHERE
		|	Table.Ref = &BankTerm
		|	AND NOT Table.PaymentType.DeletionMark " + 
		StrReplace(Filter, "Table.", "Table.Ref.") + "
		|	AND Table.PaymentType.Description_en LIKE ""%"" + &SearchString + ""%""
		|GROUP BY
		|	Table.PaymentType";
EndFunction
	
Function GetQueryText_All(Filter)
	//@skip-check ql-constants-in-binary-operation
	Return 
		"SELECT
		|	2 AS Sort,
		|	Table.Description_en AS Presentation,
		|	Table.Ref
		|FROM
		|	Catalog.PaymentTypes AS Table
		|WHERE
		|	Table.Description_en LIKE ""%"" + &SearchString + ""%""
		|	AND NOT Table.DeletionMark" + Filter;
EndFunction

		