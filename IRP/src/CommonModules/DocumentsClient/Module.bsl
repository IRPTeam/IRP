#Region FormEvents

Procedure OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	//@skip-check use-non-recommended-method
	ChoiceForm = GetForm(OpenSettings.FormName, OpenSettings.FormParameters, Item, Form.UUID, , Form.URL);
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
	EndIf;

	For Each Filter In OpenSettings.ArrayOfFilters Do
		AddFilterToChoiceForm(ChoiceForm, Filter.FieldName, Filter.Value, Filter.ComparisonType);
	EndDo;
	ChoiceForm.Open();
EndProcedure

Procedure OpenListForm(FormName, ArrayOfFilters, FormParameters, Source = Undefined, Uniqueness = Undefined,
	Window = Undefined, URL = Undefined) Export

	//@skip-check use-non-recommended-method
	ListForm = GetForm(FormName, FormParameters, Source, Uniqueness, Window, URL);

	For Each Filter In ArrayOfFilters Do
		AddFilterToChoiceForm(ListForm, Filter.FieldName, Filter.Value, Filter.ComparisonType);
	EndDo;

	ListForm.Open();
EndProcedure

#EndRegion

#Region ItemPartner

Procedure PartnerStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, TransactionType) Export
	PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(TransactionType);
	
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	
	If ValueIsFilled(PartnerType) Then
		OpenSettings.FormParameters.Insert("Filter", New Structure(PartnerType, True));
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(PartnerType, True, DataCompositionComparisonType.Equal));
		OpenSettings.FillingData = New Structure(PartnerType, True);
	EndIf;
	
	PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Partners.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			DataCompositionComparisonType.NotEqual));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
	EndIf;

	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "Partner");

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, TransactionType) Export
	PartnerType = ModelServer_V2.GetPartnerTypeByTransactionType(TransactionType);
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	If ValueIsFilled(PartnerType) Then
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(PartnerType, True, ComparisonType.Equal));
	EndIf;
	AdditionalParameters = New Structure();
	PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

Procedure PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export

	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	EndIf;

	If AdditionalParameters = Undefined Then
		AdditionalParameters = New Structure();
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter",
		DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters",
		DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region PartnerSegment

Procedure PartnerSegmentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.PartnerSegments.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			DataCompositionComparisonType.NotEqual));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
	EndIf;

	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerSegmentEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined) Export

	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter",
		DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure AgreementStartChoice_TransactionTypeFilter(Object, Form, Item, ChoiceData, StandardProcessing, TransactionType, Parameters = Undefined) Export
	CompanyIsSet = True;
	DateIsSet    = True;
	If Parameters <> Undefined Then
		If Parameters.Property("Company") Then
			Company = Parameters.Company;
		Else
			Company = Object.Company;
		EndIf;
		
		If Parameters.Property("Partner") Then
			Partner = Parameters.Partner;
		Else
			Partner = Object.Partner;
		EndIf;
		
		If Parameters.Property("LegalName") Then
			LegalName = Parameters.LegalName;
		Else
			LegalName = Object.LegalName;
		EndIf;
	Else
		If CommonFunctionsClientServer.ObjectHasProperty(Object, "Company") Then
			Company = Object.Company;
		Else
			Company = Undefined;
			CompanyIsSet = False;
		EndIf;
		
		Partner   = Object.Partner;
		LegalName = Object.LegalName;
	EndIf;

	If CommonFunctionsClientServer.ObjectHasProperty(Object, "Date") Then
		Date = Object.Date;
	Else
		Date = Undefined;
		DateIsSet = False;
	EndIf;
	
	AgreementType = ModelServer_V2.GetAgreementTypeByTransactionType(TransactionType);
	
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType, DataCompositionComparisonType.Equal));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner"                     , Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner"      , True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments"      , True);
	If DateIsSet Then
		OpenSettings.FormParameters.Insert("EndOfUseDate", Date);
	EndIf;
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate" , True);
	
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"   , Partner);
	OpenSettings.FillingData.Insert("LegalName" , LegalName);
	If CompanyIsSet Then
		OpenSettings.FillingData.Insert("Company"   , Company);
	EndIf;
	OpenSettings.FillingData.Insert("Type"      , AgreementType);

	AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Agreements.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			DataCompositionComparisonType.NotEqual));
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue(
			"Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));

	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
	EndIf;

	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "Agreement");

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange_TransactionTypeFilter(Object, Form, Item, Text, StandardProcessing, TransactionType, Parameters = Undefined) Export
	If Parameters <> Undefined Then
		If Parameters.Property("Partner") Then
			Partner = Parameters.Partner;
		Else
			Partner = Object.Partner;
		EndIf;
	Else
		Partner   = Object.Partner;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "Date") Then
		Date = Object.Date;
		DateIsSet = True;
	Else
		Date = Undefined;
		DateIsSet = False;
	EndIf;
	
	AgreementType = ModelServer_V2.GetAgreementTypeByTransactionType(TransactionType);
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", AgreementType,ComparisonType.Equal));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"),ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate" , True);
	AdditionalParameters.Insert("IncludeFilterByPartner"      , True);
	AdditionalParameters.Insert("IncludePartnerSegments"      , True);
	If DateIsSet Then
		AdditionalParameters.Insert("EndOfUseDate", Date);
	EndIf;
	AdditionalParameters.Insert("Partner"                     , Partner);
	AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

