#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "OpeningEntryPrint") = 0 Then
		Return OpeningEntryPrint(Ref, Param);
	EndIf;
EndFunction

// Sales Invoice print.
// 
// Parameters:
//  Ref - DocumentRef.OpeningEntry
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Opening entry print
Function OpeningEntryPrint(Ref, Param)
		
	Template = GetTemplate("OpeningEntryPrint");
	Template.LanguageCode = Param.LayoutLang;
	Query = New Query;
	Text =
	"SELECT
	|	DocumentHeader.Number AS Number,
	|	DocumentHeader.Date AS Date,
	|	DocumentHeader.Company.Description_en AS Company,
	|	DocumentHeader.Author AS Author,
	|	DocumentHeader.Ref AS Ref	
	|FROM
	|	Document.OpeningEntry AS DocumentHeader
	|WHERE
	|	DocumentHeader.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentItemList.ItemKey.Item.Description_en AS Item,
	|	DocumentItemList.ItemKey.Description_en AS ItemKey,
	|	DocumentItemList.Quantity AS Quantity,
	|	DocumentItemList.Item.Unit AS Unit,
	|	DocumentItemList.Price AS Price,
	|	DocumentItemList.AmountTax AS TaxAmount,
	|	DocumentItemList.Amount AS TotalAmount,
	|	DocumentItemList.Amount AS NetAmount,
	|	DocumentItemList.Ref AS Ref,
	|	DocumentItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.OpeningEntry.Inventory AS DocumentItemList
	|WHERE
	|	DocumentItemList.Ref = &Ref	
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Items.Item AS Item,
	|	Items.ItemKey AS ItemKey,
	|	Items.Quantity AS Quantity,
	|	Items.Unit AS Unit,
	|	Items.Price AS Price,
	|	Items.TaxAmount AS TaxAmount,
	|	Items.TotalAmount AS TotalAmount,
	|	Items.NetAmount AS NetAmount,
	|	Items.Ref AS Ref,
	|	Items.Key AS Key
	|FROM
	|	Items AS Items";

	LCode = Param.DataLang;
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Company", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.ItemKey.Item", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.ItemKey", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentItemList.Unit", LCode);
	Query.Text = Text;                                                    

	Query.Parameters.Insert("Ref", Ref);
	Selection = Query.ExecuteBatch();
	SelectionHeader = Selection[0].Select();
	SelectionItems = Selection[2].Unload();
	SelectionItems.Indexes.Add("Ref");

	AreaCaption = Template.GetArea("Caption");
	AreaHeader = Template.GetArea("Header");
	AreaItemListHeader = Template.GetArea("ItemListHeader|ItemColumn");
	AreaItemList = Template.GetArea("ItemList|ItemColumn");
	AreaFooter = Template.GetArea("Footer");

	Spreadsheet = New SpreadsheetDocument;
	Spreadsheet.LanguageCode = Param.LayoutLang;

	While SelectionHeader.Next() Do
		AreaCaption.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaCaption);

		AreaHeader.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaHeader);

		Spreadsheet.Put(AreaItemListHeader);
			
		Choice	= New Structure("Ref", SelectionHeader.Ref);
		FindRow = SelectionItems.FindRows(Choice);

		Number = 0;
		TotalSum = 0;
		TotalTax = 0;
		TotalNet = 0;
	
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);
			AreaItemList.Parameters.Number = Number;
			Spreadsheet.Put(AreaItemList);
			
			TotalSum = TotalSum + It.TotalAmount;
			TotalTax = TotalTax + It.TaxAmount;			
			TotalNet = TotalNet + It.NetAmount;
		EndDo;
	EndDo;

	AreaFooter.Parameters.Total = TotalSum;
	AreaFooter.Parameters.Total = TotalSum;
	AreaFooter.Parameters.TotalTax = TotalTax;
	AreaFooter.Parameters.TotalNet = TotalNet;
	AreaFooter.Parameters.Manager = SelectionHeader.Author;
	Spreadsheet.Put(AreaFooter);
	Spreadsheet = UniversalPrintServer.ResetLangSettings(Spreadsheet, Param.LayoutLang);
	Return Spreadsheet;
	
