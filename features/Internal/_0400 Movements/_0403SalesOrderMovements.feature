#language: en
@tree
@Positive
@Movements
@MovementsSalesOrder


Feature: check Sales order movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040148 preparation (sales order movements)
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
		When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
		When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)

		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	* Check query for sales order movements
		Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
		And in the table "Info" I click "Fill movements" button
		And "Info" table contains lines
			| 'Document'   | 'Register'                         | 'Recorder' | 'Conditions'                                                                                                                          | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         | 'Parameters'                   | 'Receipt' | 'Expense' |
			| 'SalesOrder' | 'R2010T_SalesOrders'               | 'Yes'      | 'NOT ItemList.IsCanceled'                                                                                                             | 'SELECT\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R2010T_SalesOrders\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled'                                                                                                                                                                                                                                                                              | 'StatusInfoPosting: Structure' | 'No'      | 'No'      |
			| 'SalesOrder' | 'R2014T_CanceledSalesOrders'       | 'Yes'      | 'ItemList.IsCanceled'                                                                                                                 | 'SELECT\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R2014T_CanceledSalesOrders\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.IsCanceled'                                                                                                                                                                                                                                                                          | 'StatusInfoPosting: Structure' | 'No'      | 'No'      |
			| 'SalesOrder' | 'R4013B_StockReservationPlanning'  | 'Yes'      | 'FALSE'                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R4013B_StockReservationPlanning\nFROM\n    ItemList AS ItemList\nWHERE\n    FALSE'                                                                                                                                                                                                                         | 'StatusInfoPosting: Structure' | 'Yes'     | 'No'      |
			| 'SalesOrder' | 'R2011B_SalesOrdersShipment'       | 'Yes'      | 'NOT ItemList.IsCanceled\nNOT ItemList.IsService'                                                                                     | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R2011B_SalesOrdersShipment\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled\n    AND NOT ItemList.IsService'                                                                                                                                                                            | 'StatusInfoPosting: Structure' | 'Yes'     | 'No'      |
			| 'SalesOrder' | 'R4011B_FreeStocks'                | 'Yes'      | 'NOT ItemList.IsCanceled\nNOT ItemList.IsService\nItemList.IsProcurementMethod_Stock'                                                 | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R4011B_FreeStocks\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled\n    AND NOT ItemList.IsService\n    AND ItemList.IsProcurementMethod_Stock'                                                                                                                                         | 'StatusInfoPosting: Structure' | 'No'      | 'Yes'     |
			| 'SalesOrder' | 'R4012B_StockReservation'          | 'Yes'      | 'NOT ItemList.IsCanceled\nNOT ItemList.IsService\nItemList.IsProcurementMethod_Stock'                                                 | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R4012B_StockReservation\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled\n    AND NOT ItemList.IsService\n    AND ItemList.IsProcurementMethod_Stock'                                                                                                                                   | 'StatusInfoPosting: Structure' | 'Yes'     | 'No'      |
			| 'SalesOrder' | 'R2013T_SalesOrdersProcurement'    | 'Yes'      | 'NOT ItemList.IsCanceled\nNOT ItemList.IsService\nItemList.IsProcurementMethod_Purchase'                                              | 'SELECT\n    ItemList.Quantity AS OrderedQuantity,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R2013T_SalesOrdersProcurement\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled\n    AND NOT ItemList.IsService\n    AND ItemList.IsProcurementMethod_Purchase'                                                                                                                                         | 'StatusInfoPosting: Structure' | 'No'      | 'No'      |
			| 'SalesOrder' | 'R4034B_GoodsShipmentSchedule'     | 'Yes'      | 'NOT ItemList.IsCanceled\nNOT ItemList.IsService\nNOT ItemList.DeliveryDate = DATETIME(1, 1, 1)\nItemList.UseItemsShipmentScheduling' | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.DeliveryDate AS Period,\n    ItemList.Order AS Basis,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period1,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R4034B_GoodsShipmentSchedule\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled\n    AND NOT ItemList.IsService\n    AND NOT ItemList.DeliveryDate = DATETIME(1, 1, 1)\n    AND ItemList.UseItemsShipmentScheduling' | 'StatusInfoPosting: Structure' | 'Yes'     | 'No'      |
			| 'SalesOrder' | 'R2012B_SalesOrdersInvoiceClosing' | 'Yes'      | 'NOT ItemList.IsCanceled'                                                                                                             | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    ItemList.Store AS Store,\n    ItemList.UseShipmentConfirmation AS UseShipmentConfirmation,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Order AS Order,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Item AS Item,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.DeliveryDate AS DeliveryDate,\n    ItemList.ProcurementMethod AS ProcurementMethod,\n    ItemList.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    ItemList.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    ItemList.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    ItemList.IsService AS IsService,\n    ItemList.Amount AS Amount,\n    ItemList.Currency AS Currency,\n    ItemList.IsCanceled AS IsCanceled,\n    ItemList.CancelReason AS CancelReason,\n    ItemList.NetAmount AS NetAmount,\n    ItemList.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    ItemList.OffersAmount AS OffersAmount,\n    ItemList.StatusInfoPosting AS StatusInfoPosting\nINTO R2012B_SalesOrdersInvoiceClosing\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.IsCanceled'                                                                                                                                                                                                      | 'StatusInfoPosting: Structure' | 'Yes'     | 'No'      |
		And I close all client application windows

	

