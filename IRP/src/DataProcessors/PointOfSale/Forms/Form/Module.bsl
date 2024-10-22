
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

	AutoCalculateOffers = Workstation.AutoCalculateDiscount;

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
		Status = CommonFunctionsServer.GetRefAttribute(Object.ConsolidatedRetailSales, "Status");
		SessionIsOpen = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.Open");

		Form.Items.GroupSessionComands.Visible = True;
		Form.Items.GroupCashCommands.Visible = True;
		Form.Items.GroupReports.Visible = True;
		Form.Items.GroupCashCommands.Visible =
			CommonFunctionsServer.GetRefAttribute(Form.Workstation, "UseCashInAndCashOut");

		If SessionIsOpen Then
			Form.Items.GroupCashCommands.Enabled = True;
			Form.Items.OpenSession.Enabled = False;
			Form.Items.CloseSession.Enabled = True;
			Form.Items.CancelSession.Enabled = False;
			Form.Items.GroupPostponed.Enabled = True;
		Else
			Form.Items.GroupCashCommands.Enabled = False;
			Form.Items.OpenSession.Enabled = True;
			Form.Items.CloseSession.Enabled = False;
			Form.Items.CancelSession.Enabled = Status = PredefinedValue("Enum.ConsolidatedRetailSalesStatuses.New");
			Form.Items.GroupPostponed.Enabled = False;
		EndIf;
	Else
		Form.Items.GroupSessionComands.Visible = False;
		Form.Items.GroupCashCommands.Visible = False;
		Form.Items.GroupReports.Visible = False;
		Form.Items.GroupCashCommands.Visible = False;
	EndIf;

	PostponeWithReserve = CommonFunctionsServer.GetRefAttribute(Form.Workstation, "PostponeWithReserve");
	PostponeWithoutReserve = CommonFunctionsServer.GetRefAttribute(Form.Workstation, "PostponeWithoutReserve");
	Form.Items.PostponeCurrentReceipt.Visible = PostponeWithoutReserve OR (PostponeWithReserve AND Form.isReturn);
	Form.Items.PostponeCurrentReceiptWithReserve.Visible = PostponeWithReserve AND NOT Form.isReturn;
	Form.Items.OpenPostponedReceipt.Visible = PostponeWithReserve OR PostponeWithoutReserve;

	Form.Items.ReturnPage.Visible =	Form.isReturn;

	Form.Title = R().InfoMessage_POS_Title + ?(Form.isReturn, ": " + R().InfoMessage_ReturnTitle, "");

	If Form.Items.ChangeRollbackRight.Check Then
		Form.Items.ChangeRollbackRight.Title = R().I_8;
	Else
		Form.Items.ChangeRollbackRight.Title = R().I_7;
	EndIf;

	Form.Items.GroupHeaderTopUserAdmin.Visible = ValueIsFilled(Form.UserAdmin);

	// Additional settings
	Form.Items.Return.Enabled = UserSettingsServer.PointOfSale_AdditionalSettings_DisableCreateReturn(Form.UserAdmin);

	ChangePrice = UserSettingsServer.PointOfSale_AdditionalSettings_DisableChangePrice(Form.UserAdmin);
	ChangePriceType = UserSettingsServer.PointOfSale_AdditionalSettings_EnableChangePriceType(Form.UserAdmin);
	Form.Items.ItemListPrice.ReadOnly = Not ChangePrice;
	Form.Items.ItemListTotalAmount.ReadOnly = Not ChangePrice;
	Form.Items.ItemListPriceType.Visible = ChangePriceType;
EndProcedure

&AtClient
Procedure PageButtonsOnCurrentPageChange(Item, CurrentPage)
	If CurrentPage = Items.OffersPage Then
		UpdateOffersPreviewID();
	EndIf;
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
	If Object.ConsolidatedRetailSales.IsEmpty() Then
		DocConsolidatedRetailSales = DocConsolidatedRetailSalesServer.CreateDocument(Object.Company, Object.Branch, ThisObject.Workstation);
	Else
		DocConsolidatedRetailSales = Object.ConsolidatedRetailSales;
	EndIf;

	EquipmentOpenShiftResult = Await EquipmentFiscalPrinterClient.OpenShift(DocConsolidatedRetailSales); // See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
	If EquipmentOpenShiftResult.Info.Success Then
		DocConsolidatedRetailSalesServer.DocumentOpenShift(DocConsolidatedRetailSales, EquipmentOpenShiftResult.Out.OutputParameters);
		ChangeConsolidatedRetailSales(Object, ThisObject, DocConsolidatedRetailSales);
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);

		SetVisibilityAvailability(Object, ThisObject);
		EnabledPaymentButton();
	Else
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentOpenShiftResult.Info.Error);

		ChangeConsolidatedRetailSales(Object, ThisObject, DocConsolidatedRetailSales);
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);
	EndIf;
EndProcedure

&AtClient
Procedure CloseSession(Command)
	CountPostponedReceipts = GetCountPostponedReceipts(Object.ConsolidatedRetailSales);
	If CountPostponedReceipts > 0 Then
		OpenPostponedReceipt(Command);
		Return;
	EndIf;
	
	FormParameters = New Structure();
	FormParameters.Insert("Workstation", Object.Workstation);
	FormParameters.Insert("AutoCreateMoneyTransfer"
		, CommonFunctionsServer.GetRefAttribute(Object.Workstation, "AutoCreateMoneyTransferAtSessionClosing"));
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

	If Result.AutoCreateMoneyTransfer Then
		CreateCashOut(Commands.CreateCashOut, True);
	EndIf;

	AcquiringList = HardwareServer.GetWorkstationHardwareByEquipmentType(Object.Workstation, PredefinedValue("Enum.EquipmentTypes.Acquiring"));
	For Each Acquiring In AcquiringList Do
		SettlementSettings = EquipmentAcquiringAPIClient.SettlementSettings();
		If Not Await EquipmentAcquiringAPIClient.Settlement(Acquiring, SettlementSettings) Then
			CommonFunctionsClientServer.ShowUsersMessage(SettlementSettings.Info.Error);
			Continue;
		EndIf;

		DocumentPackage = EquipmentFiscalPrinterAPIClient.DocumentPackage();
		DocumentPackage.TextString = StrSplit(SettlementSettings.Out.Slip, Chars.LF + Chars.CR);
		PrintResult = Await EquipmentFiscalPrinterClient.PrintTextDocument(Object.ConsolidatedRetailSales, DocumentPackage); // See EquipmentFiscalPrinterAPIClient.PrintTextDocumentSettings
		If Not PrintResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(PrintResult.Info.Error);
		EndIf;
	EndDo;

	EquipmentCloseShiftResult = Await EquipmentFiscalPrinterClient.CloseShift(Object.ConsolidatedRetailSales); // See EquipmentFiscalPrinterAPIClient.OpenShiftSettings
	If EquipmentCloseShiftResult.Info.Success Then
		DocConsolidatedRetailSalesServer.DocumentCloseShift(Object.ConsolidatedRetailSales, EquipmentCloseShiftResult.Out.OutputParameters, Result);
		ChangeConsolidatedRetailSales(Object, ThisObject, Undefined);

		SetVisibilityAvailability(Object, ThisObject);
		EnabledPaymentButton();
	Else
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentCloseShiftResult.Info.Error);
	EndIf;
EndProcedure

&AtClient
Procedure CancelSession(Command)
	NumberOfCanceled = CancelingPostponedReceipts(Object.ConsolidatedRetailSales);
	If NumberOfCanceled > 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().POS_CancelPostponed, NumberOfCanceled));
	EndIf;
	
	DocConsolidatedRetailSalesServer.CancelDocument(Object.ConsolidatedRetailSales);
	ChangeConsolidatedRetailSales(Object, ThisObject, Undefined);
	SetVisibilityAvailability(Object, ThisObject);
	EnabledPaymentButton();
EndProcedure

&AtClient
Async Procedure PrintXReport(Command)

	If Object.ConsolidatedRetailSales.IsEmpty() Then
		Settings = New Structure;
		FP = HardwareServer.GetWorkstationHardwareByEquipmentType(Workstation, PredefinedValue("Enum.EquipmentTypes.FiscalPrinter"));
		If FP.Count() = 0 Then
			Return;
		Else
			Settings.Insert("FiscalPrinter", FP[0]);
			Settings.Insert("Author", SessionParametersServer.GetSessionParameter("CurrentUser"));
			EquipmentResult = Await EquipmentFiscalPrinterClient.PrintXReport(Settings);
		EndIf;
	Else
		EquipmentResult = Await EquipmentFiscalPrinterClient.PrintXReport(Object.ConsolidatedRetailSales);
	EndIf;
	If Not EquipmentResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentResult.Info.Error);
	EndIf;
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocRetailSalesReceiptClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	CheckByRetailBasis();
	SetDetailedInfo("");
EndProcedure

&AtClient
Procedure ItemListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	If ThisObject.isReturn And Not ThisObject.RetailBasis.IsEmpty() Then
		Cancel = True;
		Return;
	EndIf;

	DocRetailSalesReceiptClient.ItemListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	EnabledPaymentButton();
	FillSalesPersonInItemList();
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));
	If Object.ItemList.Count() = 0 Then
		Modified = False;
	EndIf;
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, WarningText, StandardProcessing)
	If Object.ItemList.Count() Then
		Cancel = True;
		If Not Exit Then
			CommonFunctionsClientServer.ShowUsersMessage(R().POS_s6, "Object.ItemList[0].Item", "Object.ItemList");
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	If Item.CurrentItem.Name = "ItemListControlCodeStringState" Then
		ItemListControlCodeStringStateClick();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	UpdateHTMLPictures();
	CurrentData = Items.ItemList.CurrentData;
	If Not CurrentData = Undefined Then
		BuildDetailedInformation(CurrentData.ItemKey);
	EndIf;

	UpdateOffersPreviewID();
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
	CheckByRetailBasis();
	UpdateHTMLPictures();
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item)
	DocRetailSalesReceiptClient.ItemListUnitOnChange(Object, ThisObject, Item);
	CheckByRetailBasis();
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item)
	If ThisObject.isReturn Then
		RecalculateOffer(Items.ItemList.CurrentData);
		CheckByRetailBasis();
	EndIf;
	DocRetailSalesReceiptClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item)
	DocRetailSalesReceiptClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
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

&AtClient
Procedure ItemListRetailSalesReceiptStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;

	RowID = Undefined;
	If Not Items.ItemList.CurrentRow = Undefined Then
		RowID = Items.ItemList.CurrentRow;
	EndIf;

	FindRetailBasis(RowID);