EndFunction	

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Calculate_BatchKeysInfo(Ref, Parameters, AddInfo);

	Tables = New Structure;
	
	CashInTransit = Metadata.AccumulationRegisters.CashInTransit;
	Tables.Insert(CashInTransit.Name, CommonFunctionsServer.CreateTable(CashInTransit));
	
	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	
	Tables.R3010B_CashOnHand.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1020B_AdvancesToVendors.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R1021B_VendorsTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2020B_AdvancesFromCustomers.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R2021B_CustomersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R8015T_ConsignorPrices.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3027B_EmployeeCashAdvance.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R9510B_SalaryPayment.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R5015B_OtherPartnersTransactions.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R3021B_CashInTransitIncoming.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.R8510B_BookValueOfFixedAsset.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Tables.CashInTransit.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	
	CashInTransit = Metadata.AccumulationRegisters.CashInTransit;
	PostingServer.SetPostingDataTable(PostingDataTables, Parameters, CashInTransit.Name, Parameters.DocumentDataTables[CashInTransit.Name]);
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure Calculate_BatchKeysInfo(Ref, Parameters, AddInfo)
	
	Query = New Query;
	Query.Text =
	"SELECT
	|	ReceiptFromConsignor.ItemKey,
	|	ReceiptFromConsignor.Store,
	|	ReceiptFromConsignor.Ref.Company AS Company,
	|	SUM(ReceiptFromConsignor.Quantity) AS Quantity,
	|	ReceiptFromConsignor.Ref.Date AS Period,
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	ReceiptFromConsignor.Key AS Key,
	|	SUM(ReceiptFromConsignor.Amount) AS Amount,
	|	ReceiptFromConsignor.Currency AS Currency,
	|	Value(ChartOfCharacteristicTypes.CurrencyMovementType.EmptyRef) AS CurrencyMovementType,
	|	SUM(ReceiptFromConsignor.AmountTax) AS AmountTax,
	|	CASE
	|		WHEN ReceiptFromConsignor.SerialLotNumber.BatchBalanceDetail
	|			THEN ReceiptFromConsignor.SerialLotNumber
	|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
	|	END AS SerialLotNumber,
	|	CASE
	|		WHEN ReceiptFromConsignor.SourceOfOrigin.BatchBalanceDetail
	|			THEN ReceiptFromConsignor.SourceOfOrigin
	|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
	|	END AS SourceOfOrigin
	|FROM
	|	Document.OpeningEntry.ReceiptFromConsignor AS ReceiptFromConsignor
	|WHERE
	|	ReceiptFromConsignor.Ref = &Ref
	|GROUP BY
	|	ReceiptFromConsignor.ItemKey,
	|	ReceiptFromConsignor.Store,
	|	ReceiptFromConsignor.Ref.Company,
	|	ReceiptFromConsignor.Ref.Date,
	|	VALUE(Enum.BatchDirection.Receipt),
	|	ReceiptFromConsignor.Key,
	|	ReceiptFromConsignor.Currency,
	|	Value(ChartOfCharacteristicTypes.CurrencyMovementType.EmptyRef),
	|	CASE
	|		WHEN ReceiptFromConsignor.SerialLotNumber.BatchBalanceDetail
	|			THEN ReceiptFromConsignor.SerialLotNumber
	|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
	|	END,
	|	CASE
	|		WHEN ReceiptFromConsignor.SourceOfOrigin.BatchBalanceDetail
	|			THEN ReceiptFromConsignor.SourceOfOrigin
	|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
	|	END";
	Query.SetParameter("Ref", Ref);

	QueryResult = Query.Execute();
	BatchKeysInfo = QueryResult.Unload();
	CurrencyTable = Ref.Currencies.UnloadColumns();
	CurrencyMovementType = Ref.Company.LandedCostCurrencyMovementType;
	For Each Row In BatchKeysInfo Do
		CurrenciesServer.AddRowToCurrencyTable(Ref.Date, CurrencyTable, Row.Key, Row.Currency, CurrencyMovementType);
	EndDo;
	
	T6020S_BatchKeysInfo = Metadata.InformationRegisters.T6020S_BatchKeysInfo;
	PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, T6020S_BatchKeysInfo.Name, BatchKeysInfo);
	Parameters.PostingDataTables[T6020S_BatchKeysInfo].WriteInTransaction = Parameters.IsReposting;
	
	CurrenciesServer.PreparePostingDataTables(Parameters, CurrencyTable, AddInfo);
	CurrenciesServer.ExcludePostingDataTable(Parameters, T6020S_BatchKeysInfo);
	
	BatchKeysInfo_DataTable = Parameters.PostingDataTables[T6020S_BatchKeysInfo].PrepareTable;
	
	BatchKeysInfoSettings = PostingServer.GetBatchKeysInfoSettings();
	BatchKeysInfoSettings.DataTable = BatchKeysInfo_DataTable;
	BatchKeysInfoSettings.Dimensions = "Period, Direction, Company, Store, ItemKey, Currency, CurrencyMovementType, SerialLotNumber, SourceOfOrigin";
	BatchKeysInfoSettings.Totals = "Quantity, Amount, AmountTax";
	BatchKeysInfoSettings.CurrencyMovementType = CurrencyMovementType;
	
	PostingServer.SetBatchKeyInfoTable(Parameters, BatchKeysInfoSettings);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.OpeningEntry.Inventory");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel 
		And Not AccReg.R4014B_SerialLotNumber.CheckBalance(
				Ref,
				LineNumberAndItemKeyFromItemList,
				PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters),
				PostingServer.GetQueryTableByName("Exists_R4014B_SerialLotNumber", Parameters),
				AccumulationRecordType.Receipt,
				Unposting,
				AddInfo
			) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	CommonFunctionsClientServer.PutToAddInfo(AddInfo, "TableDataPath", "Object.Inventory");
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.OpeningEntry.Inventory", AddInfo);
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(AccountBalance());
	QueryArray.Add(AdvancesToVendors());
	QueryArray.Add(VendorsTransactions());
	QueryArray.Add(AdvancesFromCustomers());
	QueryArray.Add(CustomersTransactions());
	QueryArray.Add(CustomersAging());
	QueryArray.Add(VendorsAging());
	QueryArray.Add(ShipmentToTradeAgent());
	QueryArray.Add(ReceiptFromConsignor());
	QueryArray.Add(EmployeeCashAdvance());
	QueryArray.Add(AdvanceFromRetailCustomers());
	QueryArray.Add(SalaryPayment());
	QueryArray.Add(OtherVendorsTransactions());
	QueryArray.Add(OtherCustomersTransactions());
	QueryArray.Add(CashInTransitDoc());
	QueryArray.Add(FixedAssets());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(CashInTransit());
	QueryArray.Add(R1020B_AdvancesToVendors());
	QueryArray.Add(R1021B_VendorsTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2023B_AdvancesFromRetailCustomers());
	QueryArray.Add(R3010B_CashOnHand());
	QueryArray.Add(R3027B_EmployeeCashAdvance());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5012B_VendorsAging());
	QueryArray.Add(R8015T_ConsignorPrices());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(R9510B_SalaryPayment());
	QueryArray.Add(T2014S_AdvancesInfo());
	QueryArray.Add(T2015S_TransactionsInfo());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R5015B_OtherPartnersTransactions());
	QueryArray.Add(R3021B_CashInTransitIncoming());
	QueryArray.Add(T8515S_FixedAssetsLocation());
	QueryArray.Add(R8515T_CostOfFixedAsset());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function ItemList()
	Return "SELECT
		   |	OpeningEntryInventory.Ref,
		   |	OpeningEntryInventory.Key,
		   |	OpeningEntryInventory.ItemKey,
		   |	OpeningEntryInventory.Store,
		   |	OpeningEntryInventory.Quantity,
		   |	NOT OpeningEntryInventory.SerialLotNumber = VALUE(Catalog.SerialLotNumbers.EmptyRef) AS isSerialLotNumberSet,
		   |	OpeningEntryInventory.SerialLotNumber,
		   |	OpeningEntryInventory.Ref.Date AS Period,
		   |	OpeningEntryInventory.Ref.Company AS Company,
		   |	OpeningEntryInventory.Ref.Branch AS Branch,
		   |	OpeningEntryInventory.Amount AS Amount,
		   |	OpeningEntryInventory.AmountTax AS AmountTax,
		   |	OpeningEntryInventory.Ref.Company.LandedCostCurrencyMovementType AS CurrencyMovementType,
		   |	OpeningEntryInventory.Ref.Company.LandedCostCurrencyMovementType.Currency AS Currency,
		   |	OpeningEntryInventory.SourceOfOrigin AS SourceOfOrigin
		   |INTO ItemList
		   |FROM
		   |	Document.OpeningEntry.Inventory AS OpeningEntryInventory
		   |WHERE
		   |	OpeningEntryInventory.Ref = &Ref";
EndFunction

Function AccountBalance()
	Return "SELECT
		   |	AccountBalance.Ref.Company AS Company,
		   |	AccountBalance.Ref.Branch AS Branch,
		   |	AccountBalance.Account,
		   |	AccountBalance.Currency,
		   |	AccountBalance.Amount AS Amount,
		   |	AccountBalance.Ref.Date AS Period,
		   |	AccountBalance.Key
		   |INTO AccountBalance
		   |FROM
		   |	Document.OpeningEntry.AccountBalance AS AccountBalance
		   |WHERE
		   |	AccountBalance.Ref = &Ref";
EndFunction

Function AdvancesToVendors()
	Return 
		"SELECT
		|	OpeningEntryAdvanceToSuppliers.Ref.Company AS Company,
		|	OpeningEntryAdvanceToSuppliers.Ref.Branch AS Branch,
		|	OpeningEntryAdvanceToSuppliers.Ref AS Basis,
		|	OpeningEntryAdvanceToSuppliers.Currency,
		|	OpeningEntryAdvanceToSuppliers.Partner,
		|	OpeningEntryAdvanceToSuppliers.LegalName,
		|	OpeningEntryAdvanceToSuppliers.LegalNameContract,
		|	case
		|		when OpeningEntryAdvanceToSuppliers.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			Then OpeningEntryAdvanceToSuppliers.Agreement
		|		else Undefined
		|	end AS Agreement,
		|	OpeningEntryAdvanceToSuppliers.Amount AS Amount,
		|	OpeningEntryAdvanceToSuppliers.Ref.Date AS Period,
		|	OpeningEntryAdvanceToSuppliers.Key,
		|	OpeningEntryAdvanceToSuppliers.Project
		|INTO AdvancesToVendors
		|FROM
		|	Document.OpeningEntry.AdvanceToSuppliers AS OpeningEntryAdvanceToSuppliers
		|WHERE
		|	OpeningEntryAdvanceToSuppliers.Ref = &Ref";
EndFunction

Function VendorsTransactions()
	Return "SELECT
		   |	OpeningEntryAccountPayableByDocuments.Ref.Date AS Period,
		   |	OpeningEntryAccountPayableByDocuments.Key,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Company,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Branch AS Branch,
		   |	OpeningEntryAccountPayableByDocuments.Ref AS Basis,
		   |	OpeningEntryAccountPayableByDocuments.Partner,
		   |	OpeningEntryAccountPayableByDocuments.LegalName,
		   |	OpeningEntryAccountPayableByDocuments.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountPayableByDocuments.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountPayableByDocuments.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountPayableByDocuments.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountPayableByDocuments.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountPayableByDocuments.Currency,
		   |	OpeningEntryAccountPayableByDocuments.Amount AS Amount,
		   |	OpeningEntryAccountPayableByDocuments.Project
		   |INTO VendorsTransactions
		   |FROM
		   |	Document.OpeningEntry.AccountPayableByDocuments AS OpeningEntryAccountPayableByDocuments
		   |WHERE
		   |	OpeningEntryAccountPayableByDocuments.Ref = &Ref
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	OpeningEntryAccountPayableByAgreements.Ref.Date,
		   |	OpeningEntryAccountPayableByAgreements.Key,
		   |	OpeningEntryAccountPayableByAgreements.Ref.Company,
		   |	OpeningEntryAccountPayableByAgreements.Ref.Branch,
		   |	UNDEFINED,
		   |	OpeningEntryAccountPayableByAgreements.Partner,
		   |	OpeningEntryAccountPayableByAgreements.LegalName,
		   |	OpeningEntryAccountPayableByAgreements.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountPayableByAgreements.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountPayableByAgreements.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountPayableByAgreements.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountPayableByAgreements.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountPayableByAgreements.Currency,
		   |	OpeningEntryAccountPayableByAgreements.Amount AS Amount,
		   |	OpeningEntryAccountPayableByAgreements.Project
		   |FROM
		   |	Document.OpeningEntry.AccountPayableByAgreements AS OpeningEntryAccountPayableByAgreements
		   |WHERE
		   |	OpeningEntryAccountPayableByAgreements.Ref = &Ref";
