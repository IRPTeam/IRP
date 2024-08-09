#language: en
@tree
@Positive
@Movements
@MovementsShipmentConfirmation

Feature: check Shipment confirmation


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040170 preparation (Shipment confirmation)
	When set True value to the constant
	* Unpost SO closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		If "List" table contains lines Then
				| "Number"     |
				| "1"          |
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.UndoPosting);"     |
		And I close all client application windows
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
		When Create catalog Countries objects
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create document ShipmentConfirmation (stock control serial lot numbers)
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Shipment confirmation
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
	// * Check query for Shipment confirmation movements
	// 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	// 	And in the table "Info" I click "Fill movements" button
	// 	And "Info" table contains lines
	// 		| 'Document'             | 'Register'                           | 'Recorder' | 'Conditions'                                                                                                                                                                     | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 'Parameters'                                           | 'Receipt' | 'Expense' |
	// 		| 'ShipmentConfirmation' | 'R4010B_ActualStocks'                | 'Yes'      | 'TRUE'                                                                                                                                                                           | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.SalesInvoiceExists AS SalesInvoiceExists,\n    ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,\n    ItemList.PurchaseReturnOrderExists AS PurchaseReturnOrderExists,\n    ItemList.PurchaseReturn AS PurchaseReturn,\n    ItemList.PurchaseReturnExists AS PurchaseReturnExists,\n    ItemList.InventoryTransferOrder AS InventoryTransferOrder,\n    ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,\n    ItemList.InventoryTransfer AS InventoryTransfer,\n    ItemList.InventoryTransferExists AS InventoryTransferExists,\n    ItemList.IsTransaction_Sales AS IsTransaction_Sales,\n    ItemList.IsTransaction_ReturnToVendor AS IsTransaction_ReturnToVendor,\n    ItemList.IsTransaction_InventoryTransfer AS IsTransaction_InventoryTransfer\nINTO R4010B_ActualStocks\nFROM\n    ItemList AS ItemList\nWHERE\n    TRUE'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R4022B_StockTransferOrdersShipment' | 'Yes'      | 'ItemList.InventoryTransferOrderExists'                                                                                                                                          | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.InventoryTransferOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.SalesInvoiceExists AS SalesInvoiceExists,\n    ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,\n    ItemList.PurchaseReturnOrderExists AS PurchaseReturnOrderExists,\n    ItemList.PurchaseReturn AS PurchaseReturn,\n    ItemList.PurchaseReturnExists AS PurchaseReturnExists,\n    ItemList.InventoryTransferOrder AS InventoryTransferOrder,\n    ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,\n    ItemList.InventoryTransfer AS InventoryTransfer,\n    ItemList.InventoryTransferExists AS InventoryTransferExists,\n    ItemList.IsTransaction_Sales AS IsTransaction_Sales,\n    ItemList.IsTransaction_ReturnToVendor AS IsTransaction_ReturnToVendor,\n    ItemList.IsTransaction_InventoryTransfer AS IsTransaction_InventoryTransfer\nINTO R4022B_StockTransferOrdersShipment\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.InventoryTransferOrderExists'                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R2011B_SalesOrdersShipment'         | 'Yes'      | 'ItemList.SalesOrderExists'                                                                                                                                                      | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.SalesInvoiceExists AS SalesInvoiceExists,\n    ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,\n    ItemList.PurchaseReturnOrderExists AS PurchaseReturnOrderExists,\n    ItemList.PurchaseReturn AS PurchaseReturn,\n    ItemList.PurchaseReturnExists AS PurchaseReturnExists,\n    ItemList.InventoryTransferOrder AS InventoryTransferOrder,\n    ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,\n    ItemList.InventoryTransfer AS InventoryTransfer,\n    ItemList.InventoryTransferExists AS InventoryTransferExists,\n    ItemList.IsTransaction_Sales AS IsTransaction_Sales,\n    ItemList.IsTransaction_ReturnToVendor AS IsTransaction_ReturnToVendor,\n    ItemList.IsTransaction_InventoryTransfer AS IsTransaction_InventoryTransfer\nINTO R2011B_SalesOrdersShipment\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesOrderExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R4011B_FreeStocks'                  | 'Yes'      | 'ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)'                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemListGroup.Period AS Period,\n    ItemListGroup.Store AS Store,\n    ItemListGroup.ItemKey AS ItemKey,\n    ItemListGroup.Quantity - ISNULL(TmpStockReservation.Quantity, 0) AS Quantity\nINTO R4011B_FreeStocks\nFROM\n    ItemListGroup AS ItemListGroup\n        LEFT JOIN TmpStockReservation AS TmpStockReservation\n        ON ItemListGroup.Store = TmpStockReservation.Store\n            AND ItemListGroup.ItemKey = TmpStockReservation.ItemKey\n            AND (TmpStockReservation.Basis = ItemListGroup.SalesOrder\n                OR TmpStockReservation.Basis = ItemListGroup.SalesInvoice\n                OR TmpStockReservation.Basis = ItemListGroup.InventoryTransferOrder)\nWHERE\n    ItemListGroup.Quantity > ISNULL(TmpStockReservation.Quantity, 0)'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R4032B_GoodsInTransitOutgoing'      | 'Yes'      | 'TRUE'                                                                                                                                                                           | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    CASE\n        WHEN ItemList.IsTransaction_Sales\n                AND ItemList.SalesInvoiceExists\n            THEN ItemList.SalesInvoice\n        WHEN ItemList.IsTransaction_InventoryTransfer\n                AND ItemList.InventoryTransferExists\n            THEN ItemList.InventoryTransfer\n        WHEN ItemList.IsTransaction_ReturnToVendor\n                AND ItemList.PurchaseReturnExists\n            THEN ItemList.PurchaseReturn\n        ELSE ItemList.ShipmentConfirmation\n    END AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.SalesInvoiceExists AS SalesInvoiceExists,\n    ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,\n    ItemList.PurchaseReturnOrderExists AS PurchaseReturnOrderExists,\n    ItemList.PurchaseReturn AS PurchaseReturn,\n    ItemList.PurchaseReturnExists AS PurchaseReturnExists,\n    ItemList.InventoryTransferOrder AS InventoryTransferOrder,\n    ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,\n    ItemList.InventoryTransfer AS InventoryTransfer,\n    ItemList.InventoryTransferExists AS InventoryTransferExists,\n    ItemList.IsTransaction_Sales AS IsTransaction_Sales,\n    ItemList.IsTransaction_ReturnToVendor AS IsTransaction_ReturnToVendor,\n    ItemList.IsTransaction_InventoryTransfer AS IsTransaction_InventoryTransfer\nINTO R4032B_GoodsInTransitOutgoing\nFROM\n    ItemList AS ItemList\nWHERE\n    TRUE' | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R1031B_ReceiptInvoicing'            | 'Yes'      | 'Query Receipt:\nNOT ItemList.PurchaseReturnExists\nItemList.IsTransaction_ReturnToVendor\nQuery Expense:\nItemList.PurchaseReturnExists\nItemList.IsTransaction_ReturnToVendor' | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.ShipmentConfirmation AS Basis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Company AS Company,\n    ItemList.Period AS Period,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Store AS Store\nINTO R1031B_ReceiptInvoicing\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.PurchaseReturnExists\n    AND ItemList.IsTransaction_ReturnToVendor\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    ItemList.PurchaseReturn,\n    ItemList.Quantity,\n    ItemList.Company,\n    ItemList.Period,\n    ItemList.ItemKey,\n    ItemList.Store\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.PurchaseReturnExists\n    AND ItemList.IsTransaction_ReturnToVendor'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R4012B_StockReservation'            | 'Yes'      | ''                                                                                                                                                                               | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.Period AS Period,\n    ItemList.SalesOrder AS Order,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Store AS Store,\n    CASE\n        WHEN StockReservation.QuantityBalance > ItemList.Quantity\n            THEN ItemList.Quantity\n        ELSE StockReservation.QuantityBalance\n    END AS Quantity\nINTO R4012B_StockReservation\nFROM\n    ItemListGroup AS ItemList\n        INNER JOIN TmpStockReservation AS StockReservation\n        ON (ItemList.SalesOrder = StockReservation.Order\n                OR ItemList.SalesInvoice = StockReservation.Order\n                OR ItemList.InventoryTransferOrder = StockReservation.Order)\n            AND ItemList.ItemKey = StockReservation.ItemKey\n            AND ItemList.Store = StockReservation.Store'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R2013T_SalesOrdersProcurement'      | 'Yes'      | 'ItemList.SalesOrderExists'                                                                                                                                                      | 'SELECT\n    ItemList.Quantity AS ShippedQuantity,\n    ItemList.SalesOrder AS Order,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.SalesInvoiceExists AS SalesInvoiceExists,\n    ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,\n    ItemList.PurchaseReturnOrderExists AS PurchaseReturnOrderExists,\n    ItemList.PurchaseReturn AS PurchaseReturn,\n    ItemList.PurchaseReturnExists AS PurchaseReturnExists,\n    ItemList.InventoryTransferOrder AS InventoryTransferOrder,\n    ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,\n    ItemList.InventoryTransfer AS InventoryTransfer,\n    ItemList.InventoryTransferExists AS InventoryTransferExists,\n    ItemList.IsTransaction_Sales AS IsTransaction_Sales,\n    ItemList.IsTransaction_ReturnToVendor AS IsTransaction_ReturnToVendor,\n    ItemList.IsTransaction_InventoryTransfer AS IsTransaction_InventoryTransfer\nINTO R2013T_SalesOrdersProcurement\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesOrderExists'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'ShipmentConfirmation' | 'R4034B_GoodsShipmentSchedule'       | 'Yes'      | 'ItemList.SalesOrderExists\nItemList.SalesOrder.UseItemsShipmentScheduling'                                                                                                      | 'SELECT\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    ItemList.SalesOrder AS Basis,\n    ItemList.Company AS Company,\n    ItemList.Store AS Store,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.ShipmentConfirmation AS ShipmentConfirmation,\n    ItemList.UnitQuantity AS UnitQuantity,\n    ItemList.Quantity AS Quantity,\n    ItemList.Unit AS Unit,\n    ItemList.Period AS Period,\n    ItemList.RowKey AS RowKey,\n    ItemList.SalesOrder AS SalesOrder,\n    ItemList.SalesOrderExists AS SalesOrderExists,\n    ItemList.SalesInvoice AS SalesInvoice,\n    ItemList.SalesInvoiceExists AS SalesInvoiceExists,\n    ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,\n    ItemList.PurchaseReturnOrderExists AS PurchaseReturnOrderExists,\n    ItemList.PurchaseReturn AS PurchaseReturn,\n    ItemList.PurchaseReturnExists AS PurchaseReturnExists,\n    ItemList.InventoryTransferOrder AS InventoryTransferOrder,\n    ItemList.InventoryTransferOrderExists AS InventoryTransferOrderExists,\n    ItemList.InventoryTransfer AS InventoryTransfer,\n    ItemList.InventoryTransferExists AS InventoryTransferExists,\n    ItemList.IsTransaction_Sales AS IsTransaction_Sales,\n    ItemList.IsTransaction_ReturnToVendor AS IsTransaction_ReturnToVendor,\n    ItemList.IsTransaction_InventoryTransfer AS IsTransaction_InventoryTransfer\nINTO R4034B_GoodsShipmentSchedule\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesOrderExists\n    AND ItemList.SalesOrder.UseItemsShipmentScheduling'                                                                                                                                                                                                                                                                                                                                                                                                          | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'ShipmentConfirmation' | 'R2031B_ShipmentInvoicing'           | 'Yes'      | 'Query Receipt:\nNOT ItemList.SalesInvoiceExists\nItemList.IsTransaction_Sales\nQuery Expense:\nItemList.SalesInvoiceExists\nItemList.IsTransaction_Sales'                       | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    ItemList.ShipmentConfirmation AS Basis,\n    ItemList.Quantity AS Quantity,\n    ItemList.Company AS Company,\n    ItemList.Period AS Period,\n    ItemList.ItemKey AS ItemKey,\n    ItemList.Store AS Store\nINTO R2031B_ShipmentInvoicing\nFROM\n    ItemList AS ItemList\nWHERE\n    NOT ItemList.SalesInvoiceExists\n    AND ItemList.IsTransaction_Sales\n\nUNION ALL\n\nSELECT\n    VALUE(AccumulationRecordType.Expense),\n    ItemList.SalesInvoice,\n    ItemList.Quantity,\n    ItemList.Company,\n    ItemList.Period,\n    ItemList.ItemKey,\n    ItemList.Store\nFROM\n    ItemList AS ItemList\nWHERE\n    ItemList.SalesInvoiceExists\n    AND ItemList.IsTransaction_Sales'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               | 'Ref: Shipment confirmation\nBalancePeriod: Undefined' | 'Yes'     | 'Yes'     |
		And I close all client application windows

