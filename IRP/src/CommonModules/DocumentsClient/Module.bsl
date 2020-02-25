#Region FormEvents

Procedure OnOpen(Object, Form, Cancel) Export
	Return;
EndProcedure
			
Procedure OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings) Export	
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	ChoiceForm = GetForm(OpenSettings.FormName, OpenSettings.FormParameters, Item, Form.UUID, , Form.URL);	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
	EndIf;
	
	For Each Filter In OpenSettings.ArrayOfFilters Do
		AddFilterToChoiceForm(ChoiceForm, Filter.FieldName, Filter.Value, Filter.ComparisonType);
	EndDo;	
	ChoiceForm.Open();
EndProcedure

Procedure OpenListForm(FormName, ArrayOfFilters, FormParameters,
		Source = Undefined, Uniqueness = Undefined, Window = Undefined,
		URL = Undefined) Export
	
	ListForm = GetForm(FormName, FormParameters, Source, Uniqueness, Window, URL);
	
	For Each Filter In ArrayOfFilters Do
		AddFilterToChoiceForm(ListForm, Filter.FieldName, Filter.Value, Filter.ComparisonType);
	EndDo;
	
	ListForm.Open();
EndProcedure

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure
#EndRegion

#Region Account

Procedure AccountOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	Module.AccountOnChange(Object, Form, Item);
EndProcedure

Procedure CurrencyOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export 	
	If Object[Settings.TableName].Count() > 0 Then
		QuestionStructure = New Structure();
		QuestionStructure.Insert("Currency", String(Settings.AccountInfo.Currency));
		QuestionStructure.Insert("CurrentCurrency", Form.Currency);
		QuestionStructure.Insert("AccountInfo", Settings.AccountInfo);
		QuestionStructure.Insert("ProcedureName", "CurrencyOnChangeContinue");
		QuestionStructure.Insert("QuestionText", StrTemplate(R()["R().QuestionToUser_006"]));
		QuestionStructure.Insert("Action", "Currency");
		
		Settings.Questions.Add(QuestionStructure);

		Return;
	Else
		Form.Currency = Settings.AccountInfo.Currency;
	EndIf;
EndProcedure

#EndRegion

#Region ItemPartner
Procedure PartnerOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	PartnerSettings = Module.PartnerSettings();
	
	Settings.Insert("ObjectAttributes"	, PartnerSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, PartnerSettings.FormAttributes);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	// {TAXES}
	Form.Taxes_CreateFormControls();
	// {TAXES}
	
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
	FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);
	
	PartnerInfo = New Structure();
	PartnerInfo.Insert("ManagerSegment"	, DocumentsServer.GetManagerSegmentByPartner(Object.Partner));
	PartnerInfo.Insert("LegalName"		, DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName));
	
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner"		, Object.Partner);
	AgreementParameters.Insert("Agreement"		, Object.Agreement);
	AgreementParameters.Insert("CurrentDate"	, Object.Date);
	AgreementParameters.Insert("AgreementType"	, PartnerSettings.AgreementType);
	
	PartnerInfo.Insert("Agreement" , DocumentsServer.GetAgreementByPartner(AgreementParameters));
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(PartnerInfo.Agreement);
	
	Settings.Insert("CurrentValuesStructure"	, CurrentValuesStructure);
	Settings.Insert("PartnerInfo"				, PartnerInfo);
	Settings.Insert("AgreementInfo"				, AgreementInfo);
	
	DoTitleActions(Object, Form, Settings, PartnerSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	// GroupTitle
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings); 
	Else
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		Settings.Insert("Rows", Object.ItemList);
		Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
		CalculateTable(Object, Form, Settings);
	EndIf;
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Partners.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
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

Procedure PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
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

#Region PartnerSegment

Procedure PartnerSegmentStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.PartnerSegments.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
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

Procedure AgreementOnChange(Object, Form, Module, Item = Undefined, Settings  = Undefined) Export
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	 
	AgreementSettings = Module.AgreementSettings();
	
	Settings.Insert("ObjectAttributes"	, AgreementSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, AgreementSettings.FormAttributes);
	
	// {TAXES}
	// рАЗДЕЛИТЬ ПРОЦЕДУРУ НА ЗАПОЛНЕНИЕ И ПЕРЕРАСЧЕТ
	TaxesClient.ChangeTaxRatesByAgreement(Object, Form);
	// {TAXES}
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
	FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);

	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	Settings.Insert("CurrentValuesStructure", CurrentValuesStructure);
	Settings.Insert("AgreementInfo", AgreementInfo);
	
	DoTitleActions(Object, Form, Settings, AgreementSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	// GroupTitle
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings); 
	Else
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		
		Settings.Insert("Rows", Object.ItemList);
		Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
		CalculateTable(Object, Form, Settings);
	EndIf;
	
EndProcedure

//TODO: Start choice functions are similar.
Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Agreements.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", 
								PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));															
		
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

