#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "DecommissioningOfFixedAssetPrint") = 0 Then
		Return DecommissioningOfFixedAssetPrint(Ref, Param);
	EndIf;
EndFunction

// Decommissioning of fixed asset print.
// 
// Parameters:
//  Ref - DocumentRef.DecommissioningOfFixedAsset
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Decommissioning of fixed asset print
Function DecommissioningOfFixedAssetPrint(Ref, Param)
		
	Template = GetTemplate("DecommissioningOfFixedAssetPrint");
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
	|	Document.DecommissioningOfFixedAsset AS DocumentHeader
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
	|	Document.DecommissioningOfFixedAsset.ItemList AS DocumentItemList
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
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	CurrenciesServer.ExcludePostingDataTable(Parameters, Metadata.InformationRegisters.T6020S_BatchKeysInfo);
	
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
		"Document.DecommissioningOfFixedAsset.ItemList");

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4014B_SerialLotNumber.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4014B_SerialLotNumber", Parameters), PostingServer.GetQueryTableByName(
		"Exists_R4014B_SerialLotNumber", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.DecommissioningOfFixedAsset.ItemList", AddInfo);
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
	StrParams.Insert("Ref"           , Ref);
	StrParams.Insert("Company"       , Ref.Company);
	StrParams.Insert("FixedAsset"    , Ref.FixedAsset);
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod" , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod" , Undefined);
	EndIf;
	StrParams.Insert("Period", Ref.Date);
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
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R8510B_BookValueOfFixedAsset());
	QueryArray.Add(T8515S_FixedAssetsLocation());
	Return QueryArray;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function ItemList()
	Return 
		"SELECT
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Branch AS Branch,
		|	ItemList.Ref.FixedAsset AS FixedAsset,
		|	ItemList.Ref AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.Amount,
		|	ItemList.AmountTax,
		|	ItemList.Key
		|INTO ItemList
		|FROM
		|	Document.DecommissioningOfFixedAsset.ItemList AS ItemList
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
		|	Document.DecommissioningOfFixedAsset.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.DecommissioningOfFixedAsset.ItemList AS ItemList
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
		|	Document.DecommissioningOfFixedAsset.SourceOfOrigins AS SourceOfOrigins
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
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS QueryTable
		|WHERE
		|	TRUE";

EndFunction

Function R4011B_FreeStocks()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
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
		|	VALUE(AccumulationRecordType.Expense),
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Store,
		|	ItemList.ItemKey";
EndFunction

Function T6010S_BatchesInfo()
	Return "SELECT
		   |	ItemList.Ref AS Document,
		   |	ItemList.Company,
		   |	ItemList.Period
		   |INTO T6010S_BatchesInfo
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	TRUE
		   |GROUP BY
		   |	ItemList.Ref,
		   |	ItemList.Company,
		   |	ItemList.Period";
EndFunction

Function T6020S_BatchKeysInfo()
	Return 
		"SELECT
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
		|INTO BatchKeysInfo_1
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.CurrencyMovementType,
		|	BatchKeysInfo_1.Currency,
		|	SUM(CASE
		|		WHEN ISNULL(SourceOfOrigins.Quantity, 0) <> 0
		|			THEN ISNULL(SourceOfOrigins.Quantity, 0)
		|		ELSE BatchKeysInfo_1.TotalQuantity
		|	END) AS Quantity,
		|	SUM(BatchKeysInfo_1.InvoiceAmount) AS InvoiceAmount,
		|	SUM(BatchKeysInfo_1.InvoiceTaxAmount) AS InvoiceTaxAmount,
		|	SUM(BatchKeysInfo_1.TotalQuantity) AS TotalQuantity,
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)) AS SourceOfOrigin,
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
		|INTO BatchKeysInfo_1_1
		|FROM
		|	BatchKeysInfo_1 AS BatchKeysInfo_1
		|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
		|		ON BatchKeysInfo_1.Key = SourceOfOrigins.Key
		|WHERE
		|	TRUE
		|GROUP BY
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.CurrencyMovementType,
		|	BatchKeysInfo_1.Currency,
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	ISNULL(SourceOfOrigins.SourceOfOrigin, VALUE(Catalog.SourceOfOrigins.EmptyRef)),
		|	ISNULL(SourceOfOrigins.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BatchKeysInfo_1.ItemKey,
		|	BatchKeysInfo_1.Store,
		|	BatchKeysInfo_1.Company,
		|	BatchKeysInfo_1.CurrencyMovementType,
		|	BatchKeysInfo_1.Currency,
		|	BatchKeysInfo_1.Quantity,
		|	CASE
		|		WHEN BatchKeysInfo_1.TotalQuantity <> 0
		|			THEN (BatchKeysInfo_1.InvoiceAmount / BatchKeysInfo_1.TotalQuantity) * BatchKeysInfo_1.Quantity
		|		ELSE 0
		|	END AS InvoiceAmount,
		|	CASE
		|		WHEN BatchKeysInfo_1.TotalQuantity <> 0
		|			THEN (BatchKeysInfo_1.InvoiceTaxAmount / BatchKeysInfo_1.TotalQuantity) * BatchKeysInfo_1.Quantity
		|		ELSE 0
		|	END AS InvoiceTaxAmount,
		|	BatchKeysInfo_1.Period,
		|	BatchKeysInfo_1.Direction,
		|	BatchKeysInfo_1.SourceOfOrigin,
		|	BatchKeysInfo_1.SerialLotNumber
		|INTO T6020S_BatchKeysInfo
		|FROM
		|	BatchKeysInfo_1_1 AS BatchKeysInfo_1
		|WHERE
		|	TRUE";
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
		|	&Period AS Period,
		|	R8510B_BookValueOfFixedAssetBalance.Company,
		|	R8510B_BookValueOfFixedAssetBalance.Branch,
		|	R8510B_BookValueOfFixedAssetBalance.ProfitLossCenter,
		|	R8510B_BookValueOfFixedAssetBalance.FixedAsset,
		|	R8510B_BookValueOfFixedAssetBalance.LedgerType,
		|	R8510B_BookValueOfFixedAssetBalance.Schedule,
		|	R8510B_BookValueOfFixedAssetBalance.Currency,
		|	-R8510B_BookValueOfFixedAssetBalance.AmountBalance AS Amount
		|INTO R8510B_BookValueOfFixedAsset
		|FROM
		|	AccumulationRegister.R8510B_BookValueOfFixedAsset.Balance(&BalancePeriod, FixedAsset = &FixedAsset
		|	AND CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)) AS
		|		R8510B_BookValueOfFixedAssetBalance";
EndFunction

Function T8515S_FixedAssetsLocation()
	Return
		"SELECT
		|	&Period AS Period,
		|	T8515S_FixedAssetsLocationSliceLast.Company,
		|	T8515S_FixedAssetsLocationSliceLast.FixedAsset,
		|	T8515S_FixedAssetsLocationSliceLast.ResponsiblePerson,
		|	T8515S_FixedAssetsLocationSliceLast.Branch,
		|	T8515S_FixedAssetsLocationSliceLast.ProfitLossCenter,
		|	FALSE AS IsActive
		|INTO T8515S_FixedAssetsLocation
		|FROM
		|	InformationRegister.T8515S_FixedAssetsLocation.SliceLast(&BalancePeriod, Company = &Company
		|	AND FixedAsset = &FixedAsset) AS T8515S_FixedAssetsLocationSliceLast
		|WHERE
		|	T8515S_FixedAssetsLocationSliceLast.IsActive";
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