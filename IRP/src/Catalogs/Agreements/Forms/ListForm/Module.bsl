#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	CatAgreementsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
	CatalogsServer.OnCreateAtServerListForm(ThisObject, List, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ThisObject.FormOwner <> Undefined Then
		AgreementCreationQuestion(ThisObject.FormOwner.Object.Ref);
	EndIf;	
EndProcedure

#EndRegion

&AtClient
Procedure ListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	CommonFormActions.DynamicListBeforeAddRow(ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Agreements.ObjectForm");
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
// Agreement creation question.
// 
// Parameters:
//  FormOwnerRef - CatalogRef.Partners
&AtClient
Procedure AgreementCreationQuestion(FormOwnerRef)
	If ValueIsFilled(FormOwnerRef) And
	 TypeOf(FormOwnerRef) = Type("CatalogRef.Partners") And
	 Not PartnerHasAgreements(FormOwnerRef) Then
	  	TextQuestion = R().QuestionToUser_033;
		AdditionalParameters = New Structure;
		AdditionalParameters.Insert("Partner", FormOwnerRef);
		CallbackDescription = New CallbackDescription("AgreementCreationQuestionAfter", ThisObject, AdditionalParameters);
   		ShowQueryBox(CallbackDescription, TextQuestion, QuestionDialogMode.YesNo);
	EndIf;		
EndProcedure

// Company creation question after.
// 
// Parameters:
//  QuestionResult - DialogReturnCode
//  AdditionalParameters - Structure
&AtClient
Procedure AgreementCreationQuestionAfter(QuestionResult, AdditionalParameters) Export
	If QuestionResult = DialogReturnCode.Yes Then
		CreateAgreementForPartner(AdditionalParameters.Partner);
		AgreementStructure = New Structure;
		AgreementStructure.Insert("Company", GetDefaultCompany());
		AgreementStructure.Insert("Partner", AdditionalParameters.Partner);
		AgreementStructure.Insert("CurrencyMovementType", GetDefaultMovementType());
		
		FormParameters = New Structure("FillingValues", AgreementStructure);
		
		OpenForm("Catalog.Agreements.Form.ItemForm", FormParameters);			 
	EndIf;		
EndProcedure

&AtServerNoContext
Function GetDefaultMovementType()
	Query = New Query;
	Query.Text = 
	"SELECT
	|	Companies.Ref.LegalCurrencyMovementType AS LegalCurrencyMovementType
	|FROM
	|	Catalog.Companies AS Companies
	|WHERE
	|	Companies.OurCompany
	|GROUP BY
	|	Companies.Ref.LegalCurrencyMovementType";
	
	MovementTypeRef = Undefined;
	Selection = Query.Execute().Select();
	If Selection.Next() Then
		MovementTypeRef = Selection.LegalCurrencyMovementType;
	EndIf;
	Return MovementTypeRef;
	
EndFunction	

// Create agreement for partner.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
&AtServer
Procedure CreateAgreementForPartner(PartnerRef)
	
EndProcedure

&AtServer
Function GetDefaultCompany()
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Companies.Ref AS CompanyRef
		|FROM
		|	Catalog.Companies AS Companies
		|WHERE
		|	Companies.OurCompany = FALSE";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	Company = Undefined;
	If SelectionDetailRecords.Next() Then
		Company =  SelectionDetailRecords.CompanyRef;
	EndIf;
	Return Company; 
	
EndFunction	

// Partner has companies.
// 
// Parameters:
//  PartnerRef - CatalogRef.Partners
// 
// Returns:
//  Boolean - Partner has agreements
&AtServerNoContext
Function PartnerHasAgreements(PartnerRef)
		
	Query = New Query;
	Query.SetParameter("Partner", PartnerRef);
	Query.Text =
		"SELECT
		|	Agreements.Ref
		|FROM
		|	Catalog.Agreements AS Agreements
		|WHERE
		|	Agreements.Partner = &Partner";
	
	ResultIsEmpty = Query.Execute().IsEmpty();
	Return Not ResultIsEmpty;	
	
EndFunction
#EndRegion