Procedure AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined,
	AdditionalParameters = Undefined) Export

	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	EndIf;

	If AdditionalParameters = Undefined Then
		AdditionalParameters = New Structure();
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter",
		DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters",
		DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region ItemCompany

Procedure LegalNameStartChoice_PartnerFilter(Object, Form, Item, ChoiceData, StandardProcessing, Partner) Export
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	If ValueIsFilled(Partner) Then
		OpenSettings.FormParameters.Insert("Partner", Partner);
		OpenSettings.FormParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	OpenSettings.FillingData = New Structure("Partner", Partner);

	CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Companies.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			DataCompositionComparisonType.NotEqual));
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True,
			DataCompositionComparisonType.Equal));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
	EndIf;

	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "LegalName");

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure LegalNameTextChange_PartnerFilter(Object, Form, Item, Text, StandardProcessing, Partner) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	If ValueIsFilled(Partner) Then
		AdditionalParameters.Insert("Partner", Partner);
		AdditionalParameters.Insert("FilterByPartnerHierarchy", True);
	EndIf;
	CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export
	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
	EndIf;

	If AdditionalParameters = Undefined Then
		AdditionalParameters = New Structure();
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

Procedure SerialLotNumbersEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined,
	AdditionalParameters = Undefined) Export

	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, ComparisonType.Equal));
	EndIf;

	If AdditionalParameters = Undefined Then
		AdditionalParameters = New Structure();
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

Procedure SourceOfOriginsEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined,
	AdditionalParameters = Undefined) Export

	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, ComparisonType.Equal));
	EndIf;

	If AdditionalParameters = Undefined Then
		AdditionalParameters = New Structure();
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter"   , DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters" , DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region Status

Procedure StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.ObjectStatuses.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			DataCompositionComparisonType.NotEqual));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
	EndIf;

	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure StatusEditTextChange(Object, Form, Item, Text, StandardProcessing, EditSettings = Undefined) Export
	If EditSettings = Undefined Then
		EditSettings = GetOpenSettingsStructure();
	EndIf;

	If EditSettings.ArrayOfFilters = Undefined Then
		EditSettings.ArrayOfFilters = New Array();
		EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			ComparisonType.NotEqual));
		EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True,
			ComparisonType.Equal));
	EndIf;

	If EditSettings.AdditionalParameters = Undefined Then
		EditSettings.AdditionalParameters = New Structure();
	EndIf;

	EditSettings.ArrayOfChoiceParameters = New Array();
	EditSettings.ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter",
		DocumentsServer.SerializeArrayOfFilters(EditSettings.ArrayOfFilters)));
	EditSettings.ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters",
		DocumentsServer.SerializeArrayOfFilters(EditSettings.AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(EditSettings);
EndProcedure

#EndRegion

#Region Item

Function GetOpenSettingsForSelectItemWithoutServiceFilter(OpenSettings = Undefined, AddInfo = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
	EndIf;

	NotService = DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"),
		DataCompositionComparisonType.NotEqual);
	OpenSettings.ArrayOfFilters.Add(NotService);
	Return OpenSettings;
EndFunction

Procedure ItemListItemStartChoice_IsNotServiceFilter(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
		PredefinedValue("Enum.ItemTypes.Service"), DataCompositionComparisonType.NotEqual));

	ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export

	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Items.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
	EndIf;

	DeletionMarkItem = DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual);
	OpenSettings.ArrayOfFilters.Add(DeletionMarkItem);

	OpenSettings.FormParameters = New Structure();
	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "Item");

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Function GetArrayOfFiltersForSelectItemWithoutServiceFilter(AddInfo = Undefined) Export
	ArrayOfFilters = New Array();
	DeletionMarkItem = DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual);
	ArrayOfFilters.Add(DeletionMarkItem);
	NotService = DocumentsClientServer.CreateFilterItem("ItemType.Type", PredefinedValue("Enum.ItemTypes.Service"),
		ComparisonType.NotEqual);
	ArrayOfFilters.Add(NotService);
	Return ArrayOfFilters;
EndFunction

Procedure ItemListItemEditTextChange_IsNotServiceFilter(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
		PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.NotEqual));
	ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined) Export
	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		DeletionMarkItem = DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual);
		ArrayOfFilters.Add(DeletionMarkItem);
	EndIf;

	ArrayOfChoiceParameters = New Array();
	SerializedArrayOfFilters = DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters);
	CustomSearchFilter = New ChoiceParameter("Filter.CustomSearchFilter", SerializedArrayOfFilters);
	ArrayOfChoiceParameters.Add(CustomSearchFilter);
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure ChangeTitleCollapse(Object, Form, TitleVisible = True) Export
	Form.Items.GroupTitleCollapsed.Visible = Not TitleVisible;
	Form.Items.GroupTitleUncollapsed.Visible = TitleVisible;
	Form.Items.GroupTitleItems.Visible = TitleVisible;
EndProcedure

#EndRegion

#Region Commands

