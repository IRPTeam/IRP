#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("RetailSales"        , PostingServer.CreateTable(AccReg.RetailSales));
	Tables.Insert("RetailCash"         , PostingServer.CreateTable(AccReg.RetailCash));
		
	QueryRetailSales = New Query();
	QueryRetailSales.Text = GetQueryText_RetailSalesReceipt_RetailSales();
	QueryRetailSales.SetParameter("Ref", Ref);
	QueryResultRetailSales = QueryRetailSales.Execute();
	QueryTableRetailSales = QueryResultRetailSales.Unload();
	
	QueryRetailCash = New Query();
	QueryRetailCash.Text = GetQueryText_RetailSalesReceipt_RetailCash();
	QueryRetailCash.SetParameter("Ref", Ref);
	QueryResultRetailCash = QueryRetailCash.Execute();
	QueryTableRetailCash = QueryResultRetailCash.Unload();
	
	Tables.RetailSales = QueryTableRetailSales;
	Tables.RetailCash = QueryTableRetailCash;
	
#Region NewRegistersPosting		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion	
	
	Return Tables;
EndFunction

Function GetQueryText_RetailSalesReceipt_RetailCash()
	Return 
	"SELECT
	|	RetailSalesReceiptPayments.Ref.Company,
	|	RetailSalesReceiptPayments.Ref.BusinessUnit,
	|	RetailSalesReceiptPayments.Ref.Currency,
	|	RetailSalesReceiptPayments.Account,
	|	SUM(RetailSalesReceiptPayments.Amount) AS Amount,
	|	RetailSalesReceiptPayments.Ref.Date AS Period,
	|	RetailSalesReceiptPayments.PaymentType,
	|	RetailSalesReceiptPayments.PaymentTerminal,
	|	RetailSalesReceiptPayments.BankTerm,
	|	RetailSalesReceiptPayments.Percent,
	|	SUM(RetailSalesReceiptPayments.Commission) AS Commission
	|FROM
	|	Document.RetailSalesReceipt.Payments AS RetailSalesReceiptPayments
	|WHERE
	|	RetailSalesReceiptPayments.Ref = &Ref
	|GROUP BY
	|	RetailSalesReceiptPayments.Ref.Company,
	|	RetailSalesReceiptPayments.Ref.BusinessUnit,
	|	RetailSalesReceiptPayments.Ref.Currency,
	|	RetailSalesReceiptPayments.Account,
	|	RetailSalesReceiptPayments.Ref.Date,
	|	RetailSalesReceiptPayments.PaymentType,
	|	RetailSalesReceiptPayments.PaymentTerminal,
	|	RetailSalesReceiptPayments.BankTerm,
	|	RetailSalesReceiptPayments.Percent";
EndFunction

