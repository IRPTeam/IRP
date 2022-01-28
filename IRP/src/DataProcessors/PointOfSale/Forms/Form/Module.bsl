&AtClient
Var Component Export;

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTMLDate = GetCommonTemplate("HTMLClock").GetText();
	HTMLTextTemplate = GetCommonTemplate("HTMLTextField").GetText();
	Workstation = SessionParametersServer.GetSessionParameter("Workstation");
	If Workstation.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_103, "Workstation"));
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	NewTransaction();
	SetShowItems();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If Source = ThisObject Then
		DocRetailSalesReceiptClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);
	EndIf;

	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

#Region FormTableItemsEventHandlers

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailSalesReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	Items.DetailedInformation.document.getElementById("text").innerHTML = "";
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListOnChange(Object, ThisObject, Item);
	EnabledPaymentButton();
	ItemListOnActivateRow(Item);
	FillSalesPersonInItemList();
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Clone Then
		Item.CurrentData.Key = New UUID();
	EndIf;
	DocumentsClient.TableOnStartEdit(Object, ThisObject, "Object.ItemList", Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	DocRetailSalesReceiptClient.ItemListOnActivateRow(Object, ThisObject, Item);
	UpdateHTMLPictures();
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListItemOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
	UpdateHTMLPictures();
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item, AddInfo = Undefined) Export
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	TaxesClient.CalculateReverseTaxOnChangeTotalAmount(Object, ThisObject, CurrentData);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailSalesReceiptClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocRetailSalesReceiptClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#Region SerialLotNumbers
&AtClient
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListSerialLotNumbersPresentationStartChoice(Object, ThisObject, Item, ChoiceData,
		StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	DocRetailSalesReceiptClient.ItemListSerialLotNumbersPresentationClearing(Object, ThisObject, Item);
EndProcedure
#EndRegion

#EndRegion

#Region ItemListPickupEvents

&AtClient
Procedure ItemsPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	AddItemToItemList();
EndProcedure

&AtClient
Procedure AddItemToItemList()
	CurrentData = Items.ItemsPickup.CurrentData;
	ItemListOnActivateRow(Items.ItemList);
	Result = AfterItemChoice(CurrentData.Item, True);
	If Not Result Then
		Return;
	EndIf;
	ItemListOnStartEdit(Items.ItemList, True, False);
	ItemListOnChange(Items.ItemList);
	ItemListItemOnChange(Items.ItemList);
	ItemListItemKeyOnChange(Items.ItemList);
	CurrentDataItemList = Items.ItemList.CurrentData;

	BuildDetailedInformation(?(CurrentDataItemList = Undefined, Undefined, CurrentDataItemList.ItemKey));
EndProcedure

&AtClient
Procedure ItemsPickupOnActivateRow(Item)
	CurrentData = Items.ItemsPickup.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	AfterItemChoice(CurrentData.Item);
	UpdateHTMLPictures();
EndProcedure

#EndRegion

#Region ItemkeyPickupList

&AtClient
Procedure ItemKeysPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	AddItemKeyToItemList();
EndProcedure

&AtClient
Procedure AddItemKeyToItemList()
	Var CurrentData;
	CurrentData = Items.ItemKeysPickup.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ItemKeysSelectionAtServer(CurrentData.Ref);
	ItemListOnStartEdit(Items.ItemList, True, False);
	ItemListOnChange(Items.ItemList);
	ItemListItemKeyOnChange(Items.ItemList);

	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.Ref));
EndProcedure

#EndRegion

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, CurrentPriceType);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	If AdditionalParameters.FoundedItems.Count() Then
		NotifyParameters = New Structure();
		NotifyParameters.Insert("Form", ThisObject);
		NotifyParameters.Insert("Object", Object);
		Items.DetailedInformation.document.getElementById("text").innerHTML = "";
		DocumentsClient.PickupItemsEnd(AdditionalParameters.FoundedItems, NotifyParameters);
	Else
		DetailedInformation = "<span style=""color:red;"">" + StrTemplate(R().S_019, StrConcat(
			AdditionalParameters.Barcodes, ",")) + "</span>";
		Items.DetailedInformation.document.getElementById("text").innerHTML = DetailedInformation;
	EndIf;
