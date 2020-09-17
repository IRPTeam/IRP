#Region FormEvents

Procedure BeforeWrite(Object, Form, Cancel, WriteParameters) Export
	If Not Form.TaxAndOffersCalculated Then
		
		OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object,
			Form,
			"SpecialOffersEditFinish_ForDocument",
			,
			True);
		
	EndIf;
EndProcedure

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	
	OnChangeItemName = "OnOpen";
	ParametersToServer = New Structure();
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, Form.UUID));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	
	
	Settings = New Structure;
	Settings.Insert("UpdateInfoString");
	If AddInfo <> Undefined And AddInfo.Property("RemovedActions") Then
		For Each RemovedAction In AddInfo.RemovedActions Do
			Settings.Delete(RemovedAction);
		EndDo;
	EndIf;
	
	#If Not MobileClient Then
	Settings.Delete("UpdateInfoString");
	#EndIf
	
	Form.TaxAndOffersCalculated = True;
	If Settings.Count() Then
		CalculationStringsClientServer.CalculateItemsRows(Object, Form, Object.ItemList, Settings, Undefined, AddInfo);
	EndIf;
	If Not ValueIsFilled(Object.Ref) Then
		ItemListOnChange(Object, Form);
		If ValueIsFilled(Object.Company) Then
			DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Undefined);
		EndIf;
	EndIf;
		
	#If AtClient Then
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	#EndIf
	
	If ValueIsFilled(Object.Ref) Then
		CurrenciesClient.SerFaceTable(Object, Form, AddInfo);
	Else
		CurrenciesClient.FullRefreshTable(Object, Form, AddInfo);
	EndIf;
EndProcedure

Procedure NotificationProcessing(Object, Form, EventName, Parameter, Source) Export
	If EventName = "ItemListChange" Then
		CalculationStringsClientServer.CalculateItemsRows(Object,
			Form,
			Object.ItemList,
			CalculationStringsClientServer.GetCalculationSettings(),
			TaxesClient.GetArrayOfTaxInfo(Form));
	EndIf;
EndProcedure

#EndRegion

#Region ItemListEvents

//Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
//	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
//EndProcedure

Procedure ItemListOnChange(Object, Form, Item = Undefined, CalculationSettings = Undefined) Export
	
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
	
	DocumentsClient.FillDeliveryDates(Object, Form);
	CurrenciesClient.CalculateAmount(Object, Form); 
EndProcedure

Procedure ItemListOnActivateRow(Object, Form, Item) Export
	
	If Form.Items.ItemList.CurrentData = Undefined Then
		Return;
	EndIf;
	
	CurrentRow = Form.Items.ItemList.CurrentData;
	
	If ValueIsFilled(CurrentRow.Store)
		And CurrentRow.Store <> Form.CurrentStore Then
		DocumentsClient.SetCurrentStore(Object, Form, CurrentRow.Store);
	EndIf;
	
	If ValueIsFilled(CurrentRow.DeliveryDate)
		And CurrentRow.DeliveryDate <> Form.CurrentDeliveryDate Then
		DocumentsClient.SetCurrentDeliveryDate(Form, CurrentRow.DeliveryDate);
	EndIf;
	
	If ValueIsFilled(CurrentRow.PriceType)
		And CurrentRow.PriceType <> Form.CurrentPriceType Then
			Form.CurrentPriceType = CurrentRow.PriceType;
			//DocumentsClient.SetCurrentPriceType(Form, CurrentRow.PriceType);
	EndIf;
	
EndProcedure

#EndRegion

#Region ItemListItemsEvents

#Region Item

Procedure ItemListItemOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.ItemListItemOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, DataCompositionComparisonType.NotEqual));
																	
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters);
EndProcedure

