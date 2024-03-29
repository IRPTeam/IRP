#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function Print(Ref, Param) Export
	If StrCompare(Param.NameTemplate, "SalesOrderPrint") = 0 Then
		Return SalesOrderPrint(Ref, Param);
	EndIf;
EndFunction

// Sales order print.
// 
// Parameters:
//  Ref - DocumentRef.SalesOrder
//  Param - See UniversalPrintServer.InitPrintParam
// 
// Returns:
//  SpreadsheetDocument - Sales order print
Function SalesOrderPrint(Ref, Param)

	Template = GetTemplate("SalesOrderPrint");
	Template.LanguageCode = Param.LayoutLang;
	Query = New Query;
	Text =
	"SELECT
	|	DocumentHeader.Number AS Number,
	|	DocumentHeader.Date AS Date,
	|	DocumentHeader.Company.Description_en AS Company,
	|	DocumentHeader.Partner.Description_en AS Partner,
	|	DocumentHeader.Author AS Author,
	|	DocumentHeader.Ref AS Ref,
	|	DocumentHeader.Currency.Code AS Currency
	|FROM
	|	Document.SalesOrder AS DocumentHeader
	|WHERE
	|	DocumentHeader.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesOrderItemList.ItemKey.Item.Description_en AS Item,
	|	SalesOrderItemList.ItemKey.Description_en AS ItemKey,
	|	SalesOrderItemList.Quantity AS Quantity,
	|	SalesOrderItemList.Unit.Description_en AS Unit,
	|	SalesOrderItemList.Price AS Price,
	|	SalesOrderItemList.VatRate AS VatRate,
	|	SalesOrderItemList.TaxAmount AS TaxAmount,
	|	SalesOrderItemList.TotalAmount AS TotalAmount,
	|	SalesOrderItemList.NetAmount AS NetAmount,
	|	SalesOrderItemList.OffersAmount AS OffersAmount,
	|	SalesOrderItemList.Ref AS Ref,
	|	SalesOrderItemList.Key AS Key
	|INTO Items
	|FROM
	|	Document.SalesOrder.ItemList AS SalesOrderItemList
	|WHERE
	|	SalesOrderItemList.Ref = &Ref
	|	AND NOT SalesOrderItemList.Cancel
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Items.Item AS Item,
	|	Items.ItemKey AS ItemKey,
	|	Items.Quantity AS Quantity,
	|	Items.Unit AS Unit,
	|	Items.Price AS Price,
	|	Items.VatRate AS VatRate,
	|	Items.TaxAmount AS TaxAmount,
	|	Items.TotalAmount AS TotalAmount,
	|	Items.NetAmount AS NetAmount,
	|	Items.OffersAmount AS OffersAmount,
	|	Items.Ref AS Ref,
	|	Items.Key AS Key
	|FROM
	|	Items AS Items";

	LCode = Param.DataLang;
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "SalesOrder.Company", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "SalesOrder.Partner", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "SalesOrderItemList.ItemKey.Item", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "SalesOrderItemList.ItemKey", LCode);
	Text = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(Text, "SalesOrderItemList.Unit", LCode);
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
	AreaListHeaderTAX = Template.GetArea("ItemListHeaderTAX|ColumnTAX");
	AreaListTAX = Template.GetArea("ItemListTAX|ColumnTAX");

	Spreadsheet = New SpreadsheetDocument;
	Spreadsheet.LanguageCode = Param.LayoutLang;

	TaxVat = TaxesServer.GetVatRef();
	
	While SelectionHeader.Next() Do
		AreaCaption.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaCaption);

		AreaHeader.Parameters.Fill(SelectionHeader);
		Spreadsheet.Put(AreaHeader);

		Spreadsheet.Put(AreaItemListHeader);
		AreaListHeaderTAX.Parameters.NameTAX = LocalizationEvents.DescriptionRefLocalization(TaxVat, Spreadsheet.LanguageCode);
		Spreadsheet.Join(AreaListHeaderTAX);
		
		Choice	= New Structure("Ref", SelectionHeader.Ref);
		FindRow = SelectionItems.FindRows(Choice);

		Number = 0;
		TotalSum = 0;
		TotalTax = 0;
		TotalNet = 0;
		TotalOffers = 0;
		For Each It In FindRow Do
			Number = Number + 1;
			AreaItemList.Parameters.Fill(It);
			AreaItemList.Parameters.Number = Number;
			
			Spreadsheet.Put(AreaItemList);

			AreaListTAX.Parameters.PercentTax = It.VatRate;
			Spreadsheet.Join(AreaListTAX);
			
			TotalSum = TotalSum + It.TotalAmount;
			TotalTax = TotalTax + It.TaxAmount;
			TotalOffers	= TotalOffers + It.OffersAmount;
			TotalNet = TotalNet + It.NetAmount;
		EndDo;
	EndDo;

	AreaFooter.Parameters.Total = TotalSum;
	AreaFooter.Parameters.Currency = SelectionHeader.Currency;
	AreaFooter.Parameters.Total = TotalSum;
	AreaFooter.Parameters.TotalTax = TotalTax;
	AreaFooter.Parameters.TotalNet = TotalNet;
	AreaFooter.Parameters.TotalOffers = TotalOffers;
	AreaFooter.Parameters.Manager = SelectionHeader.Author;
	Spreadsheet.Put(AreaFooter);
	Spreadsheet = UniversalPrintServer.ResetLangSettings(Spreadsheet, Param.LayoutLang);
	Return Spreadsheet;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure;

	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
		Return Tables;
	EndIf;

	Parameters.IsReposting = False;

	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

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
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.SalesOrder.ItemList");

	If StatusInfo.Posting Then
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "BalancePeriod",
			New Boundary(New PointInTime(StatusInfo.Period, Ref), BoundaryType.Including));
	EndIf;

	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);

	If Not Cancel And Not AccReg.R4037B_PlannedReceiptReservationRequests.CheckBalance(Ref,
		LineNumberAndItemKeyFromItemList, PostingServer.GetQueryTableByName("R4037B_PlannedReceiptReservationRequests",
		Parameters), PostingServer.GetQueryTableByName("R4037B_PlannedReceiptReservationRequests_Exists", Parameters),
		AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesOrder.ItemList", AddInfo);
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
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(R4037B_PlannedReceiptReservationRequests_Exists());
	Return QueryArray;
EndFunction

Function ItemList()
	Return "SELECT
		   |	SalesOrderItemList.Ref.Company AS Company,
		   |	SalesOrderItemList.Store AS Store,
		   |	SalesOrderItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		   |	SalesOrderItemList.ItemKey AS ItemKey,
		   |	SalesOrderItemList.Ref AS Order,
		   |	SalesOrderItemList.Quantity AS UnitQuantity,
		   |	SalesOrderItemList.QuantityInBaseUnit AS Quantity,
		   |	SalesOrderItemList.Unit,
		   |	SalesOrderItemList.ItemKey.Item AS Item,
		   |	SalesOrderItemList.Ref.Date AS Period,
		   |	SalesOrderItemList.Key AS RowKey,
		   |	SalesOrderItemList.DeliveryDate AS DeliveryDate,
		   |	SalesOrderItemList.ProcurementMethod,
		   |	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Stock) AS IsProcurementMethod_Stock,
		   |	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.Purchase) AS IsProcurementMethod_Purchase,
		   |	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.IncomingReserve) AS
		   |		IsProcurementMethod_IncomingReserve,
		   |	SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.NoReserve)
		   |	OR SalesOrderItemList.ProcurementMethod = VALUE(Enum.ProcurementMethods.IncomingReserve) AS
		   |		IsProcurementMethod_NonReserve,
		   |	SalesOrderItemList.IsService AS IsService,
		   |	SalesOrderItemList.TotalAmount AS Amount,
		   |	SalesOrderItemList.Ref.Currency AS Currency,
		   |	SalesOrderItemList.Cancel AS IsCanceled,
		   |	SalesOrderItemList.CancelReason,
		   |	SalesOrderItemList.NetAmount,
		   |	SalesOrderItemList.Ref.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
		   |	SalesOrderItemList.OffersAmount,
		   |	&StatusInfoPosting AS StatusInfoPosting,
		   |	SalesOrderItemList.Ref.Branch AS Branch,
		   |	CASE
		   |		WHEN SalesOrderItemList.ReservationDate = DATETIME(1, 1, 1)
		   |			THEN SalesOrderItemList.Ref.Date
		   |		ELSE SalesOrderItemList.ReservationDate
		   |	END AS ReservationDate,
		   |	SalesOrderItemList.SalesPerson,
		   |	SalesOrderItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales) AS IsSales,
		   |	SalesOrderItemList.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.ShipmentToTradeAgent) AS IsShipmentToTradeAgent,
		   |	NOT SalesOrderItemList.Ref.ShipmentMode.Ref IS NULL AS IsRetailShipment
		   |INTO ItemList
		   |FROM
		   |	Document.SalesOrder.ItemList AS SalesOrderItemList
		   |WHERE
		   |	SalesOrderItemList.Ref = &Ref
		   |	AND &StatusInfoPosting";
