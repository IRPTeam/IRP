Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	
	DocumentsClient.SetTextOfDescriptionAtForm(Object, Form);
	
	#If MobileClient Then
	ItemListOnChange(Object, Form);
	SerialLotNumberListOnChange(Object, Form);
	#EndIf
	
EndProcedure

#Region ItemCompany

Procedure CompanyOnChange(Object, Form, Item) Export
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure CompanyStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", 
																		True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("OurCompany", 
																		True, DataCompositionComparisonType.Equal));
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

#Region ItemPartner

Procedure PartnerOnChange(Object, Form, Item) Export
	Object.LegalName = DocumentsServer.GetLegalNameByPartner(Object.Partner, Object.LegalName);
	DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
EndProcedure

Procedure PartnerStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();
	
	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.FormParameters = New Structure();
	
	FilterParnerType = "";
	If Object.TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.Purchase") Then
		FilterParnerType = "Vendor";
	ElsIf Object.TransactionType = PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer") Then
		FilterParnerType = "Customer";
	EndIf;
	If Not IsBlankString(FilterParnerType) Then
		OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem(FilterParnerType		, True, DataCompositionComparisonType.Equal));
		OpenSettings.FormParameters.Insert("Filter", New Structure(FilterParnerType , True));
		OpenSettings.FillingData = New Structure(FilterParnerType, True);
	EndIf;
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

#Region ItemListItemsEvents

#Region Unit

Procedure ItemListUnitOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Actions = New Structure("CalculateQuantityInBaseUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#Region Quantity

Procedure ItemListQuantityOnChange(Object, Form, Item, AddInfo = Undefined) Export
	CurrentData = Form.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Actions = New Structure("CalculateQuantityInBaseUnit");
	CalculationStringsClientServer.CalculateItemsRow(Object, CurrentData, Actions);
EndProcedure

#EndRegion

#EndRegion

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

Procedure ItemListOnChange(Object, Form, Item = Undefined, CalculationSettings = Undefined) Export
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
		#If MobileClient Then
		Row.Item = ServiceSystemServer.GetObjectAttribute(Row.ItemKey, "Item");
		Row.Title = "" + Row.Item + " " + Row.ItemKey;
		#EndIf
	EndDo;
	
	If Form.Items.ItemList.CurrentData <> Undefined Then
		If Form.Items.ItemList.CurrentItem <> Undefined
			AND Form.Items.ItemList.CurrentItem.Name = "ItemListStore" Then
			DocumentsClient.SetCurrentStore(Object, Form, Form.Items.ItemList.CurrentData.Store);
		EndIf;
		DocumentsClient.FillUnfilledStoreInRow(Object, Form.Items.ItemList, Form.CurrentStore);
	EndIf;
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, Object);
	DocumentsClientServer.FillStores(ObjectData, Form);
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
EndProcedure

Procedure ItemListReceiptBasisStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	StandardProcessing = False;
	
	FilterValues = New Structure();
	FilterValues.Insert("Company"  , Object.Company);
	FilterValues.Insert("Partner"  , ?(Form.Items.Partner.Visible, Object.Partner, Undefined));
	FilterValues.Insert("LegalName", ?(Form.Items.LegalName.Visible, Object.LegalName, Undefined));
	FilterValues.Insert("ItemKey"  , Form.Items.ItemList.CurrentData.ItemKey);
	
	ExistingRows = New Array;
	For Each Row In Object.ItemList Do
		If Row.GetID() = Form.Items.ItemList.CurrentRow Then
			Continue;
		EndIf;
		RowStructure = New Structure("Key, Unit, Quantity");
		FillPropertyValues(RowStructure, Row);
		ExistingRows.Add(RowStructure);
	EndDo;
	
	FormParameters = New Structure();
	FormParameters.Insert("SelectReceiptBasisMode", True);
	FormParameters.Insert("FilterValues"          , FilterValues);
	FormParameters.Insert("ExistingRows"          , ExistingRows);
	FormParameters.Insert("Ref"                   , Object.Ref);
	
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object"    , Object);
	NotifyParameters.Insert("Form"      , Form);
	NotifyParameters.Insert("CurrentRow", Form.Items.ItemList.CurrentRow);
	OpenForm("Document.GoodsReceipt.Form.SelectReceiptBasisesForm"
		, FormParameters, , , ,
		, New NotifyDescription("SelectReceiptBasisInRowContinue", ThisObject, NotifyParameters));
	
EndProcedure