Procedure SearchByBarcodeWithPriceType(Barcode, Object, Form) Export
	PriceType = PredefinedValue("Catalog.PriceKeys.EmptyRef");
	If ValueIsFilled(Object.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		PriceType = AgreementInfo.PriceType;
	EndIf;
	SearchByBarcode(Barcode, Object, Form, , PriceType);
EndProcedure

// Search by barcode.
// 
// Parameters:
//  Barcode - String -Barcode
//  Object - See Document.SalesInvoice.Form.DocumentForm.Object
//  Form - See Document.SalesInvoice.Form.DocumentForm
//  ReturnCallToModule - Undefined - Document client module
//  PriceType - Undefined, CatalogRef.PriceKeys - Price type
//  Settings - See BarcodeClient.GetBarcodeSettings
Procedure SearchByBarcode(Barcode, Object, Form, ReturnCallToModule = Undefined, PriceType = Undefined, Settings = Undefined) Export
	If Not Form.Items.Find("ItemList") = Undefined Then
		Form.CurrentItem = Form.Items.ItemList;
	EndIf;
	
	If Settings = Undefined Then
		Settings = BarcodeClient.GetBarcodeSettings();
	EndIf;
	
	Settings.Form = Form;
	Settings.Object = Object;

	Settings.ServerSettings.PriceType = PriceType;
	
	// Check, if call from document, and document is new
	If Object.Property("Ref") And Not Object.Ref.IsEmpty() Then
		Settings.ServerSettings.PricePeriod = Object.Date;
	EndIf;
	
	Settings.ReturnCallToModule = ?(ReturnCallToModule = Undefined, ThisObject, ReturnCallToModule);

	BarcodeClient.SearchByBarcode(Barcode, Settings);
EndProcedure

// Search by barcode end.
// 
// Parameters:
//  Result - Structure - Result
//  Parameters - See BarcodeClient.GetBarcodeSettings
Procedure SearchByBarcodeEnd(Result, Parameters) Export
	If Result.FoundedItems.Count() Then
		Parameters.ReturnCallToModule.PickupItemsEnd(Result.FoundedItems, Parameters);
	EndIf;
	For Each BarcodeEmpty In Result.Barcodes Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, BarcodeEmpty));
	EndDo;
EndProcedure

Async Procedure OpenScanForm(Object, Form, Module) Export
	
	If Object.Ref.isEmpty() Then
#If WebClient Then
		Form.Write();
#Else				
		Answer = Await DoQueryBoxAsync(R().InfoMessage_004, QuestionDialogMode.OKCancel);
		If Answer = DialogReturnCode.OK Then 
			Form.Write();
		Else
			Return;
		EndIf;
