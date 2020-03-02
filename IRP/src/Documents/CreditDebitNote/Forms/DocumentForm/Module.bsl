#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters, AddInfo = Undefined) Export
	DocCreditDebitNoteServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibility(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocCreditDebitNoteServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibility(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LibraryLoader.RegisterLibrary(Object, ThisObject, Currencies_GetDeclaration(Object, ThisObject));
	
	DocCreditDebitNoteServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	If Parameters.Key.IsEmpty() Then
		SetVisibility(Object, ThisObject);
	EndIf;
	SetConditionalAppearence();
EndProcedure

&AtClient
Procedure OnOpen(Cancel, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.OnOpen(Object, ThisObject, Cancel);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "SetVisibility" Then
		SetVisibility(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure SetConditionalAppearence() Export
	Return;
EndProcedure

#EndRegion

&AtClient
Procedure OperationTypeOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.OperationTypeOnChange(Object, ThisObject, Item);
	SetVisibility(Object, ThisObject);
EndProcedure

&AtClient
Procedure DateOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.DateOnChange(Object, ThisObject, Item);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibility(Object, Form)
	IsAp = Object.OperationType = PredefinedValue("Enum.CreditDebitNoteOperationsTypes.Payable");
	IsAr = Object.OperationType = PredefinedValue("Enum.CreditDebitNoteOperationsTypes.Receivable");
	
	Form.Items.TransactionsPartnerApTransactionsBasisDocument.Visible = IsAp;
	Form.Items.TransactionsPartnerArTransactionsBasisDocument.Visible = IsAr;
EndProcedure

&AtClient
Procedure FillTransactions(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	If Not ValueIsFilled(Object.OperationType) Then
		MessageText = StrTemplate(R()["Error_010"], "OperationType");
		CommonFunctionsClientServer.ShowUsersMessage(MessageText
			, "Object.OperationType"
			, Object.OperationType);
		Return;
	EndIf;
	
	If Object.Transactions.Count() Then
		ShowQueryBox(New NotifyDescription("FillTransactionsContinue", ThisObject),
			R().QuestionToUser_007,	QuestionDialogMode.YesNoCancel);
		Return;
	EndIf;
	FillTransactionsAtServer();
EndProcedure

&AtClient
Procedure FillTransactionsContinue(Answer, AdditionalParameters) Export
	If Answer = DialogReturnCode.Yes Then
		Object.Transactions.Clear();
		FillTransactionsAtServer();
	EndIf;
EndProcedure

&AtServer
Procedure FillTransactionsAtServer()
	Object.Transactions.Clear();
	
	TableName = "";
	BasisAttributeName = "";
	If Object.OperationType = Enums.CreditDebitNoteOperationsTypes.Payable Then
		TableName = "PartnerApTransactions";
		BasisAttributeName = "PartnerApTransactionsBasisDocument";
	ElsIf Object.OperationType = Enums.CreditDebitNoteOperationsTypes.Receivable Then
		TableName = "PartnerArTransactions";
		BasisAttributeName = "PartnerArTransactionsBasisDocument";
	Else
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	Table.Company,
		|	Table.BasisDocument AS %2,
		|	Table.Partner,
		|	Table.LegalName,
		|	Table.Agreement,
		|	Table.Currency,
		|	Table.AmountBalance AS Amount
		|FROM
		|	AccumulationRegister.%1.Balance(&Period, 
		|	Company = &Company
		|	AND LegalName = &LegalName 
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS Table
		|WHERE
		|	Table.AmountBalance > 0";
	Query.SetParameter("Period", ?(ValueIsFilled(Object.Ref),
			New Boundary(Object.Date, BoundaryType.Excluding),
			Undefined));
	Query.SetParameter("Company", Object.Company);
	Query.SetParameter("LegalName", Object.LegalName);
	
	Query.Text = StrTemplate(Query.Text, TableName, BasisAttributeName);
	
	TransferParameters = New Structure;
	TransferParameters.Insert("Period", Object.Date);
	TransferParameters.Insert("Company", Object.Company);
	Selection = Query.Execute().Select();
	While Selection.Next() Do
		NewRow = Object.Transactions.Add();
		FillPropertyValues(NewRow, Selection);
	EndDo;
	
EndProcedure

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemPartner

&AtClient
Procedure PartnerOnChange(Item)
	DocCreditDebitNoteClient.PartnerOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemLegalName

&AtClient
Procedure LegalNameOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.LegalNameOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure LegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.LegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure LegalNameEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.LegalNameTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsOnStartEdit(Item, NewRow, Clone)
	Return;
EndProcedure

#EndRegion

#Region ItemTransactionsPartner

&AtClient
Procedure TransactionsPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsPartnerEditTextChange(Item, Text, StandardProcessing)
	DocCreditDebitNoteClient.TransactionsPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransactionsBasisDocument

&AtClient
Procedure TransactionsBasisDocumentOnChange(Item, AddInfo = Undefined) Export
	DocCreditDebitNoteClient.TransactionsBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

#EndRegion

#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocCreditDebitNoteClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion


#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocCreditDebitNoteClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtClient
Procedure TransactionsOnChange(Item)
	For Each Row In Object.Transactions Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

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
	ArrayOfItems_MainTable.Add(Form.Items.Transactions);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableBeforeDeleteRow", "BeforeDeleteRow", ArrayOfItems_MainTable);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableOnActivateRow", "OnActivateRow", ArrayOfItems_MainTable);
	
	ArrayOfItems_MainTableColumns = New Array();
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsPartnerApTransactionsBasisDocument);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsPartnerArTransactionsBasisDocument);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsPartner);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsAgreement);
	ArrayOfItems_MainTableColumns.Add(Form.Items.TransactionsCurrency);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableColumnOnChange", "OnChange", ArrayOfItems_MainTableColumns);
	
	ArrayOfItems_MainTableAmount = New Array();
	ArrayOfItems_MainTableAmount.Add(Form.Items.TransactionsAmount);
	LibraryLoader.AddActionHandler(Declaration, "Currencies_MainTableAmountOnChange", "OnChange", ArrayOfItems_MainTableAmount);
	
	ArrayOfItems_Header = New Array();
	ArrayOfItems_Header.Add(Form.Items.Company);
	ArrayOfItems_Header.Add(Form.Items.OperationType);
	ArrayOfItems_Header.Add(Form.Items.LegalName);
	ArrayOfItems_Header.Add(Form.Items.Date);
	
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
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "Transactions");
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
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "Transactions");
	CurrenciesClientServer.MainTableColumnOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_MainTableAmountOnChange(Item, AddInfo = Undefined) Export
	CurrenciesClientServer.MainTableAmountOnChange(Object, ThisObject, Item, AddInfo);
EndProcedure

&AtClient
Procedure Currencies_HeaderOnChange(Item, AddInfo = Undefined) Export
	ArrayOfTableNames = New Array();
	ArrayOfTableNames.Add("Transactions");
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_ArrayOfTableNames", ArrayOfTableNames);
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Currencies_CurrentTableName", "Transactions");
	
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