EndProcedure

&AtClient
Procedure RetailSalesReceiptStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	FindRetailBasis(Undefined);
EndProcedure

&AtClient
Procedure RetailSalesReceiptOnChange(Item)
	If ThisObject.RetailBasis.IsEmpty() Then
		For Each ListItem In ThisObject.Object.ItemList Do
			ListItem.RetailBasis = ThisObject.RetailBasis;
		EndDo;
		ThisObject.BasisPayments.Clear();
	EndIf;
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

	Result = New Structure("FoundedItems, Barcodes", GetItemInfo.GetInfoByItemsKey(ItemKey, Object.Agreement), New Array);
	SearchByBarcodeEnd(Result, New Structure());

EndProcedure

#EndRegion

#EndRegion

#Region FormCommandsEventHandlers

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
		
		For Each Row In Result.FoundedItems Do
			If Row.isCertificate And Not Row.SerialLotNumber.IsEmpty() Then
				CertStatus = CertificateServer.GetCertificateStatus(Row.SerialLotNumber);
				If isReturn Then
					If Not CertStatus.CanBeUsed Then
						CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().CERT_CertAlreadyUsed, Row.SerialLotNumber));
						Return;
					EndIf; 
				Else
					If Not CertStatus.CanBeSold Then
						CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().CERT_CannotBeSold, Row.SerialLotNumber));
						Return;
					EndIf; 
				EndIf;
			EndIf;
		EndDo;
		
		FillSalesPersonInItemList();

		NotifyParameters = New Structure();
		NotifyParameters.Insert("Form"   , ThisObject);
		NotifyParameters.Insert("Object" , Object);
		NotifyParameters.Insert("Filter" , New Structure("DisableIfIsService", False));
		SetDetailedInfo("");
		DocumentsClient.PickupItemsEnd(Result.FoundedItems, NotifyParameters);
		EnabledPaymentButton();

		If Not SalesPersonByDefault.IsEmpty() Then
			FillSalesPersonInItemList();
		EndIf;

		If AutoCalculateOffers And Not ThisObject.isReturn Then
			RecalculateOffersAtServer();
			OffersClient.SpecialOffersEditFinish_ForDocument(Object, ThisObject);
		EndIf;

	EndIf;

	If Result.Barcodes.Count() Then
		DetailedInformation = "<span style=""color:red;"">" + StrTemplate(R().S_019, StrConcat(
			Result.Barcodes, ",")) + "</span>";
		SetDetailedInfo(DetailedInformation);
	EndIf;
EndProcedure

