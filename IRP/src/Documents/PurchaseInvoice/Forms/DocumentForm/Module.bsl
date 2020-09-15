
#Region FormEvents
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocPurchaseInvoiceServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		CurrentPartner = Object.Partner;
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	Taxes_CreateFormControls();
	ThisObject.TaxAndOffersCalculated = True;
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.OnOpen(Object, ThisObject, Cancel);
	SetLockedRowsByGoodsReceipts();
	UpdateGoodsReceiptsTree();
	
	SetTaxTreeRelevance(False);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;
	
	DocPurchaseInvoiceClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);
	
	ServerData = Undefined;		
	If TypeOf(Parameter) = Type("Structure") And Parameter.Property("AddInfo") Then
		ServerData = CommonFunctionsClientServer.GetFromAddInfo(Parameter.AddInfo, "ServerData");
	EndIf;
		
	If EventName = "CalculateTax" Then
		If ServerData <> Undefined And ServerData.OnChangeItemName <> "TaxTree" Then
			SetTaxTreeRelevance(False);
		EndIf;
	EndIf;
	
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
	
	If Upper(EventName) = Upper("CallbackHandler") Then
		CurrenciesClient.CalculateAmount(Object, ThisObject);
		CurrenciesClient.SetRatePresentation(Object, ThisObject);
				
		If ServerData <> Undefined Then
			CurrenciesClient.SetVisibleRows(Object, ThisObject, Parameter.AddInfo);
		EndIf;
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
	OnChangeItemName = "AfterWrite";
	ParametersToServer = New Structure();
		
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	
	CurrenciesClient.SetVisibleRows(Object, ThisObject, AddInfo);
	SetLockedRowsByGoodsReceipts();
	UpdateGoodsReceiptsTree();	
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	
	Taxes_CreateFormControls();
	DocPurchaseInvoiceServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocPurchaseInvoiceServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	Taxes_CreateFormControls();
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export
	Form.Items.LegalName.Enabled = ValueIsFilled(Object.Partner);
EndProcedure

#EndRegion

#Region FormItemsEvents

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocPurchaseInvoiceClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DeliveryDateOnChange(Item)
	DocumentsClient.DeliveryDateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerOnChange(Item, AddInfo = Undefined) Export	
	DocPurchaseInvoiceClient.PartnerOnChange(Object, ThisObject, Item, AddInfo);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure LegalNameOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocPurchaseInvoiceClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChange(Item)
	DocPurchaseInvoiceClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	//DocPurchaseInvoiceClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
	If ThisObject.TaxAndOffersCalculated Then
		ThisObject.TaxAndOffersCalculated = False;
	EndIf;
	CalculationStringsClientServer.ClearDependentData(Object);
	SetTaxTreeRelevance(False);
	ClearGoodsReceiptsTable();
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListOnChange(Object, ThisObject, Item);
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
	DocPurchaseInvoiceClient.ItemListOnActivateRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListItemOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListItemOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseInvoiceClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseInvoiceClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListUnitOnChange(Object, ThisObject, Item);
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListStoreOnChange(Item)
	DocPurchaseInvoiceClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item, AddInfo = Undefined) Export	
	DocPurchaseInvoiceClient.ItemListQuantityOnChange(Object, ThisObject, Item, AddInfo);
		
	UpdateGoodsReceiptsTree();
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item, AddInfo = Undefined) Export
	DocPurchaseInvoiceClient.ItemListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseInvoiceClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseInvoiceClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseInvoiceClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseInvoiceClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemAgreement

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseInvoiceClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseInvoiceClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocPurchaseInvoiceClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocPurchaseInvoiceClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
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
	OffersClient.OpenFormPickupSpecialOffers_ForDocument(Object,
		ThisObject,
		"SpecialOffersEditFinish_ForDocument");
EndProcedure

&AtClient
Procedure SpecialOffersEditFinish_ForDocument(Result, AdditionalParameters) Export
	OffersClient.SpecialOffersEditFinish_ForDocument(Result, Object, ThisObject, AdditionalParameters);
	
EndProcedure

#EndRegion

#Region Offers_for_row

