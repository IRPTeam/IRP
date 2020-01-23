#Region FormEvents

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	Settings = New Structure;
	Settings.Insert("UpdateInfoString");
	If AddInfo <> Undefined And AddInfo.Property("RemovedActions") Then
		For Each RemovedAction In AddInfo.RemovedActions Do
			Settings.Delete(RemovedAction);
		EndDo;
	EndIf;
	
	CalculationStringsClientServer.CalculateItemsRows(Object, Form, Object.ItemList, Settings);
	
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	
	If Not ValueIsFilled(Object.Ref) Then
		DocSalesReturnClient.ItemListOnChange(Object, Form);
		CompanyOnChange(Object, Form, Undefined);
	EndIf;
	
EndProcedure

Procedure AfterWrite(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure AgreementOnChange(Object, Form, Item) Export
	CurrentValuesStructure = DocumentsClient.CreateCurrentValuesStructure(Object, "Currency, Company");
	CurrentValuesStructure.Insert("Store", Form.Store);
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	Object.Currency = AgreementInfo.Currency;
	If ValueIsFilled(AgreementInfo.Company) Then
		Object.Company = AgreementInfo.Company;
	EndIf;
	Form.Store = AgreementInfo.Store;
	
	If Object.Company <> CurrentValuesStructure.Company Then
		DocSalesReturnClient.CompanyOnChange(Object, Form, Item);
	EndIf;
	If Form.Store <> CurrentValuesStructure.Store Then
		StoreOnChange(Object, Form, Undefined);
	EndIf;
	
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True,
																	DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
																	PredefinedValue("Enum.AgreementTypes.Customer"), 
																	DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
																	PredefinedValue("Enum.AgreementKinds.Standard"), 
																	DataCompositionComparisonType.NotEqual));
								
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner", Object.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner", True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments", True);
	OpenSettings.FormParameters.Insert("EndOfUseDate", Object.Date);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate", True);
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner", Object.Partner);
	OpenSettings.FillingData.Insert("LegalName", Object.LegalName);
	OpenSettings.FillingData.Insert("Company", Object.Company);
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Customer"));
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
																	PredefinedValue("Enum.AgreementTypes.Customer"), 
																	ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
																	PredefinedValue("Enum.AgreementKinds.Standard"), 
																	ComparisonType.NotEqual));						
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate", True);
	AdditionalParameters.Insert("IncludeFilterByPartner", True);
	AdditionalParameters.Insert("IncludePartnerSegments", True);
	AdditionalParameters.Insert("EndOfUseDate", Object.Date);
	AdditionalParameters.Insert("Partner", Object.Partner);
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing,
				ArrayOfFilters, AdditionalParameters);
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

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item) Export
	CurrentValuesStructure = DocumentsClient.CreateCurrentValuesStructure(Object, "Agreement, LegalName");
	
	If Object.Partner <> Form.CurrentPartner Then
		Object.LegalName = DocSalesReturnServer.GetLegalNameByPartner(Object.Partner, Object.LegalName);
		Object.Agreement = DocSalesReturnServer.GetAgreementByPartner(Object.Partner, Object.Agreement);
	EndIf;
	If CurrentValuesStructure.Agreement <> Object.Agreement Then
		DocSalesReturnClient.AgreementOnChange(Object, Form, Undefined);
	EndIf;
	Form.CurrentPartner = Object.Partner;
	
	// GroupTitle 
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer"	, True, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Filter", New Structure("Customer" , True));
	OpenSettings.FillingData = New Structure("Customer", True);
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer"	, True, ComparisonType.Equal));
	AdditionalParameters = New Structure();
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Item) Export
	// GroupTitle 
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

#Region Store

Procedure ChangeItemListStore(ItemList, Store) Export
	For Each Row In ItemList Do
		If Row.Store <> Store Then
			Row.Store = Store;
		EndIf;
	EndDo;
EndProcedure