Scenario: _040149 check Sales order movements by the Register  "R2010 Sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2010 Sales orders" 
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| 'Register  "R2010 Sales orders"'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key' | 'Row key'                              | 'Procurement method' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
		And I close all client application windows
		
Scenario: _040150 check Sales order movements by the Register  "R2014 Canceled sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2014 Canceled sales orders" 
		And I click "Registrations report" button
		And I select "R2014 Canceled sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Register  "R2014 Canceled sales orders"' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key'  | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '325,28' | '275,66'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |

		And I close all client application windows
		
// Scenario: _040151 check Sales order movements by the Register  "R4013 Stock Reservation planning"
// 	* Select Sales order
// 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '1' |
// 	* Check movements by the Register  "R4013 Stock Reservation planning" 
// 		And I click "Registrations report" button
// 		And I select "R4013 Stock Reservation planning" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Sales order 1 dated *'					 	  | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Register  "R4013 Stock Reservation planning"'                     | ''            | ''                    | ''          | ''           | ''          |
			
// 		And I close all client application windows
		
Scenario: _040152 check Sales order movements by the Register  "R2011 Shipment of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'    | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  |

		And I close all client application windows
		
Scenario: _040153 check Sales order movements by the Register  "R4011 Free stocks"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                        | 'Expense'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  |
	
		And I close all client application windows
		
Scenario: _040154 check Sales order movements by the Register  "R4012 Stock Reservation"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4012 Stock Reservation" 
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Register  "R4012 Stock Reservation"'     | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                        |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                   |
			| ''                                        | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  | 'Sales order 1 dated 27.01.2021 19:50:45' |

		And I close all client application windows
		
Scenario: _040155 check Sales order movements by the Register  "R2013 Procurement of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'       | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '27.01.2021 19:50:45' | '24'               | ''                    | ''                  | ''                 | ''                 | ''               | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  |
	
		And I close all client application windows
		
Scenario: _040156 check Sales order movements by the Register  "R4034 Scheduled goods shipments"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4034 Scheduled goods shipments" 
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'     | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R4034 Scheduled goods shipments"' | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                   | 'Store'    | 'Item key' | 'Row key'                              |
			| ''                                            | 'Receipt'     | '27.01.2021 00:00:00' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                            | 'Receipt'     | '27.01.2021 00:00:00' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                            | 'Receipt'     | '27.01.2021 00:00:00' | '24'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' |
		And I close all client application windows
		
Scenario: _040157 check Sales order movements by the Register  "R2012 Invoice closing of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders" 
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'           | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' |

		And I close all client application windows

//SO 2
			
		
		
		
Scenario: _0401562 check Sales order movements by the Register  "R4034 Scheduled goods shipments"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4034 Scheduled goods shipments" 
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4034 Scheduled goods shipments" |
		And I close all client application windows

Scenario: _0401563 check Sales order movements by the Register  "R4011 Free stocks"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                        | 'Expense'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  |
			| ''                                        | 'Expense'     | '27.01.2021 19:50:45' | '2'         | 'Store 02'   | 'XS/Blue'  |
		And I close all client application windows


Scenario: _0401573 Sales order clear posting/mark for deletion
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2010 Sales orders' |
			| 'R4011 Free stocks' |
			| 'Register  "R2011 Shipment of sales orders' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
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
			| 'Sales order 1 dated 27.01.2021 19:50:45' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
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
			| 'R2010 Sales orders' |
			| 'R4011 Free stocks' |
			| 'Register  "R2011 Shipment of sales orders' |
		And I close all client application windows
	

		