&AtClient
Procedure SetSpecialOffersAtRow(Command)
	OffersClient.OpenFormPickupSpecialOffers_ForRow(Object,
		Items.ItemList.CurrentData,
		ThisObject,
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
	DocumentsClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	DocPurchaseInvoiceClient.ItemListTaxValueOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure TaxTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TaxTreeOnChange(Item, AddInfo = Undefined)
	CurrentData = Items.TaxTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OnChangeItemName = "TaxTree";
	ParametersToServer = New Structure();
	
	ParametersToServer.Insert("GetArrayOfCurrenciesRows", 
	New Structure("Agreement, Date, Company, Currency, UUID", 
	Object.Agreement, Object.Date, Object.Company, Object.Currency, ThisObject.UUID));
	
	ArrayOfMovementsTypes = New Array;
	For Each Row In Object.Currencies Do
		ArrayOfMovementsTypes.Add(Row.MovementType);
	EndDo;
	ParametersToServer.Insert("ArrayOfMovementsTypes", ArrayOfMovementsTypes);
	
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company", 
	ThisObject.TaxesCache, Object.Ref, Object.Date, Object.Company));
		
	ParametersToServer.Insert("GetTaxes_EmptyRef");
	ParametersToServer.Insert("GetTaxAnalytics_EmptyRef");
	ParametersToServer.Insert("GetTaxRates_EmptyRef");
			
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	ServerData.Insert("OnChangeItemName", OnChangeItemName);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ServerData", ServerData);
	
	
	Filter = TaxesClient.ChangeTaxAmount(Object, ThisObject, CurrentData, Object.ItemList, Undefined, AddInfo);
	//opt
	//CreateTaxTree_AtClient();
	//ThisObject.Items.TaxTree.CurrentRow = TaxesClient.FindRowInTree(Filter, ThisObject.TaxTree);
EndProcedure

&AtClient
Procedure TaxTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtServer
Function Taxes_CreateFormControls() Export
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
	
	// update tax cache after rebuild form controls
	
	ParametersToServer = New Structure();
	ParametersToServer.Insert("TaxesCache", 
	New Structure ("Cache, Ref, Date, Company", 
	ThisObject.TaxesCache, Object.Ref, Object.Date, Object.Company));
	
	ServerData = DocumentsServer.PrepareServerData_AtServerNoContext(ParametersToServer);
	Return ServerData.ArrayOfTaxInfo;
EndFUnction

&AtClient
Procedure SetTaxTreeRelevance(IsRelevanse)
	Items.GroupRelevanceStates.CurrentPage = 
	?(IsRelevanse, Items.GroupTaxTreeIsRelevanse, Items.GroupTaxTreeIsNotRelevanse);
EndProcedure
	
