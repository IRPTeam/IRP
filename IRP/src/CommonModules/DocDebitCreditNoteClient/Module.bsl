#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "");
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", False, DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, DataCompositionComparisonType.Equal));
	OpenSettings.FillingData = New Structure("OurCompany", True);
	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region SEND_DEBT_TYPE

Procedure SendDebtTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.SendDebtTypeOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region SEND_PARTNER

Procedure SendPartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.SendPartnerOnChange(Object, Form, "");
EndProcedure

Procedure SendPartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SendPartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region SEND_LEGAL_NAME

Procedure SendLegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.SendLegalNameOnChange(Object, Form, "");
EndProcedure

Procedure SendLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	
	If ValueIsFilled(Object.SendPartner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.SendPartner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.SendPartner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SendLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.SendPartner) Then
		AdditionalParameters.Insert("Partner", Object.SendPartner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region SEND_AGREEMENT

Procedure SendAgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.SendAgreementOnChange(Object, Form, "");
EndProcedure

Procedure SendAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
		
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", Object.SendPartner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"   , Object.SendPartner);
	OpenSettings.FillingData.Insert("LegalName" , Object.SendLegalName);
	OpenSettings.FillingData.Insert("Company"   , Object.Company);
	OpenSettings.FillingData.Insert("Type"      , ModelServer_V2.GetAgreementTypeByDebtType(Object.SendDebtType));
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SendAgreementEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner"     , Object.SendPartner);
	AdditionalParameters.Insert("Type"        , ModelServer_V2.GetAgreementTypeByDebtType(Object.SendDebtType));
	
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region RECEIVE_DEBT_TYPE

Procedure ReceiveDebtTypeOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveDebtTypeOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region RECEIVE_PARTNER

Procedure ReceivePartnerOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceivePartnerOnChange(Object, Form, "");
EndProcedure

Procedure ReceivePartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ReceivePartnerEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

#EndRegion

#Region RECEIVE_LEGAL_NAME

Procedure ReceiveLegalNameOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveLegalNameOnChange(Object, Form, "");
EndProcedure

Procedure ReceiveLegalNameStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	
	If ValueIsFilled(Object.ReceivePartner) Then
		OpenSettings.FormParameters.Insert("Partner", Object.ReceivePartner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Object.ReceivePartner);

	DocumentsClient.CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ReceiveLegalNameEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.ReceivePartner) Then
		AdditionalParameters.Insert("Partner", Object.ReceivePartner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	DocumentsClient.CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region RECEIVE_AGREEMENT

Procedure ReceiveAgreementOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveAgreementOnChange(Object, Form, "");
EndProcedure

Procedure ReceiveAgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", Object.ReceivePartner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"   , Object.ReceivePartner);
	OpenSettings.FillingData.Insert("LegalName" , Object.ReceiveLegalName);
	OpenSettings.FillingData.Insert("Company"   , Object.Company);
	OpenSettings.FillingData.Insert("Type"      , ModelServer_V2.GetAgreementTypeByDebtType(Object.ReceiveDebtType));
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ReceiveAgreementEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner"     , Object.ReceivePartner);
	AdditionalParameters.Insert("Type"        , ModelServer_V2.GetAgreementTypeByDebtType(Object.ReceiveDebtType));
	
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

Procedure SendCurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.SendCurrencyOnChange(Object, Form);
EndProcedure

Procedure ReceiveCurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveCurrencyOnChange(Object, Form);
EndProcedure

Procedure SendAmountOnChange(Object, Form, Item) Export
	ViewClient_V2.SendAmountOnChange(Object, Form);
EndProcedure

Procedure ReceiveAmountOnChange(Object, Form, Item) Export
	ViewClient_V2.ReceiveAmountOnChange(Object, Form);
EndProcedure

Procedure ReceiveBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	
	Notify = New CallbackDescription("ReceiveBasisDocumentStartChoiceEnd", ThisObject, NotifyParameters);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Partner", Object.ReceivePartner);
	FormParameters.Insert("LegalName", Object.ReceiveLegalName);
	FormParameters.Insert("Agreement", Object.ReceiveAgreement);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("IsReceiver", True);
	FormParameters.Insert("Document", Object.ReceiveBasisDocument);
		
	OpenForm("CommonForm.ChoiceTransactionBasis", FormParameters, Form,,,,Notify,FormWindowOpeningMode.LockOwnerWindow); 
EndProcedure

Procedure ReceiveBasisDocumentStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = NotifyParameters.Object;
	Object.ReceiveBasisDocument = Result.BasisDocument;
EndProcedure

Procedure SendBasisDocumentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	
	Notify = New CallbackDescription("SendBasisDocumentStartChoiceEnd", ThisObject, NotifyParameters);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Partner", Object.SendPartner);
	FormParameters.Insert("LegalName", Object.SendLegalName);
	FormParameters.Insert("Agreement", Object.SendAgreement);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("IsSender", True);
	FormParameters.Insert("Document", Object.SendBasisDocument);
		
	OpenForm("CommonForm.ChoiceTransactionBasis", FormParameters, Form,,,,Notify,FormWindowOpeningMode.LockOwnerWindow); 
EndProcedure

Procedure SendBasisDocumentStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = NotifyParameters.Object;
	Object.SendBasisDocument = Result.BasisDocument;
EndProcedure

Procedure ReceiveOrderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	
	Notify = New CallbackDescription("ReceiveOrderStartChoiceEnd", ThisObject, NotifyParameters);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Partner", Object.ReceivePartner);
	FormParameters.Insert("LegalName", Object.ReceiveLegalName);
	FormParameters.Insert("Agreement", Object.ReceiveAgreement);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("IsReceiver", True);
	FormParameters.Insert("IsOrder", True);
	FormParameters.Insert("Document", Object.ReceiveOrder);
		
	OpenForm("CommonForm.ChoiceTransactionBasis", FormParameters, Form,,,,Notify,FormWindowOpeningMode.LockOwnerWindow); 
EndProcedure

Procedure ReceiveOrderStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = NotifyParameters.Object;
	Object.ReceiveOrder = Result.BasisDocument;
EndProcedure

Procedure SendOrderStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	
	Notify = New CallbackDescription("SendOrderStartChoiceEnd", ThisObject, NotifyParameters);
	FormParameters = New Structure();
	FormParameters.Insert("Company", Object.Company);
	FormParameters.Insert("Partner", Object.SendPartner);
	FormParameters.Insert("LegalName", Object.SendLegalName);
	FormParameters.Insert("Agreement", Object.SendAgreement);
	FormParameters.Insert("Ref", Object.Ref);
	FormParameters.Insert("IsSender", True);
	FormParameters.Insert("IsOrder", True);
	FormParameters.Insert("Document", Object.SendOrder);
		
	OpenForm("CommonForm.ChoiceTransactionBasis", FormParameters, Form,,,,Notify,FormWindowOpeningMode.LockOwnerWindow); 
EndProcedure

Procedure SendOrderStartChoiceEnd(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	Object = NotifyParameters.Object;
	Object.SendOrder = Result.BasisDocument;
EndProcedure
