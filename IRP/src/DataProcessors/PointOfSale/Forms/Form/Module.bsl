
&AtClient
Var Component Export;

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.HTMLDate = GetCommonTemplate("HTMLClock").GetText();
	ThisObject.HTMLTextTemplate = GetCommonTemplate("HTMLTextField").GetText();
	Workstation = SessionParametersServer.GetSessionParameter("Workstation");
	If Workstation.IsEmpty() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_103, "Workstation"));
	EndIf;
	
	If SessionParameters.isMobile Then
		
		Items.HTMLDate.Visible = False;
		Items.DetailedInformation.Visible = False;
		
		Items.GroupHeaderTop.Group = ChildFormItemsGroup.Vertical;
		Items.Move(Items.GroupHeaderTop, Items.AdditionalPage);
		
		Items.Move(Items.PageButtons, ThisObject);
		Items.Move(Items.GroupPicture, Items.GroupPaymentLeft);
		Items.Move(Items.PagePayment, Items.PageButtons);
		Items.PageButtons.PagesRepresentation = FormPagesRepresentation.TabsOnBottom;
		Items.GroupPaymentRight.ShowTitle = False;

	EndIf;
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		FillCashInList();
	EndIf;
		
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	NewTransaction();
	SetShowItems();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		SessionIsCreated = Not Object.ConsolidatedRetailSales.IsEmpty();
		If SessionIsCreated Then
			Status = CommonFunctionsServer.GetRefAttribute(Object.ConsolidatedRetailSales, "Status");
			Form.Items.OpenSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.New");
			Form.Items.CloseSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.Open");
			Form.Items.CancelSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.New");
			Form.Items.GroupCommonCommands.Visible = True;
		Else
			Form.Items.OpenSession.Enabled = Not SessionIsCreated;
			Form.Items.CloseSession.Enabled = SessionIsCreated;
			Form.Items.CancelSession.Enabled = SessionIsCreated;
		EndIf;
	Else
		Form.Items.GroupCommonCommands.Visible = False;
	EndIf;
	
	Form.Items.GroupCashCommands.Visible = 
		CommonFunctionsServer.GetRefAttribute(Form.Workstation, "UseCashInAndCashOut");
EndProcedure

#Region AGREEMENT

&AtClient
Procedure AgreementOnChange(Item)
	DocRetailSalesReceiptClient.AgreementOnChange(Object, ThisObject, Item);
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocRetailSalesReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocRetailSalesReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region CONSOLIDATED_RETAIL_SALES

&AtClient
Async Procedure OpenSession(Command)
	DocConsolidatedRetailSales = DocConsolidatedRetailSalesServer.CreateDocument(Object.Company, Object.Branch, ThisObject.Workstation);

	EquipmentOpenShiftResult = Await EquipmentFiscalPrinterClient.OpenShift(DocConsolidatedRetailSales);
	If EquipmentOpenShiftResult.Success Then
		DocConsolidatedRetailSalesServer.DocumentOpenShift(DocConsolidatedRetailSales, EquipmentOpenShiftResult);
		ChangeConsolidatedRetailSales(Object, ThisObject, DocConsolidatedRetailSales);
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);
		
		SetVisibilityAvailability(Object, ThisObject);
		EnabledPaymentButton();
	EndIf;
EndProcedure

