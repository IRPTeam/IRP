Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;
	
	If Parameters.Property("FormTitle") Then
		Form.Title = Parameters.FormTitle;	
		Form.AutoTitle = False;
	EndIf;
	
	If Form.FormName = "Catalog.CashAccounts.Form.ChoiceForm" Then
		If Parameters.Property("CustomParameters") Then
			CustomParameters = Parameters.CustomParameters;
			Form.List.CustomQuery = True;
			Form.List.QueryText = CommonFunctionsServer.GetQueryText("Catalog.CashAccounts", , CustomParameters.Fields);
			CommonFunctionsClientServer.SetListFilters(Form.List, CustomParameters.Filters);
			SetListComplexFilters(Form.List, CustomParameters.ComplexFilters);
		EndIf;		
	EndIf;
	
EndProcedure

Function GetCashAccountByCompany(Company, CustomParameters) Export
	If Company.IsEmpty() Then
		Return Catalogs.CashAccounts.EmptyRef();
	EndIf;
	Return GetDefaultChoiceRef(CustomParameters);
EndFunction

Function GetDefaultChoiceRef(Parameters) Export
	QueryTable = CommonFunctionsServer.QueryTable("Catalog.CashAccounts", CatCashAccountsServer, Parameters);
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

Function GetCashAccountInfo(CashAccount) Export
	Return Catalogs.CashAccounts.GetCashAccountInfo(CashAccount);
EndFunction

Procedure SetQueryComplexFilters(Query, QueryParameters) Export	
	ParametersArray = New Array;
	For Each QueryParameter In QueryParameters Do
		UseCustomFilter = True;
		If QueryParameter.FieldName = "ByCompanyWithEmpty" Then
			ParametersArray.Add("(Table.Company = &Company
								|	OR Table.Company = VALUE(Catalog.Companies.EmptyRef))");
			Query.SetParameter("Company", QueryParameter.Value);
			UseCustomFilter = False;
		EndIf;
		If QueryParameter.FieldName = "BySearchString" Then
			ParametersArray.Add("Table.Description_en LIKE ""%%"" + &SearchString + ""%%""");
			Query.SetParameter("SearchString", QueryParameter.Value);
			UseCustomFilter = False;
		EndIf;
		If UseCustomFilter Then
			ParametersArray.Add(QueryParameter.FieldName);
			For Each ValueItem In QueryParameter.Value Do 
				Query.SetParameter(ValueItem.Key, ValueItem.Value);
			EndDo;
		EndIf;
	EndDo;
	Query.Text = Query.Text + ?(ParametersArray.Count(), Chars.LF + "	AND ", "") + StrConcat(ParametersArray, Chars.LF + "	AND ");
	Query.Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Query.Text);
EndProcedure

Procedure SetListComplexFilters(List, QueryParameters) Export
	Filters = List.Filter.Items;
	For Each QueryParameter In QueryParameters Do		
		If QueryParameter.FieldName = "ByCompanyWithEmpty" Then
			FilterItemGroup = Filters.Add(Type("DataCompositionFilterItemGroup"));
			FilterItemGroup.Use = True;
			FilterItemGroup.GroupType = DataCompositionFilterItemsGroupType.OrGroup;
			FilterItem = FilterItemGroup.Items.Add(Type("DataCompositionFilterItem"));
			FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
			FilterItem.Use = True;
			FilterItem.LeftValue = New DataCompositionField("Company");
			FilterItem.RightValue = QueryParameter.Value;
			FilterItem = FilterItemGroup.Items.Add(Type("DataCompositionFilterItem"));
			FilterItem.ComparisonType = DataCompositionComparisonType.Equal;
			FilterItem.Use = True;
			FilterItem.LeftValue = New DataCompositionField("Company");
			FilterItem.RightValue = Catalogs.Companies.EmptyRef();
		EndIf;
		If QueryParameter.FieldName = "BySearchString" Then
			FilterItem = Filters.Add(Type("DataCompositionFilterItem"));
			FilterItem.ComparisonType = DataCompositionComparisonType.Contains;
			FilterItem.Use = True;
			FilterItem.LeftValue = New DataCompositionField("Description_" + SessionParameters.LocalizationCode);
			FilterItem.RightValue = "%" + QueryParameter.Value + "%";
		EndIf;
	EndDo;
EndProcedure