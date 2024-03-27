
Procedure ChoiceDataGetProcessing(ChoiceData, Parameters, StandardProcessing)
	FilterIsSet = (TypeOf(Parameters) = Type("Structure") 
		And ValueIsFilled(Parameters.SearchString)
		And Parameters.Filter.Property("PaymentType")
		And Parameters.Filter.Property("Branch"));
		
	If Not FilterIsSet Then
		Return;
	EndIf;
	
	StandardProcessing = False;
	CommonFormActionsServer.CutLastSymbolsIfCameFromExcel(Parameters);
	CatalogsServer.SetParametersForDataChoosing(Catalogs.BankTerms, Parameters);
	
	Query = New Query;
	If ValueIsFilled(Parameters.Filter.PaymentType) And ValueIsFilled(Parameters.Filter.Branch) Then
		Query.Text = GetQueryText_Filter();
	Else
		Query.Text = GetQueryText_All();
	EndIf;

	Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text);
	
	For Each Filter In Parameters.Filter Do
		Query.SetParameter(Filter.Key, Filter.Value);
	EndDo;
	Query.SetParameter("PaymentType", Parameters.Filter.PaymentType);
	Query.SetParameter("Branch", Parameters.Filter.Branch);
	Query.SetParameter("SearchString", Parameters.SearchString);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ChoiceData = CommonFormActionsServer.QueryTableToChoiceData(QueryTable);
EndProcedure

Function GetQueryText_Filter()
	Return
		"SELECT
		|	2 AS Sort,
		|	Table.Ref AS Ref,
		|	Table.Description_en AS Presentation
		|FROM
		|	Catalog.BankTerms AS Table
		|		INNER JOIN Catalog.BankTerms.PaymentTypes AS TablePaymentTypes
		|		ON Table.Ref = TablePaymentTypes.Ref
		|		AND NOT Table.DeletionMark
		|		AND TablePaymentTypes.PaymentType = &PaymentType
		|		INNER JOIN InformationRegister.BranchBankTerms AS BranchBankTerms
		|		ON BranchBankTerms.BankTerm = Table.Ref
		|		AND BranchBankTerms.Branch = &Branch
		|		AND Table.Description_en LIKE ""%"" + &SearchString + ""%""
		|GROUP BY
		|	Table.Ref";
EndFunction

Function GetQueryText_All()
	//@skip-check ql-constants-in-binary-operation
	Return 
		"SELECT
		|	2 AS Sort,
		|	Table.Ref,
		|	Table.Description_en AS Presentation
		|FROM
		|	Catalog.BankTerms AS Table
		|WHERE
		|	Table.Description_en LIKE ""%"" + &SearchString + ""%""
		|	AND NOT Table.DeletionMark";
EndFunction