#EndIf
	EndIf;
	
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyDescription = New NotifyDescription("OpenScanFormEnd", ThisObject, NotifyParameters);
	OpenFormParameters = New Structure;
	OpenFormParameters.Insert("Basis", Object.Ref);
	OpenForm("DataProcessor.ScanBarcode.Form.Form", OpenFormParameters, Form, , , , NotifyDescription, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure OpenScanFormEnd(Result, AdditionalParameters) Export
	If Not ValueIsFilled(Result) 
		Or Not AdditionalParameters.Property("Object") 
		Or Not AdditionalParameters.Property("Form") Then
			
		Return;
	EndIf;
EndProcedure

#EndRegion

#Region Common

Function CreateFilterItem(FieldName, Value, ComparisonType) Export
	FilterStructure = New Structure();
	FilterStructure.Insert("FieldName", FieldName);
	FilterStructure.Insert("Value", Value);
	FilterStructure.Insert("ComparisonType", ComparisonType);
	Return FilterStructure;
EndFunction

Procedure AddFilterToChoiceForm(ChoiceForm, PathToField, Value, ComparisonType)
	FilterItem = ChoiceForm.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.LeftValue = New DataCompositionField(PathToField);
	FilterItem.RightValue = Value;
	FilterItem.ComparisonType = ComparisonType;
EndProcedure

#EndRegion

#Region DocumentsStartChoice

Procedure SerialLotNumberStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.SerialLotNumbers.ChoiceForm";
	EndIf;

	If OpenSettings.FormFilters = Undefined Then
		FormFilters = New Array();
		FormFilters.Add(CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
		FormFilters.Add(CreateFilterItem("Inactive", True, DataCompositionComparisonType.NotEqual));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		FormParameters = New Structure();
		FormParameters.Insert("FillingData", New Structure());
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SourceOfOriginsStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.SourceOfOrigins.ChoiceForm";
	EndIf;

	If OpenSettings.FormFilters = Undefined Then
		FormFilters = New Array();
		FormFilters.Add(CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
		FormFilters.Add(CreateFilterItem("Inactive", True, DataCompositionComparisonType.NotEqual));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		FormParameters = New Structure();
		FormParameters.Insert("FillingData", New Structure());
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

#EndRegion

#Region ItemList

Function GetCurrentRowDataList(List, CurrentRow) Export
	ReturnRow = CurrentRow;
	If CurrentRow = Undefined Then
		ReturnRow = List.CurrentData;
	Else
		Return CurrentRow;
	EndIf;
	Return ReturnRow;
EndFunction

Procedure FillRowIDInItemList(Object) Export
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

Function GetSettingsStructure(Module) Export
	Settings = New Structure();
	Settings.Insert("Actions", New Structure());
	Settings.Insert("CalculateSettings", New Structure());
	Settings.Insert("Module", Module);
	Settings.Insert("Questions", New Array());
	Return Settings;
EndFunction

// Get open settings structure.
// 
// Returns:
//  Structure - Get open settings structure:
// * FormName - String -
// * ArrayOfFilters - Array of Structure -
// * FormParameters - Structure -
// * FillingData - Structure -
// * FormFilters - Structure -
// * ArrayOfChoiceParameters - Array Of Structure -
// * AdditionalParameters - Structure -
Function GetOpenSettingsStructure() Export
	Settings = New Structure();
	Settings.Insert("FormName");
	Settings.Insert("ArrayOfFilters");
	Settings.Insert("FormParameters");
	Settings.Insert("FillingData");
	Settings.Insert("FormFilters");
	Settings.Insert("ArrayOfChoiceParameters");
	Settings.Insert("AdditionalParameters");
	Return Settings;
EndFunction

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	If CommonFunctionsClientServer.ObjectHasProperty(Form, "TaxAndOffersCalculated") Then
		OffersClient.RecalculateTaxAndOffers(Object, Form);
	EndIf;

	RowIDInfoClient.DeleteRows(Object, Form);
EndProcedure

#EndRegion

#Region TitleChanges

Procedure SetTextOfDescriptionAtForm(Object, Form) Export
	If ValueIsFilled(Object.Description) Then
		Form.Description = Object.Description;
	Else
		Form.Description = R().I_2;
	EndIf;
EndProcedure

Procedure CalculatePaymentTermDuePeriod(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.PaymentTerms.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	SecondsInOneDay = 86400;
	If ValueIsFilled(Object.Date) And ValueIsFilled(CurrentData.Date) Then
		CurrentData.DuePeriod = (CurrentData.Date - BegOfDay(Object.Date)) / SecondsInOneDay;
	Else
		CurrentData.DuePeriod = 0;
	EndIf;
EndProcedure

Procedure CalculatePaymentTermDateAndAmount(Object, Form, AddInfo = Undefined) Export
	If Not Object.PaymentTerms.Count() Then
		Return;
	EndIf;
	TotalAmount = 0;
	For Each Row In Object.ItemList Do
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "Cancel") And Row.Cancel Then
			Continue;
		EndIf;
		TotalAmount = TotalAmount + Row.TotalAmount;
	EndDo;
	TotalPercent = Object.PaymentTerms.Total("ProportionOfPayment");
	RowWithMaxAmount = Undefined;
	SecondsInOneDay = 86400;
	For Each Row In Object.PaymentTerms Do
		Row.Date = Object.Date + (SecondsInOneDay * Row.DuePeriod);
		If TotalPercent = 0 Then
			Row.Amount = 0;
		Else
			Row.Amount = (TotalAmount / TotalPercent) * Row.ProportionOfPayment;
		EndIf;
		If RowWithMaxAmount = Undefined Then
			RowWithMaxAmount = Row;
		Else
			If Row.Amount > RowWithMaxAmount.Amount Then
				RowWithMaxAmount = Row;
			EndIf;
		EndIf;
	EndDo;
	If RowWithMaxAmount <> Undefined Then
		Difference = TotalAmount - Object.PaymentTerms.Total("Amount");
		RowWithMaxAmount.Amount = RowWithMaxAmount.Amount + Difference;
	EndIf;
	DocumentsClientServer.SetReadOnlyPaymentTermsCanBePaid(Object, Form);
EndProcedure

#EndRegion

#Region PaymentListItemsEvents

Procedure TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	CurrentData = Form.Items.PaymentList.CurrentData;

	If CurrentData = Undefined Then
		Return;
	EndIf;

	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.CashTransferOrder.Form.AvailableChoiceForm";
	EndIf;

	If OpenSettings.FormFilters = Undefined Then
		OpenSettings.FormFilters = New Array();
		OpenSettings.FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

#EndRegion

#Region MoneyTransfer

Procedure MoneyTransferStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	CurrentData = Form.Items.PaymentList.CurrentData;

	If CurrentData = Undefined Then
		Return;
	EndIf;

	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.MoneyTransfer.Form.ChoiceForm";
	EndIf;

	If OpenSettings.FormFilters = Undefined Then
		OpenSettings.FormFilters = New Array();
		OpenSettings.FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

#EndRegion

#Region ExpenseAndRevenue

Procedure ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing,
	OpenSettings = Undefined) Export
	If OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	StandardProcessing = False;

	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.ExpenseAndRevenueTypes.ChoiceForm";
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
			DataCompositionComparisonType.NotEqual));

	EndIf;

	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
	EndIf;

	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;

	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing,
	ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export

	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	EndIf;

	If AdditionalParameters = Undefined Then
		AdditionalParameters = New Structure();
	EndIf;

	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter",
		DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.AdditionalParameters",
		DocumentsServer.SerializeArrayOfFilters(AdditionalParameters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure

#EndRegion

#Region Utility

Procedure ShowHiddenTables(Object, Form) Export
	FormParameters = New Structure("DocumentRef", Object.Ref);
	OpenForm("CommonForm.EditHiddenTables", FormParameters, Form, , , , , FormWindowOpeningMode.Independent);
EndProcedure

Function GetFormItemNames()
	ItemNames = "ItemListKey, SpecialOffersKey, TransactionsKey,
				|CostListKey,
				|ItemListRowsKey,
				|ResultsTable,
				|RowIDInfo,
				|BasisesTreeBasis, BasisesTreeBasisUnit, BasisesTreeQuantityInBaseUnit, BasisesTreeKey,
				|BasisesTreeRowID, BasisesTreeRowRef, BasisesTreeBasisKey, BasisesTreeCurrentStep,
				|BasisesTreeReverseBasis, BasisesTreeReverseBasisUnit, BasisesTreeReverseQuantityInBaseUnit, BasisesTreeReverseKey,
				|BasisesTreeReverseRowID, BasisesTreeReverseRowRef, BasisesTreeReverseBasisKey, BasisesTreeReverseCurrentStep,
				|ResultsTreeBasis, ResultsTreeBasisUnit, ResultsTreeQuantityInBaseUnit, ResultsTreeKey,
				|ResultsTreeRowID, ResultsTreeRowRef, ResultsTreeBasisKey, ResultsTreeCurrentStep,
				|LinkedBasises,
				|QuantityInBaseUnit,
				|RevenueList, AllocationList, CostRowsRowID, RevenueRowsRowID, 
				|AllocationRowsBasisRowID, AllocationRowsRowID, 
				|CostDocumentsKey, RevenueDocumentsKey, CostRowsTreeRowID, RevenueRowsTreeRowID,
				|AllocationDocumentsKey, DocumentRowsBasisRowID, DocumentRowsRowID, ResultTreeRowID,
				|PaymentListKey, PaymentsKey,
				|ItemListInternalLinks, ItemListExternalLinks, InternalLinkedDocs, ExternalLinkedDocs,
				|Currencies, CurrenciesTableKey,
				|InventoryKey, AccountBalanceKey, AdvanceFromCustomersKey, AdvanceToSuppliersKey,
				|AccountPayableByAgreementsKey, AccountPayableByDocumentsKey, VendorsPaymentTermsKey,
				|AccountReceivableByAgreementsKey, AccountReceivableByDocumentsKey, CustomersPaymentTermsKey,
				|SendUUID, ReceiveUUID,
				|ItemListUseSerialLotNumber, ItemListIsService,
				|PaymentListApArPostingDetail,
				|InventoryUseSerialLotNumber, AccountBalanceIsFixedCurrency,
				|ChequeBondsKey, ChequeBondsApArPostingDetail,
				|WorkersQuantityInBaseUnit, WorkersKey,
				|MaterialsQuantityInBaseUnit, MaterialsQuantityInBaseUnitBOM, MaterialsKey, MaterialsKeyOwner, MaterialsIsVisible, MaterialsIsManualChanged,
				|MaterialsUniqueID, MaterialsBillOfMaterials,
				|DocumentsTreeKey, DocumentsTreeBasisKey, DocumentsTreeDocumentName,
				|GroupBillOfMaterials,
				|ProductionTreeWriteofStoreEnable,
				|ProductionTreeSurplusStoreEnable,
				|ProductionTreeMaterialStore,
				|ProductionTreeReleaseStore,
				|ProductionTreeInputID,
				|ProductionTreeOutputID,
				|ProductionTreeUniqueID,
				|ProductionTreeIsProduct,
				|ProductionTreeIsSemiproduct,
				|ProductionTreeIsMaterial,
				|ProductionTreeIsService,
				|ProductionsKey,
				|ConsignorBatches,
				|ShipmentToTradeAgentKey, ShipmentToTradeAgentUseSerialLotNumber,
				|ReceiptFromConsignorKey, ReceiptFromConsignorUseSerialLotNumber,
				|SourceOfOrigins,
				|ProductionDurationsListKey, ProductionCostsListKey,
				|PayrollListKey, 
				|TimeSheetListKey, TimeSheetListVisible, TimeSheetListLineNumber, 
				|TimeSheetListEmployee, TimeSheetListPosition, TimeSheetListEmployeeSchedule, TimeSheetListEmployeeSchedule,
				|TimeSheetListIsVacation, TimeSheetListIsSickLeave,
				|EmployeeCashAdvanceKey, AdvanceFromRetailCustomersKey, SalaryPaymentKey, EmployeeCashAdvanceIsFixedCurrency,
				|ItemListPurchaseOrderKey, ItemListSalesOrderKey,
				|AccrualListKey, DeductionListKey, CashAdvanceDeductionListKey,
				|ItemListConsignor, isControlCodeString,
				|AccountPayableOtherKey, AccountReceivableOtherKey, CashInTransitKey, CashInTransitIsFixedCurrency,
				|FixedAssetsKey,
				|AccrualListTotalVacationDays, AccrualListPaidVacationDays, AccrualListTotalSickLeaveDays ,AccrualListPaidSickLeaveDays,
				|EmployeeListKey, SalaryTaxListKey,
				|TaxesIncomingKey, TaxesOutgoingKey, TaxesDifferenceKey,
				|CalculationsKey";
	Return ItemNames;
EndFunction	

Procedure ShowRowKey(Form) Export
	ItemNames = GetFormItemNames();
	ArrayOfItemNames = StrSplit(ItemNames, ",");
	For Each ItemName In ArrayOfItemNames Do
		ItemName = TrimAll(ItemName);
		If Form.Items.Find(ItemName) <> Undefined Then
			Form.Items[ItemName].Visible = Not Form.Items[ItemName].Visible;
		EndIf;
	EndDo;
EndProcedure

Procedure SetCurrentRow(Object, Form, Item, FormParameters, AttributeName) Export
	If CommonFunctionsClientServer.ObjectHasProperty(Object, Item.Name) Then
		FormParameters.Insert("CurrentRow", Object[Item.Name]);
	Else
		TabularSection = Left(Item.Name, StrLen(Item.Name) - StrLen(AttributeName));
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, TabularSection) Then
			CurrentData = Form.Items[TabularSection].CurrentData;
			If CurrentData <> Undefined And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, AttributeName) Then
				If Not ValueIsFilled(CurrentData[AttributeName]) 
					And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "LineNumber") Then
					RowIndex = CurrentData.LineNumber - 1;
					PreviousRow = ?(RowIndex > 0, Object[TabularSection][RowIndex - 1], CurrentData);
					FormParameters.Insert("CurrentRow", PreviousRow[AttributeName]);
				Else
					FormParameters.Insert("CurrentRow", CurrentData[AttributeName]);
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

