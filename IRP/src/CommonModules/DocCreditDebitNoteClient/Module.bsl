#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
EndProcedure

#EndRegion

Procedure DateOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	If Form.CurrentCompany <> Object.Company
		And Object.Transactions.Count() Then
		ShowQueryBox(New NotifyDescription("TransactionsBeforeClearing", ThisObject, New Structure("Form", Form)),
			R().QuestionToUser_007,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	Form.CurrentCompany = Object.Company;
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", 
																	True, DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("Our", True);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item) Export
	If Object.Partner <> Form.CurrentPartner Then
		ArrayOfCompanies = DocReconciliationStatementServer.GetCompaniesByPartner(Object.Partner);
		If ArrayOfCompanies.Count() = 1 Then
			Object.LegalName = ArrayOfCompanies[0];
			LegalNameOnChange(Object, Form, Undefined);
		Else
			Object.LegalName = Undefined;
			Form.CurrentLegalName = Object.LegalName;
			Form.CurrentPartner = Object.Partner; 
		EndIf;
		Return;
	EndIf;
	Form.CurrentPartner = Object.Partner; 
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Item) Export
	If Form.CurrentLegalName <> Object.LegalName
		And Object.Transactions.Count() Then
		ShowQueryBox(New NotifyDescription("TransactionsBeforeClearing", ThisObject, New Structure("Form", Form)),
			R().QuestionToUser_007,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	Form.CurrentPartner = Object.Partner; 
	Form.CurrentLegalName = Object.LegalName;
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.Partner);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure LegalNameTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		AdditionalParameters.Insert("Partner", Object.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

Procedure TransactionsBasisDocumentOnChange(Object, Form, Item) Export
	CurrentRow = Form.Items.Transactions.CurrentData;
	If CurrentRow <> Undefined Then
		BasisAttributeName = "";
		If Object.OperationType = PredefinedValue("Enum.CreditDebitNoteOperationsTypes.Payable") Then
			BasisAttributeName = "PartnerApTransactionsBasisDocument";
			CurrentRow.PartnerArTransactionsBasisDocument = Undefined;
		ElsIf Object.OperationType = PredefinedValue("Enum.CreditDebitNoteOperationsTypes.Receivable") Then
			BasisAttributeName = "PartnerArTransactionsBasisDocument";
			CurrentRow.PartnerApTransactionsBasisDocument = Undefined;
		Else
			Return;
		EndIf;
		CurrentRow.Partner = ServiceSystemServer.GetCompositeObjectAttribute(CurrentRow[BasisAttributeName], "Partner");
		CurrentRow.Agreement = ServiceSystemServer.GetCompositeObjectAttribute(CurrentRow[BasisAttributeName], "Agreement");
		CurrentRow.Currency = ServiceSystemServer.GetCompositeObjectAttribute(CurrentRow[BasisAttributeName], "Currency");
	EndIf;
EndProcedure

#Region ItemTransactionsPartner

Procedure TransactionsPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.LegalName) Then
		OpenSettings.FormParameters.Insert("Company", Object.LegalName);
		OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	OpenSettings.FillingData = New Structure();
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TransactionsPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.LegalName) Then
		AdditionalParameters.Insert("Company", Object.LegalName);
		AdditionalParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

Procedure OperationTypeOnChange(Object, Form, Item) Export
	If Form.CurrentOperationType <> Object.OperationType
		And Object.Transactions.Count() Then
		ShowQueryBox(New NotifyDescription("TransactionsBeforeClearing", ThisObject, New Structure("Form", Form)),
			R().QuestionToUser_007,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	Form.CurrentOperationType = Object.OperationType;
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure TransactionsBeforeClearing(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes
		And AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		Form.Object.Transactions.Clear();
		
		If Form.CurrentCompany <> Form.Object.Company Then
			Form.CurrentCompany = Form.Object.Company;
		EndIf;
		If Form.CurrentOperationType <> Form.Object.OperationType Then
			Form.CurrentOperationType = Form.Object.OperationType;
		EndIf;
		If Form.CurrentLegalName <> Form.Object.LegalName Then
			Form.CurrentLegalName = Form.Object.LegalName;
		EndIf;
		If Form.CurrentPartner <> Form.Object.Partner Then
			Form.CurrentPartner = Form.Object.Partner;
		EndIf;
	Else
		If AdditionalParameters.Property("Form") Then
			Form = AdditionalParameters.Form;
			Form.Object.Company = Form.CurrentCompany;
			Form.Object.OperationType = Form.CurrentOperationType;
			Form.Object.LegalName = Form.CurrentLegalName;
			Form.Object.Partner = Form.CurrentPartner;
			Notify("SetVisibility", Undefined, Form);
		EndIf;
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(Form.Object, Form);
	Notify("CallbackHandler", Undefined, Form);
EndProcedure

#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion


#Region GroupTitle

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

#EndRegion
