#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Currency = Parameters.FiltersStructure.Currencies;
	ChequeAmount = Parameters.FiltersStructure.ChequeAmount;
	If Parameters.Property("FiltersStructure") Then
		SetDocumentListQueryText(Parameters);
		SetVisibility(ThisObject, Parameters.FiltersStructure);
	EndIf;
	
	UpdateHeader(ThisObject);
EndProcedure

&AtServer
Procedure SetDocumentListQueryText(Parameters)
	Filters = Parameters.FiltersStructure;
	If Filters.QueryType = "ChequeBondTransaction" Then
		ChequeBondType = Filters.Cheque.Type;
		If ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
			ThisObject.Title = R().Title_00100;
			SetQueryTextChequeBondTransactionOwnCheque(Parameters);
		ElsIf ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.PartnerCheque") Then
			ThisObject.Title = R().Title_00100;
			SetQueryTextChequeBondTransactionPartnerCheque(Parameters);
		Else
			Return;
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure SetQueryTextChequeBondTransactionOwnCheque(Parameters)
	Filters = Parameters.FiltersStructure;
	
	DocumentsList.CustomQuery = True;
	DocumentsList.QueryText = "SELECT
	|	PartnerApTransactionsBalance.BasisDocument,
	|	PartnerApTransactionsBalance.AmountBalance,
	|	PartnerApTransactionsBalance.Company,
	|	PartnerApTransactionsBalance.Currency,
	|	PartnerApTransactionsBalance.LegalName,
	|	PartnerApTransactionsBalance.Agreement,
	|	Isnull(PartnerApTransactionsBalance.BasisDocument.DocumentAmount, 0) As DocumentAmount,
	|	PartnerApTransactionsBalance.Partner
	|FROM
	|	AccumulationRegister.PartnerApTransactions.Balance(&EndDate, VALUETYPE(BasisDocument) IN
	|	(TYPE(Document.PurchaseInvoice), TYPE(Document.SalesReturn), TYPE(Document.CashTransferOrder))
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		PartnerApTransactionsBalance";
	
	DocumentsList.Parameters.SetParameterValue("EndDate", Filters.EndDate);
	DocumentsList.Filter.Items.Clear();
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Partners);
	Filter.LeftValue = New DataCompositionField("Partner");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Partners;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Companies);
	Filter.LeftValue = New DataCompositionField("Company");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Companies;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.LegalNames);
	Filter.LeftValue = New DataCompositionField("LegalName");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.LegalNames;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Agreements);
	Filter.LeftValue = New DataCompositionField("Agreement");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Agreements;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Currencies);
	Filter.LeftValue = New DataCompositionField("Currency");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Currencies;
	
	For Each Row In Parameters.RowsArray Do
		NewRow = PickedDocuments.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Key = Filters.Key;
		NewRow.Currency = Currency;
		NewRow.AmountBalance = Row.Amount;
	EndDo;
EndProcedure

&AtServer
Procedure SetQueryTextChequeBondTransactionPartnerCheque(Parameters)
	Filters = Parameters.FiltersStructure;
	
	DocumentsList.CustomQuery = True;
	DocumentsList.QueryText = "SELECT
	|	PartnerArTransactionsBalance.BasisDocument,
	|	PartnerArTransactionsBalance.AmountBalance,
	|	PartnerArTransactionsBalance.Company,
	|	PartnerArTransactionsBalance.Currency,
	|	PartnerArTransactionsBalance.LegalName,
	|	PartnerArTransactionsBalance.Agreement,
	|	Isnull(PartnerArTransactionsBalance.BasisDocument.DocumentAmount, 0) As DocumentAmount,
	|	PartnerArTransactionsBalance.Partner
	|FROM
	|	AccumulationRegister.PartnerArTransactions.Balance(&EndDate, VALUETYPE(BasisDocument) IN
	|	(TYPE(Document.SalesInvoice), TYPE(Document.PurchaseReturn), TYPE(Document.CashTransferOrder))
	|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
	|		PartnerArTransactionsBalance";
	
	DocumentsList.Parameters.SetParameterValue("EndDate", Filters.EndDate);
	DocumentsList.Filter.Items.Clear();
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Partners);
	Filter.LeftValue = New DataCompositionField("Partner");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Partners;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Companies);
	Filter.LeftValue = New DataCompositionField("Company");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Companies;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.LegalNames);
	Filter.LeftValue = New DataCompositionField("LegalName");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.LegalNames;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Agreements);
	Filter.LeftValue = New DataCompositionField("Agreement");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Agreements;
	
	Filter = DocumentsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
	Filter.Use = ValueIsFilled(Filters.Currencies);
	Filter.LeftValue = New DataCompositionField("Currency");
	Filter.ComparisonType = DataCompositionComparisonType.InList;
	Filter.RightValue = Filters.Currencies;
	
	For Each Row In Parameters.RowsArray Do
		NewRow = PickedDocuments.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Key = Filters.Key;
		NewRow.Currency = Currency;
		NewRow.AmountBalance = Row.Amount;
	EndDo;
