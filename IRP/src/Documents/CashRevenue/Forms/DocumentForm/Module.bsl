#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));
	
	DocCashExpenseRevenueServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	Taxes_CreateFormControls();
	Taxes_CreateTaxTree();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCashExpenseRevenueServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnWriteAtServer(Cancel, CurrentObject, WriteParameters)
	Return;
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "CalculateTaxByNetAmount" Or 
		EventName = "CalculateTaxByTotalAmount" Or  
		EventName = "CalculateTax" Then
		Taxes_CreateTaxTree();
		TaxesClient.ExpandTaxTree(ThisObject.Items.TaxTree, ThisObject.TaxTree.GetItems());
	EndIf;
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters, AddInfo = Undefined) Export
	Return;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCashExpenseRevenueServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	Taxes_CreateFormControls();
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	Return;
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form) Export	
	Form.Items.PaymentListCurrency.ReadOnly = ValueIsFilled(Form.Currency);	
EndProcedure

#EndRegion 

#Region FormItemsEvents
&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.DateOnChange(Object, ThisObject, Item);
	//Taxes_CreateFormControls();
EndProcedure

&AtClient
Procedure PaymentListOnChange(Item)
	For Each Row In Object.PaymentList Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure PaymentListCurrencyOnChange(Item, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.PaymentListCurrencyOnChange(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListNetAmountOnChange(Item, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.PaymentListNetAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountOnChange(Item, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.AccountOnChange(Object, ThisObject, Item);
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocCashExpenseRevenueClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocCashExpenseRevenueClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOnStartEdit(Item, NewRow, Clone)
	DocCashExpenseRevenueClient.PaymentListOnStartEdit(Object, ThisObject, Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocCashExpenseRevenueClient.PaymentListAfterDeleteRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListTotalAmountOnChange(Item, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.PaymentListTotalAmountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocumentsClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region Taxes
&AtClient
Procedure TaxValueOnChange(Item) Export
	CurrentData = Items.PaymentList.CurrentData;
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
	Filter = TaxesClient.ChangeTaxAmount(Object, ThisObject, CurrentData, 
															Object.PaymentList, TaxesClient.GetCalculateRowsActions());
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
	TaxesParameters.PathToTable = "Object.PaymentList";
	TaxesParameters.ItemParent = ThisObject.Items.PaymentList;
	TaxesParameters.ColumnOffset = ThisObject.Items.PaymentListNetAmount;
	TaxesParameters.ItemListName = "PaymentList";
	TaxesParameters.TaxListName = "TaxList";
	TaxesServer.CreateFormControls(Object, ThisObject, TaxesParameters);
EndProcedure

&AtServer
Procedure Taxes_CreateTaxTree() Export
	TaxesTreeParameters = TaxesServer.GetCreateTaxTreeParameters();
	TaxesTreeParameters.MetadataMainList = Metadata.Documents.CashRevenue.TabularSections.PaymentList;
	TaxesTreeParameters.MetadataTaxList = Metadata.Documents.CashRevenue.TabularSections.TaxList;
	TaxesTreeParameters.ObjectMainList = Object.PaymentList;
	TaxesTreeParameters.ObjectTaxList = Object.TaxList;
	TaxesTreeParameters.MainListColumns = "Key, BusinessUnit, RevenueType, Currency";
	TaxesTreeParameters.Level1Columns = "Tax, Currency";
	TaxesTreeParameters.Level2Columns = "Key, BusinessUnit, RevenueType, TaxRate";
	TaxesTreeParameters.Level3Columns = "Key, Analytics";
	TaxesServer.CreateTaxTree(Object, ThisObject, TaxesTreeParameters);
EndProcedure
#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocCashExpenseRevenueClient.CompanyOnChange(Object, ThisObject, Item);
	//Taxes_CreateFormControls();
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocumentsClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocumentsClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocumentsClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocumentsClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
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
	
	ArrayOfItems_MainTable = New Array();
	ArrayOfItems_MainTable.Add(Form.Items.PaymentList);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableBeforeDeleteRow", "BeforeDeleteRow", ArrayOfItems_MainTable);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableOnActivateRow", "OnActivateRow", ArrayOfItems_MainTable);
	
	ArrayOfItems_MainTableColumns = New Array();
	ArrayOfItems_MainTableColumns.Add(Form.Items.PaymentListCurrency);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableColumnOnChange", "OnChange", ArrayOfItems_MainTableColumns);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.PaymentListNetAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.PaymentListTaxAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.PaymentListTotalAmount);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableAmountOnChange", "OnChange", ArrayOfItems_MainTableAmount);
	
	ArrayOfItems_Header = New Array();
	ArrayOfItems_Header.Add(Form.Items.Company);
	ArrayOfItems_Header.Add(Form.Items.Account);
	ArrayOfItems_Header.Add(Form.Items.Date);
	
	LibraryLoader.AddActionHandler(Declaration, "Currencies_HeaderOnChange", "OnChange", ArrayOfItems_Header);
	
	Columns = CurrenciesClientServer.GetPropertiesForReplace();
	Columns.Amount = "TotalAmount";
	TableColumns = New Structure("PaymentList", Columns);
	
	LibraryData = New Structure();
	LibraryData.Insert("TableColumns", TableColumns);
	LibraryData.Insert("Version", "1.0");
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
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "PaymentList");
	CurrenciesClientServer.AfterWrite(Object, ThisObject, WriteParameters, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("PaymentList");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "PaymentList");
	
	CurrenciesClientServer.NotificationProcessing(Object, ThisObject, EventName, Parameter, Source, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableBeforeDeleteRow(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableBeforeDeleteRow(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableOnActivateRow(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableOnActivateRow(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableColumnOnChange(Item, AddInfo = Undefined) Export
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", Item.Parent.Name);
	CurrenciesClientServer.MainTableColumnOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableAmountOnChange(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableAmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_HeaderOnChange(Item, AddInfo = Undefined) Export
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("PaymentList");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "PaymentList");
	
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
	CurrenciesServer.FiilCurrencyTable(Object, 
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