&AtClient
Procedure ChangeRollbackRight(Command)
	If Not Items.ChangeRollbackRight.Check Then
		OpenForm("DataProcessor.PointOfSale.Form.ChangeRight", , ThisObject, , , ,
			New NotifyDescription("ChangeRightEnd", ThisObject ) , FormWindowOpeningMode.LockOwnerWindow);
	Else
		Items.ChangeRollbackRight.Check = False;
		ThisObject.KeepRights = False;
		ThisObject.UserAdmin = Undefined;
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtClient
Procedure ChangeRightEnd(Result, AdditionalParameters) Export
	If Result = Undefined OR Result.UserAdmin.isEmpty() Then
		Items.ChangeRollbackRight.Check = False;
	Else
		Items.ChangeRollbackRight.Check = True;
		ThisObject.KeepRights = Result.KeepRights;
		ThisObject.UserAdmin = Result.UserAdmin;
	EndIf;
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure qPayment(Command)
	Cancel = False;
	OffersRecalculated = False;
	FillqPaymentAtServer(Cancel, OffersRecalculated);

	If Not ThisObject.isReturn Then
		OffersClient.SpecialOffersEditFinish_ForDocument(Object, ThisObject);
	EndIf;

	DPPointOfSaleClient.BeforePayment(ThisObject, Cancel);

	If Cancel Then
		Return;
	EndIf;

	OpenFormNotifyDescription = New NotifyDescription("PaymentFormClose", ThisObject);
	ObjectParameters = New Structure();
	ObjectParameters.Insert("Amount", Object.ItemList.Total("TotalAmount"));
	ObjectParameters.Insert("Branch", Object.Branch);
	ObjectParameters.Insert("Workstation", Workstation);
	ObjectParameters.Insert("IsAdvance", False);
	ObjectParameters.Insert("RetailCustomer", Object.RetailCustomer);
	ObjectParameters.Insert("Company", Object.Company);
	ObjectParameters.Insert("isReturn", ThisObject.isReturn);
	ObjectParameters.Insert("RetailBasis", ThisObject.RetailBasis);
	ObjectParameters.Insert("Discount", Object.ItemList.Total("OffersAmount"));
	ObjectParameters.Insert("ConsolidatedRetailSales", ConsolidatedRetailSales);
	OpenForm("DataProcessor.PointOfSale.Form.Payment", ObjectParameters, ThisObject, UUID, , ,
		OpenFormNotifyDescription, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtServer
Procedure FillqPaymentAtServer(Cancel, OffersRecalculated)
	Object.Date = CommonFunctionsServer.GetCurrentSessionDate();

	If Not CheckFilling() Then
		Cancel = True;
		Return;
	EndIf;

	DPPointOfSaleServer.BeforePayment(ThisObject, Cancel);

	If ThisObject.isReturn Then
		If Not ThisObject.RetailBasis.IsEmpty() Then
			EmptyRows = Object.ItemList.FindRows(
				New Structure("RetailBasis", PredefinedValue("Document.RetailSalesReceipt.EmptyRef")));
			If EmptyRows.Count() > 0 Then
				Cancel = True;
				For Each EmptyRow In EmptyRows Do
					Message = StrTemplate(R().Error_077, EmptyRow.LineNumber);
					Path = StrTemplate(
						"Object.ItemList[%1].RetailBasis",
						Format(EmptyRow.LineNumber - 1, "NZ=; NG=;"));
					CommonFunctionsClientServer.ShowUsersMessage(Message, Path);
				EndDo;
			EndIf;
		EndIf;
	EndIf;

	For Index = 0 To Object.ItemList.Count() - 1 Do
		Row = Object.ItemList[Index];
		If Row.isControlCodeString And Not Row.ControlCodeStringState = 3 Then
			Cancel = True;
			Message = R().POS_Error_CheckFillingForAllCodes;
			Path = StrTemplate(
				"Object.ItemList[%1].ControlCodeStringState",
				Format(Row.LineNumber - 1, "NZ=; NG=;"));
			CommonFunctionsClientServer.ShowUsersMessage(Message, Path);
		EndIf;
	EndDo;

	RecalculateOffersAtServer();
EndProcedure

&AtServer
Procedure RecalculateOffersAtServer()
	If Not ThisObject.isReturn Then
		OffersInfo = OffersServer.RecalculateOffers(Object, ThisObject);
		OffersServer.CalculateOffersAfterSet(OffersInfo, Object);
	EndIf;
EndProcedure

&AtClient
Procedure Advance(Command)
	If Not ValueIsFilled(Object.RetailCustomer) Then
		// "Error. Retail customer is not filled
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_123);
		Return;
	EndIf;

	OpenFormNotifyDescription = New NotifyDescription("AdvanceFormClose", ThisObject);
	ObjectParameters = New Structure();
	ObjectParameters.Insert("Amount", Object.ItemList.Total("TotalAmount"));
	ObjectParameters.Insert("Branch", Object.Branch);
	ObjectParameters.Insert("Workstation", Workstation);
	ObjectParameters.Insert("IsAdvance", True);
	ObjectParameters.Insert("isReturn", ThisObject.isReturn);
	ObjectParameters.Insert("RetailCustomer", Object.RetailCustomer);
	ObjectParameters.Insert("Company", Object.Company);
	ObjectParameters.Insert("ConsolidatedRetailSales", ConsolidatedRetailSales);
	OpenForm("DataProcessor.PointOfSale.Form.Payment", ObjectParameters, ThisObject, UUID, , ,
		OpenFormNotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure DocReturn(Command)
	isReturn = Not isReturn;
	ThisObject.RetailBasis = Undefined;
	For Each ListItem In ThisObject.Object.ItemList Do
		 ListItem.RetailBasis = Undefined;
	EndDo;
	ThisObject.BasisPayments.Clear();
	Object.ControlCodeStrings.Clear();
	ControlCodeStringsClient.UpdateState(Object);
	SetVisibilityAvailability(Object, ThisObject);
	EnabledPaymentButton();

	If isReturn Then
		Items.PageButtons.CurrentPage = Items.ReturnPage;
	EndIf;
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
	DPPointOfSaleClient.SearchCustomer(Object, ThisObject);
EndProcedure

&AtClient
Procedure SetRetailCustomer(Value, AddInfo = Undefined) Export
	If ValueIsFilled(Value) Then
		Object.RetailCustomer = Value;
		DocRetailSalesReceiptClient.RetailCustomerOnChange(Object, ThisObject,
			ThisObject.Items.RetailCustomer);

	EndIf;
	SetSelectBasisDocumentColor();
EndProcedure

&AtClient
Procedure SetSelectBasisDocumentColor()
	If Object.RetailCustomer.IsEmpty() Then
		Items.SelectBasisDocument.ShapeRepresentation = ButtonShapeRepresentation.WhenActive;
		Items.SelectBasisDocument.BackColor = Items.SearchByBarcode.BackColor;
	Else
		IsRetailCustomerHasOrders = IsRetailCustomerHasOrders();
		If IsRetailCustomerHasOrders Then
			Items.SelectBasisDocument.BackColor = WebColors.GreenYellow;
			Items.SelectBasisDocument.ShapeRepresentation = ButtonShapeRepresentation.Always;
		Else
			Items.SelectBasisDocument.ShapeRepresentation = ButtonShapeRepresentation.WhenActive;
			Items.SelectBasisDocument.BackColor = Items.SearchByBarcode.BackColor;
		EndIf;
	EndIf;
EndProcedure

&AtServer
Function IsRetailCustomerHasOrders()

	Query = New Query;
	Query.Text =
		"SELECT ALLOWED DISTINCT
		|	R2012B_SalesOrdersInvoiceClosingBalance.Order,
		|	R2012B_SalesOrdersInvoiceClosingBalance.ItemKey
		|FROM
		|	AccumulationRegister.R2012B_SalesOrdersInvoiceClosing.Balance(, Order.RetailCustomer = &RetailCustomer) AS
		|		R2012B_SalesOrdersInvoiceClosingBalance
		|WHERE
		|	R2012B_SalesOrdersInvoiceClosingBalance.QuantityBalance > 0
		|
		|UNION ALL
		|
		|SELECT
		|	R4032B_GoodsInTransitOutgoing.Basis,
		|	R4032B_GoodsInTransitOutgoing.ItemKey
		|FROM
		|	AccumulationRegister.R4032B_GoodsInTransitOutgoing.BalanceAndTurnovers(,,,,
		|		Basis.RetailCustomer = &RetailCustomer) AS R4032B_GoodsInTransitOutgoing
		|WHERE
		|	R4032B_GoodsInTransitOutgoing.QuantityClosingBalance < 0";

	Query.SetParameter("RetailCustomer", Object.RetailCustomer);
	SetPrivilegedMode(True);
	Return Not Query.Execute().IsEmpty();

EndFunction

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

&AtClient
Procedure ItemListControlCodeStringStateClick() Export

	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If Not CurrentData.isControlCodeString Then
		Return;
	EndIf;

	Params = New Structure;
	Params.Insert("Hardware", CommonFunctionsServer.GetRefAttribute(ConsolidatedRetailSales, "FiscalPrinter"));
	Params.Insert("RowKey", CurrentData.Key);
	Params.Insert("Item", CurrentData.Item);
	Params.Insert("ItemKey", CurrentData.ItemKey);
	//@skip-check unknown-method-property
	Params.Insert("LineNumber", CurrentData.LineNumber);
	Params.Insert("isReturn", isReturn);
	Notify = New NotifyDescription("ItemListControlCodeStringStateOpeningEnd", ThisObject, Params);

	OpenForm("CommonForm.CodeStringCheck", Params, ThisObject, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ItemListControlCodeStringStateOpeningEnd(Result, AddInfo) Export

	If Result = Undefined Then
		Return;
	EndIf;

	Array = New Array;
	Str = New Structure;
	Str.Insert("Key", AddInfo.RowKey);
	Array.Add(Str);
	ControlCodeStringsClient.ClearAllByRow(Object, Array);
	If Result.WithoutScan Then
		CurrentRow = Object.ItemList.FindByID(Items.ItemList.CurrentRow);
		CurrentRow.isControlCodeString = False;
	Else
		For Each Row In Result.Scaned Do
			FillPropertyValues(Object.ControlCodeStrings.Add(), Row);
		EndDo;
	EndIf;

	ControlCodeStringsClient.UpdateState(Object);
	Modified = True;
EndProcedure

#Region SpecialOffers

#Region Offers_for_document

&AtClient
Procedure SetSpecialOffers(Command)
	If ThisObject.isReturn Then
		Return;
	EndIf;
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object, ThisObject, "SpecialOffersEditFinish_ForDocument");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForDocument(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	CalculateOffersAfterSet(Result);
	OffersClient.SpecialOffersEditFinish_ForDocument(Object, ThisObject, AdditionalParameters);

	CurrentData = Items.ItemList.CurrentData;
	If Not CurrentData = Undefined Then
		BuildDetailedInformation(CurrentData.ItemKey);
	EndIf;
EndProcedure

&AtServer
Procedure CalculateOffersAfterSet(Result)
	OffersServer.CalculateOffersAfterSet(Result, Object);
EndProcedure

#EndRegion

#Region Offers_for_row

&AtClient
Procedure SetSpecialOffersAtRow(Command)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If ThisObject.isReturn Then
		Return;
	EndIf;
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object, CurrentData, ThisObject, "SpecialOffersEditFinish_ForRow");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForRow(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	CalculateAndLoadOffers_ForRow(Result);
	OffersClient.SpecialOffersEditFinish_ForRow(Result, Object, ThisObject, AdditionalParameters);

	CurrentData = Items.ItemList.CurrentData;
	If Not CurrentData = Undefined Then
		BuildDetailedInformation(CurrentData.ItemKey);
	EndIf;
EndProcedure

&AtServer
Procedure CalculateAndLoadOffers_ForRow(Result)
	OffersServer.CalculateAndLoadOffers_ForRow(Object, Result.OffersAddress, Result.ItemListRowKey);
EndProcedure

#EndRegion

&AtClient
Procedure UpdateOffersPreview(Command)
	UpdateOffersPreviewID();
EndProcedure

&AtClient
Procedure UpdateOffersPreviewID()
	CurrentData = Items.ItemList.CurrentData;
	If Not CurrentData = Undefined Then
		CurrentItemListID = CurrentData.Key;
	EndIf;
EndProcedure

#EndRegion

#EndRegion

#EndRegion

#Region Terminal

&AtClient
Procedure TerminalSettlement(Command)
	OpenFormProperty = New Structure();
	OpenFormProperty.Insert("Workstation", Workstation);
	OpenForm("DataProcessor.PointOfSale.Form.GetSettlement", OpenFormProperty, ThisObject, , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure TerminalShowTransactions(Command)
	AcquiringList = HardwareServer.GetWorkstationHardwareByEquipmentType(Workstation, PredefinedValue("Enum.EquipmentTypes.Acquiring"));
	FormParameters = New Structure("Hardware, OpenAsLog", AcquiringList, False);
	OpenForm("InformationRegister.HardwareLog.Form.LogAnalyze", FormParameters);
EndProcedure

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
		ItemPicture = Undefined;
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
Async Procedure PaymentFormClose(Result, AdditionalData) Export

	If Result = Undefined Then
		Return;
	EndIf;

	PaymentForm = Result.PaymentForm; // See DataProcessor.PointOfSale.Form.Payment
	Result.PaymentForm = Undefined;

	TransactionResult = WriteTransaction(Result);
	If TransactionResult.Refs.Count() = 0 Then
		PaymentForm.Items.Enter.Enabled = True;
		Return;
	EndIf;
	
	ResultPrint = True;
	For Each DocRef In TransactionResult.Refs Do
		ResultPrint = ResultPrint AND Await PrintFiscalReceipt(DocRef);
	EndDo;

	If Not ResultPrint Then
		ReceiptsCanceling(TransactionResult.Refs);
		PaymentForm.Items.Enter.Enabled = True;
		Return;
	EndIf;
	
	PaymentForm.Close();

	DetailedInformation = R().S_030 + ": " + Format(TransactionResult.CashbackAmount, "NFD=2; NZ=0;");
	SetDetailedInfo(DetailedInformation);

	DPPointOfSaleClient.AfterWriteTransaction(TransactionResult.Refs, ThisObject);
	DPPointOfSaleClient.BeforeStartNewTransaction(Object, ThisObject, DocRef);

	NewTransaction();
	SetSelectBasisDocumentColor();
	Modified = False;
EndProcedure

&AtClient
Async Procedure AdvanceFormClose(Result, AdditionalData) Export
	If Result = Undefined Then
		Return;
	EndIf;

	PaymentForm = Result.PaymentForm; // See DataProcessor.PointOfSale.Form.Payment
	Result.PaymentForm = Undefined;

	If ThisObject.isReturn Then
		DocumentParameters = GetAdvanceDocumentParameters(Result.Payments, "Outgoing");
	Else
		DocumentParameters = GetAdvanceDocumentParameters(Result.Payments, "Incoming");
	EndIf;

	CreatedDocuments = CreateAdvanceDocumentsAtServer(DocumentParameters);
	For Each CreatedDocument In CreatedDocuments Do
		Await PrintFiscalReceipt(CreatedDocument);
	EndDo;

	PaymentForm.Close();

	NewTransaction();
	Modified = False;
EndProcedure

&AtClient
Function GetAdvanceDocumentParameters(_Payments, AdvanceDirection)
	ArrayOfPayments = New Array();
	For Each Row In _Payments Do
		If Row.Amount < 0 Then
			Continue;
		EndIf;
		NewPayment = New Structure();
		NewPayment.Insert("PaymentType");
		NewPayment.Insert("PaymentTypeEnum");
		NewPayment.Insert("Amount");
		NewPayment.Insert("Account");
		NewPayment.Insert("BankTerm");
		NewPayment.Insert("Percent");
		NewPayment.Insert("Commission");
		FillPropertyValues(NewPayment, Row);
		ArrayOfPayments.Add(NewPayment);
	EndDo;

	DocumentParameters = New Structure();
	DocumentParameters.Insert("ArrayOfPayments", ArrayOfPayments);

	If AdvanceDirection = "Incoming" Then // receipt advance
		DocumentParameters.Insert("CashDocumentName", "CashReceipt");
		DocumentParameters.Insert("CashDocumentTransactionType",
			PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance"));

		DocumentParameters.Insert("BankDocumentName", "BankReceipt");
		DocumentParameters.Insert("BankDocumentTransactionType",
			PredefinedValue("Enum.IncomingPaymentTransactionType.RetailCustomerAdvance"));
	ElsIf AdvanceDirection = "Outgoing" Then // return advance
		DocumentParameters.Insert("CashDocumentName", "CashPayment");
		DocumentParameters.Insert("CashDocumentTransactionType",
			PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance"));

		DocumentParameters.Insert("BankDocumentName", "BankPayment");
		DocumentParameters.Insert("BankDocumentTransactionType",
			PredefinedValue("Enum.OutgoingPaymentTransactionTypes.RetailCustomerAdvance"));
	Else
		Raise "Wrong advance direction";
	EndIf;

	Return DocumentParameters;
EndFunction

&AtServer
Function CreateAdvanceDocumentsAtServer(DocumentParameters)
	ReturnData = New Array;

	// cash receipt / cash payment
	CashtTable = New ValueTable();
	CashtTable.Columns.Add("Account");
	CashtTable.Columns.Add("Amount");

	For Each Row In DocumentParameters.ArrayOfPayments Do
		If Row.PaymentTypeEnum = Enums.PaymentTypes.Cash Then
			NewRow = CashtTable.Add();
			NewRow.Account = Row.Account;
			NewRow.Amount  = Row.Amount;
		EndIf;
	EndDo;

	CashTableGrouped = CashtTable.Copy();
	CashTableGrouped.GroupBy("Account");
	For Each RowHeader In CashTableGrouped Do
		CashDocument = BuilderAPI.Initialize(DocumentParameters.CashDocumentName);
		BuilderAPI.SetProperty(CashDocument, "Company"     , Object.Company, "PaymentList");
		BuilderAPI.SetProperty(CashDocument, "Branch"      , Object.Branch, "PaymentList");
		BuilderAPI.SetProperty(CashDocument, "Date"        , CommonFunctionsServer.GetCurrentSessionDate(), "PaymentList");
		BuilderAPI.SetProperty(CashDocument, "TransactionType" , DocumentParameters.CashDocumentTransactionType, "PaymentList");
		BuilderAPI.SetProperty(CashDocument, "CashAccount" , RowHeader.Account, "PaymentList");
		BuilderAPI.SetProperty(CashDocument, "ConsolidatedRetailSales" , Object.ConsolidatedRetailSales, "PaymentList");

		For Each RowList In CashtTable.FindRows(New Structure("Account", RowHeader.Account)) Do
			NewRow = BuilderAPI.AddRow(CashDocument, "PaymentList");
			BuilderAPI.SetRowProperty(CashDocument, NewRow, "RetailCustomer", Object.RetailCustomer, "PaymentList");
			BuilderAPI.SetRowProperty(CashDocument, NewRow, "TotalAmount"   , RowList.Amount, "PaymentList");
			BuilderAPI.SetRowProperty(CashDocument, NewRow, "NetAmount"     , RowList.Amount, "PaymentList");
		EndDo;
		BuilderAPIWriteResult = BuilderAPI.Write(CashDocument, DocumentWriteMode.Posting);
		ReturnData.Add(BuilderAPIWriteResult.Ref);
	EndDo;

	// bank receipt / bank payment
	BankTable = New ValueTable();
	BankTable.Columns.Add("Account");
	BankTable.Columns.Add("PaymentType");
	BankTable.Columns.Add("PaymentTerminal");
	BankTable.Columns.Add("BankTerm");
	BankTable.Columns.Add("Amount");

	For Each Row In DocumentParameters.ArrayOfPayments Do
		If Row.PaymentTypeEnum = Enums.PaymentTypes.Card Then
			NewRow = BankTable.Add();
			NewRow.Account         = Row.Account;
			NewRow.PaymentType     = Row.PaymentType;
			NewRow.BankTerm        = Row.BankTerm;
			NewRow.Amount          = Row.Amount;
		EndIf;
	EndDo;

	BankTableGrouped = BankTable.Copy();
	BankTableGrouped.GroupBy("Account");
	For Each RowHeader In BankTableGrouped Do
		BankDocument = BuilderAPI.Initialize(DocumentParameters.BankDocumentName);
		BuilderAPI.SetProperty(BankDocument, "Company"     , Object.Company, "PaymentList");
		BuilderAPI.SetProperty(BankDocument, "Branch"      , Object.Branch, "PaymentList");
		BuilderAPI.SetProperty(BankDocument, "Date"        , CommonFunctionsServer.GetCurrentSessionDate(), "PaymentList");
		BuilderAPI.SetProperty(BankDocument, "TransactionType" , DocumentParameters.BankDocumentTransactionType, "PaymentList");
		BuilderAPI.SetProperty(BankDocument, "Account" , RowHeader.Account, "PaymentList");
		BuilderAPI.SetProperty(BankDocument, "ConsolidatedRetailSales" , Object.ConsolidatedRetailSales, "PaymentList");

		For Each RowList In BankTable.FindRows(New Structure("Account", RowHeader.Account)) Do
			NewRow = BuilderAPI.AddRow(BankDocument, "PaymentList");
			BuilderAPI.SetRowProperty(BankDocument, NewRow, "RetailCustomer"   , Object.RetailCustomer, "PaymentList");
			BuilderAPI.SetRowProperty(BankDocument, NewRow, "PaymentType"      , RowList.PaymentType, "PaymentList");
			BuilderAPI.SetRowProperty(BankDocument, NewRow, "BankTerm"         , RowList.BankTerm, "PaymentList");
			BuilderAPI.SetRowProperty(BankDocument, NewRow, "TotalAmount"      , RowList.Amount, "PaymentList");
			BuilderAPI.SetRowProperty(BankDocument, NewRow, "NetAmount"        , RowList.Amount, "PaymentList");
		EndDo;
		BuilderAPIWriteResult = BuilderAPI.Write(BankDocument, DocumentWriteMode.Posting);
		ReturnData.Add(BuilderAPIWriteResult.Ref);
	EndDo;

	Return ReturnData;
EndFunction

&AtClient
Procedure NewTransaction()
	NewTransactionAtServer();
	Cancel = False;
	DocRetailSalesReceiptClient.OnOpen(Object, ThisObject, Cancel);

	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		DocRetailSalesReceiptClient.ConsolidatedRetailSalesOnChange(Object, ThisObject, Undefined);
	EndIf;

	If Not ThisObject.KeepRights Then
		Items.ChangeRollbackRight.Check = False;
		ThisObject.UserAdmin = Undefined;
	EndIf;

	EnabledPaymentButton();
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Async Function PrintFiscalReceipt(DocumentRef)
	If Object.ConsolidatedRetailSales.IsEmpty() Then
		Return True;
	EndIf;

	EquipmentPrintFiscalReceiptResult = Await EquipmentFiscalPrinterClient.ProcessCheck(Object.ConsolidatedRetailSales, DocumentRef); // See EquipmentFiscalPrinterAPIClient.ProcessCheckSettings
	If Not EquipmentPrintFiscalReceiptResult.Info.Success Then
		CommonFunctionsClientServer.ShowUsersMessage(EquipmentPrintFiscalReceiptResult.Info.Error);
	EndIf;
	Return EquipmentPrintFiscalReceiptResult.Info.Success;
EndFunction

&AtServer
Procedure NewTransactionAtServer()
	ObjectValue = Documents.RetailSalesReceipt.CreateDocument();
	ObjectValue.Fill(Undefined);
	ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
	ObjectValue.StatusType = Enums.RetailReceiptStatusTypes.Completed;
	ValueToFormAttribute(ObjectValue, "Object");
	Cancel = False;
	DocRetailSalesReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, True);

	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		If ThisObject.ConsolidatedRetailSales.IsEmpty() Then
			CRS = DocConsolidatedRetailSalesServer.GetDocument(Object.Company, Object.Branch, ThisObject.Workstation);
			ChangeConsolidatedRetailSales(Object, ThisObject, CRS);
		Else
			Object.ConsolidatedRetailSales = ThisObject.ConsolidatedRetailSales;
		EndIf;
	EndIf;

	SalesPersonByDefault = Undefined;
	ThisObject.RetailBasis = Undefined;
	ThisObject.isReturn = False;
	ThisObject.PostponedReceipt = Undefined;
EndProcedure

// Write transaction.
// 
// Parameters:
//  PaymentResult - Structure - Payment result
// 
// Returns:
//  Structure -  Write transaction:
// * Refs - Array of DocumentRef - refs of documents 
// * CashbackAmount - Number - 
&AtServer
Function WriteTransaction(PaymentResult)
	Result = New Structure;
	Result.Insert("Refs", New Array);
	Result.Insert("CashbackAmount", 0);
	
	OneHundred = 100;
	If PaymentResult = Undefined Or Not PaymentResult.Payments.Count() Then
		Return Result;
	EndIf;
	Payments = PaymentResult.Payments.Unload();
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

	DocRef = Undefined;
	CashbackAmount = 0;

	If ThisObject.isReturn Then

		PaymentsTable = PaymentResult.Payments.Unload(); // ValueTable
		For Each PaymentsItem In PaymentsTable Do
			If PaymentsItem.Amount < 0 Then
				CashbackAmount = CashbackAmount + PaymentsItem.Amount * (-1);
			EndIf;
		EndDo;

		If ThisObject.RetailBasis.IsEmpty() Then
			DocRef = CreateReturnWithoutBase(PaymentsTable, Enums.RetailReceiptStatusTypes.Completed);
			Result.Refs.Add(DocRef);
		Else
			DocRefs = CreateReturnOnBase(PaymentsTable, Enums.RetailReceiptStatusTypes.Completed);
			For Each DocRef In DocRefs Do
				Result.Refs.Add(DocRef);
			EndDo;
		EndIf;

	Else

		If TypeOf(ThisObject.PostponedReceipt) = Type("DocumentRef.RetailSalesReceipt") Then
			ObjectValue = GetClearPostponedObject(); // DocumentObject.RetailSalesReceipt
			ObjectValue.ItemList.Load(Object.ItemList.Unload());
			ObjectValue.SpecialOffers.Load(Object.SpecialOffers.Unload());
			ObjectValue.Currencies.Load(Object.Currencies.Unload());
			ObjectValue.SerialLotNumbers.Load(Object.SerialLotNumbers.Unload());
			ObjectValue.RowIDInfo.Load(Object.RowIDInfo.Unload());
			ObjectValue.SourceOfOrigins.Load(Object.SourceOfOrigins.Unload());
			ObjectValue.ControlCodeStrings.Load(Object.ControlCodeStrings.Unload());
		Else
			ObjectValue = FormAttributeToValue("Object");
		EndIf;
		ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
		ObjectValue.StatusType = Enums.RetailReceiptStatusTypes.Completed;
		ObjectValue.Payments.Load(Payments);
		For Each Row In ObjectValue.Payments Do
			If ValueIsFilled(Row.PaymentType) Then
				Row.FinancialMovementType = Row.PaymentType.FinancialMovementType;
			EndIf;
		EndDo;
		ObjectValue.PaymentMethod = PaymentResult.ReceiptPaymentMethod;
		DPPointOfSaleServer.BeforePostingDocument(ObjectValue);

		Try
			ObjectValue.Write(DocumentWriteMode.Posting);
		Except
			Return Result;
		EndTry;

		DocRef = ObjectValue.Ref;
		DPPointOfSaleServer.AfterPostingDocument(DocRef);
		Result.Refs.Add(DocRef);
	EndIf;

	CashAmountFilter = New Structure();
	CashAmountFilter.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.Cash"));
	CashAmountFoundRows = Payments.FindRows(CashAmountFilter);
	For Each Row In CashAmountFoundRows Do
		If Row.Amount < 0 Then
			CashbackAmount = CashbackAmount + Row.Amount * (-1);
		EndIf;
	EndDo;
	Result.CashbackAmount = CashbackAmount; 

	Return Result;
EndFunction

&AtClient
Procedure SetShowItems()
	Items.PageButtons.CurrentPage = Items.ItemsPage;
EndProcedure

&AtClient
Procedure EnabledPaymentButton()
	Items.qPayment.Enabled = Object.ItemList.Count() > 0;
	Items.CommandBarPayments.Enabled = Object.ItemList.Count() = 0;
	SetPaymentButtonOnServer();
EndProcedure

&AtServer
Procedure SetPaymentButtonOnServer()
	ColorGreen = StyleColors.AccentColor;
	ColorRed = StyleColors.NegativeTextColor;

	If ThisObject.isReturn Then
		Items.qPayment.Title = R().InfoMessage_PaymentReturn;
		Items.qPayment.TextColor = ColorRed;
	Else
		Items.qPayment.Title = R().InfoMessage_Payment;
		Items.qPayment.TextColor = ColorGreen;
	EndIf;
	Items.qPayment.BorderColor = ColorGreen;
	Items.GroupPaymentButtons.Enabled = True;

	If DocConsolidatedRetailSalesServer.UseConsolidatedRetailSales(Object.Branch) Then
		If Not ValueIsFilled(Object.ConsolidatedRetailSales)
			OR Object.ConsolidatedRetailSales.Status = Enums.ConsolidatedRetailSalesStatuses.New Then
			Items.qPayment.Title = R().InfoMessage_SessionIsClosed;
			Items.qPayment.TextColor = ColorRed;
			Items.qPayment.BorderColor = ColorRed;
			Items.GroupPaymentButtons.Enabled = False;
		EndIf;
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
	SetSelectBasisDocumentColor();
EndProcedure

&AtServer
Procedure ClearRetailCustomerAtServer()
	ObjectValue = FormAttributeToValue("Object");
	FillingWithDefaultDataEvent.FillingDocumentsWithDefaultData(ObjectValue, Undefined, Undefined, True, True);
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

#EndRegion

#Region MoneyDocuments

&AtClient
Procedure CreateCashIn(Command)
	Items.GroupMainPages.CurrentPage = Items.CashPage;
	FillCashInList();
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
	CashInData.Insert("MoneyTransfer"           , CurrentData.MoneyTransfer);
	CashInData.Insert("Currency"                , CurrentData.Currency);
	CashInData.Insert("Amount"                  , CurrentData.Amount);
	CashInData.Insert("NetAmount"               , CurrentData.Amount);
	CashInData.Insert("ConsolidatedRetailSales" , Object.ConsolidatedRetailSales);

	FillingData = GetFillingDataMoneyTransferForCashReceipt(CashInData);
	OpenForm(
		"Document.CashReceipt.ObjectForm",
		New Structure("FillingValues", FillingData), ,
		New UUID(), , ,
		New NotifyDescription("CreateCashInFinish", ThisObject),
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Async Procedure CreateAndPostCashIn(Command)
	CurrentData = Items.CashInList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CashInData = New Structure();
	CashInData.Insert("MoneyTransfer"           , CurrentData.MoneyTransfer);
	CashInData.Insert("Currency"                , CurrentData.Currency);
	CashInData.Insert("Amount"                  , CurrentData.Amount);
	CashInData.Insert("NetAmount"               , CurrentData.Amount);
	CashInData.Insert("ConsolidatedRetailSales" , Object.ConsolidatedRetailSales);

	FillingData = GetFillingDataMoneyTransferForCashReceipt(CashInData);
	CashIn = CreateAndPostCashInAtServer(FillingData); // DocumentRef.CashReceipt
	CommonFunctionsClientServer.ShowUsersMessage(CashIn);
	PrintCashIn(CashIn);
	FillCashInList();
EndProcedure

// Print cash in.
//
// Parameters:
//  CashIn - DocumentRef.CashReceipt -  Cash in
&AtClient
Async Procedure PrintCashIn(CashIn)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CashIn, "ConsolidatedRetailSales");
	If ValueIsFilled(ConsolidatedRetailSales) Then
		EquipmentResult = Await EquipmentFiscalPrinterClient.CashInCome(ConsolidatedRetailSales
				, CashIn
				, GetSumm(CashIn)); // See EquipmentFiscalPrinterAPIClient.CashInOutcomeSettings
		If Not EquipmentResult.Info.Success Then
			CommonFunctionsClientServer.ShowUsersMessage(EquipmentResult.Info.Error);
		EndIf;
	EndIf;
EndProcedure

&AtServer
Function GetSumm(CashIn)
	Return CashIn.PaymentList.Total("TotalAmount");
EndFunction

// Create and post cash in at server.
//
// Parameters:
//  FillingData - Structure - Filling data:
// * BasedOn - String -
// * Date - Date -
// * TransactionType - EnumRef.IncomingPaymentTransactionType -
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
// * CashAccount - CatalogRef.CashAccounts -
// * Currency - CatalogRef.Currencies -
// * ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -
// * PaymentList - Array Of Structure -
//
// Returns:
//  DocumentRef.CashReceipt
&AtServer
Function CreateAndPostCashInAtServer(FillingData)
	Wrapper = BuilderAPI.Initialize("CashReceipt", , FillingData);
	Doc = BuilderAPI.Write(Wrapper, DocumentWriteMode.Posting);
	Return Doc.Ref;
EndFunction

&AtClient
Procedure CreateCashInFinish(Result, AddInfo) Export
	FillCashInList();
EndProcedure

&AtClient
Procedure UpdateMoneyTransfers(Command)
	FillCashInList();
EndProcedure

&AtClient
Procedure CreateCashOut(Command, AutoCreateMoneyTransfer = False)
	OpenFormParameters = New Structure();
	OpenFormParameters.Insert("AutoCreateMoneyTransfer", AutoCreateMoneyTransfer);
	OpenFormParameters.Insert("FillingData", GetFillingDataMoneyTransfer(0));
	OpenForm("DataProcessor.PointOfSale.Form.CashOut",
			OpenFormParameters, ,
			UUID, , ,
			New NotifyDescription("CreateCashOutFinish", ThisObject),
			FormWindowOpeningMode.LockWholeInterface);
EndProcedure

// Create cash out finish.
//
// Parameters:
//  CashOut - DocumentRef.MoneyTransfer - Cash out
//  AddInfo - Undefined - Add info
&AtClient
Procedure CreateCashOutFinish(CashOut, AddInfo) Export
	If ValueIsFilled(CashOut) Then
		PrintCashOut(CashOut);
	EndIf;
EndProcedure

&AtClient
Async Procedure PrintCashOut(CashOut)
	ConsolidatedRetailSales = CommonFunctionsServer.GetRefAttribute(CashOut, "ConsolidatedRetailSales");
	If Not ConsolidatedRetailSales.IsEmpty() Then
		Await EquipmentFiscalPrinterClient.CashOutCome(ConsolidatedRetailSales
				, CashOut
				, CommonFunctionsServer.GetRefAttribute(CashOut, "SendAmount"));
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
	FillingData.Insert("ConsolidatedRetailSales" , CashInData.ConsolidatedRetailSales);
	FillingData.Insert("PaymentList"    , New Array());
	NewRow = New Structure();
	NewRow.Insert("TotalAmount"           , CashInData.Amount);
	NewRow.Insert("NetAmount"             , CashInData.NetAmount);
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
	|	AND Account = &CashAccount) AS R3021B_CashInTransitIncoming";
	Query.SetParameter("CashAccount", Workstation.CashAccount);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		FillPropertyValues(ThisObject.CashInList.Add(), QuerySelection);
	EndDo;
EndProcedure

#EndRegion

#Region RetailSalesReturns

&AtClient
Procedure FindRetailBasis(RowID)
	FormParameters = New Structure;
	FormParameters.Insert("RetailCustomer", ThisObject.Object.RetailCustomer);

	If RowID = Undefined And Object.ItemList.Count() > 0 Then
		RowID = Object.ItemList[0].GetID();
	EndIf;

	If Not RowID = Undefined Then
		CurrentRow = Object.ItemList.FindByID(RowID);
		FormParameters.Insert("ItemKey", CurrentRow.ItemKey);
	EndIf;

	NotifyDescription = New NotifyDescription("FindRetailBasisFinish", ThisObject, RowID);
	OpenForm("CommonForm.SelectionRetailBasisForReturn",
		FormParameters, ThisObject, UUID, , , NotifyDescription, FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure FindRetailBasisFinish(Result, RowID) Export
	If Result = Undefined Then
		Return;
	EndIf;

	ThisObject.RetailBasis = Result;
	
	RetailBasisData = GetRetailBasisData();

	ThisObject.BasisPayments.Clear();
	For Each PaymentItem In RetailBasisData.Payments Do
		FillPropertyValues(ThisObject.BasisPayments.Add(), PaymentItem);
	EndDo;

	ThisObject.RetailBasisSpecialOffers.Clear();
	For Each OffersItem In RetailBasisData.SpecialOffers Do
		FillPropertyValues(ThisObject.RetailBasisSpecialOffers.Add(), OffersItem);
	EndDo;
	ThisObject.Object.ControlCodeStrings.Clear();
	FillOnSelectBasisDocument(Result);
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(ThisObject.Object);
	ControlCodeStringsClient.UpdateState(ThisObject.Object);
	FillSalesPersonInItemList();
	EnabledPaymentButton();	
	
EndProcedure

&AtServer
Function GetRetailBasisData()

	ItemListArray = New Array;
	PaymentsArray = New Array;
	RowIDInfoArray = New Array;
	SpecialOffersArray = New Array;
	SerialLotNumbersArray = New Array;
	ControlCodeStringsArray = New Array;

	ArrayOfBasises = New Array();
	ArrayOfBasises.Add(ThisObject.RetailBasis);
	MainFilter = New Structure();
	MainFilter.Insert("Ref", PredefinedValue("Document.RetailReturnReceipt.EmptyRef"));
	MainFilter.Insert("Basises", ArrayOfBasises);
	BasisesTable = RowIDInfoPrivileged.GetBasises(MainFilter.Ref, MainFilter);

	ResultTable = GetBasisResultTable(BasisesTable);
	ExtractedData = RowIDInfoPrivileged.ExtractData(ResultTable, MainFilter.Ref);

	If ExtractedData.Count() > 0 Then
		DocumentData = ExtractedData[0];
		DocumentData.Payments.GroupBy("PaymentType", "Amount");
		For Each TableItem In DocumentData.Payments Do
			ItemStructure = New Structure;
			ItemStructure.Insert("PaymentType", TableItem.PaymentType);
			ItemStructure.Insert("Amount", TableItem.Amount);
			PaymentsArray.Add(ItemStructure);
		EndDo;

		For Each TableItem In DocumentData.SerialLotNumbers Do
			ItemStructure = New Structure;
			ItemStructure.Insert("Key", TableItem.Key);
			ItemStructure.Insert("SerialLotNumber", TableItem.SerialLotNumber);
			ItemStructure.Insert("Quantity", TableItem.Quantity);
			SerialLotNumbersArray.Add(ItemStructure);
		EndDo;

		For Each TableItem In DocumentData.SpecialOffers Do
			ItemStructure = New Structure;
			ItemStructure.Insert("Key", TableItem.Key);
			ItemStructure.Insert("Offer", TableItem.Offer);
			ItemStructure.Insert("Amount", TableItem.Amount);
			ItemStructure.Insert("Percent", TableItem.Percent);
			ItemStructure.Insert("Bonus", TableItem.Bonus);
			ItemStructure.Insert("AddInfo", TableItem.AddInfo);
			SpecialOffersArray.Add(ItemStructure);
		EndDo;

		For Each TableItem In DocumentData.RowIDInfo Do
			ItemStructure = New Structure;
			ItemStructure.Insert("Key", TableItem.Key);
			ItemStructure.Insert("RowID", TableItem.RowID);
			ItemStructure.Insert("Quantity", TableItem.Quantity);
			ItemStructure.Insert("Basis", TableItem.Basis);
			ItemStructure.Insert("BasisKey", TableItem.BasisKey);
			ItemStructure.Insert("CurrentStep", TableItem.CurrentStep);
			ItemStructure.Insert("RowRef", TableItem.RowRef);
			RowIDInfoArray.Add(ItemStructure);
		EndDo;

		For Each TableItem In DocumentData.ItemList Do
			ItemStructure = New Structure;
			ItemStructure.Insert("Key", TableItem.Key);
			ItemStructure.Insert("Item", TableItem.Item);
			ItemStructure.Insert("ItemKey", TableItem.ItemKey);
			ItemStructure.Insert("Unit", TableItem.Unit);
			ItemStructure.Insert("BasisUnit", TableItem.BasisUnit);
			ItemStructure.Insert("Quantity", TableItem.Quantity);
			ItemStructure.Insert("QuantityInBaseUnit", TableItem.QuantityInBaseUnit);
			ItemStructure.Insert("Price", TableItem.Price);
			ItemStructure.Insert("PriceType", TableItem.PriceType);
			ItemListArray.Add(ItemStructure);
		EndDo;
		For Each TableItem In DocumentData.ControlCodeStrings Do
			ItemStructure = New Structure;
			ItemStructure.Insert("Key", TableItem.Key);
			ItemStructure.Insert("CodeString", TableItem.CodeString);
			ItemStructure.Insert("CodeIsApproved", TableItem.CodeIsApproved);
			ItemStructure.Insert("ControlCodeStringType", TableItem.ControlCodeStringType);
			ItemStructure.Insert("Prefix", TableItem.Prefix);
			ControlCodeStringsArray.Add(ItemStructure);
		EndDo;
	EndIf;

	Resultat = New Structure;
	Resultat.Insert("ItemList", ItemListArray);
	Resultat.Insert("Payments", PaymentsArray);
	Resultat.Insert("RowIDInfo", RowIDInfoArray);
	Resultat.Insert("SpecialOffers", SpecialOffersArray);
	Resultat.Insert("SerialLotNumbers", SerialLotNumbersArray);
	Resultat.Insert("ControlCodeStrings", ControlCodeStringsArray);

	Return Resultat;

EndFunction

&AtServer
Function GetBasisTable(RetailBasis)
	ArrayOfBasises = New Array();
	ArrayOfBasises.Add(RetailBasis);

	MainFilter = New Structure();
	MainFilter.Insert("Ref", PredefinedValue("Document.RetailReturnReceipt.EmptyRef"));
	MainFilter.Insert("Basises", ArrayOfBasises);

	Return RowIDInfoPrivileged.GetBasises(MainFilter.Ref, MainFilter);
EndFunction

&AtServer
Function GetBasisResultTable(Val BasisesTable)

	BasisesTypes = New Array();
	For Each Doc In Metadata.Documents Do
		If Doc.TabularSections.Find("RowIDInfo") <> Undefined Then
			BasisesTypes.Add(Type("DocumentRef." + Doc.Name));
		EndIf;
	EndDo;
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Basis"          , New TypeDescription(BasisesTypes));
	ResultTable.Columns.Add("BasisKey"       , Metadata.DefinedTypes.typeRowID.Type);
	ResultTable.Columns.Add("BasisUnit"      , New TypeDescription("CatalogRef.Units"));
	ResultTable.Columns.Add("Unit"           , New TypeDescription("CatalogRef.Units"));
	ResultTable.Columns.Add("CurrentStep"    , New TypeDescription("CatalogRef.MovementRules"));
	ResultTable.Columns.Add("IsMainDocument" , New TypeDescription("Boolean"));
	ResultTable.Columns.Add("Item"           , New TypeDescription("CatalogRef.Items"));
	ResultTable.Columns.Add("ItemKey"        , New TypeDescription("CatalogRef.ItemKeys"));
	ResultTable.Columns.Add("Key"            , Metadata.DefinedTypes.typeRowID.Type);
	ResultTable.Columns.Add("ParentBasis"    , New TypeDescription(BasisesTypes));
	ResultTable.Columns.Add("QuantityInBaseUnit" , Metadata.DefinedTypes.typeQuantity.Type);
	ResultTable.Columns.Add("RowID"          , Metadata.DefinedTypes.typeRowID.Type);
	ResultTable.Columns.Add("RowRef"         , New TypeDescription("CatalogRef.RowIDs"));
	ResultTable.Columns.Add("Store"          , New TypeDescription("CatalogRef.Stores"));

	For Each Row In BasisesTable Do
		NewRow = ResultTable.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Unit = Row.BasisUnit;
	EndDo;

	Return ResultTable;

EndFunction

&AtServer
Function CreateReturnOnBase(PaymentData, StatusType)

	BasisesTable = GetBasisTable(ThisObject.RetailBasis);

	ClearArray = New Array;
	For Each BasisesTableItem In BasisesTable Do
		ItemRowKey = BasisesTableItem.Key;
		ObjectRowIDInfo = ThisObject.Object.RowIDInfo.FindRows(New Structure("BasisKey", ItemRowKey));
		If ObjectRowIDInfo.Count() > 0 Then
			ItemRowKey = ObjectRowIDInfo[0].Key;
		EndIf;
		ReturnDataItems = ThisObject.Object.ItemList.FindRows(New Structure("Key", ItemRowKey));
		If ReturnDataItems.Count() > 0 And ReturnDataItems[0].QuantityInBaseUnit > 0 Then
			BasisesTableItem.QuantityInBaseUnit = ReturnDataItems[0].QuantityInBaseUnit;
		Else
			ClearArray.Add(BasisesTableItem);
		EndIf;
	EndDo;
	For Each ClearItem In ClearArray Do
		BasisesTable.Delete(ClearItem);
	EndDo;

	ResultTable = GetBasisResultTable(BasisesTable);
	ExtractedData = RowIDInfoPrivileged.ExtractData(
		ResultTable, PredefinedValue("Document.RetailReturnReceipt.EmptyRef"));

	isFirst = True;
	For Each ExtractedDataItem In ExtractedData Do
		ExtractedDataItem.Payments.Clear();
		ExtractedDataItem.SerialLotNumbers.Clear();
		ExtractedDataItem.ControlCodeStrings.Clear();
		If isFirst Then
			isFirst = False;
			For Each PaymentDataItem In PaymentData Do
				FillPropertyValues(ExtractedDataItem.Payments.Add(), PaymentDataItem);
			EndDo;
			For Each SerialItem In ThisObject.Object.SerialLotNumbers Do
				NewSerialRow = ExtractedDataItem.SerialLotNumbers.Add();
				FillPropertyValues(NewSerialRow, SerialItem);
				ObjectRowIDInfo = ThisObject.Object.RowIDInfo.FindRows(New Structure("Key", SerialItem.Key));
				If ObjectRowIDInfo.Count() > 0 Then
					NewSerialRow.Key = ObjectRowIDInfo[0].BasisKey;
				EndIf;
			EndDo;
			For Each ControlCode In Object.ControlCodeStrings Do
				NewControlCodeRow = ExtractedDataItem.ControlCodeStrings.Add();
				FillPropertyValues(NewControlCodeRow, ControlCode);
				ObjectRowIDInfo = ThisObject.Object.RowIDInfo.FindRows(New Structure("Key", ControlCode.Key));
				If ObjectRowIDInfo.Count() > 0 Then
					NewControlCodeRow.Key = ObjectRowIDInfo[0].BasisKey;
				EndIf;
			EndDo;
			For Each ItemListRow In ExtractedDataItem.ItemList Do
				ItemRowKey = ItemListRow.Key;
				ObjectRowIDInfo = ThisObject.Object.RowIDInfo.FindRows(New Structure("BasisKey", ItemRowKey));
				If ObjectRowIDInfo.Count() > 0 Then
					ItemRowKey = ObjectRowIDInfo[0].Key;
				EndIf;
				ReturnDataItems = ThisObject.Object.ItemList.FindRows(New Structure("Key", ItemRowKey));
				ItemListRow.isControlCodeString = ReturnDataItems[0].isControlCodeString;
			EndDo;
		EndIf;

		ExtractedDataItem.ItemList.FillValues(ThisObject.Object.Branch, "Branch");
	EndDo;

	ArrayOfFillingValues = RowIDInfoPrivileged.ConvertDataToFillingValues(
		PredefinedValue("Document.RetailReturnReceipt.EmptyRef").Metadata(), ExtractedData);

	DocRefs = New Array;
	For Each FillingValues In ArrayOfFillingValues Do
		If TypeOf(ThisObject.PostponedReceipt) = Type("DocumentRef.RetailReturnReceipt") Then
			NewDoc = GetClearPostponedObject();
		Else
			NewDoc = Documents.RetailReturnReceipt.CreateDocument();
		EndIf;
		NewDoc.Date = CommonFunctionsServer.GetCurrentSessionDate();
		NewDoc.StatusType = StatusType;
		NewDoc.Fill(FillingValues);
		NewDoc.ConsolidatedRetailSales = ThisObject.Object.ConsolidatedRetailSales;
		NewDoc.Write(DocumentWriteMode.Posting);
		DPPointOfSaleServer.AfterPostingDocument(NewDoc.Ref);
		DocRefs.Add(NewDoc.Ref);
	EndDo;
	
	Return DocRefs;

EndFunction

&AtServer
Function CreateReturnWithoutBase(PaymentData, StatusType)

	FillingData = New Structure();
	FillingData.Insert("BasedOn"                , "RetailReturnReceipt");
	FillingData.Insert("RetailCustomer"         , Object.RetailCustomer);
	FillingData.Insert("Company"                , Object.Company);
	FillingData.Insert("Branch"                 , Object.Branch);
	FillingData.Insert("Partner"                , Object.Partner);
	FillingData.Insert("LegalName"              , Object.LegalName);
	FillingData.Insert("LegalNameContract"      , Object.LegalNameContract);
	FillingData.Insert("Agreement"              , Object.Agreement);
	FillingData.Insert("Currency"               , Object.Currency);
	FillingData.Insert("PriceIncludeTax"        , Object.PriceIncludeTax);
	FillingData.Insert("ManagerSegment"         , Object.ManagerSegment);
	FillingData.Insert("UsePartnerTransactions" , Object.UsePartnerTransactions);
	FillingData.Insert("Workstation"            , Object.Workstation);
	FillingData.Insert("ConsolidatedRetailSales", Object.ConsolidatedRetailSales);

	FillingData.Insert("Payments"               , PaymentData);
	FillingData.Insert("ItemList"               , GetItemListForReturn());

	FillingData.Insert("SerialLotNumbers", Object.SerialLotNumbers.Unload());
	FillingData.Insert("ControlCodeStrings", Object.ControlCodeStrings.Unload());

	If TypeOf(ThisObject.PostponedReceipt) = Type("DocumentRef.RetailReturnReceipt") Then
		NewDoc = GetClearPostponedObject();
	Else
		NewDoc = Documents.RetailReturnReceipt.CreateDocument();
	EndIf;
	NewDoc.Date = CommonFunctionsServer.GetCurrentSessionDate();
	NewDoc.StatusType = StatusType;
	NewDoc.Fill(FillingData);
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(NewDoc);
	NewDoc.Write(DocumentWriteMode.Posting);

	DocRef = NewDoc.Ref;
	DPPointOfSaleServer.AfterPostingDocument(DocRef);

	Return DocRef;

EndFunction

&AtServer
Function GetItemListForReturn()
	Result = New Array;
	For Each ListItem In ThisObject.Object.ItemList Do
		NewRecord = New Structure;
		NewRecord.Insert("Key",          ListItem.Key);
		NewRecord.Insert("Store",        ListItem.Store);
		NewRecord.Insert("IsService",    ListItem.IsService);
		NewRecord.Insert("Item",         ListItem.Item);
		NewRecord.Insert("ItemKey",      ListItem.ItemKey);
		NewRecord.Insert("Unit",         ListItem.Unit);
		NewRecord.Insert("Quantity",     ListItem.Quantity);
		NewRecord.Insert("Price",        ListItem.Price);
		NewRecord.Insert("OffersAmount", ListItem.OffersAmount);
		NewRecord.Insert("TaxAmount",    ListItem.TaxAmount);
		NewRecord.Insert("NetAmount",    ListItem.NetAmount);
		NewRecord.Insert("TotalAmount",  ListItem.TotalAmount);
		Result.Add(NewRecord);
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure CheckByRetailBasis()
	If ThisObject.isReturn And Not ThisObject.RetailBasis.IsEmpty() Then
		CheckByRetailBasisAtServer();
	EndIf;
EndProcedure

&AtClient
Procedure RecalculateOffer(ListItem)
	If ListItem.RetailBasisQuantity = 0 Then
		Return;
	EndIf;

	ListItem.OffersAmount = 0;
	OfferRows = ThisObject.Object.SpecialOffers.FindRows(New Structure("Key", ListItem.Key));
	For Each OfferRow In OfferRows Do
		RowKey = OfferRow.Key;
		ObjectRowIDInfo = ThisObject.Object.RowIDInfo.FindRows(New Structure("Key", RowKey));
		If ObjectRowIDInfo.Count() > 0 Then
			RowKey = ObjectRowIDInfo[0].BasisKey;
		EndIf;
		
		RetailBasisAmount = 0;
		RetailBasisBonus = 0;
		BasisOffers = ThisObject.RetailBasisSpecialOffers.FindRows(
			New Structure("Key, Offer", RowKey, OfferRow.Offer));
		For Each BasisOffer In BasisOffers Do
			RetailBasisAmount = RetailBasisAmount + BasisOffer.Amount;
			RetailBasisBonus = RetailBasisBonus + BasisOffer.Bonus;
		EndDo;
		OfferRow.Amount = RetailBasisAmount * ListItem.Quantity / ListItem.RetailBasisQuantity;
		OfferRow.Bonus = RetailBasisBonus * ListItem.Quantity / ListItem.RetailBasisQuantity;
		ListItem.OffersAmount = ListItem.OffersAmount + OfferRow.Amount;
	EndDo;
EndProcedure

&AtServer
Procedure CheckByRetailBasisAtServer()

	BasisesTable = GetBasisTable(ThisObject.RetailBasis);

	For Each ListItem In ThisObject.Object.ItemList Do
		BasisKey = ListItem.Key;
		RowsID = ThisObject.Object.RowIDInfo.FindRows(New Structure("Key", ListItem.Key));
		If RowsID.Count() > 0 Then
			BasisKey = RowsID[0].BasisKey;
		EndIf;
		NeedQuantity = ListItem.QuantityInBaseUnit;
		BasisRow = BasisesTable.Find(BasisKey, "Key");
		If Not BasisRow = Undefined Then
			UseQuantity = Min(NeedQuantity, BasisRow.QuantityInBaseUnit);
			NeedQuantity = NeedQuantity - UseQuantity;
		EndIf;
		If NeedQuantity > 0 Then
			ErrorMessageString = StrTemplate(R().POS_Error_ReturnAmountLess,
				ListItem.ItemKey,
				Format(ListItem.QuantityInBaseUnit, "NZ=; NG=;"),
				Format((ListItem.QuantityInBaseUnit - NeedQuantity), "NZ=; NG=;"),
				ThisObject.RetailBasis);
			CommonFunctionsClientServer.ShowUsersMessage(ErrorMessageString);
			ListItem.RetailBasis = Undefined;
		Else
			ListItem.RetailBasis = ThisObject.RetailBasis;
		EndIf;
	EndDo;

EndProcedure

#EndRegion

#Region BasisDocument

&AtClient
Procedure SelectBasisDocument(Command)
	OpenFormNotifyDescription = New NotifyDescription("SelectBasisDocumentClose", ThisObject);
	FormParameters = New Structure();
	FormParameters.Insert("RetailCustomer", Object.RetailCustomer);
	OpenForm("DataProcessor.PointOfSale.Form.SelectBasisDocument", FormParameters, ThisObject, , , , OpenFormNotifyDescription, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

// Select basis document close.
//
// Parameters:
//  Result - DocumentRef.SalesOrder - Result
//  AdditionalData - Structure - Additional data
&AtClient
Procedure SelectBasisDocumentClose(Result, AdditionalData) Export
	If Result = Undefined Then
		Return;
	EndIf;

	FillOnSelectBasisDocument(Result);
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Object);
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(ThisObject.Object);
	ThisObject.Object.ControlCodeStrings.Clear();
	ControlCodeStringsClient.UpdateState(ThisObject.Object);
	FillSalesPersonInItemList();
	EnabledPaymentButton();
EndProcedure

&AtServer
Procedure FillOnSelectBasisDocument(BasisDocRef)

	If ThisObject.isReturn Then
		NewDocRef = Documents.RetailReturnReceipt.EmptyRef();
	Else
		NewDocRef = Documents.RetailSalesReceipt.EmptyRef();
	EndIf;
	
	FillParameters = New Structure("Basises, Ref", New Array, NewDocRef);
	FillParameters.Basises.Add(BasisDocRef);

	BasisesTable = RowIDInfoPrivileged.GetBasises(NewDocRef, FillParameters);

	If BasisesTable.Count() = 0 Then
		Return;
	EndIf;

	ExtractedData = RowIDInfoPrivileged.ExtractData(BasisesTable, BasisDocRef);
	FillingValues = RowIDInfoPrivileged.ConvertDataToFillingValues(NewDocRef.Metadata(), ExtractedData);

	NewObj = Documents.RetailSalesReceipt.CreateDocument();
	NewObj.Fill(FillingValues[0]);
	ValueToFormAttribute(NewObj, "Object");
	If ThisObject.isReturn Then
		For Each ItemListRow In Object.ItemList Do
			ItemListRow.RetailBasis = BasisDocRef;
			ItemListRow.RetailBasisQuantity = ItemListRow.Quantity; 
			If Not ItemListRow.isControlCodeString Then
				ItemListRow.isControlCodeString = CommonFunctionsServer.GetRefAttribute(ItemListRow.Item, "ControlCodeString");
			EndIf;
		EndDo;
	EndIf;
EndProcedure

#EndRegion

#Region LINKED_DOCUMENTS

&AtClient
Procedure LinkUnlinkBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_RSR(Object));
	FormParameters.Insert("SelectedRowInfo", RowIDInfoClient.GetSelectedRowInfo(Items.ItemList.CurrentData));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.LinkUnlinkDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters),
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddBasisDocuments(Command)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", RowIDInfoClientServer.GetLinkedDocumentsFilter_RSR(Object));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo(Object));
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form", ThisObject);
	OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddOrLinkUnlinkDocumentRowsContinue", ThisObject, NotifyParameters),
			FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddOrLinkUnlinkDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	ThisObject.Modified = True;
	ExtractedData = AddOrLinkUnlinkDocumentRowsContinueAtServer(Result);
	If ExtractedData <> Undefined Then
		ViewClient_V2.OnAddOrLinkUnlinkDocumentRows(ExtractedData, Object, ThisObject, "ItemList");
	EndIf;
	SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(Object);
	SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Object);
EndProcedure

&AtServer
Function AddOrLinkUnlinkDocumentRowsContinueAtServer(Result)
	ExtractedData = Undefined;
	If Result.Operation = "LinkUnlinkDocumentRows" Then
		LinkedResult = RowIDInfoServer.LinkUnlinkDocumentRows(Object, Result.FillingValues, Result.CalculateRows);
	ElsIf Result.Operation = "AddLinkedDocumentRows" Then
		LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(Object, Result.FillingValues);
	EndIf;
	ExtractedData = ControllerClientServer_V2.AddLinkedDocumentRows(Object, ThisObject, LinkedResult, "ItemList");
	LockLinkedRows();
	Return ExtractedData;
EndFunction

&AtServer
Procedure LockLinkedRows()
	RowIDInfoServer.SetAppearance(Object, ThisObject);
EndProcedure

#EndRegion

#Region Postponed

&AtClient
Procedure ClearCurrentReceipt(Command)
	NewTransaction();
	SetShowItems();
	SetDetailedInfo("");
	UpdateHTMLPictures();
	BuildDetailedInformation(Undefined);
	ThisObject.Modified = False;
EndProcedure

&AtClient
Procedure PostponeCurrentReceipt(Command)

	If Object.ItemList.Count() = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_045);
		Return;
	EndIf;	

	PostponeCurrentReceiptAtServer(False);
	
	ClearCurrentReceipt(Command);
	
