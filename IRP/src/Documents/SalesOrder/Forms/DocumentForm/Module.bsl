
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	ThisObject.TaxAndOffersCalculated = True;
	SetConditionalAppearance();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocSalesOrderClient.OnOpen(Object, ThisObject, Cancel);
	UpdateTotalAmounts();
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;

	If EventName = "LockLinkedRows" Then
		If Source <> ThisObject Then
			LockLinkedRows();
		EndIf;
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;

	DocSalesOrderClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);

	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
	
	If Upper(EventName) = Upper("CalculationStringsComplete") Then
		UpdateTotalAmounts();
	EndIf;
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	Return;
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	DocumentsServer.OnWriteAtServer(Object, ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters, AddInfo = Undefined) Export
	DocSalesOrderClient.AfterWriteAtClient(Object, ThisObject, WriteParameters);
	UpdateTotalAmounts();
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocSalesOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocSalesOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	ThisObject.ClosingOrder = DocSalesOrderServer.GetLastSalesOrderClosingBySalesOrder(Object.Ref);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
	If Not Form.ClosingOrder.IsEmpty() Then
		Form.ReadOnly = True;
	EndIf;
	Form.Items.GroupHead.Visible = Not Form.ClosingOrder.IsEmpty();
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	DocumentsClientServer.SetReadOnlyPaymentTermsCanBePaid(Object, Form);
EndProcedure

&AtServer
Procedure SetConditionalAppearance()

	AppearanceElement = ConditionalAppearance.Items.Add();
	FieldElement = AppearanceElement.Fields.Items.Add();
	FieldElement.Field = New DataCompositionField(Items.ItemListProcurementMethod.Name);

	FilterElementGroup = AppearanceElement.Filter.Items.Add(Type("DataCompositionFilterItemGroup"));
	FilterElementGroup.GroupType = DataCompositionFilterItemsGroupType.AndGroup;

	FilterElement = FilterElementGroup.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue = New DataCompositionField("Object.ItemList.ItemType");
	FilterElement.ComparisonType = DataCompositionComparisonType.Equal;
	FilterElement.RightValue = Enums.ItemTypes.Product;

	FilterElement = FilterElementGroup.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue = New DataCompositionField("Object.ItemList.ProcurementMethod");
	FilterElement.ComparisonType = DataCompositionComparisonType.NotFilled;

	AppearanceElement.Appearance.SetParameterValue("MarkIncomplete", True);
EndProcedure

&AtClient
Procedure UpdateTotalAmounts()
	ThisObject.TotalNetAmount = 0;
	ThisObject.TotalTotalAmount = 0;
	ThisObject.TotalTaxAmount = 0;
	ThisObject.TotalOffersAmount = 0;
	For Each Row In Object.ItemList Do
		If Row.Cancel Then
			Continue;
		EndIf;
		ThisObject.TotalNetAmount = ThisObject.TotalNetAmount + Row.NetAmount;
		ThisObject.TotalTotalAmount = ThisObject.TotalTotalAmount + Row.TotalAmount;

		ArrayOfTaxesRows = Object.TaxList.FindRows(New Structure("Key", Row.Key));
		For Each RowTax In ArrayOfTaxesRows Do
			ThisObject.TotalTaxAmount = ThisObject.TotalTaxAmount + ?(RowTax.IncludeToTotalAmount, RowTax.ManualAmount, 0);
		EndDo;

		ArrayOfOffersRows = Object.SpecialOffers.FindRows(New Structure("Key", Row.Key));
		For Each RowOffer In ArrayOfOffersRows Do
			ThisObject.TotalOffersAmount = ThisObject.TotalOffersAmount + RowOffer.Amount;
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#Region FormItemsEvents

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocSalesOrderClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DeliveryDateOnChange(Item)
	DocumentsClient.DeliveryDateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.PartnerOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure LegalNameOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesOrderClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChange(Item)
	DocSalesOrderClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StatusOnChange(Item)
	DocSalesOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ManagerOnChange(Item)
	Return;
EndProcedure

