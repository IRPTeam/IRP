#language: en
@tree
@Positive
@Movements
@MovementsSalesInvoice

Feature: check Sales invoice movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040130 preparation (Sales invoice)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Unpost SO closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		If "List" table contains lines Then
				| "Number" |
				| "1" |
			And I execute 1C:Enterprise script at server
 				| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.UndoPosting);" |
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load Bank receipt
		When Create document BankReceipt objects (check movements, advance)
		When Create document BankReceipt objects (advance, BR-SI)
		And I execute 1C:Enterprise script at server
 			| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		When Create document SalesOrder objects (SI more than SO)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |	
	
	* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);" |
	// * Check query for sales invoice movements
	// 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	// 	And in the table "Info" I click "Fill movements" button
	// 	And "Info" table contains lines
	// 		| 'Document'     | 'Register'                         | 'Recorder' | 'Conditions'                                                                                                                              | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Parameters'                                   | 'Receipt' | 'Expense' |
	// 		| 'SalesInvoice' | 'R2005T_SalesSpecialOffers'        | 'Yes'      | 'TRUE'                                                                                                                                    | 'SELECT\n    OffersInfo.Period AS Period,\n    OffersInfo.Invoice AS Invoice,\n    OffersInfo.RowKey AS RowKey,\n    OffersInfo.ItemKey AS ItemKey,\n    OffersInfo.Company AS Company,\n    OffersInfo.Currency AS Currency,\n    OffersInfo.SpecialOffer AS SpecialOffer,\n    OffersInfo.OffersAmount AS OffersAmount,\n    OffersInfo.SalesAmount AS SalesAmount,\n    OffersInfo.NetAmount AS NetAmount\nINTO R2005T_SalesSpecialOffers\nFROM\n    OffersInfo AS OffersInfo\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'SalesInvoice' | 'R5010B_ReconciliationStatement'   | 'Yes'      | ''                                                                                                                                        | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.LegalName AS LegalName,\n    ItemList.Currency AS Currency,\n    SUM(ItemList.Amount) AS Amount,\n    ItemList.Period AS Period\nINTO R5010B_ReconciliationStatement\nFROM\n    ItemList AS ItemList\n\nGROUP BY\n    ItemList.Company,\n    ItemList.LegalName,\n    ItemList.Currency,\n    ItemList.Period'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 		| 'SalesInvoice' | 'R4010B_ActualStocks'              | 'Yes'      | 'NOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nNOT ItemList.ShipmentConfirmationExists'                                   | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Quantity AS Quantity\nINTO R4010B_ActualStocks\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND NOT ItemList.ShipmentConfirmationExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2011B_SalesOrdersShipment'       | 'Yes'      | 'NOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nItemList.SalesOrderExists\nNOT ItemList.ShipmentConfirmationExists'        | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R2011B_SalesOrdersShipment\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND ItemList.SalesOrderExists\n    AND NOT ItemList.ShipmentConfirmationExists'                                                                                             | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R4050B_StockInventory'            | 'Yes'      | 'NOT ItemList.IsService'                                                                                                                  | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R4050B_StockInventory\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService'                                                                                                                                                                                                                                                                       | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2001T_Sales'                     | 'Yes'      | 'TRUE'                                                                                                                                    | 'SELECT\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R2001T_Sales\nFROM\n    ItemList AS ItemList\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                            | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'SalesInvoice' | 'R2021B_CustomersTransactions'     | 'Yes'      | 'Query Receipt:\nQuery Expense:'                                                                                                          | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    CustomersTransactions.Period AS Period,\n    CustomersTransactions.Company AS Company,\n    CustomersTransactions.Currency AS Currency,\n    CustomersTransactions.LegalName AS LegalName,\n    CustomersTransactions.Partner AS Partner,\n    CustomersTransactions.Agreement AS Agreement,\n    CustomersTransactions.TransactionDocument AS Basis,\n    SUM(CustomersTransactions.DocumentAmount) AS Amount\nINTO R2021B_CustomersTransactions\nFROM\n    CustomersTransactions AS CustomersTransactions\n\nGROUP BY\n    CustomersTransactions.Period,\n    CustomersTransactions.Company,\n    CustomersTransactions.Currency,\n    CustomersTransactions.LegalName,\n    CustomersTransactions.Partner,\n    CustomersTransactions.Agreement,\n    CustomersTransactions.TransactionDocument\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    OffsetOfAdvance.Period,\n    OffsetOfAdvance.Company,\n    OffsetOfAdvance.Currency,\n    OffsetOfAdvance.LegalName,\n    OffsetOfAdvance.Partner,\n    OffsetOfAdvance.Agreement,\n    OffsetOfAdvance.TransactionDocument,\n    SUM(OffsetOfAdvance.Amount)\nFROM\n    OffsetOfAdvance AS OffsetOfAdvance\n\nGROUP BY\n    OffsetOfAdvance.Period,\n    OffsetOfAdvance.Company,\n    OffsetOfAdvance.Currency,\n    OffsetOfAdvance.LegalName,\n    OffsetOfAdvance.Partner,\n    OffsetOfAdvance.Agreement,\n    OffsetOfAdvance.TransactionDocument'                                                                                                | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
	// 		| 'SalesInvoice' | 'R4011B_FreeStocks'                | 'Yes'      | 'ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)'                                                                        | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemListGroup.Period AS Period,\n    ItemListGroup.Store AS Store,\n    ItemListGroup.ItemKey AS ItemKey,\n    ItemListGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity\nINTO R4011B_FreeStocks\nFROM\n    ItemListGroup AS ItemListGroup\n        LEFT JOIN TmpStockReservation AS TmpStockReservation\n        ON ItemListGroup.Store = TmpStockReservation.Store\n            AND ItemListGroup.ItemKey = TmpStockReservation.ItemKey\n            AND (TmpStockReservation.Basis = ItemListGroup.SalesOrder)\nWHERE\n    ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R4032B_GoodsInTransitOutgoing'    | 'Yes'      | 'NOT ItemList.IsService\n(ItemList.UseShipmentConfirmation\n    OR ItemList.ShipmentConfirmationExists)'                                  | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    CASE\n        WHEN ItemList.ShipmentConfirmationExists\n            THEN ItemList.ShipmentConfirmation\n        ELSE ItemList.Invoice\n    END AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R4032B_GoodsInTransitOutgoing\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND (ItemList.UseShipmentConfirmation\n            OR ItemList.ShipmentConfirmationExists)' | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 		| 'SalesInvoice' | 'R4012B_StockReservation'          | 'Yes'      | ''                                                                                                                                        | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemListGroup.Period AS Period,\n    ItemListGroup.SalesOrder AS Order,\n    ItemListGroup.ItemKey AS ItemKey,\n    ItemListGroup.Store AS Store,\n    CASE\n        WHEN StockReservation.QuantityBalance > ItemListGroup.Quantity\n            THEN ItemListGroup.Quantity\n        ELSE StockReservation.QuantityBalance\n    END AS Quantity\nINTO R4012B_StockReservation\nFROM\n    TmpItemListGroup AS ItemListGroup\n        INNER JOIN TmpStockReservation AS StockReservation\n        ON ItemListGroup.SalesOrder = StockReservation.Order\n            AND ItemListGroup.ItemKey = StockReservation.ItemKey\n            AND ItemListGroup.Store = StockReservation.Store'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2013T_SalesOrdersProcurement'    | 'Yes'      | 'NOT ItemList.IsService\nItemList.SalesOrderExists'                                                                                       | 'SELECT\n    ItemList.Quantity AS SalesQuantity,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R2013T_SalesOrdersProcurement\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND ItemList.SalesOrderExists'                                                                                                                                                                                                          | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'SalesInvoice' | 'R5011B_PartnersAging'             | 'Yes'      | 'Query Receipt:\nQuery Expense:'                                                                                                          | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    Aging.Period AS Period,\n    Aging.Company AS Company,\n    Aging.Currency AS Currency,\n    Aging.Agreement AS Agreement,\n    Aging.Partner AS Partner,\n    Aging.Invoice AS Invoice,\n    Aging.PaymentDate AS PaymentDate,\n    Aging.Amount AS Amount\nINTO R5011B_PartnersAging\nFROM\n    Aging AS Aging\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    OffsetOfAging.Period,\n    OffsetOfAging.Company,\n    OffsetOfAging.Currency,\n    OffsetOfAging.Agreement,\n    OffsetOfAging.Partner,\n    OffsetOfAging.Invoice,\n    OffsetOfAging.PaymentDate,\n    OffsetOfAging.Amount\nFROM\n    OffsetOfAging AS OffsetOfAging'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2020B_AdvancesFromCustomers'     | 'Yes'      | ''                                                                                                                                        | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    OffsetOfAdvance.Period AS Period,\n    OffsetOfAdvance.Company AS Company,\n    OffsetOfAdvance.Currency AS Currency,\n    OffsetOfAdvance.LegalName AS LegalName,\n    OffsetOfAdvance.Partner AS Partner,\n    OffsetOfAdvance.AdvancesDocument AS Basis,\n    SUM(OffsetOfAdvance.Amount) AS Amount\nINTO R2020B_AdvancesFromCustomers\nFROM\n    OffsetOfAdvance AS OffsetOfAdvance\n\nGROUP BY\n    OffsetOfAdvance.Period,\n    OffsetOfAdvance.Company,\n    OffsetOfAdvance.Currency,\n    OffsetOfAdvance.LegalName,\n    OffsetOfAdvance.Partner,\n    OffsetOfAdvance.AdvancesDocument'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2040B_TaxesIncoming'             | 'Yes'      | 'TRUE'                                                                                                                                    | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    Taxes.Period AS Period,\n    Taxes.Company AS Company,\n    Taxes.Tax AS Tax,\n    Taxes.TaxRate AS TaxRate,\n    Taxes.TaxAmount AS TaxAmount,\n    Taxes.TaxableAmount AS TaxableAmount\nINTO R2040B_TaxesIncoming\nFROM\n    Taxes AS Taxes\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 		| 'SalesInvoice' | 'R4034B_GoodsShipmentSchedule'     | 'Yes'      | 'NOT ItemList.IsService\nNOT ItemList.UseShipmentConfirmation\nItemList.SalesOrderExists\nItemList.SalesOrder.UseItemsShipmentScheduling' | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R4034B_GoodsShipmentSchedule\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsService\n    AND NOT ItemList.UseShipmentConfirmation\n    AND ItemList.SalesOrderExists\n    AND ItemList.SalesOrder.UseItemsShipmentScheduling'                                                                                    | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R4014B_SerialLotNumber'           | 'Yes'      | 'TRUE'                                                                                                                                    | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    SerialLotNumbers.Period AS Period,\n    SerialLotNumbers.Company AS Company,\n    SerialLotNumbers.Key AS Key,\n    SerialLotNumbers.SerialLotNumber AS SerialLotNumber,\n    SerialLotNumbers.Quantity AS Quantity,\n    SerialLotNumbers.ItemKey AS ItemKey\nINTO R4014B_SerialLotNumber\nFROM\n    SerialLotNumbers AS SerialLotNumbers\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2031B_ShipmentInvoicing'         | 'Yes'      | 'Query Receipt:\nItemList.UseShipmentConfirmation\nNOT ItemList.ShipmentConfirmationExists\nQuery Expense:\nTRUE'                         | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Invoice AS Basis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Company AS Company,\n    ItemList.Period AS Period,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Store AS Store\nINTO R2031B_ShipmentInvoicing\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.UseShipmentConfirmation\n    AND NOT ItemList.ShipmentConfirmationExists\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    ShipmentConfirmations.ShipmentConfirmation,\n    ShipmentConfirmations.Quantity,\n    ItemList.Company,\n    ItemList.Period,\n    ItemList.ItemKey,\n    ItemList.Store\nFROM\n    ItemList AS ItemList\n        INNER JOIN ShipmentConfirmationsInfo AS ShipmentConfirmations\n        ON ItemList.RowKey = ShipmentConfirmations.Key\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
	// 		| 'SalesInvoice' | 'R2012B_SalesOrdersInvoiceClosing' | 'Yes'      | 'ItemList.SalesOrderExists'                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ShipmentConfirmationExists AS ShipmentConfirmationExists,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.Invoice AS Invoice,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Amount AS Amount,\n    ItemList.Partner AS Partner,\n    ItemList.LegalName AS LegalName,\n    ItemList.Agreement AS Agreement,\n    ItemList.Currency AS Currency,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.IsService AS IsService,\n    ItemList.BusinessUnit AS BusinessUnit,\n    ItemList.RevenueType AS RevenueType,\n    ItemList.AdditionalAnalytic AS AdditionalAnalytic,\n    ItemList.BasisDocument AS BasisDocument,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation\nINTO R2012B_SalesOrdersInvoiceClosing\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesOrderExists'                                                                                                                                                                                                                      | 'Ref: Sales invoice\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
		And I close all client application windows