//TODO: Edit text change functions are similar.
Procedure AgreementEditTextChange(Object, Form, Item, Text,
		StandardProcessing, ArrayOfFilters = Undefined,
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

#Region ItemLegalName
Procedure LegalNameOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	// GroupTitle		 
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure
#EndRegion

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	CompanySettings = Module.CompanySettings();
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	Settings.Insert("ObjectAttributes"	, CompanySettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, CompanySettings.FormAttributes);
	
	// {TAXES}
	If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
		Form.Taxes_CreateFormControls();
	EndIf;
	
	// {TAXES}
	
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
    FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);
	Settings.Insert("CurrentValuesStructure"	, CurrentValuesStructure);
    
    
    If CurrentValuesStructure.Property("Account") Or CurrentValuesStructure.Property("CashAccount") Then
	    DefaultCustomParameters = New Structure("Company", Object.Company);
		CustomParameters = CatCashAccountsClient.DefaultCustomParameters(DefaultCustomParameters);
		If CompanySettings.Property("AccountType") Then
			CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
														CompanySettings.AccountType,
														ComparisonType.Equal,
														DataCompositionComparisonType.Equal));
		
		Else
			CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
														PredefinedValue("Enum.CashAccountTypes.Transit"),
														ComparisonType.NotEqual,
														DataCompositionComparisonType.NotEqual));
		EndIf;
	EndIf;	
		
    If CurrentValuesStructure.Property("Account") Then
		CustomParameters.Insert("CashAccount", Object.Account);
    	Account = CatCashAccountsServer.GetCashAccountByCompany(Object.Company, CustomParameters);
    	Settings.Insert("CompanyInfo", Account);
    ElsIf CurrentValuesStructure.Property("CashAccount") Then
    	CustomParameters.Insert("CashAccount", Object.CashAccount);
    	CashAccount = CatCashAccountsServer.GetCashAccountByCompany(Object.Company, CustomParameters);
    	Settings.Insert("CompanyInfo", CashAccount);
    EndIf;
    
    If CurrentValuesStructure.Property("Agreement") Then
	   	CompanyInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	    AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	    Settings.Insert("CompanyInfo"				, CompanyInfo);
	    Settings.Insert("AgreementInfo"				, AgreementInfo);
    EndIf;
    
    DoTitleActions(Object, Form, Settings, CompanySettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	// GroupTitle
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	Settings.Insert("Rows", Object[CompanySettings.TableName]);
	If CompanySettings.Property("CalculateSettings") Then
		Settings.CalculateSettings = CompanySettings.CalculateSettings;
	Else
		Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	EndIf;
	
	CalculateTable(Object, Form, Settings);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Companies.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", 
																		True, DataCompositionComparisonType.Equal));
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

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, 
										ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export
	
	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", True, ComparisonType.Equal));
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

#Region Status
Procedure StatusStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.ObjectStatuses.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
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
	If  EditSettings = Undefined Then
		EditSettings = GetOpenSettingsStructure();
	EndIf;
	
	If EditSettings.ArrayOfFilters = Undefined Then
		EditSettings.ArrayOfFilters = New Array();
		EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																						True, ComparisonType.NotEqual));
		EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Our", 
																						True, ComparisonType.Equal));
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

#Region Stores

Procedure StoreOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	StoreSettings = Module.StoreSettings();
	
	Settings.Insert("ObjectAttributes"	, StoreSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, StoreSettings.FormAttributes);
	
	If Not Settings.Property("AgreementInfo") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		Settings.Insert("AgreementInfo", AgreementInfo);
	EndIf;

	DoTitleActions(Object, Form, Settings, StoreSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings); 
	Else
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
	EndIf;
	
EndProcedure

Procedure StoreOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes
		And AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		Object = AdditionalParameters.Object;
				
		If AdditionalParameters.Property("Settings") Then
			AdditionalParameters.Form.Store = AdditionalParameters.Settings.NewStore;
		EndIf;
		
		For Each Row In AdditionalParameters.Rows Do
			Row.Store = Form.Store;
		EndDo;
		Form.Items.Store.InputHint = "";
		Form.StoreBeforeChange = Form.Store;
		SetCurrentStore(Object, Form, Form.Store);
	ElsIf AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, AdditionalParameters.Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
	Else
		Return;
	EndIf;
EndProcedure

Procedure SetCurrentStore(Object, Form, Store) Export
	If Not Store = Undefined And Store.IsEmpty() Then
		Form.StoreBeforeChange = Form.CurrentStore;
	EndIf;
	
	If ValueIsFilled(Store) Then
		Form.CurrentStore = Store;
	ElsIf ValueIsFilled(Form.Store) Then
		Form.CurrentStore = Form.Store;
	ElsIf ValueIsFilled(Form.CurrentStore) Then
		Return;
	Else
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		Form.CurrentStore = DocumentsServer.GetCurrentStore(ObjectData);
		
	EndIf;
EndProcedure

Procedure FillUnfilledStoreInRow(Object, Item, Store) Export
	If ValueIsFilled(Item.CurrentData.Store) Then
		Return;
	EndIf;
	
	If CatItemsServer.StoreMustHave(Item.CurrentData.Item) Then
		IdentifyRow = Item.CurrentRow;
		RowItemList = Object.ItemList.FindByID(IdentifyRow);
		RowItemList.Store = Store;
	EndIf;
EndProcedure

#EndRegion

#Region PriceType

Procedure PriceTypeOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export 	
	If Object.ItemList.Count() > 0 Then
		QuestionStructure = New Structure();
		QuestionStructure.Insert("PriceType", String(Settings.AgreementInfo.PriceType));
		QuestionStructure.Insert("CurrentPriceType", Form.CurrentPriceType);
		QuestionStructure.Insert("AgreementInfo", Settings.AgreementInfo);
		QuestionStructure.Insert("ProcedureName", "PriceTypeOnChangeContinue");
		QuestionStructure.Insert("QuestionText", StrTemplate(R()["QuestionToUser_011"], String(Settings.AgreementInfo.PriceType)));
		QuestionStructure.Insert("Action", "PriceTypes");
		
		Settings.Questions.Add(QuestionStructure);

		Return;
	Else
		Form.CurrentPriceType = Settings.AgreementInfo.PriceType;
	EndIf;
EndProcedure
	
Procedure PriceTypeOnChangeContinue(Answer, AdditionalParameters) Export
	Form = AdditionalParameters.Form;
	Object = AdditionalParameters.Object;
	Settings = AdditionalParameters.Settings;
		
	If Answer = DialogReturnCode.Yes Then
		Form.CurrentPriceType = Settings.AgreementInfo.PriceType;
		For Each RowItem In AdditionalParameters.Rows Do
			RowItem.PriceType = Form.CurrentPriceType;
		EndDo;
	EndIf;
	
	Settings.Insert("CalculateSettings", New Structure());
	CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
    Settings.Insert("Rows", AdditionalParameters.Rows);
    ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure

Procedure SetCurrentPriceType(Form, PriceType) Export
	Form.CurrentPriceType = PriceType;
EndProcedure

Procedure ChangePriceType(Object, Form, Settings) Export	
	If Not ValueIsFilled(Settings.AgreementInfo.PriceType) Then
		Return;
	EndIf;
	
	Filter = New Structure("PriceType", Form.CurrentPriceType);
	If Not Form.CurrentPriceType = Settings.AgreementInfo.PriceType Or 
								Not Object.ItemList.FindRows(Filter).Count() = Object.ItemList.Count() Then
		PriceTypeOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;
EndProcedure

#EndRegion

#Region PriceIncludeTaxEvents

Procedure PriceIncludeTaxOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	// GroupTitle
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	Settings.Insert("Rows", Object.ItemList);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	CalculateTable(Object, Form, Settings);
	
	Form.TaxAndOffersCalculated = True;
EndProcedure

#EndRegion

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

#Region ItemDate

Procedure DateOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export

	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	DateSettings = Module.DateSettings();
	Settings.Insert("ObjectAttributes"		, DateSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, DateSettings.FormAttributes);

	#Region TAXES
	// Taxes and amounts recalcolates ALWAYS
	// {TAXES}
	Form.Taxes_CreateFormControls();
	// {TAXES}
	
	If DateSettings.Property("EmptyBasisDocument") Then
		Rows = Object[DateSettings.TableName].FindRows(DateSettings.EmptyBasisDocument);
		If Rows.Count() = 0 And Object[DateSettings.TableName].Count() Then	
			Settings.Insert("Rows", Object[DateSettings.TableName]);
			Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
			ItemListCalculateRowsAmounts(Object, Form, Settings);
			Return;
		EndIf;
		Settings.Insert("Rows", Rows);
	Else
		Rows = Object[DateSettings.TableName];
	EndIf;
	#EndRegion
	
	Settings.CalculateSettings.Insert("UpdatePrice"	, "UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType);
	
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
	FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);
	
	PartnerInfo = New Structure();
	PartnerInfo.Insert("ManagerSegment"	, DocumentsServer.GetManagerSegmentByPartner(Object.Partner));
	PartnerInfo.Insert("LegalName"		, DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName));

	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner"		, Object.Partner);
	AgreementParameters.Insert("Agreement"		, Object.Agreement);
	AgreementParameters.Insert("CurrentDate"	, Object.Date);
	AgreementParameters.Insert("AgreementType"	, DateSettings.AgreementType);
	
	PartnerInfo.Insert("Agreement" , DocumentsServer.GetAgreementByPartner(AgreementParameters));
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(PartnerInfo.Agreement);
	
	
	Settings.Insert("CurrentValuesStructure"	, CurrentValuesStructure);
	Settings.Insert("PartnerInfo"				, PartnerInfo);
	Settings.Insert("AgreementInfo"				, AgreementInfo);
	
	DoTitleActions(Object, Form, Settings, DateSettings.Actions);
	
	// GroupTitle
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	If CalculationStringsClientServer.PricesChenged(Object, Form, Settings) Then
		QuestionStructure = New Structure;
		QuestionStructure.Insert("ProcedureName", "PricesChengedContinue");
		QuestionStructure.Insert("QuestionText"	, R()["QuestionToUser_013"]);
		QuestionStructure.Insert("Action"		, "Prices");
		Settings.Questions.Add(QuestionStructure);
	EndIf;
	
	
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings); 
	Else
		Settings.Insert("Rows", Object[DateSettings.TableName]);
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		CalculateTable(Object, Form, Settings);
	EndIf;
EndProcedure

Procedure ShowUserQueryBox(Object, Form, Settings)
	
		NotifyDescription = New NotifyDescription("ShowUserQueryBoxContinue", 
						ThisObject,
						New Structure("Object, Form, Settings", Object, Form, Settings));
						
		OpenForm("CommonForm.UpdateItemListInfo",
					New Structure("QuestionsParameters", Settings.Questions),		
					Form,
					,
					,
					,
					NotifyDescription,
					FormWindowOpeningMode.LockOwnerWindow);

EndProcedure
	
