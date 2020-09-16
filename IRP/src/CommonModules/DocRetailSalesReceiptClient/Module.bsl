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
	
	Settings = New Structure;
	Settings.Insert("UpdateInfoString");
	If AddInfo <> Undefined And AddInfo.Property("RemovedActions") Then
		For Each RemovedAction In AddInfo.RemovedActions Do
			Settings.Delete(RemovedAction);
		EndDo;
	EndIf;
	
	Form.TaxAndOffersCalculated = True;
	CalculationStringsClientServer.CalculateItemsRows(Object, Form, Object.ItemList, Settings);
	
	If Not ValueIsFilled(Object.Ref) Then
		ItemListOnChange(Object, Form);
	EndIf;
	
	AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
	
	If Object.Ref.IsEmpty() Then
		If ValueIsFilled(Object.Company) Then
			DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Undefined);
		EndIf;
	EndIf;
	
	If Not ValueIsFilled(Form.CurrentStore) Then
		DocumentsClient.SetCurrentStore(Object, Form, AgreementInfo.Store);
	EndIf;
		
	If Not ValueIsFilled(Form.CurrentPriceType) Then
		DocumentsClient.SetCurrentPriceType(Form, AgreementInfo.PriceType);
	EndIf;
	
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object);
	SerialLotNumberClient.UpdateSerialLotNubersTree(Object, Form);		
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

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object);
EndProcedure

#EndRegion

#Region ItemListEvents

Procedure ItemListAfterDeleteRow(Object, Form, Item) Export
	DocumentsClient.ItemListAfterDeleteRow(Object, Form, Item);
	SerialLotNumberClient.DeleteUnusedSerialLotNumbers(Object);
	SerialLotNumberClient.UpdateSerialLotNubersTree(Object, Form);	
EndProcedure

Procedure ItemListOnChange(Object, Form, Item = Undefined, CalculationSettings = Undefined) Export
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
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
	
	If ValueIsFilled(CurrentRow.PriceType)
		And CurrentRow.PriceType <> Form.CurrentPriceType 
		And CurrentRow.PriceType <> PredefinedValue("Catalog.PriceTypes.ManualPriceType") Then
		DocumentsClient.SetCurrentPriceType(Form, CurrentRow.PriceType);
	EndIf;
EndProcedure
#EndRegion

#Region ItemListItemsEvents

Procedure ItemListItemOnChange(Object, Form, Item = Undefined) Export
	DocumentsClient.ItemListItemOnChange(Object, Form, ThisObject, Item);
	SerialLotNumberClient.UpdateUseSerialLotNumber(Object, Form);
EndProcedure

Function ItemListItemSettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AfterActionsCalculateSettings");
	
	Actions = New Structure();
	Actions.Insert("UpdateRowPriceType"	, "UpdateRowPriceType");
	Actions.Insert("UpdateItemKey"		, "UpdateItemKey");
	
	AfterActionsCalculateSettings = New Structure;
	PriceDate = CalculationStringsClientServer.GetPriceDate(Form.Object);
	AfterActionsCalculateSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "ItemKey";
	Settings.FormAttributes = "";
	Settings.AfterActionsCalculateSettings = AfterActionsCalculateSettings;
	Return Settings;
EndFunction

Procedure ItemListItemKeyOnChange(Object, Form, Item = Undefined) Export
	DocumentsClient.ItemListItemKeyOnChange(Object, Form, ThisObject, Item);
	SerialLotNumberClient.UpdateUseSerialLotNumber(Object, Form);
EndProcedure

Function ItemListItemKeySettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AfterActionsCalculateSettings");
	
	Actions = New Structure();
	Actions.Insert("UpdateRowPriceType"	, "UpdateRowPriceType");
	Actions.Insert("UpdateRowUnit"		, "UpdateRowUnit");
	
	AfterActionsCalculateSettings = New Structure;
	PriceDate = CalculationStringsClientServer.GetPriceDate(Form.Object);
	AfterActionsCalculateSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "ItemKey";
	Settings.FormAttributes = "";
	Settings.AfterActionsCalculateSettings = AfterActionsCalculateSettings;
	Return Settings;
EndFunction

Procedure ItemListPriceTypeOnChange(Object, Form, Item = Undefined) Export
	DocumentsClient.ItemListPriceTypeOnChange(Object, Form, ThisObject, Item);
EndProcedure

Function ItemListPriceTypeSettings(Object, Form, AddInfo = Undefined) Export
	Return New Structure();
EndFunction

Procedure ItemListUnitOnChange(Object, Form, Item = Undefined) Export
	DocumentsClient.ItemListUnitOnChange(Object, Form, ThisObject, Item);
EndProcedure

Procedure ItemListQuantityOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;	
	DocumentsClient.ItemListCalculateRowAmounts(Object, Form, CurrentData);
	SerialLotNumberClient.UpdateSerialLotNubersTree(Object, Form);
EndProcedure

Procedure ItemListPriceOnChange(Object, Form, Item) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Form.Items.ItemList.CurrentData.PriceType = PredefinedValue("Catalog.PriceTypes.ManualPriceType");
	DocumentsClient.ItemListCalculateRowAmounts(Object, Form, CurrentData);
EndProcedure