Procedure OpenLinkedDocuments(Object, Form, TableName, DocumentColumnName, QuantityColumnName) Export
	ArrayOfRows_ItemList = New Array();
	ArrayOfRows_Documents = New Array();
	
	For Each Row_ItemList In Object.ItemList Do
		ArrayOfDocuments = Object[TableName].FindRows(New Structure("Key", Row_ItemList.Key));

		If Not ArrayOfDocuments.Count() Then
			Continue;
		EndIf;
	
		For Each Row_Document In ArrayOfDocuments Do
			NewRow_Document = New Structure();
			NewRow_Document.Insert("Key"      , Row_Document.Key);
			NewRow_Document.Insert("BasisKey" , Row_Document.BasisKey);
			NewRow_Document.Insert("Document" , Row_Document[DocumentColumnName]);
			
			NewRow_Document.Insert("Quantity"           , Row_Document.Quantity);
			NewRow_Document.Insert("QuantityInDocument" , Row_Document[QuantityColumnName]);
			
			ArrayOfRows_Documents.Add(NewRow_Document);
		EndDo;
		
		
		NewRow_ItemList = New Structure("Key, Item, ItemKey, QuantityInBaseUnit");
		FillPropertyValues(NewRow_ItemList, Row_ItemList);
		ArrayOfRows_ItemList.Add(NewRow_ItemList);
	EndDo;
		
	FormParameters = New Structure();
	FormParameters.Insert("TableName", TableName);
	FormParameters.Insert("DocumentColumnName", DocumentColumnName);
	FormParameters.Insert("QuantityColumnName", QuantityColumnName);
	FormParameters.Insert("ArrayOfRows_ItemList", ArrayOfRows_ItemList);
	FormParameters.Insert("ArrayOfRows_Documents", ArrayOfRows_Documents);
	FormParameters.Insert("Ref", Object.Ref);
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Object"    , Object);
	AdditionalParameters.Insert("Form"      , Form);
	AdditionalParameters.Insert("TableName" , TableName);
	
	Notify = New NotifyDescription("LinkedDocumentsEnd", ThisObject, AdditionalParameters);
	OpenForm("CommonForm.LinkedDocuments", FormParameters, Form, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure LinkedDocumentsEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	Object = AdditionalParameters.Object;
	Form   = AdditionalParameters.Form;
	TableName = AdditionalParameters.TableName;
	
	For Each TreeRow In Result Do
		ArrayOfRows = Object[TableName].FindRows(TreeRow.Filter);
		For Each Row In ArrayOfRows Do
			Row.Quantity = TreeRow.Quantity;
		EndDo;
	EndDo;
	
	RowIDInfoClient.UpdateQuantity(Object, Form);
EndProcedure

Procedure UpdateQuantityByTradeDocuments(Object, TableName) Export
	For Each Row In Object.ItemList Do
		ArrayOfDocuments = Object[TableName].FindRows(New Structure("Key", Row.Key));

		If ArrayOfDocuments.Count() = 1 And ArrayOfDocuments[0].Quantity <> Row.QuantityInBaseUnit Then
			ArrayOfDocuments[0].Quantity = Row.QuantityInBaseUnit;
		EndIf;
	EndDo;
EndProcedure

Procedure SetLockedRowsForItemListByTradeDocuments(Object, Form, TableName) Export
	For Each Row In Object.ItemList Do
		Row.LockedRow = Object[TableName].FindRows(New Structure("Key", Row.Key)).Count() > 0;
	EndDo;
EndProcedure

#EndRegion

#Region RevenueType

Procedure RevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsRevenue", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure RevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsRevenue", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region ExpenseType

Procedure ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsExpense", True,
		DataCompositionComparisonType.Equal));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsExpense", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region FinancialMovementType