EndFunction

Function OtherVendorsTransactions()
	Return 
		"SELECT
		|	OpeningEntryAccountPayableOther.Ref.Date AS Period,
		|	OpeningEntryAccountPayableOther.Key,
		|	OpeningEntryAccountPayableOther.Ref.Company AS Company,
		|	OpeningEntryAccountPayableOther.Ref.Branch AS Branch,
		|	OpeningEntryAccountPayableOther.Partner,
		|	OpeningEntryAccountPayableOther.LegalName,
		|	OpeningEntryAccountPayableOther.LegalNameContract,
		|	OpeningEntryAccountPayableOther.Agreement AS Agreement,
		|	OpeningEntryAccountPayableOther.Currency,
		|	OpeningEntryAccountPayableOther.Amount AS Amount
		|INTO OtherVendorsTransactions
		|FROM
		|	Document.OpeningEntry.AccountPayableOther AS OpeningEntryAccountPayableOther
		|WHERE
		|	OpeningEntryAccountPayableOther.Ref = &Ref";
EndFunction

Function AdvancesFromCustomers()
	Return 
		"SELECT
		|	OpeningEntryAdvanceFromCustomers.Ref.Company AS Company,
		|	OpeningEntryAdvanceFromCustomers.Ref.Branch AS Branch,
		|	OpeningEntryAdvanceFromCustomers.Ref AS Basis,
		|	OpeningEntryAdvanceFromCustomers.Currency,
		|	OpeningEntryAdvanceFromCustomers.Partner,
		|	OpeningEntryAdvanceFromCustomers.LegalName,
		|	OpeningEntryAdvanceFromCustomers.LegalNameContract,
		|	case
		|		when OpeningEntryAdvanceFromCustomers.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			Then OpeningEntryAdvanceFromCustomers.Agreement
		|		else Undefined
		|	end AS Agreement,
		|	OpeningEntryAdvanceFromCustomers.Amount AS Amount,
		|	OpeningEntryAdvanceFromCustomers.Ref.Date AS Period,
		|	OpeningEntryAdvanceFromCustomers.Key,
		|	OpeningEntryAdvanceFromCustomers.Project
		|INTO AdvancesFromCustomers
		|FROM
		|	Document.OpeningEntry.AdvanceFromCustomers AS OpeningEntryAdvanceFromCustomers
		|WHERE
		|	OpeningEntryAdvanceFromCustomers.Ref = &Ref";
EndFunction

Function CustomersTransactions()
	Return "SELECT
		   |	OpeningEntryAccountReceivableByDocuments.Key,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Date AS Period,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Company,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Branch,
		   |	OpeningEntryAccountReceivableByDocuments.Ref AS Basis,
		   |	OpeningEntryAccountReceivableByDocuments.Partner,
		   |	OpeningEntryAccountReceivableByDocuments.LegalName,
		   |	OpeningEntryAccountReceivableByDocuments.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountReceivableByDocuments.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountReceivableByDocuments.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountReceivableByDocuments.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountReceivableByDocuments.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountReceivableByDocuments.Currency,
		   |	OpeningEntryAccountReceivableByDocuments.Amount AS Amount,
		   |	OpeningEntryAccountReceivableByDocuments.Project
		   |INTO CustomersTransactions
		   |FROM
		   |	Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		   |WHERE
		   |	OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	OpeningEntryAccountReceivableByAgreements.Key,
		   |	OpeningEntryAccountReceivableByAgreements.Ref.Date,
		   |	OpeningEntryAccountReceivableByAgreements.Ref.Company,
		   |	OpeningEntryAccountReceivableByAgreements.Ref.Branch,
		   |	UNDEFINED,
		   |	OpeningEntryAccountReceivableByAgreements.Partner,
		   |	OpeningEntryAccountReceivableByAgreements.LegalName,
		   |	OpeningEntryAccountReceivableByAgreements.LegalNameContract,
		   |	CASE
		   |		WHEN OpeningEntryAccountReceivableByAgreements.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		   |		AND
		   |			OpeningEntryAccountReceivableByAgreements.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		   |			THEN OpeningEntryAccountReceivableByAgreements.Agreement.StandardAgreement
		   |		ELSE OpeningEntryAccountReceivableByAgreements.Agreement
		   |	END AS Agreement,
		   |	OpeningEntryAccountReceivableByAgreements.Currency,
		   |	OpeningEntryAccountReceivableByAgreements.Amount AS Amount,
		   |	OpeningEntryAccountReceivableByAgreements.Project
		   |FROM
		   |	Document.OpeningEntry.AccountReceivableByAgreements AS OpeningEntryAccountReceivableByAgreements
		   |WHERE
		   |	OpeningEntryAccountReceivableByAgreements.Ref = &Ref";
EndFunction

Function OtherCustomersTransactions()
	Return 
		"SELECT
		|	OpeningEntryAccountReceivableOther.Key,
		|	OpeningEntryAccountReceivableOther.Ref.Date AS Period,
		|	OpeningEntryAccountReceivableOther.Ref.Company AS Company,
		|	OpeningEntryAccountReceivableOther.Ref.Branch AS Branch,
		|	OpeningEntryAccountReceivableOther.Partner,
		|	OpeningEntryAccountReceivableOther.LegalName,
		|	OpeningEntryAccountReceivableOther.LegalNameContract,
		|	OpeningEntryAccountReceivableOther.Agreement AS Agreement,
		|	OpeningEntryAccountReceivableOther.Currency,
		|	OpeningEntryAccountReceivableOther.Amount AS Amount
		|INTO OtherCustomersTransactions
		|FROM
		|	Document.OpeningEntry.AccountReceivableOther AS OpeningEntryAccountReceivableOther
		|WHERE
		|	OpeningEntryAccountReceivableOther.Ref = &Ref";
EndFunction

Function CustomersAging()
	Return "SELECT
		   |	OpeningEntryCustomersPaymentTerms.Ref.Date AS Period,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Company AS Company,
		   |	OpeningEntryAccountReceivableByDocuments.Ref.Branch AS Branch,
		   |	OpeningEntryAccountReceivableByDocuments.Partner AS Partner,
		   |	OpeningEntryAccountReceivableByDocuments.Agreement AS Agreement,
		   |	OpeningEntryAccountReceivableByDocuments.Ref AS Invoice,
		   |	OpeningEntryCustomersPaymentTerms.Date AS PaymentDate,
		   |	OpeningEntryAccountReceivableByDocuments.Currency AS Currency,
		   |	OpeningEntryCustomersPaymentTerms.Amount AS Amount
		   |INTO CustomersAging
		   |FROM
		   |	Document.OpeningEntry.CustomersPaymentTerms AS OpeningEntryCustomersPaymentTerms
		   |		LEFT JOIN Document.OpeningEntry.AccountReceivableByDocuments AS OpeningEntryAccountReceivableByDocuments
		   |		ON OpeningEntryCustomersPaymentTerms.Key = OpeningEntryAccountReceivableByDocuments.Key
		   |		AND OpeningEntryCustomersPaymentTerms.Ref = OpeningEntryAccountReceivableByDocuments.Ref
		   |		AND OpeningEntryAccountReceivableByDocuments.Ref = &Ref
		   |WHERE
		   |	OpeningEntryCustomersPaymentTerms.Ref = &Ref";
EndFunction

