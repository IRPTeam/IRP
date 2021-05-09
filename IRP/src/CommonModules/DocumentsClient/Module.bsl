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
		QuestionStructure.Insert("QuestionText", R().QuestionToUser_006);
		QuestionStructure.Insert("Action", "Currency");
		
		Settings.Questions.Add(QuestionStructure);

		Return;
	Else
		Form.Currency = Settings.AccountInfo.Currency;
	EndIf;
EndProcedure

#EndRegion

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export

	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	PartnerSettings = Module.PartnerSettings(Object, Form);
	If PartnerSettings.Property("PutServerDataToAddInfo") And PartnerSettings.PutServerDataToAddInfo Then
		Module.PartnerOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	PartnerSettings = Module.PartnerSettings(Object, Form, AddInfo);
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object, AddInfo);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	AgreementParameters = New Structure();
	AgreementParameters.Insert("Partner"		, Object.Partner);
	AgreementParameters.Insert("Agreement"		, Object.Agreement);
	AgreementParameters.Insert("CurrentDate"	, Object.Date);
	AgreementParameters.Insert("AgreementType"	, PartnerSettings.AgreementType);
	
	Settings.Insert("ObjectAttributes"	, PartnerSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, PartnerSettings.FormAttributes);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
	FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);
	
	PartnerInfo = New Structure();
	If ServerData = Undefined Then
		PartnerInfo.Insert("ManagerSegment"	, DocumentsServer.GetManagerSegmentByPartner(Object.Partner));
		PartnerInfo.Insert("LegalName"		, DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName));
		PartnerInfo.Insert("Agreement"      , DocumentsServer.GetAgreementByPartner(AgreementParameters));
	
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(PartnerInfo.Agreement);
	Else
		PartnerInfo.Insert("ManagerSegment"	, ServerData.ManagerSegmentByPartner);
		PartnerInfo.Insert("LegalName"		, ServerData.LegalNameByPartner);
		
		If PartnerSettings.AgreementType = ServerData.AgreementTypes_Customer Then
			PartnerInfo.Insert("Agreement" , ServerData.AgreementByPartner_Customer);
		ElsIf PartnerSettings.AgreementType = ServerData.AgreementTypes_Vendor Then
			PartnerInfo.Insert("Agreement" , ServerData.AgreementByPartner_Vendor);
		Else
			Raise "Not supported Agreement type";
		EndIf;
		
		AgreementInfo = ServerData.AgreementInfo;
	EndIf;	
	
	Settings.Insert("CurrentValuesStructure"	, CurrentValuesStructure);
	Settings.Insert("PartnerInfo"				, PartnerInfo);
	Settings.Insert("AgreementInfo"				, AgreementInfo);
	
	DoTitleActions(Object, Form, Settings, PartnerSettings.Actions, AddInfo);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings, AddInfo); 
	Else
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		Settings.Insert("Rows", Object.ItemList);
		Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
		CalculateTable(Object, Form, Settings, AddInfo);
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
	
	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "Partner");
		
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

Procedure AgreementOnChange(Object, Form, Module, Item = Undefined, Settings  = Undefined, AddInfo = Undefined) Export
	If TypeOf(Settings) = Type("Structure") And 
		Settings.Property("AgreementSettings") Then		
		AgreementSettings = Settings.AgreementSettings;
		Settings = Undefined;
	Else
		CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
		AgreementSettings = Module.AgreementSettings(Object, Form);
		If AgreementSettings.Property("PutServerDataToAddInfo") And AgreementSettings.PutServerDataToAddInfo Then
			Module.AgreementOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
		EndIf;
		AgreementSettings = Module.AgreementSettings(Object, Form, AddInfo);
	EndIf;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object, AddInfo);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	 
	Settings.Insert("ObjectAttributes"	, AgreementSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, AgreementSettings.FormAttributes);
	
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
	FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);
	
	If ServerData = Undefined Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	Else
		AgreementInfo = ServerData.AgreementInfo;
		CurrenciesClient.FullRefreshTable(Object, Form, AddInfo);
	EndIf;
	
	Settings.Insert("CurrentValuesStructure", CurrentValuesStructure);
	Settings.Insert("AgreementInfo", AgreementInfo);
	
	DoTitleActions(Object, Form, Settings, AgreementSettings.Actions, AddInfo);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings, AddInfo); 
	Else
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		
		Settings.Insert("Rows", Object.ItemList);
		Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
		CalculateTable(Object, Form, Settings, AddInfo);
	EndIf;
	
EndProcedure

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
	
	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "Agreement");
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

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

#Region ItemCurrency

Procedure CurrencyOnChange2(Object, Form, Module, Item = Undefined, Settings  = Undefined, AddInfo = Undefined) Export
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	CurrencySettings = Module.CurrencySettings(Object, Form);
	If CurrencySettings.Property("PutServerDataToAddInfo") And CurrencySettings.PutServerDataToAddInfo Then
		Module.CurrencyOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	CurrencySettings = Module.CurrencySettings(Object, Form, AddInfo);
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData <> Undefined Then
		CurrenciesClient.FullRefreshTable(Object, Form, AddInfo);
	EndIf;
EndProcedure

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined) Export	 
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

#EndRegion

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	CompanySettings = Module.CompanySettings(Object, Form);
	If CompanySettings.Property("PutServerDataToAddInfo") And CompanySettings.PutServerDataToAddInfo Then
		Module.CompanyOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	CompanySettings = Module.CompanySettings(Object, Form, AddInfo);
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	Settings.Insert("ObjectAttributes"	, CompanySettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, CompanySettings.FormAttributes);
	
	If ServerData = Undefined Then
		If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
			Form.Taxes_CreateFormControls();
		EndIf;
	Else
		CurrenciesClient.FullRefreshTable(Object, Form, AddInfo);
		If ServerData.RequireCallCreateTaxesFormControls Then
			ServerData.ArrayOfTaxInfo = Form.Taxes_CreateFormControls();
		EndIf;
	EndIf;
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
    	If ServerData = Undefined Then
	   		CompanyInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	    	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
    	Else
	   		CompanyInfo = ServerData.AgreementInfo;
	    	AgreementInfo = ServerData.AgreementInfo;
		EndIf;    		
	    Settings.Insert("CompanyInfo"				, CompanyInfo);
	    Settings.Insert("AgreementInfo"				, AgreementInfo);
    EndIf;
    
    DoTitleActions(Object, Form, Settings, CompanySettings.Actions, AddInfo);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	Settings.Insert("Rows", Object[CompanySettings.TableName]);
	If CompanySettings.Property("CalculateSettings") Then
		Settings.CalculateSettings = CompanySettings.CalculateSettings;
	Else
		Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	EndIf;
	
	CalculateTable(Object, Form, Settings, AddInfo);
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
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", 
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
	
	SetCurrentRow(Object, Form, Item, OpenSettings.FormParameters, "LegalName");
	
	OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure CompanyEditTextChange(Object, Form, Item, Text, StandardProcessing, 
										ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export
	
	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", True, ComparisonType.Equal));
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

Procedure SerialLotNumbersEditTextChange(Object, Form, Item, Text, StandardProcessing, 
										ArrayOfFilters = Undefined, AdditionalParameters = Undefined) Export
	
	If ArrayOfFilters = Undefined Then
		ArrayOfFilters = New Array();
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
		ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Inactive", True, ComparisonType.Equal));
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
		EditSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", 
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

Procedure StoreOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	StoreSettings = Module.StoreSettings(Object, Form);
	If StoreSettings.Property("PutServerDataToAddInfo") And StoreSettings.PutServerDataToAddInfo Then
		Module.StoreOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	StoreSettings = Module.StoreSettings(Object, Form, AddInfo);
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object, AddInfo);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	Settings.Insert("ObjectAttributes"	, StoreSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"	, StoreSettings.FormAttributes);
	
	If Not Settings.Property("AgreementInfo") Then
		If ServerData = Undefined Then
			AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		Else
			AgreementInfo = ServerData.AgreementInfo;
		EndIf;
		Settings.Insert("AgreementInfo", AgreementInfo);
	EndIf;

	DoTitleActions(Object, Form, Settings, StoreSettings.Actions, AddInfo);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings, AddInfo); 
	Else
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
	EndIf;
	
EndProcedure

Procedure StoreOnChangeContinue(Answer, AdditionalParameters, AddInfo = Undefined) Export
	If Answer = DialogReturnCode.Yes And AdditionalParameters.Property("Form") Then
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
		SetCurrentStore(Object, Form, Form.Store, AddInfo);
	ElsIf AdditionalParameters.Property("Form") Then
		Form = AdditionalParameters.Form;
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, AdditionalParameters.Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
	Else
		Return;
	EndIf;