EndFunction

Function R4037B_PlannedReceiptReservationRequests_Exists()
	Return "SELECT
		   |	*
		   |INTO R4037B_PlannedReceiptReservationRequests_Exists
		   |FROM
		   |	AccumulationRegister.R4037B_PlannedReceiptReservationRequests AS R4037B_PlannedReceiptReservationRequests
		   |WHERE
		   |	R4037B_PlannedReceiptReservationRequests.Recorder = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2010T_SalesOrders());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2014T_CanceledSalesOrders());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R3024B_SalesOrdersToBePaid());
	QueryArray.Add(R3026B_SalesOrdersCustomerAdvance());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R4037B_PlannedReceiptReservationRequests());
	QueryArray.Add(T3010S_RowIDInfo());
	Return QueryArray;
EndFunction

Function R2010T_SalesOrders()
	Return "SELECT
		   |	*
		   |INTO R2010T_SalesOrders
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled";
EndFunction

Function R2011B_SalesOrdersShipment()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R2011B_SalesOrdersShipment
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND (ItemList.IsSales OR ItemList.IsShipmentToTradeAgent OR ItemList.IsRetailShipment)";
EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R2012B_SalesOrdersInvoiceClosing
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled";
EndFunction

Function R2013T_SalesOrdersProcurement()
	Return "SELECT
		   |	ItemList.Period,
		   |	ItemList.Company,
		   |	ItemList.Branch,
		   |	ItemList.Order,
		   |	ItemList.ItemKey,
		   |	ItemList.RowKey,
		   |	ItemList.Quantity AS OrderedQuantity,
		   |	ItemList.NetAmount AS OrderedNetAmount,
		   |	ItemList.Amount AS OrderedTotalAmount
		   |INTO R2013T_SalesOrdersProcurement
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Purchase";
EndFunction

