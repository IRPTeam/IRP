#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));	
	DocSalesReturnOrderServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
	// {TAXES}
	Taxes_CreateFormControls();
	Taxes_CreateTaxTree();
	// {TAXES}
	SetConditionalAppearance();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
	
	If Not Source = ThisObject Then
		Return;
	EndIf;
	
	DocSalesReturnOrderClient.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source);
	
	// {TAXES}
	If EventName = "CalculateTax" Then
		Taxes_CreateTaxTree();
		TaxesClient.ExpandTaxTree(ThisObject.Items.TaxTree, ThisObject.TaxTree.GetItems());
	EndIf;
	// {TAXES}
	
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
	DocSalesReturnOrderClient.AfterWrite(Object, ThisObject, WriteParameters);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	// {TAXES}
	Taxes_CreateFormControls();
	// {TAXES}
	
	DocSalesReturnOrderServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibilityAvailability(CurrentObject, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocSalesReturnOrderServer.OnReadAtServer(Object, ThisObject, CurrentObject);
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

&AtServer
Procedure SetConditionalAppearance()
	
	AppearanceElement = ConditionalAppearance.Items.Add();
	
	AppearanceElement.Appearance.SetParameterValue("MarkIncomplete", True);
EndProcedure

#EndRegion

#Region FormItemsEvents
&AtClient
Procedure StatusOnChange(Item)
	DocSalesReturnOrderClient.StatusOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	DocSalesReturnOrderClient.StoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.PartnerOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure LegalNameOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AgreementOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.AgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ManagerOnChange(Item)
	Return;
EndProcedure

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PriceIncludeTaxOnChange(Item)
	DocSalesReturnOrderClient.PriceIncludeTaxOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemListEvents

&AtClient
Procedure ItemListAfterDeleteRow(Item)
	DocSalesReturnOrderClient.ItemListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListOnChange(Object, ThisObject, Item);
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
	DocSalesReturnOrderClient.ItemListOnActivateRow(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemListItemsEvents

&AtClient
Procedure ItemListItemOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListItemOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemKeyOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListItemKeyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListUnitOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListUnitOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceTypeOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListPriceTypeOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListQuantityOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListQuantityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListPriceOnChange(Item, AddInfo = Undefined) Export
	DocSalesReturnOrderClient.ItemListPriceOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListStoreOnChange(Item, AddInfo = Undefined)
	DocSalesReturnOrderClient.ItemListStoreOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure ItemListItemStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.ItemListItemStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure ItemListItemEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.ItemListItemEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.PartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PartnerEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.PartnerTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemAgreement

&AtClient
Procedure AgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AgreementEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocSalesReturnOrderClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocSalesReturnOrderClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region DescriptionEvents

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocSalesReturnOrderClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocSalesReturnOrderClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocSalesReturnOrderClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocSalesReturnOrderClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	CurrentData = Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	PutToTaxTable_(Item.Name, CurrentData.Key, CurrentData[Item.Name]);
		
	Settings = New Structure();
	Settings.Insert("Rows", New Array());
	Settings.Insert("CalculateSettings");
	Settings.CalculateSettings = New Structure("CalculateTax");
	Settings.Rows.Add(CurrentData);
	DocumentsClient.ItemListCalculateRowsAmounts(Object, ThisObject, Settings);
EndProcedure

&AtServer
Procedure PutToTaxTable_(ItemName, Key, Value)
	TaxesServer.PutToTaxTableByColumnName(ThisObject, Key, ItemName, Value);
EndProcedure

&AtClient
Procedure TaxTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TaxTreeOnChange(Item)
	CurrentData = Items.TaxTree.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Filter = TaxesClient.ChangeTaxAmount(Object, ThisObject, CurrentData, Object.ItemList);
	Taxes_CreateTaxTree();
	TaxesClient.ExpandTaxTree(ThisObject.Items.TaxTree, ThisObject.TaxTree.GetItems());
	ThisObject.Items.TaxTree.CurrentRow = TaxesClient.FindRowInTree(Filter, ThisObject.TaxTree);
EndProcedure

&AtClient
Procedure TaxTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
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
	TaxesTreeParameters = TaxesServer.GetCreateTaxTreeParameters();
	TaxesTreeParameters.MetadataMainList = Metadata.Documents.SalesReturnOrder.TabularSections.ItemList;
	TaxesTreeParameters.MetadataTaxList = Metadata.Documents.SalesReturnOrder.TabularSections.TaxList;
	TaxesTreeParameters.ObjectMainList = Object.ItemList;
	TaxesTreeParameters.ObjectTaxList = Object.TaxList;
	TaxesTreeParameters.MainListColumns = "Key, Item, ItemKey";
	TaxesTreeParameters.Level1Columns = "Tax";
	TaxesTreeParameters.Level2Columns = "Key, Item, ItemKey, TaxRate";
	TaxesTreeParameters.Level3Columns = "Key, Analytics";
	TaxesServer.CreateTaxTree(Object, ThisObject, TaxesTreeParameters);
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure OpenPickupItems(Command)
	DocSalesReturnOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

&AtClient
Procedure SearchByBarcode(Command)
	DocSalesReturnOrderClient.SearchByBarcode(Command, Object, ThisObject);
EndProcedure

&AtClient
Procedure ItemListTotalAmountOnChange(Item, AddInfo = Undefined) Export
	CurrentData = ThisObject.Items.ItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	// To Do todo переписать
	TaxesClient.CalculateReverseTaxOnChangeTotalAmount(Object, ThisObject, CurrentData);
EndProcedure

&AtClient
Procedure DecorationStatusHistoryClick(Item)
	ObjectStatusesClient.OpenHistoryByStatus(Object.Ref, ThisObject);
EndProcedure

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

#Region Currencies

#Region Currencies_Library_Loader

&AtServerNoContext
Function Currencies_GetDeclaration(Object, Form)
	Declaration = LibraryLoader.GetDeclarationInfo();
	Declaration.LibraryName = "LibraryCurrencies";
	
	LibraryLoader.AddActionHandler(Declaration, "Currencies_OnOpen", "OnOpen", Form);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_AfterWriteAtServer", "AfterWriteAtServer", Form);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_AfterWrite", "AfterWrite", Form);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_NotificationProcessing", "NotificationProcessing", Form);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.ItemList);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableAmountOnChange", "OnChange", ArrayOfItems_MainTableAmount);
	
	ArrayOfItems_Header = New Array();
	ArrayOfItems_Header.Add(Form.Items.Partner);
	ArrayOfItems_Header.Add(Form.Items.LegalName);
	ArrayOfItems_Header.Add(Form.Items.Agreement);
	ArrayOfItems_Header.Add(Form.Items.Company);
	ArrayOfItems_Header.Add(Form.Items.Date);
	ArrayOfItems_Header.Add(Form.Items.Currency);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_HeaderOnChange", "OnChange", ArrayOfItems_Header);
	
	Columns = CurrenciesClientServer.GetPropertiesForReplace();
	Columns.Amount = "TotalAmount";
	TableColumns = New Structure("ItemList", Columns);
	
	LibraryData = New Structure();
	LibraryData.Insert("TableColumns", TableColumns);
	LibraryData.Insert("MainTableName", "ItemList");
	LibraryData.Insert("Version", "2.0");
	LibraryLoader.PutData(Declaration, LibraryData);
	Return Declaration;