EndProcedure

&AtClient
Procedure PostponeCurrentReceiptWithReserve(Command)

	If Object.ItemList.Count() = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_045);
		Return;
	EndIf;	

	PostponeCurrentReceiptAtServer(True);
	
	ClearCurrentReceipt(Command);
		
EndProcedure

&AtServer
Procedure PostponeCurrentReceiptAtServer(WithReserve)
	
	If Not ThisObject.isReturn Then
		ObjectValue = FormAttributeToValue("Object"); // DocumentObject.RetailSalesReceipt
		ObjectValue.Date = CommonFunctionsServer.GetCurrentSessionDate();
		ObjectValue.Workstation = Workstation;
		
		If WithReserve Then
			ObjectValue.StatusType = Enums.RetailReceiptStatusTypes.PostponedWithReserve;
		Else
			ObjectValue.StatusType = Enums.RetailReceiptStatusTypes.Postponed;
		EndIf;
		
		DPPointOfSaleServer.BeforePostingDocument(ObjectValue);
	
		ObjectValue.Write(DocumentWriteMode.Posting);
	ElsIf ThisObject.RetailBasis.IsEmpty() Then
		CreateReturnWithoutBase(New Array, Enums.RetailReceiptStatusTypes.Postponed);
	Else
		CreateReturnOnBase(New Array, Enums.RetailReceiptStatusTypes.Postponed);
	EndIf;

