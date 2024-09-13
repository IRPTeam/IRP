#Region FormEventHandlers
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCompaniesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	CompanyCreationQuestion(ThisObject.FormOwner.Object.Ref);
EndProcedure

#EndRegion

&AtClient
Procedure OurCompanyFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "OurCompany", ?(OurCompanyFilter = 1, True, False),
		DataCompositionComparisonType.Equal, ValueIsFilled(OurCompanyFilter));
EndProcedure

#Region COMMANDS

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	SelectedRows = Items.List.SelectedRows;
	ExternalCommandsClient.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name, SelectedRows);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName, SelectedRows) Export
	ExternalCommandsServer.GeneratedListChoiceFormCommandActionByName(SelectedRows, ThisObject, CommandName);
EndProcedure

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, List, Items.List.SelectedRows);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, List, Items.List.SelectedRows);
EndProcedure

#EndRegion

#Region Private

// Company creation question.
// 
// Parameters:
//  FormOwnerRef - CatalogRef.Partners
&AtClient
Procedure CompanyCreationQuestion(FormOwnerRef)
	If ValueIsFilled(FormOwnerRef) And
	 TypeOf(FormOwnerRef) = Type("CatalogRef.Partners") And
	 Not PartnerHasCompanies(FormOwnerRef) And
	 PartnerTypeMustHaveCompany(FormOwnerRef) Then
	  	TextQuestion = R().QuestionToUser_032;
		AdditionalParameters = New Structure;
		AdditionalParameters.Insert("Partner", FormOwnerRef);
		CallbackDescription = New CallbackDescription("CompanyCreationQuestionAfter", ThisObject, AdditionalParameters);
   		ShowQueryBox(CallbackDescription, TextQuestion, QuestionDialogMode.YesNo);
	EndIf;		
EndProcedure

// Company creation question after.
// 
// Parameters:
//  QuestionResult - DialogReturnCode
//  AdditionalParameters - Structure
&AtClient
Procedure CompanyCreationQuestionAfter(QuestionResult, AdditionalParameters) Export
	If QuestionResult = DialogReturnCode.Yes Then
		CreateCompanyForPartner(AdditionalParameters.Partner);
		Items.List.Refresh();			 
	EndIf;		
EndProcedure

// Create company for partner.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
&AtServer
Procedure CreateCompanyForPartner(PartnerRef)
	AttributesStructure = CommonFunctionsServer.GetAttributesFromRef(PartnerRef, "Description_en, Description_ru, Description_tr, TaxID"); 
	CompanyObject = Catalogs.Companies.CreateItem();
	FillPropertyValues(CompanyObject, AttributesStructure);
	CompanyObject.Type = PredefinedValue("Enum.CompanyLegalType.Company");
	CompanyObject.Partner = PartnerRef;
	CompanyObject.Write();
EndProcedure

// Partner has companies.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
// 
// Returns:
//  Boolean - Partner has companies
&AtServerNoContext
Function PartnerHasCompanies(PartnerRef)
		
	Query = New Query;
	Query.SetParameter("Partner", PartnerRef);
	Query.Text =
		"SELECT
		|	Companies.Ref
		|FROM
		|	Catalog.Companies AS Companies
		|WHERE
		|	Companies.Partner = &Partner";
	
	ResultIsEmpty = Query.Execute().IsEmpty();
	Return Not ResultIsEmpty;	
	
EndFunction	

// Partner type must have company.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
// 
// Returns:
//  Boolean - Partner type must have company
&AtServerNoContext
Function PartnerTypeMustHaveCompany(PartnerRef)
	PartnerTypeMustHaveCompany = False;
	AttributesStructure = CommonFunctionsServer.GetAttributesFromRef(PartnerRef, "Customer, Vendor, Consignor, Other");
	If AttributesStructure.Customer Or
		AttributesStructure.Vendor Or
		AttributesStructure.Consignor Or
		AttributesStructure.Other Then
			PartnerTypeMustHaveCompany = True;
			
	EndIf;
	Return PartnerTypeMustHaveCompany;
EndFunction			

#EndRegion