Function R2014T_CanceledSalesOrders()
	Return "SELECT
		   |	*
		   |INTO R2014T_CanceledSalesOrders
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.isCanceled";
EndFunction

Function R4011B_FreeStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	*
		   |INTO R4011B_FreeStocks
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Stock";
EndFunction

Function R4012B_StockReservation()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.ReservationDate AS Period,
		   |	*
		   |INTO R4012B_StockReservation
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND ItemList.IsProcurementMethod_Stock";
EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	ItemList.DeliveryDate AS Period,
		   |	ItemList.Order AS Basis,
		   |	*
		   |INTO R4034B_GoodsShipmentSchedule
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	NOT ItemList.isCanceled
		   |	AND NOT ItemList.IsService
		   |	AND NOT ItemList.DeliveryDate = DATETIME(1, 1, 1)
		   |	AND ItemList.UseItemsShipmentScheduling";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	SalesOrderPaymentTerms.Ref.Date AS Period,
		   |	SalesOrderPaymentTerms.Ref.Company AS Company,
		   |	SalesOrderPaymentTerms.Ref.Branch AS Branch,
		   |	SalesOrderPaymentTerms.Ref AS Basis,
		   |	SalesOrderPaymentTerms.Ref.LegalName AS LegalName,
		   |	SalesOrderPaymentTerms.Ref.Partner AS Partner,
		   |	SalesOrderPaymentTerms.Ref.Agreement AS Agreement,
		   |	SUM(SalesOrderPaymentTerms.Amount) AS Amount
		   |INTO R2022B_CustomersPaymentPlanning
		   |FROM
		   |	Document.SalesOrder.PaymentTerms AS SalesOrderPaymentTerms
		   |WHERE
		   |	SalesOrderPaymentTerms.Ref = &Ref
		   |	AND SalesOrderPaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
		   |	AND &StatusInfoPosting
		   |	AND SalesOrderPaymentTerms.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales)
		   |GROUP BY
		   |	SalesOrderPaymentTerms.Ref.Date,
		   |	SalesOrderPaymentTerms.Ref.Company,
		   |	SalesOrderPaymentTerms.Ref.Branch,
		   |	SalesOrderPaymentTerms.Ref,
		   |	SalesOrderPaymentTerms.Ref.LegalName,
		   |	SalesOrderPaymentTerms.Ref.Partner,
		   |	SalesOrderPaymentTerms.Ref.Agreement,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R4037B_PlannedReceiptReservationRequests()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4037B_PlannedReceiptReservationRequests
		   |FROM
		   |	ItemList AS ItemList
		   |WHERE
		   |	ItemList.IsProcurementMethod_IncomingReserve";
EndFunction

