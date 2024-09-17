#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "CommissioningOfFixedAssetPrint") = 0 Then
		Return CommissioningOfFixedAssetPrint(Ref, Param);
	EndIf;
EndFunction

// Commissioning of fixed asset print.
// 
// Parameters:
//  Ref - DocumentRef.CommissioningOfFixedAsset
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Commissioning of fixed asset print
Function CommissioningOfFixedAssetPrint(Ref, Param)
		
	Template = GetTemplate("CommissioningOfFixedAssetPrint");
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
	|	Document.CommissioningOfFixedAsset AS DocumentHeader
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
	|	DocumentItemList.Ref AS Ref,
	|	DocumentItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.CommissioningOfFixedAsset.ItemList AS DocumentItemList
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
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);
			AreaItemList.Parameters.Number = Number;
			Spreadsheet.Put(AreaItemList);			
		EndDo;
	EndDo;

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

	CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Expense, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_CheckStockBalance(Ref, Cancel, Parameters, AddInfo = Undefined) Export
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
	QueryArray.Add(PostingServer.Exists_R4050B_StockInventory());
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
	QueryArray.Add(T8515S_FixedAssetsLocation());
	QueryArray.Add(R8515T_CostOfFixedAsset());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function ItemList()
	Return 
		"SELECT
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.ProfitLossCenter AS ProfitLossCenter,
		|	ItemList.Ref.Branch AS Branch,	
		|	ItemList.Ref.ResponsiblePerson AS ResponsiblePerson,
		|	ItemList.Ref.FixedAsset AS FixedAsset,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Key
		|INTO ItemList
		|FROM
		|	Document.CommissioningOfFixedAsset.ItemList AS ItemList
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
		|	ItemList.ItemKey AS ItemKey
		|INTO SerialLotNumbers
		|FROM
		|	Document.CommissioningOfFixedAsset.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.CommissioningOfFixedAsset.ItemList AS ItemList
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
		|	Document.CommissioningOfFixedAsset.SourceOfOrigins AS SourceOfOrigins
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
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	SerialLotNumbers.Period,
		|	SerialLotNumbers.Company,
		|	SerialLotNumbers.Branch,
		|	SerialLotNumbers.ItemKey,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	TRUE";
EndFunction

Function R4011B_FreeStocks()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction

Function R4010B_ActualStocks()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
		|	END";
EndFunction

Function R4050B_StockInventory()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey";
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
		|	TRUE
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
		|INTO T6020S_BatchKeysInfo
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
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))";
EndFunction

Function R9010B_SourceOfOriginStock()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
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
		|	SourceOfOrigins.SerialLotNumber";
EndFunction

Function R8510B_BookValueOfFixedAsset()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	FixedAssetsInfo.Period,
		|	FixedAssetsInfo.Company,
		|	FixedAssetsInfo.Branch,
		|	FixedAssetsInfo.ProfitLossCenter,
		|	FixedAssetsInfo.FixedAsset,
		|	FixedAssetsInfo.LedgerType,
		|	FixedAssetsInfo.Schedule,
		|	FixedAssetsInfo.Currency,
		|	FixedAssetsInfo.Amount,
		|	FixedAssetsInfo.Recorder AS CalculationMovementCost
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	InformationRegister.T8510S_FixedAssetsInfo AS FixedAssetsInfo
		|WHERE
		|	FixedAssetsInfo.Document = &Ref";
EndFunction

Function R8515T_CostOfFixedAsset()
	Return
		"SELECT
		|	FixedAssetsInfo.Period,
		|	FixedAssetsInfo.Company,
		|	FixedAssetsInfo.FixedAsset,
		|	FixedAssetsInfo.LedgerType,
		|	FixedAssetsInfo.Amount,
		|	FixedAssetsInfo.Recorder AS CalculationMovementCost
		|INTO R8515T_CostOfFixedAsset
		|FROM
		|	InformationRegister.T8510S_FixedAssetsInfo AS FixedAssetsInfo
		|WHERE
		|	FixedAssetsInfo.Document = &Ref";
EndFunction

Function T8515S_FixedAssetsLocation()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.ProfitLossCenter,
		|	ItemList.ResponsiblePerson,
		|	ItemList.FixedAsset,
		|	TRUE AS IsActive
		|INTO T8515S_FixedAssetsLocation
		|FROM
		|	ItemLIst AS ItemLIst
		|WHERE
		|	TRUE
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Branch,
		|	ItemList.ProfitLossCenter,
		|	ItemList.ResponsiblePerson,
		|	ItemList.FixedAsset";
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

Function GetAccountingAnalytics(Parameters) Export
	Operations = Catalogs.AccountingOperations;
	If Parameters.Operation = Operations.CommissioningOfFixedAsset_DR_R8510B_BookValueOfFixedAsset_CR_R4050B_StockInventory Then
		Return GetAnalytics_BookValue_StockInventory(Parameters); // Book value - Stock inventory		
	EndIf;
	Return Undefined;
EndFunction

#Region Accounting_Analytics

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

Function GetHintDebitExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

Function GetHintCreditExtDimension(Parameters, ExtDimensionType, Value, AdditionalAnalytics, Number) Export
	Return Value;
EndFunction

#EndRegion

#EndRegion