Function GetQueryText_RetailSalesReceipt_RetailSales()
	Return 
	"SELECT
	|	RetailSalesReceiptItemList.Ref.Company AS Company,
	|	RetailSalesReceiptItemList.Ref.BusinessUnit AS BusinessUnit,
	|	RetailSalesReceiptItemList.ItemKey AS ItemKey,
	|	SUM(RetailSalesReceiptItemList.QuantityInBaseUnit) AS Quantity,
	|	SUM(ISNULL(RetailSalesReceiptSerialLotNumbers.Quantity, 0)) AS QuantityBySerialLtNumbers,
	|	RetailSalesReceiptItemList.Ref.Date AS Period,
	|	RetailSalesReceiptItemList.Ref AS RetailSalesReceipt,
	|	SUM(RetailSalesReceiptItemList.TotalAmount) AS Amount,
	|	SUM(RetailSalesReceiptItemList.NetAmount) AS NetAmount,
	|	SUM(RetailSalesReceiptItemList.OffersAmount) AS OffersAmount,
	|	RetailSalesReceiptItemList.Key AS RowKey,
	|	RetailSalesReceiptSerialLotNumbers.SerialLotNumber AS SerialLotNumber,
	|	RetailSalesReceiptItemList.Store
	|INTO tmp
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|		LEFT JOIN Document.RetailSalesReceipt.SerialLotNumbers AS RetailSalesReceiptSerialLotNumbers
	|		ON RetailSalesReceiptItemList.Key = RetailSalesReceiptSerialLotNumbers.Key
	|		AND RetailSalesReceiptItemList.Ref = RetailSalesReceiptSerialLotNumbers.Ref
	|		AND RetailSalesReceiptItemList.Ref = &Ref
	|		AND RetailSalesReceiptSerialLotNumbers.Ref = &Ref
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref
	|GROUP BY
	|	RetailSalesReceiptItemList.Ref.Company,
	|	RetailSalesReceiptItemList.Ref.BusinessUnit,
	|	RetailSalesReceiptItemList.ItemKey,
	|	RetailSalesReceiptItemList.Ref.Date,
	|	RetailSalesReceiptItemList.Ref,
	|	RetailSalesReceiptItemList.Key,
	|	RetailSalesReceiptSerialLotNumbers.SerialLotNumber,
	|	RetailSalesReceiptItemList.Store
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company AS Company,
	|	tmp.BusinessUnit AS BusinessUnit,
	|	tmp.ItemKey AS ItemKey,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers = 0
	|			THEN tmp.Quantity
	|		ELSE tmp.QuantityBySerialLtNumbers
	|	END AS Quantity,
	|	tmp.Period AS Period,
	|	tmp.RetailSalesReceipt AS RetailSalesReceipt,
	|	tmp.RowKey AS RowKey,
	|	tmp.SerialLotNumber AS SerialLotNumber,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.Amount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.Amount
	|	END AS Amount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.NetAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.NetAmount
	|	END AS NetAmount,
	|	CASE
	|		WHEN tmp.QuantityBySerialLtNumbers <> 0
	|			THEN CASE
	|				WHEN tmp.Quantity = 0
	|					THEN 0
	|				ELSE tmp.OffersAmount / tmp.Quantity * tmp.QuantityBySerialLtNumbers
	|			END
	|		ELSE tmp.OffersAmount
	|	END AS OffersAmount,
	|	tmp.Store
	|FROM
	|	tmp AS tmp";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegisterPosting
	Tables = Parameters.DocumentDataTables;	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// RetailSales
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RetailSales,
		New Structure("RecordSet", Parameters.DocumentDataTables.RetailSales));
		
	// RetailCash
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RetailCash,
		New Structure("RecordSet", Parameters.DocumentDataTables.RetailCash));

#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion	
	
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
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.RetailSalesReceipt.ItemList", AddInfo);
EndProcedure

#EndRegion

#Region PrintForm

Function GetPrintForm(Ref, PrintTemplate, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParamenters", GetAdditionalQueryParamenters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParamenters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(Payments());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());	
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());	
	QueryArray.Add(R3010B_CashOnHand());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
		"SELECT
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.QuantityInBaseUnit AS Quantity,
		|	ItemList.TotalAmount AS TotalAmount,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN ItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN ItemList.Ref.Agreement.StandardAgreement
		|		ELSE ItemList.Ref.Agreement
		|	END AS Agreement,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Date AS Period,
		|	ItemList.Ref AS RetailSalesReceipt,
		|	ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
		|	ItemList.BusinessUnit AS BusinessUnit,
		|	ItemList.RevenueType AS RevenueType,
		|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE
		|		WHEN ItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN ItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	ItemList.NetAmount AS NetAmount,
		|	ItemList.OffersAmount AS OffersAmount
		|INTO ItemList
		|FROM
		|	Document.RetailSalesReceipt.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref = &Ref";
EndFunction

Function Payments()
	Return
	"SELECT
	|	Payments.Ref.Date AS Period,
	|	Payments.Ref.Company AS Company,
	|	Payments.Account AS Account,
	|	Payments.Ref.Currency AS Currency,
	|	Payments.Amount AS Amount
	|INTO Payments
	|FROM
	|	Document.RetailSalesReceipt.Payments AS Payments
	|WHERE
	|	Payments.Ref = &Ref";
EndFunction

Function R3010B_CashOnHand()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R3010B_CashOnHand
		|FROM
		|	Payments AS Payments
		|WHERE
		|	TRUE";
EndFunction


Function R4011B_FreeStocks()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	*
	|INTO R4011B_FreeStocks
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	NOT ItemList.IsService";	
EndFunction

Function R4010B_ActualStocks()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	*
	|INTO R4010B_ActualStocks
	|FROM
	|	ItemList AS ItemList
	|WHERE
	|	NOT ItemList.IsService";	
EndFunction	

#EndRegion