Scenario: _0401701 check preparation
	When check preparation

// 1

Scenario: _040171 check Shipment confirmation movements by the Register  "R4010 Actual stocks"
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                     | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                    | 'Expense'       | '28.01.2021 18:42:17'   | '1'           | 'Store 02'     | 'XS/Blue'    | ''                     |
			| ''                                                    | 'Expense'       | '28.01.2021 18:42:17'   | '10'          | 'Store 02'     | '36/Red'     | ''                     |
		And I close all client application windows
		
Scenario: _040172 check Shipment confirmation movements by the Register  "R4022 Shipment of stock transfer orders" (not transfer)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4022 Shipment of stock transfer orders"
		And I click "Registrations report" button
		And I select "R4022 Shipment of stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4022 Shipment of stock transfer orders"'    |
		And I close all client application windows
		
Scenario: _040173 check Shipment confirmation movements by the Register  "R2011 Shipment of sales orders" (SO exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| 'Register  "R2011 Shipment of sales orders"'        | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                                        | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Order'                                   | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '1'         | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '10'        | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
		And I close all client application windows
		
Scenario: _040174 check Shipment confirmation movements by the Register  "R4032 Goods in transit (outgoing)" (SO-SC-SI)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | ''              | ''                      | ''            | ''             | ''                                                    | ''            | ''                 |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''                                                    | ''            | ''                 |
			| 'Register  "R4032 Goods in transit (outgoing)"'       | ''              | ''                      | ''            | ''             | ''                                                    | ''            | ''                 |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                                    | ''            | ''                 |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                               | 'Item key'    | 'Serial lot number'|
			| ''                                                    | 'Expense'       | '28.01.2021 18:42:17'   | '1'           | 'Store 02'     | 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | 'XS/Blue'     | ''                 |
			| ''                                                    | 'Expense'       | '28.01.2021 18:42:17'   | '10'          | 'Store 02'     | 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | '36/Red'      | ''                 |
		And I close all client application windows
		
Scenario: _040175 check Shipment confirmation movements by the Register  "R4012 Stock Reservation" (SO-SC-SI)
		And I close all client application windows
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Register  "R4012 Stock Reservation"'                 | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                                           |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Order'                                      |
			| ''                                                    | 'Expense'       | '28.01.2021 18:42:17'   | '1'           | 'Store 02'     | 'XS/Blue'    | 'Sales order 1 dated 27.01.2021 19:50:45'    |
		And I close all client application windows
		
// Scenario: _040176 check Shipment confirmation movements by the Register  "R2013 Procurement of sales orders"
// 	* Select Shipment confirmation
// 		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '1' |
// 	* Check movements by the Register  "R2013 Procurement of sales orders"
// 		And I click "Registrations report" button
// 		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Shipment confirmation 1 dated *'               | '' | '' | '' | '' | '' |
// 			| 'Document registrations records'                | '' | '' | '' | '' | '' |
// 			| 'Register  "R2013 Procurement of sales orders"' | '' | '' | '' | '' | '' |
			
// 		And I close all client application windows

Scenario: _040176 check Shipment confirmation with serial lot number movements by the Register  "R4010 Actual stocks"
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 112 dated 24.05.2022 11:01:23'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                          | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                         | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                        | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                        | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                        | 'Expense'       | '24.05.2022 11:01:23'   | '5'           | 'Store 02'     | 'PZU'        | '8908899877'           |
			| ''                                                        | 'Expense'       | '24.05.2022 11:01:23'   | '5'           | 'Store 02'     | 'PZU'        | '8908899879'           |
			| ''                                                        | 'Expense'       | '24.05.2022 11:01:23'   | '5'           | 'Store 02'     | 'UNIQ'       | ''                     |
		And I close all client application windows


Scenario: _040177 check Shipment confirmation movements by the Register  "R4034 Scheduled goods shipments" (use sheduling, SO exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                        | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                        | ''         | ''                                     |
			| 'Register  "R4034 Scheduled goods shipments"'       | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                        | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                        | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                   | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '1'         | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '10'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
		And I close all client application windows


Scenario: _0401771 check Shipment confirmation movements by the Register  "R4034 Scheduled goods shipments" (not use sheduling, SO exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'    |
		And I close all client application windows




Scenario: _040178 check Shipment confirmation movements by the Register  "R2031 Shipment invoicing" (SI exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 3 dated 28.01.2021 18:52:05' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                          | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                          | ''         |
			| 'Register  "R2031 Shipment invoicing"'              | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                          | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                          | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                     | 'Item key' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '1'         | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '10'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '24'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/18SD'  |		
		And I close all client application windows

Scenario: _0401781 check Shipment confirmation movements by the Register  "R2031 Shipment invoicing" (SI not exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                                    | ''            |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                                    | ''            |
			| 'Register  "R2031 Shipment invoicing"'                | ''              | ''                      | ''            | ''               | ''                          | ''           | ''                                                    | ''            |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''                                                    | ''            |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'                    | 'Store'      | 'Basis'                                               | 'Item key'    |
			| ''                                                    | 'Receipt'       | '28.01.2021 18:42:17'   | '1'           | 'Main Company'   | 'Distribution department'   | 'Store 02'   | 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | 'XS/Blue'     |
			| ''                                                    | 'Receipt'       | '28.01.2021 18:42:17'   | '10'          | 'Main Company'   | 'Distribution department'   | 'Store 02'   | 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | '36/Red'      |
		And I close all client application windows

Scenario: _040179 check Shipment confirmation movements by the Register  "R4011 Free stocks" (SO-SC-SI)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                       | ''              | ''                      | ''            | ''             | ''            |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                    | 'Expense'       | '28.01.2021 18:42:17'   | '10'          | 'Store 02'     | '36/Red'      |
		And I close all client application windows

//3

Scenario: _040181 check Shipment confirmation movements by the Register  "R4011 Free stocks" (SO-SI-SC)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 3 dated 28.01.2021 18:52:05' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                     | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '10'        | 'Store 02'   | '36/Red'   |		
		And I close all client application windows

Scenario: _040182 check Shipment confirmation movements by the Register  "R4012 Stock Reservation" (SO-SI-SC)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 3 dated 28.01.2021 18:52:05' | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Register  "R4012 Stock Reservation"'               | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                        |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                   |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '1'         | 'Store 02'   | 'XS/Blue'  | 'Sales order 3 dated 27.01.2021 19:50:45' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '24'        | 'Store 02'   | '36/18SD'  | 'Sales order 3 dated 27.01.2021 19:50:45' |		
		And I close all client application windows




//4

Scenario: _040180 check Shipment confirmation movements by the Register  "R4011 Free stocks" (SC first)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 4 dated 16.02.2021 12:14:52'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                       | ''              | ''                      | ''            | ''             | ''            |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                    | 'Expense'       | '16.02.2021 12:14:52'   | '25'          | 'Store 02'     | 'XS/Blue'     |
		And I close all client application windows

Scenario: _040183 check Shipment confirmation movements by the Register  "R4012 Stock Reservation" (SC first)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows

Scenario: _040187 check Shipment confirmation movements by the Register  "R4032 Goods in transit (outgoing)" (SC first)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 4 dated 16.02.2021 12:14:52'   | ''              | ''                      | ''            | ''             | ''                                                    | ''            | ''                 |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''                                                    | ''            | ''                 |
			| 'Register  "R4032 Goods in transit (outgoing)"'       | ''              | ''                      | ''            | ''             | ''                                                    | ''            | ''                 |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                                    | ''            | ''                 |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                               | 'Item key'    | 'Serial lot number'|
			| ''                                                    | 'Expense'       | '16.02.2021 12:14:52'   | '10'          | 'Store 02'     | 'Shipment confirmation 4 dated 16.02.2021 12:14:52'   | 'XS/Blue'     | ''                 |
			| ''                                                    | 'Expense'       | '16.02.2021 12:14:52'   | '15'          | 'Store 02'     | 'Shipment confirmation 4 dated 16.02.2021 12:14:52'   | 'XS/Blue'     | ''                 |
		And I close all client application windows

//2 (SO-reserve 3, SC - 5)

Scenario: _040184 check Shipment confirmation movements by the Register  "R4011 Free stocks" (SO-SC-SI, SC>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 2 dated 28.01.2021 18:43:36'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                       | ''              | ''                      | ''            | ''             | ''            |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '2'           | 'Store 02'     | 'XS/Blue'     |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '10'          | 'Store 02'     | '36/Red'      |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '12'          | 'Store 02'     | '36/18SD'     |

		And I close all client application windows

Scenario: _040185 check Shipment confirmation movements by the Register  "R4012 Stock Reservation" (SO-SC-SI, SC>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 2 dated 28.01.2021 18:43:36'   | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Register  "R4012 Stock Reservation"'                 | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                                           |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Order'                                      |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '3'           | 'Store 02'     | 'XS/Blue'    | 'Sales order 2 dated 27.01.2021 19:50:45'    |
		And I close all client application windows

Scenario: _040186 check Shipment confirmation movements by the Register  "R4010 Actual stocks" (SO-SC-SI, SC>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 2 dated 28.01.2021 18:43:36'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                     | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '5'           | 'Store 02'     | 'XS/Blue'    | ''                     |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '10'          | 'Store 02'     | '36/Red'     | ''                     |
			| ''                                                    | 'Expense'       | '28.01.2021 18:43:36'   | '12'          | 'Store 02'     | '36/18SD'    | ''                     |
		And I close all client application windows

// 8 (SC>SI>SO)

Scenario: _040190 check Shipment confirmation movements by the Register  "R4010 Actual stocks" (SO-SI-SC, SC>SI>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 8 dated 18.02.2021 10:48:53'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                     | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                    | 'Expense'       | '18.02.2021 10:48:53'   | '26'          | 'Store 02'     | 'XS/Blue'    | ''                     |
		And I close all client application windows

Scenario: _040191 check Shipment confirmation movements by the Register  "R4032 Goods in transit (outgoing)" (SO-SI-SC, SC>SI>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 8 dated 18.02.2021 10:48:53'   | ''              | ''                      | ''            | ''             | ''                                            | ''            | ''                 |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''                                            | ''            | ''                 |
			| 'Register  "R4032 Goods in transit (outgoing)"'       | ''              | ''                      | ''            | ''             | ''                                            | ''            | ''                 |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                            | ''            | ''                 |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                       | 'Item key'    | 'Serial lot number'|
			| ''                                                    | 'Expense'       | '18.02.2021 10:48:53'   | '10'          | 'Store 02'     | 'Sales invoice 8 dated 18.02.2021 10:48:46'   | 'XS/Blue'     | ''                 |
			| ''                                                    | 'Expense'       | '18.02.2021 10:48:53'   | '16'          | 'Store 02'     | 'Sales invoice 8 dated 18.02.2021 10:48:46'   | 'XS/Blue'     | ''                 |
		And I close all client application windows

Scenario: _040193 check Shipment confirmation movements by the Register  "R4012 Stock Reservation" (SO-SI-SC, SC>SI>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 8 dated 18.02.2021 10:48:53'   | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Register  "R4012 Stock Reservation"'                 | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                                           |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Order'                                      |
			| ''                                                    | 'Expense'       | '18.02.2021 10:48:53'   | '20'          | 'Store 02'     | 'XS/Blue'    | 'Sales order 5 dated 18.02.2021 10:48:33'    |
		And I close all client application windows

Scenario: _040194 check Shipment confirmation movements by the Register  "R4011 Free stocks" (SO-SI-SC, SC>SI>SO)
	* Select Shipment confirmation
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '8'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 8 dated 18.02.2021 10:48:53' | ''                    | ''           | ''         | ''         | ''         |
			| 'Register  "R4011 Free stocks"'                     | ''                    | ''           | ''         | ''         | ''         |
			| ''                                                  | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Quantity' |
			| ''                                                  | '18.02.2021 10:48:53' | 'Expense'    | 'Store 02' | 'XS/Blue'  | '6'        |		
		And I close all client application windows

Scenario: _040199 Shipment confirmation clear posting/mark for deletion
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'    |
			| 'Document registrations records'                       |
		And I close current window
	* Post Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2011 Shipment of sales orders'    |
			| 'R4010 Actual stocks'               |
			| 'R4012 Stock Reservation'           |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17'    |
			| 'Document registrations records'                       |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2011 Shipment of sales orders'    |
			| 'R4010 Actual stocks'               |
			| 'R4012 Stock Reservation'           |
		And I close all client application windows