//1


Scenario: _0401311 check Sales invoice movements by the Register  "R2005 Sales special offers" SO-SC-SI (with special offers)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| 'Document registrations records'            | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| 'Register  "R2005 Sales special offers"'    | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| ''                                          | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
			| ''                                          | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Special offer'    |
			| ''                                          | '28.01.2021 18:48:53' | '16,26'        | '13,78'      | '0,86'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '84,57'        | '71,67'      | '4,45'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '569,24'       | '482,41'     | '29,96'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			
		And I close all client application windows
		
Scenario: _040132 check Sales invoice movements by the Register  "R5010 Reconciliation statement"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'TRY'        | 'Main Company' | 'Company Ferron BP' |	
		And I close all client application windows
		
Scenario: _040133 check Sales invoice movements by the Register  "R4010 Actual stocks" (use SC, SC first)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'           |
			
		And I close all client application windows
		
Scenario: _040134 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2011 Shipment of sales orders"' |
		And I close all client application windows
		
Scenario: _040135 check Sales invoice movements by the Register  "R4050 Stock inventory"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'         | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Store 02' | '36/Red'   |
			
		And I close all client application windows
		
Scenario: _040136 check Sales invoice movements by the Register  "R2001 Sales"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Document registrations records'            | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Register  "R2001 Sales"'                   | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '16,26'  | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '84,57'  | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '569,24' | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			
		And I close all client application windows
		