EndProcedure

Procedure SetCurrentStore(Object, Form, Store, AddInfo = Undefined) Export
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

Procedure PriceTypeOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export 	
	If Object.ItemList.Count() > 0 Then
		
		ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
		
		If ServerData = Undefined Then
			AgreementInfo_PriceType_Presentation = String(Settings.AgreementInfo.PriceType); 
		Else
			AgreementInfo_PriceType_Presentation = ServerData.AgreementInfo_PriceType_Presentation;
		EndIf;
		
		QuestionStructure = New Structure();
		QuestionStructure.Insert("PriceType", AgreementInfo_PriceType_Presentation);
		QuestionStructure.Insert("CurrentPriceType", Form.CurrentPriceType);
		QuestionStructure.Insert("AgreementInfo", Settings.AgreementInfo);
		QuestionStructure.Insert("ProcedureName", "PriceTypeOnChangeContinue");
		QuestionStructure.Insert("QuestionText", StrTemplate(R().QuestionToUser_011, AgreementInfo_PriceType_Presentation));
		QuestionStructure.Insert("Action", "PriceTypes");
		
		Settings.Questions.Add(QuestionStructure);

		Return;
	Else
		Form.CurrentPriceType = Settings.AgreementInfo.PriceType;
	EndIf;
EndProcedure
	
Procedure PriceTypeOnChangeContinue(Answer, AdditionalParameters, AddInfo = Undefined) Export
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
    ItemListCalculateRowsAmounts(Object, Form, Settings, Undefined, AddInfo);
EndProcedure

Procedure SetCurrentPriceType(Form, PriceType) Export
	Form.CurrentPriceType = PriceType;
EndProcedure

Procedure ChangePriceType(Object, Form, Settings, AddInfo = Undefined) Export	
	If Not ValueIsFilled(Settings.AgreementInfo.PriceType) Then
		Return;
	EndIf;
	
	Filter = New Structure("PriceType", Form.CurrentPriceType);
	If Not Form.CurrentPriceType = Settings.AgreementInfo.PriceType
		Or Not Object.ItemList.FindRows(Filter).Count() = Object.ItemList.Count() Then
		PriceTypeOnChange(Object, Form, Settings.Module, , Settings, AddInfo);
	EndIf;
EndProcedure

#EndRegion

#Region PriceIncludeTaxEvents

Procedure PriceIncludeTaxOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	If Item = Undefined Then
		Return;
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	PriceIncludeTaxSettings = Module.PriceIncludeTaxSettings(Object, Form);
	If PriceIncludeTaxSettings.Property("PutServerDataToAddInfo") And PriceIncludeTaxSettings.PutServerDataToAddInfo Then
		Module.PriceIncludeTaxOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	PriceIncludeTaxSettings = Module.StoreSettings(Object, Form, AddInfo);
	
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	Settings.Insert("Rows", Object.ItemList);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	CalculateTable(Object, Form, Settings, AddInfo);
	
	Form.TaxAndOffersCalculated = True;
EndProcedure

#EndRegion

#Region GroupTitleDecorationsEvents

Procedure DecorationGroupTitleCollapsedPictureClick(Object = Undefined, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(, Form, True);
EndProcedure

Procedure DecorationGroupTitleCollapsedLabelClick(Object = Undefined, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(, Form, True);
EndProcedure

Procedure DecorationGroupTitleUncollapsedPictureClick(Object = Undefined, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(, Form, False);
EndProcedure

Procedure DecorationGroupTitleUncollapsedLabelClick(Object = Undefined, Form, Item) Export
	DocumentsClientServer.ChangeTitleCollapse(, Form, False);
EndProcedure

#EndRegion

#Region ItemDate

Procedure DateOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export

	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	DateSettings = Module.DateSettings(Object, Form);
	If DateSettings.Property("PutServerDataToAddInfo") And DateSettings.PutServerDataToAddInfo Then
		Module.DateOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	DateSettings = Module.DateSettings(Object, Form, AddInfo);
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	If Not Item = Undefined Then
		CacheObject = CommonFunctionsClientServer.GetStructureOfProperty(Object, AddInfo);
		CacheForm = New Structure("CurrentDeliveryDate, CurrentPartner, CurrentPriceType, CurrentStore, CurrentDate,
						|CurrentAgreement, DeliveryDate, PriceType, Store, StoreBeforeChange, TaxAndOffersCalculated");
		FillPropertyValues(CacheForm, Form);
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);	
	EndIf;
		
	Settings.Insert("ObjectAttributes" , DateSettings.ObjectAttributes);
	Settings.Insert("FormAttributes"   , DateSettings.FormAttributes);

	If ServerData = Undefined Then
		If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
			Form.Taxes_CreateFormControls();
		EndIf;
	Else
		CurrenciesClient.FullRefreshTable(Object, Form, AddInfo);
		If ServerData.RequireCallCreateTaxesFormControls Then
			ServerData.ArrayOfTaxInfo = Form.Taxes_CreateFormControls();
		EndIf;
	EndIf;
	
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
	
	For Each KeyValue In DateSettings.AfterActionsCalculateSettings Do
		Settings.CalculateSettings.Insert(KeyValue.Key, KeyValue.Value);
	EndDo;
	
	CurrentValuesStructure = CreateCurrentValuesStructure(Object, Settings.ObjectAttributes, Settings.FormAttributes);
	FillPropertyValues(CurrentValuesStructure, Form, Settings.FormAttributes);
	
	PartnerInfo = New Structure();
	If ServerData = Undefined Then
		PartnerInfo.Insert("ManagerSegment"	, DocumentsServer.GetManagerSegmentByPartner(Object.Partner));
		PartnerInfo.Insert("LegalName"		, DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName));
		
		AgreementParameters = New Structure();
		AgreementParameters.Insert("Partner"		, Object.Partner);
		AgreementParameters.Insert("Agreement"		, Object.Agreement);
		AgreementParameters.Insert("CurrentDate"	, Object.Date);
		AgreementParameters.Insert("AgreementType"	, DateSettings.AgreementType);
	
		PartnerInfo.Insert("Agreement" , DocumentsServer.GetAgreementByPartner(AgreementParameters));
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(PartnerInfo.Agreement);
	Else
		PartnerInfo.Insert("ManagerSegment"	, ServerData.ManagerSegmentByPartner);
		PartnerInfo.Insert("LegalName"		, ServerData.LegalNameByPartner);
		
		If DateSettings.AgreementType = ServerData.AgreementTypes_Customer Then
			PartnerInfo.Insert("Agreement" , ServerData.AgreementByPartner_Customer);
			AgreementInfo = ServerData.AgreementInfoByPartner_Customer;
		ElsIf DateSettings.AgreementType = ServerData.AgreementTypes_Vendor Then
			PartnerInfo.Insert("Agreement" , ServerData.AgreementByPartner_Vendor);
			AgreementInfo = ServerData.AgreementInfoByPartner_Vendor;
		Else
			Raise "Not supported Agreement type";
		EndIf;
	EndIf;
	
	Settings.Insert("CurrentValuesStructure"	, CurrentValuesStructure);
	Settings.Insert("PartnerInfo"				, PartnerInfo);
	Settings.Insert("AgreementInfo"				, AgreementInfo);
	
	DoTitleActions(Object, Form, Settings, DateSettings.Actions);
	
	#If Not MobileClient Then
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	#EndIf
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	If Settings.CalculateSettings.Property("UpdatePrice")
		And CalculationStringsClientServer.IsPricesChanged(Object, Form, Settings, AddInfo) Then
		QuestionStructure = New Structure;
		QuestionStructure.Insert("ProcedureName", "PricesChangedContinue");
		QuestionStructure.Insert("QuestionText"	, R().QuestionToUser_013);
		QuestionStructure.Insert("Action"		, "Prices");
		Settings.Questions.Add(QuestionStructure);
	EndIf;
	
	If Settings.Questions.Count() > 0  Then
		Settings.Insert("CacheObject", CacheObject);
		Settings.Insert("CacheForm", CacheForm);
		ShowUserQueryBox(Object, Form, Settings, AddInfo); 
	Else
		Settings.Insert("Rows", Object[DateSettings.TableName]);
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		CalculateTable(Object, Form, Settings, AddInfo);
	EndIf;
EndProcedure

Procedure ShowUserQueryBox(Object, Form, Settings, AddInfo = Undefined)
	
		NotifyDescription = New NotifyDescription("ShowUserQueryBoxContinue", 
						ThisObject,
						New Structure("Object, Form, Settings, AddInfo", Object, Form, Settings, AddInfo));
						
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
		
		If AdditionalParameters.Property("AddInfo") Then
			CurrenciesClient.SetSurfaceTable(Object, Form, AdditionalParameters.AddInfo);
		EndIf;
		
		Return;
	EndIf;
	
	QuestionSettings = New Structure();
	For Each Question In Settings.Questions Do
		QuestionSettings.Insert(Question.Action, Question);
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
		Parameters.Settings = QuestionSettings.Stores;
		Parameters.Rows = Rows;
		StoreOnChangeContinue(DialogReturnCode.Yes, Parameters, AdditionalParameters.AddInfo);
	EndIf;
		
	If Result.Property("UpdatePriceTypes") Then
		Parameters = New Structure("Object, Form, Settings, Rows");
		Parameters.Object = Object;
		Parameters.Form = Form;
		Parameters.Settings = QuestionSettings.PriceTypes;
		Parameters.Rows = Rows;
		PriceTypeOnChangeContinue(DialogReturnCode.Yes, Parameters, AdditionalParameters.AddInfo);
	EndIf;
		
	If Result.Property("UpdatePrices") Then
		
		Settings.CalculateSettings = New Structure();
		PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
		Settings.CalculateSettings.Insert("UpdatePrice",
					New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
					
		Settings.Insert("Rows", Rows);
		CalculateTable(Object, Form, Settings, AdditionalParameters.AddInfo);
	EndIf;
	
	If Result.Property("UpdatePaymentTerm") Then
		ServerData = CommonFunctionsClientServer.GetFromAddInfo(AdditionalParameters.AddInfo, "ServerData");
		ProcedureName = Undefined;
		For Each Question In Settings.Questions Do
			If Question.Action = "PaymentTerm" Then
				ProcedureName = Question.ProcedureName;
				Break;
			EndIf;
		EndDo;
		If ProcedureName = "FillPaymentTerms" Then
			Object.PaymentTerms.Clear();
			For Each Row In ServerData.PaymentTerms Do
				NewRow = Object.PaymentTerms.Add();
				FillPropertyValues(NewRow, Row);
			EndDo;
			CalculatePaymentTermDateAndAmount(Object, Form, AdditionalParameters.AddInfo);
		EndIf;
		If ProcedureName = "UpdatePaymentTerms" Then
			CalculatePaymentTermDateAndAmount(Object, Form, AdditionalParameters.AddInfo);
		EndIf;
	EndIf;
	
	If Result.Property("UpdateTaxRates") Then
		ArrayOfChangeTaxParameters = 
			CommonFunctionsClientServer.GetFromAddInfo(AdditionalParameters.AddInfo, "ArrayOfChangeTaxParameters");
			
		For Each i In ArrayOfChangeTaxParameters Do
			For Each Row In Object.ItemList Do
				Row[i.TaxInfo.Name] = Undefined;
			EndDo;
		EndDo;
		CalculationStringsClientServer.CalculateItemsRows(Object, Form, Object.ItemList,
				TaxesClient.GetCalculateRowsActions(),
				TaxesClient.GetArrayOfTaxInfo(Form));			
	EndIf;
	
	Settings.CalculateSettings = New Structure();
	Settings.Insert("Rows", Object.ItemList);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	CalculateTable(Object, Form, Settings, AdditionalParameters.AddInfo);
	Form.CurrentPartner = Object.Partner;
	Form.CurrentAgreement = Object.Agreement;
	Form.CurrentDate = Object.Date;
EndProcedure

#EndRegion

#Region PickUpItems

Procedure PickupItemsEnd(Result, AddInfo) Export
	If NOT ValueIsFilled(Result)
		OR Not AddInfo.Property("Object")
		OR Not AddInfo.Property("Form") Then
		Return;
	EndIf;
	
	Object 	= AddInfo.Object;
	Form 	= AddInfo.Form;	
	
	Settings = New Structure();
	Settings.Insert("Rows", New Array);
	CalculationSettings = New Structure;
	If Object.Property("Agreement") Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
		CalculationSettings.Insert("UpdatePrice",
					New Structure("Period, PriceType", PriceDate, AgreementInfo.PriceType));
		FilterString = "Item, ItemKey, Unit, Price";
	Else
		FilterString = "Item, ItemKey, Unit";
	EndIf;
	Settings.Insert("CalculateSettings", CalculationSettings);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	FilterStructure = New Structure(FilterString);
	
	UseSerialLotNumbers = Object.Property("SerialLotNumbers");
	
	For Each ResultElement In Result Do
		FillPropertyValues(FilterStructure, ResultElement);
		ExistingRows = Object.ItemList.FindRows(FilterStructure);
		If ExistingRows.Count() Then
			NewRow = False;
			Row = ExistingRows[0];
		Else
			NewRow = True;
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
		ElsIf Row.Property("PhysCount") And Row.Property("Difference") Then
			Row.PhysCount = Row.PhysCount + ResultElement.Quantity;
			Row.Difference = Row.PhysCount - Row.ExpCount;
		EndIf;
		
		If Row.Property("NetAmount") Then
			ItemListCalculateRowAmounts(Object, Form, Row);
		EndIf;	
		Settings.Rows.Add(Row);
		
		Form.Items.ItemList.CurrentRow = Row.GetID();
		DocumentsClient.TableOnStartEdit(Object, Form, "Object.ItemList", Form.Items.ItemList, NewRow, False);
		
		If UseSerialLotNumbers Then
			
			If ValueIsFilled(ResultElement.SerialLotNumber) Then
				SerialLotNumbersArray = New Array;
				SerialLotNumbers = New Structure("SerialLotNumber, Quantity");
				SerialLotNumbers.SerialLotNumber = ResultElement.SerialLotNumber;
				SerialLotNumbers.Quantity = 1;
				SerialLotNumbersArray.Add(SerialLotNumbers);
				SerialLotNumbersStructure = New Structure("RowKey, SerialLotNumbers", Row.Key, SerialLotNumbersArray);
				
				SerialLotNumberClient.AddNewSerialLotNumbers(SerialLotNumbersStructure, AddInfo, True, AddInfo);
			ElsIf ResultElement.UseSerialLotNumber Then
				Form.ItemListSerialLotNumbersPresentationStartChoice(Object.ItemList, Undefined, True);
			EndIf;
			SerialLotNumberClient.UpdateUseSerialLotNumber(Object, Form, AddInfo);
		EndIf;
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
	
	StoreArray = New Array;
	Try
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.Store) Then
			If StoreArray.Find(Row.Store) = Undefined Then
				StoreArray.Add(Row.Store);
			EndIf;
		EndIf;
	EndDo;
	
		If Not StoreArray.Count() And ValueIsFilled(Form.CurrentStore) Then
			StoreArray.Add(Form.CurrentStore);
		EndIf;
	Except
		StoreArray = New Array;
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
		DeliveryDatesFormattedArray = New Array();
		For Each Row In DeliveryDatesArray Do
			DeliveryDatesFormattedArray.Add(Format(Row, "DF=dd.MM.yy;"));
		EndDo;
		Form.DeliveryDate = Date(1, 1, 1);
		Form.Items.DeliveryDate.Tooltip = StrConcat(DeliveryDatesFormattedArray, "; ");
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

Function GetOpenSettingsForSelectItemWithNotServiceFilter(OpenSettings = Undefined, AddInfo = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;

	If OpenSettings.ArrayOfFilters = Undefined Then
		OpenSettings.ArrayOfFilters = New Array();
	EndIf;

	NotService = DocumentsClientServer.CreateFilterItem("ItemType.Type", 
							PredefinedValue("Enum.ItemTypes.Service"), DataCompositionComparisonType.NotEqual);
	OpenSettings.ArrayOfFilters.Add(NotService);
	Return OpenSettings;
EndFunction

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
	EndIf;

	DeletionMarkItem = DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual);
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

Procedure SearchByBarcode(Barcode, Object, Form, DocumentClientModule = Undefined, PriceType = Undefined, AddInfo = Undefined) Export
  If Not Form.Items.Find("ItemList") = Undefined Then
  	Form.CurrentItem = Form.Items.ItemList;
  EndIf;

  If AddInfo = Undefined Then
  	AddInfo = New Structure;
  EndIf;
  If DocumentClientModule = Undefined Then
    ClientModule = ThisObject;
  Else
    ClientModule = DocumentClientModule;
  EndIf;
  
  If PriceType <> Undefined Then
    AddInfo.Insert("PriceType", PriceType);
    If Object.Ref = Undefined Then
      AddInfo.Insert("PricePeriod", CurrentDate());
    Else
      AddInfo.Insert("PricePeriod", Object.Date);
    EndIf;
  EndIf;
  BarcodeClient.SearchByBarcode(Barcode, Object, Form, ClientModule, AddInfo);
EndProcedure

Procedure SearchByBarcodeEnd(Result, Parameters) Export
	If Parameters.FoundedItems.Count() Then
		DocumentModule = Parameters.ClientModule;
		DocumentModule.PickupItemsEnd(Parameters.FoundedItems, Parameters);
	Else
	    CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, StrConcat(Parameters.Barcodes, ",")));
	EndIf;
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