Procedure ItemListItemOnChangePutServerDataToAddInfo(Object, Form, CurrentRow, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListItem";
	ParametersToServer = New Structure();
		
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	GetArrayOfTaxRates = New Structure("Agreement, ItemKey", Object.Agreement, CurrentRow.ItemKey);
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company, GetArrayOfTaxRates", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company, GetArrayOfTaxRates));
	
	ParametersToServer.Insert("GetItemKeyByItem", New Structure("Item", CurrentRow.Item));
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
		
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

Function ItemListItemSettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure();
	Actions = New Structure();
	Actions.Insert("UpdateRowPriceType"	, "UpdateRowPriceType");
	Actions.Insert("UpdateItemKey"		, "UpdateItemKey");
	Settings.Insert("Actions"           , Actions);
	
	AfterActionsCalculateSettings = New Structure;
	PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
	AfterActionsCalculateSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	Settings.Insert("AfterActionsCalculateSettings", AfterActionsCalculateSettings);
	
	Settings.Insert("ObjectAttributes" , "ItemKey");
	Settings.Insert("FormAttributes"   , "");
	
	Return Settings;
EndFunction

#EndRegion

#Region ItemKey

Procedure ItemListItemKeyOnChange(Object, Form, Item = Undefined, AddInfo = Undefined) Export
	DocumentsClient.ItemListItemKeyOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure ItemListItemKeyOnChangePutServerDataToAddInfo(Object, Form, CurrentRow, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListItemKey";
	ParametersToServer = New Structure();
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	GetArrayOfTaxRates = New Structure("Agreement, ItemKey", Object.Agreement, CurrentRow.ItemKey);
	ParametersToServer.Insert("TaxesCache",
	New Structure ("Cache, Ref, Date, Company, GetArrayOfTaxRates", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company, GetArrayOfTaxRates));
	
	ParametersToServer.Insert("GetItemUnitInfo", New Structure("ItemKey", CurrentRow.ItemKey));
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
		
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

Function ItemListItemKeySettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AfterActionsCalculateSettings");
	
	Actions = New Structure();
	Actions.Insert("UpdateRowPriceType"	, "UpdateRowPriceType");
	Actions.Insert("UpdateRowUnit"		, "UpdateRowUnit");
	
	AfterActionsCalculateSettings = New Structure;
	PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
	AfterActionsCalculateSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "ItemKey";
	Settings.FormAttributes = "";
	Settings.AfterActionsCalculateSettings = AfterActionsCalculateSettings;
	Return Settings;
EndFunction

#EndRegion

#Region PriceType

Procedure ItemListPriceTypeOnChange(Object, Form, Item = Undefined, AddInfo = Undefined) Export
	DocumentsClient.ItemListPriceTypeOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure ItemListPriceTypeOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListPriceType";
	ParametersToServer = New Structure();
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache", New Structure ("Cache, Ref, Date, Company", Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
		
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

Function ItemListPriceTypeSettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Settings.Actions = New Structure();
	Settings.ObjectAttributes = "ItemKey";
	Settings.FormAttributes = "";
	
	Return Settings;
EndFunction

#EndRegion

#Region Unit

Procedure ItemListUnitOnChange(Object, Form, Item = Undefined, AddInfo = Undefined) Export
	DocumentsClient.ItemListUnitOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure ItemListUnitOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListUnit";
	ParametersToServer = New Structure();
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache", New Structure ("Cache, Ref, Date, Company", Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
		
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure

Function ItemListUnitSettings(Object, Form, AddInfo = Undefined) Export	
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Actions = New Structure();
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "ItemKey";
	Settings.FormAttributes = "";
	Return Settings;
EndFunction

#EndRegion

#Region Quantity

Procedure ItemListQuantityOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	DocumentsClient.ItemListCalculateRowAmounts_QuantityChange(Object, Form, CurrentData, Item, ThisObject, AddInfo);
EndProcedure

Procedure ItemListQuantityPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListQuantity";
	
	ParametersToServer = New Structure();
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	ParametersToServer.Insert("TaxesCache", New Structure ("Cache, Ref, Date, Company", Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region Price
	
Procedure ItemListPriceOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	DocumentsClient.ItemListCalculateRowAmounts_PriceChange(Object, Form, CurrentData, Item, ThisObject, AddInfo);
EndProcedure

Procedure ItemListPricePutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListPrice";
	
	ParametersToServer = New Structure();
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	ParametersToServer.Insert("TaxesCache", New Structure ("Cache, Ref, Date, Company", Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region TotalAmount

Procedure ItemListTotalAmountOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	DocumentsClient.ItemListCalculateRowAmounts_TotalAmountChange(Object, Form, CurrentData, Item, ThisObject, AddInfo);
EndProcedure

Procedure ItemListTotalAmountPutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListTotalAmount";
	
	ParametersToServer = New Structure();
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	ParametersToServer.Insert("TaxesCache", New Structure ("Cache, Ref, Date, Company", Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region TaxValue

Procedure ItemListTaxValueOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	DocumentsClient.ItemListCalculateRowAmounts_TaxValueChange(Object, Form, CurrentData, Item, ThisObject, AddInfo);
EndProcedure

Procedure ItemListTaxValuePutServerDataToAddInfo(Object, Form, CurrentData, AddInfo = Undefined) Export
	OnChangeItemName = "ItemListTaxValue";
	
	ParametersToServer = New Structure();
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	ParametersToServer.Insert("TaxesCache", New Structure ("Cache, Ref, Date, Company", Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
EndProcedure	

#EndRegion

#Region Store

Procedure ItemListStoreOnChange(Object, Form, Item = Undefined) Export
	DocumentsClient.ItemListStoreOnChange(Object, Form, ThisObject, Item);
EndProcedure

#EndRegion

#EndRegion

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.PartnerOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure PartnerOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Partner";
	
	ParametersToServer = New Structure();
	ParametersToServer.Insert("GetAgreementTypes_Vendor");
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, Form.UUID));
	
	GetArrayOfTaxRates = New Structure("Agreement", Object.Agreement);
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company, GetArrayOfTaxRates", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company, GetArrayOfTaxRates));
	
	ParametersToServer.Insert("GetAgreementInfo", New Structure("Agreement", Object.Agreement));
	ParametersToServer.Insert("GetManagerSegmentByPartner", New Structure("Partner", Object.Partner));
	ParametersToServer.Insert("GetLegalNameByPartner", New Structure("Partner, LegalName", Object.Partner, Object.LegalName));
	ParametersToServer.Insert("GetAgreementByPartner", New Structure("Partner, Agreement, Date", Object.Partner, Object.Agreement, Object.Date));
	ParametersToServer.Insert("GetMetaDataStructure", New Structure("Ref", Object.Ref));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure


Function PartnerSettings(Object, Form, AddInfo = Undefined) Export
	
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AgreementType");
	
	Actions = New Structure();
	Actions.Insert("ChangeLegalName"		, "ChangeLegalName");
	Actions.Insert("ChangeAgreement"		, "ChangeAgreement");
	Settings.Actions = Actions;
	
	Settings.ObjectAttributes 	= "Company, Currency, PriceIncludeTax, Agreement, LegalName";
	Settings.FormAttributes		= "CurrentPriceType";
	Settings.AgreementType = ServerData.AgreementTypes_Vendor;
	Return Settings;
EndFunction

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Vendor"		, 
																		True, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Filter", New Structure("Vendor" , True));
	OpenSettings.FillingData = New Structure("Vendor", True);
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Vendor"		, True, ComparisonType.Equal));
	AdditionalParameters = New Structure();				
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
				ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure AgreementOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.AgreementOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure AgreementOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Agreement";
	ParametersToServer = New Structure();
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, Form.UUID));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	GetArrayOfTaxRates = New Structure("Agreement", Object.Agreement);
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company, GetArrayOfTaxRates", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company, GetArrayOfTaxRates));
	
	ParametersToServer.Insert("GetMetaDataStructure", New Structure("Ref", Object.Ref));
	ParametersToServer.Insert("GetAgreementInfo", New Structure("Agreement", Object.Agreement));	
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

Function AgreementSettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Actions = New Structure();
	Actions.Insert("ChangeCompany"			, "ChangeCompany");
	Actions.Insert("ChangePriceType"		, "ChangePriceType");
	Actions.Insert("ChangeCurrency"			, "ChangeCurrency");
	Actions.Insert("ChangePriceIncludeTax"	, "ChangePriceIncludeTax");
	Actions.Insert("ChangeStore"			, "ChangeStore");
	Actions.Insert("ChangeDeliveryDate"		, "ChangeDeliveryDate");
	
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Currency, PriceIncludeTax";
	Settings.FormAttributes = "Store, DeliveryDate, CurrentPriceType";
	Return Settings;
EndFunction

Procedure AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																	True, 
																	DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
																	PredefinedValue("Enum.AgreementTypes.Vendor"), 
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
	OpenSettings.FillingData.Insert("Type", PredefinedValue("Enum.AgreementTypes.Vendor"));
	
	DocumentsClient.AgreementStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure AgreementTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Type", 
																	PredefinedValue("Enum.AgreementTypes.Vendor"),
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

#Region ItemCurrency

Procedure CurrencyOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.CurrencyOnChange2(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure CurrencyOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Currency";
	ParametersToServer = New Structure();
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, Form.UUID));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

Function CurrencySettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Return New Structure();
EndFunction

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Item) Export
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

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure CompanyOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Company";
	ParametersToServer = New Structure();
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, Form.UUID));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	ParametersToServer.Insert("GetAgreementInfo", New Structure("Agreement", Object.Agreement));	
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

Function CompanySettings(Object, Form, AddInfo = Undefined) Export
	
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Actions = New Structure();
	Actions.Insert("ChangeCurrency"	, "ChangeCurrency");
	Settings.Insert("TableName"		, "ItemList");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Currency, PriceIncludeTax, Agreement";
	Settings.FormAttributes = "Store, DeliveryDate, CurrentPriceType";
	Return Settings;
EndFunction

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

#Region ItemStore

Procedure StoreOnChange(Object, Form, Item = Undefined, Settings = Undefined, AddInfo = Undefined) Export
	DocumentsClient.StoreOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure StoreOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Store";
	ParametersToServer = New Structure();
		
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ParametersToServer.Insert("GetMetaDataStructure", New Structure("Ref", Object.Ref));
	ParametersToServer.Insert("GetAgreementInfo", New Structure("Agreement", Object.Agreement));	
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure


Function StoreSettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	
	Actions = New Structure();
	Actions.Insert("UpdateStore"		, "UpdateStore");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company";
	Settings.FormAttributes = "Store, CurrentPriceType";
	Return Settings;
EndFunction

#EndRegion

#Region ItemPriceIncludeTax

Procedure PriceIncludeTaxOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.PriceIncludeTaxOnChange(Object, Form, ThisObject, Item, Undefined, AddInfo);
EndProcedure

Procedure PriceIncludeTaxOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Store";
	ParametersToServer = New Structure();
		
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company", 
	Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

Function PriceIncludeTaxSettings(Object, Form, AddInfo = Undefined) Export
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	
	Return New Structure();
EndFunction

#EndRegion

#Region ItemDate

Procedure DateOnChange(Object, Form, Item, AddInfo = Undefined) Export
	DocumentsClient.DateOnChange(Object, Form, Thisobject, Item, Undefined, AddInfo);
EndProcedure

Procedure DateOnChangePutServerDataToAddInfo(Object, Form, AddInfo = Undefined) Export
	OnChangeItemName = "Date";
	ParametersToServer = New Structure();
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, Form.UUID));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache",
	 New Structure ("Cache, Ref, Date, Company", 
	 Form.TaxesCache, Object.Ref, Object.Date, Object.Company));
	ParametersToServer.Insert("GetMetaDataStructure", New Structure("Ref", Object.Ref));
	ParametersToServer.Insert("GetAgreementTypes_Vendor");
	ParametersToServer.Insert("GetPurchaseOrder_EmptyRef");
	ParametersToServer.Insert("GetManagerSegmentByPartner", New Structure("Partner", Object.Partner));
	ParametersToServer.Insert("GetLegalNameByPartner", New Structure("Partner, LegalName", Object.Partner, Object.LegalName));
	ParametersToServer.Insert("GetAgreementByPartner", New Structure("Partner, Agreement, Date, WithAgreementInfo", 
	Object.Partner, Object.Agreement, Object.Date, True));
	ParametersToServer.Insert("GetPriceTypes_ManualPriceType");
		
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "CalculateItemRowsAtServer", True);
EndProcedure