Function VendorsAging()
	Return "SELECT
		   |	OpeningEntryVendorsPaymentTerms.Ref.Date AS Period,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Company AS Company,
		   |	OpeningEntryAccountPayableByDocuments.Ref.Branch AS Branch,
		   |	OpeningEntryAccountPayableByDocuments.Partner AS Partner,
		   |	OpeningEntryAccountPayableByDocuments.Agreement AS Agreement,
		   |	OpeningEntryAccountPayableByDocuments.Ref AS Invoice,
		   |	OpeningEntryVendorsPaymentTerms.Date AS PaymentDate,
		   |	OpeningEntryAccountPayableByDocuments.Currency AS Currency,
		   |	OpeningEntryVendorsPaymentTerms.Amount AS Amount
		   |INTO VendorsAging
		   |FROM
		   |	Document.OpeningEntry.VendorsPaymentTerms AS OpeningEntryVendorsPaymentTerms
		   |		LEFT JOIN Document.OpeningEntry.AccountPayableByDocuments AS OpeningEntryAccountPayableByDocuments
		   |		ON OpeningEntryVendorsPaymentTerms.Key = OpeningEntryAccountPayableByDocuments.Key
		   |		AND OpeningEntryVendorsPaymentTerms.Ref = OpeningEntryAccountPayableByDocuments.Ref
		   |		AND OpeningEntryAccountPayableByDocuments.Ref = &Ref
		   |WHERE
		   |	OpeningEntryVendorsPaymentTerms.Ref = &Ref";
EndFunction

Function ShipmentToTradeAgent()
	Return "SELECT
		   |	ShipmentToTradeAgent.Ref AS Ref,
		   |	ShipmentToTradeAgent.Ref.Date AS Period,
		   |	ShipmentToTradeAgent.Ref.Company AS Company,
		   |	ShipmentToTradeAgent.Ref.Branch AS Branch,
		   |	ShipmentToTradeAgent.Ref.PartnerTradeAgent AS Partner,
		   |	ShipmentToTradeAgent.Ref.AgreementTradeAgent AS Agreement,
		   |	ShipmentToTradeAgent.Ref.LegalNameTradeAgent AS LegalName,
		   |	ShipmentToTradeAgent.Store,
		   |	ShipmentToTradeAgent.Ref AS Batch,
		   |	ShipmentToTradeAgent.SerialLotNumber,
		   |	ShipmentToTradeAgent.Ref.Company.TradeAgentStore AS StoreTradeAgent,
		   |	ShipmentToTradeAgent.Store,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	ShipmentToTradeAgent.Quantity,
		   |	CASE
		   |		WHEN ShipmentToTradeAgent.SerialLotNumber.Ref IS NULL
		   |			THEN FALSE
		   |		ELSE TRUE
		   |	END AS isSerialLotNumberSet,
		   |	ShipmentToTradeAgent.SourceOfOrigin
		   |INTO ShipmentToTradeAgent
		   |FROM
		   |	Document.OpeningEntry.ShipmentToTradeAgent AS ShipmentToTradeAgent
		   |WHERE
		   |	ShipmentToTradeAgent.Ref = &Ref";
EndFunction

Function ReceiptFromConsignor()
	Return "SELECT
		   |	ReceiptFromConsignor.Ref AS Ref,
		   |	ReceiptFromConsignor.Key AS Key,
		   |	ReceiptFromConsignor.Ref.Date AS Period,
		   |	ReceiptFromConsignor.Ref.Company AS Company,
		   |	ReceiptFromConsignor.Ref.Branch AS Branch,
		   |	ReceiptFromConsignor.Ref.PartnerConsignor AS Partner,
		   |	ReceiptFromConsignor.Ref.AgreementConsignor AS Agreement,
		   |	ReceiptFromConsignor.Ref.LegalNameConsignor AS LegalName,
		   |	ReceiptFromConsignor.Ref AS PurchaseInvoice,
		   |	ReceiptFromConsignor.Ref AS Batch,
		   |	ReceiptFromConsignor.Currency AS Currency,
		   |	ReceiptFromConsignor.SerialLotNumber AS SerialLotNumber,
		   |	ReceiptFromConsignor.Store AS Store,
		   |	ReceiptFromConsignor.ItemKey AS ItemKey,
		   |	ReceiptFromConsignor.Quantity AS Quantity,
		   |	ReceiptFromConsignor.Price AS Price,
		   |	CASE
		   |		WHEN ReceiptFromConsignor.SerialLotNumber.Ref IS NULL
		   |			THEN FALSE
		   |		ELSE TRUE
		   |	END AS isSerialLotNumberSet,
		   |	ReceiptFromConsignor.SourceOfOrigin
		   |INTO ReceiptFromConsignor
		   |FROM
		   |	Document.OpeningEntry.ReceiptFromConsignor AS ReceiptFromConsignor
		   |WHERE
		   |	ReceiptFromConsignor.Ref = &Ref";
EndFunction

Function EmployeeCashAdvance()
	Return "SELECT
		   |	EmployeeCashAdvance.Ref.Company AS Company,
		   |	EmployeeCashAdvance.Ref.Branch AS Branch,
		   |	EmployeeCashAdvance.Account,
		   |	EmployeeCashAdvance.Currency,
		   |	EmployeeCashAdvance.Employee AS Partner,
		   |	EmployeeCashAdvance.Amount AS Amount,
		   |	EmployeeCashAdvance.Ref.Date AS Period,
		   |	EmployeeCashAdvance.Key
		   |INTO EmployeeCashAdvance
		   |FROM
		   |	Document.OpeningEntry.EmployeeCashAdvance AS EmployeeCashAdvance
		   |WHERE
		   |	EmployeeCashAdvance.Ref = &Ref";
EndFunction

Function AdvanceFromRetailCustomers()
	Return "SELECT
		   |	AdvanceFromRetailCustomers.Ref.Company AS Company,
		   |	AdvanceFromRetailCustomers.Ref.Branch AS Branch,
		   |	AdvanceFromRetailCustomers.RetailCustomer,
		   |	AdvanceFromRetailCustomers.Amount AS Amount,
		   |	AdvanceFromRetailCustomers.Ref.Date AS Period
		   |INTO AdvanceFromRetailCustomers
		   |FROM
		   |	Document.OpeningEntry.AdvanceFromRetailCustomers AS AdvanceFromRetailCustomers
		   |WHERE
		   |	AdvanceFromRetailCustomers.Ref = &Ref";
EndFunction

Function SalaryPayment()
	Return "SELECT
		   |	SalaryPayment.Ref.Company AS Company,
		   |	SalaryPayment.Ref.Branch AS Branch,
		   |	SalaryPayment.Currency,
		   |	SalaryPayment.Employee,
		   |	SalaryPayment.PaymentPeriod,
		   |	SalaryPayment.Amount AS Amount,
		   |	SalaryPayment.Ref.Date AS Period,
		   |	SalaryPayment.Key
		   |INTO SalaryPayment
		   |FROM
		   |	Document.OpeningEntry.SalaryPayment AS SalaryPayment
		   |WHERE
		   |	SalaryPayment.Ref = &Ref";
EndFunction

Function CashInTransitDoc()
	Return
		"SELECT
		|	CashInTransitDoc.Key,
		|	CashInTransitDoc.Ref.Date AS Period,
		|	CashInTransitDoc.Ref.Company AS Company,
		|	CashInTransitDoc.ReceiptingBranch AS Branch,
		|	CashInTransitDoc.ReceiptingAccount,
		|	CashInTransitDoc.Currency,
		|	CashInTransitDoc.Amount
		|INTO CashInTransitDoc
		|FROM
		|	Document.OpeningEntry.CashInTransit AS CashInTransitDoc
		|WHERE
		|	CashInTransitDoc.Ref = &Ref";
EndFunction