Scenario: _040137 check Sales invoice movements by the Register  "R2021 Customer transactions"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '670,08'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			
		And I close all client application windows
		
Scenario: _040138 check Sales invoice movements by the Register  "R4011 Free stocks" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'             |
		And I close all client application windows
		
Scenario: _040139 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows
		
Scenario: _040140 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" SO-SC-SI (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'     | ''            | ''                    | ''          | ''           | ''                                                  | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                                  | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                                  | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                                  | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                             | 'Item key' |
			| ''                                              | 'Receipt'     | '28.01.2021 18:48:53' | '1'         | 'Store 02'   | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '28.01.2021 18:48:53' | '10'        | 'Store 02'   | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | '36/Red'   |
		And I close all client application windows
		
Scenario: _040141 check Sales invoice movements by the Register  "R5011 Partners aging" (without aging)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5011 Partners aging"
		And I click "Registrations report" button
		And I select "R5011 Partners aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5011 Partners aging"'                     |
			
		And I close all client application windows
		
Scenario: _040142 check Sales invoice movements by the Register  "R2020 Advances from customer" (without advances)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'                     |
			
		And I close all client application windows
		
Scenario: _040143 check Sales invoice movements by the Register  "R2040 Taxes incoming"
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'          | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''    | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '80,51'          | '14,49'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '418,64'         | '75,36'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '2 817,8'        | '507,2'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			
		And I close all client application windows
		