Procedure ShowUserQueryBoxContinue(Result, AdditionalParameters) Export
	
	Object = AdditionalParameters.Object;
	Form = AdditionalParameters.Form;
	Settings = AdditionalParameters.Settings;
	If Result = Undefined Then
		
		CacheObject = Settings.CacheObject;
		CommonFunctionsClientServer.FillStructureInObject(CacheObject, Object);
		
		CacheForm = AdditionalParameters.Settings.CacheForm;
		
		FillPropertyValues(Form, CacheForm);
		If Not CacheForm.CurrentPartner = Undefined Then
			Object.Partner = CacheForm.CurrentPartner; 
		EndIf;
		If Not CacheForm.CurrentDate = Undefined Then
			Object.Date = CacheForm.CurrentDate;
		EndIf;
		If Not CacheForm.CurrentAgreement = Undefined Then
			Object.Agreement = CacheForm.CurrentAgreement; 
		EndIf;
		
		Form.Modified = False;
		Return;
	EndIf;
	
	QuestionSettngs = New Structure();
	For Each Question In Settings.Questions Do
		QuestionSettngs.Insert(Question.Action, Question);
	EndDo;
	
	If Settings.Property("Rows") Then
		Rows = Settings.Rows;
	Else
		Rows = Object.ItemList;
	EndIf;
	
	If Result.Property("UpdateStores") Then
		Parameters = New Structure("Object, Form, Settings, Rows");
		Parameters.Object = Object;
		Parameters.Form = Form;
		Parameters.Settings = QuestionSettngs.Stores;
		Parameters.Rows = Rows;
		StoreOnChangeContinue(DialogReturnCode.Yes, Parameters);
	EndIf;
		
	If Result.Property("UpdatePriceTypes") Then
		Parameters = New Structure("Object, Form, Settings, Rows");
		Parameters.Object = Object;
		Parameters.Form = Form;
		Parameters.Settings = QuestionSettngs.PriceTypes;
		Parameters.Rows = Rows;
		PriceTypeOnChangeContinue(DialogReturnCode.Yes, Parameters);
	EndIf;
		
	If Result.Property("UpdatePrices") Then
		
		Settings.CalculateSettings = New Structure();
		Settings.CalculateSettings.Insert("UpdatePrice",
					New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType));
					
		Settings.Insert("Rows", Rows);
		CalculateTable(Object, Form, Settings);
	EndIf;
	
	Settings.CalculateSettings = New Structure();
	Settings.Insert("Rows", Object.ItemList);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	CalculateTable(Object, Form, Settings);
	Form.CurrentPartner = Object.Partner;
	Form.CurrentAgreement = Object.Agreement;
	Form.CurrentDate = Object.Date;
EndProcedure

#EndRegion

#Region PickUpItems

Procedure PickupItemsEnd(Result, AdditionalParameters) Export
	If NOT ValueIsFilled(Result)
		OR Not AdditionalParameters.Property("Object")
		OR Not AdditionalParameters.Property("Form") Then
		Return;
	EndIf;
	
	Object 	= AdditionalParameters.Object;
	Form 	= AdditionalParameters.Form;	
	
	Settings = New Structure();
	Settings.Insert("Rows", New Array);
	CalculationSettings = New Structure;
	If Object.Property("Agreement") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		CalculationSettings.Insert("UpdatePrice",
					New Structure("Period, PriceType", Object.Date, AgreementInfo.PriceType));
		FilterString = "Item, ItemKey, Unit, Price";
	Else
		FilterString = "Item, ItemKey, Unit";
	EndIf;
	FilterStructure = New Structure(FilterString);
	Settings.Insert("CalculateSettings", CalculationSettings);
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	For Each ResultElement In Result Do
		FillPropertyValues(FilterStructure, ResultElement);
		ExistingRows = Object.ItemList.FindRows(FilterStructure);
		If ExistingRows.Count() Then
			Row = ExistingRows[0];
		Else
			Row = Object.ItemList.Add();
			If Row.Property("Key") Then
				Row.Key = New UUID();
			EndIf;
			FillPropertyValues(Row, ResultElement, FilterString);
			If Row.Property("Store") Then
				Row.Store = Form.CurrentStore;
			EndIf;
			If Row.Property("DeliveryDate") Then
				Row.DeliveryDate = Form.DeliveryDate;
			EndIf;
			If Row.Property("PriceType") Then
				Row.PriceType = Form.CurrentPriceType;
			EndIf;
			If Row.Property("ProcurementMethod") And CatItemsServer.StoreMustHave(Row.Item) Then
				Row.ProcurementMethod = PredefinedValue("Enum.ProcurementMethods.Stock");
			EndIf;
		EndIf;
		
		If Row.Property("Quantity") Then
			Row.Quantity = Row.Quantity + ResultElement.Quantity;
		ElsIF Row.Property("PhysCount") Then
			Row.PhysCount = Row.PhysCount + ResultElement.Quantity;
			Row.Difference = Row.PhysCount - Row.ExpCount;
		EndIf;
		
		If Row.Property("NetAmount") Then
			ItemListCalculateRowAmounts(Object, Form, Row);
		EndIf;	
		Settings.Rows.Add(Row);
	EndDo;
	
	Form.ItemListOnChange(Form.Items.ItemList);
EndProcedure

Procedure OpenPickupItems(Object, Form, Command) Export
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyDescription = New NotifyDescription("PickupItemsEnd", ThisObject, NotifyParameters);
	OpenFormParameters = PickupItemsParameters(Object, Form);	
	#If MobileClient Then
	FormName = "CommonForm.PickUpItemsMobile";
	#Else
	FormName = "CommonForm.PickUpItems";
	#EndIf
	OpenForm(FormName, OpenFormParameters, Form, , , , NotifyDescription);