#Region DocUmentsStartChoice

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

Procedure SerialLotNumberStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.SerialLotNumbers.ChoiceForm";
	EndIf;
	
	If OpenSettings.FormFilters = Undefined Then
		FormFilters = New Array;
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

#Region ItemListItemsOnChange

Procedure ItemListCalculateRowAmounts_QuantityChange(Object, Form, CurrentData, Item, Module = Undefined, AddInfo = Undefined) Export	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	If Module <> Undefined Then
		Module.ItemListQuantityPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo);
	EndIf;
	ItemListCalculateRowAmounts(Object, Form, CurrentData, Module, AddInfo);
EndProcedure

Procedure ItemListCalculateRowAmounts_PriceChange(Object, Form, CurrentData, Item, Module = Undefined, AddInfo = Undefined) Export	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	If Module <> Undefined Then
		Module.ItemListPricePutServerDataToAddInfo(Object, Form, CurrentData, AddInfo);
	EndIf;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	CurrentData.PriceType = ServerData.PriceTypes_ManualPriceType;
	ItemListCalculateRowAmounts(Object, Form, CurrentData, Module, AddInfo);
EndProcedure

Procedure ItemListCalculateRowAmounts_TotalAmountChange(Object, Form, CurrentData, Item, Module = Undefined, AddInfo = Undefined) Export	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	If Module <> Undefined Then
		Module.ItemListTotalAmountPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo);
	EndIf;
	TaxesClient.CalculateReverseTaxOnChangeTotalAmount(Object, Form, CurrentData, AddInfo);
EndProcedure

Procedure ItemListCalculateRowAmounts_TaxAmountChange(Object, Form, CurrentData, Item, Module = Undefined, AddInfo = Undefined) Export	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	If Module <> Undefined Then
		Module.ItemListTaxAmountPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo);
	EndIf;
	ArrayOfTaxListRowsForChange = Object.TaxList.FindRows(New Structure("Key", CurrentData.Key));
	If ArrayOfTaxListRowsForChange.Count() <> 1 Then
		Raise "ArrayOfTaxListRowsForChange.Count() <> 1";
	EndIf;
	ArrayOfTaxListRows = New Array();
	For Each Row In ArrayOfTaxListRowsForChange Do
		NewRowTaxList = New Structure("Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount");
		FillPropertyValues(NewRowTaxList, Row);
		NewRowTaxList.ManualAmount = CurrentData.TaxAmount;
		ArrayOfTaxListRows.Add(NewRowTaxList);
	EndDo;
	TaxesClient.UpdateTaxList(Object, Form, CurrentData.Key, ArrayOfTaxListRows, AddInfo);
EndProcedure

Procedure ItemListCalculateRowAmounts_DontCalculateRowChange(Object, Form, CurrentData, Item, Module = Undefined, AddInfo = Undefined) Export	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	If Module <> Undefined Then
		Module.ItemListDontCalculateRowPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo);
	EndIf;
	ArrayForDelete = Object.TaxList.FindRows(New Structure("Key", CurrentData.Key));
	For Each ItemOfArrayForDelete In ArrayForDelete Do
		Object.TaxList.Delete(ItemOfArrayForDelete);
	EndDo;
	ItemListCalculateRowAmounts(Object, Form, CurrentData, Module, AddInfo);
EndProcedure

Procedure ItemListCalculateRowAmounts_TaxValueChange(Object, Form, CurrentData, Item, Module = Undefined, AddInfo = Undefined) Export	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	If Module <> Undefined Then
		Module.ItemListTotalAmountPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo);
	EndIf;
	TaxesClient.CalculateTaxOnChangeTaxValue(Object, Form, CurrentData, Item, AddInfo);
EndProcedure

Procedure ItemListCalculateRowAmounts(Object, Form, CurrentData, Module = Undefined, AddInfo = Undefined) Export
	Settings = New Structure();
	
	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentData);
	
	Settings.Insert("CalculateSettings");
	Settings.CalculateSettings = 
	CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings, , AddInfo);
EndProcedure

Procedure ItemListCalculateRowsAmounts(Object, Form, Settings, Item = Undefined, AddInfo = Undefined) Export
	ArrayOfTaxInfo = Undefined;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		If ServiceSystemClientServer.ObjectHasAttribute("TaxList", Object) Then
			ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
		EndIf;
	Else
		ArrayOfTaxInfo = ServerData.ArrayOfTaxInfo;
	EndIf;
	
	CalculationStringsClientServer.CalculateItemsRows(Object,
		Form,
		Settings.Rows,
		Settings.CalculateSettings,
		ArrayOfTaxInfo,
		AddInfo);
	If Not ArrayOfTaxInfo = Undefined Then	
		Form.TaxAndOffersCalculated = False;
	EndIf;
EndProcedure

Procedure CalculateTable(Object, Form, Settings, AddInfo = Undefined) Export
	Actions = New Structure();

	CalculationStringsClientServer.DoTableActions(Object, Form, Settings, Actions);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings, Undefined, AddInfo);
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

Procedure ChangeCompany(Object, Form, Settings, AddInfo = Undefined) Export
	If ValueIsFilled(Settings.AgreementInfo.Company) Then
		Object.Company = Settings.AgreementInfo.Company;
		If Not Object.Company = Settings.CurrentValuesStructure.Company Then
			CompanyOnChange(Object, Form, Settings.Module, , Settings, AddInfo);
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

Procedure ChangeCurrency(Object, Form, Settings, AddInfo = Undefined) Export
	Object.Currency = Settings.AgreementInfo.Currency;
	If Not Object.Currency = Settings.CurrentValuesStructure.Currency Then
		CurrencyOnChange2(Object, Form, Settings.Module, , Settings, AddInfo);
	EndIf; 	
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

Procedure ChangeAgreement(Object, Form, Settings, AddInfo = Undefined) Export
	Object.Agreement = Settings.PartnerInfo.Agreement;
	If Object.Agreement = Settings.CurrentValuesStructure.Agreement Then
		If Settings.CalculateSettings.Property("UpdatePrice") Then
			ChangePriceType(Object, Form, Settings);
		EndIf;
		ChangeCurrency(Object, Form, Settings);
	Else
		AgreementOnChange(Object, Form, Settings.Module, , Settings, AddInfo);
	EndIf;
EndProcedure

Procedure ChangeManagerSegment(Object, Form, Settings) Export	
	Object.ManagerSegment = Settings.PartnerInfo.ManagerSegment;
EndProcedure

Procedure ChangeStore(Object, Form, Settings) Export
	Form.StoreBeforeChange = Form.Store;
	If ValueIsFilled(Settings.AgreementInfo.Store) Then
		Form.Store = Settings.AgreementInfo.Store;
	EndIf;
	
	StoreOnChange(Object, Form, Settings.Module, , Settings);
EndProcedure

Procedure UpdateStore(Object, Form, Settings, AddInfo = Undefined) Export
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
		QuestionStructure.Insert("QuestionText"		, StrTemplate(R().QuestionToUser_009, String(Settings.NewStore)));
		QuestionStructure.Insert("Action"			, "Stores");
		Settings.Questions.Add(QuestionStructure);
		Return;
	Else
		Form.Store = Settings.NewStore;
	EndIf;
	
	SetCurrentStore(Object, Form, Form.Store, AddInfo);
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

Procedure ChangePaymentTerm(Object, Form, Settings, AddInfo = Undefined) Export
	If Not ValueIsFilled(Object.Agreement) Then
		Return;
	EndIf;
	
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	If Not Object.PaymentTerms.Count() Then
		For Each Row In ServerData.PaymentTerms Do
			NewRow = Object.PaymentTerms.Add();
			FillPropertyValues(NewRow, Row);
		EndDo;
		CalculatePaymentTermDateAndAmount(Object, Form);
	Else
		QuestionStructure = New Structure;
		QuestionStructure.Insert("ProcedureName" , "FillPaymentTerms");
		QuestionStructure.Insert("QuestionText"  , R().QuestionToUser_019);
		QuestionStructure.Insert("Action"        , "PaymentTerm");
		Settings.Questions.Add(QuestionStructure);
	EndIf;