Procedure StoreOnChange(Object, Form, Item) Export
	
	If Not ValueIsFilled(Form.Store) Then
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		Form.Store = DocumentsServer.GetCurrentStore(ObjectData);
		
	EndIf;
	
	If Form.Store <> Form.StoreBeforeChange
		And Object.ItemList.Count() Then
		ShowQueryBox(New NotifyDescription("StoreOnChangeContinue", ThisObject, New Structure("Form, Object", Form, Object)),
			R().QuestionToUser_005,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocumentsClient.SetCurrentStore(Object, Form, Form.Store);
	DocSalesReturnClient.ChangeItemListStore(Object.ItemList, Form.Store);
EndProcedure

Procedure StoreOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes
		And AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		For Each Row In Form.Object.ItemList Do
			Row.Store = Form.Store;
		EndDo;
		Form.Items.Store.InputHint = "";
		Form.StoreBeforeChange = Form.Store;
		DocumentsClient.SetCurrentStore(AdditionalParameters.Object, Form, Form.Store);
	ElsIf AdditionalParameters.Property("Form") Then
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, AdditionalParameters.Object);
		DocumentsClientServer.FillStores(ObjectData, AdditionalParameters.Form);
	Else
		Return;
	EndIf;
EndProcedure

#EndRegion


#Region GroupTitle

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLalelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLalelClick(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(Object, Form, False);
EndProcedure

#EndRegion

#EndRegion

#Region ItemDescription

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

#EndRegion

#Region Item

Procedure ItemListItemOnChange(Object, Form, Item = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentRow.ItemKey = CatItemsServer.GetItemKeyByItem(CurrentRow.Item);
	If ValueIsFilled(CurrentRow.ItemKey)
		And ServiceSystemServer.GetObjectAttribute(CurrentRow.ItemKey, "Item") <> CurrentRow.Item Then
		CurrentRow.ItemKey = Undefined;
	EndIf;
	
	CalculationSettings = New Structure();
	CalculationSettings.Insert("UpdateUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object,
		CurrentRow,
		CalculationSettings);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

Procedure ItemListOnActivateRow(Object, Form, Item) Export
	If Form.Items.ItemList.CurrentData = Undefined Then
		Return;
	EndIf;
	
	CurrentRow = Form.Items.ItemList.CurrentData;
	
	If ValueIsFilled(CurrentRow.Store)
		And CurrentRow.Store <> Form.CurrentStore Then
		DocumentsClient.SetCurrentStore(Object, Form, CurrentRow.Store);
	EndIf;
EndProcedure

Procedure ItemListOnChange(Object, Form, Item = Undefined, CalculationSettings = Undefined) Export
	
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
	
	If Form.Items.ItemList.CurrentItem <> Undefined
		AND Form.Items.ItemList.CurrentItem.Name = "ItemListStore" Then
		DocumentsClient.SetCurrentStore(Object, Form, Form.Items.ItemList.CurrentData.Store);
	EndIf;
	
	If Form.Items.ItemList.CurrentData <> Undefined Then
		DocumentsClient.FillUnfilledStoreInRow(Object, Form.Items.ItemList, Form.CurrentStore);
	EndIf;
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, Object);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	If CalculationSettings = Undefined Then
		CalculationSettings = CalculationStringsClientServer.GetCalculationSettings();
	EndIf;
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		Object.ItemList,
		CalculationSettings);
	Form.TaxAndOffersCalculated = False;
	
EndProcedure

Procedure PickupItemsEnd(Result, AdditionalParameters) Export
	If NOT ValueIsFilled(Result)
		OR Not AdditionalParameters.Property("Object")
		OR Not AdditionalParameters.Property("Form") Then
		Return;
	EndIf;
	
	FilterString = "Item, ItemKey, Unit";
	FilterStructure = New Structure(FilterString);
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(AdditionalParameters.Object.Agreement);
	CalculationSettings = New Structure();
	CalculationSettings.Insert("ChangePriceType",
		New Structure("Period, PriceType",
			AdditionalParameters.Object.Date,
			AgreementInfo.PriceType));
	
	For Each ResultElement In Result Do
		FillPropertyValues(FilterStructure, ResultElement);
		ExistingRows = AdditionalParameters.Object.ItemList.FindRows(FilterStructure);
		If ExistingRows.Count() Then
			Row = ExistingRows[0];
		Else
			Row = AdditionalParameters.Object.ItemList.Add();
			FillPropertyValues(Row, ResultElement, FilterString);
			Row.Store = AdditionalParameters.Form.Store;
		EndIf;
		Row.Quantity = Row.Quantity + ResultElement.Quantity;
		CalculationStringsClientServer.CalculateItemsRow(AdditionalParameters.Object,
			Row,
			CalculationSettings);
	EndDo;
	ItemListOnChange(AdditionalParameters.Object, AdditionalParameters.Form, Undefined, Undefined);
EndProcedure

Procedure SearchByBarcode(Command, Object, Form) Export
	DocumentsClient.SearchByBarcode(Command, Object, Form, ThisObject);
EndProcedure

