#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();	
#Region NewRegistersPosting	
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParamenters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Tables.Insert("CustomersTransactions", 
	PostingServer.GetQueryTableByName("CustomersTransactions", Parameters));	
#EndRegion	
		
	Return Tables;
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
#Region NewRegisterPosting
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
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	
	If Not Unposting And Ref.Agreement.UseCreditLimit Then
		OffsetOfPartnersServer.CheckCreditLimit(Ref, Cancel);
	EndIf;
	
	If Cancel Then
		Return;
	EndIf;
	
	Parameters.Insert("RecordType", AccumulationRecordType.Expense);
	PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.SalesInvoice.ItemList", AddInfo);
EndProcedure

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
	If ValueIsFilled(Ref) Then
		StrParams.Insert("BalancePeriod", New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	Else
		StrParams.Insert("BalancePeriod", Undefined);
	EndIf;
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(ItemList());
	QueryArray.Add(OffersInfo());
	QueryArray.Add(Taxes());
	QueryArray.Add(SerialLotNumbers());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R2001T_Sales());	
	QueryArray.Add(R2005T_SalesSpecialOffers());
	QueryArray.Add(R2011B_SalesOrdersShipment());
	QueryArray.Add(R2012B_SalesOrdersInvoiceClosing());
	QueryArray.Add(R2013T_SalesOrdersProcurement());
	QueryArray.Add(R2031B_ShipmentInvoicing());
	QueryArray.Add(R2040B_TaxesIncoming());
	QueryArray.Add(R4010B_ActualStocks());
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R4014B_SerialLotNumber());
	QueryArray.Add(R4032B_GoodsInTransitOutgoing());
	QueryArray.Add(R4034B_GoodsShipmentSchedule());
	QueryArray.Add(R4050B_StockInventory());
	QueryArray.Add(R2021B_CustomersTransactions());
	QueryArray.Add(R2020B_AdvancesFromCustomers());
	QueryArray.Add(R5011B_CustomersAging());
	QueryArray.Add(R5010B_ReconciliationStatement());
	QueryArray.Add(T2011S_PartnerTransactions());
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R5021T_Revenues());
	Return QueryArray;
EndFunction

Function ItemList()
	Return
	"SELECT
	|	RowIDInfo.Ref AS Ref,
	|	RowIDInfo.Key AS Key,
	|	MAX(RowIDInfo.RowID) AS RowID
	|INTO TableRowIDInfo
	|FROM
	|	Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref,
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ShipmentConfirmations.Key AS Key
	|INTO ShipmentConfirmations
	|FROM
	|	Document.SalesInvoice.ShipmentConfirmations AS ShipmentConfirmations
	|WHERE
	|	ShipmentConfirmations.Ref = &Ref
	|GROUP BY
	|	ShipmentConfirmations.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesInvoiceItemList.Ref.Company AS Company,
	|	SalesInvoiceItemList.Store AS Store,
	|	NOT ShipmentConfirmations.Key IS NULL AS ShipmentConfirmationExists,
	|	SalesInvoiceItemList.Ref AS Invoice,
	|	SalesInvoiceItemList.ItemKey AS ItemKey,
	|	SalesInvoiceItemList.Quantity AS UnitQuantity,
	|	SalesInvoiceItemList.QuantityInBaseUnit AS Quantity,
	|	SalesInvoiceItemList.TotalAmount AS Amount,
	|	SalesInvoiceItemList.Ref.Partner AS Partner,
	|	SalesInvoiceItemList.Ref.LegalName AS LegalName,
	|	CASE
	|		WHEN SalesInvoiceItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
	|		AND SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
	|			THEN SalesInvoiceItemList.Ref.Agreement.StandardAgreement
	|		ELSE SalesInvoiceItemList.Ref.Agreement
	|	END AS Agreement,
	|	SalesInvoiceItemList.Ref.Currency AS Currency,
	|	SalesInvoiceItemList.Unit AS Unit,
	|	SalesInvoiceItemList.Ref.Date AS Period,
	|	SalesInvoiceItemList.SalesOrder AS SalesOrder,
	|	NOT SalesInvoiceItemList.SalesOrder.Ref IS NULL AS SalesOrderExists,
	|	TableRowIDInfo.RowID AS RowKey,
	|	SalesInvoiceItemList.DeliveryDate AS DeliveryDate,
	|	SalesInvoiceItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	SalesInvoiceItemList.BusinessUnit AS BusinessUnit,
	|	SalesInvoiceItemList.RevenueType AS RevenueType,
	|	SalesInvoiceItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	CASE
	|		WHEN SalesInvoiceItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
	|			THEN SalesInvoiceItemList.Ref
	|		ELSE UNDEFINED
	|	END AS Basis,
	|	SalesInvoiceItemList.NetAmount AS NetAmount,
	|	SalesInvoiceItemList.OffersAmount AS OffersAmount,
	|	SalesInvoiceItemList.UseShipmentConfirmation AS UseShipmentConfirmation,
	|	SalesInvoiceItemList.Ref.IgnoreAdvances AS IgnoreAdvances,
	|	SalesInvoiceItemList.Key
	|INTO ItemList
	|FROM
	|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
	|		LEFT JOIN ShipmentConfirmations AS ShipmentConfirmations
	|		ON SalesInvoiceItemList.Key = ShipmentConfirmations.Key
	|		LEFT JOIN TableRowIDInfo AS TableRowIDInfo
	|		ON SalesInvoiceItemList.Key = TableRowIDInfo.Key
	|WHERE
	|	SalesInvoiceItemList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesInvoiceShipmentConfirmations.Key,
	|	SalesInvoiceShipmentConfirmations.ShipmentConfirmation,
	|	SalesInvoiceShipmentConfirmations.Quantity
	|INTO ShipmentConfirmationsInfo
	|FROM
	|	Document.SalesInvoice.ShipmentConfirmations AS SalesInvoiceShipmentConfirmations
	|WHERE
	|	SalesInvoiceShipmentConfirmations.Ref = &Ref
	|";