Procedure SerialLotNumberListOnChange(Object, Form, Item = Undefined) Export
	For Each Row In Object.SerialLotNumbers Do
		#If MobileClient Then
		ItemListFilterStructure = New Structure;
		ItemListFilterStructure.Insert("Key", Row.KeyRef);
		ItemListExistingRows = Object.ItemList.FindRows(ItemListFilterStructure);
		If ItemListExistingRows.Count() Then
			ItemListExistingRow = ItemListExistingRows[0];
			Row.ItemKey = ItemListExistingRow.ItemKey;
			Row.Item = ItemListExistingRow.Item;
			Row.Title = "" + Row.Item + " " + Row.ItemKey + " " + Row.SerialLotNumber;
		EndIf;
		#EndIf
	EndDo;
EndProcedure

Procedure DescriptionClick(Object, Form, Item, StandardProcessing) Export
	StandardProcessing = False;
	CommonFormActions.EditMultilineText(Item.Name, Form);
EndProcedure

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
		ShowQueryBox(New NotifyDescription("StoreOnChangeContinue", 
											ThisObject, 
											New Structure("Form, Object", Form, Object)),
					R().QuestionToUser_005,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocumentsClient.SetCurrentStore(Object, Form, Form.Store);
	DocGoodsReceiptClient.ChangeItemListStore(Object.ItemList, Form.Store);
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
	Else
		If AdditionalParameters.Property("Form") Then
			ObjectData = DocumentsClientServer.GetStructureFillStores();
			FillPropertyValues(ObjectData, AdditionalParameters.Object);
			DocumentsClientServer.FillStores(ObjectData, AdditionalParameters.Form);
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region GroupTitle

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

#EndRegion

Procedure ItemListItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing) Export
	OpenSettings = DocumentsClient.GetOpenSettingsForSelectItemWithNotServiceFilter();
	DocumentsClient.ItemStartChoice(Object, Form, Item, ChoiceData, StandardProcessing, OpenSettings);
EndProcedure

Procedure ItemListItemEditTextChange(Object, Form, Item, Text, StandardProcessing) Export
	DocumentsClient.ItemEditTextChange(Object, Form, Item, Text, StandardProcessing);
EndProcedure

Procedure PickupItemsEnd(Result, AdditionalParameters) Export
	If NOT ValueIsFilled(Result)
		OR Not AdditionalParameters.Property("Object")
		OR Not AdditionalParameters.Property("Form") Then
		Return;
	EndIf;
	
	Object = AdditionalParameters.Object;
	Form = AdditionalParameters.Form;
	
	ItemListFilterString = "Item, ItemKey, Unit, Barcode";
	ItemListFilterStructure = New Structure(ItemListFilterString);
	
	SerialLotNumberListString = "SerialLotNumber";
	SerialLotNumberListFilterStructure = New Structure(SerialLotNumberListString);
	
	For Each ResultElement In Result Do
		
		FillPropertyValues(ItemListFilterStructure, ResultElement);
		ExistingRows = Object.ItemList.FindRows(ItemListFilterStructure);
		If ExistingRows.Count() Then
			Row = ExistingRows[0];
		Else
			Row = Object.ItemList.Add();
			FillPropertyValues(Row, ResultElement, ItemListFilterString);
			Row.Store = Form.Store;
			Row.Key = New UUID();
		EndIf;
		Row.Quantity = Row.Quantity + ResultElement.Quantity;
		
		FillPropertyValues(SerialLotNumberListFilterStructure, ResultElement);
		SerialLotNumberListExistingRows = Object.SerialLotNumbers.FindRows(SerialLotNumberListFilterStructure);
		If SerialLotNumberListExistingRows.Count() Then
			SerialLotNumberListRow = SerialLotNumberListExistingRows[0];
		Else
			SerialLotNumberListRow = Object.SerialLotNumbers.Add();
			FillPropertyValues(SerialLotNumberListRow, ResultElement, SerialLotNumberListString);
		EndIf;
		SerialLotNumberListRow.KeyRef = Row.Key;
		SerialLotNumberListRow.Quantity = SerialLotNumberListRow.Quantity + ResultElement.Quantity;
		
	EndDo;
	ItemListOnChange(Object, Form, Undefined, Undefined);
	SerialLotNumberListOnChange(Object, Form, Undefined);
EndProcedure

Procedure ItemListBeforeDeleteRow(Object, Form, Item, Cancel) Export
	
	CurrentData = Form.Items.ItemList.CurrentData;
	
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	SerialLotNumberListFilterStructure = New Structure;
	SerialLotNumberListFilterStructure.Insert("KeyRef", CurrentData.Key);
	SerialLotNumberListExistingRows = Object.SerialLotNumbers.FindRows(SerialLotNumberListFilterStructure);
	For Each Row In SerialLotNumberListExistingRows Do
		Object.SerialLotNumbers.Delete(Row);
	EndDo;
	