EndProcedure

//TODO: Some parameters do not exist. Fix
Function PickupItemsParameters(Object, Form)
	ReturnValue = New Structure();
	
	StoreArray = New Array;
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.Store) Then
			If StoreArray.Find(Row.Store) = Undefined Then
				StoreArray.Add(Row.Store);
			EndIf;
		EndIf;
	EndDo;
	Try
		If Not StoreArray.Count() And ValueIsFilled(Form.CurrentStore) Then
			StoreArray.Add(Form.CurrentStore);
		EndIf;
	Except
		
	EndTry;
	EndPeriod = CommonFunctionsServer.GetCurrentSessionDate();
	Try
		PriceType = Form.CurrentPriceType;
	Except
		PriceType = PredefinedValue("Catalog.PriceTypes.EmptyRef");
	EndTry;
	
	ReturnValue.Insert("Stores", StoreArray);
	ReturnValue.Insert("EndPeriod", EndPeriod);
	ReturnValue.Insert("PriceType", PriceType);
	
	Return ReturnValue;
EndFunction

#EndRegion

#Region DeliveryDate

Procedure DeliveryDateOnChange(Object, Form, Item = Undefined) Export
	SetCurrentDeliveryDate(Form, Form.DeliveryDate);
	ChangeItemListDeliveryDate(Object.ItemList, Form.DeliveryDate);
	FillDeliveryDates(Object, Form);
EndProcedure

Procedure SetCurrentDeliveryDate(Form, DeliveryDate) Export
	Form.CurrentDeliveryDate = DeliveryDate;
EndProcedure

Procedure ChangeItemListDeliveryDate(ItemList, DeliveryDate) Export
	For Each Row In ItemList Do
		If Row.DeliveryDate <> DeliveryDate Then
			Row.DeliveryDate = DeliveryDate;
		EndIf;
	EndDo;
EndProcedure

Procedure FillDeliveryDates(Object, Form) Export
	DeliveryDatesArray = New Array;
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.DeliveryDate) Then
			If DeliveryDatesArray.Find(Row.DeliveryDate) = Undefined Then
				DeliveryDatesArray.Add(Row.DeliveryDate);
			EndIf;
		EndIf;
	EndDo;
	If DeliveryDatesArray.Count() = 0 Then
		Form.Items.DeliveryDate.Tooltip = "";
		Form.DeliveryDate = Form.CurrentDeliveryDate;
	ElsIf DeliveryDatesArray.Count() = 1 Then
		Form.Items.DeliveryDate.Tooltip = "";
		Form.DeliveryDate = DeliveryDatesArray[0];
	Else
		DeliveryDatesFormatedArray = New Array();
		For Each Row In DeliveryDatesArray Do
			DeliveryDatesFormatedArray.Add(Format(Row, "DF=dd.MM.yy;"));
		EndDo;
		Form.DeliveryDate = Date(1, 1, 1);
		Form.Items.DeliveryDate.Tooltip = StrConcat(DeliveryDatesFormatedArray, "; ");
	EndIf;
EndProcedure

Procedure FillUnfilledDeliveryDatesInRow(Object, Item, DeliveryDate) Export
	If Not ValueIsFilled(Item.CurrentData.DeliveryDate) Then
		IdentifyRow = Item.CurrentRow;
		RowItemList = Object.ItemList.FindByID(IdentifyRow);
		RowItemList.DeliveryDate = DeliveryDate;
	EndIf;
EndProcedure
#EndRegion

#Region Item

Procedure ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Items.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type", 
								PredefinedValue("Enum.ItemTypes.Service"), DataCompositionComparisonType.NotEqual));
	EndIf;
	
	OpenSettings.FormParameters = New Structure();
	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined) Export
	
	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("ItemType.Type",
												PredefinedValue("Enum.ItemTypes.Service"), ComparisonType.NotEqual));
	EndIf;
	
	ArrayOfChoiceParameters = New Array();
	ArrayOfChoiceParameters.Add(New ChoiceParameter("Filter.CustomSearchFilter", 
															DocumentsServer.SerializeArrayOfFilters(ArrayOfFilters)));
	Item.ChoiceParameters = New FixedArray(ArrayOfChoiceParameters);
EndProcedure
#EndRegion

#Region Boxes

Procedure BoxesStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.Boxes.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	EndIf;
	
	OpenSettings.FormParameters = New Structure();
	If OpenSettings.FillingData = Undefined Then
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	Else
		OpenSettings.FormParameters.Insert("FillingData", OpenSettings.FillingData);
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure BoxesEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined) Export
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

#Region Cheque