Function FixedAssets()
	Return
		"SELECT
		|	OpeningEntryFixedAssets.Ref.Date AS Period,
		|	OpeningEntryFixedAssets.Ref.Company,
		|	OpeningEntryFixedAssets.FixedAsset,
		|	OpeningEntryFixedAssets.ResponsiblePerson,
		|	OpeningEntryFixedAssets.Ref.Branch AS Branch,
		|	OpeningEntryFixedAssets.ProfitLossCenter AS ProfitLossCenter,
		|	OpeningEntryFixedAssets.LedgerType,
		|	OpeningEntryFixedAssets.CommissioningDate,
		|	OpeningEntryFixedAssets.OriginalAmount,
		|	OpeningEntryFixedAssets.BalanceAmount,
		|	OpeningEntryFixedAssets.Currency,
		|	OpeningEntryFixedAssets.Key
		|INTO FixedAssets
		|FROM
		|	Document.OpeningEntry.FixedAssets AS OpeningEntryFixedAssets
		|WHERE
		|	OpeningEntryFixedAssets.Ref = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function CashInTransit()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	OpeningEntryCashInTransit.Ref.Date AS Period,
		|	OpeningEntryCashInTransit.Ref.Company,
		|	OpeningEntryCashInTransit.Account AS FromAccount,
		|	OpeningEntryCashInTransit.ReceiptingAccount AS ToAccount,
		|	OpeningEntryCashInTransit.Currency,
		|	OpeningEntryCashInTransit.Amount,
		|	OpeningEntryCashInTransit.Key
		|INTO CashInTransit
		|FROM
		|	Document.OpeningEntry.CashInTransit AS OpeningEntryCashInTransit
		|WHERE
		|	OpeningEntryCashInTransit.Ref = &Ref";
EndFunction

Function R1020B_AdvancesToVendors()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	AdvancesToVendors.Period,
		   |	AdvancesToVendors.Company,
		   |	AdvancesToVendors.Branch,
		   |	AdvancesToVendors.Currency,
		   |	AdvancesToVendors.LegalName,
		   |	AdvancesToVendors.Partner,
		   |	UNDEFINED AS Order,
		   |	AdvancesToVendors.Agreement,
		   |	AdvancesToVendors.Project,
		   |	AdvancesToVendors.Amount,
		   |	AdvancesToVendors.Key
		   |INTO R1020B_AdvancesToVendors
		   |FROM
		   |	AdvancesToVendors AS AdvancesToVendors
		   |WHERE 
		   |	TRUE";
EndFunction

Function R1021B_VendorsTransactions()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	VendorsTransactions.Period,
		   |	VendorsTransactions.Company,
		   |	VendorsTransactions.Branch,
		   |	VendorsTransactions.Currency,
		   |	VendorsTransactions.LegalName,
		   |	VendorsTransactions.Partner,
		   |	VendorsTransactions.Agreement,
		   |	VendorsTransactions.Basis,
		   |	UNDEFINED AS Order,
		   |	VendorsTransactions.Project,
		   |	VendorsTransactions.Amount,
		   |	VendorsTransactions.Key
		   |INTO R1021B_VendorsTransactions
		   |FROM
		   |	VendorsTransactions AS VendorsTransactions
		   |WHERE 
		   |	TRUE";

EndFunction

Function R5012B_VendorsAging()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	VendorsAging.Period,
		   |	VendorsAging.Company,
		   |	VendorsAging.Branch,
		   |	VendorsAging.Currency,
		   |	VendorsAging.Agreement,
		   |	VendorsAging.Partner,
		   |	VendorsAging.Invoice,
		   |	VendorsAging.PaymentDate,
		   |	VendorsAging.Amount
		   |INTO R5012B_VendorsAging
		   |FROM
		   |	VendorsAging AS VendorsAging
		   |WHERE 
		   |	TRUE";

EndFunction

Function R2020B_AdvancesFromCustomers()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	AdvancesFromCustomers.Period,
		   |	AdvancesFromCustomers.Company,
		   |	AdvancesFromCustomers.Branch,
		   |	AdvancesFromCustomers.Currency,
		   |	AdvancesFromCustomers.LegalName,
		   |	AdvancesFromCustomers.Partner,
		   |	UNDEFINED AS Order,
		   |	AdvancesFromCustomers.Agreement,
		   |	AdvancesFromCustomers.Project,
		   |	AdvancesFromCustomers.Amount,
		   |	AdvancesFromCustomers.Key
		   |INTO R2020B_AdvancesFromCustomers
		   |FROM
		   |	AdvancesFromCustomers AS AdvancesFromCustomers
		   |WHERE 
		   |	TRUE";

EndFunction

Function R2021B_CustomersTransactions()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CustomersTransactions.Period,
		   |	CustomersTransactions.Company,
		   |	CustomersTransactions.Branch,
		   |	CustomersTransactions.Currency,
		   |	CustomersTransactions.LegalName,
		   |	CustomersTransactions.Partner,
		   |	CustomersTransactions.Agreement,
		   |	CustomersTransactions.Basis,
		   |	UNDEFINED AS Order,
		   |	CustomersTransactions.Project,
		   |	CustomersTransactions.Amount,
		   |	CustomersTransactions.Key
		   |INTO R2021B_CustomersTransactions
		   |FROM
		   |	CustomersTransactions AS CustomersTransactions
		   |WHERE 
		   |	TRUE";

EndFunction

Function R5011B_CustomersAging()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	CustomersAging.Period,
		   |	CustomersAging.Company,
		   |	CustomersAging.Branch,
		   |	CustomersAging.Currency,
		   |	CustomersAging.Agreement,
		   |	CustomersAging.Partner,
		   |	CustomersAging.Invoice,
		   |	CustomersAging.PaymentDate,
		   |	CustomersAging.Amount
		   |INTO R5011B_CustomersAging
		   |FROM
		   |	CustomersAging AS CustomersAging
		   |WHERE 
		   |	TRUE";

EndFunction

Function R4010B_ActualStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	CASE
		   |		WHEN ItemList.SerialLotNumber.StockBalanceDetail
		   |			THEN ItemList.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END SerialLotNumber,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Quantity
		   |INTO R4010B_ActualStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ShipmentToTradeAgent.Period,
		   |	CASE
		   |		WHEN ShipmentToTradeAgent.SerialLotNumber.StockBalanceDetail
		   |			THEN ShipmentToTradeAgent.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END SerialLotNumber,
		   |	ShipmentToTradeAgent.StoreTradeAgent,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	ShipmentToTradeAgent.Quantity
		   |FROM
		   |	ShipmentToTradeAgent
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ShipmentToTradeAgent.Period,
		   |	CASE
		   |		WHEN ShipmentToTradeAgent.SerialLotNumber.StockBalanceDetail
		   |			THEN ShipmentToTradeAgent.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END SerialLotNumber,
		   |	ShipmentToTradeAgent.Store,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	ShipmentToTradeAgent.Quantity
		   |FROM
		   |	ShipmentToTradeAgent
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ReceiptFromConsignor.Period,
		   |	CASE
		   |		WHEN ReceiptFromConsignor.SerialLotNumber.StockBalanceDetail
		   |			THEN ReceiptFromConsignor.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END SerialLotNumber,
		   |	ReceiptFromConsignor.Store,
		   |	ReceiptFromConsignor.ItemKey,
		   |	ReceiptFromConsignor.Quantity
		   |FROM
		   |	ReceiptFromConsignor
		   |WHERE
		   |	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.Quantity
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ShipmentToTradeAgent.Period,
		   |	ShipmentToTradeAgent.Store,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	ShipmentToTradeAgent.Quantity
		   |FROM
		   |	ShipmentToTradeAgent AS ShipmentToTradeAgent
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ReceiptFromConsignor.Period,
		   |	ReceiptFromConsignor.Store,
		   |	ReceiptFromConsignor.ItemKey,
		   |	ReceiptFromConsignor.Quantity
		   |FROM
		   |	ReceiptFromConsignor AS ReceiptFromConsignor
		   |WHERE
		   |	TRUE";
EndFunction

Function R4014B_SerialLotNumber()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.ItemKey,
		   |	ItemList.SerialLotNumber,
		   |	ItemList.Quantity
		   |INTO R4014B_SerialLotNumber
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.isSerialLotNumberSet
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ShipmentToTradeAgent.Period,
		   |	ShipmentToTradeAgent.Company,
		   |	ShipmentToTradeAgent.Branch,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	ShipmentToTradeAgent.SerialLotNumber,
		   |	ShipmentToTradeAgent.Quantity
		   |FROM
		   |	ShipmentToTradeAgent AS ShipmentToTradeAgent
		   |WHERE
		   |	ShipmentToTradeAgent.isSerialLotNumberSet
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ReceiptFromConsignor.Period,
		   |	ReceiptFromConsignor.Company,
		   |	ReceiptFromConsignor.Branch,
		   |	ReceiptFromConsignor.ItemKey,
		   |	ReceiptFromConsignor.SerialLotNumber,
		   |	ReceiptFromConsignor.Quantity
		   |FROM
		   |	ReceiptFromConsignor AS ReceiptFromConsignor
		   |WHERE
		   |	ReceiptFromConsignor.isSerialLotNumberSet";