EndProcedure

Procedure SearchByBarcode(Barcode, Object, Form) Export
	DocumentsClient.SearchByBarcode(Barcode, Object, Form);
EndProcedure

Procedure SelectReceiptBasises(Object, Form, Command) Export
	FilterValues = New Structure("Company, Partner, LegalName");
	FilterValues.Company = Object.Company;
	FilterValues.Partner = ?(Form.Items.Partner.Visible, Object.Partner, Undefined);
	FilterValues.LegalName = ?(Form.Items.LegalName.Visible, Object.LegalName, Undefined);
	
	ExistingRows = New Array;
	For Each Row In Object.ItemList Do
		RowStructure = New Structure("Key, Unit, Quantity");
		FillPropertyValues(RowStructure, Row);
		ExistingRows.Add(RowStructure);
	EndDo;
	
	FormParameters = New Structure("FilterValues, ExistingRows, Ref", FilterValues, ExistingRows, Object.Ref);
	NotifyParameters = New Structure;
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", Form);
	NotifyParameters.Insert("Command", Command);
	OpenForm("Document.GoodsReceipt.Form.SelectReceiptBasisesForm"
		, FormParameters, , , ,
		, New NotifyDescription("SelectReceiptBasisesContinue", ThisObject, NotifyParameters));
EndProcedure

Procedure SelectReceiptBasisesContinue(Result, AdditionalParameters) Export
	
	Object = AdditionalParameters.Object;
	Form = AdditionalParameters.Form;
	
	If Result = Undefined Then
		Return;
	EndIf;
	
	For Each ResultRow In Result Do
		RowsByKey = Object.ItemList.FindRows(New Structure("Key", ResultRow.Key));
		If RowsByKey.Count() Then
			RowByKey = RowsByKey[0];
			ItemKeyUnit = CatItemsServer.GetItemKeyUnit(ResultRow.ItemKey);
			UnitFactorFrom = DocGoodsReceiptServer.GetUnitFactor(RowByKey.Unit, ItemKeyUnit);
			UnitFactorTo = DocGoodsReceiptServer.GetUnitFactor(ResultRow.Unit, ItemKeyUnit);
			FillPropertyValues(RowByKey, ResultRow, , "Quantity");
			RowByKey.Quantity = ?(UnitFactorTo = 0,
					0,
					RowByKey.Quantity * UnitFactorFrom / UnitFactorTo) + ResultRow.Quantity;
		Else
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, ResultRow);
		EndIf;
	EndDo;
	
	DocGoodsReceiptClient.ItemListOnChange(Object, Form, Form.Items.ItemList);
	
	Notify("ChoiceReceiptBasis", New Structure(), Result);
EndProcedure

Procedure SelectReceiptBasisInRowContinue(Result, AdditionalParameters) Export
	
	Object = AdditionalParameters.Object;
	Form = AdditionalParameters.Form;
	
	If Result = Undefined OR Not Result.Count() Then
		Return;
	EndIf;
	
	Row = Object.ItemList.FindByID(AdditionalParameters.CurrentRow);
	If Row = Undefined Then
		Return;
	EndIf;
	FillPropertyValues(Row, Result[0], "Key, ReceiptBasis, SalesOrder");
	
	DocGoodsReceiptClient.ItemListOnChange(Object, Form, Form.Items.ItemList);
	
	Notify("ChoiceReceiptBasis", New Structure(), Result);
EndProcedure

Procedure FillReceiptBasises(Object, Form, Command) Export
	
	FilterValues = New Structure("Company, Partner, LegalName");
	FillPropertyValues(FilterValues, Object);
	
	ExistingRows = New Array;
	For Each Row In Object.ItemList Do
		RowStructure = New Structure("ItemKey, Unit, Quantity, Store");
		FillPropertyValues(RowStructure, Row);
		ExistingRows.Add(RowStructure);
	EndDo;
	
	Object.ItemList.Clear();
	Result = DocGoodsReceiptServer.InfoReceiptBasisesFilling(FilterValues, ExistingRows, Object.Ref);
	For Each ResultRow In Result Do
		Row = Object.ItemList.Add();
		FillPropertyValues(Row, ResultRow);
	EndDo;
	
	DocGoodsReceiptClient.ItemListOnChange(Object, Form, Form.Items.ItemList);
EndProcedure

#Region PickUpItems

Procedure OpenPickupItems(Object, Form, Command) Export
	DocumentsClient.OpenPickupItems(Object, Form, Command); 
EndProcedure

#EndRegion