EndProcedure	

&AtClient
Procedure OpenPostponedReceipt(Command)
	
	If Object.ItemList.Count() > 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().POS_ClearAllItems);
		Return;
	EndIf;	
	
	Notification = New NotifyDescription("SelectPostponedReceiptNotify", ThisObject);
	OpenForm("DataProcessor.PointOfSale.Form.SelectPostponedReceipt", 
		New Structure("Branch", Object.Branch), , , , , 
		Notification, FormWindowOpeningMode.LockWholeInterface);

EndProcedure

&AtClient
Procedure SelectPostponedReceiptNotify(SelectedReceipt, AddInfo) Export
	If SelectedReceipt = Undefined Then
		Return;
	EndIf;
	
	OpenPostponedReceiptAtServer(SelectedReceipt);
	
	SourceOfOriginClient.UpdateSourceOfOriginsPresentation(Object);
	SerialLotNumberClient.UpdateSerialLotNumbersPresentation(Object);
	ControlCodeStringsClient.UpdateState(ThisObject.Object);
	
	EnabledPaymentButton();
	SetVisibilityAvailability(Object, ThisObject);
	EnabledPaymentButton();

	If isReturn Then
		Items.PageButtons.CurrentPage = Items.ReturnPage;
	Else
		SetShowItems();
	EndIf;
	
	SetDetailedInfo("");
	CurrentData = Items.ItemList.CurrentData;
	BuildDetailedInformation(?(CurrentData = Undefined, Undefined, CurrentData.ItemKey));	
	
	ThisObject.Modified = True;
