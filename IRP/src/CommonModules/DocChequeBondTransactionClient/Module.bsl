#Region FORM

Procedure OnOpen(Object, Form, Cancel) Export
	ViewClient_V2.OnOpen(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "ChequeBonds");
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True,
		DataCompositionComparisonType.Equal));
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

#Region CURRENCY

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "ChequeBonds");
EndProcedure

#EndRegion

//#Region STATUS
//	
//Procedure StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
//	StandardProcessing = False;
//	
//	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
//	
//	OpenSettings.FormName = "Catalog.ObjectStatuses.Form.ChoiceForm";
//	OpenSettings.ArrayOfFilters = New Array;
//	
//	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
//		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
//	Else
//		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
//	EndIf;
//	
//	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
//																	True, DataCompositionComparisonType.NotEqual));
//	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", 
//																Parent, DataCompositionComparisonType.InHierarchy));
//	
//	DocumentsClient.StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);																																
//EndProcedure						
//
//Procedure StatusEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
//	EditSettings = DocumentsClient.GetOpenSettingsStructure();
//
//	If Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
//		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondOutgoing");
//	Else
//		Parent = PredefinedValue("Catalog.ObjectStatuses.ChequeBondIncoming");
//	EndIf;
//	
//	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
//																		True, DataCompositionComparisonType.NotEqual));
//	EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Parent", 
//																Parent, DataCompositionComparisonType.InHierarchy));	
//	
//	DocumentsClient.StatusEditTextChange(Object, Form, Item, Text, StandardProcessing, EditSettings);
//EndProcedure
//
//#EndRegion

#Region CHEQUE_BONDS

Procedure ChequeBondsBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.ChequeBondsBeforeAddRow(Object, Form, Cancel, Clone);
EndProcedure

Procedure ChequeBondsAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.ChequeBondsAfterDeleteRow(Object, Form);
EndProcedure

#Region CHEQUE_BONDS_COLUMNS

#Region CHEQUE

Procedure ChequeBondsChequeOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsChequeOnChange(Object, Form, CurrentData);
	
	//Status, Amount, NewStatus, Currency
	//FillPropertyValues(CurrentData, DocChequeBondTransactionServer.GetChequeInfo(Object.Ref, CurrentData.Cheque));
	// CleanPaymentList()
EndProcedure

//Procedure CleanPaymentList(Object, Form) Export
//	CurrentData = Form.Items.ChequeBonds.CurrentData;
//	If CurrentData = Undefined Then
//		Return;
//	EndIf;
//	
//	DependentLines = Object.PaymentList.FindRows(New Structure("Key", CurrentData.Key));
//	
//	If CatAgreementsServer.GetAgreementInfo(CurrentData.Agreement).Type = PredefinedValue("Enum.ApArPostingDetail.ByDocuments") Then
//		For Each DependentLine In DependentLines Do
//			Object.PaymentList.Delete(DependentLine);
//			Return;
//		EndDo;
//	EndIf;
//	
//	ChequeType = ServiceSystemServer.GetObjectAttribute(CurrentData.Cheque, "Type");
//	If ChequeType = PredefinedValue("Enum.ChequeBondTypes.PartnerCheque") Then
//		ColumnName = "PartnerArBasisDocument";
//	ElsIf ChequeType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
//		ColumnName = "PartnerApBasisDocument"; 
//	Else
//		For Each DependentLine In DependentLines Do
//			Object.PaymentList.Delete(DependentLine);
//			Return;
//		EndDo;
//	EndIf;
//	
//	ControlDocuments = New Array();
//	For Each DependentLine In DependentLines Do
//		If ValueIsFilled(DependentLine[ColumnName]) Then
//			ControlDocuments.Add(DependentLine[ColumnName]);
//		Else
//			Object.PaymentList.Delete(DependentLine);
//		EndIf;
//	EndDo;
//	
//	If ControlDocuments.Count() = 0 Then
//		Return;
//	EndIf;
//	
//	ControlStructure = New Structure(, );
//	ControlStructure.Insert("Company", Object.Company);
//	ControlStructure.Insert("Partner", Form.CurrentPartner);
//	ControlStructure.Insert("LegalName", Form.CurrentLegalName);
//	ControlStructure.Insert("Agreement", Form.CurrentAgreement);
//	ControlStructure.Insert("ControlDocument", ControlDocuments);
//	ControlStructure.Insert("EndDate", Object.Date - 1);
//	ControlStructure.Insert("UseCurrencyFilter", ValueIsFilled(Object.Currency));
//	ControlStructure.Insert("Currency", Object.Currency);
//	
//	InvalidDocuments = DocChequeBondTransactionServer.InvalidDocuments(ControlStructure);
//	
//	For Each DependentLine In DependentLines Do
//		If InvalidDocuments.Find(DependentLine[ColumnName]) = Undefined Then
//			Continue;
//		Else
//			Object.PaymentList.Delete(DependentLine);
//		EndIf;
//	EndDo;
//
//EndProcedure

Procedure ChequeBondsChequeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
		
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Currency", Object.Currency, DataCompositionComparisonType.Equal));
	
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Object.Currency) Then
		OpenSettings.FormParameters.Insert("Currency", Object.Currency);
		OpenSettings.FormParameters.Insert("FilterByCurrency", True);
	EndIf;
	
	OpenSettings.FillingData = New Structure("Currency", Object.Currency);
	OpenSettings.FormName = "Catalog.ChequeBonds.ChoiceForm";
	
	DocumentsClient.OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeBondsChequeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	StandardProcessing = False;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	
	AdditionalParameters = New Structure();
	If ValueIsFilled(Object.Currency) Then
		AdditionalParameters.Insert("Currency", Object.Currency);
		AdditionalParameters.Insert("FilterByCurrency", True);
	EndIf;
	
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region NEW_STATUS

Procedure ChequeBondsNewStatusOnChange(Object, Form, Item, CurrentData = Undefined) Export
	ViewClient_V2.ChequeBondsNewStatusOnChange(Object, Form, CurrentData);
EndProcedure

Procedure ChequeBondsNewStatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ChoiceData = New ValueList();
	For Each StatusRef In ObjectStatusesServer.GetAvailableStatusesByCheque(Object.Ref, CurrentData.Cheque) Do
		ChoiceData.Add(StatusRef, String(StatusRef));
	EndDo;
EndProcedure

Procedure ChequeBondsNewStatusEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	StandardProcessing = False;
	
	CurrentData = Form.Items.ChequeBonds.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(Text) Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Filter_RefInList", True);
	AdditionalParameters.Insert("RefList", ObjectStatusesServer.GetAvailableStatusesByCheque(Object.Ref, CurrentData.Cheque));
	
	ArrayOfFilteredStatusRefs = ObjectStatusesServer.GetObjectStatusesChoiceDataTable(Text, ArrayOfFilters, AdditionalParameters);
	If Not ArrayOfFilteredStatusRefs.Count() Then
		Return;
	EndIf;
	
	ObjectStatusesClient.StatusEditTextChange(Form, Object, ArrayOfFilters, AdditionalParameters, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#EndRegion
