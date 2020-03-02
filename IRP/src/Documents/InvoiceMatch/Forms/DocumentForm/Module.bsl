#Region FormEvents

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	DocInvoiceMatchServer.AfterWriteAtServer(Object, ThisObject, CurrentObject, WriteParameters);
	SetVisibility();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	DocInvoiceMatchServer.OnReadAtServer(Object, ThisObject, CurrentObject);
	SetVisibility();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocInvoiceMatchServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
	SetVisibility();
	SetConditionalAppearence();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	DocInvoiceMatchClient.OnOpen(Object, ThisObject, Cancel);
	
	FillDebtAndAmount();
EndProcedure

&AtServer
Procedure SetConditionalAppearence() Export
	ConditionalAppearance.Items.Clear();
	
	AppearenceElement = ConditionalAppearance.Items.Add();
	
	FieldElement = AppearenceElement.Fields.Items.Add();
	FieldElement.Field = New DataCompositionField(Items.TransactionsLegalName.Name);
	
	FilterElement = AppearenceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue = New DataCompositionField("Object.Transactions.Partner");
	FilterElement.ComparisonType = DataCompositionComparisonType.NotFilled;
	
	AppearenceElement.Appearance.SetParameterValue("Enabled", False);
	
EndProcedure

#EndRegion

&AtClient
Procedure OperationTypeOnChange(Item)
	DocInvoiceMatchClient.OperationTypeOnChange(Object, ThisObject, Item);
	FillByBasisDocument();
	SetVisibility();
EndProcedure


&AtServer
Procedure SetVisibility()
	IsAp = False;
	IsAr = False;
	
	IsAp = Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithVendor;
	IsAr = Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithCustomer;
	
	Items.PartnerApTransactionsBasisDocument.Visible = IsAp;
	Items.PartnerArTransactionsBasisDocument.Visible = IsAr;
	
	Items.TransactionsPartnerApTransactionsBasisDocument.Visible = IsAp;
	Items.TransactionsPartnerArTransactionsBasisDocument.Visible = IsAr;
	
	Items.AdvancesPaymentDocument.Visible = IsAp;
	Items.AdvancesReceiptDocument.Visible = IsAr;
EndProcedure