EndFunction

Function R3010B_CashOnHand()
	Return "SELECT 
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	AccountBalance.Period,
		   |	AccountBalance.Company,
		   |	AccountBalance.Branch,
		   |	AccountBalance.Account,
		   |	AccountBalance.Currency,
		   |	AccountBalance.Amount,
		   |	AccountBalance.Key
		   |INTO R3010B_CashOnHand
		   |FROM
		   |	AccountBalance AS AccountBalance
		   |WHERE 
		   |	TRUE";
EndFunction

Function R3021B_CashInTransitIncoming()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CashInTransitDoc.Key,
		|	CashInTransitDoc.Period,
		|	CashInTransitDoc.Company,
		|	CashInTransitDoc.Branch,
		|	CashInTransitDoc.ReceiptingAccount AS Account,
		|	CashInTransitDoc.Currency,
		|	CashInTransitDoc.Amount
		|INTO R3021B_CashInTransitIncoming
		|FROM
		|	CashInTransitDoc AS CashInTransitDoc
		|WHERE
		|	TRUE";
EndFunction

Function R5015B_OtherPartnersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OtherVendorsTransactions.Key,
		|	OtherVendorsTransactions.Period,
		|	OtherVendorsTransactions.Company,
		|	OtherVendorsTransactions.Branch,
		|	OtherVendorsTransactions.Partner,
		|	OtherVendorsTransactions.LegalName,
		|	OtherVendorsTransactions.Agreement,
		|	OtherVendorsTransactions.Currency,
		|	OtherVendorsTransactions.Amount
		|INTO R5015B_OtherPartnersTransactions
		|FROM
		|	OtherVendorsTransactions AS OtherVendorsTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	OtherCustomersTransactions.Key,
		|	OtherCustomersTransactions.Period,
		|	OtherCustomersTransactions.Company,
		|	OtherCustomersTransactions.Branch,
		|	OtherCustomersTransactions.Partner,
		|	OtherCustomersTransactions.LegalName,
		|	OtherCustomersTransactions.Agreement,
		|	OtherCustomersTransactions.Currency,
		|	OtherCustomersTransactions.Amount
		|FROM
		|	OtherCustomersTransactions AS OtherCustomersTransactions";
EndFunction

Function R5010B_ReconciliationStatement()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	VendorsTransactions.Period,
		|	VendorsTransactions.Company,
		|	VendorsTransactions.Branch,
		|	VendorsTransactions.LegalName,
		|	VendorsTransactions.LegalNameContract,
		|	VendorsTransactions.Currency,
		|	VendorsTransactions.Amount
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	VendorsTransactions AS VendorsTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OtherVendorsTransactions.Period,
		|	OtherVendorsTransactions.Company,
		|	OtherVendorsTransactions.Branch,
		|	OtherVendorsTransactions.LegalName,
		|	OtherVendorsTransactions.LegalNameContract,
		|	OtherVendorsTransactions.Currency,
		|	OtherVendorsTransactions.Amount
		|FROM
		|	OtherVendorsTransactions AS OtherVendorsTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	AdvancesToVendors.Period,
		|	AdvancesToVendors.Company,
		|	AdvancesToVendors.Branch,
		|	AdvancesToVendors.LegalName,
		|	AdvancesToVendors.LegalNameContract,
		|	AdvancesToVendors.Currency,
		|	AdvancesToVendors.Amount
		|FROM
		|	AdvancesToVendors AS AdvancesToVendors
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CustomersTransactions.Period,
		|	CustomersTransactions.Company,
		|	CustomersTransactions.Branch,
		|	CustomersTransactions.LegalName,
		|	CustomersTransactions.LegalNameContract,
		|	CustomersTransactions.Currency,
		|	CustomersTransactions.Amount
		|FROM
		|	CustomersTransactions AS CustomersTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	OtherCustomersTransactions.Period,
		|	OtherCustomersTransactions.Company,
		|	OtherCustomersTransactions.Branch,
		|	OtherCustomersTransactions.LegalName,
		|	OtherCustomersTransactions.LegalNameContract,
		|	OtherCustomersTransactions.Currency,
		|	OtherCustomersTransactions.Amount
		|FROM
		|	OtherCustomersTransactions AS OtherCustomersTransactions
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	AdvancesFromCustomers.Period,
		|	AdvancesFromCustomers.Company,
		|	AdvancesFromCustomers.Branch,
		|	AdvancesFromCustomers.LegalName,
		|	AdvancesFromCustomers.LegalNameContract,
		|	AdvancesFromCustomers.Currency,
		|	AdvancesFromCustomers.Amount
		|FROM
		|	AdvancesFromCustomers AS AdvancesFromCustomers";
EndFunction

Function T2014S_AdvancesInfo()
	Return "SELECT
		   |	AdvancesToVendors.Period AS Date,
		   |	AdvancesToVendors.Key,
		   |	AdvancesToVendors.Company,
		   |	AdvancesToVendors.Branch,
		   |	AdvancesToVendors.Currency,
		   |	AdvancesToVendors.Agreement AS AdvanceAgreement,
		   |	AdvancesToVendors.Partner,
		   |	AdvancesToVendors.LegalName,
		   |	AdvancesToVendors.Project,
		   |	TRUE AS IsVendorAdvance,
		   |	FALSE AS IsCustomerAdvance,
		   |	AdvancesToVendors.Amount
		   |INTO T2014S_AdvancesInfo
		   |FROM
		   |	AdvancesToVendors AS AdvancesToVendors
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	AdvancesFromCustomers.Period,
		   |	AdvancesFromCustomers.Key,
		   |	AdvancesFromCustomers.Company,
		   |	AdvancesFromCustomers.Branch,
		   |	AdvancesFromCustomers.Currency,
		   |	AdvancesFromCustomers.Agreement,
		   |	AdvancesFromCustomers.Partner,
		   |	AdvancesFromCustomers.LegalName,
		   |	AdvancesFromCustomers.Project,
		   |	FALSE,
		   |	TRUE,
		   |	AdvancesFromCustomers.Amount
		   |FROM
		   |	AdvancesFromCustomers AS AdvancesFromCustomers
		   |WHERE
		   |	TRUE";
EndFunction

Function T2015S_TransactionsInfo()
	Return "SELECT
		   |	VendorsTransactions.Period AS Date,
		   |	VendorsTransactions.Key,
		   |	VendorsTransactions.Company,
		   |	VendorsTransactions.Branch,
		   |	VendorsTransactions.Currency,
		   |	VendorsTransactions.Partner,
		   |	VendorsTransactions.LegalName,
		   |	VendorsTransactions.Project,
		   |	VendorsTransactions.Agreement,
		   |	TRUE AS IsVendorTransaction,
		   |	FALSE AS IsCustomerTransaction,
		   |	VendorsTransactions.Basis AS TransactionBasis,
		   |	VendorsTransactions.Amount AS Amount,
		   |	TRUE AS IsDue
		   |INTO T2015S_TransactionsInfo
		   |FROM
		   |	VendorsTransactions AS VendorsTransactions
		   |WHERE
		   |	TRUE
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	CustomersTransactions.Period,
		   |	CustomersTransactions.Key,
		   |	CustomersTransactions.Company,
		   |	CustomersTransactions.Branch,
		   |	CustomersTransactions.Currency,
		   |	CustomersTransactions.Partner,
		   |	CustomersTransactions.LegalName,
		   |	CustomersTransactions.Project,
		   |	CustomersTransactions.Agreement,
		   |	FALSE,
		   |	TRUE,
		   |	CustomersTransactions.Basis,
		   |	CustomersTransactions.Amount AS Amount,
		   |	TRUE AS IsDue
		   |FROM
		   |	CustomersTransactions AS CustomersTransactions
		   |WHERE
		   |	TRUE";
EndFunction

Function T6010S_BatchesInfo()
	Return "SELECT
		   |	ItemList.Ref AS Document,
		   |	ItemList.Ref.Company AS Company,
		   |	ItemList.Ref.Date AS Period,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO tmp_T6010S_BatchesInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.Ref,
		   |	ItemList.Ref.Company,
		   |	ItemList.Ref.Date
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	ReceiptFromConsignor.Ref,
		   |	ReceiptFromConsignor.Company,
		   |	ReceiptFromConsignor.Period,
		   |	SUM(ReceiptFromConsignor.Quantity)
		   |FROM
		   |	ReceiptFromConsignor AS ReceiptFromConsignor
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ReceiptFromConsignor.Ref,
		   |	ReceiptFromConsignor.Company,
		   |	ReceiptFromConsignor.Period
		   |;
		   |
		   |////////////////////////////////////////////////////////////////////////////////
		   |SELECT
		   |	Table.Document,
		   |	Table.Company,
		   |	Table.Period
		   |INTO T6010S_BatchesInfo
		   |FROM
		   |	tmp_T6010S_BatchesInfo AS Table
		   |WHERE
		   |	Table.Quantity > 0";
EndFunction

Function T6020S_BatchKeysInfo()
	Return "SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
		|	ItemList.CurrencyMovementType,
		|	ItemList.Currency,
		|	CASE
		|		WHEN ItemList.SerialLotNumber.BatchBalanceDetail
		|			THEN ItemList.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	CASE
		|		WHEN ItemList.SourceOfOrigin.BatchBalanceDetail
		|			THEN ItemList.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END AS SourceOfOrigin,
		|	SUM(ItemList.Quantity) AS Quantity,
		|	SUM(ItemList.Amount) AS InvoiceAmount,
		|	SUM(ItemList.AmountTax) AS InvoiceTaxAmount
		|INTO tmp_T6020S_BatchKeysInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.CurrencyMovementType,
		|	ItemList.ItemKey,
		|	ItemList.Period,
		|	ItemList.Store,
		|	VALUE(Enum.BatchDirection.Receipt),
		|	CASE
		|		WHEN ItemList.SerialLotNumber.BatchBalanceDetail
		|			THEN ItemList.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	CASE
		|		WHEN ItemList.SourceOfOrigin.BatchBalanceDetail
		|			THEN ItemList.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END
		|
		|UNION ALL
		|
		|SELECT
		|	ShipmentToTradeAgent.Period,
		|	ShipmentToTradeAgent.Company,
		|	ShipmentToTradeAgent.Store,
		|	ShipmentToTradeAgent.ItemKey,
		|	VALUE(Enum.BatchDirection.Expense),
		|	Value(ChartOfCharacteristicTypes.CurrencyMovementType.EmptyRef),
		|	Value(Catalog.Currencies.EmptyRef),
		|	CASE
		|		WHEN ShipmentToTradeAgent.SerialLotNumber.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	CASE
		|		WHEN ShipmentToTradeAgent.SourceOfOrigin.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END AS SourceOfOrigin,
		|	SUM(ShipmentToTradeAgent.Quantity),
		|	0,
		|	0
		|FROM
		|	ShipmentToTradeAgent AS ShipmentToTradeAgent
		|WHERE
		|	TRUE
		|GROUP BY
		|	ShipmentToTradeAgent.Period,
		|	ShipmentToTradeAgent.Company,
		|	ShipmentToTradeAgent.Store,
		|	ShipmentToTradeAgent.ItemKey,
		|	VALUE(Enum.BatchDirection.Expense),
		|	Value(ChartOfCharacteristicTypes.CurrencyMovementType.EmptyRef),
		|	Value(Catalog.Currencies.EmptyRef),
		|	CASE
		|		WHEN ShipmentToTradeAgent.SerialLotNumber.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	CASE
		|		WHEN ShipmentToTradeAgent.SourceOfOrigin.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END
		|
		|UNION ALL
		|
		|SELECT
		|	ShipmentToTradeAgent.Period,
		|	ShipmentToTradeAgent.Company,
		|	ShipmentToTradeAgent.StoreTradeAgent,
		|	ShipmentToTradeAgent.ItemKey,
		|	VALUE(Enum.BatchDirection.Receipt),
		|	Value(ChartOfCharacteristicTypes.CurrencyMovementType.EmptyRef),
		|	Value(Catalog.Currencies.EmptyRef),
		|	CASE
		|		WHEN ShipmentToTradeAgent.SerialLotNumber.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	CASE
		|		WHEN ShipmentToTradeAgent.SourceOfOrigin.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END AS SourceOfOrigin,
		|	SUM(ShipmentToTradeAgent.Quantity),
		|	0,
		|	0
		|FROM
		|	ShipmentToTradeAgent AS ShipmentToTradeAgent
		|WHERE
		|	TRUE
		|GROUP BY
		|	ShipmentToTradeAgent.Period,
		|	ShipmentToTradeAgent.Company,
		|	ShipmentToTradeAgent.StoreTradeAgent,
		|	ShipmentToTradeAgent.ItemKey,
		|	VALUE(Enum.BatchDirection.Receipt),
		|	Value(ChartOfCharacteristicTypes.CurrencyMovementType.EmptyRef),
		|	Value(Catalog.Currencies.EmptyRef),
		|	CASE
		|		WHEN ShipmentToTradeAgent.SerialLotNumber.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	CASE
		|		WHEN ShipmentToTradeAgent.SourceOfOrigin.BatchBalanceDetail
		|			THEN ShipmentToTradeAgent.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END
		|
		|UNION ALL
		|
		|SELECT
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.Store,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Direction,
		|	BatchKeysInfo.CurrencyMovementType,
		|	BatchKeysInfo.Currency,
		|	BatchKeysInfo.SerialLotNumber,
		|	BatchKeysInfo.SourceOfOrigin,
		|	SUM(BatchKeysInfo.Quantity) AS Quantity,
		|	SUM(BatchKeysInfo.Amount) AS InvoiceAmount,
		|	SUM(BatchKeysInfo.AmountTax) AS InvoiceTaxAmount
		|FROM
		|	BatchKeysInfo AS BatchKeysInfo
		|WHERE
		|	TRUE
		|GROUP BY
		|	BatchKeysInfo.Period,
		|	BatchKeysInfo.Company,
		|	BatchKeysInfo.Store,
		|	BatchKeysInfo.ItemKey,
		|	BatchKeysInfo.Direction,
		|	BatchKeysInfo.CurrencyMovementType,
		|	BatchKeysInfo.Currency,
		|	BatchKeysInfo.SerialLotNumber,
		|	BatchKeysInfo.SourceOfOrigin
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Table.Period,
		|	Table.Company,
		|	Table.Store,
		|	Table.ItemKey,
		|	Table.Direction,
		|	Table.CurrencyMovementType,
		|	Table.Currency,
		|	Table.SerialLotNumber,
		|	Table.SourceOfOrigin,
		|	Table.Quantity,
		|	Table.InvoiceAmount,
		|	Table.InvoiceTaxAmount
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	tmp_T6020S_BatchKeysInfo AS Table
		|WHERE
		|	Table.Quantity > 0"

EndFunction

Function R4050B_StockInventory()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R4050B_StockInventory
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Store,
		   |	ItemList.ItemKey
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ShipmentToTradeAgent.Period,
		   |	ShipmentToTradeAgent.Company,
		   |	ShipmentToTradeAgent.StoreTradeAgent,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	SUM(ShipmentToTradeAgent.Quantity) AS Quantity
		   |FROM
		   |	ShipmentToTradeAgent AS ShipmentToTradeAgent
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ShipmentToTradeAgent.Period,
		   |	ShipmentToTradeAgent.Company,
		   |	ShipmentToTradeAgent.StoreTradeAgent,
		   |	ShipmentToTradeAgent.ItemKey
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	ShipmentToTradeAgent.Period,
		   |	ShipmentToTradeAgent.Company,
		   |	ShipmentToTradeAgent.Store,
		   |	ShipmentToTradeAgent.ItemKey,
		   |	SUM(ShipmentToTradeAgent.Quantity) AS Quantity
		   |FROM
		   |	ShipmentToTradeAgent AS ShipmentToTradeAgent
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Expense),
		   |	ShipmentToTradeAgent.Period,
		   |	ShipmentToTradeAgent.Company,
		   |	ShipmentToTradeAgent.Store,
		   |	ShipmentToTradeAgent.ItemKey";
EndFunction

