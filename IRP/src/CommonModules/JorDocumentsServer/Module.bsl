Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	CustomFilter = Undefined;
	If Parameters.Property("CustomFilter", CustomFilter) Then
		Form.List.CustomQuery = True;
		Form.List.QueryText = CustomFilter.QueryText;
		For Each QueryParameter In CustomFilter.QueryParameters Do
			If Form.List.Parameters.Items.Find(QueryParameter.Key) <> Undefined Then
				Form.List.Parameters.SetParameterValue(QueryParameter.Key, QueryParameter.Value);
			EndIf;
		EndDo;
		Period = EndOfDay(CurrentSessionDate());
		Form.List.Parameters.SetParameterValue("Period", Period);
	EndIf;
	
	AdditionalProperties = Form.List.SettingsComposer.Settings.AdditionalProperties;
	AdditionalParameters = Undefined;
	If Not AdditionalProperties.Property("AdditionalParameters", AdditionalParameters) Then
		AdditionalParameters = New Structure;
	EndIf;
	
	EnteredItems = Undefined;
	If Not Parameters.Property("EnteredItems", EnteredItems) Then
		EnteredItems = New Array;
	EndIf;
	AdditionalParameters.Insert("EnteredItems", EnteredItems);
	
	If Parameters.Property("CustomFilter") Then
		AdditionalParameters.Insert("Ref", Parameters.CustomFilter.QueryParameters.Ref);
	EndIf;
	
	If Parameters.Property("DocumentDate") Then
		AdditionalParameters.Insert("DocumentDate", Parameters.DocumentDate);
		
		DateFilter = Undefined;
		CurrentDate = CommonFunctionsServer.GetCurrentSessionDate();
		DateValueFilter = 
			?(BegOfDay(Parameters.DocumentDate) = BegOfDay(CurrentDate), 
				EndOfDay(CurrentDate), Parameters.DocumentDate);
		//DateField = New DataCompositionField("Ref.Date");
		DateField = New DataCompositionField("Date");
		For Each FilterItem In Form.List.Filter.Items Do
			If FilterItem.LeftValue = DateField Then
				DateFilter = FilterItem;
			EndIf;
		EndDo;
		If DateFilter = Undefined Then
			DateFilter = Form.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
			DateFilter.LeftValue = DateField;
		EndIf;
		DateFilter.ComparisonType = DataCompositionComparisonType.LessOrEqual;
		DateFilter.RightValue = DateValueFilter;
		DateFilter.Use = True;
	EndIf;
	
	AdditionalProperties.Insert("AdditionalParameters", AdditionalParameters);
EndProcedure

Procedure ListOnGetDataAtServer(ItemName, Settings, Rows) Export
	If Settings.AdditionalProperties.Property("AdditionalParameters") 
			And Settings.AdditionalProperties.AdditionalParameters.Property("EnteredItems") Then
		FilterKey = "Ref, Company, Partner, LegalName, Agreement, Currency";
		EnteredItems = GetTableEnteredItems();
		For Each EnteredItem in Settings.AdditionalProperties.AdditionalParameters.EnteredItems Do
			FillPropertyValues(EnteredItems.Add(), EnteredItem);
		EndDo;
		EnteredItems.GroupBy(FilterKey, "Amount");
		Filter = New Structure(FilterKey);
		For Each RowItem In Rows Do
			FillPropertyValues(Filter, RowItem.Value.Data);
			FindedEnteredItems = EnteredItems.FindRows(Filter);
			For Each EnteredItem In FindedEnteredItems Do 
				NewAmount = Max(RowItem.Value.Data.DocumentAmount - EnteredItem.Amount, 0);
				RowItem.Value.Data.DocumentAmount = NewAmount; 
			EndDo;
		EndDo;
	EndIf;
EndProcedure

// Get table of entered items.
// 
// Returns:
//  ValueTable - Table of entered items:
// * Ref - DocumentRef - Basis document
// * Company - CatalogRef.Companies - Company
// * Partner - CatalogRef.Partners - Partner
// * LegalName - CatalogRef.Companies - LegalName
// * Agreement - CatalogRef.Agreements - Agreement
// * Currency - CatalogRef.Currencies - Currency
// * Amount - Number - Amount
Function GetTableEnteredItems()
	Resultat = New ValueTable();
	Resultat.Columns.Add("Ref", Documents.AllRefsType());
	Resultat.Columns.Add("Company", New TypeDescription("CatalogRef.Companies"));
	Resultat.Columns.Add("Partner", New TypeDescription("CatalogRef.Partners"));
	Resultat.Columns.Add("LegalName", New TypeDescription("CatalogRef.Companies"));
	Resultat.Columns.Add("Agreement", New TypeDescription("CatalogRef.Agreements"));
	Resultat.Columns.Add("Currency", New TypeDescription("CatalogRef.Currencies"));
	Resultat.Columns.Add("Amount", New TypeDescription("Number"));
	Return Resultat;
EndFunction