Scenario: _040144 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'                     |
			
		And I close all client application windows
		
Scenario: _040145 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (without serial lot numbers)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'                     |
			
		And I close all client application windows
		
Scenario: _040146 check Sales invoice movements by the Register  "R2031 Shipment invoicing" SO-SC-SI
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                  | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'        | 'Basis'                                             | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Store 02'     | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Store 02'     | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | '36/Red'   |	
		And I close all client application windows
		
Scenario: _040147 check Sales invoice movements by the Register  "R2012 Invoice closing of sales orders" (SO exists)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
		And I close all client application windows

//2


		
Scenario: _0401442 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"' | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                   | 'Store'    | 'Item key' | 'Row key'                              |
			| ''                                            | 'Expense'     | '28.01.2021 18:49:39' | '5'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                            | 'Expense'     | '28.01.2021 18:49:39' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
	
		And I close all client application windows
		
Scenario: _0401443 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"' |
		And I close all client application windows

Scenario: _0401444 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"' |
		And I close all client application windows

Scenario: _0401445 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SC-SI, SI,SC>SO)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"' |
		And I close all client application windows	

//3


		
		
Scenario: _0401333 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SI-SC, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4010 Actual stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | '37/18SD'  |
			
		And I close all client application windows
		
Scenario: _0401343 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" (SO-SI, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'  | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                           | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  |
			
		And I close all client application windows
	
		
		