EndProcedure

&AtClient
Procedure qPayment(Command)

	Object.Date = CommonFunctionsServer.GetCurrentSessionDate();

	If Not CheckFilling() Then
		Cancel = True;
		Return;
	EndIf;

	Cancel = False;
	DPPointOfSaleClient.BeforePayment(ThisObject, Cancel);

	If Cancel Then
		Return;
	EndIf;

	OpenFormNotifyDescription = New NotifyDescription("PaymentFormClose", ThisObject);
	ObjectParameters = New Structure();
	ObjectParameters.Insert("Amount", Object.ItemList.Total("TotalAmount"));
	ObjectParameters.Insert("Branch", Object.Branch);
	ObjectParameters.Insert("Workstation", Workstation);
	OpenFormParameters = New Structure();
	OpenFormParameters.Insert("Parameters", ObjectParameters);
	OpenForm("DataProcessor.PointOfSale.Form.Payment", OpenFormParameters, ThisObject, UUID, , ,
		OpenFormNotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure DocReturn(Command)
	OpenForm("Document.RetailReturnReceipt.ObjectForm");
EndProcedure

&AtClient
Procedure CancelReceipt(Command)
	Return;
EndProcedure

&AtClient
Procedure ChangeCashier(Command)
	Return;
EndProcedure

&AtClient
Procedure CloseButton(Command)
	Close();
EndProcedure

&AtClient
Procedure CalculateOffers(Command)
	Return;
EndProcedure

&AtClient
Procedure PrintReceipt(Command)
	Cancel = False;
	DPPointOfSaleClient.PrintLastReceipt(ThisObject, Cancel);
EndProcedure

&AtClient
Procedure SearchCustomer(Command)

	Notify = New NotifyDescription("SetRetailCustomer", ThisObject);
	OpenForm("Catalog.RetailCustomers.Form.QuickSearch", New Structure("RetailCustomer", Object.RetailCustomer), , , ,
		, Notify, FormWindowOpeningMode.LockOwnerWindow);

EndProcedure

&AtClient
Procedure SetRetailCustomer(Value, AddInfo = Undefined) Export
	If ValueIsFilled(Value) Then
		Object.RetailCustomer = Value;
		DocRetailSalesReceiptClient.RetailCustomerPointOfSaleOnChange(Object, ThisObject,
			ThisObject.Items.RetailCustomer);
	EndIf;
EndProcedure

&AtClient
Procedure ItemListDrag(Item, DragParameters, StandardProcessing, Row, Field)

	AddItemKeyToItemList();

EndProcedure

#Region SpecialOffers

#Region Offers_for_document

&AtClient
Procedure SetSpecialOffers(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object, ThisObject, "SpecialOffersEditFinish_ForDocument");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForDocument(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForDocument(Result, Object, ThisObject, AdditionalParameters);

EndProcedure

#EndRegion

#Region Offers_for_row

&AtClient
Procedure SetSpecialOffersAtRow(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, Items.ItemList.CurrentData, ThisObject,
		"SpecialOffersEditFinish_ForRow");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForRow(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForRow(Result, Object, ThisObject, AdditionalParameters);
EndProcedure

#EndRegion

#EndRegion
#EndRegion

#EndRegion

#Region Private

#Region PictureViewer

&AtClient
Procedure UpdateHTMLPictures() Export
	If Not Items.ItemPicture.Visible Then
		Return;
	EndIf;

	If CurrentItem = Items.ItemList Then
		CurrentRow = Items.ItemList.CurrentData;
	ElsIf CurrentItem = Items.ItemsPickup Then
		CurrentRow = Items.ItemsPickup.CurrentData;
	Else
		CurrentRow = Undefined;
	EndIf;

	If CurrentRow = Undefined Then
		Return;
	EndIf;

	ItemPicture = GetURL(GetPictureFile(CurrentRow.Item), "Preview");
EndProcedure

&AtServerNoContext
Function GetPictureFile(Item)
	ArrayOfFiles = PictureViewerServer.GetPicturesByObjectRefAsArrayOfRefs(Item);
	If ArrayOfFiles.Count() Then
		If ArrayOfFiles[0].isPreviewSet Then
			Return ArrayOfFiles[0];
		EndIf;
	Else
		Return Catalogs.Files.EmptyRef();
	EndIf;
EndFunction

#EndRegion

#Region SalesPerson

&AtClient
Procedure SetSalesPerson(Command)
	SetDefaultSalesPerson();
EndProcedure

&AtClient
Async Procedure SetDefaultSalesPerson()
	SalesPersons = GetSalesPersonsAtServer();
	If SalesPersons.Count() = 1 Then
		SalesPersonByDefault = SalesPersons[0];
	ElsIf SalesPersons.Count() > 1 Then
		SelectDefPerson = New ValueList();
		SelectDefPerson.LoadValues(SalesPersons);
		SelectDefPersonValue = Await SelectDefPerson.ChooseItemAsync(R().POS_s5);
		If Not SelectDefPersonValue = Undefined Then
			SalesPersonByDefault = SelectDefPersonValue.Value;
		EndIf;
	Else
		SalesPersonByDefault = Undefined;
	EndIf;
	
	If Not SalesPersonByDefault.IsEmpty() Then
		FillSalesPersonInItemList();
		For Each Row In Items.ItemList.SelectedRows Do
			ObjRow = Object.ItemList.FindByID(Row);
			ObjRow.SalesPerson = SalesPersonByDefault;
		EndDo;
	EndIf;
 
EndProcedure

&AtClient
Async Procedure FillSalesPersonInItemList()
	If SalesPersonByDefault.IsEmpty() Then
		SetDefaultSalesPerson();
	EndIf;
	
	For Each Row In Object.ItemList Do
		If Row.SalesPerson.IsEmpty() Then
			Row.SalesPerson = SalesPersonByDefault;
		EndIf;
	EndDo;
EndProcedure


&AtServer
Function GetSalesPersonsAtServer()
	Query = New Query;
	Query.Text =
		"SELECT ALLOWED
		|	RetailWorkers.Worker
		|FROM
		|	InformationRegister.RetailWorkers AS RetailWorkers
		|WHERE
		|	RetailWorkers.Store = &Store
		|GROUP BY
		|	RetailWorkers.Worker
		|AUTOORDER";
	
	Query.SetParameter("Store", Store);
	
	QueryResult = Query.Execute().Unload().UnloadColumn("Worker");
	
	Return QueryResult;
EndFunction

#EndRegion

#Region RegionArea

&AtClient
Procedure PaymentFormClose(Result, AdditionalData) Export

	If Result = Undefined Then
		Return;
	EndIf;
	CashbackAmount = WriteTransaction(Result);
	DetailedInformation = R().S_030 + ": " + Format(CashbackAmount, "NFD=2; NZ=0;");
	Items.DetailedInformation.document.getElementById("text").innerHTML = DetailedInformation;

	NewTransaction();
	Modified = False;
EndProcedure

&AtClient
Procedure NewTransaction()
	NewTransactionAtServer();
	Cancel = False;
	DocRetailSalesReceiptClient.OnOpen(Object, ThisObject, Cancel);
	EnabledPaymentButton();
EndProcedure

&AtServer
Procedure NewTransactionAtServer()
	ObjectValue = Documents.RetailSalesReceipt.CreateDocument();
	FillingWithDefaultDataEvent.FillingWithDefaultDataFilling(ObjectValue, Undefined, Undefined, True);
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ValueToFormAttribute(ObjectValue, "Object");
	Cancel = False;
	DocRetailSalesReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, True);
	SalesPersonByDefault = Undefined;
EndProcedure

&AtServer
Function WriteTransaction(Result)
	OneHundred = 100;
	If Result = Undefined Or Not Result.Payments.Count() Then
		Return 0;
	EndIf;
	Payments = Result.Payments.Unload();
	ZeroAmountFilter = New Structure();
	ZeroAmountFilter.Insert("Amount", 0);
	ZeroAmountFoundRows = Payments.FindRows(ZeroAmountFilter);
	ZeroAmountRows = New Array();
	For Each Row In ZeroAmountFoundRows Do
		ZeroAmountRows.Add(Row);
	EndDo;
	For Each Row In ZeroAmountRows Do
		Payments.Delete(Row);
	EndDo;
	For Each Row In Payments Do
		If Row.Percent Then
			Row.Commission = Row.Amount * Row.Percent / OneHundred;
		EndIf;
	EndDo;

	ObjectValue = FormAttributeToValue("Object");
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ObjectValue.Payments.Load(Payments);
	DPPointOfSaleServer.BeforePostingDocument(ObjectValue);

	ObjectValue.Write(DocumentWriteMode.Posting);
	DocRef = ObjectValue.Ref;
	DPPointOfSaleServer.AfterPostingDocument(DocRef);
	CashAmountFilter = New Structure();
	CashAmountFilter.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.Cash"));
	CashAmountFoundRows = Payments.FindRows(CashAmountFilter);
	CashbackAmount = 0;
	For Each Row In CashAmountFoundRows Do
		If Row.Amount < 0 Then
			CashbackAmount = CashbackAmount + Row.Amount * (-1);
		EndIf;
	EndDo;

	Return CashbackAmount;
EndFunction

&AtClient
Procedure ShowPictures()
	Items.ItemListShowPictures.Check = Not Items.ItemPicture.Visible;
	Items.ItemPicture.Visible = Items.ItemListShowPictures.Check;
EndProcedure

&AtClient
Procedure ShowItems()
	Items.ItemListShowItems.Check = Not Items.ItemListShowItems.Check;
	SetShowItems();
EndProcedure

&AtClient
Procedure SetShowItems()
	Items.GroupPickupItems.Visible = Items.ItemListShowItems.Check;
	CurrentData = Items.ItemsPickup.CurrentData;
	If CurrentData <> Undefined Then
		AfterItemChoice(CurrentData.Item);
	Else
		AfterItemChoice(PredefinedValue("Catalog.Items.EmptyRef"));
	EndIf;
EndProcedure

&AtServer
Function AfterItemChoice(Val ChoicedItem, AddToItemList = False)
	ReturnValue = False;
	Query = New Query();
	Query.Text = "SELECT
				 |	CatalogItemKeys.Ref AS Ref,
				 |	CatalogItemKeys.Ref AS Presentation
				 |FROM
				 |	Catalog.ItemKeys AS CatalogItemKeys
				 |WHERE
				 |	CatalogItemKeys.Item = &Item
				 |	AND NOT CatalogItemKeys.DeletionMark
				 |ORDER BY
				 |	Ref";
	Query.SetParameter("Item", ChoicedItem);
	QueryExecute = Query.Execute();
	QueryUnload = QueryExecute.Unload();
	ItemKeysPickup.Load(QueryUnload);
	If QueryUnload.Count() = 1 And AddToItemList Then
		ItemKeysSelectionAtServer(QueryUnload[0].Ref);
		ReturnValue = True;
	EndIf;
	Return ReturnValue;
EndFunction

&AtServer
Procedure ItemKeysSelectionAtServer(Val ChoicedItemKey)
	ItemListFilter = New Structure();
	ItemListFilter.Insert("ItemKey", ChoicedItemKey);
	FoundRows = Object.ItemList.FindRows(ItemListFilter);
	If FoundRows.Count() Then
		NewRow = FoundRows.Get(0);
	Else
		NewRow = Object.ItemList.Add();
		NewRow.ItemKey = ChoicedItemKey;
		NewRow.Item = ChoicedItemKey.Item;
	EndIf;
	NewRow.Quantity = NewRow.Quantity + 1;
	NewRow.TotalAmount = NewRow.Quantity * NewRow.Price;
	Items.ItemList.CurrentRow = NewRow.GetID();
	EnabledPaymentButton();
EndProcedure

&AtServer
Procedure EnabledPaymentButton()
	Items.qPayment.Enabled = Object.ItemList.Count();
EndProcedure

&AtClient
Procedure BuildDetailedInformation(ItemKey)
	If Not ValueIsFilled(ItemKey) Then
		DetailedInformation = "";
		Return;
	EndIf;
	ItemListFilter = New Structure();
	ItemListFilter.Insert("ItemKey", ItemKey);
	FoundItemKeyRows = Object.ItemList.FindRows(ItemListFilter);
	InfoItem = PredefinedValue("Catalog.Items.EmptyRef");
	InfoPrice = 0;
	InfoQuantity = 0;
	InfoOffersAmount = 0;
	InfoTotalAmount = 0;
	For Each FoundItemKeyRow In FoundItemKeyRows Do
		InfoItem = FoundItemKeyRow.Item;
		InfoPrice = FoundItemKeyRow.Price;
		InfoOffersAmount = InfoOffersAmount + FoundItemKeyRow.OffersAmount;
		InfoQuantity = InfoQuantity + FoundItemKeyRow.Quantity;
		InfoTotalAmount = InfoTotalAmount + FoundItemKeyRow.TotalAmount;
	EndDo;
	DetailedInformation = String(InfoItem) + ?(ValueIsFilled(ItemKey), " [" + String(ItemKey) + "]", "]") + " " + InfoQuantity
		+ " x " + Format(InfoPrice, "NFD=2; NZ=0.00;") + ?(ValueIsFilled(InfoOffersAmount), "-" + Format(
		InfoOffersAmount, "NFD=2; NZ=0.00;"), "") + " = " + Format(InfoTotalAmount, "NFD=2; NZ=0.00;");
	Items.DetailedInformation.document.getElementById("text").innerHTML = DetailedInformation;
EndProcedure

&AtClient
Procedure ClearRetailCustomer(Command)
	Object.RetailCustomer = Undefined;
	DocRetailSalesReceiptClient.RetailCustomerPointOfSaleOnChange(Object, ThisObject, Undefined);

	ClearRetailCustomerAtServer();
	DocRetailSalesReceiptClient.AgreementOnChange(Object, ThisObject, Items.RetailCustomer);
EndProcedure

&AtServer
Procedure ClearRetailCustomerAtServer()
	ObjectValue = FormAttributeToValue("Object");
	FillingWithDefaultDataEvent.FillingWithDefaultDataFilling(ObjectValue, Undefined, Undefined, True, True);
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ValueToFormAttribute(ObjectValue, "Object");
	For Each Row In Object.ItemList Do
		If ValueIsFilled(Row.ItemKey) Then
			Row.Item = Row.ItemKey.Item;
		Else
			Row.Item = Undefined;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	Return;
EndProcedure

&AtServer
Procedure PutToTaxTable_(ItemName, Key, Value) Export
	Return;
EndProcedure

&AtServer
Procedure Taxes_CreateFormControls() Export
	ColumnFieldParameters = New Structure();
	ColumnFieldParameters.Insert("Visible", False);

	TaxesParameters = TaxesServer.GetCreateFormControlsParameters();
	TaxesParameters.Date = Object.Date;
	TaxesParameters.Company = Object.Company;
	TaxesParameters.PathToTable = "Object.ItemList";
	TaxesParameters.ItemParent = ThisObject.Items.ItemList;
	TaxesParameters.ColumnOffset = ThisObject.Items.ItemListOffersAmount;
	TaxesParameters.ItemListName = "ItemList";
	TaxesParameters.TaxListName = "TaxList";
	TaxesParameters.TotalAmountColumnName = "ItemListTotalAmount";
	TaxesParameters.ColumnFieldParameters = ColumnFieldParameters;
	TaxesServer.CreateFormControls(Object, ThisObject, TaxesParameters);
EndProcedure

&AtServer
Procedure Taxes_CreateTaxTree() Export
	Return;
EndProcedure

#EndRegion

#EndRegion
