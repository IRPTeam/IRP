Procedure OnCreateAtServer(Cancel, StandardProcessing, Form, Parameters) Export
	FillingData = Undefined;
	If Parameters.Property("FillingData", FillingData) Then
		Form.FillingData = CommonFunctionsServer.SerializeXMLUseXDTO(FillingData);
	EndIf;
	If Form.FormName = "Catalog.Companies.Form.ChoiceForm" Then
		SetChoiceFormParameters(Form, Parameters);
	EndIf;

	For Each FilterItem In Parameters.Filter Do
		If FilterItem.Key = "OurCompany" Then
			OurCompanyFilter = ?(FilterItem.Value = True, 1, 2);
			Form.Items.OurCompanyFilter.Enabled = False;
		EndIf;
		If FilterItem.Key = "Partner" Then
			OurCompanyFilter = 2;
			Form.Items.OurCompanyFilter.Enabled = False;
		EndIf;
	EndDo;

	CommonFunctionsClientServer.SetFilterItem(Form.List.Filter.Items, "OurCompany", ?(OurCompanyFilter = 1, True, False),
		DataCompositionComparisonType.Equal, ValueIsFilled(OurCompanyFilter));
EndProcedure

Procedure SetChoiceFormParameters(Form, Parameters) Export
	Form.List.Parameters.SetParameterValue("FilterByPartnerHierarchy", Parameters.FilterByPartnerHierarchy);
	Form.List.Parameters.SetParameterValue("CompaniesByPartnerHierarchy", New Array());
	If Parameters.FilterByPartnerHierarchy Then
		CompaniesByPartnerHierarchy = Catalogs.Partners.GetCompaniesForPartner(Parameters.Partner);
		If CompaniesByPartnerHierarchy.Count() Then
			Form.List.Parameters.SetParameterValue("CompaniesByPartnerHierarchy", CompaniesByPartnerHierarchy);
		EndIf;
	EndIf;
EndProcedure

Procedure ReadTaxesIntoFormTable(Form) Export
	Set = InformationRegisters.Taxes.CreateRecordSet();
	Set.Filter.Company.Set(Form.Parameters.Key);
	Set.Read();
	Form.CompanyTaxes.Load(Set.Unload());
EndProcedure

Procedure WriteTaxesIntoFormTable(Form, CurrentCompany) Export
	Set = InformationRegisters.Taxes.CreateRecordSet();
	Set.Filter.Company.Set(CurrentCompany);
	For Each Row In Form.CompanyTaxes Do
		Record = Set.Add();
		FillPropertyValues(Record, Row);
		Record.Company = CurrentCompany;
	EndDo;
	Set.Write();
EndProcedure

Procedure ClearTaxesIntoFormTable(CurrentCompany) Export
	Set = InformationRegisters.Taxes.CreateRecordSet();
	Set.Filter.Company.Set(CurrentCompany);
	Set.Clear();
	Set.Write();
EndProcedure

Procedure ReadLedgerTypesFormTable(Form) Export
	Set = InformationRegisters.CompanyLedgerTypes.CreateRecordSet();
	Set.Filter.Company.Set(Form.Parameters.Key);
	Set.Read();
	Form.CompanyLedgerTypes.Load(Set.Unload());	
EndProcedure

Procedure WriteLedgerTypesFormTable(Form, CurrentCompany) Export
	Set = InformationRegisters.CompanyLedgerTypes.CreateRecordSet();
	Set.Filter.Company.Set(CurrentCompany);
	For Each Row In Form.CompanyLedgerTypes Do
		Record = Set.Add();
		FillPropertyValues(Record, Row);
		Record.Company = CurrentCompany;
	EndDo;
	Set.Write();
EndProcedure

Procedure ClearLedgerTypesFormTable(CurrentCompany) Export
	Set = InformationRegisters.CompanyLedgerTypes.CreateRecordSet();
	Set.Filter.Company.Set(CurrentCompany);
	Set.Clear();
	Set.Write();
EndProcedure

Function isUseCompanies() Export
	Return GetFunctionalOption("UseCompanies");
EndFunction