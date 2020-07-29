#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	
	AccReg = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("OrderBalance", PostingServer.CreateTable(AccReg.OrderBalance));
	Tables.Insert("OrderReservation", PostingServer.CreateTable(AccReg.OrderReservation));
	Tables.Insert("StockReservation", PostingServer.CreateTable(AccReg.StockReservation));
	Tables.Insert("InventoryBalance", PostingServer.CreateTable(AccReg.InventoryBalance));
	Tables.Insert("SalesTurnovers", PostingServer.CreateTable(AccReg.SalesTurnovers));
	Tables.Insert("GoodsInTransitOutgoing", PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("GoodsInTransitOutgoing_Exists", PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.Insert("StockBalance", PostingServer.CreateTable(AccReg.StockBalance));
	Tables.Insert("ShipmentOrders", PostingServer.CreateTable(AccReg.ShipmentOrders));
	Tables.Insert("PartnerArTransactions", PostingServer.CreateTable(AccReg.PartnerArTransactions));
	Tables.Insert("AdvanceFromCustomers_Lock", PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("AdvanceFromCustomers_Registrations", PostingServer.CreateTable(AccReg.AdvanceFromCustomers));
	Tables.Insert("ShipmentConfirmationSchedule_Expense", PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ShipmentConfirmationSchedule_Receipt", PostingServer.CreateTable(AccReg.ShipmentConfirmationSchedule));
	Tables.Insert("ReconciliationStatement", PostingServer.CreateTable(AccReg.ReconciliationStatement));
	Tables.Insert("TaxesTurnovers", PostingServer.CreateTable(AccReg.TaxesTurnovers));
	Tables.Insert("RevenuesTurnovers", PostingServer.CreateTable(AccReg.RevenuesTurnovers));

	QueryItemList = New Query();
	QueryItemList.Text = GetQueryTextRetailSalesReceiptItemList();
	QueryItemList.SetParameter("Ref", Ref);
	QueryResultItemList = QueryItemList.Execute();
	QueryTableItemList = QueryResultItemList.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTableItemList);
	// UUID to String
	QueryTableItemList.Columns.Add("RowKey", 
		Metadata.AccumulationRegisters.ShipmentConfirmationSchedule.Dimensions.RowKey.Type);
	For Each Row In QueryTableItemList Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
	QueryTaxList = New Query();
	QueryTaxList.Text = GetQueryTextRetailSalesReceiptTaxList();
	QueryTaxList.SetParameter("Ref", Ref);
	QueryResultTaxList = QueryTaxList.Execute();
	QueryTableTaxList = QueryResultTaxList.Unload();
	// UUID to String
	QueryTableTaxList.Columns.Add("RowKey", Metadata.AccumulationRegisters.TaxesTurnovers.Dimensions.RowKey.Type);
	For Each Row In QueryTableTaxList Do
		Row.RowKey = String(Row.RowKeyUUID);
	EndDo;
	
	Query = New Query();
	Query.Text = GetQueryTextQueryTable();
	Query.SetParameter("QueryTable", QueryTableItemList);
	QueryResult = Query.ExecuteBatch();
	
	Tables.OrderBalance = QueryResult[1].Unload();
	Tables.OrderReservation = QueryResult[2].Unload();
	Tables.StockReservation = QueryResult[3].Unload();
	Tables.InventoryBalance = QueryResult[4].Unload();
	Tables.SalesTurnovers = QueryResult[5].Unload();
	Tables.GoodsInTransitOutgoing = QueryResult[6].Unload();
	Tables.StockBalance = QueryResult[7].Unload();
	Tables.ShipmentOrders = QueryResult[8].Unload();
	Tables.PartnerArTransactions = QueryResult[9].Unload();
	Tables.AdvanceFromCustomers_Lock = QueryResult[10].Unload();
	Tables.ShipmentConfirmationSchedule_Expense = QueryResult[11].Unload();
	Tables.ShipmentConfirmationSchedule_Receipt = QueryResult[12].Unload();
	Tables.ReconciliationStatement = QueryResult[13].Unload();
	Tables.RevenuesTurnovers = QueryResult[14].Unload();
	Tables.TaxesTurnovers = QueryTableTaxList;
	
	Tables.GoodsInTransitOutgoing_Exists = GetExistsGoodsInTransitOutgoing(Ref, AddInfo);
	
	Return Tables;
EndFunction

Function GetQueryTextRetailSalesReceiptItemList()
	Return
		"SELECT
		|	RetailSalesReceiptItemList.Ref.Company AS Company,
		|	RetailSalesReceiptItemList.Store AS Store,
		|	RetailSalesReceiptItemList.ShipmentConfirmation AS ShipmentConfirmation,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.ShipmentConfirmation.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS ShipmentConfirmationBeforeRetailSalesReceipt,
		|	RetailSalesReceiptItemList.Store.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	RetailSalesReceiptItemList.ItemKey AS ItemKey,
		|	SUM(RetailSalesReceiptItemList.Quantity) AS Quantity,
		|	SUM(RetailSalesReceiptItemList.TotalAmount) AS TotalAmount,
		|	RetailSalesReceiptItemList.Ref.Partner AS Partner,
		|	RetailSalesReceiptItemList.Ref.LegalName AS LegalName,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND RetailSalesReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN RetailSalesReceiptItemList.Ref.Agreement.StandardAgreement
		|		ELSE RetailSalesReceiptItemList.Ref.Agreement
		|	END AS Agreement,
		|	RetailSalesReceiptItemList.Ref.Currency AS Currency,
		|	0 AS BasisQuantity,
		|	RetailSalesReceiptItemList.Unit AS Unit,
		|	RetailSalesReceiptItemList.ItemKey.Item.Unit AS ItemUnit,
		|	RetailSalesReceiptItemList.ItemKey.Unit AS ItemKeyUnit,
		|	RetailSalesReceiptItemList.ItemKey.Item AS Item,
		|	RetailSalesReceiptItemList.Ref.Date AS Period,
		|	RetailSalesReceiptItemList.SalesOrder AS SalesOrder,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.SalesOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS UseSalesOrder,
		|	RetailSalesReceiptItemList.Ref AS ShipmentBasis,
		|	RetailSalesReceiptItemList.Ref AS RetailSalesReceipt,
		|	RetailSalesReceiptItemList.Key AS RowKeyUUID,
		|	RetailSalesReceiptItemList.Ref.IsOpeningEntry AS IsOpeningEntry,
		|	RetailSalesReceiptItemList.DeliveryDate AS DeliveryDate,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END AS IsService,
		|	RetailSalesReceiptItemList.BusinessUnit AS BusinessUnit,
		|	RetailSalesReceiptItemList.RevenueType AS RevenueType,
		|	RetailSalesReceiptItemList.AdditionalAnalytic AS AdditionalAnalytic,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN RetailSalesReceiptItemList.Ref
		|		ELSE UNDEFINED
		|	END AS BasisDocument,
		|	SUM(RetailSalesReceiptItemList.NetAmount) AS NetAmount,
		|	SUM(RetailSalesReceiptItemList.OffersAmount) AS OffersAmount
		|FROM
		|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
		|WHERE
		|	RetailSalesReceiptItemList.Ref = &Ref
		|GROUP BY
		|	RetailSalesReceiptItemList.Ref.Company,
		|	RetailSalesReceiptItemList.Store,
		|	RetailSalesReceiptItemList.ShipmentConfirmation,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.ShipmentConfirmation.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END,
		|	RetailSalesReceiptItemList.Store.UseShipmentConfirmation,
		|	RetailSalesReceiptItemList.ItemKey,
		|	RetailSalesReceiptItemList.Ref.Partner,
		|	RetailSalesReceiptItemList.Ref.LegalName,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.Ref.Agreement.Kind = VALUE(Enum.AgreementKinds.Regular)
		|		AND RetailSalesReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByStandardAgreement)
		|			THEN RetailSalesReceiptItemList.Ref.Agreement.StandardAgreement
		|		ELSE RetailSalesReceiptItemList.Ref.Agreement
		|	END,
		|	RetailSalesReceiptItemList.Ref.Currency,
		|	RetailSalesReceiptItemList.Unit,
		|	RetailSalesReceiptItemList.ItemKey.Item.Unit,
		|	RetailSalesReceiptItemList.ItemKey.Unit,
		|	RetailSalesReceiptItemList.ItemKey.Item,
		|	RetailSalesReceiptItemList.Ref.Date,
		|	RetailSalesReceiptItemList.SalesOrder,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.SalesOrder.Date IS NULL
		|			THEN FALSE
		|		ELSE TRUE
		|	END,
		|	RetailSalesReceiptItemList.Ref,
		|	RetailSalesReceiptItemList.Key,
		|	RetailSalesReceiptItemList.Ref.IsOpeningEntry,
		|	RetailSalesReceiptItemList.DeliveryDate,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service)
		|			THEN TRUE
		|		ELSE FALSE
		|	END,
		|	RetailSalesReceiptItemList.BusinessUnit,
		|	RetailSalesReceiptItemList.RevenueType,
		|	CASE
		|		WHEN RetailSalesReceiptItemList.Ref.Agreement.ApArPostingDetail = VALUE(Enum.ApArPostingDetail.ByDocuments)
		|			THEN RetailSalesReceiptItemList.Ref
		|		ELSE UNDEFINED
		|	END,
		|	RetailSalesReceiptItemList.AdditionalAnalytic";

EndFunction

Function GetQueryTextRetailSalesReceiptTaxList()
	Return
			"SELECT
			|	RetailSalesReceiptTaxList.Ref AS Document,
			|	RetailSalesReceiptTaxList.Ref.Date AS Period,
			|	RetailSalesReceiptTaxList.Ref.Currency AS Currency,
			|	RetailSalesReceiptTaxList.Key AS RowKeyUUID,
			|	RetailSalesReceiptTaxList.Tax AS Tax,
			|	RetailSalesReceiptTaxList.Analytics AS Analytics,
			|	RetailSalesReceiptTaxList.TaxRate AS TaxRate,
			|	RetailSalesReceiptTaxList.Amount AS Amount,
			|	RetailSalesReceiptTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
			|	RetailSalesReceiptTaxList.ManualAmount AS ManualAmount,
			|	RetailSalesReceiptItemList.NetAmount AS NetAmount
			|FROM
			|	Document.RetailSalesReceipt.TaxList AS RetailSalesReceiptTaxList
			|		INNER JOIN Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
			|		ON RetailSalesReceiptTaxList.Ref = RetailSalesReceiptItemList.Ref
			|		AND RetailSalesReceiptItemList.Ref = &Ref
			|		AND RetailSalesReceiptTaxList.Ref = &Ref
			|		AND RetailSalesReceiptItemList.Key = RetailSalesReceiptTaxList.Key
			|WHERE
			|	RetailSalesReceiptTaxList.Ref = &Ref";
EndFunction

Function GetQueryTextQueryTable()
	Return
		"SELECT
		|	QueryTable.Company AS Company,
		|	QueryTable.Store AS Store,
		|	QueryTable.ShipmentConfirmation AS ShipmentConfirmation,
		|	QueryTable.ShipmentConfirmationBeforeRetailSalesReceipt AS ShipmentConfirmationBeforeRetailSalesReceipt,
		|	QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,
		|	QueryTable.ItemKey AS ItemKey,
		|	QueryTable.BasisQuantity AS Quantity,
		|	QueryTable.TotalAmount AS Amount,
		|	QueryTable.Partner AS Partner,
		|	QueryTable.LegalName AS LegalName,
		|	QueryTable.Agreement AS Agreement,
		|	QueryTable.Currency AS Currency,
		|	QueryTable.Period AS Period,
		|	QueryTable.SalesOrder AS SalesOrder,
		|	QueryTable.UseSalesOrder AS UseSalesOrder,
		|	QueryTable.ShipmentBasis AS ShipmentBasis,
		|	QueryTable.RetailSalesReceipt AS RetailSalesReceipt,
		|	QueryTable.RowKey AS RowKey,
		|	QueryTable.IsOpeningEntry AS IsOpeningEntry,
		|	QueryTable.DeliveryDate AS DeliveryDate,
		|	QueryTable.BusinessUnit AS BusinessUnit,
		|	QueryTable.RevenueType AS RevenueType,
		|	QueryTable.AdditionalAnalytic AS AdditionalAnalytic,
		|	QueryTable.NetAmount AS NetAmount,
		|	QueryTable.OffersAmount AS OffersAmount,
		|	QueryTable.IsService AS IsService,
		|	QueryTable.BasisDocument AS BasisDocument
		|INTO tmp
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|
		|//[1]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.SalesOrder AS Order,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.SalesOrder <> VALUE(Document.SalesOrder.EmptyRef)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period,
		|	tmp.SalesOrder,
		|	tmp.RowKey
		|;
		|
		|//[2]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.SalesOrder <> VALUE(Document.SalesOrder.EmptyRef)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[3]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseSalesOrder
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|GROUP BY
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.Period
		|;
		|
		|//[4]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	(NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt OR NOT tmp.UseSalesOrder)
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey
		|;
		|
		|//[5]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Currency AS Currency,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.RetailSalesReceipt AS RetailSalesReceipt,
		|	SUM(tmp.Amount) AS Amount,
		|	SUM(tmp.NetAmount) AS NetAmount,
		|	SUM(tmp.OffersAmount) AS OffersAmount,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Currency,
		|	tmp.ItemKey,
		|	tmp.RetailSalesReceipt,
		|	tmp.RowKey
		|;
		|
		|//[6]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	CASE
		|		WHEN tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|		AND
		|		NOT tmp.UseSalesOrder
		|			THEN tmp.ShipmentConfirmation
		|		ELSE tmp.ShipmentBasis
		|	END AS ShipmentBasis,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.UseShipmentConfirmation
		|	AND (NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|	OR
		|	NOT tmp.UseSalesOrder)
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	CASE
		|		WHEN tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|		AND
		|		NOT tmp.UseSalesOrder
		|			THEN tmp.ShipmentConfirmation
		|		ELSE tmp.ShipmentBasis
		|	END,
		|	tmp.RowKey
		|;
		|
		|//[7]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseShipmentConfirmation
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.IsService
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.Store,
		|	tmp.ItemKey
		|;
		|
		|//[8]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.SalesOrder AS Order,
		|	tmp.ShipmentConfirmation AS ShipmentConfirmation,
		|	tmp.ItemKey AS ItemKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.RowKey AS RowKey
		|FROM
		|	tmp AS tmp
		|WHERE
		|	tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND tmp.UseSalesOrder
		|GROUP BY
		|	tmp.SalesOrder,
		|	tmp.Period,
		|	tmp.ShipmentConfirmation,
		|	tmp.ItemKey,
		|	tmp.RowKey
		|;
		|
		|//[9]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[10]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.BasisDocument AS BasisDocument,
		|	tmp.Partner AS Partner,
		|	tmp.LegalName AS LegalName,
		|	tmp.Agreement AS Agreement,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS DocumentAmount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.BasisDocument,
		|	tmp.Partner,
		|	tmp.LegalName,
		|	tmp.Agreement,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[11]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.SalesOrder AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.Period AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.SalesOrder
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND
		|		NOT tmp.UseShipmentConfirmation
		|		AND
		|		NOT tmp.ShipmentConfirmationBeforeREtailSalesReceipt
		|		AND
		|		NOT tmp.IsOpeningEntry
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|GROUP BY
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.Period
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	SUM(tmp.Quantity),
		|	tmp.Period,
		|	ShipmentConfirmationSchedule.DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.SalesOrder
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND tmp.UseShipmentConfirmation
		|		AND
		|		NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|		AND
		|		NOT tmp.IsOpeningEntry
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|GROUP BY
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	ShipmentConfirmationSchedule.DeliveryDate
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.RetailSalesReceipt,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	SUM(tmp.Quantity),
		|	tmp.Period,
		|	tmp.Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.UseShipmentConfirmation
		|	AND
		|	NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.UseSalesOrder
		|	AND tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.RetailSalesReceipt,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate,
		|	tmp.Period
		|;
		|
		|//[12]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.RetailSalesReceipt AS Order,
		|	tmp.Store AS Store,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.RowKey AS RowKey,
		|	SUM(tmp.Quantity) AS Quantity,
		|	tmp.Period AS Period,
		|	tmp.DeliveryDate AS DeliveryDate
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|	AND
		|	NOT tmp.IsOpeningEntry
		|	AND
		|	NOT tmp.UseSalesOrder
		|	AND tmp.DeliveryDate <> DATETIME(1, 1, 1)
		|GROUP BY
		|	tmp.Company,
		|	tmp.RetailSalesReceipt,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|
		|UNION ALL
		|
		|SELECT
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	SUM(tmp.Quantity),
		|	tmp.Period,
		|	tmp.DeliveryDate
		|FROM
		|	tmp AS tmp
		|		INNER JOIN AccumulationRegister.ShipmentConfirmationSchedule AS ShipmentConfirmationSchedule
		|		ON ShipmentConfirmationSchedule.Recorder = tmp.SalesOrder
		|		AND ShipmentConfirmationSchedule.RowKey = tmp.RowKey
		|		AND ShipmentConfirmationSchedule.Company = tmp.Company
		|		AND ShipmentConfirmationSchedule.Store = tmp.Store
		|		AND ShipmentConfirmationSchedule.ItemKey = tmp.ItemKey
		|		AND tmp.UseShipmentConfirmation
		|		AND
		|		NOT tmp.ShipmentConfirmationBeforeRetailSalesReceipt
		|		AND
		|		NOT tmp.IsOpeningEntry
		|		AND ShipmentConfirmationSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
		|GROUP BY
		|	tmp.Company,
		|	tmp.SalesOrder,
		|	tmp.Store,
		|	tmp.ItemKey,
		|	tmp.RowKey,
		|	tmp.Period,
		|	tmp.DeliveryDate
		|;
		|
		|//[13]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Company AS Company,
		|	tmp.LegalName AS LegalName,
		|	tmp.Currency AS Currency,
		|	SUM(tmp.Amount) AS Amount,
		|	tmp.Period AS Period
		|FROM
		|	tmp AS tmp
		|WHERE
		|	NOT tmp.IsOpeningEntry
		|GROUP BY
		|	tmp.Company,
		|	tmp.LegalName,
		|	tmp.Currency,
		|	tmp.Period
		|;
		|
		|//[14]//////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	tmp.Period AS Period,
		|	tmp.Company AS Company,
		|	tmp.BusinessUnit AS BusinessUnit,
		|	tmp.RevenueType AS RevenueType,
		|	tmp.ItemKey AS ItemKey,
		|	tmp.Currency AS Currency,
		|	tmp.AdditionalAnalytic AS AdditionalAnalytic,
		|	SUM(tmp.NetAmount) AS Amount
		|FROM
		|	tmp AS tmp
		|GROUP BY
		|	tmp.Period,
		|	tmp.Company,
		|	tmp.BusinessUnit,
		|	tmp.RevenueType,
		|	tmp.Currency,
		|	tmp.AdditionalAnalytic,
		|	tmp.ItemKey";
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// OrderBalance
	OrderBalance = AccumulationRegisters.OrderBalance.GetLockFields(DocumentDataTables.OrderBalance);
	DataMapWithLockFields.Insert(OrderBalance.RegisterName, OrderBalance.LockInfo);
	
	// InventoryBalance
	InventoryBalance = AccumulationRegisters.InventoryBalance.GetLockFields(DocumentDataTables.InventoryBalance);
	DataMapWithLockFields.Insert(InventoryBalance.RegisterName, InventoryBalance.LockInfo);
	
	// OrderReservation
	OrderReservation = AccumulationRegisters.OrderReservation.GetLockFields(DocumentDataTables.OrderReservation);
	DataMapWithLockFields.Insert(OrderReservation.RegisterName, OrderReservation.LockInfo);
	
	// StockReservation 
	StockReservation = AccumulationRegisters.StockReservation.GetLockFields(DocumentDataTables.StockReservation);
	DataMapWithLockFields.Insert(StockReservation.RegisterName, StockReservation.LockInfo);
	
	// SalesTurnovers
	SalesTurnovers = AccumulationRegisters.SalesTurnovers.GetLockFields(DocumentDataTables.SalesTurnovers);
	SalesTurnovers.LockInfo.Fields["SalesInvoice"] = "RetailSalesReceipt";
	DataMapWithLockFields.Insert(SalesTurnovers.RegisterName, SalesTurnovers.LockInfo);
	
	// GoodsInTransitOutgoing 
	GoodsInTransitOutgoing = 
		AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	// StockBalance 
	StockBalance = AccumulationRegisters.StockBalance.GetLockFields(DocumentDataTables.StockBalance);
	DataMapWithLockFields.Insert(StockBalance.RegisterName, StockBalance.LockInfo);
	
	// ShipmentOrders
	ShipmentOrders = AccumulationRegisters.ShipmentOrders.GetLockFields(DocumentDataTables.ShipmentOrders);
	DataMapWithLockFields.Insert(ShipmentOrders.RegisterName, ShipmentOrders.LockInfo);
	
	// PartnerArTransactions
	PartnerArTransactions 
		= AccumulationRegisters.PartnerArTransactions.GetLockFields(DocumentDataTables.PartnerArTransactions);
	DataMapWithLockFields.Insert(PartnerArTransactions.RegisterName, PartnerArTransactions.LockInfo);
	
	// AdvanceFromCustomers (Lock use In PostingCheckBeforeWrite)
	AdvanceFromCustomers = 
		AccumulationRegisters.AdvanceFromCustomers.GetLockFields(DocumentDataTables.AdvanceFromCustomers_Lock);
	DataMapWithLockFields.Insert(AdvanceFromCustomers.RegisterName, AdvanceFromCustomers.LockInfo);
	
	// ReconciliationStatement
	ReconciliationStatement 
		= AccumulationRegisters.ReconciliationStatement.GetLockFields(DocumentDataTables.ReconciliationStatement);
	DataMapWithLockFields.Insert(ReconciliationStatement.RegisterName, ReconciliationStatement.LockInfo);
	
	// TaxesTurnovers
	TaxesTurnovers = AccumulationRegisters.TaxesTurnovers.GetLockFields(DocumentDataTables.TaxesTurnovers);
	DataMapWithLockFields.Insert(TaxesTurnovers.RegisterName, TaxesTurnovers.LockInfo);
	
	// RevenuesTurnovers
	RevenuesTurnovers = AccumulationRegisters.RevenuesTurnovers.GetLockFields(DocumentDataTables.RevenuesTurnovers);
	DataMapWithLockFields.Insert(RevenuesTurnovers.RegisterName, RevenuesTurnovers.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	// Advance from customers
	Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations =
		AccumulationRegisters.AdvanceFromCustomers.GetTableExpenceAdvance(Parameters.Object.RegisterRecords
			, Parameters.PointInTime
			, Parameters.DocumentDataTables.AdvanceFromCustomers_Lock);
			
    If Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Count() Then
    	Query = New Query();
    	Query.Text = 
    	"SELECT
    	|	tmp.Company,
    	|	tmp.Partner,
    	|	tmp.LegalName,
    	|	tmp.BasisDocument,
    	|	tmp.Currency,
    	|	tmp.Amount
    	|INTO tmp
    	|FROM
    	|	&QueryTable AS tmp
    	|;
    	|////////////////////////////////////////////////////////////////////////////////
    	|SELECT
    	|	AccountsStatementBalance.Company,
    	|	AccountsStatementBalance.Partner,
    	|	AccountsStatementBalance.LegalName,
    	|	AccountsStatementBalance.Currency,
    	|	&Period AS Period,
    	|	AccountsStatementBalance.AdvanceToSuppliersBalance AS AdvanceToSuppliersBalance,
    	|	-tmp.Amount AS AdvanceToSuppliers
    	|FROM
    	|	AccumulationRegister.AccountsStatement.Balance(&PointInTime, (Company, Partner, LegalName, Currency) IN
    	|		(SELECT
    	|			tmp.Company,
    	|			tmp.Partner,
    	|			tmp.LegalName,
    	|			tmp.Currency
    	|		FROM
    	|			tmp AS tmp)) AS AccountsStatementBalance
    	|		INNER JOIN tmp AS tmp
    	|		ON AccountsStatementBalance.Company = tmp.Company
    	|		AND AccountsStatementBalance.Partner = tmp.Partner
    	|		AND AccountsStatementBalance.LegalName = tmp.LegalName
    	|		AND AccountsStatementBalance.Currency = tmp.Currency";
    	Query.SetParameter("QueryTable", Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations);
    	Query.SetParameter("PointInTime", Parameters.PointInTime);
    	Query.SetParameter("Period", Parameters.Object.Date);
    	Parameters.DocumentDataTables.Insert("AdvanceFromCustomers_Registrations_AccountStatement",
    	Query.Execute().Unload());
    EndIf;
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	
	// OrderBalance 
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderBalance,
		New Structure("RecordType, RecordSet, WriteInTransaction", 
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderBalance,
			True));
	
	// InventoryBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.InventoryBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.InventoryBalance));
	
	// OrderReservation
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.OrderReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.OrderReservation));
	
	// StockReservation	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockReservation,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockReservation));
	
	
	// SalesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.SalesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.SalesTurnovers));
	
	// GoodsInTransitOutgoing
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.GoodsInTransitOutgoing,
		New Structure("RecordType, RecordSet, WriteInTransaction",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing,
			Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists.Count() > 0));
	
	// StockBalance
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.StockBalance,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.StockBalance));
	
	// ShipmentOrders
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentOrders,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.ShipmentOrders));
	
	// RevenuesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.RevenuesTurnovers,
		New Structure("RecordSet, WriteInTransaction",
			Parameters.DocumentDataTables.RevenuesTurnovers,
			Parameters.IsReposting));
	
	// AccountsStatement
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table1);
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Copy();
	Table2.Columns.Amount.Name = "TransactionAR";
	PostingServer.AddColumnsToAccountsStatementTable(Table2);
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	Table3 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Copy();
	Table3.Columns.Amount.Name = "AdvanceFromCustomers";
	PostingServer.AddColumnsToAccountsStatementTable(Table3);
	Table3.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table3);
		
	If Parameters.DocumentDataTables.Property("AdvanceFromCustomers_Registrations_AccountStatement") Then
		Table4 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations_AccountStatement.Copy();
		PostingServer.AddColumnsToAccountsStatementTable(Table4);
		Table4.FillValues(AccumulationRecordType.Expense, "RecordType");
		ArrayOfTables.Add(Table4);
	EndIf;
		
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AccountsStatement,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Partner, LegalName, BasisDocument, Currency, 
				|TransactionAR, AdvanceFromCustomers,
				|TransactionAP, AdvanceToSuppliers"),
			Parameters.IsReposting));	
		
	// PartnerArTransactions
	// PartnerArTransactions [Receipt]  
	// AdvanceFromCustomers_Registrations [Expense]
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.PartnerArTransactions.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.PartnerArTransactions,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, BasisDocument, Partner, 
				|LegalName, Agreement, Currency, Amount"),
				Parameters.IsReposting));
	
	// AdvanceFromCustomers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.AdvanceFromCustomers,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Expense,
			Parameters.DocumentDataTables.AdvanceFromCustomers_Registrations));
	
	// ShipmentConfirmationSchedule
	ArrayOfTables = New Array();
	Table1 = Parameters.DocumentDataTables.ShipmentConfirmationSchedule_Expense.Copy();
	Table1.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table1.FillValues(AccumulationRecordType.Expense, "RecordType");
	ArrayOfTables.Add(Table1);
	
	Table2 = Parameters.DocumentDataTables.ShipmentConfirmationSchedule_Receipt.Copy();
	Table2.Columns.Add("RecordType", New TypeDescription("AccumulationRecordType"));
	Table2.FillValues(AccumulationRecordType.Receipt, "RecordType");
	ArrayOfTables.Add(Table2);
	
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ShipmentConfirmationSchedule,
		New Structure("RecordSet, WriteInTransaction",
			PostingServer.JoinTables(ArrayOfTables,
				"RecordType, Period, Company, Order, Store, ItemKey, RowKey, Quantity, DeliveryDate"),
			Parameters.IsReposting));
	
	// ReconciliationStatement
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.ReconciliationStatement,
		New Structure("RecordType, RecordSet",
			AccumulationRecordType.Receipt,
			Parameters.DocumentDataTables.ReconciliationStatement));
	
	// TaxesTurnovers
	PostingDataTables.Insert(Parameters.Object.RegisterRecords.TaxesTurnovers,
		New Structure("RecordSet", Parameters.DocumentDataTables.TaxesTurnovers));
	
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	If Not CheckOrderBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not CheckGoodsInTransitOutgoingBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	AccReg = Metadata.AccumulationRegisters;
	Tables.Insert("GoodsInTransitOutgoing_Exists", PostingServer.CreateTable(AccReg.GoodsInTransitOutgoing));
	Tables.GoodsInTransitOutgoing_Exists = GetExistsGoodsInTransitOutgoing(Ref, AddInfo);	
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DocumentDataTables = Parameters.DocumentDataTables;
	DataMapWithLockFields = New Map();
	
	// GoodsInTransitOutgoing
	GoodsInTransitOutgoing = AccumulationRegisters.GoodsInTransitOutgoing.GetLockFields(DocumentDataTables.GoodsInTransitOutgoing_Exists);
	DataMapWithLockFields.Insert(GoodsInTransitOutgoing.RegisterName, GoodsInTransitOutgoing.LockInfo);
	
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	If Not CheckOrderBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
	
	If Not CheckGoodsInTransitOutgoingBalance(Ref, Parameters, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

Function CheckOrderBalance(Ref, Parameters, AddInfo = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	OrderBalanceBalance.ItemKey.Item AS Item,
	|	OrderBalanceBalance.ItemKey AS ItemKey,
	|	OrderBalanceBalance.Order,
	|	SUM(OrderBalanceBalance.QuantityBalance) AS QuantityBalance,
	|	SUM(RetailSalesReceiptItemList.Quantity) AS Quantity,
	|	-SUM(OrderBalanceBalance.QuantityBalance) AS LackOfBalance,
	|	RetailSalesReceiptItemList.LineNumber AS LineNumber,
	|	0 AS BasisQuantity,
	|	RetailSalesReceiptItemList.Unit AS Unit,
	|	OrderBalanceBalance.ItemKey.Item.Unit AS ItemUnit,
	|	OrderBalanceBalance.ItemKey.Unit AS ItemKeyUnit,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|		INNER JOIN AccumulationRegister.OrderBalance.Balance(, (Order, ItemKey, Store) IN
	|			(SELECT
	|				RetailSalesReceiptItemList.SalesOrder AS Order,
	|				RetailSalesReceiptItemList.ItemKey AS ItemKey,
	|				RetailSalesReceiptItemList.Store AS Store
	|			FROM
	|				Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|			WHERE
	|				RetailSalesReceiptItemList.Ref = &Ref
	|				AND NOT RetailSalesReceiptItemList.SalesOrder.Date IS NULL)) AS OrderBalanceBalance
	|		ON OrderBalanceBalance.Order = RetailSalesReceiptItemList.SalesOrder
	|		AND OrderBalanceBalance.ItemKey = RetailSalesReceiptItemList.ItemKey
	|		AND OrderBalanceBalance.Store = RetailSalesReceiptItemList.Store
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref
	|	AND NOT RetailSalesReceiptItemList.SalesOrder.Date IS NULL
	|GROUP BY
	|	OrderBalanceBalance.ItemKey.Item,
	|	OrderBalanceBalance.ItemKey,
	|	RetailSalesReceiptItemList.LineNumber,
	|	OrderBalanceBalance.Order,
	|	RetailSalesReceiptItemList.Unit,
	|	OrderBalanceBalance.ItemKey.Item.Unit,
	|	OrderBalanceBalance.ItemKey.Unit,
	|	VALUE(Catalog.Units.EmptyRef)
	|HAVING
	|	SUM(OrderBalanceBalance.QuantityBalance) < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTable);
	HaveError = False;
	If QueryTable.Count() Then
		HaveError = True;
		
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Order, ItemKey, Item, BasisUnit, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "BasisQuantity");
		ErrorParameters.Insert("FilterColumns", "Order, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Ordered");
		ErrorParameters.Insert("Excess", False);
		
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not HaveError;
EndFunction