EndProcedure

Procedure UpdatePaymentTerm(Object, Form, Settings, AddInfo = Undefined) Export
	If Object.PaymentTerms.Count() Then
		QuestionStructure = New Structure;
		QuestionStructure.Insert("ProcedureName" , "UpdatePaymentTerms");
		QuestionStructure.Insert("QuestionText"  , R().QuestionToUser_019);
		QuestionStructure.Insert("Action"        , "PaymentTerm");
		Settings.Questions.Add(QuestionStructure);
	EndIf;
EndProcedure

Procedure ChangeTaxRates(Object, Form, Settings, AddInfo = Undefined) Export
	If Not ValueIsFilled(Object.Agreement) Then
		Return;
	EndIf;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	If ServerData = Undefined Then
		ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
	Else
		ArrayOfTaxInfo = ServerData.ArrayOfTaxInfo;
	EndIf;
	
	ArrayOfCurrentTaxInfo = New Array();
	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		
		TaxTypeIsRate = True;
		If ItemOfTaxInfo.Property("TaxTypeIsRate") Then
			TaxTypeIsRate = ItemOfTaxInfo.TaxTypeIsRate;
		Else
			TaxTypeIsRate = (ItemOfTaxInfo.Type = PredefinedValue("Enum.TaxType.Rate"));
		EndIf;
		
		If TaxTypeIsRate Then
			ArrayOfCurrentTaxRates = New Array();
			For Each RowItemList In Object.ItemList Do
				SelectedTaxRate = RowItemList[ItemOfTaxInfo.Name];
				If ValueIsFilled(SelectedTaxRate) Then
					ArrayOfCurrentTaxRates.Add(SelectedTaxRate);
				EndIf;
			EndDo;
			
			CurrentTaxInfo = New Structure();
			CurrentTaxInfo.Insert("Date"                  , Object.Date);
			CurrentTaxInfo.Insert("Company"               , Object.Company);
			CurrentTaxInfo.Insert("Agreement"             , Object.Agreement);
			CurrentTaxInfo.Insert("Tax"                   , ItemOfTaxInfo.Tax);
			CurrentTaxInfo.Insert("ArrayOfCurrentTaxRates", ArrayOfCurrentTaxRates);
			CurrentTaxInfo.Insert("TaxInfo"               , ItemOfTaxInfo);
			
			ArrayOfCurrentTaxInfo.Add(CurrentTaxInfo);
		EndIf;
	EndDo;
	
	ArrayOfChangeTaxParameters = New Array();
	
	For Each ItemOfCurrentTaxInfo In ArrayOfCurrentTaxInfo Do
		ArrayOfTaxRates = New Array();
		If ItemOfCurrentTaxInfo.TaxInfo.Property("ArrayOfTaxRatesForAgreement") Then
			ArrayOfTaxRates = ItemOfCurrentTaxInfo.TaxInfo.ArrayOfTaxRatesForAgreement;
		Else	
			ArrayOfTaxRates = TaxesServer.GetTaxRatesForAgreement(ItemOfCurrentTaxInfo);
		EndIf;
		If Not ArrayOfTaxRates.Count() Then
			If ItemOfCurrentTaxInfo.TaxInfo.Property("ArrayOfTaxRatesForCompany") Then
				ArrayOfTaxRates = ItemOfCurrentTaxInfo.TaxInfo.ArrayOfTaxRatesForCompany;
			Else	
				ArrayOfTaxRates = TaxesServer.GetTaxRatesForCompany(ItemOfCurrentTaxInfo);
			EndIf;
		EndIf;
		
		NewTaxRate = Undefined;
		If ArrayOfTaxRates.Count() Then
			NewTaxRate = ArrayOfTaxRates[0].TaxRate;
		EndIf;
		For Each CurrentTaxRate In ItemOfCurrentTaxInfo.ArrayOfCurrentTaxRates Do
			If CurrentTaxRate <> NewTaxRate Then
				ArrayOfChangeTaxParameters.Add(ItemOfCurrentTaxInfo);
				Break;
			EndIf;
		EndDo;
	EndDo;
	
	If ArrayOfChangeTaxParameters.Count() Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ArrayOfChangeTaxParameters", ArrayOfChangeTaxParameters);
		QuestionStructure = New Structure;
		QuestionStructure.Insert("ProcedureName" , "ChangeTaxRates");
		QuestionStructure.Insert("QuestionText"  , R().QuestionToUser_004);
		QuestionStructure.Insert("Action"        , "TaxRates");
		Settings.Questions.Add(QuestionStructure);
	EndIf;
EndProcedure

Procedure CalculatePaymentTermDateAndAmount(Object, Form, AddInfo = Undefined) Export
	If Not Object.PaymentTerms.Count() Then
		Return;
	EndIf;
	TotalAmount = Object.ItemList.Total("TotalAmount");
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
EndProcedure

Procedure DoTitleActions(Object, Form, Settings, Actions, AddInfo = Undefined) Export
	For Each Action In Actions Do
		If Action.Key = "ChangeCompany" Then
			ChangeCompany(Object, Form, Settings, AddInfo);
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
			ChangePriceType(Object, Form, Settings, AddInfo);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeCurrency" Then
			ChangeCurrency(Object, Form, Settings, AddInfo);
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
			ChangeAgreement(Object, Form, Settings, AddInfo);
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
			UpdateStore(Object, Form, Settings, AddInfo);
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
		
		If Action.Key = "ChangePaymentTerm" Then
			ChangePaymentTerm(Object, Form, Settings, AddInfo);
			Continue;
		EndIf;
		
		If Action.Key = "UpdatePaymentTerm" Then
			UpdatePaymentTerm(Object, Form, Settings, AddInfo);
			Continue;
		EndIf;
		
		If Action.Key = "ChangeTaxRates" Then
			ChangeTaxRates(Object, Form, Settings, AddInfo);
			Continue;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region ItemListItemsEvents

Procedure ItemListItemOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	
	ItemListName = "ItemList";
	If Settings <> Undefined
		And Settings.Property("ItemListName") Then
		ItemListName = Settings.ItemListName; 			
	EndIf;
	CurrentRow = Form.Items[ItemListName].CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	ItemListItemSettings = Module.ItemListItemSettings(Object, Form);
	If ItemListItemSettings.Property("PutServerDataToAddInfo") And ItemListItemSettings.PutServerDataToAddInfo Then
		Module.ItemListItemOnChangePutServerDataToAddInfo(Object, Form, CurrentRow, AddInfo);
	EndIf;
	ItemListItemSettings = Module.ItemListItemSettings(Object, Form, AddInfo);
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	Settings.Insert("ObjectAttributes", ItemListItemSettings.ObjectAttributes);
	Settings.Insert("CurrentRow", CurrentRow);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTableActions(Object, Form, Settings, ItemListItemSettings.Actions, AddInfo);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	For Each AfterActionsCalculateSettingsItem In ItemListItemSettings.AfterActionsCalculateSettings Do
		Settings.CalculateSettings.Insert(AfterActionsCalculateSettingsItem.Key, AfterActionsCalculateSettingsItem.Value);
	EndDo;
	
	ItemListCalculateRowsAmounts(Object, Form, Settings, Undefined, AddInfo);
EndProcedure

Procedure ItemListItemKeyOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	
	ItemListName = "ItemList";
	If Settings <> Undefined
		And Settings.Property("ItemListName") Then
		ItemListName = Settings.ItemListName; 			
	EndIf;
	CurrentRow = Form.Items[ItemListName].CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	ItemListItemKeySettings = Module.ItemListItemKeySettings(Object, Form);
	If ItemListItemKeySettings.Property("PutServerDataToAddInfo") And ItemListItemKeySettings.PutServerDataToAddInfo Then
		Module.ItemListItemKeyOnChangePutServerDataToAddInfo(Object, Form, CurrentRow, AddInfo);
	EndIf;
	ItemListItemKeySettings = Module.ItemListItemKeySettings(Object, Form, AddInfo);
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	Settings.Insert("ObjectAttributes", ItemListItemKeySettings.ObjectAttributes);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTableActions(Object, Form, Settings, ItemListItemKeySettings.Actions, AddInfo);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	For Each AfterActionsCalculateSettingsItem In ItemListItemKeySettings.AfterActionsCalculateSettings Do
		Settings.CalculateSettings.Insert(AfterActionsCalculateSettingsItem.Key, AfterActionsCalculateSettingsItem.Value);
	EndDo;
	
	ItemListCalculateRowsAmounts(Object, Form, Settings, Undefined, AddInfo);
EndProcedure

Procedure ItemListUnitOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	ItemListUnitSettings = Module.ItemListUnitSettings(Object, Form);
	If ItemListUnitSettings.Property("PutServerDataToAddInfo") And ItemListUnitSettings.PutServerDataToAddInfo Then
		Module.ItemListUnitOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	ItemListUnitSettings = Module.ItemListUnitSettings(Object, Form, AddInfo);
		
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	// If Item was changed we have to clear itemkey
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	Settings.Insert("ObjectAttributes", ItemListUnitSettings.ObjectAttributes);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTableActions(Object, Form, Settings, ItemListUnitSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	Settings.CalculateSettings.Insert("UpdatePrice");
	PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType);

	ItemListCalculateRowsAmounts(Object, Form, Settings, Undefined, AddInfo);
EndProcedure

Procedure ItemListPriceTypeOnChange(Object, Form, Module, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	
	CommonFunctionsClientServer.DeleteFromAddInfo(AddInfo, "ServerData");
	ItemListPriceTypeSettings = Module.ItemListPriceTypeSettings(Object, Form);
	If ItemListPriceTypeSettings.Property("PutServerDataToAddInfo") And ItemListPriceTypeSettings.PutServerDataToAddInfo Then
		Module.ItemListPriceTypeOnChangePutServerDataToAddInfo(Object, Form, AddInfo);
	EndIf;
	ItemListPriceTypeSettings = Module.ItemListPriceTypeSettings(Object, Form, AddInfo);
	
	CurrentRow = Form.Items.ItemList.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	If Settings = Undefined Then
		Settings = GetSettingsStructure(Module);
	EndIf;
	
	Settings.Insert("ObjectAttributes", ItemListPriceTypeSettings.ObjectAttributes);

	Settings.Insert("Rows", New Array());
	Settings.Rows.Add(CurrentRow);
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	CalculationStringsClientServer.DoTableActions(Object, Form, Settings, ItemListPriceTypeSettings.Actions);
	
	If Item = Undefined Then
		Return;
	EndIf;
	
	Settings.CalculateSettings.Insert("UpdatePrice");
	Settings.CalculateSettings.UpdatePrice = New Structure("Period, PriceType", 
	CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date), Form.CurrentPriceType);
	
	ItemListCalculateRowsAmounts(Object, Form, Settings, Undefined, AddInfo);
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

Procedure TableOnStartEdit(Object, Form, DataPath, Item, NewRow, Clone, AddInfo = Undefined) Export
	CurrentData = Item.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Clone Then
		SerialLotNumberClient.PresentationClearingOnCopy(Object, Form, Item);
	EndIf;
	
	If Not NewRow Then
		Return;
	ElsIf Clone Then
		If CurrentData.Property("DontCalculateRow") Then	
			CurrentData.DontCalculateRow = False;
		EndIf;
	
		ItemListCalculateRowAmounts(Object, Form, CurrentData, Undefined, AddInfo);
		Return;
	EndIf;
	
	If CurrentData.Property("Quantity") Then	
		If CurrentData.Quantity = 0 Then
			CurrentData.Quantity = 1;
		EndIf;
	EndIf;
	
	If CurrentData.Property("PriceType") Then
		If Not ValueIsFilled(CurrentData.PriceType) Then
			CurrentData.PriceType = Form.CurrentPriceType;
		EndIf;
	EndIf;
	
	If CurrentData.Property("DeliveryDate")
		And Not ValueIsFilled(CurrentData.DeliveryDate) Then
		CurrentData.DeliveryDate = Form.CurrentDeliveryDate;
	EndIf;
	
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, New Structure("CalculateQuantityInBaseUnit"));
	
	UserSettingsClient.TableOnStartEdit(Object, Form, DataPath, Item, NewRow, Clone);
EndProcedure

#EndRegion

#Region PrepareServerData

Procedure CommonParametersToServer(Object, Form, ParametersToServer, AddInfo = Undefined)
	
	If Object.Property("Currencies") Then
		ArrayOfMovementsTypes = New Array;
		For Each Row In Object.Currencies Do
			ArrayOfMovementsTypes.Add(Row.MovementType);
		EndDo;
		ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	EndIf;
	If Object.Property("ItemList") Then
		GetItemKeysWithSerialLotNumbers(Object, ParametersToServer);
	EndIf;

	
	TaxesCacheParameters = New Structure();
	TaxesCacheParameters.Insert("Cache"   , Form.TaxesCache); 
	TaxesCacheParameters.Insert("Ref"     , Object.Ref);
	TaxesCacheParameters.Insert("Date"    , Object.Date);
	TaxesCacheParameters.Insert("Company" , Object.Company);
	ParametersToServer.Insert("TaxesCache", TaxesCacheParameters);
	
	ParametersToServer.Insert("GetAgreementTypes_Vendor");
	ParametersToServer.Insert("GetPurchaseOrder_EmptyRef");
	ParametersToServer.Insert("GetAgreementTypes_Customer");
	ParametersToServer.Insert("GetSalesOrder_EmptyRef");
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
	ParametersToServer.Insert("GetPurchaseReturnOrder_EmptyRef");
	ParametersToServer.Insert("GetSalesReturnOrder_EmptyRef");	
EndProcedure

Procedure GetItemKeysWithSerialLotNumbers(Object, ParametersToServer) Export
	ArrayOfItemKeys = New Array;
	For Each Row In Object.ItemList Do
		ArrayOfItemKeys.Add(Row.ItemKey);
	EndDo;
	ParametersToServer.Insert("GetItemKeysWithSerialLotNumbers", ArrayOfItemKeys);
EndProcedure

#Region FormEvents

Procedure OnOpenPutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "OnOpen";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfCurrenciesRowsParameters = New Structure();
	ArrayOfCurrenciesRowsParameters.Insert("Agreement" , Object.Agreement);
	ArrayOfCurrenciesRowsParameters.Insert("Date"      , Object.Date);
	ArrayOfCurrenciesRowsParameters.Insert("Company"   , Object.Company);
	ArrayOfCurrenciesRowsParameters.Insert("Currency"  , Object.Currency);
	ArrayOfCurrenciesRowsParameters.Insert("UUID"      , Form.UUID);
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", ArrayOfCurrenciesRowsParameters);
	
	AgreementInfoParameters = New Structure();
	AgreementInfoParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetAgreementInfo", AgreementInfoParameters);	
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

Procedure AfterWriteAtClientPutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "AfterWrite";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
			
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

#EndRegion

#Region ItemListItemsEvents

Procedure ItemListSelectionPutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListSelection";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
			
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#Region Item

Procedure ItemListItemOnChangePutServerDataToAddInfo(Object, Form, CurrentRow, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListItem";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfTaxRatesParameters = New Structure();
	ArrayOfTaxRatesParameters.Insert("Agreement", Object.Agreement);
	ArrayOfTaxRatesParameters.Insert("ItemKey"  , CurrentRow.ItemKey);
	ParametersToServer.TaxesCache.Insert("GetArrayOfTaxRates" , ArrayOfTaxRatesParameters);
	
	ItemKeyByItemParameters = New Structure();
	ItemKeyByItemParameters.Insert("Item", CurrentRow.Item);
	ParametersToServer.Insert("GetItemKeyByItem", ItemKeyByItemParameters);
		
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

#EndRegion

#Region ItemKey

Procedure ItemListItemKeyOnChangePutServerDataToAddInfo(Object, Form, CurrentRow, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListItemKey";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
		
	ArrayOfTaxRatesParameters = New Structure();
	ArrayOfTaxRatesParameters.Insert("Agreement", Object.Agreement); 
	ArrayOfTaxRatesParameters.Insert("ItemKey"  , CurrentRow.ItemKey);
	ParametersToServer.TaxesCache.Insert("GetArrayOfTaxRates" , ArrayOfTaxRatesParameters);
	
	ItemUnitInfoParameters = New Structure();
	ItemUnitInfoParameters.Insert("ItemKey", CurrentRow.ItemKey);
	ParametersToServer.Insert("GetItemUnitInfo", ItemUnitInfoParameters);
		
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

#EndRegion

Procedure ItemListSerialLotNumbersPutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListSerialLotNumbersPresentation";
	ParametersToServer = New Structure();
	GetItemKeysWithSerialLotNumbers(Object, ParametersToServer);
			
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);	
EndProcedure

#Region PriceType

Procedure ItemListPriceTypeOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListPriceType";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
		
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

#EndRegion

#Region Unit

Procedure ItemListUnitOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListUnit";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
		
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

#EndRegion

#Region Quantity

Procedure ItemListQuantityPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListQuantity";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region Price

Procedure ItemListPricePutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListPrice";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region TotalAmount

Procedure ItemListTotalAmountPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListTotalAmount";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region TaxAmount

Procedure ItemListTaxAmountPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListTaxAmount";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region DontCalculateRow

Procedure ItemListDontCalculateRowPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "DontCalculateRow";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region TaxValue

Procedure ItemListTaxValuePutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListTaxValue";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region ExpenseAndRevenue

Procedure ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings = Undefined) Export
	If  OpenSettings = Undefined Then
		OpenSettings = GetOpenSettingsStructure();
	EndIf;
	
	StandardProcessing = False;
	
	If OpenSettings.FormName = Undefined Then
		OpenSettings.FormName = "Catalog.ExpenseAndRevenueTypes.ChoiceForm";
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