&AtClient
Procedure CloseSession(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Currency", Object.Currency);
	FormParameters.Insert("Store", ThisObject.Store);
	FormParameters.Insert("Workstation", Object.Workstation);
	FormParameters.Insert("ConsolidatedRetailSales", Object.ConsolidatedRetailSales);
	
	NotifyDescription = New NotifyDescription("CloseSessionFinish", ThisObject);
	
	OpenForm(
		"DataProcessor.PointOfSale.Form.SessionClosing", 
		FormParameters, ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Async Procedure CloseSessionFinish(Result, AddInfo) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	EquipmentCloseShiftResult = Await EquipmentFiscalPrinterClient.CloseShift(Object.ConsolidatedRetailSales);
	If EquipmentCloseShiftResult.Success Then
		DocConsolidatedRetailSalesServer.DocumentCloseShift(Object.ConsolidatedRetailSales, EquipmentCloseShiftResult, Result);
		ChangeConsolidatedRetailSales(Object, ThisObject, Undefined);
	
		SetVisibilityAvailability(Object, ThisObject);
		EnabledPaymentButton();
	EndIf;
EndProcedure

&AtClient
Procedure CancelSession(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Currency", Object.Currency);
	FormParameters.Insert("Store", ThisObject.Store);
	FormParameters.Insert("Workstation", Object.Workstation);
	FormParameters.Insert("ConsolidatedRetailSales", Object.ConsolidatedRetailSales);
	
	NotifyDescription = New NotifyDescription("CancelSessionFinish", ThisObject);
	
	OpenForm(
		"DataProcessor.PointOfSale.Form.SessionClosing", 
		FormParameters, ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure CancelSessionFinish(Result, AddInfo) Export
	If Not Result = DialogReturnCode.OK Then
		Return;
	EndIf;
	
	DocConsolidatedRetailSalesServer.CancelDocument(Object.ConsolidatedRetailSales);
	ChangeConsolidatedRetailSales(Object, ThisObject, Undefined);
	
	SetVisibilityAvailability(Object, ThisObject);
	EnabledPaymentButton();
EndProcedure
			
#EndRegion

#Region FormTableItemsEventHandlers

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailSalesReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	SetDetailedInfo("");
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	EnabledPaymentButton();
	FillSalesPersonInItemList();
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	Return;
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	UpdateHTMLPictures();
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListItemOnChange(Item)
	DocRetailSalesReceiptClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item)
	DocRetailSalesReceiptClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
	UpdateHTMLPictures();
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocRetailSalesReceiptClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item)
	DocRetailSalesReceiptClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item)
	DocRetailSalesReceiptClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item)
	DocRetailSalesReceiptClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
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
Procedure ItemListSerialLotNumbersPresentationStartChoice(Item, ChoiceData, StandardProcessing) Export
	SerialLotNumberClient.PresentationStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListSerialLotNumbersPresentationClearing(Item, StandardProcessing)
	SerialLotNumberClient.PresentationClearing(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemListPickupEvents

&AtClient
Procedure ItemsPickupSelection(Item, SelectedRow, Field, StandardProcessing)
	
	CurrentData = Items.ItemsPickup.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If Not CurrentData.Property("Ref") Then
		Return;
	EndIf;
	StandardProcessing = False;
	
	AddItemKeyToItemList(CurrentData.Ref);
EndProcedure

&AtClient
Procedure ItemsPickupOnActivateRow(Item)
	UpdateHTMLPictures();
EndProcedure

#EndRegion

#Region ItemkeyPickupList

&AtClient
Procedure AddItemKeyToItemList(ItemKey)
	
	Result = New Structure("FoundedItems", GetItemInfo.GetInfoByItemsKey(ItemKey));
	SearchByBarcodeEnd(Result, New Structure());
	
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
	PriceType = PredefinedValue("Catalog.PriceKeys.EmptyRef");
	If ValueIsFilled(Object.Agreement) Then
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(Object.Agreement);
		PriceType = AgreementInfo.PriceType;
	EndIf;
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject, PriceType);
EndProcedure