Function CheckGoodsInTransitOutgoingBalance(Ref, Parameters, AddInfo = Undefined)
	Query = New Query();
	Query.Text =
	"SELECT
	|	GoodsInTransitOutgoing_Exists.Store AS Store,
	|	GoodsInTransitOutgoing_Exists.ShipmentBasis AS ShipmentBasis,
	|	GoodsInTransitOutgoing_Exists.Item AS Item,
	|	GoodsInTransitOutgoing_Exists.ItemKey AS ItemKey,
	|	GoodsInTransitOutgoing_Exists.Quantity AS Quantity
	|INTO GoodsInTransitOutgoing_Exists
	|FROM
	|	&GoodsInTransitOutgoing_Exists AS GoodsInTransitOutgoing_Exists
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	GoodsInTransitOutgoing_Exists.Store AS Store,
	|	GoodsInTransitOutgoing_Exists.ShipmentBasis AS ShipmentBasis,
	|	GoodsInTransitOutgoing_Exists.Item AS Item,
	|	GoodsInTransitOutgoing_Exists.ItemKey AS ItemKey,
	|	GoodsInTransitOutgoing_Exists.Quantity AS Quantity
	|INTO GoodsInTransitOutgoing_Deleted
	|FROM
	|	GoodsInTransitOutgoing_Exists AS GoodsInTransitOutgoing_Exists
	|		LEFT JOIN Document.RetailSalesReceipt.ItemList AS ItemList
	|		ON ItemList.Ref = &Ref
	|		AND GoodsInTransitOutgoing_Exists.Store = ItemList.Store
	|		AND GoodsInTransitOutgoing_Exists.ShipmentBasis = ItemList.Ref
	|		AND GoodsInTransitOutgoing_Exists.ItemKey = ItemList.ItemKey
	|WHERE
	|	ItemList.Ref IS NULL
	|	AND
	|	NOT &Unposting
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RetailSalesReceiptItemList.Ref AS ShipmentBasis,
	|	RetailSalesReceiptItemList.ItemKey.Item AS Item,
	|	RetailSalesReceiptItemList.ItemKey AS ItemKey,
	|	RetailSalesReceiptItemList.Store AS Store,
	|	RetailSalesReceiptItemList.Quantity AS Quantity,
	|	0 AS BasisQuantity,
	|	RetailSalesReceiptItemList.Unit AS Unit,
	|	RetailSalesReceiptItemList.ItemKey.Item.Unit AS ItemUnit,
	|	RetailSalesReceiptItemList.ItemKey.Unit AS ItemKeyUnit,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
	|	RetailSalesReceiptItemList.LineNumber AS LineNumber
	|INTO ItemList_Full
	|FROM
	|	Document.RetailSalesReceipt.ItemList AS RetailSalesReceiptItemList
	|WHERE
	|	RetailSalesReceiptItemList.Ref = &Ref
	|
	|UNION ALL
	|
	|SELECT
	|	GoodsInTransitOutgoing_Deleted.ShipmentBasis,
	|	GoodsInTransitOutgoing_Deleted.Item,
	|	GoodsInTransitOutgoing_Deleted.ItemKey,
	|	GoodsInTransitOutgoing_Deleted.Store,
	|	GoodsInTransitOutgoing_Deleted.Quantity,
	|	0,
	|	CASE
	|		WHEN GoodsInTransitOutgoing_Deleted.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
	|			THEN GoodsInTransitOutgoing_Deleted.ItemKey.Unit
	|		ELSE GoodsInTransitOutgoing_Deleted.ItemKey.Item.Unit
	|	END,
	|	GoodsInTransitOutgoing_Deleted.ItemKey.Item.Unit,
	|	GoodsInTransitOutgoing_Deleted.ItemKey.Unit,
	|	VALUE(Catalog.Units.EmptyRef),
	|	UNDEFINED
	|FROM
	|	GoodsInTransitOutgoing_Deleted
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList_Full.ShipmentBasis,
	|	ItemList_Full.Item,
	|	ItemList_Full.ItemKey,
	|	ItemList_Full.Store,
	|	ItemList_Full.LineNumber,
	|	ItemList_Full.BasisQuantity AS BasisQuantity,
	|	ItemList_Full.Unit AS Unit,
	|	ItemList_Full.ItemUnit AS ItemUnit,
	|	ItemList_Full.ItemKeyUnit AS ItemKeyUnit,
	|	ItemList_Full.BasisUnit AS BasisUnit,
	|	SUM(ItemList_Full.Quantity) AS Quantity
	|INTO ItemList_Full_Grouped
	|FROM
	|	ItemList_Full AS ItemList_Full
	|GROUP BY
	|	ItemList_Full.ShipmentBasis,
	|	ItemList_Full.Item,
	|	ItemList_Full.ItemKey,
	|	ItemList_Full.Store,
	|	ItemList_Full.LineNumber,
	|	ItemList_Full.Unit,
	|	ItemList_Full.BasisQuantity,
	|	ItemList_Full.ItemUnit,
	|	ItemList_Full.ItemKeyUnit,
	|	ItemList_Full.BasisUnit
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	GoodsInTransitOutgoingBalance.ItemKey.Item AS Item,
	|	GoodsInTransitOutgoingBalance.ItemKey AS ItemKey,
	|	GoodsInTransitOutgoingBalance.ShipmentBasis,
	|	SUM(GoodsInTransitOutgoingBalance.QuantityBalance) AS QuantityBalance,
	|	SUM(ItemList_Full_Grouped.Quantity) AS Quantity,
	|	-SUM(GoodsInTransitOutgoingBalance.QuantityBalance) AS LackOfBalance,
	|	ItemList_Full_Grouped.LineNumber AS LineNumber,
	|	ItemList_Full_Grouped.BasisQuantity AS BasisQuantity,
	|	ItemList_Full_Grouped.Unit AS Unit,
	|	ItemList_Full_Grouped.ItemUnit AS ItemUnit,
	|	ItemList_Full_Grouped.ItemKeyUnit AS ItemKeyUnit,
	|	ItemList_Full_Grouped.BasisUnit AS BasisUnit,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList_Full_Grouped AS ItemList_Full_Grouped
	|		INNER JOIN AccumulationRegister.GoodsInTransitOutgoing.Balance(, (ShipmentBasis, ItemKey, Store) IN
	|			(SELECT
	|				ItemList_Full_Grouped.ShipmentBasis AS ShipmentBasis,
	|				ItemList_Full_Grouped.ItemKey AS ItemKey,
	|				ItemList_Full_Grouped.Store AS Store
	|			FROM
	|				ItemList_Full_Grouped AS ItemList_Full_Grouped)) AS GoodsInTransitOutgoingBalance
	|		ON GoodsInTransitOutgoingBalance.ShipmentBasis = ItemList_Full_Grouped.ShipmentBasis
	|		AND GoodsInTransitOutgoingBalance.ItemKey = ItemList_Full_Grouped.ItemKey
	|		AND GoodsInTransitOutgoingBalance.Store = ItemList_Full_Grouped.Store
	|GROUP BY
	|	GoodsInTransitOutgoingBalance.ItemKey.Item,
	|	GoodsInTransitOutgoingBalance.ItemKey,
	|	ItemList_Full_Grouped.LineNumber,
	|	GoodsInTransitOutgoingBalance.ShipmentBasis,
	|	ItemList_Full_Grouped.Unit,
	|	ItemList_Full_Grouped.BasisQuantity,
	|	ItemList_Full_Grouped.ItemUnit,
	|	ItemList_Full_Grouped.ItemKeyUnit,
	|	ItemList_Full_Grouped.BasisUnit
	|HAVING
	|	SUM(GoodsInTransitOutgoingBalance.QuantityBalance) < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("GoodsInTransitOutgoing_Exists", Parameters.DocumentDataTables.GoodsInTransitOutgoing_Exists);
	Query.SetParameter("Unposting", ?(Parameters.Property("Unposting"), Parameters.Unposting, False));
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	HaveError = False;
	If QueryTable.Count() Then
		HaveError = True;
		
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "ShipmentBasis, ItemKey, Item, BasisUnit, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "BasisQuantity");
		ErrorParameters.Insert("FilterColumns", "ShipmentBasis, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Shipped");
		ErrorParameters.Insert("Excess", True);
		
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not HaveError;
EndFunction

Function GetExistsGoodsInTransitOutgoing(Ref, AddInfo = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	GoodsInTransitOutgoing.Store,
	|	GoodsInTransitOutgoing.ShipmentBasis,
	|	GoodsInTransitOutgoing.ItemKey,
	|	GoodsInTransitOutgoing.ItemKey.Item AS Item,
	|	GoodsInTransitOutgoing.RowKey,
	|	GoodsInTransitOutgoing.Quantity
	|FROM
	|	AccumulationRegister.GoodsInTransitOutgoing AS GoodsInTransitOutgoing
	|WHERE
	|	GoodsInTransitOutgoing.Recorder = &Recorder
	|	AND GoodsInTransitOutgoing.RecordType = &RecordType";
	Query.SetParameter("Recorder", Ref);
	Query.SetParameter("RecordType", AccumulationRecordType.Receipt);
	QueryResult = Query.Execute();
	Return QueryResult.Unload();
EndFunction

