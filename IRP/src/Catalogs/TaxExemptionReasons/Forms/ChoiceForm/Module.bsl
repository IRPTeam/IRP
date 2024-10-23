
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)

	Parameters.Filter.Property("TaxRate", TaxRate);
	Items.TaxRateFilter.Enabled = Not ValueIsFilled(TaxRate);
	
	Parameters.Filter.Property("Country", Country);
	Items.CountryFilter.Enabled = Not ValueIsFilled(Country);
	
	Parameters.Filter.Clear();
	
	SetFilters();	

EndProcedure

&AtServer
Procedure SetFilters()
	
	QuerySchemaAPI = DynamicListAPI.Get(List);
	
	DynamicListAPI.ClearFilter(QuerySchemaAPI);
	If ValueIsFilled(TaxRate) Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, 
			"TaxRate = &TaxRateFilter OR TaxRate = Value(Catalog.TaxRates.EmptyRef)");
	EndIf;
	If ValueIsFilled(Country) Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, 
			"Country = &CountryFilter OR Country = Value(Catalog.Countries.EmptyRef)");
	EndIf;
	
	DynamicListAPI.Set(QuerySchemaAPI);
	
	If ValueIsFilled(TaxRate) Then
		List.Parameters.SetParameterValue("TaxRateFilter", TaxRate); 
	EndIf;
	If ValueIsFilled(Country) Then
		List.Parameters.SetParameterValue("CountryFilter", Country); 
	EndIf;
	
EndProcedure

&AtClient
Procedure CountryFilterOnChange(Item)
	SetFilters();
EndProcedure

&AtClient
Procedure TaxRateFilterOnChange(Item)
	SetFilters();
EndProcedure