EndFunction

Function OffersInfo()
	Return
		"SELECT
		|	SalesInvoiceItemList.Ref.Date AS Period,
		|	SalesInvoiceItemList.Ref AS Invoice,
		|	TableRowIDInfo.RowID AS RowKey,
		|	SalesInvoiceItemList.ItemKey,
		|	SalesInvoiceItemList.Ref.Company AS Company,
		|	SalesInvoiceItemList.Ref.Currency,
		|	SalesInvoiceSpecialOffers.Offer AS SpecialOffer,
		|	SalesInvoiceSpecialOffers.Amount AS OffersAmount,
		|	SalesInvoiceItemList.TotalAmount AS SalesAmount,
		|	SalesInvoiceItemList.NetAmount
		|INTO OffersInfo
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		INNER JOIN Document.SalesInvoice.SpecialOffers AS SalesInvoiceSpecialOffers
		|		ON SalesInvoiceItemList.Key = SalesInvoiceSpecialOffers.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND SalesInvoiceSpecialOffers.Ref = &Ref
		|		INNER JOIN TableRowIDInfo AS TableRowIDInfo
		|		ON SalesInvoiceItemList.Key = TableRowIDInfo.Key";
EndFunction

Function Taxes()
	Return
		"SELECT
		|	SalesInvoiceTaxList.Ref.Date AS Period,
		|	SalesInvoiceTaxList.Ref.Company AS Company,
		|	SalesInvoiceTaxList.Tax AS Tax,
		|	SalesInvoiceTaxList.TaxRate AS TaxRate,
		|	CASE
		|		WHEN SalesInvoiceTaxList.ManualAmount = 0
		|			THEN SalesInvoiceTaxList.Amount
		|		ELSE SalesInvoiceTaxList.ManualAmount
		|	END AS TaxAmount,
		|	SalesInvoiceItemList.NetAmount AS TaxableAmount
		|INTO Taxes
		|FROM
		|	Document.SalesInvoice.ItemList AS SalesInvoiceItemList
		|		INNER JOIN Document.SalesInvoice.TaxList AS SalesInvoiceTaxList
		|		ON SalesInvoiceItemList.Key = SalesInvoiceTaxList.Key
		|		AND SalesInvoiceItemList.Ref = &Ref
		|		AND SalesInvoiceTaxList.Ref = &Ref";
EndFunction