&AtClient
Procedure RefreshTaxTree(Command)
	ThisObject.TaxTree.GetItems().Clear();
	TableColumns = "Item, ItemKey, Key, Tax, Analytics, TaxRate, ManualAmount, Amount, TotalAmount, TotalManualAmount";
	Table1 = New Array;
	Table1_With_Analytics = New Array;
	For Each RowItemList In Object.ItemList Do
		ArrayOfTaxListRows = Object.TaxList.FindRows(New Structure("Key", RowItemList.Key));

		For Each RowTaxList In ArrayOfTaxListRows Do

			NewRow = New Structure(TableColumns);
			Table1.Add(NewRow);
			NewRow.Item              = RowItemList.Item;
			NewRow.ItemKey           = RowItemList.ItemKey;
			NewRow.Key               = RowTaxList.Key;
			NewRow.Tax               = RowTaxList.Tax;
			NewRow.Analytics         = RowTaxList.Analytics;
			NewRow.TaxRate           = RowTaxList.TaxRate;
			NewRow.ManualAmount      = RowTaxList.ManualAmount;
			NewRow.Amount            = RowTaxList.Amount;
			NewRow.TotalAmount       = ?(RowTaxList.IncludeToTotalAmount, RowTaxList.Amount, 0);
			NewRow.TotalManualAmount = ?(RowTaxList.IncludeToTotalAmount, RowTaxList.ManualAmount, 0);
			If ValueIsFilled(NewRow.Analytics) Then
				Table1_With_Analytics.Add(NewRow);
			EndIf;
		EndDo;
	EndDo;
	
	//Table1.GroupBy("Tax", "TotalManualAmount, TotalAmount")
	Table1_Grupped = New Array;
	For Each RowTable1 In Table1 Do
		FindRow = Undefined;
		For Each RowTable1_Grupped In Table1_Grupped Do
			If RowTable1.Tax = RowTable1_Grupped.Tax Then
				FindRow = RowTable1_Grupped;
				Break;
			EndIf;
		EndDo;
		If FindRow = Undefined Then
			Table1_Grupped.Add(New Structure("Tax, TotalAmount, TotalManualAmount", RowTable1.Tax,
				RowTable1.TotalAmount, RowTable1.TotalManualAmount));
		Else
			FindRow.TotalAmount = FindRow.TotalAmount + RowTable1.TotalAmount;
			FindRow.TotalManualAmount = FindRow.TotalManualAmount + RowTable1.TotalManualAmount;
		EndIf;
	EndDo;

	For Each Row1 In Table1_Grupped Do
		NewRow1 = ThisObject.TaxTree.GetItems().Add();
		FillPropertyValues(NewRow1, Row1);
		NewRow1.Amount = Row1.TotalAmount;
		NewRow1.ManualAmount = Row1.TotalManualAmount;
		NewRow1.Level = 1;
		NewRow1.ReadOnly = True;
		NewRow1.PictureEdit = 1;
		
		//Table2 = QueryTable.Copy(New Structure("Tax", Row1.Tax));
		Table2 = New Array;
		For Each RowTable1 In Table1 Do
			If RowTable1.Tax = Row1.Tax Then
				NewRowTable2 = New Structure(TableColumns);
				FillPropertyValues(NewRowTable2, RowTable1);
				Table2.Add(NewRowTable2);
			EndIf;
		EndDo;
		
		//Table2.GroupBy("Key, Item, ItemKey, TaxRate", "TotalManualAmount, TotalAmount");
		Table2_Grupped = New Array;
		For Each RowTable2 In Table2 Do
			FindRow = Undefined;
			For Each RowTable2_Grupped In Table2_Grupped Do
				If RowTable2.Key = RowTable2_Grupped.Key And RowTable2.Item = RowTable2_Grupped.Item
					And RowTable2.ItemKey = RowTable2_Grupped.ItemKey And RowTable2.TaxRate
					= RowTable2_Grupped.TaxRate Then
					FindRow = RowTable2_Grupped;
					Break;
				EndIf;
			EndDo;
			If FindRow = Undefined Then
				Table2_Grupped.Add(New Structure("Key, Item, ItemKey, TaxRate, TotalAmount, TotalManualAmount",
					RowTable2.Key, RowTable2.Item, RowTable2.ItemKey, RowTable2.TaxRate, RowTable2.TotalAmount,
					RowTable2.TotalManualAmount));
			Else
				FindRow.TotalAmount = FindRow.TotalAmount + RowTable2.TotalAmount;
				FindRow.TotalManualAmount = FindRow.TotalManualAmount + RowTable2.TotalManualAmount;
			EndIf;
		EndDo;

		For Each Row2 In Table2_Grupped Do
			NewRow2 = NewRow1.GetItems().Add();
			FillPropertyValues(NewRow2, Row1);
			FillPropertyValues(NewRow2, Row2);

			NewRow2.Amount = Row2.TotalAmount;
			NewRow2.ManualAmount = Row2.TotalManualAmount;

			NewRow2.Level = 2;
			If Not ValueIsFilled(Row2.TaxRate) Then
				NewRow2.ReadOnly = True;
				NewRow2.PictureEdit = 1;
			EndIf;
			
			//Filter2 = New Structure("Tax, Key, Item, ItemKey, TaxRate",
			//Row1.Tax, Row2.Key, Row2.Item, Row2.ItemKey, Row2.TaxRate);
			//Table3 = QueryTable.Copy(Filter2);

			Table3 = New Array;
			For Each RowTable1 In Table1_With_Analytics Do
				If RowTable1.Tax = Row1.Tax And RowTable1.Key = Row2.Key And RowTable1.Item = Row2.Item
					And RowTable1.ItemKey = Row2.ItemKey And RowTable1.TaxRate = Row2.TaxRate Then
					NewRowTable3 = New Structure(TableColumns);
					FillPropertyValues(NewRowTable3, RowTable1);
					Table3.Add(NewRowTable3);
				EndIf;
			EndDo;
		
			//Table3.GroupBy("Key, Analytics", "ManualAmount, Amount");
			Table3_Grupped = New Array;
			For Each RowTable3 In Table3 Do
				FindRow = Undefined;
				For Each RowTable3_Grupped In Table3_Grupped Do
					If RowTable3.Key = RowTable3_Grupped.Key And RowTable3.Analytics = RowTable3_Grupped.Analytics Then
						FindRow = RowTable3_Grupped;
						Break;
					EndIf;
				EndDo;
				If FindRow = Undefined Then
					Table3_Grupped.Add(New Structure("Key, Analytics, Amount, ManualAmount", RowTable3.Key,
						RowTable3.Analytics, RowTable3.Amount, RowTable3.ManualAmount));
				Else
					FindRow.Amount = FindRow.Amount + RowTable3.TotalAmount;
					FindRow.ManualAmount = FindRow.ManualAmount + RowTable3.ManualAmount;
				EndIf;
			EndDo;

			For Each Row3 In Table3_Grupped Do
				If ValueIsFilled(Row3.Analytics) Then
					NewRow2.ReadOnly = True;
					NewRow2.PictureEdit = 1;
					NewRow3 = NewRow2.GetItems().Add();

					FillPropertyValues(NewRow3, Row1);
					FillPropertyValues(NewRow3, Row2);
					FillPropertyValues(NewRow3, Row3);
					NewRow3.Level = 3;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
	TaxesClient.ExpandTaxTree(ThisObject.Items.TaxTree, ThisObject.TaxTree.GetItems());
	SetTaxTreeRelevance(True);