Procedure ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined,	AdditionalParameters = Undefined) Export
	
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

#EndRegion

#Region ItemPartner

Procedure PartnerOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Partner";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfCurrenciesRowsParameters = New Structure();
	ArrayOfCurrenciesRowsParameters.Insert("Agreement" , Object.Agreement);
	ArrayOfCurrenciesRowsParameters.Insert("Date"      , Object.Date);
	ArrayOfCurrenciesRowsParameters.Insert("Company"   , Object.Company);
	ArrayOfCurrenciesRowsParameters.Insert("Currency"  , Object.Currency);
	ArrayOfCurrenciesRowsParameters.Insert("UUID"      , Form.UUID);
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", ArrayOfCurrenciesRowsParameters);
	
	ArrayOfTaxRatesParameters = New Structure();
	ArrayOfTaxRatesParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.TaxesCache.Insert("GetArrayOfTaxRates", ArrayOfTaxRatesParameters);
	
	AgreementInfoParameters = New Structure();
	AgreementInfoParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetAgreementInfo", AgreementInfoParameters);	
	
	ManagerSegmentByPartnerParameters = New Structure();
	ManagerSegmentByPartnerParameters.Insert("Partner", Object.Partner);
	ParametersToServer.Insert("GetManagerSegmentByPartner", ManagerSegmentByPartnerParameters);
	
	LegalNameByPartnerParameters = New Structure();
	LegalNameByPartnerParameters.Insert("Partner"     , Object.Partner);
	LegalNameByPartnerParameters.Insert("LegalName"   , Object.LegalName);
	ParametersToServer.Insert("GetLegalNameByPartner" , LegalNameByPartnerParameters);
	
	AgreementByPartnerParameters = New Structure();
	AgreementByPartnerParameters.Insert("Partner"           , Object.Partner);
	AgreementByPartnerParameters.Insert("Agreement"         , Object.Agreement);
	AgreementByPartnerParameters.Insert("Date"              , Object.Date);
	ParametersToServer.Insert("GetAgreementByPartner", AgreementByPartnerParameters);
	
	MetaDataStructureParameters = New Structure();
	MetaDataStructureParameters.Insert("Ref", Object.Ref);	
	ParametersToServer.Insert("GetMetaDataStructure", MetaDataStructureParameters);
	
	PaymentTermsParameters = New Structure();
	PaymentTermsParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetPaymentTerms", PaymentTermsParameters);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure AgreementOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Agreement";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfCurrenciesRowsParameters = New Structure();
	ArrayOfCurrenciesRowsParameters.Insert("Agreement" , Object.Agreement);
	ArrayOfCurrenciesRowsParameters.Insert("Date"      , Object.Date);
	ArrayOfCurrenciesRowsParameters.Insert("Company"   , Object.Company);
	ArrayOfCurrenciesRowsParameters.Insert("Currency"  , Object.Currency);
	ArrayOfCurrenciesRowsParameters.Insert("UUID"      , Form.UUID);
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", ArrayOfCurrenciesRowsParameters);
	
	ArrayOfTaxRatesParameters = New Structure();
	ArrayOfTaxRatesParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.TaxesCache.Insert("GetArrayOfTaxRates", ArrayOfTaxRatesParameters);
	
	MetaDataStructureParameters = New Structure();
	MetaDataStructureParameters.Insert("Ref", Object.Ref);	
	ParametersToServer.Insert("GetMetaDataStructure", MetaDataStructureParameters);
	
	AgreementInfoParameters = New Structure();
	AgreementInfoParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetAgreementInfo", AgreementInfoParameters);	
	
	PaymentTermsParameters = New Structure();
	PaymentTermsParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetPaymentTerms", PaymentTermsParameters);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#Region ItemCurrency

Procedure CurrencyOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Currency";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfCurrenciesRowsParameters = New Structure();
	ArrayOfCurrenciesRowsParameters.Insert("Agreement" , Object.Agreement);
	ArrayOfCurrenciesRowsParameters.Insert("Date"      , Object.Date);
	ArrayOfCurrenciesRowsParameters.Insert("Company"   , Object.Company);
	ArrayOfCurrenciesRowsParameters.Insert("Currency"  , Object.Currency);
	ArrayOfCurrenciesRowsParameters.Insert("UUID"      , Form.UUID);
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", ArrayOfCurrenciesRowsParameters);
	
	AgreementInfoParameters = New Structure();
	AgreementInfoParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetAgreementInfo", AgreementInfoParameters);	
	
	PaymentTermsParameters = New Structure();
	PaymentTermsParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetPaymentTerms", PaymentTermsParameters);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#Region ItemCompany

Procedure CompanyOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Company";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfCurrenciesRowsParameters = New Structure();
	ArrayOfCurrenciesRowsParameters.Insert("Agreement" , Object.Agreement);
	ArrayOfCurrenciesRowsParameters.Insert("Date"      , Object.Date);
	ArrayOfCurrenciesRowsParameters.Insert("Company"   , Object.Company);
	ArrayOfCurrenciesRowsParameters.Insert("Currency"  , Object.Currency);
	ArrayOfCurrenciesRowsParameters.Insert("UUID"      , Form.UUID);
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", ArrayOfCurrenciesRowsParameters);
	
	AgreementInfoParameters = New Structure();
	AgreementInfoParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetAgreementInfo", AgreementInfoParameters);	
	
	PaymentTermsParameters = New Structure();
	PaymentTermsParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetPaymentTerms", PaymentTermsParameters);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#Region ItemStore

Procedure StoreOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Store";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);	
	
	MetaDataStructureParameters = New Structure();
	MetaDataStructureParameters.Insert("Ref", Object.Ref);	
	ParametersToServer.Insert("GetMetaDataStructure", MetaDataStructureParameters);
	
	AgreementInfoParameters = New Structure();
	AgreementInfoParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetAgreementInfo", AgreementInfoParameters);	
			
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#Region ItemPriceIncludeTax

Procedure PriceIncludeTaxOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "PriceIncludeTax";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);	
		
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#Region ItemDate