Function SerialLotNumbers()
	Return
		"SELECT
		|	SerialLotNumbers.Ref.Date AS Period,
		|	SerialLotNumbers.Ref.Company AS Company,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity,
		|	ItemList.ItemKey AS ItemKey
		|INTO SerialLotNumbers
		|FROM
		|	Document.SalesInvoice.SerialLotNumbers AS SerialLotNumbers
		|		LEFT JOIN Document.SalesInvoice.ItemList AS ItemList
		|		ON SerialLotNumbers.Key = ItemList.Key
		|		AND ItemList.Ref = &Ref
		|WHERE
		|	SerialLotNumbers.Ref = &Ref";	
EndFunction	

Function R2001T_Sales()
	Return
		"SELECT *
		|INTO R2001T_Sales
		|FROM
		|	ItemList AS ItemList
		|WHERE TRUE";

EndFunction

Function R2005T_SalesSpecialOffers()
	Return
		"SELECT *
		|INTO R2005T_SalesSpecialOffers
		|FROM
		|	OffersInfo AS OffersInfo
		|WHERE TRUE";

EndFunction

Function R2011B_SalesOrdersShipment()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2011B_SalesOrdersShipment
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND ItemList.SalesOrderExists
		|	AND NOT ItemList.ShipmentConfirmationExists";

EndFunction

Function R2012B_SalesOrdersInvoiceClosing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2012B_SalesOrdersInvoiceClosing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.SalesOrderExists";

EndFunction

Function R2013T_SalesOrdersProcurement()
	Return
		"SELECT
		|	ItemList.Quantity AS SalesQuantity,
		|	ItemList.SalesOrder AS Order,
		|	*
		|INTO R2013T_SalesOrdersProcurement
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND ItemList.SalesOrderExists";

EndFunction

Function R2031B_ShipmentInvoicing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Invoice AS Basis,
		|	ItemList.Quantity AS Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|INTO R2031B_ShipmentInvoicing
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	ShipmentConfirmations.ShipmentConfirmation,
		|	ShipmentConfirmations.Quantity,
		|	ItemList.Company,
		|	ItemList.Period,
		|	ItemList.ItemKey,
		|	ItemList.Store
		|FROM
		|	ItemList AS ItemList
		|		INNER JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations
		|		ON ItemList.Key = ShipmentConfirmations.Key
		|WHERE
		|	TRUE";

EndFunction

Function R2040B_TaxesIncoming()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|*
		|INTO R2040B_TaxesIncoming
		|FROM
		|	Taxes AS Taxes
		|WHERE TRUE";

EndFunction

#Region Stock

Function R4010B_ActualStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.Quantity
		|INTO R4010B_ActualStocks
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists";
EndFunction

Function R4011B_FreeStocks()
	
	Return
		
		"SELECT
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.SalesOrderExists AS SalesOrderExists,
		|	SUM(ItemList.Quantity) AS Quantity
		|INTO ItemListGroup
		|FROM
		|	ItemList AS ItemList
		|Where
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.SalesOrderExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	StockReservation.Store AS Store,
		|	StockReservation.Order AS Basis,
		|	StockReservation.ItemKey AS ItemKey,
		|	StockReservation.QuantityBalance AS Quantity
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.SalesOrder
		|		FROM
		|			ItemList AS ItemList)) AS StockReservation
		|WHERE
		|	StockReservation.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period AS Period,
		|	ItemListGroup.Store AS Store,
		|	ItemListGroup.ItemKey AS ItemKey,
		|	ItemListGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity
		|INTO R4011B_FreeStocks
		|FROM
		|	ItemListGroup AS ItemListGroup
		|		LEFT JOIN TmpStockReservation AS TmpStockReservation
		|		ON (ItemListGroup.Store = TmpStockReservation.Store)
		|		AND (ItemListGroup.ItemKey = TmpStockReservation.ItemKey)
		|		AND TmpStockReservation.Basis = ItemListGroup.SalesOrder
		|WHERE
		|	ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP ItemListGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
EndFunction

