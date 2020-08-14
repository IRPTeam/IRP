
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DetailedInformation = Format(CurrentSessionDate(), "DLF=DDT");
	NewTransaction();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.OnOpen(Object, ThisObject, Cancel);
	Items.ItemListPicture.PictureSize = PictureSize.Proportionally;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If Not Source = ThisObject Then
		Return;
	EndIf;	
	DocRetailSalesReceiptClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);
EndProcedure

&AtClient
Procedure ExternalEvent(Source, Event, Data)
	If Data <> Undefined Then
		NotifyParameters = New Structure;
		NotifyParameters.Insert("Form", ThisObject);
		NotifyParameters.Insert("Object", Object);
		NotifyParameters.Insert("ClientModule", ThisObject);
		BarcodeClient.InputBarcodeEnd(Data, NotifyParameters);
	EndIf;
EndProcedure

#Region FormTableItemsEventHandlers

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailSalesReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.ItemListOnChange(Object, ThisObject, Item);
	EnabledPaymentButton();
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
	If CurrentData <> Undefined Then
		BuildDetailedInformation(CurrentData.ItemKey);
	EndIf;
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

#EndRegion

#Region ItemListPickupEvents

&AtClient
Procedure ItemsPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.ItemsPickup.CurrentData;
	AfterItemChoice(CurrentData.Item, True);
	ItemListOnChange(Items.ItemList);
	ItemListItemOnChange(Items.ItemList);
	ItemListItemKeyOnChange(Items.ItemList);
	CurrentDataItemList = Items.ItemList.CurrentData;
	If CurrentDataItemList <> Undefined Then
		BuildDetailedInformation(CurrentDataItemList.ItemKey);
	EndIf;
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
	CurrentData = Items.ItemKeysPickup.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ItemKeysSelectionAtServer(CurrentData.Ref);
	ItemListOnChange(Items.ItemList);	
	ItemListItemKeyOnChange(Items.ItemList);
	BuildDetailedInformation(CurrentData.Ref);
EndProcedure

#EndRegion

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure OpenPickupItems(Command)
	DocumentsClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command)
	DocumentsClient.SearchByBarcode(Command, Object, ThisObject, , ThisObject.CurrentPriceType);
EndProcedure

&AtClient
Procedure qPayment(Command)
	OpenFormNotifyDescription = New NotifyDescription("PaymentFormClose", ThisObject);
	ObjectParameters = New Structure;
	ObjectParameters.Insert("Amount", Object.ItemList.Total("TotalAmount"));
	ObjectParameters.Insert("BusinessUnit", Object.BusinessUnit);
	OpenFormParameters = New Structure;
	OpenFormParameters.Insert("Parameters", ObjectParameters);
	OpenForm("DataProcessor.PointOfSale.Form.Payment"
				, OpenFormParameters
				, ThisObject
				, UUID
				, 
				, 
				, OpenFormNotifyDescription
				, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure Refund(Command)
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
	Return;
EndProcedure

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
		
	PictureInfo = PictureViewerClient.PicturesInfoForSlider(CurrentRow.Item, UUID);
	
	If PictureInfo.Pictures.Count() Then
		ItemPicture = PictureInfo.Pictures[0].Preview;
		If CurrentItem = Items.ItemList Then
			CurrentRow.Picture = PictureInfo.Pictures[0].Preview;
		EndIf;
	EndIf;
EndProcedure

#EndRegion

#Region RegionArea

&AtClient
Procedure PaymentFormClose(Result, AdditionalData) Export
	WriteTransaction(Result);
EndProcedure

&AtServer
Procedure NewTransaction()
	ObjectValue = Documents.RetailSalesReceipt.CreateDocument();
	FillingWithDefaultDataEvent.FillingWithDefaultDataFilling(ObjectValue, Undefined, Undefined, True);
	ValueToFormAttribute(ObjectValue, "Object");
	ThisObject.CurrentPartner = ObjectValue.Partner;
	ThisObject.CurrentAgreement = ObjectValue.Agreement;
	ThisObject.CurrentDate = ObjectValue.Date;
	EnabledPaymentButton();
EndProcedure

&AtServer
Procedure WriteTransaction(Result)
	OneHundred = 100;
	If Result = Undefined 
		Or Not Result.Payments.Count() Then
		Return;
	EndIf;
	Payments = Result.Payments.Unload();
	ZeroAmountFilter = New Structure;
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
	ObjectValue.Date = CurrentSessionDate();
	ObjectValue.Payments.Load(Payments);
	ObjectValue.Write();
	CashAmountFilter = New Structure;
	CashAmountFilter.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.Cash"));
	CashAmountFoundRows = Payments.FindRows(CashAmountFilter);
	CashbackAmount = 0;
	For Each Row In CashAmountFoundRows Do
		If Row.Amount < 0 Then
			CashbackAmount = CashbackAmount + Row.Amount * (-1);
		EndIf;
	EndDo;
	If CashbackAmount Then
		DetailedInformation = "Cashback: " + Format(CashbackAmount, "NFD=2;");
	EndIf;
	NewTransaction();
	Return;
EndProcedure

&AtClient
Procedure ShowPictures()
	Items.ItemListShowPictures.Check = Not Items.ItemPicture.Visible;
	Items.ItemPicture.Visible = Items.ItemListShowPictures.Check;
EndProcedure

&AtClient
Procedure ShowItems()
	Items.ItemListShowItems.Check = Not Items.ItemsPickup.Visible;
	Items.ItemsPickup.Visible = Items.ItemListShowItems.Check;
	CurrentData = Items.ItemsPickup.CurrentData;
	If CurrentData <> Undefined Then
		AfterItemChoice(CurrentData.Item);
	Else
		AfterItemChoice(PredefinedValue("Catalog.Items.EmptyRef"));
	EndIf;
	Items.ItemKeysPickup.Visible = Items.ItemListShowItems.Check;
EndProcedure

&AtServer
Procedure AfterItemChoice(Val ChoicedItem, AddToItemList = False)	
	Query = New Query;
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
	If QueryUnload.Count() = 1
		And AddToItemList Then
		ItemKeysSelectionAtServer(QueryUnload[0].Ref);
	EndIf;
EndProcedure

&AtServer
Procedure ItemKeysSelectionAtServer(Val ChoicedItemKey)
	ItemListFilter = New Structure;
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
	DetailedInformation = String(InfoItem)
						+ ?(ValueIsFilled(ItemKey), " " + String(ItemKey), "")
						+ " " + Format(InfoQuantity, "NFD=2;")
						+ " x " + Format(InfoPrice, "NFD=2;")
						+ ?(ValueIsFilled(InfoOffersAmount), "-" + Format(InfoOffersAmount, "NFD=2;"), "")
						+ " = " + Format(InfoTotalAmount, "NFD=2;");
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
    TaxesParameters = TaxesServer.GetCreateFormControlsParameters();
    TaxesParameters.Date = Object.Date;
    TaxesParameters.Company = Object.Company;
    TaxesParameters.PathToTable = "Object.ItemList";
    TaxesParameters.ItemParent = ThisObject.Items.ItemList;
    TaxesParameters.ColumnOffset = ThisObject.Items.ItemListOffersAmount;
    TaxesParameters.ItemListName = "ItemList";
    TaxesParameters.TaxListName = "TaxList";
    TaxesParameters.TotalAmountColumnName = "ItemListTotalAmount";
    TaxesServer.CreateFormControls(Object, ThisObject, TaxesParameters);
EndProcedure

&AtServer
Procedure Taxes_CreateTaxTree() Export
	Return;
EndProcedure

#EndRegion

#EndRegion
