#Region FormEvents

Procedure OpenChoiceForm(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings) Export
	If OpenSettings = Undefined Then
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

Procedure OpenListForm(FormName, ArrayOfFilters, FormParameters, Source = Undefined, Uniqueness = Undefined,
	Window = Undefined, URL = Undefined) Export

	ListForm = GetForm(FormName, FormParameters, Source, Uniqueness, Window, URL);

	For Each Filter In ArrayOfFilters Do
		AddFilterToChoiceForm(ListForm, Filter.FieldName, Filter.Value, Filter.ComparisonType);
	EndDo;

	ListForm.Open();
EndProcedure

#EndRegion

#Region ItemPartner

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

Procedure PartnerEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters = Undefined,
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

#Region PickUpItems

// Pickup items end.
// 
// Parameters:
//  Result - See BarcodeServer.SearchByBarcodes
//  AddInfo - See BarcodeClient.GetBarcodeSettings
Procedure PickupItemsEnd(Result, AddInfo) Export
	If Not ValueIsFilled(Result) Or Not AddInfo.Property("Object") Or Not AddInfo.Property("Form") Then
		Return;
	EndIf;

	Object 	= AddInfo.Object;
	Form 	= AddInfo.Form;
	
	UseSerialLotNumbers = Object.Property("SerialLotNumbers");
	isSerialLotNumberAtRow = False;
	
	ObjectRefType = TypeOf(Object.Ref);
	
	isSerialLotNumberAtRow = ObjectRefType = Type("DocumentRef.PhysicalInventory")
			Or ObjectRefType = Type("DocumentRef.PhysicalCountByLocation");
	
	If Object.Property("Agreement") Then
		FilterString = "Item, ItemKey, Unit, Price";
	ElsIf isSerialLotNumberAtRow Then
		FilterString = "Item, ItemKey, Unit, SerialLotNumber";
	Else
		FilterString = "Item, ItemKey, Unit";
	EndIf;

	If ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
		FilterString = FilterString + ", Barcode, Date";
	EndIf;
	
	FilterStructure = New Structure(FilterString);
	
	For Each ResultElement In Result Do
		
		If ResultElement.isService And AddInfo.Property("Filter") And AddInfo.Filter.DisableIfIsService Then
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_026, ResultElement.Item));
			Continue;
		EndIf;
		
		FillPropertyValues(FilterStructure, ResultElement);
		ExistingRows = Object.ItemList.FindRows(FilterStructure);
		If ExistingRows.Count() Then
			Row = ExistingRows[0];
			If ObjectRefType = Type("DocumentRef.PhysicalInventory")
				Or ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
				ViewClient_V2.SetItemListPhysCount(Object, Form, Row, Row.PhysCount + ResultElement.Quantity);
			Else
				ViewClient_V2.SetItemListQuantity(Object, Form, Row, Row.Quantity + ResultElement.Quantity);
			EndIf;
		Else
			FillingValues = New Structure();
			FillingValues.Insert("Item"     , ResultElement.Item);
			FillingValues.Insert("ItemKey"  , ResultElement.ItemKey);
			FillingValues.Insert("Unit"     , ResultElement.Unit);
			FillingValues.Insert("Quantity" , ResultElement.Quantity);
			FillingValues.Insert("SerialLotNumber" , ResultElement.SerialLotNumber);
			FillingValues.Insert("Barcode" , ?(ResultElement.Property("Barcode"), ResultElement.Barcode, ""));
			FillingValues.Insert("Date" , CurrentDate());
			
			If ResultElement.Property("Price") Then
				FillingValues.Insert("Price", ResultElement.Price);
			EndIf;
			Row = ViewClient_V2.ItemListAddFilledRow(Object, Form, FillingValues);
		EndIf;
		
		If UseSerialLotNumbers Then
			If ValueIsFilled(ResultElement.SerialLotNumber) Then
				SerialLotNumbersArray = New Array();
				SerialLotNumbers = New Structure("SerialLotNumber, Quantity");
				SerialLotNumbers.SerialLotNumber = ResultElement.SerialLotNumber;
				SerialLotNumbers.Quantity = 1;
				SerialLotNumbersArray.Add(SerialLotNumbers);
				SerialLotNumbersStructure = New Structure("RowKey, SerialLotNumbers", Row.Key, SerialLotNumbersArray);

				SerialLotNumberClient.AddNewSerialLotNumbers(SerialLotNumbersStructure, AddInfo, True, AddInfo);
			ElsIf ResultElement.UseSerialLotNumber Then
				Form.ItemListSerialLotNumbersPresentationStartChoice(Object.ItemList, Undefined, True);
			EndIf;
		ElsIf ObjectRefType = Type("DocumentRef.PhysicalInventory")
				Or ObjectRefType = Type("DocumentRef.PhysicalCountByLocation") Then
			
			If Object.UseSerialLot And ResultElement.UseSerialLotNumber And Not ValueIsFilled(ResultElement.SerialLotNumber) Then
				Form.ItemListSerialLotNumberStartChoice(Object.ItemList, Undefined, True);
			EndIf;
		EndIf;
		
	EndDo;
	