&AtClient
Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	If Result.FoundedItems.Count() Then
		FillSalesPersonInItemList();
		
		NotifyParameters = New Structure();
		NotifyParameters.Insert("Form", ThisObject);
		NotifyParameters.Insert("Object", Object);
		SetDetailedInfo("");
		DocumentsClient.PickupItemsEnd(Result.FoundedItems, NotifyParameters);
		EnabledPaymentButton();
		
		If Not SalesPersonByDefault.IsEmpty() Then
			FillSalesPersonInItemList();
		EndIf;
		
	Else
		
		DetailedInformation = "<span style=""color:red;"">" + StrTemplate(R().S_019, StrConcat(
			Result.Barcodes, ",")) + "</span>";
		SetDetailedInfo(DetailedInformation);
		
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

	OpenForm("DataProcessor.PointOfSale.Form.Payment", ObjectParameters, ThisObject, UUID, , ,
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
	OpenForm("Catalog.RetailCustomers.Form.QuickSearch", New Structure("RetailCustomer", Object.RetailCustomer), ThisObject, , ,
		, Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure SetRetailCustomer(Value, AddInfo = Undefined) Export
	If ValueIsFilled(Value) Then
		Object.RetailCustomer = Value;
		DocRetailSalesReceiptClient.RetailCustomerOnChange(Object, ThisObject,
			ThisObject.Items.RetailCustomer);
	EndIf;
EndProcedure

&AtClient
Procedure ItemListDrag(Item, DragParameters, StandardProcessing, Row, Field)
	StandardProcessing = False;
	If DragParameters.Action = DragAction.Move And DragParameters.Value.Count() Then
		Value = DragParameters.Value[0];
		If TypeOf(Value) = Type("CatalogRef.ItemKeys") Then
			AddItemKeyToItemList(Value);
		EndIf;
	EndIf;
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
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, CurrentData, ThisObject, "SpecialOffersEditFinish_ForRow");
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

#Region SetDetailedInfo

&AtClient
Procedure SetDetailedInfo(DetailedInformation)
	If Items.DetailedInformation.Visible Then
		Items.DetailedInformation.document.getElementById("text").innerHTML = DetailedInformation;
	EndIf;
EndProcedure

#EndRegion

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
	SetDetailedInfo(DetailedInformation);
	
	DPPointOfSaleClient.BeforeStartNewTransaction(Object, ThisObject, DocRef);
	
	NewTransaction();
	Modified = False;
EndProcedure

&AtClient
Procedure NewTransaction()
	NewTransactionAtServer();
	Cancel = False;
	DocRetailSalesReceiptClient.OnOpen(Object, ThisObject, Cancel);
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);
	EndIf;
	
	EnabledPaymentButton();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure NewTransactionAtServer()
	ObjectValue = Documents.RetailSalesReceipt.CreateDocument();
	ObjectValue.Fill(Undefined);
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ValueToFormAttribute(ObjectValue, "Object");
	Cancel = False;
	DocRetailSalesReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, True);
	
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		If ThisObject.ConsolidatedRetailSales.IsEmpty() Then
			ChangeConsolidatedRetailSales(Object, ThisObject, 
				DocConsolidatedRetailSalesServer.GetDocument(Object.Company, Object.Branch, ThisObject.Workstation));
		Else
			Object.ConsolidatedRetailSales = ThisObject.ConsolidatedRetailSales;
		EndIf;
	EndIf;
	
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
	SetShowItems();
EndProcedure

&AtClient
Procedure SetShowItems()
	Items.PageButtons.CurrentPage = Items.GroupItems;
EndProcedure

&AtClient
Procedure EnabledPaymentButton()
	Items.qPayment.Enabled = Object.ItemList.Count();
	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		SetPaymentButtonOnServer();
	EndIf;
EndProcedure

&AtServer
Procedure SetPaymentButtonOnServer()
	ColorGreen = StyleColors.AccentColor;
	ColorRed = StyleColors.NegativeTextColor;
	If ValueIsFilled(Object.ConsolidatedRetailSales) Then
		Items.qPayment.Title = R().InfoMessage_Payment;
		Items.qPayment.TextColor = ColorGreen;
		Items.qPayment.BorderColor = ColorGreen;
	Else
		Items.qPayment.Enabled = False;
		Items.qPayment.Title = R().InfoMessage_SessionIsClosed;
		Items.qPayment.TextColor = ColorRed;
		Items.qPayment.BorderColor = ColorRed;
	EndIf;
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
	
	SetDetailedInfo(DetailedInformation);
EndProcedure

&AtClient
Procedure ClearRetailCustomer(Command)
	Object.RetailCustomer = Undefined;
	DocRetailSalesReceiptClient.RetailCustomerOnChange(Object, ThisObject, Undefined);

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

&AtClientAtServerNoContext
Procedure ChangeConsolidatedRetailSales(Object, Form, NewDocument)
	Form.ConsolidatedRetailSales = NewDocument;
	Object.ConsolidatedRetailSales = NewDocument;
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

&AtClient
Procedure CreateCashIn(Command)
	Items.GroupMainPages.CurrentPage = Items.CashPage;
EndProcedure

&AtClient
Procedure ReturnToMain(Command)
	Items.GroupMainPages.CurrentPage = Items.MainPage;
EndProcedure

&AtClient
Procedure CashInListSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.CashInList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CashInData = New Structure();
	CashInData.Insert("MoneyTransfer" , CurrentData.MoneyTransfer);
	CashInData.Insert("Currency"      , CurrentData.Currency);
	CashInData.Insert("Amount"        , CurrentData.Amount);
	
	FillingData = GetFillingDataMoneyTransferForCashReceipt(CashInData);
	OpenForm(
		"Document.CashReceipt.ObjectForm", 
		New Structure("FillingValues", FillingData), , 
		New UUID(), , ,
		New NotifyDescription("CreateCashInFinish", ThisObject),
		FormWindowOpeningMode.LockWholeInterface);	
