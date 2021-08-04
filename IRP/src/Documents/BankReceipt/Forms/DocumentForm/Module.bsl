#Region FormEvents

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	AddAttributesAndPropertiesServer.BeforeWriteAtServer(ThisObject, Cancel, CurrentObject, WriteParameters);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source, AddInfo = Undefined) Export
	If EventName = "UpdateAddAttributeAndPropertySets" Then
		AddAttributesCreateFormControl();
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocBankReceiptClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocBankReceiptServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));	
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocBankReceiptServer.OnReadAtServer(Object, ThisObject, CurrentObject);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocBankReceiptServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
EndProcedure

#EndRegion

#Region ItemPaymentList

&AtClient
Procedure PaymentListOnChange(Item)
	DocBankReceiptClient.PaymentListOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListOnActivateRow(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListOnActivateRow(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListOnStartEdit(Item, NewRow, Clone, AddInfo = Undefined) Export
	DocumentsClient.PaymentListOnStartEdit(Object, ThisObject, Item, NewRow, Clone);
EndProcedure

&AtClient
Procedure PaymentListAfterDeleteRow(Item)
	DocumentsClient.CalculateTotalAmount(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListBasisDocumentStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListBasisDocumentOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAmountOnChange(Item, AddInfo = Undefined) Export
	DocumentsClient.CalculateTotalAmount(Object, ThisObject);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListPlaningTransactionBasisOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPlaningTransactionBasisStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.TransactionBasisStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListOnActivateCell(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.OnActiveCell(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListBeforeRowChange(Item, Cancel)
	DocBankReceiptClient.OnActiveCell(Object, ThisObject, Item, Cancel);
EndProcedure

&AtClient
Procedure PaymentListBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	DocBankReceiptClient.PaymentListBeforeAddRow(Object, ThisObject, Item, Cancel, Clone, Parent, IsFolder, Parameter);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListExpenseTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListExpenseTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListMovementTypeStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListMovementTypeStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListMovementTypeEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListMovementTypeEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#Region ItemPartner

&AtClient
Procedure PaymentListPartnerOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListPartnerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPartnerEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Payer

&AtClient
Procedure PaymentListPayerOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListPayerOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListPayerStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListPayerEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.PaymentListPayerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region Agreement

&AtClient
Procedure PaymentListAgreementOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.PaymentListAgreementOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PaymentListAgreementStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure PaymentListAgreementEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AgreementTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#EndRegion

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemDate

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocBankReceiptClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemCurrency

&AtClient
Procedure CurrencyOnChange(Item, AddInfo = Undefined) Export
	If CashTransferOrdersInPaymentList(Object.Currency) And Object.Currency <> CurrentCurrency Then
		ShowQueryBox(New NotifyDescription("CurrencyOnChangeContinue", ThisObject),
			R().QuestionToUser_008,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocBankReceiptClient.CurrencyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CurrencyOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		// delete rows with cash transfers
		ClearCashTransferOrders(Object.Currency);
		CurrentCurrency = Object.Currency;
		DocBankReceiptClient.CurrencyOnChange(Object, ThisObject, Items.Currency);
		Notify("CallbackHandler", Undefined, ThisObject);
	Else
		Object.Currency = CurrentCurrency;
	EndIf;
EndProcedure

#EndRegion

#Region ItemAccount

&AtClient
Procedure AccountOnChange(Item, AddInfo = Undefined) Export
	AccountCurrency = ServiceSystemServer.GetObjectAttribute(Object.Account, "Currency");
	If CashTransferOrdersInPaymentList(AccountCurrency) And AccountCurrency <> CurrentCurrency Then
		ShowQueryBox(New NotifyDescription("AccountOnChangeContinue", ThisObject),
			R().QuestionToUser_008,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	DocBankReceiptClient.AccountOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure AccountOnChangeContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		CurrentAccount = Object.Account;
		DocBankReceiptClient.AccountOnChange(Object, ThisObject, Items.Currency);
		ClearCashTransferOrders(Object.Currency);
		Notify("CallbackHandler", Undefined, ThisObject);
	Else
		Object.Account = CurrentAccount;
	EndIf;
EndProcedure

&AtClient
Procedure AccountStartChoice(Item, ChoiceData, StandardProcessing)
	DocBankReceiptClient.AccountStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure AccountEditTextChange(Item, Text, StandardProcessing)
	DocBankReceiptClient.AccountEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransitAccount
&AtClient
Procedure TransitAccountStartChoice(Item, ChoiceData, StandardProcessing)
	StandardProcessing = False;
	DefaultStartChoiceParameters = New Structure("Company", Object.Company);
	StartChoiceParameters = CatCashAccountsClient.GetDefaultStartChoiceParameters(DefaultStartChoiceParameters);
	StartChoiceParameters.CustomParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																		PredefinedValue("Enum.CashAccountTypes.Transit"),
																		,
																		DataCompositionComparisonType.Equal));
	StartChoiceParameters.FillingData.Insert("Type", PredefinedValue("Enum.CashAccountTypes.Transit"));
	OpenForm(StartChoiceParameters.FormName, StartChoiceParameters, Item, ThisObject.UUID, , ThisObject.URL);
EndProcedure

&AtClient
Procedure TransitAccountEditTextChange(Item, Text, StandardProcessing)
	DefaultEditTextParameters = New Structure("Company", Object.Company);
	EditTextParameters = CatCashAccountsClient.GetDefaultEditTextParameters(DefaultEditTextParameters);
	EditTextParameters.Filters.Add(DocumentsClientServer.CreateFilterItem("Type",
																		PredefinedValue("Enum.CashAccountTypes.Transit"),
																		ComparisonType.Equal));
	Item.ChoiceParameters = CatCashAccountsClient.FixedArrayOfChoiceParameters(EditTextParameters);
EndProcedure

#EndRegion

#Region ItemTransactionTypeOnChange

&AtClient
Procedure TransactionTypeOnChange(Item)
	DocBankReceiptClient.TransactionTypeOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocBankReceiptClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion

#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocBankReceiptClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLabelClick(Item)
	DocBankReceiptClient.DecorationGroupTitleCollapsedLabelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocBankReceiptClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLabelClick(Item)
	DocBankReceiptClient.DecorationGroupTitleUncollapsedLabelClick(Object, ThisObject, Item);
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
	
	ArrayOfItems_MainTable = New Array();
	ArrayOfItems_MainTable.Add(Form.Items.PaymentList);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableBeforeDeleteRow", "BeforeDeleteRow", ArrayOfItems_MainTable);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableOnActivateRow", "OnActivateRow", ArrayOfItems_MainTable);
	
	ArrayOfItems_MainTableColumns = New Array();
	ArrayOfItems_MainTableColumns.Add(Form.Items.PaymentListPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.PaymentListAgreement);
	ArrayOfItems_MainTableColumns.Add(Form.Items.PaymentListBasisDocument);
	ArrayOfItems_MainTableColumns.Add(Form.Items.PaymentListPayer);
	ArrayOfItems_MainTableColumns.Add(Form.Items.PaymentListPlaningTransactionBasis);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableColumnOnChange", "OnChange", ArrayOfItems_MainTableColumns);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.PaymentListAmount);
	ArrayOfItems_MainTableAmount.Add(Form.Items.PaymentListAmountExchange);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableAmountOnChange", "OnChange", ArrayOfItems_MainTableAmount);
	
	ArrayOfItems_Header = New Array();
	ArrayOfItems_Header.Add(Form.Items.Company);
	ArrayOfItems_Header.Add(Form.Items.Date);
	ArrayOfItems_Header.Add(Form.Items.Account);
	ArrayOfItems_Header.Add(Form.Items.Currency);
	ArrayOfItems_Header.Add(Form.Items.CurrencyExchange);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_HeaderOnChange", "OnChange", ArrayOfItems_Header);
	
	LibraryData = New Structure();
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
	
	If ValueIsFilled(Object.CurrencyExchange) And Object.CurrencyExchange <> Object.Currency Then
		CurrenciesServer.FillCurrencyTable(Object, 
	                                       Object.Date, 
	                                       Object.Company, 
	                                       Object.CurrencyExchange, 
	                                       RowKey,
	                                       AgreementInfo);
	EndIf;

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
	If ValueIsFilled(Object.CurrencyExchange) And Object.CurrencyExchange <> Object.Currency Then
		OwnerRow = CurrenciesClientServer.FindRowByUUID(Object, "PaymentList", RowKey);
		If OwnerRow <> Undefined Then
			CurrenciesServer.CalculateAmount(Object, OwnerRow.AmountExchange, RowKey, Object.CurrencyExchange);
		EndIf;
	EndIf;
	CurrenciesServer.CalculateAmount(Object, Amount, RowKey, Object.Currency);
EndProcedure

&AtServer
Procedure Currencies_CalculateRate(Amount, MovementType, RowKey) Export
	If ValueIsFilled(Object.CurrencyExchange) And Object.CurrencyExchange <> Object.Currency Then
		OwnerRow = CurrenciesClientServer.FindRowByUUID(Object, "PaymentList", RowKey);
		If OwnerRow <> Undefined Then
			CurrenciesServer.CalculateRate(Object, OwnerRow.AmountExchange, MovementType, RowKey, Object.CurrencyExchange);
		EndIf;
	EndIf;
	CurrenciesServer.CalculateRate(Object, Amount, MovementType, RowKey, Object.Currency);
EndProcedure

#EndRegion

#EndRegion

#Region Common

&AtClient
Procedure ClearCashTransferOrders(Val CashTransferOrderCurrency) Export
	For Each Row In Object.PaymentList Do
		If ValueIsFilled(Row.PlaningTransactionBasis)
			And TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder")
			And ServiceSystemServer.GetObjectAttribute(Row.PlaningTransactionBasis, "ReceiveCurrency") 
																					<> CashTransferOrderCurrency Then
			Row.PlaningTransactionBasis = Undefined;
		EndIf;
	EndDo;
EndProcedure

&AtClient
Function CashTransferOrdersInPaymentList(Val CashTransferOrderCurrency)
	Answer = False;
	For Each Row In Object.PaymentList Do
		If ValueIsFilled(Row.PlaningTransactionBasis)
			And TypeOf(Row.PlaningTransactionBasis) = Type("DocumentRef.CashTransferOrder")
			And ServiceSystemServer.GetObjectAttribute(Row.PlaningTransactionBasis, "ReceiveCurrency") 
																					<> CashTransferOrderCurrency Then
			Answer = True;
			Break;
		EndIf;
	EndDo;
	Return Answer;
EndFunction

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