&AtClient
Procedure PartnerApTransactionsBasisDocumentOnChange(Item)
	FillByBasisDocument();
	DocInvoiceMatchClient.PartnerApTransactionsBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerApTransactionsBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocInvoiceMatchClient.PartnerApTransactionsBasisDocumentStartChoice(
				Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure


&AtClient
Procedure PartnerArTransactionsBasisDocumentOnChange(Item)
	FillByBasisDocument();
	DocInvoiceMatchClient.PartnerArTransactionsBasisDocumentOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure PartnerArTransactionsBasisDocumentStartChoice(Item, ChoiceData, StandardProcessing)
	DocInvoiceMatchClient.PartnerArTransactionsBasisDocumentStartChoice(
				Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtServer
Procedure FillByBasisDocument()
	If Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithVendor Then
		If ValueIsFilled(Object.PartnerApTransactionsBasisDocument) Then
			Object.Currency = Object.PartnerApTransactionsBasisDocument.Currency;
			Object.LegalName = Object.PartnerApTransactionsBasisDocument.LegalName;
			Object.Partner = Object.PartnerApTransactionsBasisDocument.Partner;
			Object.Agreement = Object.PartnerApTransactionsBasisDocument.Agreement;
		Else
			Object.Currency = Catalogs.Currencies.EmptyRef();
			Object.LegalName = Catalogs.Companies.EmptyRef();
			Object.Partner = Catalogs.Partners.EmptyRef();
			Object.Agreement = Catalogs.Agreements.EmptyRef();
		EndIf;
		FillDebtAndAmount();
	EndIf;
	
	If Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithCustomer Then
		If ValueIsFilled(Object.PartnerArTransactionsBasisDocument) Then
			Object.Currency = Object.PartnerArTransactionsBasisDocument.Currency;
			Object.LegalName = Object.PartnerArTransactionsBasisDocument.LegalName;
			Object.Partner = Object.PartnerArTransactionsBasisDocument.Partner;
			Object.Agreement = Object.PartnerArTransactionsBasisDocument.Agreement;
		Else
			Object.Currency = Catalogs.Currencies.EmptyRef();
			Object.LegalName = Catalogs.Companies.EmptyRef();
			Object.Partner = Catalogs.Partners.EmptyRef();
			Object.Agreement = Catalogs.Agreements.EmptyRef();
		EndIf;
		FillDebtAndAmount();
	EndIf;
EndProcedure

&AtServer
Function GetApDebtByDocument(Object)
	ReturnValue = 0;
	
	QueryDebt = New Query;
	QueryDebt.Text = "SELECT ALLOWED
	|	PartnerApTransactionsBalance.BasisDocument,
	|	PartnerApTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.PartnerApTransactions.Balance(&EndPeriod, BasisDocument = &BasisDocument
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		PartnerApTransactionsBalance";
	QueryDebt.SetParameter("EndPeriod", ?(ValueIsFilled(Object.Ref),
			New Boundary(Object.Date, BoundaryType.Excluding),
			Undefined));
	QueryDebt.SetParameter("BasisDocument", Object.PartnerApTransactionsBasisDocument);
	QueryExecute = QueryDebt.Execute();
	
	If Not QueryExecute.IsEmpty() Then
		QuerySelection = QueryExecute.Select();
		QuerySelection.Next();
		ReturnValue = QuerySelection.AmountBalance;
	EndIf;
	
	Return ReturnValue;
EndFunction

&AtServer
Function GetArDebtByDocument(Object)
	ReturnValue = 0;
	
	QueryDebt = New Query;
	QueryDebt.Text = "SELECT ALLOWED
	|	PartnerApTransactionsBalance.BasisDocument,
	|	PartnerApTransactionsBalance.AmountBalance
	|FROM
	|	AccumulationRegister.PartnerArTransactions.Balance(&EndPeriod, BasisDocument = &BasisDocument
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		PartnerApTransactionsBalance";
	QueryDebt.SetParameter("EndPeriod", ?(ValueIsFilled(Object.Ref),
			New Boundary(Object.Date, BoundaryType.Excluding),
			Undefined));
	QueryDebt.SetParameter("BasisDocument", Object.PartnerArTransactionsBasisDocument);
	QueryExecute = QueryDebt.Execute();
	
	If Not QueryExecute.IsEmpty() Then
		QuerySelection = QueryExecute.Select();
		QuerySelection.Next();
		ReturnValue = QuerySelection.AmountBalance;
	EndIf;
	
	Return ReturnValue;
EndFunction

&AtClient
Procedure FillTransactions(Command)
	Return;
EndProcedure

&AtClient
Procedure FillAdvances(Command)
	FillAdvancesAtServer();
	FillDebtAndAmount();
EndProcedure

&AtServer
Procedure FillAdvancesAtServer()
	Query = New Query();
	If Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithVendor Then
		Query.Text = GetQueryTextByAdvanceToSuppliers();
	ElsIf Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithCustomer Then
		Query.Text = GetQueryTextByAdvanceFromCustomers();
	Else
		Raise R().Error_044;
	EndIf;
	
	Query.SetParameter("Period", ?(ValueIsFilled(Object.Ref),
			New Boundary(Object.Date, BoundaryType.Excluding),
			Undefined));
	Query.SetParameter("LegalName", Object.LegalName);
	Query.SetParameter("Company", Object.Company);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	Object.Advances.Clear();
	While QuerySelection.Next() Do
		NewRow = Object.Advances.Add();
		FillPropertyValues(NewRow, QuerySelection);
		
		CurrencyInfo = 
		Catalogs.Currencies.GetCurrencyInfo(Object.Date, Object.Currency, NewRow.Currency);
		
		NewRow.CurrencyRate = CurrencyInfo.Rate;
		NewRow.CurrencyMultiplicity = CurrencyInfo.Multiplicity;
		
		If NewRow.CurrencyMultiplicity = 0 Then
			NewRow.ClosingAmount = 0;
		Else
			NewRow.ClosingAmount = NewRow.Amount * (NewRow.CurrencyRate / NewRow.CurrencyMultiplicity);
		EndIf;
	EndDo;
EndProcedure

Function GetQueryTextByAdvanceToSuppliers()
	Return
	"SELECT
	|	AdvanceToSuppliersBalance.Company AS Company,
	|	AdvanceToSuppliersBalance.Partner AS Partner,
	|	AdvanceToSuppliersBalance.Partner AS DocumentPartner,
	|	AdvanceToSuppliersBalance.LegalName AS LegalName,
	|	AdvanceToSuppliersBalance.Currency AS Currency,
	|	AdvanceToSuppliersBalance.PaymentDocument AS PaymentDocument,
	|	AdvanceToSuppliersBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.AdvanceToSuppliers.Balance(&Period, Company = &Company
	|	AND LegalName = &LegalName
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		AdvanceToSuppliersBalance
	|ORDER BY
	|	AdvanceToSuppliersBalance.PaymentDocument.Date";
EndFunction

Function GetQueryTextByAdvanceFromCustomers()
	Return
	"SELECT
	|	AdvanceFromCustomersBalance.Company AS Company,
	|	AdvanceFromCustomersBalance.Partner AS Partner,
	|	AdvanceFromCustomersBalance.Partner AS DocumentPartner,
	|	AdvanceFromCustomersBalance.LegalName AS LegalName,
	|	AdvanceFromCustomersBalance.Currency AS Currency,
	|	AdvanceFromCustomersBalance.ReceiptDocument AS ReceiptDocument,
	|	AdvanceFromCustomersBalance.AmountBalance AS Amount
	|FROM
	|	AccumulationRegister.AdvanceFromCustomers.Balance(&Period, Company = &Company
	|	AND LegalName = &LegalName
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		AdvanceFromCustomersBalance
	|ORDER BY
	|	AdvanceFromCustomersBalance.ReceiptDocument.Date";
EndFunction

#Region ItemCompany

&AtClient
Procedure CompanyOnChange(Item)
	DocInvoiceMatchClient.CompanyOnChange(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure CompanyStartChoice(Item, ChoiceData, StandardProcessing)
	DocInvoiceMatchClient.CompanyStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure CompanyEditTextChange(Item, Text, StandardProcessing)
	DocInvoiceMatchClient.CompanyEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransactionsPartner

&AtClient
Procedure TransactionsPartnerStartChoice(Item, ChoiceData, StandardProcessing)
	DocInvoiceMatchClient.TransactionsPartnerStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsPartnerEditTextChange(Item, Text, StandardProcessing)
	DocInvoiceMatchClient.TransactionsPartnerEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion

#Region ItemTransactionsLegalName

&AtClient
Procedure TransactionsLegalNameStartChoice(Item, ChoiceData, StandardProcessing)
	DocInvoiceMatchClient.TransactionsLegalNameStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing);
EndProcedure

&AtClient
Procedure TransactionsLegalNameEditTextChange(Item, Text, StandardProcessing)
	DocInvoiceMatchClient.TransactionsLegalNameEditTextChange(Object, ThisObject, Item, Text, StandardProcessing);
EndProcedure

#EndRegion


#Region ItemDescription

&AtClient
Procedure DescriptionClick(Item, StandardProcessing)
	DocInvoiceMatchClient.DescriptionClick(Object, ThisObject, Item, StandardProcessing);
EndProcedure

#EndRegion


#Region GroupTitleDecorations

&AtClient
Procedure DecorationGroupTitleCollapsedPictureClick(Item)
	DocInvoiceMatchClient.DecorationGroupTitleCollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleCollapsedLalelClick(Item)
	DocInvoiceMatchClient.DecorationGroupTitleCollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedPictureClick(Item)
	DocInvoiceMatchClient.DecorationGroupTitleUncollapsedPictureClick(Object, ThisObject, Item);
EndProcedure

&AtClient
Procedure DecorationGroupTitleUncollapsedLalelClick(Item)
	DocInvoiceMatchClient.DecorationGroupTitleUncollapsedLalelClick(Object, ThisObject, Item);
EndProcedure

#EndRegion

&AtServer
Procedure FillDebtAndAmount()
	ThisObject.PartnerTransactionsBasisDocumentDebt = 0;
	ThisObject.PartnerTransactionsBasisDocumentAmount = 0;
	
	If Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithVendor
		And ValueIsFilled(Object.PartnerApTransactionsBasisDocument) Then
		ThisObject.PartnerTransactionsBasisDocumentDebt = GetApDebtByDocument(Object);
		ThisObject.PartnerTransactionsBasisDocumentAmount = Object.PartnerApTransactionsBasisDocument.DocumentAmount;
	EndIf;
	
	If Object.OperationType = Enums.InvoiceMatchOperationsTypes.WithCustomer
		And ValueIsFilled(Object.PartnerArTransactionsBasisDocument) Then
		ThisObject.PartnerTransactionsBasisDocumentDebt = GetArDebtByDocument(Object);
		ThisObject.PartnerTransactionsBasisDocumentAmount = Object.PartnerArTransactionsBasisDocument.DocumentAmount;
	EndIf;
EndProcedure

&AtClient
Procedure AdvancesCurrencyOnChange(Item)
	CurrencyOnChangeAtServer();
EndProcedure

&AtClient
Procedure TransactionsCurrencyOnChange(Item)
	CurrencyOnChangeAtServer();
EndProcedure

&AtClient
Procedure TransactionsOnChange(Item)
	For Each Row In Object.Transactions Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

&AtClient
Procedure AdvancesOnChange(Item)
	For Each Row In Object.Advances Do
		If Not ValueIsFilled(Row.Key) Then
			Row.Key = New UUID();
		EndIf;
	EndDo;
EndProcedure

#Region Currencies

Procedure CurrencyOnChangeAtServer()
	Object.Currencies.Clear();
	For Each Row In Object.Transactions Do
		CurrenciesServer.FiilCurrencyTable(Object, 
	                                       Object.Date, 
	                                       Object.Company, 
	                                       Row.Currency, 
	                                       Row.Key,
	                                       Row.Agreement);
	EndDo;
	For Each Row In Object.Advances Do
		CurrenciesServer.FiilCurrencyTable(Object, 
	                                       Object.Date, 
	                                       Object.Company, 
	                                       Row.Currency, 
	                                       Row.Key,
	                                       Undefined);
	EndDo;
EndProcedure

#EndRegion



