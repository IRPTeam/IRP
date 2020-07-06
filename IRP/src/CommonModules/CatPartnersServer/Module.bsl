Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;
	If Form.FormName = "Catalog.Partners.Form.ChoiceForm" Then
		Form.List.Parameters.SetParameterValue("FilterPartnersByCompanies", Parameters.FilterPartnersByCompanies);
		Form.List.Parameters.SetParameterValue("PartnersByCompanies", New Array());
		If Parameters.FilterPartnersByCompanies Then
			CompaniesArray = New Array();
			CompaniesArray.Add(Parameters.Company);
			PartnersArray = CatPartnersServer.GetPartnersByCompanies(CompaniesArray);
			Form.List.Parameters.SetParameterValue("PartnersByCompanies", PartnersArray);
		EndIf;
	EndIf;
EndProcedure

Function GetPartnersByCompanies(CompaniesArray) Export
	
	ReturnValue = New Array;
	
	Query = New Query;
	Query.Text = "SELECT
		|	Company.Partner
		|FROM
		|	Catalog.Companies AS Company
		|WHERE
		|	Company.Ref IN (&CompaniesArray)
		|GROUP BY
		|	Company.Partner";
	Query.SetParameter("CompaniesArray", CompaniesArray);
	QueryExecute = Query.Execute();
	If Not QueryExecute.IsEmpty() Then
		QueryUnload = QueryExecute.Unload();
		ReturnValue = QueryUnload.UnloadColumn("Partner");
	EndIf;
	
	Return ReturnValue;
	
EndFunction