Procedure ChequeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.ChequeBonds.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Currency", 
																Object.Currency, DataCompositionComparisonType.Equal));
	EndIf;
	
	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ChequeEditTextChange(Object, Form, Item, Text, StandardProcessing,
	ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Currency", Object.Currency, ComparisonType.Equal));
	CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
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

&AtClient
Procedure SearchByBarcode(Command, Object, Form, DocumentClientModule = Undefined, PriceType = Undefined) Export
	TransferParameters = New Structure;
	If DocumentClientModule = Undefined Then
		TransferParameters.Insert("DocumentClientModule", ThisObject);
	Else
		TransferParameters.Insert("DocumentClientModule", DocumentClientModule);
	EndIf;
	If PriceType <> Undefined Then
		TransferParameters.Insert("PriceType", PriceType);
		If Object.Ref = Undefined Then
			TransferParameters.Insert("PricePeriod", CurrentDate());
		Else
			TransferParameters.Insert("PricePeriod", Object.Date);
		EndIf;
	EndIf;
	SearchByBarcode(Command, Object, Form, DocumentClientModule, TransferParameters);
EndProcedure

Procedure SearchByBarcodeEnd(BarcodeItems, Parameters) Export
	DocumentModule = Parameters.ClientModule;
	DocumentModule.PickupItemsEnd(BarcodeItems, Parameters);
EndProcedure

#EndRegion

#Region Common

Function CreateCurrentValuesStructure(Object, StringKeys, CunditionalKeys = "") Export
	CurrentValuesStructure = New Structure(StringKeys + ", " + CunditionalKeys);
	FillPropertyValues(CurrentValuesStructure, Object, StringKeys);
	Return CurrentValuesStructure;
EndFunction

Function CreateFilterItem(FieldName, Value, ComparisonType) Export
	FilterStructure = New Structure();
	FilterStructure.Insert("FieldName", FieldName);
	FilterStructure.Insert("Value", Value);
	FilterStructure.Insert("ComparisonType", ComparisonType);
	Return FilterStructure;
EndFunction

Procedure AddFilterToChoiceForm(ChoiceForm, PathToField, Value,
		ComparisonType)
	FilterItem = ChoiceForm.List.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterItem.LeftValue = New DataCompositionField(PathToField);
	FilterItem.RightValue = Value;
	FilterItem.ComparisonType = ComparisonType;
EndProcedure

#EndRegion

#Region DocUmentsStartChoise

Procedure PurchaseInvoiceStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.PurchaseInvoice.ChoiceForm";
	EndIf;
	
	If OpenSettings.FormFilters = Undefined Then
		OpenSettings.FormFilters = New Array;
		OpenSettings.FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
		OpenSettings.FormFilters.Add(CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PurchaseReturnStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.PurchaseReturn.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
	EndIf;
	
	If OpenSettings.FormFilters = Undefined Then
		OpenSettings.FormFilters = New Array;
		OpenSettings.FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
		OpenSettings.FormFilters.Add(CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SalesInvoiceStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.SalesInvoice.ChoiceForm";
	EndIf;
	
	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array;
	EndIf;
	
	If OpenSettings.FormFilters = Undefined Then
		OpenSettings.FormFilters = New Array;
		OpenSettings.FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
		OpenSettings.FormFilters.Add(CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure SalesReturnStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.SalesReturn.ChoiceForm";
	EndIf;
	
	If OpenSettings.FormFilters = Undefined Then
		FormFilters = New Array;
		FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
		FormFilters.Add(CreateFilterItem("Company", Object.Company, DataCompositionComparisonType.Equal));
	EndIf;
	
	If OpenSettings.FormParameters = Undefined Then
		FormParameters = New Structure();
		FormParameters.Insert("FillingData", New Structure());
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

#EndRegion

#Region ItemListItemsOnChange

Procedure ItemListCalculateRowAmounts(Object, Form, RowData) Export
	Settings = New Structure();
	Settings.Insert("Rows", New Array());
	Settings.Insert("CalculateSettings");
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	Settings.Rows.Add(RowData);
	ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure

Procedure ItemListCalculateRowsAmounts(Object, Form, Settings, Item = Undefined) Export

	Taxes = Undefined;
	If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
		Taxes = TaxesClient.GetArrayOfTaxInfo(Form);
	EndIf;
	
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		Settings.Rows,
		Settings.CalculateSettings,
		Taxes);
	If Not Taxes = Undefined Then	
		Form.TaxAndOffersCalculated = False;
	EndIf;
	
EndProcedure

Procedure CalculateTable(Object, Form, Settings) Export
	Actions = New Structure();

	CalculationStringsClientServer.DoTabelActions(Object, Form, Settings, Actions);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure 

Function GetSettingsStructure(Module) Export
	Settings = New Structure();
	Settings.Insert("Actions",  New Structure());
	Settings.Insert("CalculateSettings",  New Structure());
	Settings.Insert("Module", Module);
	Settings.Insert("Questions", New Array());
	Return Settings;
EndFunction

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
	OffersClient.RecalculateTaxAndOffers(Object, Form);
EndProcedure
#EndRegion

#Region TitleChanges

Procedure SetTextOfDescriptionAtForm(Object, Form) Export
	If ValueIsFilled(Object.Description) Then
		Form.Description = Object.Description;
	Else
		Form.Description = R()["I_2"];
	EndIf;
EndProcedure

Procedure ChangeCompany(Object, Form, Settings) Export
	If ValueIsFilled(Settings.AgreementInfo.Company) Then
		Object.Company = Settings.AgreementInfo.Company;
		If Not Object.Company = Settings.CurrentValuesStructure.Company Then
			CompanyOnChange(Object, Form, Settings.Module, , Settings);
		EndIf;
	EndIf;
EndProcedure

Procedure ChangeAccount(Object, Form, Settings) Export
	Object.Account = Settings.CompanyInfo;
	
	If Not Settings.CurrentValuesStructure.Account = Object.Account Then
		AccountOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;
EndProcedure

Procedure ChangeCashAccount(Object, Form, Settings) Export
	Object.CashAccount = Settings.CompanyInfo;
	
	If Not Settings.CurrentValuesStructure.CashAccount = Object.CashAccount Then
		AccountOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;
EndProcedure

Procedure ChangeShipmentConfirmationsBeforeSalesInvoice(Object, Form, Settings) Export	
	Object.ShipmentConfirmationsBeforeSalesInvoice
				= ServiceSystemServer.GetObjectAttribute(Object.Partner, "ShipmentConfirmationsBeforeSalesInvoice");
EndProcedure

Procedure ChangeDeliveryDate(Object, Form, Settings) Export
	Form.DeliveryDate = Settings.AgreementInfo.DeliveryDate;
	
	DeliveryDateOnChange(Object, Form);
EndProcedure

Procedure ChangeGoodsReceiptBeforePurchaseInvoice(Object, Form, Settings) Export	
	Object.GoodsReceiptBeforePurchaseInvoice 
				= ServiceSystemServer.GetObjectAttribute(Object.Partner, "GoodsReceiptBeforePurchaseInvoice");
EndProcedure

Procedure ChangeCurrency(Object, Form, Settings) Export
	Object.Currency = Settings.AgreementInfo.Currency;
EndProcedure

Procedure ChangePriceIncludeTax(Object, Form, Settings) Export
	Object.PriceIncludeTax = Settings.AgreementInfo.PriceIncludeTax;
	If Not Object.PriceIncludeTax = Settings.CurrentValuesStructure.PriceIncludeTax Then
		PriceIncludeTaxOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;  
EndProcedure

Procedure ChangeLegalName(Object, Form, Settings) Export
	Object.LegalName = Settings.PartnerInfo.LegalName;
	
	If Not Object.LegalName = Settings.CurrentValuesStructure.LegalName Then
		LegalNameOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;
EndProcedure

Procedure ChangeAgreement(Object, Form, Settings) Export
	Object.Agreement = Settings.PartnerInfo.Agreement;
	If Object.Agreement = Settings.CurrentValuesStructure.Agreement Then
		ChangePriceType(Object, Form, Settings);
		ChangeCurrency(Object, Form, Settings);
	Else
		AgreementOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;
EndProcedure

Procedure ChangeManagerSegment(Object, Form, Settings) Export	
	Object.ManagerSegment = Settings.PartnerInfo.ManagerSegment;
EndProcedure

Procedure ChangeStore(Object, Form, Settings) Export	
	// It Call Only If Table has attribute store
	Form.StoreBeforeChange = Form.Store;
	If ValueIsFilled(Settings.AgreementInfo.Store) Then
		Form.Store = Settings.AgreementInfo.Store;
	EndIf;
	
	StoreOnChange(Object, Form, Settings.Module, , Settings);
EndProcedure

Procedure UpdateStore(Object, Form, Settings) Export
	If Not ValueIsFilled(Form.Store) Then
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		Form.Store = DocumentsServer.GetCurrentStore(ObjectData);
	EndIf;
	Settings.Insert("NewStore", Form.Store);
	
	Form.Store = Form.StoreBeforeChange;
	
	If Settings.NewStore <> Form.StoreBeforeChange
		And Object.ItemList.Count() Then
		
		QuestionStructure = New Structure;
		QuestionStructure.Insert("Store"			, Form.Store);
		QuestionStructure.Insert("StoreBeforeChange", Form.StoreBeforeChange);
		QuestionStructure.Insert("NewStore"			, Settings.NewStore);
		QuestionStructure.Insert("ProcedureName"	, "StoreOnChangeContinue");
		QuestionStructure.Insert("QuestionText"		, StrTemplate(R()["QuestionToUser_009"], String(Settings.NewStore)));
		QuestionStructure.Insert("Action"			, "Stores");
		Settings.Questions.Add(QuestionStructure);
		Return;
	Else
		Form.Store = Settings.NewStore;
	EndIf;
	
	SetCurrentStore(Object, Form, Form.Store);
EndProcedure

Procedure UpdateCurrency(Object, Form, Settings) Export	
	If Not ValueIsFilled(Settings.AgreementInfo.PriceType) Then
		Return;
	EndIf;
	
	Filter = New Structure("Currency", Form.Currency);
	If Not Form.CurrentPriceType = Settings.AgreementInfo.PriceType Or 
								Not Object.ItemList.FindRows(Filter).Count() = Object.ItemList.Count() Then
		PriceTypeOnChange(Object, Form, Settings.Module, , Settings);
	EndIf;
EndProcedure

Procedure ChangeItemListStore(ItemList, Store) Export
	For Each Row In ItemList Do
		If Row.Store <> Store Then
			Row.Store = Store;
		EndIf;
	EndDo;
EndProcedure

Procedure DoTitleActions(Object, Form, Settings, Actions) Export
	For Each Action In Actions Do
		If Action.Key = "ChangeCompany" Then
			ChangeCompany(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeAccount" Then
			ChangeAccount(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeCashAccount" Then
			ChangeCashAccount(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangePriceType" Then
			ChangePriceType(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeCurrency" Then
			ChangeCurrency(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangePriceIncludeTax" Then
			ChangePriceIncludeTax(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeLegalName" Then
			ChangeLegalName(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeAgreement" Then
			ChangeAgreement(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeManagerSegment" Then
			ChangeManagerSegment(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeStore" Then
			ChangeStore(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "UpdateStore" Then
			UpdateStore(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "UpdateCurrency" Then
			UpdateCurrency(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeShipmentConfirmationsBeforeSalesInvoice" Then
			ChangeShipmentConfirmationsBeforeSalesInvoice(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeGoodsReceiptBeforePurchaseInvoice" Then
			ChangeGoodsReceiptBeforePurchaseInvoice(Object, Form, Settings);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeDeliveryDate" Then
			ChangeDeliveryDate(Object, Form, Settings);
			Continue;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region ItemListItemsEvents

Procedure ItemListItemOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	// If Item was chenged we hawe to clear itemkey
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	ItemListItemSettings = Module.ItemListItemSettings();
	
	Settings.Insert("ObjectAttributes", ItemListItemSettings.ObjectAttributes);
	Settings.Insert("CurrentRow", CurrentRow);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTabelActions(Object, Form, Settings, ItemListItemSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	Settings.CalculateSettings.Insert("UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure

Procedure ItemListItemKeyOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	// If Item was changed we have to clear itemkey
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	ItemListItemKeySettings = Module.ItemListItemKeySettings();
	Settings.Insert("ObjectAttributes", ItemListItemKeySettings.ObjectAttributes);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTabelActions(Object, Form, Settings, ItemListItemKeySettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	Settings.CalculateSettings.Insert("UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure

Procedure ItemListUnitOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	// If Item was changed we have to clear itemkey
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	ItemListUnitSettings = Module.ItemListUnitSettings();
	
	Settings.Insert("ObjectAttributes", ItemListUnitSettings.ObjectAttributes);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTabelActions(Object, Form, Settings, ItemListUnitSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	Settings.CalculateSettings.Insert("UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure

Procedure ItemListPriceTypeOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	// If Item was chenged we hawe to clear itemkey
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	ItemListUnitSettings = Module.ItemListUnitSettings();
	
	Settings.Insert("ObjectAttributes", ItemListUnitSettings.ObjectAttributes);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTabelActions(Object, Form, Settings, ItemListUnitSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	Settings.CalculateSettings.Insert("UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", Object.Date, Form.CurrentPriceType);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings);
EndProcedure

Procedure ItemListStoreOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export
	RowItemList = Form.Items.ItemList.CurrentData;
	
	If Not Item = Undefined And Not RowItemList = Undefined Then
		If Not ValueIsFilled(RowItemList.Store)
				And CatItemsServer.StoreMustHave(RowItemList.Item) Then
			RowItemList.Store = Form.CurrentStore;
		EndIf;
	EndIf;
	
	SetCurrentStore(Object, Form, Form.Items.ItemList.CurrentData.Store);
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, Object);
	DocumentsClientServer.FillStores(ObjectData, Form);
EndProcedure

#EndRegion

#Region PaymentListItemsEvents

Procedure PaymentListOnStartEdit(Object, Form, Item, NewRow, Clone) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Clone Then
		CurrentData.Key = New UUID();
		CalculateTotalAmount(Object, Form);
	EndIf;
EndProcedure

Procedure PaymentListPlaningTransactionBasisOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Object.TransactionType = PredefinedValue("Enum.IncomingPaymentTransactionType.CurrencyExchange") Or
		Object.TransactionType = PredefinedValue("Enum.OutgoingPaymentTransactionTypes.CurrencyExchange") Then
	
		If Not ValueIsFilled(CurrentData.PlaningTransactionBasis) Then
			CurrentData.PlaningTransactionBasis = Undefined;
		EndIf;
	EndIf;
EndProcedure


Procedure TransactionBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export 
	CurrentData = Form.Items.PaymentList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Document.CashTransferOrder.Form.AvailableChoiceForm";
	EndIf;
	
	If OpenSettings.FormFilters = Undefined Then
		OpenSettings.FormFilters = New Array;
		OpenSettings.FormFilters.Add(CreateFilterItem("Posted", True, DataCompositionComparisonType.Equal));
	EndIf;
	
	If OpenSettings.FormParameters = Undefined Then
		OpenSettings.FormParameters = New Structure();
		OpenSettings.FormParameters.Insert("FillingData", New Structure());
	EndIf;
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
	
EndProcedure

Procedure CalculateTotalAmount(Object, Form) Export

	Object.DocumentAmount = Object.PaymentList.Total("Amount");

EndProcedure

#EndRegion 

#Region DocumentsPurchasingAndSales

Procedure TableOnStartEdit(Object, Form, DataPath, Item, NewRow, Clone) Export
	CurrentData = Item.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not NewRow Then
		Return;
	ElsIf Clone Then
		Settings = New Structure();
		Settings.Insert("Rows", New Array());
		Settings.Rows.Add(CurrentData);
		Settings.Insert("CalculateSettings", New Structure());
		Settings.CalculateSettings.Insert("CalculateSpecialOffers");
		Settings.CalculateSettings.Insert("CalculateTax");
		
		DocumentsClient.ItemListCalculateRowsAmounts(Object, Form, Settings);
		Return;
	EndIf;
	
	// TODO: To do correct
	If CurrentData.Property("Quantity") Then	
		If CurrentData.Quantity = 0 Then
			CurrentData.Quantity = 1;
		EndIf;
	EndIf;
	
	If Not ValueIsFilled(CurrentData.PriceType) Then
		CurrentData.PriceType = Form.CurrentPriceType;
	EndIf;
	
	If CurrentData.Property("DeliveryDate")
		And Not ValueIsFilled(CurrentData.DeliveryDate) Then
		CurrentData.DeliveryDate = Form.CurrentDeliveryDate;
	EndIf;
	
	UserSettingsClient.TableOnStartEdit(Object, Form, DataPath, Item, NewRow, Clone);
	
EndProcedure

#EndRegion