
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	FilterIsSet = (TypeOf(Parameters) = Type("Structure") 
		And ValueIsFilled(Parameters.SearchString)
		And Parameters.Filter.Property("BankTerm"));
		
	If Not FilterIsSet Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	
	Query = New Query;
	If ValueIsFilled(Parameters.Filter.BankTerm) Then
		Query.Text = GetQueryText_Filter();
		Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text, "Table.PaymentType");
	Else
		Query.Text = GetQueryText_All();
		Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text);
	EndIf;
	
	Query.SetParameter("BankTerm", Parameters.Filter.BankTerm);
	Query.SetParameter("SearchString", Parameters.SearchString);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);
EndProcedure

Function GetQueryText_Filter()
	Return
		"SELECT
		|	2 AS Sort,
		|	Table.PaymentType.Description_en AS Presentation,
		|	Table.PaymentType AS Ref
		|FROM
		|	Catalog.BankTerms.PaymentTypes AS Table
		|WHERE
		|	Table.Ref = &BankTerm
		|	AND NOT Table.PaymentType.DeletionMark
		|	AND Table.PaymentType.Description_en LIKE ""%"" + &SearchString + ""%""
		|GROUP BY
		|	Table.PaymentType";
EndFunction
	
Function GetQueryText_All()
	Return 
		"SELECT
		|	2 AS Sort,
		|	Table.Description_en AS Presentation,
		|	Table.Ref
		|FROM
		|	Catalog.PaymentTypes AS Table
		|WHERE
		|	Table.Description_en LIKE ""%"" + &SearchString + ""%""
		|	AND NOT Table.DeletionMark";
EndFunction

		