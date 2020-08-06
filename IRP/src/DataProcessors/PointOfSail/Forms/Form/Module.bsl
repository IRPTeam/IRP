

&AtClient
Var HTMLWindowPictures Export;

#Region Events

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	NewTransaction();
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	For Each Row In Object.ItemList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;	
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item)
	DocRetailSalesReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemsPickupOnActivateRow(Item)
	CurrentData = Items.ItemsPickup.CurrentData;
	AfterItemChoice(CurrentData.Item);
	If NOT HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
	EndIf;
EndProcedure

&AtClient
Procedure ItemsPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	CurrentData = Items.ItemsPickup.CurrentData;
	AfterItemChoice(CurrentData.Item, True);
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
	ObjectParameters.Insert("CustomerCash", Object.ItemList.Total("TotalAmount"));
	OpenFormParameters = New Structure;
	OpenFormParameters.Insert("Parameters", ObjectParameters);
	OpenForm("DataProcessor.PointOfSail.Form.Payment"
				, OpenFormParameters
				, ThisObject
				, New UUID()
				, 
				, 
				, OpenFormNotifyDescription
				, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

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
EndProcedure

&AtServer
Procedure WriteTransaction(Result)
	Payments = Result.Payments;
	If Not Payments.Total("Amount") Then
		Return;
	EndIf;
	ObjectValue = FormAttributeToValue("Object");
	ObjectValue.Date = CurrentDate();
	ObjectValue.Write();	
	NewTransaction();
	Return;
EndProcedure

#EndRegion

&AtClient
Procedure OnOpen(Cancel)
	PictureViewerClient.UpdateObjectPictures(ThisObject, PredefinedValue("Catalog.ItemKeys.EmptyRef"));
	Items.DecorationTop.Title = CurrentDate();
	Items.ItemListPicture.PictureSize = PictureSize.Proportionally;
	ShowPictures();
	ShowItems();
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	If NOT HTMLWindowPictures = Undefined Then
		HTMLWindowPictures.clearAll();
		AttachIdleHandler("UpdateHTMLPictures", 0.1, True);
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocRetailSalesReceiptClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
	UpdateHTMLPictures();
EndProcedure


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
Procedure AfterItemChoice(ChoicedItem, AddToItemList = False)	
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

&AtClient
Procedure ItemListQuantityOnChange(Item)
	RecalculateAmount();
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item)
	RecalculateAmount();
EndProcedure

&AtClient
Procedure RecalculateAmount()
	For Each Row In Object.ItemList Do
		Row.TotalAmount = Row.Quantity * Row.Price;
	EndDo;
EndProcedure

&AtClient
Procedure ItemKeysSelection(Item, SelectedRow, Field, StandardProcessing)
	CurrentData = Items.ItemKeysPickup.CurrentData;
	ItemKeysSelectionAtServer(CurrentData.Ref);
	ItemListItemOnChange(Item);
EndProcedure

&AtServer
Procedure ItemKeysSelectionAtServer(ChoicedItemKey)
	ItemListFilter = New Structure
	ItemListFilter.Insert("ItemKey", ChoicedItemKey);
	FoundRows = Object.ItemList.FindRows(ItemListFilter);
	If FoundRows.Count() Then
		NewRow = FoundRows.Get(0);
		Items.ItemList.CurrentRow = NewRow;
	Else
		NewRow = Object.ItemList.Add();
		NewRow.ItemKey = ChoicedItemKey;
		NewRow.Item = NewRow.ItemKey.Item;
	EndIf;
	NewRow.Quantity = NewRow.Quantity + 1;	
	NewRow.TotalAmount = NewRow.Quantity * NewRow.Price;
EndProcedure

#EndRegion