EndProcedure

// Open postponed receipt at server.
// 
// Parameters:
//  Receipt - DocumentRef.RetailReturnReceipt - Receipt
&AtServer
Procedure OpenPostponedReceiptAtServer(Receipt)
	ThisObject.PostponedReceipt = Receipt;
	ThisObject.RetailBasis = Undefined;
	
	ReceiptObject = Receipt.GetObject();
	If TypeOf(Receipt) = Type("DocumentRef.RetailSalesReceipt") Then
		ThisObject.isReturn = False;
		ValueToFormAttribute(ReceiptObject, "Object");
	Else
		ThisObject.isReturn = True;
		FillPropertyValues(ThisObject.Object, ReceiptObject,, 
			"Ref,AddAttributes,ItemList,SpecialOffers,Currencies,Payments, DELETE_TaxList,
			|SerialLotNumbers,RowIDInfo,SourceOfOrigins,ControlCodeStrings");
		
		ItemListTable = ReceiptObject.ItemList.Unload();
		SpecialOffersTable = ReceiptObject.SpecialOffers.Unload();
		SerialLotNumbersTable = ReceiptObject.SerialLotNumbers.Unload();
		RowIDInfoTable = ReceiptObject.RowIDInfo.Unload();
		SourceOfOriginsTable = ReceiptObject.SourceOfOrigins.Unload();
		ControlCodeStringsTable = ReceiptObject.ControlCodeStrings.Unload();
		
		For Each ItemListRow In ItemListTable Do
			NewRecord = ThisObject.Object.ItemList.Add();
			FillPropertyValues(NewRecord, ItemListRow);
			If Not ItemListRow.RetailSalesReceipt.IsEmpty() Then
				NewRecord.RetailBasis = ItemListRow.RetailSalesReceipt;
				ThisObject.RetailBasis = NewRecord.RetailBasis;
			EndIf;
		EndDo;
		
		ThisObject.Object.SpecialOffers.Load(SpecialOffersTable);
		ThisObject.Object.Currencies.Load(ReceiptObject.Currencies.Unload());
		ThisObject.Object.SerialLotNumbers.Load(SerialLotNumbersTable);
		ThisObject.Object.RowIDInfo.Load(RowIDInfoTable);
		ThisObject.Object.SourceOfOrigins.Load(SourceOfOriginsTable);
		ThisObject.Object.ControlCodeStrings.Load(ControlCodeStringsTable);
	EndIf;
	
EndProcedure

// Receipts canceling.
// 
// Parameters:
//  Refs - Array of DocumentRef.RetailSalesReceipt - Refs
&AtServer
Procedure ReceiptsCanceling(Refs)
	For Each Ref In Refs Do
		ThisObject.PostponedReceipt = Ref;
		RefObject = Ref.GetObject();
		If RefObject.StatusType = Enums.RetailReceiptStatusTypes.Canceled Then
			Continue;
		EndIf;
		RefObject.StatusType = Enums.RetailReceiptStatusTypes.Canceled;
		RefObject.Write(DocumentWriteMode.Posting);
	EndDo;
EndProcedure

&AtServerNoContext
Function CancelingPostponedReceipts(ConsolidatedRetailSales)
	Result = 0;
	If Not ValueIsFilled(ConsolidatedRetailSales) Then
		Return Result;
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.Ref
	|FROM
	|	Document.RetailSalesReceipt AS RetailSalesReceipt
	|WHERE
	|	NOT RetailSalesReceipt.DeletionMark
	|	AND RetailSalesReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|	AND RetailSalesReceipt.StatusType IN (&Postponed, &PostponedWithReserve)
	|
	|UNION ALL
	|
	|SELECT
	|	RetailReturnReceipt.Ref
	|FROM
	|	Document.RetailReturnReceipt AS RetailReturnReceipt
	|WHERE
	|	NOT RetailReturnReceipt.DeletionMark
	|	AND RetailReturnReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|	AND RetailReturnReceipt.StatusType IN (&Postponed, &PostponedWithReserve)";
	
	Query.SetParameter("ConsolidatedRetailSales", ConsolidatedRetailSales);
	Query.SetParameter("PostponedWithReserve", Enums.RetailReceiptStatusTypes.PostponedWithReserve);
	Query.SetParameter("Postponed", Enums.RetailReceiptStatusTypes.Postponed);
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		ReceiptObject = QuerySelection.Ref.GetObject(); // DocumentObject.RetailSalesReceipt
		ReceiptObject.StatusType = Enums.RetailReceiptStatusTypes.Canceled;
		//@skip-check empty-except-statement
		Try
			ReceiptObject.Write(DocumentWriteMode.Posting);
			Result = Result + 1;
		Except EndTry;
	EndDo;
	
	Return Result;
EndFunction

// Get count postponed receipts.
// 
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales -  Consolidated retail sales
// 
// Returns:
//  Number -  Get count postponed receipts
&AtServerNoContext
Function GetCountPostponedReceipts(ConsolidatedRetailSales)
	Result = 0;
	If Not ValueIsFilled(ConsolidatedRetailSales) Then
		Return Result;
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	RetailSalesReceipt.ConsolidatedRetailSales AS ConsolidatedRetailSales,
	|	RetailSalesReceipt.Ref
	|INTO tmpAllReceipts
	|FROM
	|	Document.RetailSalesReceipt AS RetailSalesReceipt
	|WHERE
	|	NOT RetailSalesReceipt.DeletionMark
	|	AND RetailSalesReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|	AND RetailSalesReceipt.StatusType IN (&Postponed, &PostponedWithReserve)
	|
	|UNION ALL
	|
	|SELECT
	|	RetailReturnReceipt.ConsolidatedRetailSales,
	|	RetailReturnReceipt.Ref
	|FROM
	|	Document.RetailReturnReceipt AS RetailReturnReceipt
	|WHERE
	|	NOT RetailReturnReceipt.DeletionMark
	|	AND RetailReturnReceipt.ConsolidatedRetailSales = &ConsolidatedRetailSales
	|	AND RetailReturnReceipt.StatusType IN (&Postponed, &PostponedWithReserve)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpAllReceipts.ConsolidatedRetailSales,
	|	COUNT(tmpAllReceipts.Ref) AS CountPostponedReceipts
	|FROM
	|	tmpAllReceipts AS tmpAllReceipts
	|GROUP BY
	|	tmpAllReceipts.ConsolidatedRetailSales";
	
	Query.SetParameter("ConsolidatedRetailSales", ConsolidatedRetailSales);
	Query.SetParameter("PostponedWithReserve", Enums.RetailReceiptStatusTypes.PostponedWithReserve);
	Query.SetParameter("Postponed", Enums.RetailReceiptStatusTypes.Postponed);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Result = QuerySelection.CountPostponedReceipts;
	EndIf;
	
	Return Result;
EndFunction

&AtServer
Function GetClearPostponedObject()
	If ThisObject.PostponedReceipt = Undefined Then
		Return Undefined;
	EndIf;
	
	ReceiptObject = ThisObject.PostponedReceipt.GetObject(); // DocumentObject.RetailSalesReceipt
	
	ReceiptObject.ItemList.Clear();
	ReceiptObject.SpecialOffers.Clear();
	ReceiptObject.Currencies.Clear();
	ReceiptObject.SerialLotNumbers.Clear();
	ReceiptObject.RowIDInfo.Clear();
	ReceiptObject.SourceOfOrigins.Clear();
	ReceiptObject.ControlCodeStrings.Clear();
	ReceiptObject.Payments.Clear();
	
	ThisObject.PostponedReceipt = Undefined;
	
	Return ReceiptObject;
EndFunction
	
#EndRegion