Scenario: _0401383 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SI-SC, PM - Not Stock)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'             | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | '37/18SD'  |
		And I close all client application windows 

Scenario: _0401384 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SI-SC (use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows

Scenario: _0401385 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" SO-SI-SC (use and not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '28.01.2021 18:50:57' | '1'         | 'Store 02'   | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '28.01.2021 18:50:57' | '10'        | 'Store 02'   | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   |
		And I close all client application windows


//4

Scenario: _0401314 check Sales invoice movements by the Register  "R5011 Partners aging" (use Aging)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R5011 Partners aging"
		And I click "Registrations report" button
		And I select "R5011 Partners aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''         | ''                          | ''        | ''                                          | ''                    |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''                          | ''        | ''                                          | ''                    |
			| 'Register  "R5011 Partners aging"'          | ''            | ''                    | ''          | ''             | ''         | ''                          | ''        | ''                                          | ''                    |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                          | ''        | ''                                          | ''                    |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Currency' | 'Agreement'                 | 'Partner' | 'Invoice'                                   | 'Payment date'        |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '23 374'    | 'Main Company' | 'USD'      | 'Personal Partner terms, $' | 'Kalipso' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '23.02.2021 00:00:00' |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10 000'    | 'Main Company' | 'USD'      | 'Personal Partner terms, $' | 'Kalipso' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '23.02.2021 00:00:00' |
		And I close all client application windows 


Scenario: _0401315 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (use Serial lot number)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'      | ''            | ''                    | ''          | ''             | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Serial lot number' |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10'        | 'Main Company' | '36/Red'   | '0512'              |
		And I close all client application windows 

Scenario: _0401316 check Sales invoice movements by the Register  "R2020 Advances from customer" (with advance, BR-SI, Ignore advance - False)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                | ''        | ''                                         | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                | ''        | ''                                         | ''                     |
			| 'Register  "R2020 Advances from customer"'  | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                | ''        | ''                                         | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                | ''        | ''                                         | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'      | 'Partner' | 'Basis'                                    | 'Deferred calculation' |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10 000'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Bank receipt 11 dated 15.02.2021 11:20:08' | 'No'                   |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10 000'    | 'Main Company' | 'en description is empty'      | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Bank receipt 11 dated 15.02.2021 11:20:08' | 'No'                   |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '56 275'    | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Kalipso' | 'Kalipso' | 'Bank receipt 11 dated 15.02.2021 11:20:08' | 'No'                   |
		And I close all client application windows 

Scenario: _0401320 check Sales invoice movements by the Register  "R4012 Stock Reservation" (without SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'       | 
		And I close all client application windows

Scenario: _0401317 check Sales invoice movements by the Register  "R2031 Shipment invoicing" (SI first, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''             | ''         | ''                                          | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''                                          | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''         | ''                                          | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                          | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                     | 'Item key' |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '1'         | 'Main Company' | 'Store 02' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'XS/Blue'  |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '24'        | 'Main Company' | 'Store 02' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '37/18SD'  |
		And I close all client application windows

Scenario: _0401318 check Sales invoice movements by the Register  "R4011 Free stocks" (SI first, not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'             | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '20'        | 'Store 02'   | '36/Red'   |
		And I close all client application windows

Scenario: _0401319 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI first, use and not use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '16.02.2021 10:59:49' | '1'         | 'Store 02'   | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '16.02.2021 10:59:49' | '24'        | 'Store 02'   | 'Sales invoice 4 dated 16.02.2021 10:59:49' | '37/18SD'  |
		And I close all client application windows

//8 SI>SO

Scenario: _0401325 check Sales invoice movements by the Register  "R4011 Free stocks" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'             |
		And I close all client application windows
	
Scenario: _0401326 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'             |
		And I close all client application windows


Scenario: _0401327 check Sales invoice movements by the Register  "R4032 Goods in transit (outgoing)" (SI >SO, use SC)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '8' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 8 dated 18.02.2021 10:48:46'     | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"' | ''            | ''                    | ''          | ''           | ''                                          | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                          | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                     | 'Item key' |
			| ''                                              | 'Receipt'     | '18.02.2021 10:48:46' | '10'        | 'Store 02'   | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'XS/Blue'  |
			| ''                                              | 'Receipt'     | '18.02.2021 10:48:46' | '15'        | 'Store 02'   | 'Sales invoice 8 dated 18.02.2021 10:48:46' | 'XS/Blue'  |
		And I close all client application windows

Scenario: _0401328 check Sales invoice movements by the Register  "R2020 Advances from customer" (with advance, BR-SI, Ignore advance - True)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '9' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'             |
		And I close all client application windows 

Scenario: _0401331 check Sales invoice movements by the Register  "R2021 Customer transactions" (with advance, BR-SI, Ignore advance - True)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '9' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 9 dated 15.04.2021 14:53:05' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''           | ''        | ''                 | ''                                          | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                             | ''         | ''           | ''        | ''                 | ''                                          | ''                     |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''          | ''             | ''                             | ''         | ''           | ''        | ''                 | ''                                          | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''           | ''        | ''                 | ''                                          | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name' | 'Partner' | 'Agreement'        | 'Basis'                                     | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '15.04.2021 14:53:05' | '202,02'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'DFC'        | 'DFC'     | 'Partner term DFC' | 'Sales invoice 9 dated 15.04.2021 14:53:05' | 'No'                   |
			| ''                                          | 'Receipt'     | '15.04.2021 14:53:05' | '1 180'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'DFC'        | 'DFC'     | 'Partner term DFC' | 'Sales invoice 9 dated 15.04.2021 14:53:05' | 'No'                   |
			| ''                                          | 'Receipt'     | '15.04.2021 14:53:05' | '1 180'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'DFC'        | 'DFC'     | 'Partner term DFC' | 'Sales invoice 9 dated 15.04.2021 14:53:05' | 'No'                   |
			| ''                                          | 'Receipt'     | '15.04.2021 14:53:05' | '1 180'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'DFC'        | 'DFC'     | 'Partner term DFC' | 'Sales invoice 9 dated 15.04.2021 14:53:05' | 'No'                   |
		And I close all client application windows 

Scenario: _0401332 check Sales invoice movements by the Register  "R2021 Customer transactions" (with advance, BR-SI, Ignore advance - False)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 4 dated 16.02.2021 10:59:49' | ''            | ''                    | ''           | ''             | ''                             | ''         | ''                | ''        | ''                          | ''                                          | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''           | ''             | ''                             | ''         | ''                | ''        | ''                          | ''                                          | ''                     |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''           | ''             | ''                             | ''         | ''                | ''        | ''                          | ''                                          | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources'  | 'Dimensions'   | ''                             | ''         | ''                | ''        | ''                          | ''                                          | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'     | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'      | 'Partner' | 'Agreement'                 | 'Basis'                                     | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '23 374'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '23 374'     | 'Main Company' | 'USD'                          | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '23 374'     | 'Main Company' | 'en description is empty'      | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Receipt'     | '16.02.2021 10:59:49' | '131 537,19' | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10 000'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10 000'     | 'Main Company' | 'USD'                          | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '10 000'     | 'Main Company' | 'en description is empty'      | 'USD'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
			| ''                                          | 'Expense'     | '16.02.2021 10:59:49' | '56 275'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Kalipso' | 'Kalipso' | 'Personal Partner terms, $' | 'Sales invoice 4 dated 16.02.2021 10:59:49' | 'No'                   |
		And I close all client application windows 


Scenario: _0401429 Sales invoice clear posting/mark for deletion
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4050 Stock inventory' |
			| 'R2001 Sales' |
			| 'R2021 Customer transactions' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4050 Stock inventory' |
			| 'R2001 Sales' |
			| 'R2021 Customer transactions' |
		And I close all client application windows