Procedure DateOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Date";
	ParametersToServer = New Structure();
	CommonParametersToServer(Object, Form, ParametersToServer, AddInfo);
	
	ArrayOfCurrenciesRowsParameters = New Structure();
	ArrayOfCurrenciesRowsParameters.Insert("Agreement" , Object.Agreement);
	ArrayOfCurrenciesRowsParameters.Insert("Date"      , Object.Date);
	ArrayOfCurrenciesRowsParameters.Insert("Company"   , Object.Company);
	ArrayOfCurrenciesRowsParameters.Insert("Currency"  , Object.Currency);
	ArrayOfCurrenciesRowsParameters.Insert("UUID"      , Form.UUID);
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", ArrayOfCurrenciesRowsParameters);
		
	MetaDataStructureParameters = New Structure();
	MetaDataStructureParameters.Insert("Ref", Object.Ref);	
	ParametersToServer.Insert("GetMetaDataStructure", MetaDataStructureParameters);
	
	ManagerSegmentByPartnerParameters = New Structure();
	ManagerSegmentByPartnerParameters.Insert("Partner", Object.Partner);
	ParametersToServer.Insert("GetManagerSegmentByPartner", ManagerSegmentByPartnerParameters);
	
	LegalNameByPartnerParameters = New Structure();
	LegalNameByPartnerParameters.Insert("Partner"     , Object.Partner);
	LegalNameByPartnerParameters.Insert("LegalName"   , Object.LegalName);
	ParametersToServer.Insert("GetLegalNameByPartner" , LegalNameByPartnerParameters);
	
	AgreementByPartnerParameters = New Structure();
	AgreementByPartnerParameters.Insert("Partner"           , Object.Partner);
	AgreementByPartnerParameters.Insert("Agreement"         , Object.Agreement);
	AgreementByPartnerParameters.Insert("Date"              , Object.Date);
	AgreementByPartnerParameters.Insert("WithAgreementInfo" , True);
	ParametersToServer.Insert("GetAgreementByPartner", AgreementByPartnerParameters);
	
	PaymentTermsParameters = New Structure();
	PaymentTermsParameters.Insert("Agreement", Object.Agreement);
	ParametersToServer.Insert("GetPaymentTerms", PaymentTermsParameters);
	
	ServerData = DocumentsServer.PrepareServerData(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

#EndRegion

#EndRegion

#Region SpecialOffersInReturns

Procedure RecalculateSpecialOffersOnChangeQuantity(Object, Form, CurrentData, AddInfo = Undefined) Export
	ArrayOfSpecialOffersInCache = Form.SpecialOffersCache.FindRows(New Structure("Key", CurrentData.Key));
	For Each ItemOfSpecialOffersInCache In ArrayOfSpecialOffersInCache Do
		SpecialOfferAmount = 0;
		If CurrentData.Quantity = ItemOfSpecialOffersInCache.Quantity Then
			SpecialOfferAmount = ItemOfSpecialOffersInCache.Amount;
		Else
			SpecialOfferAmount = 
			(ItemOfSpecialOffersInCache.Amount / ItemOfSpecialOffersInCache.Quantity) * CurrentData.Quantity;
		EndIf;
		ArrayOfSpecialOffers = 
		Object.SpecialOffers.FindRows(New Structure("Key, Offer", CurrentData.Key, ItemOfSpecialOffersInCache.Offer));
		For Each ItemOfSpecialOffers In ArrayOfSpecialOffers Do
			ItemOfSpecialOffers.Amount = SpecialOfferAmount;
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#Region Utility

Procedure ShowRowKey(Form) Export
	ItemNames = "ItemListKey, SpecialOffersKey,
	|ItemListRowsKey,
	|ResultsTable,
	|RowIDInfo,
	|ShipmentConfirmationsTreeKey, ShipmentConfirmationsTreeBasisKey,
	|GoodsReceiptsTreeKey, GoodsReceiptsTreeBasisKey,
	|BasisesTreeBasis, BasisesTreeBasisUnit, BasisesTreeQuantityInBaseUnit, BasisesTreeKey,
	|BasisesTreeRowID, BasisesTreeRowRef, BasisesTreeBasisKey, BasisesTreeCurrentStep,
	|ResultsTreeBasis, ResultsTreeBasisUnit, ResultsTreeQuantityInBaseUnit, ResultsTreeKey,
	|ResultsTreeRowID, ResultsTreeRowRef, ResultsTreeBasisKey, ResultsTreeCurrentStep,
	|LinkedBasises,
	|ItemListQuantityInBaseUnit, QuantityInBaseUnit";
	
	ArrayOfItemNames = StrSplit(ItemNames, ",");
	For Each ItemName In ArrayOfItemNames Do
		ItemName = TrimAll(ItemName);	
		If Form.Items.Find(ItemName) <> Undefined Then
			Form.Items[ItemName].Visible = Not Form.Items[ItemName].Visible;
		EndIf;
	EndDo;
EndProcedure

Procedure SetCurrentRow(Object, Form, Item, FormParameters, AttributeName)
	If CommonFunctionsClientServer.ObjectHasProperty(Object, Item.Name) Then
		FormParameters.Insert("CurrentRow", Object[Item.Name]);
	Else
		TabularSection = Left(Item.Name, StrLen(Item.Name) - StrLen(AttributeName));
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, TabularSection) Then
			CurrentData = Form.Items[TabularSection].CurrentData;
			If CurrentData <> Undefined And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, AttributeName) Then
				If Not ValueIsFilled(CurrentData[AttributeName]) And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, "LineNumber") Then
					RowIndex = CurrentData.LineNumber - 1;
					PreviousRow = ?(RowIndex > 0,  Object[TabularSection][RowIndex - 1]  , CurrentData);
					FormParameters.Insert("CurrentRow", PreviousRow[AttributeName]);
				Else
					FormParameters.Insert("CurrentRow", CurrentData[AttributeName]);
				EndIf;
			EndIf;
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region ShipmentConfirationsGoodsReceiptd

Procedure SetLockedRowsForItemListByTradeDocuments(Object, Form, TableName) Export
	For Each Row In Object.ItemList Do
		Row.LockedRow = Object[TableName].FindRows(New Structure("Key", Row.Key)).Count() > 0;
	EndDo;
EndProcedure

Procedure ClearTradeDocumentsTable(Object, Form, TableName) Export
	If Not Object[TableName].Count() Then
		Return;
	EndIf;
	
	ArrayOfRows = New Array();
	For Each Row In Object[TableName] Do
		If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayOfRows.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayOfRows Do
		Object[TableName].Delete(Row);
	EndDo;
EndProcedure	

Procedure UpdateTradeDocumentsTree(Object, Form, TableName, TreeName, QuantityColumnName) Export
	Form[TreeName].GetItems().Clear();
	
	If Not Object[TableName].Count() Then
		Return;
	EndIf;
	
	ArrayOfRows = New Array();
	For Each Row In Object.ItemList Do
		ArrayOfDocuments = Object[TableName].FindRows(New Structure("Key", Row.Key));
		
		If Not ArrayOfDocuments.Count() Then
			Continue;
		EndIf;
		
		NewRow = New Structure("Key, Item, ItemKey, QuantityInBaseUnit");
		FillPropertyValues(NewRow, Row);
		ArrayOfRows.Add(NewRow);
	EndDo;

	For Each Row In ArrayOfRows Do	
		NewRow0 = Form[TreeName].GetItems().Add();
		NewRow0.Level             = 1;
		NewRow0.Key               = Row.Key;
		NewRow0.Item              = Row.Item;
		NewRow0.ItemKey           = Row.ItemKey;
		NewRow0.QuantityInInvoice = Row.QuantityInBaseUnit;
		If CommonFunctionsClientServer.ObjectHasProperty(NewRow0, "PictureItem") Then			
			NewRow0.PictureItem = 0;
		EndIf;
		
		ArrayOfDocuments = Object[TableName].FindRows(New Structure("Key", Row.Key));
		
		If ArrayOfDocuments.Count() = 1 
			And ArrayOfDocuments[0].Quantity <> Row.QuantityInBaseUnit Then
			ArrayOfDocuments[0].Quantity = Row.QuantityInBaseUnit;
		EndIf;
		
		For Each ItemOfArray In ArrayOfDocuments Do
			NewRow1 = NewRow0.GetItems().Add();
			FillPropertyValues(NewRow1, ItemOfArray);
			NewRow1.Level                  = 2;
			NewRow1.PictureEdit = True;
			NewRow0.Quantity = NewRow0.Quantity + ItemOfArray.Quantity;
			NewRow0[QuantityColumnName] = NewRow0[QuantityColumnName] + ItemOfArray[QuantityColumnName];
			If CommonFunctionsClientServer.ObjectHasProperty(NewRow1, "PictureDocument") Then			
				NewRow1.PictureDocument = 1;
			EndIf;
		EndDo;
	EndDo;
	
	For Each ItemTreeRows In Form[TreeName].GetItems() Do
		Form.Items[TreeName].Expand(ItemTreeRows.GetID());
	EndDo;	
EndProcedure

Procedure TradeDocumentsTreeQuantityOnChange(Object, Form, TableName, TreeName, DocumentColumnName) Export
	CurrentRow = Form.Items[TreeName].CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	RowParent = CurrentRow.GetParent();
	TotalQuantity = 0;
	For Each Row In RowParent.GetItems() Do
		TotalQuantity = TotalQuantity + Row.Quantity;
	EndDo;
	RowParent.Quantity = TotalQuantity;
	Filter = New Structure();
	Filter.Insert("Key", CurrentRow.Key);
	Filter.Insert(TrimAll(DocumentColumnName), CurrentRow[DocumentColumnName]);
	ArrayOfRows = Object[TableName].FindRows(Filter);
	For Each Row In ArrayOfRows Do
		Row.Quantity = CurrentRow.Quantity;
	EndDo;
EndProcedure

#EndRegion