Procedure FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFinancialMovementType", True,
		DataCompositionComparisonType.Equal));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFinancialMovementType", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region PickUpItems

Procedure OpenPickupItems(Object, Form, Command) Export
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Filter" , New Structure("DisableIfIsService", False));
	NotifyDescription = New NotifyDescription("PickupItemsEnd", ThisObject, NotifyParameters);
	OpenFormParameters = PickupItemsParameters(Object, Form);
#If MobileClient Then

#Else
		If Command.AssociatedTable <> Undefined Then
			OpenFormParameters.Insert("AssociatedTableName", Command.AssociatedTable.Name);
			OpenFormParameters.Insert("Object", Object);
		EndIf;

		FormName = "CommonForm.PickUpItems";
		OpenForm(FormName, OpenFormParameters, Form, , , , NotifyDescription);
#EndIf

EndProcedure

Function PickupItemsParameters(Object, Form)
	ReturnValue = New Structure();

	StoreArray = New Array();
	StoreInItemList = False;
	For Each Row In Object.ItemList Do
		If CommonFunctionsClientServer.ObjectHasProperty(Row, "Store") Then
			StoreInItemList = True;
			If ValueIsFilled(Row.Store) And StoreArray.Find(Row.Store) = Undefined Then
				StoreArray.Add(Row.Store);
			EndIf;
		EndIf;
	EndDo;
	
	If Not StoreInItemList And CommonFunctionsClientServer.ObjectHasProperty(Object, "Store") Then
		If ValueIsFilled(Object.Store) Then
			StoreArray.Add(Object.Store);
		EndIf;
	EndIf;
	
	If Not StoreInItemList And CommonFunctionsClientServer.ObjectHasProperty(Object, "StoreSender") Then
		If ValueIsFilled(Object.StoreSender) Then
			StoreArray.Add(Object.StoreSender);
		EndIf;
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "StoreReceiver") Then
		ArrayOfReceiverStores = New Array();
		ArrayOfReceiverStores.Add(Object.StoreReceiver);
		ReturnValue.Insert("ReceiverStores", ArrayOfReceiverStores);
	EndIf;
	
	EndPeriod = CommonFunctionsServer.GetCurrentSessionDate();
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "Agreement") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		PriceType = AgreementInfo.PriceType;
	Else
		PriceType = PredefinedValue("Catalog.PriceTypes.EmptyRef");
	EndIf;
	ReturnValue.Insert("Stores", StoreArray);
	ReturnValue.Insert("EndPeriod", EndPeriod);
	ReturnValue.Insert("PriceType", PriceType);

	Return ReturnValue;