#EndRegion

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesOrderClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	UpdateTotalAmounts();
	LockLinkedRows();
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnStartEdit(Item, NewRow, Clone)
	DocSalesOrderClient.ItemListOnStartEdit(Object, ThisObject, Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure ItemListOnActivateRow(Item)
	DocSalesOrderClient.ItemListOnActivateRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListSelection(Item, RowSelected, Field, StandardProcessing)
	DocSalesOrderClient.ItemListSelection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListBeforeDeleteRow(Item, Cancel)
	DocSalesOrderClient.ItemListBeforeDeleteRow(Object, ThisObject, Item, Cancel);	
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListPartnerItemOnChange(Item)
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ItemAndItemKeyByPartnerItem = DocumentsServer.GetItemAndItemKeyByPartnerItem(CurrentData.PartnerItem);

	If ItemAndItemKeyByPartnerItem.Item <> CurrentData.Item Then
		CurrentData.Item = ItemAndItemKeyByPartnerItem.Item;
		DocSalesOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
	EndIf;

	If ItemAndItemKeyByPartnerItem.ItemKey <> CurrentData.ItemKey Then
		CurrentData.ItemKey = ItemAndItemKeyByPartnerItem.ItemKey;
		DocSalesOrderClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
	EndIf;
EndProcedure

&AtClient
Procedure ItemListItemOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item, AddInfo = Undefined) Export
	DocSalesOrderClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData <> Undefined And CurrentData.DontCalculateRow Then
		UpdateTotalAmounts();
	EndIf;
EndProcedure

&AtClient
Procedure ItemListTaxAmountOnChange(Item)
	DocSalesOrderClient.ItemListTaxAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListDontCalculateRowOnChange(Item)
	DocSalesOrderClient.ItemListDontCalculateRowOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocSalesOrderClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListProcurementMethodOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure ItemListNetAmountOnChange(Item)
	UpdateTotalAmounts();
EndProcedure

&AtClient
Procedure ItemListRevenueTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.ItemListRevenueTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListRevenueTypeEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.ItemListRevenueTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListCancelOnChange(Item)
	UpdateTotalAmounts();
	DocumentsClient.CalculatePaymentTermDateAndAmount(Object, ThisObject);
EndProcedure

#EndRegion

#Region PaymentTermsItemsEvents

&AtClient
Procedure PaymentTermsDateOnChange(Item)
	DocSalesOrderClient.PaymentTermsDateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentTermsOnChange(Item)
	DocSalesOrderClient.PaymentTermsOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemAgreement

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region SpecialOffers

#Region Offers_for_document

&AtClient
Procedure SetSpecialOffers(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object, ThisObject, "SpecialOffersEditFinish_ForDocument");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForDocument(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForDocument(Result, Object, ThisObject, AdditionalParameters);
	SpecialOffersEditFinishAtServer_ForDocument(Result, AdditionalParameters);
EndProcedure

&AtServer
Procedure SpecialOffersEditFinishAtServer_ForDocument(Result, AdditionalParameters) Export
	DocumentsServer.FillItemList(Object);
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

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocSalesOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocSalesOrderClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocSalesOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocSalesOrderClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Taxes

&AtClient
Procedure TaxValueOnChange(Item) Export
	DocSalesOrderClient.ItemListTaxValueOnChange(Object, ThisObject, Item);
EndProcedure

&AtServer
Function Taxes_CreateFormControls(AddInfo = Undefined) Export
	Return TaxesServer.CreateFormControls_ItemList(Object, ThisObject, AddInfo);
EndFunction

#EndRegion

#Region Commands

&AtClient
Procedure OpenPickupItems(Command)
	DocSalesOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SetProcurementMethods(Command)
	DocSalesOrderClient.SetProcurementMethods(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocSalesOrderClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure OpenScanForm(Command)
	DocumentsClient.OpenScanForm(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

#EndRegion

#Region AddAttributes

&AtClient
Procedure AddAttributeStartChoice(Item, ChoiceData, StandardProcessing) Export
	AddAttributesAndPropertiesClient.AddAttributeStartChoice(ThisObject, Item, StandardProcessing);
EndProcedure

&AtServer
Procedure AddAttributesCreateFormControl()
	AddAttributesAndPropertiesServer.CreateFormControls(ThisObject, "GroupOther");
EndProcedure

#EndRegion

#Region ExternalCommands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region LinkedDocuments

&AtServer
Procedure LockLinkedRows()
	RowIDInfoServer.LockLinkedRows(Object, ThisObject);
	RowIDInfoServer.SetAppearance(Object, ThisObject);
EndProcedure

&AtServer
Procedure UnlockLockLinkedRows()
	RowIDInfoServer.UnlockLinkedRows(Object, ThisObject);
EndProcedure

&AtClient
Procedure FromUnlockLinkedRows(Command)
	Items.FormUnlockLinkedRows.Check = Not Items.FormUnlockLinkedRows.Check;
	If Items.FormUnlockLinkedRows.Check Then
		UnlockLockLinkedRows();
	Else
		LockLinkedRows();
	EndIf;
EndProcedure

#EndRegion

#Region Service

&AtClient
Function GetProcessingModule() Export
	Str = New Structure;
	Str.Insert("Client", DocSalesOrderClient);
	Str.Insert("Server", DocSalesOrderServer);
	Return Str;
EndFunction

#EndRegion

&AtClient
Procedure EditCurrencies(Command)
	FormParameters = CurrenciesClientServer.GetParameters_V3(Object);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure
