#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "ModernizationOfFixedAssetPrint") = 0 Then
		Return ModernizationOfFixedAssetPrint(Ref, Param);
	EndIf;
EndFunction

// Modernization of fixed print.
// 
// Parameters:
//  Ref - DocumentRef.ModernizationOfFixedAsset
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Modernization of fixed print
Function ModernizationOfFixedAssetPrint(Ref, Param)
		
	Template = GetTemplate("ModernizationOfFixedAssetPrint");
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
	|	Document.ModernizationOfFixedAsset AS DocumentHeader
	|WHERE
	|	DocumentHeader.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	DocumentItemList.ItemKey.Item.Description_en AS Item,
	|	DocumentItemList.ItemKey.Description_en AS ItemKey,
	|	DocumentItemList.Quantity AS Quantity,
	|	DocumentItemList.Unit.Description_en AS Unit,
	|	DocumentItemList.AmountTax AS TaxAmount,
	|	DocumentItemList.Amount AS TotalAmount,
	|	DocumentItemList.Amount AS NetAmount,
	|	DocumentItemList.Ref AS Ref,
	|	DocumentItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.ModernizationOfFixedAsset.ItemList AS DocumentItemList
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
	|	Items.TaxAmount AS TaxAmount,
	|	Items.TotalAmount AS TotalAmount,
	|	Items.NetAmount AS NetAmount,
	|	Items.Ref AS Ref,
	|	Items.Key AS Key
	|FROM
	|	Items AS Items";

	LCode = Param.DataLang;
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Company", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "DocumentHeader.Partner", LCode);
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
	Tables = New Structure;
	Parameters.IsReposting = False;

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.InformationRegisters.T6020S_BatchKeysInfo);
	
	AccountingServer.CreateAccountingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo);
	
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
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
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
		"Document.CommissioningOfFixedAsset.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.CommissioningOfFixedAsset.ItemList", AddInfo);
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
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(SourceOfOrigins());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4014B_SerialLotNumber());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R9010B_SourceOfOriginStock());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(R8515T_CostOfFixedAsset());
	QueryArray.Add(T1040T_AccountingAmounts());
	QueryArray.Add(T1050T_AccountingQuantities());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function ItemList()
	Return 
		"SELECT
		|	ItemList.Ref AS Ref,
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Company.LandedCostCurrencyMovementType.Currency AS Currency,
		|	ItemList.Ref.Branch AS Branch,
		|	ItemList.Ref.ProfitLossCenter AS ProfitLossCenter,
		|	ItemList.Ref.FixedAsset AS FixedAsset,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Key,
		|	ItemList.Amount,
		|	ItemList.AmountTax,
		|	ItemList.ModernizationType = VALUE(Enum.ModernizationTypes.Mount) AS IsMount
		|INTO ItemList
		|FROM
		|	Document.ModernizationOfFixedAsset.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function SerialLotNumbers()
	Return 
		"SELECT
		|	SerialLotNumbers.Ref.Date AS Period,
		|	SerialLotNumbers.Ref.Company AS Company,
		|	SerialLotNumbers.Ref.Branch AS Branch,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.SerialLotNumber.StockBalanceDetail AS StockBalanceDetail,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ModernizationType = VALUE(Enum.ModernizationTypes.Mount) AS IsMount
		|INTO SerialLotNumbers
		|FROM
		|	Document.ModernizationOfFixedAsset.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.ModernizationOfFixedAsset.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";
EndFunction

Function SourceOfOrigins()
	Return 
		"SELECT
		|	SourceOfOrigins.Key AS Key,
		|	CASE
		|		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
		|			THEN SourceOfOrigins.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	CASE
		|		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
		|			THEN SourceOfOrigins.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END AS SourceOfOrigin,
		|	SourceOfOrigins.SourceOfOrigin AS SourceOfOriginStock,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO SourceOfOrigins
		|FROM
		|	Document.ModernizationOfFixedAsset.SourceOfOrigins AS SourceOfOrigins
		|WHERE
		|	SourceOfOrigins.Ref = &Ref
		|GROUP BY
		|	SourceOfOrigins.Key,
		|	CASE
		|		WHEN SourceOfOrigins.SerialLotNumber.BatchBalanceDetail
		|			THEN SourceOfOrigins.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	CASE
		|		WHEN SourceOfOrigins.SourceOfOrigin.BatchBalanceDetail
		|			THEN SourceOfOrigins.SourceOfOrigin
		|		ELSE VALUE(Catalog.SourceOfOrigins.EmptyRef)
		|	END,
		|	SourceOfOrigins.SourceOfOrigin";
EndFunction

#EndRegion

#Region Posting_MainTables

Function R4014B_SerialLotNumber()
	Return 
		"SELECT
		|	CASE
		|		WHEN SerialLotNumbers.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return 
		"SELECT
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	*
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R4010B_ActualStocks()
	Return 
		"SELECT
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END AS SerialLotNumber,
		|	SUM(CASE
		|		WHEN SerialLotNumbers.SerialLotNumber IS NULL
		|			THEN ItemList.Quantity
		|		ELSE SerialLotNumbers.Quantity
		|	END) AS Quantity
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
		|		ON ItemList.Key = SerialLotNumbers.Key
		|WHERE
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN SerialLotNumbers.StockBalanceDetail
		|			THEN SerialLotNumbers.SerialLotNumber
		|		ELSE VALUE(Catalog.SerialLotNumbers.EmptyRef)
		|	END,
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END";
EndFunction

Function R4050B_StockInventory()
	Return 
		"SELECT
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
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
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END";
EndFunction

Function T6010S_BatchesInfo()
	Return 
		"SELECT
		|	ItemList.Ref AS Document,
		|	ItemList.Company,
		|	ItemList.Period
		|INTO T6010S_BatchesInfo
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsMount
		|GROUP BY
		|	ItemList.Ref,
		|	ItemList.Company,
		|	ItemList.Period";
EndFunction

Function T6020S_BatchKeysInfo()
	Return 
		"SELECT
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Expense) AS Direction,
		|	ItemList.Company,
		|	ItemList.FixedAsset,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.Branch,
		|	ItemList.ProfitLossCenter,
		|	ItemList.Key,
		|	ItemList.Quantity AS Quantity
		|INTO BatchKeysInfo_1
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.IsMount
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.FixedAsset,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Branch,
		|	BatchKeysInfo_1.ProfitLossCenter,
		|	SUM(CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_1.Quantity
		|	END) AS Quantity,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO BatchKeysInfo_Expense
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		|GROUP BY
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.FixedAsset,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Branch,
		|	BatchKeysInfo_1.ProfitLossCenter,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ItemList.Key,
		|	ItemList.ItemKey,
		|	ItemList.Store,
		|	ItemList.Company,
		|	ItemList.Company.LandedCostCurrencyMovementType AS CurrencyMovementType,
		|	ItemList.Company.LandedCostCurrencyMovementType.Currency AS Currency,
		|	ItemList.Quantity AS TotalQuantity,
		|	ItemList.Amount AS InvoiceAmount,
		|	ItemList.AmountTax AS InvoiceTaxAmount,
		|	ItemList.Period,
		|	VALUE(Enum.BatchDirection.Receipt) AS Direction
		|INTO BatchKeysInfo_2
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsMount
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_2.ItemKey,
		|	BatchKeysInfo_2.Store,
		|	BatchKeysInfo_2.Company,
		|	BatchKeysInfo_2.CurrencyMovementType,
		|	BatchKeysInfo_2.Currency,
		|	SUM(CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_2.TotalQuantity
		|	END) AS Quantity,
		|	SUM(BatchKeysInfo_2.InvoiceAmount) AS InvoiceAmount,
		|	SUM(BatchKeysInfo_2.InvoiceTaxAmount) AS InvoiceTaxAmount,
		|	SUM(BatchKeysInfo_2.TotalQuantity) AS TotalQuantity,
		|	BatchKeysInfo_2.Period,
		|	BatchKeysInfo_2.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO BatchKeysInfo_2_1
		|FROM
		|	BatchKeysInfo_2 AS BatchKeysInfo_2
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_2.Key = SourceOfOrigins.Key
		|WHERE
		|	TRUE
		|GROUP BY
		|	BatchKeysInfo_2.ItemKey,
		|	BatchKeysInfo_2.Store,
		|	BatchKeysInfo_2.Company,
		|	BatchKeysInfo_2.CurrencyMovementType,
		|	BatchKeysInfo_2.Currency,
		|	BatchKeysInfo_2.Period,
		|	BatchKeysInfo_2.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_2_1.ItemKey,
		|	BatchKeysInfo_2_1.Store,
		|	BatchKeysInfo_2_1.Company,
		|	BatchKeysInfo_2_1.CurrencyMovementType,
		|	BatchKeysInfo_2_1.Currency,
		|	BatchKeysInfo_2_1.Quantity,
		|	CASE
		|		WHEN BatchKeysInfo_2_1.TotalQuantity <> 0
		|			THEN (BatchKeysInfo_2_1.InvoiceAmount / BatchKeysInfo_2_1.TotalQuantity) * BatchKeysInfo_2_1.Quantity
		|		ELSE 0
		|	END AS InvoiceAmount,
		|	CASE
		|		WHEN BatchKeysInfo_2_1.TotalQuantity <> 0
		|			THEN (BatchKeysInfo_2_1.InvoiceTaxAmount / BatchKeysInfo_2_1.TotalQuantity) * BatchKeysInfo_2_1.Quantity
		|		ELSE 0
		|	END AS InvoiceTaxAmount,
		|	BatchKeysInfo_2_1.Period,
		|	BatchKeysInfo_2_1.Direction,
		|	BatchKeysInfo_2_1.SourceOfOrigin,
		|	BatchKeysInfo_2_1.SerialLotNumber
		|INTO BatchKeysInfo_Receipt
		|FROM
		|	BatchKeysInfo_2_1 AS BatchKeysInfo_2_1
		|WHERE
		|	TRUE
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_Expense.Period,
		|	BatchKeysInfo_Expense.Direction,
		|	BatchKeysInfo_Expense.Company,
		|	BatchKeysInfo_Expense.FixedAsset,
		|	BatchKeysInfo_Expense.Store,
		|	BatchKeysInfo_Expense.ItemKey,
		|	BatchKeysInfo_Expense.Branch,
		|	BatchKeysInfo_Expense.ProfitLossCenter,
		|	BatchKeysInfo_Expense.Quantity,
		|	BatchKeysInfo_Expense.SourceOfOrigin,
		|	BatchKeysInfo_Expense.SerialLotNumber,
		|	NULL AS CurrencyMovementType,
		|	NULL AS Currency,
		|	NULL AS InvoiceAmount,
		|	NULL AS InvoiceTaxAmount
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo_Expense AS BatchKeysInfo_Expense
		|
		|UNION ALL
		|
		|SELECT
		|	BatchKeysInfo_Receipt.Period,
		|	BatchKeysInfo_Receipt.Direction,
		|	BatchKeysInfo_Receipt.Company,
		|	NULL,
		|	BatchKeysInfo_Receipt.Store,
		|	BatchKeysInfo_Receipt.ItemKey,
		|	NULL,
		|	NULL,
		|	BatchKeysInfo_Receipt.Quantity,
		|	BatchKeysInfo_Receipt.SourceOfOrigin,
		|	BatchKeysInfo_Receipt.SerialLotNumber,
		|	BatchKeysInfo_Receipt.CurrencyMovementType,
		|	BatchKeysInfo_Receipt.Currency,
		|	BatchKeysInfo_Receipt.InvoiceAmount,
		|	BatchKeysInfo_Receipt.InvoiceTaxAmount
		|FROM
		|	BatchKeysInfo_Receipt AS BatchKeysInfo_Receipt";
EndFunction

Function R9010B_SourceOfOriginStock()
	Return 
		"SELECT
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	SourceOfOrigins.SourceOfOriginStock AS SourceOfOrigin,
		|	SourceOfOrigins.SerialLotNumber,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO R9010B_SourceOfOriginStock
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON ItemList.Key = SourceOfOrigins.Key
		|		AND NOT SourceOfOrigins.SourceOfOriginStock.Ref IS NULL
		|WHERE
		|	TRUE
		|GROUP BY
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	SourceOfOrigins.SourceOfOriginStock,
		|	SourceOfOrigins.SerialLotNumber,
		|	CASE
		|		WHEN ItemList.IsMount
		|			THEN VALUE(AccumulationRecordType.Expense)
		|		ELSE VALUE(AccumulationRecordType.Receipt)
		|	END";
EndFunction

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	T8510S_FixedAssetsInfo.Period AS Period,
		|	T8510S_FixedAssetsInfo.Company AS Company,
		|	T8510S_FixedAssetsInfo.Branch AS Branch,
		|	T8510S_FixedAssetsInfo.ProfitLossCenter AS ProfitLossCenter,
		|	T8510S_FixedAssetsInfo.FixedAsset AS FixedAsset,
		|	T8510S_FixedAssetsInfo.LedgerType AS LedgerType,
		|	T8510S_FixedAssetsInfo.Schedule AS Schedule,
		|	T8510S_FixedAssetsInfo.Currency AS Currency,
		|	T8510S_FixedAssetsInfo.Amount AS Amount,
		|	T8510S_FixedAssetsInfo.Recorder AS CalculationMovementCost
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	InformationRegister.T8510S_FixedAssetsInfo AS T8510S_FixedAssetsInfo
		|WHERE
		|	T8510S_FixedAssetsInfo.Document = &Ref
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.ProfitLossCenter,
		|	ItemList.FixedAsset,
		|	FixedAssetsDepreciationInfo.LedgerType,
		|	FixedAssetsDepreciationInfo.Schedule,
		|	ItemList.Company.LandedCostCurrencyMovementType.Currency,
		|	ItemList.Amount AS Amount,
		|	NULL
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN Catalog.FixedAssets.DepreciationInfo AS FixedAssetsDepreciationInfo
		|		ON ItemList.FixedAsset = FixedAssetsDepreciationInfo.Ref
		|		AND FixedAssetsDepreciationInfo.LedgerType.CalculateDepreciation
		|WHERE
		|	NOT ItemList.IsMount";
EndFunction

Function R8515T_CostOfFixedAsset()
	Return
		"SELECT
		|	T8510S_FixedAssetsInfo.Period,
		|	T8510S_FixedAssetsInfo.Company,
		|	T8510S_FixedAssetsInfo.FixedAsset,
		|	T8510S_FixedAssetsInfo.LedgerType,
		|	T8510S_FixedAssetsInfo.Amount,
		|	T8510S_FixedAssetsInfo.Recorder AS CalculationMovementCost
		|INTO R8515T_CostOfFixedAsset
		|FROM
		|	InformationRegister.T8510S_FixedAssetsInfo AS T8510S_FixedAssetsInfo
		|WHERE
		|	T8510S_FixedAssetsInfo.Document = &Ref
		|
		|UNION ALL
		|
		|SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.FixedAsset,
		|	FixedAssetsDepreciationInfo.LedgerType,
		|	-ItemList.Amount AS Amount,
		|	NULL
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN Catalog.FixedAssets.DepreciationInfo AS FixedAssetsDepreciationInfo
		|		ON ItemList.FixedAsset = FixedAssetsDepreciationInfo.Ref
		|		AND FixedAssetsDepreciationInfo.LedgerType.CalculateDepreciation
		|WHERE
		|	NOT ItemList.IsMount";
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
	CopyTable = Obj.ItemList.Unload(, "Store");
	CopyTable.GroupBy("Store");
	AccessKeyMap.Insert("Store", CopyTable.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion

#Region Accounting

Function T1040T_AccountingAmounts()
	Return 
		"SELECT
		|	ItemList.Period,
		|	ItemList.Key AS RowKey,
		|	ItemList.Currency,
		|	ItemList.Amount AS Amount,
		|	VALUE(Catalog.AccountingOperations.ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset) AS Operation,
		|	UNDEFINED AS AdvancesClosing
		|INTO T1040T_AccountingAmounts
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	Not ItemList.IsMount";
EndFunction

Function T1050T_AccountingQuantities()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Key AS RowKey,
		   |	VALUE(Catalog.AccountingOperations.ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset) AS Operation,
		   |	ItemList.Quantity
		   |INTO T1050T_AccountingQuantities
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.IsMount";
EndFunction

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	// Unmount
	If Parameters.Operation = Operations.ModernizationOfFixedAsset_DR_R4050B_StockInventory_CR_R8510B_BookValueOfFixedAsset Then 
		
		Return GetAnalytics_StockInventory_BookValue(Parameters); // Stock inventory - Book value
	
	// Mount	
	ElsIf Parameters.Operation = Operations.ModernizationOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory Then 
		
		Return GetAnalytics_BookValue_StockInventory(Parameters); // Book value - Stock inventory
	
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

// Stock inventory - Book value
Function GetAnalytics_StockInventory_BookValue(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	AccountingAnalytics.Debit = Debit.Account;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Item", Parameters.RowData.ItemKey.Item);
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.ObjectData.FixedAsset);
	                                                    
	AccountingAnalytics.Credit = Credit.Account;
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics);

	Return AccountingAnalytics;
EndFunction

// Book value - Stock inventory
Function GetAnalytics_BookValue_StockInventory(Parameters)
	AccountingAnalytics = AccountingServer.GetAccountingAnalyticsResult(Parameters);
	AccountParameters   = AccountingServer.GetAccountParameters(Parameters);

	// Debit
	Debit = AccountingServer.GetT9015S_AccountsFixedAsset(AccountParameters, Parameters.ObjectData.FixedAsset);														  
	AccountingAnalytics.Debit = Debit.Account;
	
	AccountingServer.SetDebitExtDimensions(Parameters, AccountingAnalytics);
	
	// Credit
	Credit = AccountingServer.GetT9010S_AccountsItemKey(AccountParameters, Parameters.RowData.ItemKey);
	AccountingAnalytics.Credit = Credit.Account;
	
	AdditionalAnalytics = New Structure;
	AdditionalAnalytics.Insert("Item", Parameters.RowData.ItemKey.Item);
	AccountingServer.SetCreditExtDimensions(Parameters, AccountingAnalytics, AdditionalAnalytics);
	
	Return AccountingAnalytics;
EndFunction

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion
