#Region FormEventHandlers
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatCompaniesServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ThisObject.FormOwner <> Undefined And 
		Not DisableAutomaticCreationOfCompanyAndAgreementForPartner() Then
		CompanyCreationQuestion(ThisObject.FormOwner.Object.Ref);
	Endif;	
EndProcedure

#EndRegion

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

&AtClient
Procedure OurCompanyFilterOnChange(Item)
	CommonFunctionsClientServer.SetFilterItem(List.Filter.Items, "OurCompany", ?(OurCompanyFilter = 1, True, False),
		DataCompositionComparisonType.Equal, ValueIsFilled(OurCompanyFilter));
EndProcedure

// Company creation question.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
&AtClient
Procedure CompanyCreationQuestion(PartnerRef)
	
	AskQuestion = False;
	If ValueIsFilled(PartnerRef) And
	 TypeOf(PartnerRef) = Type("CatalogRef.Partners") And
	 Not PartnerHasCompanies(PartnerRef) And
	 PartnerTypeMustHaveCompany(PartnerRef) Then
	 	AskQuestion = True;
	EndIf; 	
  	
  	If Not AskQuestion Then
  		Return;
  	EndIf;	
  	
  	TextQuestion = R().QuestionToUser_032;
	AdditionalParameters = New Structure;
	AdditionalParameters.Insert("Partner", PartnerRef);
	CallbackDescription = New CallbackDescription("CompanyCreationQuestionAfter", ThisObject, AdditionalParameters);
	ShowQueryBox(CallbackDescription, TextQuestion, QuestionDialogMode.YesNo);
			
EndProcedure

// Company creation question after.
// 
// Parameters:
//  QuestionResult - DialogReturnCode
//  AdditionalParameters - Structure
&AtClient
Procedure CompanyCreationQuestionAfter(QuestionResult, AdditionalParameters) Export
	If QuestionResult <> DialogReturnCode.Yes Then
		Return;
	EndIf;	
		
	CreateCompanyForPartner(AdditionalParameters.Partner);
	Items.List.Refresh();			 
		
EndProcedure

// Create company for partner.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
&AtServer
Procedure CreateCompanyForPartner(PartnerRef)
	CompanyObject = Catalogs.Companies.CreateItem();
	FillPropertyValues(CompanyObject, PartnerRef, "Description_en, Description_ru, Description_tr, TaxID");
	CompanyObject.Type = Enums.CompanyLegalType.Company;
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
	CompaniesArray = Catalogs.Partners.GetCompaniesForPartner(PartnerRef);	
	PartnerHasCompanies = False;
	If CompaniesArray.Count() > 0 Then
		PartnerHasCompanies = True;
	EndIf;	 
	Return PartnerHasCompanies;	
	
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
	
	AttributesStructure = CommonFunctionsServer.GetAttributesFromRef(PartnerRef, "Customer, Vendor, Consignor, Other");
	PartnerTypeMustHaveCompany = (AttributesStructure.Customer Or
									AttributesStructure.Vendor Or
									AttributesStructure.Consignor Or
									AttributesStructure.Other);
	Return PartnerTypeMustHaveCompany;
EndFunction

&AtServer
Function DisableAutomaticCreationOfCompanyAndAgreementForPartner()
	Return UserSettingsServer.AllCatalogs_AdditionalSettings_DisableAutomaticCreationOfCompanyAndAgreementForPartner(SessionParameters.CurrentUser);
EndFunction			

#EndRegion