EndFunction

#Region Currencies_Event_Handlers

&AtClient
Procedure Currencies_OnOpen(Cancel, AddInfo = Undefined) Export
	CurrenciesClientServer.OnOpen(Object, ThisObject, Cancel, AddInfo);
EndProcedure

&AtServer
Procedure Currencies_AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	CurrenciesClientServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters, AddInfo);
EndProcedure
	
&AtClient
Procedure Currencies_AfterWrite(WriteParameters, AddInfo = Undefined) Export
	CurrenciesClientServer.AfterWrite(Object, ThisObject, WriteParameters, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "ItemList");
	CurrenciesClientServer.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableAmountOnChange(Item, AddInfo = Undefined) Export
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "ItemList");
	CurrenciesClientServer.MainTableAmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_HeaderOnChange(Item, AddInfo = Undefined) Export
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("ItemList");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "ItemList");
	CurrenciesClientServer.HeaderOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

#EndRegion

#EndRegion

#Region Currencies_TableCurrencies_Events

&AtClient
Procedure CurrenciesSelection(Item, RowSelected, Field, StandardProcessing)
	CurrenciesClient.CurrenciesTable_Selection(Object, ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

&AtClient
Procedure CurrenciesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesRatePresentationOnChange(Item)
	CurrenciesClient.CurrenciesTable_RatePresentationOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrenciesMultiplicityOnChange(Item)
	CurrenciesClient.CurrenciesTable_MultiplicityOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrenciesAmountOnChange(Item)
	CurrenciesClient.CurrenciesTable_AmountOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region Currencies_Server_API

&AtServer
Procedure Currencies_SetVisibleCurrenciesRow(RowKey, IgnoreRowKey = False) Export
	CurrenciesServer.SetVisibleCurrenciesRow(Object, RowKey, IgnoreRowKey);
EndProcedure

&AtServer
Procedure Currencies_ClearCurrenciesTable(RowKey = Undefined) Export
	CurrenciesServer.ClearCurrenciesTable(Object, RowKey);
EndProcedure

&AtServer
Procedure Currencies_FillCurrencyTable(RowKey, Currency, AgreementInfo) Export
	CurrenciesServer.FillCurrencyTable(Object, 
	                                   Object.Date, 
	                                   Object.Company, 
	                                   Currency, 
	                                   RowKey,
	                                   AgreementInfo);
EndProcedure

&AtServer
Procedure Currencies_UpdateRatePresentation() Export
	CurrenciesServer.UpdateRatePresentation(Object);
EndProcedure

&AtServer
Procedure Currencies_CalculateAmount(Amount, RowKey) Export
	CurrenciesServer.CalculateAmount(Object, Amount, RowKey);
EndProcedure

&AtServer
Procedure Currencies_CalculateRate(Amount, MovementType, RowKey) Export
	CurrenciesServer.CalculateRate(Object, Amount, MovementType, RowKey);
EndProcedure

#EndRegion

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