EndProcedure

&AtServerNoContext
Procedure SetVisibility(Form, FiltersStructure)
	Form.Items.PickedDocumentsPartnerApBasisDocument.Visible = 
			Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque");
	Form.Items.PickedDocumentsPartnerArBasisDocument.Visible = 
			Form.ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.PartnerCheque");
	Form.Items.TotalAmount.Visible = False;
EndProcedure
#EndRegion

#Region FormtensEvents
&AtClient
Procedure DocumentsListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	
	CurrentData = Items.DocumentsList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	NewRow = PickedDocuments.Add();
	FillPropertyValues(NewRow, CurrentData);
	If ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.OwnCheque") Then
		NewRow.PartnerApBasisDocument = CurrentData.BasisDocument;
		NewRow.AmountBalance = 0;
		RowFilter = New Structure("PartnerApBasisDocument", CurrentData.BasisDocument);
	ElsIf ChequeBondType = PredefinedValue("Enum.ChequeBondTypes.PartnerCheque") Then
		NewRow.PartnerArBasisDocument = CurrentData.BasisDocument;
		NewRow.AmountBalance = 0;
		RowFilter = New Structure("PartnerApBasisDocument", CurrentData.BasisDocument);
	Else
		RowFilter = New Structure("Key", Undefined);
		NewRow.PartnerArBasisDocument = Undefined;
	EndIf;
	
	AmountBalance = CurrentData.AmountBalance; 
	Rows = PickedDocuments.FindRows(RowFilter);
	For Each Row In Rows Do
		AmountBalance = AmountBalance - Row.AmountBalance; 
	EndDo;

	NewRow.AmountBalance = AmountBalance;
	NewRow.Key = ThisObject.Key;
	
	UpdateHeader(ThisObject);
EndProcedure

#EndRegion

#Region Commands
&AtClient
Procedure CommandSaveAndClose(Command)
	Close(ThisObject.PickedDocuments);
EndProcedure

&AtClient
Procedure PickedDocumentsAfterDeleteRow(Item)
	UpdateHeader(ThisObject);
EndProcedure

&AtClient
Procedure PickedDocumentsAmountBalanceOnChange(Item)
	UpdateHeader(ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure UpdateHeader(Form)
	Form.DistributedAmount = Form.PickedDocuments.Total("AmountBalance");
	Form.RemainingAmount = Form.ChequeAmount - Form.DistributedAmount;
	Form.TotalAmount = Form.PickedDocuments.Total("AmountBalance");
EndProcedure

&AtClient
Procedure Edit(Command)
	CurrentData = Items.DocumentsList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ShowValue(, CurrentData.BasisDocument);
EndProcedure

&AtClient
Procedure PickedDocumentsSelection(Item, RowSelected, Field, StandardProcessing)
	DocChequeBondTransactionClient.ShowApArDocument(ThisObject, Item, RowSelected, Field, StandardProcessing);
EndProcedure

#EndRegion
