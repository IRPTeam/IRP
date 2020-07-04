#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	
EndProcedure

#EndRegion


#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
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

#Region ItemTransactionsPartner

Procedure TransactionsPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.Transactions.CurrentData.LegalName) Then
		OpenSettings.FormParameters.Insert("Company", Form.Items.Transactions.CurrentData.LegalName);
		OpenSettings.FormParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	OpenSettings.FillingData = New Structure();
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TransactionsPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.Transactions.CurrentData.LegalName) Then
		AdditionalParameters.Insert("Company", Form.Items.Transactions.CurrentData.LegalName);
		AdditionalParameters.Insert("FilterPartnersByCompanies", True);
	EndIf;
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemTransactionsLegalName

Procedure TransactionsLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Form.Items.Transactions.CurrentData.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Form.Items.Transactions.CurrentData.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Form.Items.Transactions.CurrentData.Partner);
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure TransactionsLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Form.Items.Transactions.CurrentData.Partner) Then
		AdditionalParameters.Insert("Partner", Form.Items.Transactions.CurrentData.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

Procedure OperationTypeOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#Region ItemPartnerApTransactionsBasisDocument

Procedure PartnerApTransactionsBasisDocumentOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure PartnerApTransactionsBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	
	StandardProcessing = False;
	
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Item", Item);
	NotifyParameters.Insert("ChoiceData", ChoiceData);
	NotifyParameters.Insert("StandardProcessing", StandardProcessing);
	NotifyDescription = New NotifyDescription("ApTransactionsBasisDocumentChoice", ThisObject, NotifyParameters);
	
	AttributeTypeDescription = DocInvoiceMatchServer.GetAttributeTypeDescription("PartnerApTransactionsBasisDocument");
	AttributeTypes = AttributeTypeDescription.Types();
	
	ListTypes = New ValueList();
	For Each TypeAttribute In AttributeTypes Do
		ListTypes.Add(TypeAttribute, TypeAttribute);
	EndDo;
	
	ListTypes.ShowChooseItem(NotifyDescription);
	
EndProcedure

Procedure ApTransactionsBasisDocumentChoice(Result, AdditionalParameters) Export
	
	If Result.Value = Type("DocumentRef.PurchaseInvoice") Then
		OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		OpenSettings.FormName = "Document.PurchaseInvoice.Form.ChoiceFormWithDept";
		
		DocumentsClient.PurchaseInvoiceStartChoice(AdditionalParameters.Object, AdditionalParameters.Form,
			AdditionalParameters.Item, AdditionalParameters.ChoiceData,
			AdditionalParameters.StandardProcessing, OpenSettings);
	ElsIf Result.Value = Type("DocumentRef.SalesReturn") Then
		OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		OpenSettings.FormName = "Document.SalesReturn.Form.ChoiceFormWithDept";
		
		DocumentsClient.SalesReturnStartChoice(AdditionalParameters.Object, AdditionalParameters.Form,
			AdditionalParameters.Item, AdditionalParameters.ChoiceData,
			AdditionalParameters.StandardProcessing, OpenSettings);
	Else
		Return;
	EndIf;
	
	
EndProcedure

#EndRegion


#Region ItemPartnerArTransactionsBasisDocument

Procedure PartnerArTransactionsBasisDocumentOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure PartnerArTransactionsBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	
	StandardProcessing = False;
	
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Item", Item);
	NotifyParameters.Insert("ChoiceData", ChoiceData);
	NotifyParameters.Insert("StandardProcessing", StandardProcessing);
	NotifyDescription = New NotifyDescription("ArTransactionsBasisDocumentChoice", ThisObject, NotifyParameters);
	
	AttributeTypeDescription = DocInvoiceMatchServer.GetAttributeTypeDescription("PartnerArTransactionsBasisDocument");
	AttributeTypes = AttributeTypeDescription.Types();
	
	ListTypes = New ValueList();
	For Each TypeAttribute In AttributeTypes Do
		ListTypes.Add(TypeAttribute, TypeAttribute);
	EndDo;
	
	ListTypes.ShowChooseItem(NotifyDescription);
	
EndProcedure

Procedure ArTransactionsBasisDocumentChoice(Result, AdditionalParameters) Export
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	If Result.Value = Type("DocumentRef.SalesInvoice") Then
		OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		OpenSettings.FormName = "Document.SalesInvoice.Form.ChoiceFormWithDept";
		DocumentsClient.SalesInvoiceStartChoice(AdditionalParameters.Object, AdditionalParameters.Form,
			AdditionalParameters.Item, AdditionalParameters.ChoiceData,
			AdditionalParameters.StandardProcessing, OpenSettings);
	ElsIf Result.Value = Type("DocumentRef.PurchaseReturn") Then
		OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		OpenSettings.FormName = "Document.PurchaseReturn.Form.ChoiceFormWithDept";
		DocumentsClient.PurchaseReturnStartChoice(AdditionalParameters.Object, AdditionalParameters.Form,
			AdditionalParameters.Item, AdditionalParameters.ChoiceData,
			AdditionalParameters.StandardProcessing, OpenSettings);
	Else
		Return;
	EndIf;
EndProcedure

#EndRegion


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