Function R4012B_StockReservation()
	Return
		"SELECT
		|	ItemList.Period AS Period,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.SalesOrder AS SalesOrder,
		|	SUM(ItemList.Quantity) AS Quantity,
		|	ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists
		|INTO TmpItemListGroup
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND NOT ItemList.ShipmentConfirmationExists
		|	AND ItemList.SalesOrderExists
		|GROUP BY
		|	ItemList.Period,
		|	ItemList.Store,
		|	ItemList.ItemKey,
		|	ItemList.SalesOrder,
		|	ItemList.UseShipmentConfirmation,
		|	ItemList.ShipmentConfirmationExists
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	R4012B_StockReservationBalance.Store AS Store,
		|	R4012B_StockReservationBalance.ItemKey AS ItemKey,
		|	R4012B_StockReservationBalance.Order AS Order,
		|	R4012B_StockReservationBalance.QuantityBalance AS QuantityBalance
		|INTO TmpStockReservation
		|FROM
		|	AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, (Store, ItemKey, Order) IN
		|		(SELECT
		|			ItemList.Store,
		|			ItemList.ItemKey,
		|			ItemList.SalesOrder
		|		FROM
		|			TmpItemListGroup AS ItemList)) AS R4012B_StockReservationBalance
		|WHERE
		|	R4012B_StockReservationBalance.QuantityBalance > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemListGroup.Period AS Period,
		|	ItemListGroup.SalesOrder AS Order,
		|	ItemListGroup.ItemKey AS ItemKey,
		|	ItemListGroup.Store AS Store,
		|	CASE
		|		WHEN StockReservation.QuantityBalance > ItemListGroup.Quantity
		|			THEN ItemListGroup.Quantity
		|		ELSE StockReservation.QuantityBalance
		|	END AS Quantity
		|INTO R4012B_StockReservation
		|FROM
		|	TmpItemListGroup AS ItemListGroup
		|		INNER JOIN TmpStockReservation AS StockReservation
		|		ON ItemListGroup.SalesOrder = StockReservation.Order
		|		AND ItemListGroup.ItemKey = StockReservation.ItemKey
		|		AND ItemListGroup.Store = StockReservation.Store
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpItemListGroup
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|DROP TmpStockReservation";
EndFunction

Function R4032B_GoodsInTransitOutgoing()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	CASE
		|		WHEN ItemList.ShipmentConfirmationExists
		|			Then ShipmentConfirmations.ShipmentConfirmation
		|		Else ItemList.Invoice
		|	End AS Basis,
		|	CASE 
		|		WHEN ItemList.ShipmentConfirmationExists
		|			Then ShipmentConfirmations.Quantity
		|		Else ItemList.Quantity
		|	End AS Quantity,
		|	*
		|INTO R4032B_GoodsInTransitOutgoing
		|FROM
		|	ItemList AS ItemList
		|		LEFT JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations
		|		ON ItemList.Key = ShipmentConfirmations.Key
		|WHERE
		|	NOT ItemList.IsService
		|	AND (ItemList.UseShipmentConfirmation
		|		OR ItemList.ShipmentConfirmationExists)";

EndFunction

Function R4050B_StockInventory()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	*
		|INTO R4050B_StockInventory
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService";

EndFunction

#EndRegion

Function R4014B_SerialLotNumber()
	Return
		"SELECT 
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|*
		|INTO R4014B_SerialLotNumber
		|FROM
		|	SerialLotNumbers AS SerialLotNumbers
		|WHERE 
		|	TRUE";

EndFunction

Function R4034B_GoodsShipmentSchedule()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	ItemList.SalesOrder AS Basis,
		|	*
		|INTO R4034B_GoodsShipmentSchedule
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IsService
		|	AND NOT ItemList.UseShipmentConfirmation
		|	AND ItemList.SalesOrderExists
		|	AND ItemList.SalesOrder.UseItemsShipmentScheduling";

EndFunction

Function R2020B_AdvancesFromCustomers()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvances.AdvancesDocument AS Basis,
		|	OffsetOfAdvances.Recorder AS CustomersAdvancesClosing,
		|	*
		|INTO R2020B_AdvancesFromCustomers
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function R2021B_CustomersTransactions()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	SUM(ItemList.Amount) AS Amount,
		|	UNDEFINED AS CustomersAdvancesClosing
		|INTO R2021B_CustomersTransactions
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	OffsetOfAdvances.Period,
		|	OffsetOfAdvances.Company,
		|	OffsetOfAdvances.Currency,
		|	OffsetOfAdvances.LegalName,
		|	OffsetOfAdvances.Partner,
		|	OffsetOfAdvances.Agreement,
		|	OffsetOfAdvances.TransactionDocument,
		|	OffsetOfAdvances.Amount,
		|	OffsetOfAdvances.Recorder
		|FROM
		|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
		|WHERE
		|	OffsetOfAdvances.Document = &Ref";
EndFunction