Function DateSettings(Object, Form, AddInfo = Undefined) Export
	
	If AddInfo = Undefined Then
		Return New Structure("PutServerDataToAddInfo", True);
	EndIf;
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	Settings = New Structure();
	
	Actions = New Structure();
	Actions.Insert("ChangeAgreement"	, "ChangeAgreement");
	Actions.Insert("ChangeDeliveryDate"	, "ChangeDeliveryDate");
	
	Settings.Insert("Actions", Actions);
	
	AfterActionsCalculateSettings = New Structure();
	PriceDate = CalculationStringsClientServer.GetPriceDate(Form.Object);
	AfterActionsCalculateSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	Settings.Insert("AfterActionsCalculateSettings", AfterActionsCalculateSettings);
	
	Settings.Insert("TableName"			, "ItemList");
	Settings.Insert("EmptyBasisDocument", New Structure("PurchaseOrder", ServerData.PurchaseOrder_EmptyRef));	
	Settings.Insert("ObjectAttributes"  , "Company, Currency, PriceIncludeTax, Agreement, LegalName");
	Settings.Insert("FormAttributes"    , "CurrentPriceType");
	Settings.Insert("AgreementType"     , ServerData.AgreementTypes_Vendor);
	
	Return Settings;
EndFunction

#EndRegion

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

#Region PickUpItems

Procedure OpenPickupItems(Object, Form, Command) Export
	DocumentsClient.OpenPickupItems(Object, Form, Command); 
EndProcedure

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form, , Form.CurrentPriceType);
EndProcedure

#EndRegion

