

&AtClient
Var HTMLWindowPictures Export;

#Region Events

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	NewTransaction();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocRetailSalesReceiptClient.OnOpen(Object, ThisObject, Cancel);
	
	PictureViewerClient.UpdateObjectPictures(ThisObject, PredefinedValue("Catalog.ItemKeys.EmptyRef"));
	Items.DecorationTop.Title = CurrentDate();
	Items.ItemListPicture.PictureSize = PictureSize.Proportionally;
	ShowPictures();
	ShowItems();
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
	If NOT HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
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
	CurrentData = Items.ItemsPickup.CurrentData;
	AfterItemChoice(CurrentData.Item, True);
	ItemListOnChange(Items.ItemList);
	ItemListItemOnChange(Items.ItemList);
	ItemListItemKeyOnChange(Items.ItemList);
EndProcedure

&AtClient
Procedure ItemsPickupOnActivateRow(Item)
	CurrentData = Items.ItemsPickup.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	AfterItemChoice(CurrentData.Item);
	If NOT HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
	EndIf;
EndProcedure

#EndRegion

#Region ItemkeyPickupList

&AtClient
Procedure ItemKeysPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	CurrentData = Items.ItemKeysPickup.CurrentData;
	ItemKeysSelectionAtServer(CurrentData.Ref);
	ItemListOnChange(Items.ItemList);	
	ItemListItemKeyOnChange(Items.ItemList);
EndProcedure

#EndRegion

#Region Commands

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
				, New UUID()
				, 
				, 
				, OpenFormNotifyDescription
				, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

#EndRegion

#EndRegion

#Region Common

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
	//DocRetailSalesReceiptServer.CalculateTableAtServer(ThisObject, ObjectValue);
	EnabledPaymentButton();
EndProcedure

&AtServer
Procedure WriteTransaction(Result)
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
			Row.Commision = Row.Amount * Row.Percent / 100;
		EndIf; 
	EndDo;
	ObjectValue = FormAttributeToValue("Object");
	ObjectValue.Date = CurrentDate();
	ObjectValue.Payments.Load(Payments);
	ObjectValue.Write();	
	NewTransaction();
	Return;
EndProcedure

#EndRegion

&AtClient
Procedure ShowPictures()
	Items.ItemListShowPictures.Check = Not Items.PictureViewHTML.Visible;
	Items.PictureViewHTML.Visible = Items.ItemListShowPictures.Check;
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

#Region PictureViewer
&AtClient
Procedure PictureViewerHTMLDocumentComplete(Item)
	HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Item);
	HTMLWindowPictures.displayTarget("toolbar", False);
	AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
EndProcedure


&AtClient
Procedure UpdateHTMLPictures() Export
	If Not Items.PictureViewHTML.Visible Then
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
	JSON = CommonFunctionsServer.SerializeJSON(PictureInfo);
	HTMLWindowPictures.fillSlider(JSON);
	
	If PictureInfo.Pictures.Count()
		And CurrentItem = Items.ItemList Then
		CurrentRow.Picture = PictureInfo.Pictures[0].Preview;
	EndIf;
EndProcedure

#EndRegion

#Region RegionArea

&AtServer
Procedure AfterItemChoice(Val ChoicedItem, AddToItemList = False)	
	Query = New Query;
	Query.Text = "SELECT
			|CatalogItemKeys.Ref AS Ref
			|FROM
			|	Catalog.ItemKeys AS CatalogItemKeys
			|WHERE
			|	CatalogItemKeys.Item = &Item
			|	AND NOT CatalogItemKeys.DeletionMark";
	Query.SetParameter("Item", ChoicedItem);
	QueryExecute = Query.Execute();
	If QueryExecute.IsEmpty() Then
		ItemKeysPickup.Parameters.SetParameterValue("Item", ChoicedItem);
		Return;
	EndIf;
	QueryUnload = QueryExecute.Unload();
	If QueryUnload.Count() = 1
		And AddToItemList Then
		ItemKeysSelectionAtServer(QueryUnload[0].Ref);
	Else
		ItemKeysPickup.Parameters.SetParameterValue("Item", ChoicedItem);
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

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	
EndProcedure

&AtServer
Procedure PutToTaxTable_(ItemName, Key, Value) Export
	
EndProcedure

&AtClient
Procedure TaxTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	
EndProcedure

&AtClient
Procedure TaxTreeOnChange(Item)
	
EndProcedure

&AtClient
Procedure TaxTreeBeforeDeleteRow(Item, Cancel)
	
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
	
EndProcedure

#EndRegion