Function ItemListUnitSettings(Object, Form, AddInfo = Undefined) Export	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Actions = New Structure();
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "ItemKey";
	Settings.FormAttributes = "";
	Return Settings;
EndFunction

Procedure ItemListStoreOnChange(Object, Form, Item = Undefined) Export
	DocumentsClient.ItemListStoreOnChange(Object, Form, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item) Export
	DocumentsClient.PartnerOnChange(Object, Form, ThisObject, Item);
EndProcedure

Function PartnerSettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AgreementType");
	
	Actions = New Structure();
	Actions.Insert("ChangeManagerSegment"	, "ChangeManagerSegment");
	Actions.Insert("ChangeLegalName"		, "ChangeLegalName");
	Actions.Insert("ChangeAgreement"		, "ChangeAgreement");
	Settings.Actions = Actions;
	
		Settings.ObjectAttributes 	= "Company, Currency, PriceIncludeTax, Agreement, LegalName, ManagerSegment";
		Settings.FormAttributes		= "CurrentPriceType";
	Settings.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Return Settings;
EndFunction

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Filter", New Structure("Customer" , True));
	OpenSettings.FillingData = New Structure("Customer", True);
	
	DocumentsClient.PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure PartnerTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Customer", True, ComparisonType.Equal));
	AdditionalParameters = New Structure();		
	DocumentsClient.PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing,
		ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemAgreement

Procedure AgreementOnChange(Object, Form, Item) Export
	
	DocumentsClient.AgreementOnChange(Object, Form, ThisObject, Item);
	
EndProcedure

Function AgreementSettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Actions = New Structure();
	Actions.Insert("ChangeCompany"			, "ChangeCompany");
	Actions.Insert("ChangePriceType"		, "ChangePriceType");
	Actions.Insert("ChangeCurrency"			, "ChangeCurrency");
	Actions.Insert("ChangePriceIncludeTax"	, "ChangePriceIncludeTax");
	Actions.Insert("ChangeStore"			, "ChangeStore");
	
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Currency, PriceIncludeTax, ManagerSegment";
	Settings.FormAttributes = "Store, CurrentPriceType";
	Return Settings;
EndFunction

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
	DocumentsClient.AgreementEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
EndProcedure

#EndRegion

#Region ItemLegalName

Procedure LegalNameOnChange(Object, Form, Item) Export
	DocumentsClient.LegalNameOnChange(Object, Form, ThisObject, Item);
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

Procedure CompanyOnChange(Object, Form, Item) Export
	
	DocumentsClient.CompanyOnChange(Object, Form, ThisObject, Item);
	
EndProcedure

Function CompanySettings(Object, Form, AddInfo = Undefined) Export
	
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	Actions = New Structure();
	Actions.Insert("ChangeCurrency"		, "ChangeCurrency");
	Settings.Insert("TableName"		, "ItemList");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Currency, PriceIncludeTax, Agreement";
	Settings.FormAttributes = "Store, CurrentPriceType";
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

#Region StoreEvents

Procedure StoreOnChange(Object, Form, Item = Undefined, Settings = Undefined) Export
	
	DocumentsClient.StoreOnChange(Object, Form, ThisObject, Item);
	
EndProcedure

Function StoreSettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes");
	
	Actions = New Structure();
	Actions.Insert("UpdateStore"		, "UpdateStore");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company";
	Settings.FormAttributes = "Store, CurrentPriceType";
	Return Settings;
EndFunction

#EndRegion

#Region PriceIncludeTaxEvents

Procedure PriceIncludeTaxOnChange(Object, Form, Item) Export
	DocumentsClient.PriceIncludeTaxOnChange(Object, Form, ThisObject, Item);
EndProcedure

Function PriceIncludeTaxSettings(Object, Form, AddInfo = Undefined) Export
	Return New Structure();
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

#Region ItemDate

Procedure DateOnChange(Object, Form, Item = Undefined, Settings = Undefined) Export
	
	DocumentsClient.DateOnChange(Object, Form, Thisobject, Item);
	
EndProcedure

Function DateSettings(Object, Form, AddInfo = Undefined) Export
	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AgreementType, AfterActionsCalculateSettings");
	
	Actions = New Structure();
	Actions.Insert("ChangeAgreement"	, "ChangeAgreement");
	
	AfterActionsCalculateSettings = New Structure;
	PriceDate = CalculationStringsClientServer.GetPriceDate(Form.Object);
	AfterActionsCalculateSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate, Form.CurrentPriceType));
	
	Settings.Insert("TableName"			, "ItemList");
	Settings.Actions = Actions;
	Settings.ObjectAttributes = "Company, Currency, PriceIncludeTax, Agreement, LegalName, ManagerSegment";
	Settings.FormAttributes = "CurrentPriceType";
	Settings.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Settings.AfterActionsCalculateSettings = AfterActionsCalculateSettings;
	
	Return Settings;
EndFunction

#EndRegion

#Region PickUpItems
Procedure OpenPickupItems(Object, Form, Command) Export
	DocumentsClient.OpenPickupItems(Object, Form, Command); 
EndProcedure

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form, , Form.CurrentPriceType);
EndProcedure

#EndRegion

#Region Item
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

#EndRegion

Function CurrencySettings(Object, Form, AddInfo = Undefined) Export
	Return New Structure();
EndFunction