EndProcedure

Procedure OpenPickupItems(Object, Form, Command) Export
	NotifyParameters = New Structure();
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
Procedure SearchByBarcode(Barcode, Object, Form, ReturnCallToModule = Undefined, PriceType = Undefined,
	Settings = Undefined) Export
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
	Else
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, StrConcat(Result.Barcodes, ",")));
	EndIf;
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
	OpenForm("CommonForm.EditHiddenTables", FormParameters, Form, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Function GetFormItemNames()
	ItemNames = "ItemListKey, SpecialOffersKey, TransactionsKey,
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
				|ItemListQuantityInBaseUnit, QuantityInBaseUnit,
				|CostList, RevenueList, AllocationList, CostRowsRowID, RevenueRowsRowID, 
				|AllocationRowsBasisRowID, AllocationRowsRowID, 
				|CostDocumentsKey, RevenueDocumentsKey, CostRowsTreeRowID, RevenueRowsTreeRowID,
				|AllocationDocumentsKey, DocumentRowsBasisRowID, DocumentRowsRowID, ResultTreeRowID,
				|PaymentListKey, PaymentsKey,
				|TaxList,
				|ItemListInternalLinks, ItemListExternalLinks, InternalLinkedDocs, ExternalLinkedDocs,
				|Currencies, CurrenciesTableKey,
				|InventoryKey, AccountBalanceKey, AdvanceFromCustomersKey, AdvanceToSuppliersKey,
				|AccountPayableByAgreementsKey, AccountPayableByDocumentsKey, VendorsPaymentTermsKey,
				|AccountReceivableByAgreementsKey, AccountReceivableByDocumentsKey, CustomersPaymentTermsKey,
				|SendUUID, ReceiveUUID,
				|ItemListUseSerialLotNumber, ItemListIsService,
				|PaymentListApArPostingDetail,
				|InventoryUseSerialLotNumber, AccountBalanceIsFixedCurrency,
				|ChequeBondsKey, ChequeBondsApArPostingDetail";

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

Procedure SetCurrentRow(Object, Form, Item, FormParameters, AttributeName)
	If CommonFunctionsClientServer.ObjectHasProperty(Object, Item.Name) Then
		FormParameters.Insert("CurrentRow", Object[Item.Name]);
	Else
		TabularSection = Left(Item.Name, StrLen(Item.Name) - StrLen(AttributeName));
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, TabularSection) Then
			CurrentData = Form.Items[TabularSection].CurrentData;
			If CurrentData <> Undefined And CommonFunctionsClientServer.ObjectHasProperty(CurrentData, AttributeName) Then
				If Not ValueIsFilled(CurrentData[AttributeName]) And CommonFunctionsClientServer.ObjectHasProperty(
					CurrentData, "LineNumber") Then
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

		If ArrayOfDocuments.Count() = 1 And ArrayOfDocuments[0].Quantity <> Row.QuantityInBaseUnit Then
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
	Filter.Insert("BasisKey", CurrentRow.BasisKey);
	Filter.Insert(TrimAll(DocumentColumnName), CurrentRow[DocumentColumnName]);
	ArrayOfRows = Object[TableName].FindRows(Filter);
	For Each Row In ArrayOfRows Do
		Row.Quantity = CurrentRow.Quantity;
	EndDo;
EndProcedure

#EndRegion

#Region RevenueType

Procedure RevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsRevenue", True,
		DataCompositionComparisonType.Equal));
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	DocumentsClient.ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure RevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsRevenue", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	DocumentsClient.ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region ExpenseType

Procedure ExpenseTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsExpense", True,
		DataCompositionComparisonType.Equal));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	DocumentsClient.ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ExpenseTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsExpense", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	DocumentsClient.ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion

#Region FinancialMovementType

Procedure FinancialMovementTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True,
		DataCompositionComparisonType.NotEqual));

	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFinancialMovementType", True,
		DataCompositionComparisonType.Equal));

	OpenSettings.FormParameters = New Structure();
	OpenSettings.FillingData = New Structure();

	DocumentsClient.ExpenseAndRevenueTypeStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure FinancialMovementTypeEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("IsFinancialMovementType", True, ComparisonType.Equal));

	AdditionalParameters = New Structure();
	DocumentsClient.ExpenseAndRevenueTypeEditTextChange(Object, Form, Item, Text, StandardProcessing, ArrayOfFilters,
		AdditionalParameters);
EndProcedure

#EndRegion