Function T3010S_RowIDInfo()
	Return "SELECT
		   |	RowIDInfo.RowRef AS RowRef,
		   |	RowIDInfo.BasisKey AS BasisKey,
		   |	RowIDInfo.RowID AS RowID,
		   |	RowIDInfo.Basis AS Basis,
		   |	ItemList.Key AS Key,
		   |	ItemList.Price AS Price,
		   |	ItemList.Ref.Currency AS Currency,
		   |	ItemList.Unit AS Unit
		   |INTO T3010S_RowIDInfo
		   |FROM
		   |	Document.SalesOrder.ItemList AS ItemList
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON RowIDInfo.Ref = &Ref
		   |		AND ItemList.Ref = &Ref
		   |		AND RowIDInfo.Key = ItemList.Key
		   |		AND RowIDInfo.Ref = ItemList.Ref";
EndFunction

Function R3024B_SalesOrdersToBePaid()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	PaymentTerms.Ref.Date AS Period,
		   |	PaymentTerms.Ref.Company,
		   |	PaymentTerms.Ref.Branch,
		   |	PaymentTerms.Ref.Currency,
		   |	PaymentTerms.Ref.Partner,
		   |	PaymentTerms.Ref.LegalName,
		   |	PaymentTerms.Ref AS Order,
		   |	SUM(PaymentTerms.Amount) AS Amount
		   |INTO R3024B_SalesOrdersToBePaid
		   |FROM
		   |	Document.SalesOrder.PaymentTerms AS PaymentTerms
		   |WHERE
		   |	PaymentTerms.Ref = &Ref
		   |	AND (PaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.Prepaid)
		   |	AND PaymentTerms.CanBePaid)
		   |	AND &StatusInfoPosting
		   |	AND PaymentTerms.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.Sales)
		   |GROUP BY
		   |	PaymentTerms.Ref,
		   |	PaymentTerms.Ref.Branch,
		   |	PaymentTerms.Ref.Company,
		   |	PaymentTerms.Ref.Currency,
		   |	PaymentTerms.Ref.Date,
		   |	PaymentTerms.Ref.LegalName,
		   |	PaymentTerms.Ref.Partner,
		   |	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R3026B_SalesOrdersCustomerAdvance()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	Payments.Ref.Date AS Period,
		   |	Payments.Ref.Company AS Company,
		   |	Payments.Ref.Branch AS Branch,
		   |	Payments.Ref.Currency AS Currency,
		   |	Payments.PaymentType.Type AS PaymentTypeEnum,
		   |	Payments.Account AS Account,
		   |	Payments.Ref.RetailCustomer AS RetailCustomer,
		   |	Payments.Ref AS Order,
		   |	CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.PaymentType
		   |	ELSE UNDEFINED
		   |	END AS PaymentType,
		   |	
		   |	CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.PaymentTerminal
		   |	ELSE UNDEFINED
		   |	END AS PaymentTerminal,
		   |	
		   |	CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.BankTerm
		   |	ELSE UNDEFINED
		   |	END AS BankTerm,
		   |	
		   |	SUM(CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.Commission
		   |	ELSE 0
		   |	END) AS Commission,
		   |	
		   |	SUM(Payments.Amount) AS Amount
		   |INTO R3026B_SalesOrdersCustomerAdvance
		   |FROM
		   |	Document.SalesOrder.Payments AS Payments
		   |WHERE
		   |	Payments.Ref = &Ref
		   |	AND &StatusInfoPosting
		   |	AND Payments.Ref.TransactionType = VALUE(Enum.SalesTransactionTypes.RetailSales)
		   |GROUP BY
		   |	VALUE(AccumulationRecordType.Receipt),
		   |	Payments.Ref.Date,
		   |	Payments.Ref.Company,
		   |	Payments.Ref.Branch,
		   |	Payments.Ref.Currency,
		   |	Payments.PaymentType.Type,
		   |	Payments.Account,
		   |	Payments.Ref.RetailCustomer,
		   |	Payments.Ref,
		   |	CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.PaymentType
		   |	ELSE UNDEFINED
		   |	END,
		   |	
		   |	CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.PaymentTerminal
		   |	ELSE UNDEFINED
		   |	END,
		   |	
		   |	CASE WHEN Payments.PaymentType.Type = VALUE(Enum.PaymentTypes.Card) THEN
		   |	Payments.BankTerm
		   |	ELSE UNDEFINED
		   |	END
		   |	";
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
	StoreList = Obj.ItemList.Unload(, "Store");
	StoreList.GroupBy("Store");
	AccessKeyMap.Insert("Store", StoreList.UnloadColumn("Store"));
	Return AccessKeyMap;
EndFunction

#EndRegion