Function R8015T_ConsignorPrices()
	Return "SELECT
		   |	ReceiptFromConsignor.Key,
		   |	ReceiptFromConsignor.Period,
		   |	ReceiptFromConsignor.Company,
		   |	ReceiptFromConsignor.Partner,
		   |	ReceiptFromConsignor.Agreement,
		   |	ReceiptFromConsignor.PurchaseInvoice,
		   |	ReceiptFromConsignor.ItemKey,
		   |	ReceiptFromConsignor.SerialLotNumber,
		   |	ReceiptFromConsignor.SourceOfOrigin,
		   |	ReceiptFromConsignor.Currency,
		   |	ReceiptFromConsignor.Price
		   |INTO R8015T_ConsignorPrices
		   |FROM ReceiptFromConsignor AS ReceiptFromConsignor
		   |WHERE 
		   |	TRUE";
EndFunction

Function R9010B_SourceOfOriginStock()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.SourceOfOrigin,
		   |	CASE
		   |		WHEN ItemList.SerialLotNumber.BatchBalanceDetail
		   |			THEN ItemList.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END AS SerialLotNumber,
		   |	SUM(ItemList.Quantity) AS Quantity
		   |INTO R9010B_SourceOfOriginStock
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.SourceOfOrigin.Ref IS NULL
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Store,
		   |	ItemList.ItemKey,
		   |	ItemList.SourceOfOrigin,
		   |	CASE
		   |		WHEN ItemList.SerialLotNumber.BatchBalanceDetail
		   |			THEN ItemList.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END
		   |
		   |UNION ALL
		   |
		   |SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ReceiptFromConsignor.Period,
		   |	ReceiptFromConsignor.Company,
		   |	ReceiptFromConsignor.Branch,
		   |	ReceiptFromConsignor.Store,
		   |	ReceiptFromConsignor.ItemKey,
		   |	ReceiptFromConsignor.SourceOfOrigin,
		   |	CASE
		   |		WHEN ReceiptFromConsignor.SerialLotNumber.BatchBalanceDetail
		   |			THEN ReceiptFromConsignor.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END AS SerialLotNumber,
		   |	SUM(ReceiptFromConsignor.Quantity) AS Quantity
		   |FROM
		   |	ReceiptFromConsignor AS ReceiptFromConsignor
		   |WHERE
		   |	NOT ReceiptFromConsignor.SourceOfOrigin.Ref IS NULL
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	ReceiptFromConsignor.Period,
		   |	ReceiptFromConsignor.Company,
		   |	ReceiptFromConsignor.Branch,
		   |	ReceiptFromConsignor.Store,
		   |	ReceiptFromConsignor.ItemKey,
		   |	ReceiptFromConsignor.SourceOfOrigin,
		   |	CASE
		   |		WHEN ReceiptFromConsignor.SerialLotNumber.BatchBalanceDetail
		   |			THEN ReceiptFromConsignor.SerialLotNumber
		   |		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		   |	END";
EndFunction

Function R3027B_EmployeeCashAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	EmployeeCashAdvance.Period,
		   |	EmployeeCashAdvance.Company,
		   |	EmployeeCashAdvance.Branch,
		   |	EmployeeCashAdvance.Currency,
		   |	EmployeeCashAdvance.Partner,
		   |	EmployeeCashAdvance.Amount,
		   |	EmployeeCashAdvance.Key
		   |INTO R3027B_EmployeeCashAdvance
		   |FROM
		   |	EmployeeCashAdvance AS EmployeeCashAdvance
		   |WHERE
		   |	TRUE";
EndFunction

Function R2023B_AdvancesFromRetailCustomers()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	AdvanceFromRetailCustomers.Period,
		   |	AdvanceFromRetailCustomers.Company,
		   |	AdvanceFromRetailCustomers.Branch,
		   |	AdvanceFromRetailCustomers.RetailCustomer,
		   |	AdvanceFromRetailCustomers.Amount
		   |INTO R2023B_AdvancesFromRetailCustomers
		   |FROM
		   |	AdvanceFromRetailCustomers AS AdvanceFromRetailCustomers
		   |WHERE
		   |	TRUE";
EndFunction

Function R9510B_SalaryPayment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	SalaryPayment.Period,
		   |	SalaryPayment.Company,
		   |	SalaryPayment.Branch,
		   |	SalaryPayment.Employee,
		   |	SalaryPayment.PaymentPeriod,
		   |	SalaryPayment.Currency,
		   |	SalaryPayment.Amount,
		   |	SalaryPayment.Key
		   |INTO R9510B_SalaryPayment
		   |FROM
		   |	SalaryPayment AS SalaryPayment
		   |WHERE
		   |	TRUE";
EndFunction

Function T8515S_FixedAssetsLocation()	
	Return
		"SELECT
		|	FixedAssets.CommissioningDate AS Period,
		|	FixedAssets.Company,
		|	FixedAssets.FixedAsset,
		|	FixedAssets.ResponsiblePerson,
		|	FixedAssets.Branch,
		|	FixedAssets.ProfitLossCenter,
		|	TRUE AS IsActive
		|INTO T8515S_FixedAssetsLocation
		|FROM
		|	FixedAssets AS FixedAssets
		|GROUP BY
		|	FixedAssets.CommissioningDate,
		|	FixedAssets.Company,
		|	FixedAssets.FixedAsset,
		|	FixedAssets.ProfitLossCenter,
		|	FixedAssets.ResponsiblePerson,
		|	FixedAssets.Branch";
EndFunction

Function R8515T_CostOfFixedAsset()
	Return
		"SELECT
		|	FixedAssets.Period,
		|	FixedAssets.Company,
		|	FixedAssets.FixedAsset,
		|	FixedAssets.LedgerType,
		|	FixedAssets.OriginalAmount AS Amount
		|INTO R8515T_CostOfFixedAsset
		|FROM
		|	FixedAssets AS FixedAssets";
EndFunction
	
Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	OpeningEntryFixedAssets.Ref.Date AS Period,
		|	OpeningEntryFixedAssets.Ref.Company,
		|	OpeningEntryFixedAssets.FixedAsset,
		|	OpeningEntryFixedAssets.ResponsiblePerson,
		|	OpeningEntryFixedAssets.Ref.Branch AS Branch,
		|	OpeningEntryFixedAssets.ProfitLossCenter AS ProfitLossCenter,
		|	OpeningEntryFixedAssets.LedgerType,
		|	OpeningEntryFixedAssets.CommissioningDate,
		|	OpeningEntryFixedAssets.OriginalAmount,
		|	OpeningEntryFixedAssets.BalanceAmount,
		|	OpeningEntryFixedAssets.Currency,
		|	OpeningEntryFixedAssets.Key
		|INTO tmp
		|FROM
		|	Document.OpeningEntry.FixedAssets AS OpeningEntryFixedAssets
		|WHERE
		|	OpeningEntryFixedAssets.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Branch,
		|	tmp.ProfitLossCenter,
		|	tmp.FixedAsset,
		|	tmp.LedgerType,
		|	tmp.Currency,
		|	tmp.Key,
		|	tmp.BalanceAmount AS Amount,
		|	FixedAssetsDepreciationInfo.Schedule AS Schedule
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	tmp AS tmp
		|		LEFT JOIN Catalog.FixedAssets.DepreciationInfo AS FixedAssetsDepreciationInfo
		|		ON FixedAssetsDepreciationInfo.Ref = tmp.FixedAsset
		|		AND FixedAssetsDepreciationInfo.LedgerType = tmp.LedgerType
		|WHERE
		|	FixedAssetsDepreciationInfo.LedgerType.CalculateDepreciation"
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Service

Procedure FormGetProcessing(FormType, Parameters, SelectedForm, AdditionalInfo, StandardProcessing)
	If FormType = "ListForm" And FOServer.isUseSimpleMode() Then
		Query = New Query;
		Query.Text =
		"SELECT TOP 1 ALLOWED
		|	OpeningEntry.Ref
		|FROM
		|	Document.OpeningEntry AS OpeningEntry";
		QueryResult = Query.Execute();
		QuerySelection = QueryResult.Select();
		If QuerySelection.Next() Then
			Parameters.Insert("Key", QuerySelection.Ref);
		EndIf;
		StandardProcessing = False;
		SelectedForm = Metadata.Documents.OpeningEntry.DefaultObjectForm;
	EndIf;
EndProcedure

#EndRegion