EndFunction

Function GetParametersPickupItems(Object, Form, AddInfo)
	Parameters = New Structure();
	
	ObjectRefType = TypeOf(Object.Ref);
	
	Parameters.Insert("ObjectRefType"       , ObjectRefType);
	Parameters.Insert("UseSerialLotNumbers" , Object.Property("SerialLotNumbers"));
	Parameters.Insert("UseSourceOfOrigins"  , Object.Property("SourceOfOrigins"));
	Parameters.Insert("UseControlString"  	, Object.Property("ControlCodeStrings"));

	// isSerialLotNumberAtRow
	isSerialLotNumberAtRow = False;
	If ObjectRefType = Type("DocumentRef.PhysicalInventory")
		Or ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
		isSerialLotNumberAtRow = Object.UseSerialLot;
	EndIf;
	Parameters.Insert("isSerialLotNumberAtRow", isSerialLotNumberAtRow);
	
	// FilterStructure
	If Object.Property("Agreement") Then
		FilterString = "Item, ItemKey, Unit, PriceType";
	ElsIf isSerialLotNumberAtRow Then
		FilterString = "Item, ItemKey, Unit, SerialLotNumber";
	Else
		FilterString = "Item, ItemKey, Unit";
	EndIf;

	If ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
		FilterString = FilterString + ", Barcode, Date";
	EndIf;
	FilterStructure = New Structure(FilterString);
	Parameters.Insert("FilterStructure", FilterStructure);
			
	// StoreRef	
	StoreRef = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "Store") Then
		StoreRef = Object.Store;
	ElsIf CommonFunctionsClientServer.ObjectHasProperty(Object, "StoreSender") Then
		StoreRef = Object.StoreSender;
	ElsIf CommonFunctionsClientServer.ObjectHasProperty(Form, "Store") Then
		StoreRef = Form.Store;
	EndIf;
	Parameters.Insert("StoreRef", StoreRef);
		
	// QuantityColumnName	
	QuantityColumnName = "Quantity";
	If ObjectRefType = Type("DocumentRef.PhysicalInventory")
		Or ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
		QuantityColumnName = "PhysCount";
	EndIf;
	Parameters.Insert("QuantityColumnName", QuantityColumnName);
	
	Parameters.Insert("Filter", AddInfo.Filter);
		
	ServerParameters = ControllerClientServer_V2.GetServerParameters(Object);
	ServerParameters.TableName = "ItemList";
	//@skip-check transfer-object-between-client-server
	FormParameters   = ControllerClientServer_V2.GetFormParameters(Form);
	ServerSideParameters = New Structure();
	ServerSideParameters.Insert("ServerParameters", ServerParameters);
	ServerSideParameters.Insert("FormParameters"  , FormParameters);
	Parameters.Insert("ServerSideParameters", ServerSideParameters);
	Return Parameters;
