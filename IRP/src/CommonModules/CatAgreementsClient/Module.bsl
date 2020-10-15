#Region FormEvents

Procedure ListBeforeAddRow(Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	CommonFormActions.DynamicListBeforeAddRow(
				Form, Item, Cancel, Clone, Parent, IsFolder, Parameter, "Catalog.Agreements.ObjectForm");
EndProcedure

#EndRegion

#Region ItemCompany

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData,  StandardProcessing) Export
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

#Region ItemLegalName
Procedure LegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", 
																		False, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Our", False);
	If ValueIsFilled(Object.Partner) Then
		OpenSettings.FillingData.Insert("Partner", Object.Partner);
	EndIf;
	
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure LegalNameTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", False, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Partner) Then
		AdditionalParameters.Insert("Partner", Object.Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemPartnerSegment

Procedure PartnerSegmentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Managers", 
																		False, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure("Managers", False);
	
	DocumentsClient.PartnerSegmentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerSegmentTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Managers", False, ComparisonType.Equal));
	DocumentsClient.PartnerSegmentEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region ItemTumblers

Procedure TypeOnChange(Object, Form, Item) Export
	If Object.Type <> PredefinedValue("Enum.AgreementTypes.Customer") Then
		Object.UseCreditLimit = False;
		Object.CreditLimitAmount = 0;
		Object.PaymentTerm = Undefined;
	EndIf;
	CatAgreementsClientServer.SetVisible(Object, Form);
EndProcedure

Procedure ApArPostingDetailOnChange(Object, Form, Item) Export
	If Object.ApArPostingDetail <> PredefinedValue("Enum.ApArPostingDetail.ByStandardAgreement") Then
		Object.StandardAgreement = Undefined;
	EndIf;
	If Object.ApArPostingDetail <> PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
		Object.PaymentTerm = Undefined;
	EndIf;
	CatAgreementsClientServer.SetVisible(Object, Form);
EndProcedure

Procedure KindOnChange(Object, Form, Item) Export
	If Object.Kind = PredefinedValue("Enum.AgreementKinds.Standard") Then
		Object.ApArPostingDetail = PredefinedValue("Enum.ApArPostingDetail.ByAgreements");
		Object.StandardAgreement = Undefined;
		Object.PriceType = Undefined;
		Object.PaymentTerm = Undefined;
	EndIf;
	CatAgreementsClientServer.SetVisible(Object, Form);
EndProcedure

Procedure UseCreditLimitOnChange(Object, Form, Item) Export
	If Not Object.UseCreditLimit Then
		Object.CreditLimitAmount = 0;
	EndIf;
	CatAgreementsClientServer.SetVisible(Object, Form);
EndProcedure

#EndRegion