EndProcedure
	
#EndRegion

#Region Commands

&AtClient
Procedure OpenPickupItems(Command)
	DocPurchaseInvoiceClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	DocPurchaseInvoiceClient.SearchByBarcode(Barcode, Object, ThisObject);
EndProcedure

&AtClient
Procedure SelectGoodsReceipt(Command)
	CommandParameters = New Structure("Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
	FillPropertyValues(CommandParameters, Object);
	AlreadySelectedGoodsReceipts = New Array();
	For Each Row In Object.GoodsReceipts Do
		If AlreadySelectedGoodsReceipts.Find(Row.GoodsReceipt) = Undefined Then
			AlreadySelectedGoodsReceipts.Add(Row.GoodsReceipt);
		EndIf;
	EndDo;
	CommandParameters.Insert("AlreadySelectedGoodsReceipts", AlreadySelectedGoodsReceipts);
	InfoGoodsReceipt = DocPurchaseInvoiceServer.GetInfoGoodsReceiptBeforePurchaseInvoice(CommandParameters);
	
	FormParameters = New Structure("InfoGoodsReceipt", InfoGoodsReceipt.Tree);
	OpenForm("Document.PurchaseInvoice.Form.SelectGoodsReceiptForm"
		, FormParameters, , , ,
		, New NotifyDescription("SelectGoodsReceiptContinue", ThisObject,
			New Structure("InfoGoodsReceipt",
				InfoGoodsReceipt)));
EndProcedure

&AtClient
Procedure SelectGoodsReceiptContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ArrayOfBasisDocuments = New Array();
	For Each Row In AdditionalParameters.InfoGoodsReceipt.Linear Do
		If Result.Find(Row.GoodsReceipt) <> Undefined Then
			ArrayOfBasisDocuments.Add(Row);
		EndIf;
	EndDo;	
	SelectGoodsReceiptFinish(ArrayOfBasisDocuments);
	//opt
	//Taxes_CreateTaxTree();
	//CreateTaxTree_AtClient();
	SetTaxTreeRelevance(False);
	Taxes_CreateFormControls();
	SetLockedRowsByGoodsReceipts();
	UpdateGoodsReceiptsTree();	
EndProcedure

&AtServer
Procedure SelectGoodsReceiptFinish(ArrayOfBasisDocuments)
	DocPurchaseInvoiceServer.FillDocumentWithGoodsReceiptArray(Object, ThisObject, ArrayOfBasisDocuments);
	For Each Row In Object.ItemList Do
		Row.Item = Row.ItemKey.Item;
	EndDo;
EndProcedure

&AtClient
Procedure SelectPurchaseOrders(Command)
	FilterValues = New Structure("Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax");
	FillPropertyValues(FilterValues, Object);
	
	ExistingRows = New Array;
	For Each Row In Object.ItemList Do
		RowStructure = New Structure("Key, Unit, Quantity");
		FillPropertyValues(RowStructure, Row);
		ExistingRows.Add(RowStructure);
	EndDo;
	
	FormParameters = New Structure("FilterValues, ExistingRows, Ref", FilterValues, ExistingRows, Object.Ref);
	OpenForm("Document.PurchaseInvoice.Form.SelectPurchaseOrdersForm"
		, FormParameters, , , ,
		, New NotifyDescription("SelectPurchaseOrdersContinue", ThisObject));
EndProcedure

&AtClient
Procedure SelectPurchaseOrdersContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	SelectPurchaseOrdersContinueAtServer(Result, AdditionalParameters);
	
	DocPurchaseInvoiceClient.ItemListOnChange(Object, ThisObject, Items.ItemList);
EndProcedure

&AtServer
Procedure SelectPurchaseOrdersContinueAtServer(Result, AdditionalParameters)
	
	Settings = New Structure();
	Settings.Insert("Rows", New Array());
	Settings.Insert("CalculateSettings", New Structure());
	Settings.CalculateSettings = CalculationStringsClientServer.GetCalculationSettings(Settings.CalculateSettings);
	
	
	For Each ResultRow In Result Do
		RowsByKey = Object.ItemList.FindRows(New Structure("Key", ResultRow.Key));
		If RowsByKey.Count() Then
			RowByKey = RowsByKey[0];
			ItemKeyUnit = CatItemsServer.GetItemKeyUnit(ResultRow.ItemKey);
			UnitFactorFrom = Catalogs.Units.GetUnitFactor(RowByKey.Unit, ItemKeyUnit);
			UnitFactorTo = Catalogs.Units.GetUnitFactor(ResultRow.Unit, ItemKeyUnit);
			FillPropertyValues(RowByKey, ResultRow, , "Quantity");
			RowByKey.Quantity = ?(UnitFactorTo = 0,
					0,
					RowByKey.Quantity * UnitFactorFrom / UnitFactorTo) + ResultRow.Quantity;
			RowByKey.PriceType = ResultRow.PriceType;
			RowByKey.Price = ResultRow.Price;
			Settings.Rows.Add(RowByKey);
		Else
			NewRow = Object.ItemList.Add();
			FillPropertyValues(NewRow, ResultRow);
			NewRow.PriceType = ResultRow.PriceType;
			NewRow.Price = ResultRow.Price;
			Settings.Rows.Add(NewRow);
		EndIf;
	EndDo;
	
	TaxInfo = Undefined;
	SavedData = TaxesClientServer.GetSavedData(ThisObject, TaxesServer.GetAttributeNames().CacheName);
	If SavedData.Property("ArrayOfColumnsInfo") Then
		TaxInfo = SavedData.ArrayOfColumnsInfo;
	EndIf;
	CalculationStringsClientServer.CalculateItemsRows(Object,
		ThisObject,
		Settings.Rows,
		Settings.CalculateSettings,
		TaxInfo);
EndProcedure

#EndRegion

#Region Currencies


&AtClient
Procedure CurrenciesSelection(Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_Selection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesRatePresentationOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_RatePresentationOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesMultiplicityOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_MultiplicityOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesAmountOnChange(Item, AddInfo = Undefined)
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ExecuteAtClient", True);
	CurrenciesClient.CurrenciesTable_AmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure CurrenciesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
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

#Region GoodsReceiptsTree

&AtClient
Procedure SetLockedRowsByGoodsReceipts()
	If Not Object.GoodsReceipts.Count() Then
		Return;
	EndIf;
	
	For Each Row In Object.ItemList Do
		Row.LockedRow = Object.GoodsReceipts.FindRows(New Structure("Key", Row.Key)).Count() > 0;
	EndDo;
EndProcedure

&AtClient
Procedure ClearGoodsReceiptsTable()
	If Not Object.GoodsReceipts.Count() Then
		Return;
	EndIf;
	
	ArrayOfRows = New Array();
	For Each Row In Object.GoodsReceipts Do
		If Not Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayOfRows.Add(Row);
		EndIf;
	EndDo;
	
	For Each Row In ArrayOfRows Do
		Object.GoodsReceipts.Delete(Row);
	EndDo;
EndProcedure	

&AtClient
Procedure UpdateGoodsReceiptsTree()
	ThisObject.GoodsReceiptsTree.GetItems().Clear();
	
	If Not Object.GoodsReceipts.Count() Then
		Return;
	EndIf;
	
	ArrayOfRows = New Array();
	For Each Row In Object.ItemList Do
		ArrayOfGoodsReceipts = Object.GoodsReceipts.FindRows(New Structure("Key", Row.Key));
		
		If Not ArrayOfGoodsReceipts.Count() Then
			Continue;
		EndIf;
		
		NewRow = New Structure();
		NewRow.Insert("Key"         , Row.Key);
		NewRow.Insert("Item"        , Row.Item);
		NewRow.Insert("ItemKey"     , Row.ItemKey);
		NewRow.Insert("QuantityUnit", Row.Unit);
		NewRow.Insert("Unit"        );
		NewRow.Insert("Quantity"    , Row.Quantity);
		ArrayOfRows.Add(NewRow);
	EndDo;
	RecalculateInvoiceQuantity(ArrayOfRows);

	For Each Row In ArrayOfRows Do		
		NewRow0 = ThisObject.GoodsReceiptsTree.GetItems().Add();
		NewRow0.Level             = 1;
		NewRow0.Key               = Row.Key;
		NewRow0.Item              = Row.Item;
		NewRow0.ItemKey           = Row.ItemKey;
		NewRow0.QuantityInInvoice = Row.Quantity;
		
		For Each ItemOfArray In ArrayOfGoodsReceipts Do
			NewRow1 = NewRow0.GetItems().Add();
			NewRow1.Level                  = 2;
			NewRow1.Key                    = ItemOfArray.Key;
			NewRow1.GoodsReceipt           = ItemOfArray.GoodsReceipt;
			NewRow1.Quantity               = ItemOfArray.Quantity;
			NewRow1.QuantityInGoodsReceipt = ItemOfArray.QuantityInGoodsReceipt;
			NewRow1.PictureEdit            = True;
			NewRow0.Quantity               = NewRow0.Quantity + ItemOfArray.Quantity;
			NewRow0.QuantityInGoodsReceipt = NewRow0.QuantityInGoodsReceipt + ItemOfArray.QuantityInGoodsReceipt;
		EndDo;
	EndDo;
	
	For Each ItemTreeRows In ThisObject.GoodsReceiptsTree.GetItems() Do
		ThisObject.Items.GoodsReceiptsTree.Expand(ItemTreeRows.GetID());
	EndDo;	
EndProcedure

&AtServerNoContext
Procedure RecalculateInvoiceQuantity(ArrayOfRows)
	For Each Row In ArrayOfRows Do
		Row.Unit = ?(ValueIsFilled(Row.ItemKey.Unit), 
		Row.ItemKey.Unit, Row.ItemKey.Item.Unit);
		DocumentsServer.RecalculateQuantityInRow(Row);
	EndDo;
EndProcedure	

&AtClient
Procedure GoodsReceiptsTreeQuantityOnChange(Item)
	CurrentRow = Items.GoodsReceiptsTree.CurrentData;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	RowParent = CurrentRow.GetParent();
	TotalQuantity = 0;
	For Each Row In RowParent.GetItems() Do
		TotalQuantity = TotalQuantity + Row.Quantity;
	EndDo;
	RowParent.Quantity = TotalQuantity;
	ArrayOfRows = Object.GoodsReceipts.FindRows(
	New Structure("Key, GoodsReceipt", CurrentRow.Key, CurrentRow.GoodsReceipt));
	For Each Row In ArrayOfRows Do
		Row.Quantity = CurrentRow.Quantity;
	EndDo;
EndProcedure
	
&AtClient
Procedure GoodsReceiptsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure GoodsReceiptsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

	
#EndRegion


//NEW

//&AtServerNoContext
//Function PrepareServerData_AtServerNoContext(Parameters)
//	Result = New Structure();
//	
//	If Parameters.Property("ArrayOfMovementsTypes") Then
//		Result.Insert("ArrayOfCurrenciesByMmovementTypes", GetCurrencyByMovementType_AtServerNoContext(Parameters.ArrayOfMovementsTypes));
//	EndIf;
//	
//	If Parameters.Property("TaxesCache") Then
//		ArrayOfTaxInfo = New Array;
//		If ValueIsFilled(Parameters.TaxesCache) Then
//			SavedData = CommonFunctionsServer.DeserializeXMLUseXDTO(Parameters.TaxesCache);
//			If SavedData.Property("ArrayOfColumnsInfo") Then
//				ArrayOfTaxInfo = SavedData.ArrayOfColumnsInfo;
//				For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
//					ItemOfTaxInfo.Insert("TaxTypeIsRate", ItemOfTaxInfo.Type = Enums.TaxType.Rate);
//				EndDo;
//			EndIf;
//		EndIf;
//		Result.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
//	EndIf;
//	
//	If Parameters.Property("GetManagerSegmentByPartner") Then
//		Result.Insert("ManagerSegmentByPartner", DocumentsServer.GetManagerSegmentByPartner(Parameters.GetManagerSegmentByPartner.Partner));
//	EndIf;
//	
//	If Parameters.Property("GetLegalNameByPartner") Then
//		Result.Insert("LegalNameByPartner", DocumentsServer.GetLegalNameByPartner(Parameters.GetLegalNameByPartner.Partner, 
//																				  Parameters.GetLegalNameByPartner.LegalName));
//	EndIf;
//	
//	If Parameters.Property("GetPartnerSettings") Then
//		Result.Insert("PartnerSettings", GetPartnerSettings_AtServerNoContext());
//	EndIf;
//	
//	If Parameters.Property("GetAgreementByPartner") Then
//		Result.Insert("AgreementParameters", GetAgreementParameters_AtServerNoContext(Parameters.GetAgreementByPartner.Partner, 
//																					  Parameters.GetAgreementByPartner.Agreement, 
//																					  Parameters.GetAgreementByPartner.Date));
//		Result.Insert("AgreementByPartner" , DocumentsServer.GetAgreementByPartner(Result.AgreementParameters));
//	EndIf;
//	
//	If Parameters.Property("GetAgreementInfo") Then
//		Result.Insert("AgreementInfo", CatAgreementsServer.GetAgreementInfo(Parameters.GetAgreementInfo.Agreement));
//	EndIf;
//	
//	If Parameters.Property("GetArrayOfCurrenciesRows") Then
//		CurrenciesColumns = Metadata.Documents.PurchaseInvoice.TabularSections.Currencies.Attributes;
//		CurrenciesTable = New ValueTable();
//		CurrenciesTable.Columns.Add("Key"             , CurrenciesColumns.Key.Type);
//		CurrenciesTable.Columns.Add("CurrencyFrom"    , CurrenciesColumns.CurrencyFrom.Type);
//		CurrenciesTable.Columns.Add("Rate"            , CurrenciesColumns.Rate.Type);
//		CurrenciesTable.Columns.Add("ReverseRate"     , CurrenciesColumns.ReverseRate.Type);
//		CurrenciesTable.Columns.Add("ShowReverseRate" , CurrenciesColumns.ShowReverseRate.Type);
//		CurrenciesTable.Columns.Add("Multiplicity"    , CurrenciesColumns.Multiplicity.Type);
//		CurrenciesTable.Columns.Add("MovementType"    , CurrenciesColumns.MovementType.Type);
//		CurrenciesTable.Columns.Add("Amount"          , CurrenciesColumns.Amount.Type);
//		
//		If Result.Property("AgreementInfo") Then
//			AgreementInfo = Result.AgreementInfo;
//		Else
//			AgreementInfo = CatAgreementsServer.GetAgreementInfo(Parameters.GetArrayOfCurrenciesRows.Agreement);
//		EndIf;
//		
//		CurrenciesServer.FillCurrencyTable(New Structure("Currencies", CurrenciesTable), 
//	                                   Parameters.GetArrayOfCurrenciesRows.Date, 
//	                                   Parameters.GetArrayOfCurrenciesRows.Company, 
//	                                   Parameters.GetArrayOfCurrenciesRows.Currency, 
//	                                   Parameters.GetArrayOfCurrenciesRows.UUID,
//	                                   AgreementInfo);
//	    
//	    ArrayOfCurrenciesRows = New Array();                               
//	    For Each RowCurrenciesTable In CurrenciesTable Do
//	    	NewRow = New Structure("Key, CurrencyFrom, Rate, ReverseRate, ShowReverseRate, Multiplicity, MovementType, Amount");
//	    	FillPropertyValues(NewRow, RowCurrenciesTable);
//	    	ArrayOfCurrenciesRows.Add(NewRow);
//	    EndDo;
//	    
//	    Result.Insert("ArrayOfCurrenciesRows", ArrayOfCurrenciesRows);		
//	EndIf;
//	
//	If Parameters.Property("GetMetaDataStructure") Then
//		Result.Insert("MetaDataStructure", ServiceSystemServer.GetMetaDataStructure(Parameters.GetMetaDataStructure.Ref));
//	EndIf;
//	
//	Return Result;
//EndFunction	

//&AtServerNoContext
//Function GetPartnerSettings_AtServerNoContext()
//	Settings = New Structure("Actions, ObjectAttributes, FormAttributes, AgreementType");
//	
//	Actions = New Structure();
//	Actions.Insert("ChangeLegalName"		, "ChangeLegalName");
//	Actions.Insert("ChangeAgreement"		, "ChangeAgreement");
//	Settings.Actions = Actions;
//	
//	Settings.ObjectAttributes 	= "Company, Currency, PriceIncludeTax, Agreement, LegalName";
//	Settings.FormAttributes		= "CurrentPriceType";
//	Settings.AgreementType      = Enums.AgreementTypes.Vendor;
//	Return Settings;
//EndFunction
//
//&AtServerNoContext
//Function GetAgreementParameters_AtServerNoContext(Partner, Agreement, Date)
//	AgreementParameters = New Structure();
//	AgreementParameters.Insert("Partner"		, Partner);
//	AgreementParameters.Insert("Agreement"		, Agreement);
//	AgreementParameters.Insert("CurrentDate"	, Date);
//	AgreementParameters.Insert("AgreementType"	, Enums.AgreementTypes.Vendor);
//	
//	Return AgreementParameters;
//EndFunction	

//&AtServerNoContext
//Function GetCurrencyByMovementType_AtServerNoContext(ArrayOfMovementsTypes)
//	ArrayOfCurrenciesByMmovementTypes = New Array();
//	For Each MovementType In ArrayOfMovementsTypes Do
//		ArrayOfCurrenciesByMmovementTypes.Add(New Structure("MovementType, Currency", MovementType, MovementType.Currency));
//	EndDo;
//	Return ArrayOfCurrenciesByMmovementTypes;
//EndFunction
	
//for delete
&AtServer
Procedure Taxes_CreateTaxTree() Export
	TaxesTreeParameters = TaxesServer.GetCreateTaxTreeParameters();
	TaxesTreeParameters.MetadataMainList = Metadata.Documents.PurchaseInvoice.TabularSections.ItemList;
	TaxesTreeParameters.MetadataTaxList = Metadata.Documents.PurchaseInvoice.TabularSections.TaxList;
	TaxesTreeParameters.ObjectMainList = Object.ItemList;
	TaxesTreeParameters.ObjectTaxList = Object.TaxList;
	TaxesTreeParameters.MainListColumns = "Key, Item, ItemKey";
	TaxesTreeParameters.Level1Columns = "Tax";
	TaxesTreeParameters.Level2Columns = "Key, Item, ItemKey, TaxRate";
	TaxesTreeParameters.Level3Columns = "Key, Analytics";
	TaxesServer.CreateTaxTree(Object, ThisObject, TaxesTreeParameters);
EndProcedure