EndProcedure

&AtClient
Procedure CreateCashInFinish(Result, AddInfo) Export
	FillCashInList();
EndProcedure

&AtClient
Procedure UpdateMoneyTransfers(Command)
	FillCashInList();
EndProcedure

&AtClient
Procedure CreateCashOut(Command)
	OpenForm("DataProcessor.PointOfSale.Form.CashOut", 
			New Structure("FillingData", GetFillingDataMoneyTransfer(0)), , 
			UUID, , , 
			New NotifyDescription("CreateCashOutFinish", ThisObject), 
			FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure CreateCashOutFinish(Result, AddInfo) Export
	If TypeOf(Result) = Type("String") Then
		CommonFunctionsClientServer.ShowUsersMessage(Result);
	EndIf;
EndProcedure

&AtServer
Function GetFillingDataMoneyTransfer(CashOutAmount)
	POSCashAccount = ThisObject.Workstation.CashAccount;
	
	FillingData = New Structure();
	FillingData.Insert("BasedOn" , "PointOfSale");	
	FillingData.Insert("Date"    , CommonFunctionsServer.GetCurrentSessionDate());	
	FillingData.Insert("Company" , Object.Company);	
	FillingData.Insert("Branch"  , Object.Branch);
	
	FillingData.Insert("Sender"  , POSCashAccount);
	FillingData.Insert("Receiver"  , POSCashAccount.CashAccount);
	
	FillingData.Insert("SendCurrency"    , POSCashAccount.Currency);
	FillingData.Insert("ReceiveCurrency" , POSCashAccount.Currency);
	
	FillingData.Insert("SendFinancialMovementType"     , POSCashAccount.FinancialMovementType);
	FillingData.Insert("ReceiveFinancialMovementType"  , POSCashAccount.FinancialMovementType);
	
	FillingData.Insert("SendUUID"    , String(New UUID()));
	FillingData.Insert("ReceiveUUID" , String(New UUID()));
	
	FillingData.Insert("SendAmount"    , CashOutAmount);
	FillingData.Insert("ReceiveAmount" , CashOutAmount);
	
	Return FillingData;
EndFunction

&AtServer
Function GetFillingDataMoneyTransferForCashReceipt(CashInData)
	FillingData = New Structure();
	FillingData.Insert("BasedOn" , "MoneyTransfer");	
	FillingData.Insert("Date"    , CommonFunctionsServer.GetCurrentSessionDate());	
	FillingData.Insert("TransactionType", Enums.IncomingPaymentTransactionType.CashIn);	
	FillingData.Insert("Company"        , CashInData.MoneyTransfer.Company);	
	FillingData.Insert("Branch"         , CashInData.MoneyTransfer.Branch);	
	FillingData.Insert("CashAccount"    , ThisObject.Workstation.CashAccount);	
	FillingData.Insert("Currency"       , CashInData.Currency);	
	FillingData.Insert("PaymentList"    , New Array());	
	NewRow = New Structure();
	NewRow.Insert("TotalAmount"           , CashInData.Amount);	
	NewRow.Insert("MoneyTransfer"         , CashInData.MoneyTransfer);	
	NewRow.Insert("FinancialMovementType" , CashInData.MoneyTransfer.ReceiveFinancialMovementType);
	FillingData.PaymentList.Add(NewRow);
	
	Return FillingData;	
EndFunction

&AtServer
Procedure FillCashInList()
	ThisObject.CashInList.Clear();
	If Not ValueIsFilled(ThisObject.Workstation) Then
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT ALLOWED
	|	R3021B_CashInTransitIncoming.Basis AS MoneyTransfer,
	|	R3021B_CashInTransitIncoming.Currency AS Currency,
	|	R3021B_CashInTransitIncoming.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.R3021B_CashInTransitIncoming.Balance(,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND ReceiptingAccount = &CashAccount) AS R3021B_CashInTransitIncoming";
	Query.SetParameter("CashAccount", Workstation.CashAccount);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		FillPropertyValues(ThisObject.CashInList.Add(), QuerySelection);
	EndDo;
EndProcedure