Function T2011S_PartnerTransactions()
	Return
		"SELECT
		|	ItemList.Period,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Agreement,
		|	ItemList.Basis AS TransactionDocument,
		|	TRUE AS IsCustomerTransaction,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Key
		|INTO T2011S_PartnerTransactions
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	NOT ItemList.IgnoreAdvances
		|GROUP BY
		|	ItemList.Agreement,
		|	ItemList.Basis,
		|	ItemList.Company,
		|	ItemList.Currency,
		|	ItemList.Key,
		|	ItemList.LegalName,
		|	ItemList.Partner,
		|	ItemList.Period";
EndFunction		

Function R5011B_CustomersAging()
	Return 
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	PaymentTerms.Ref.Date AS Period,
		|	PaymentTerms.Ref.Company AS Company,
		|	PaymentTerms.Ref.Currency AS Currency,
		|	PaymentTerms.Ref.Agreement AS Agreement,
		|	PaymentTerms.Ref.Partner AS Partner,
		|	PaymentTerms.Ref AS Invoice,
		|	PaymentTerms.Date AS PaymentDate,
		|	SUM(PaymentTerms.Amount) AS Amount,
		|	UNDEFINED AS AgingClosing
		|INTO R5011B_CustomersAging
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS PaymentTerms
		|WHERE
		|	PaymentTerms.Ref = &Ref
		|GROUP BY
		|	PaymentTerms.Date,
		|	PaymentTerms.Ref,
		|	PaymentTerms.Ref.Agreement,
		|	PaymentTerms.Ref.Company,
		|	PaymentTerms.Ref.Currency,
		|	PaymentTerms.Ref.Date,
		|	PaymentTerms.Ref.Partner,
		|	VALUE(AccumulationRecordType.Receipt)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense),
		|	OffsetOfAging.Period,
		|	OffsetOfAging.Company,
		|	OffsetOfAging.Currency,
		|	OffsetOfAging.Agreement,
		|	OffsetOfAging.Partner,
		|	OffsetOfAging.Invoice,
		|	OffsetOfAging.PaymentDate,
		|	OffsetOfAging.Amount,
		|	OffsetOfAging.Recorder
		|FROM
		|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
		|WHERE
		|	OffsetOfAging.Document = &Ref";
EndFunction

Function R5010B_ReconciliationStatement()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	ItemList.Company,
		|	ItemList.LegalName,
		|	ItemList.Currency,
		|	SUM(ItemList.Amount) AS Amount,
		|	ItemList.Period
		|INTO R5010B_ReconciliationStatement
		|FROM
		|	ItemList AS ItemList
		|GROUP BY
		|	ItemList.Company,
		|	ItemList.LegalName,
		|	ItemList.Currency,
		|	ItemList.Period";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	SalesInvoicePaymentTerms.Ref.Date AS Period,
		|	SalesInvoicePaymentTerms.Ref.Company AS Company,
		|	SalesInvoicePaymentTerms.Ref AS Basis,
		|	SalesInvoicePaymentTerms.Ref.LegalName AS LegalName,
		|	SalesInvoicePaymentTerms.Ref.Partner AS Partner,
		|	SalesInvoicePaymentTerms.Ref.Agreement AS Agreement,
		|	SUM(SalesInvoicePaymentTerms.Amount) AS Amount
		|INTO R2022B_CustomersPaymentPlanning
		|FROM
		|	Document.SalesInvoice.PaymentTerms AS SalesInvoicePaymentTerms
		|WHERE
		|	SalesInvoicePaymentTerms.Ref = &Ref
		|	AND SalesInvoicePaymentTerms.CalculationType = VALUE(Enum.CalculationTypes.PostShipmentCredit)
		|GROUP BY
		|	SalesInvoicePaymentTerms.Ref.Date,
		|	SalesInvoicePaymentTerms.Ref.Company,
		|	SalesInvoicePaymentTerms.Ref,
		|	SalesInvoicePaymentTerms.Ref.LegalName,
		|	SalesInvoicePaymentTerms.Ref.Partner,
		|	SalesInvoicePaymentTerms.Ref.Agreement,
		|	VALUE(AccumulationRecordType.Receipt)";
EndFunction

Function R5021T_Revenues()
	Return
		"SELECT
		|	*,
		|	ItemList.NetAmount AS Amount
		|INTO R5021T_Revenues
		|FROM
		|	ItemList AS ItemList
		|WHERE
		|	TRUE";
EndFunction	

#EndRegion