EndFunction

// Pickup items end.
// 
// Parameters:
//  ScanData - Array Of See BarcodeServer.FillFoundedItems
//  AddInfo - See BarcodeClient.GetBarcodeSettings
Procedure PickupItemsEnd(ScanData, AddInfo) Export
	If Not ValueIsFilled(ScanData) Or Not AddInfo.Property("Object") Or Not AddInfo.Property("Form") Then
		Return;
	EndIf;

	Object 	= AddInfo.Object; // See Document.RetailSalesReceipt.Form.DocumentForm.Object
	Form 	= AddInfo.Form; // See Document.RetailSalesReceipt.Form.DocumentForm
	For Each ScanRow In ScanData Do
		If ScanRow.isCertificate Then
			For Each Row In Object.ItemList Do
				If Not Row.IsService Then
					CommonFunctionsClientServer.ShowUsersMessage(R().CERT_OnlyProdOrCert);
					Return;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
	
	Parameters = GetParametersPickupItems(Object, Form, AddInfo);
	
	Parameters.ServerSideParameters.FormParameters.Form = Undefined;
	
	Result = DocumentsServer.PickupItemEnd(Parameters, ScanData);

	Parameters.ServerSideParameters.FormParameters.Form = Form;

	TmpParameters = ControllerClientServer_V2.GetParameters(
		Parameters.ServerSideParameters.ServerParameters, 
		Parameters.ServerSideParameters.FormParameters);
	
	ViewNotify = New Array();
	
	For Each RowInfo In Result.NewRows Do
		NewRow = Object.ItemList.Add();
		NewRow.Key = RowInfo.Key;
		TmpParameters.Cache = RowInfo.Cache;
		ControllerClientServer_V2.CommitChainChanges(TmpParameters, False);
		For Each ViewNotifyItem In RowInfo.ViewNotify Do
			ViewNotify.Add(ViewNotifyItem);
		EndDo;
	EndDo;
		
	For Each RowInfo In Result.UpdatedRows Do
		TmpParameters.Cache = RowInfo.Cache;
		ControllerClientServer_V2.CommitChainChanges(TmpParameters, False);
		For Each ViewNotifyItem In RowInfo.ViewNotify Do
			ViewNotify.Add(ViewNotifyItem);
		EndDo;
	EndDo;
	
	For Each TableName In Result.ArrayOfTableNames Do
		TmpParameters.Cache = Result[TableName];
		ControllerClientServer_V2.CommitChainChanges(TmpParameters, False);
	EndDo;
	
	TmpParameters.isRowsAddByScan = Result.NewRows.Count() > 0;
	TmpParameters.NewRowsByScan = Result.NewRows;
	TmpParameters.UpdatedRowsByScan = Result.UpdatedRows;
	
	TmpParameters.ViewNotify = ViewNotify;
	ControllerClientServer_V2.OnChangesNotifyView(TmpParameters);	
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "SerialLotNumbers") Then
		SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object);
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "SourceOfOrigins") Then
		SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Object);
	EndIf;
	
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "ControlCodeStrings") Then
		ControlCodeStringsClient.UpdateState(Object);
	EndIf;	
	
	// set current last added row
	If Result.ChoiceForms.PresentationStartChoice_Counter <> 1 And Result.ChoiceForms.StartChoice_Counter <> 1 Then
		If Result.NewRows.Count() Then
			Form.Items.ItemList.CurrentRow = Object.ItemList.FindRows(
				New Structure("Key", Result.NewRows[Result.NewRows.UBound()].Key))[0].GetID();
		EndIf;
	EndIf;
	
	FormAlreadyOpened = False;
	
	// open serial lot numbers choice form
	If Result.ChoiceForms.PresentationStartChoice_Counter = 1 Then
		Form.Items.ItemList.CurrentRow = Object.ItemList.FindRows(
			New Structure("Key", Result.ChoiceForms.PresentationStartChoice_Key))[0].GetID();
		Form.ItemListSerialLotNumbersPresentationStartChoice(Object.ItemList, Undefined, True);
		FormAlreadyOpened = True;
	EndIf;	
	
	If Result.ChoiceForms.StartChoice_Counter = 1 Then
		Form.Items.ItemList.CurrentRow = Object.ItemList.FindRows(
			New Structure("Key", Result.ChoiceForms.StartChoice_Key))[0].GetID();
		Form.ItemListSerialLotNumberStartChoice(Object.ItemList, Undefined, True);
		FormAlreadyOpened = True;
	EndIf;	

	If Result.ChoiceForms.ControlStringStartChoice_Counter = 1 And Not FormAlreadyOpened Then
		Form.Items.ItemList.CurrentRow = Object.ItemList.FindRows(
			New Structure("Key", Result.ChoiceForms.ControlStringStartChoice_Key))[0].GetID();
		Form.ItemListControlCodeStringStateClick();
	EndIf;
	
	For Each Message In Result.UserMessages Do
		CommonFunctionsClientServer.ShowUsersMessage(Message);
	EndDo;	
EndProcedure

#EndRegion
