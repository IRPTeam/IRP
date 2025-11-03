#language: en
@tree
@Positive
@Movements
@MovementsSalesOrderClosing

Feature: check Sales order closing movements

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040158 preparation (Sales order closing)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog CashAccounts objects
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
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	*Load Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number"     |
				| "1"          |
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"       |
				| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Load Sales order closing document
		When Create document SalesOrderClosing objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrderClosing.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
		When Create document SalesOrder, SalesInvoice, SalesOrderClosing, CashReceipt objects (with aging)
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(229).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.SalesOrder.FindByNumber(230).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.SalesInvoice.FindByNumber(229).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I execute 1C:Enterprise script at server
				| "Documents.CashReceipt.FindByNumber(229).GetObject().Write(DocumentWriteMode.Posting);"     |
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuPost"
	When Create document SO, SC, SI, SOC objects (for order closing)
	* Repost documents
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I select all lines of "List" table
		And I click the button named "FormPost"				
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I select all lines of "List" table
		And I click the button named "FormPost"	
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I select all lines of "List" table
		And I click the button named "FormPost"	
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I select all lines of "List" table
		And I click the button named "FormPost"					
	And I close all client application windows
	// * Check query for sales order closing movements
	// 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	// 	And in the table "Info" I click "Fill movements" button
	// 	And "Info" table contains lines
	// 		| 'Document'          | 'Register'                         | 'Recorder' | 'Conditions'                                                             | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | 'Parameters'                                                      | 'Receipt' | 'Expense' |
	// 		| 'SalesOrderClosing' | 'R2010T_SalesOrders'               | 'Yes'      | 'Query 0:\nIsCanceled\nQuery 1:\nNOT IsCanceled'                         | 'SELECT\n    -QueryTable.Quantity AS Quantity,\n    -QueryTable.OffersAmount AS OffersAmount,\n    -QueryTable.NetAmount AS NetAmount,\n    -QueryTable.Amount AS Amount,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    QueryTable.Store AS Store,\n    QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Order AS Order,\n    QueryTable.Unit AS Unit,\n    QueryTable.Item AS Item,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.ProcurementMethod AS ProcurementMethod,\n    QueryTable.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    QueryTable.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    QueryTable.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    QueryTable.IsService AS IsService,\n    QueryTable.Currency AS Currency,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity1,\n    QueryTable.OffersAmount AS OffersAmount1,\n    QueryTable.NetAmount AS NetAmount1,\n    QueryTable.Amount AS Amount1\nINTO R2010T_SalesOrders\nFROM\n    ItemList AS QueryTable\nWHERE\n    QueryTable.IsCanceled\n\nUNION ALL\n\nSELECT\n    QueryTable.Quantity,\n    QueryTable.OffersAmount,\n    QueryTable.NetAmount,\n    QueryTable.Amount,\n    QueryTable.Period,\n    QueryTable.Company,\n    QueryTable.ShipmentConfirmationsBeforeSalesInvoice,\n    QueryTable.Store,\n    QueryTable.UseShipmentConfirmation,\n    QueryTable.ItemKey,\n    QueryTable.Order,\n    QueryTable.Unit,\n    QueryTable.Item,\n    QueryTable.RowKey,\n    QueryTable.DeliveryDate,\n    QueryTable.ProcurementMethod,\n    QueryTable.IsProcurementMethod_Stock,\n    QueryTable.IsProcurementMethod_Purchase,\n    QueryTable.IsProcurementMethod_NonReserve,\n    QueryTable.IsService,\n    QueryTable.Currency,\n    QueryTable.IsCanceled,\n    QueryTable.CancelReason,\n    QueryTable.UseItemsShipmentScheduling,\n    QueryTable.UnitQuantity,\n    QueryTable.Quantity,\n    QueryTable.OffersAmount,\n    QueryTable.NetAmount,\n    QueryTable.Amount\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled' | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'SalesOrderClosing' | 'R2014T_CanceledSalesOrders'       | 'Yes'      | 'IsCanceled'                                                             | 'SELECT\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    QueryTable.Store AS Store,\n    QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Order AS Order,\n    QueryTable.Unit AS Unit,\n    QueryTable.Item AS Item,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.ProcurementMethod AS ProcurementMethod,\n    QueryTable.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    QueryTable.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    QueryTable.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    QueryTable.IsService AS IsService,\n    QueryTable.Currency AS Currency,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.OffersAmount AS OffersAmount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.Amount AS Amount\nINTO R2014T_CanceledSalesOrders\nFROM\n    ItemList AS QueryTable\nWHERE\n    QueryTable.IsCanceled'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'SalesOrderClosing' | 'R2011B_SalesOrdersShipment'       | 'Yes'      | ''                                                                       | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    -R2011B_SalesOrdersShipmentBalance.QuantityBalance AS Quantity,\n    R2011B_SalesOrdersShipmentBalance.Company AS Company,\n    R2011B_SalesOrdersShipmentBalance.Order AS Order,\n    R2011B_SalesOrdersShipmentBalance.ItemKey AS ItemKey,\n    R2011B_SalesOrdersShipmentBalance.QuantityBalance AS QuantityBalance\nINTO R2011B_SalesOrdersShipment\nFROM\n    AccumulationRegister.R2011B_SalesOrdersShipment.Balance(&BalancePeriod, Order = &SalesOrder) AS R2011B_SalesOrdersShipmentBalance'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 		| 'SalesOrderClosing' | 'R4011B_FreeStocks'                | 'Yes'      | ''                                                                       | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Expense) AS RecordType,\n    StockReservation.Store AS Store,\n    StockReservation.ItemKey AS ItemKey,\n    StockReservation.Order AS Order,\n    -StockReservation.QuantityBalance AS Quantity\nINTO R4011B_FreeStocks\nFROM\n    AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, Order = &SalesOrder) AS StockReservation'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'No'      | 'Yes'     |
	// 		| 'SalesOrderClosing' | 'R4012B_StockReservation'          | 'Yes'      | ''                                                                       | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    StockReservation.Store AS Store,\n    StockReservation.ItemKey AS ItemKey,\n    StockReservation.Order AS Order,\n    -StockReservation.QuantityBalance AS Quantity\nINTO R4012B_StockReservation\nFROM\n    AccumulationRegister.R4012B_StockReservation.Balance(&BalancePeriod, Order = &SalesOrder) AS StockReservation'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 		| 'SalesOrderClosing' | 'R2013T_SalesOrdersProcurement'    | 'Yes'      | 'IsCanceled\nNOT IsService\nIsProcurementMethod_Purchase\nQuantity <> 0' | 'SELECT\n    -QueryTable.Quantity AS OrderedQuantity,\n    QueryTable.Period AS Period,\n    QueryTable.Company AS Company,\n    QueryTable.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,\n    QueryTable.Store AS Store,\n    QueryTable.UseShipmentConfirmation AS UseShipmentConfirmation,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Order AS Order,\n    QueryTable.Unit AS Unit,\n    QueryTable.Item AS Item,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.ProcurementMethod AS ProcurementMethod,\n    QueryTable.IsProcurementMethod_Stock AS IsProcurementMethod_Stock,\n    QueryTable.IsProcurementMethod_Purchase AS IsProcurementMethod_Purchase,\n    QueryTable.IsProcurementMethod_NonReserve AS IsProcurementMethod_NonReserve,\n    QueryTable.IsService AS IsService,\n    QueryTable.Currency AS Currency,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.OffersAmount AS OffersAmount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.Amount AS Amount\nINTO R2013T_SalesOrdersProcurement\nFROM\n    ItemList AS QueryTable\nWHERE\n    QueryTable.IsCanceled\n    AND NOT QueryTable.IsService\n    AND QueryTable.IsProcurementMethod_Purchase\n    AND QueryTable.Quantity <> 0'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'No'      | 'No'      |
	// 		| 'SalesOrderClosing' | 'R4034B_GoodsShipmentSchedule'     | 'Yes'      | ''                                                                       | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    -R4034B_GoodsShipmentScheduleBalance.QuantityBalance AS Quantity,\n    R4034B_GoodsShipmentScheduleBalance.Company AS Company,\n    R4034B_GoodsShipmentScheduleBalance.Basis AS Basis,\n    R4034B_GoodsShipmentScheduleBalance.Store AS Store,\n    R4034B_GoodsShipmentScheduleBalance.ItemKey AS ItemKey,\n    R4034B_GoodsShipmentScheduleBalance.RowKey AS RowKey,\n    R4034B_GoodsShipmentScheduleBalance.QuantityBalance AS QuantityBalance\nINTO R4034B_GoodsShipmentSchedule\nFROM\n    AccumulationRegister.R4034B_GoodsShipmentSchedule.Balance(&BalancePeriod, Basis = &SalesOrder) AS R4034B_GoodsShipmentScheduleBalance'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 		| 'SalesOrderClosing' | 'R2012B_SalesOrdersInvoiceClosing' | 'Yes'      | ''                                                                       | 'SELECT\n    &Period AS Period,\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    -R2012B_SalesOrdersInvoiceClosingBalance.QuantityBalance AS Quantity,\n    -R2012B_SalesOrdersInvoiceClosingBalance.AmountBalance AS Amount,\n    -R2012B_SalesOrdersInvoiceClosingBalance.NetAmountBalance AS NetAmount,\n    R2012B_SalesOrdersInvoiceClosingBalance.Company AS Company,\n    R2012B_SalesOrdersInvoiceClosingBalance.Order AS Order,\n    R2012B_SalesOrdersInvoiceClosingBalance.Currency AS Currency,\n    R2012B_SalesOrdersInvoiceClosingBalance.ItemKey AS ItemKey,\n    R2012B_SalesOrdersInvoiceClosingBalance.RowKey AS RowKey,\n    R2012B_SalesOrdersInvoiceClosingBalance.QuantityBalance AS QuantityBalance,\n    R2012B_SalesOrdersInvoiceClosingBalance.AmountBalance AS AmountBalance,\n    R2012B_SalesOrdersInvoiceClosingBalance.NetAmountBalance AS NetAmountBalance\nINTO R2012B_SalesOrdersInvoiceClosing\nFROM\n    AccumulationRegister.R2012B_SalesOrdersInvoiceClosing.Balance(&BalancePeriod, Order = &SalesOrder) AS R2012B_SalesOrdersInvoiceClosingBalance'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                | 'SalesOrder: Sales order\nPeriod: Date\nBalancePeriod: Undefined' | 'Yes'     | 'No'      |
	// 	And I close all client application windows
		
				
Scenario: _0401581 check preparation
	When check preparation


Scenario: _040159 check Sales order closing movements by the Register  "R2010 Sales orders"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2010 Sales orders" 
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'   | ''                      | ''            | ''            | ''             | ''                | ''               | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                     | ''                  | ''                        |
			| 'Document registrations records'                    | ''                      | ''            | ''            | ''             | ''                | ''               | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                     | ''                  | ''                        |
			| 'Register  "R2010 Sales orders"'                    | ''                      | ''            | ''            | ''             | ''                | ''               | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                     | ''                  | ''                        |
			| ''                                                  | 'Period'                | 'Resources'   | ''            | ''             | ''                | 'Dimensions'     | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                     | ''                  | 'Attributes'              |
			| ''                                                  | ''                      | 'Quantity'    | 'Amount'      | 'Net amount'   | 'Offers amount'   | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Order'                                     | 'Item key'   | 'Row key'                                | 'Procurement method'   | 'Sales person'      | 'Deferred calculation'    |
			| ''                                                  | '28.01.2021 14:46:50'   | '-24'         | '-15 960'     | '-13 525,42'   | '-840'            | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'   | 'Purchase'             | ''                  | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-24'         | '-15 960'     | '-13 525,42'   | '-840'            | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'   | 'Purchase'             | ''                  | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-24'         | '-2 732,35'   | '-2 315,55'    | '-143,81'         | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'   | 'Purchase'             | ''                  | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-10'         | '-3 325'      | '-2 817,8'     | '-175'            | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'   | 'No reserve'           | 'Alexander Orlov'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-10'         | '-3 325'      | '-2 817,8'     | '-175'            | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'   | 'No reserve'           | 'Alexander Orlov'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-10'         | '-569,24'     | '-482,41'      | '-29,96'          | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'   | 'No reserve'           | 'Alexander Orlov'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-1'          | '-494'        | '-418,64'      | '-26'             | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'   | 'Stock'                | 'Alexander Orlov'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-1'          | '-494'        | '-418,64'      | '-26'             | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'   | 'Stock'                | 'Alexander Orlov'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-1'          | '-95'         | '-80,51'       | '-5'              | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'   | ''                     | ''                  | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-1'          | '-95'         | '-80,51'       | '-5'              | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'   | ''                     | ''                  | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-1'          | '-84,57'      | '-71,67'       | '-4,45'           | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'   | 'Stock'                | 'Alexander Orlov'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '-1'          | '-16,26'      | '-13,78'       | '-0,86'           | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'   | ''                     | ''                  | 'No'                      |
		And I close all client application windows
		
Scenario: _040160 check Sales order closing movements by the Register  "R2014 Canceled sales orders"
		And I close all client application windows
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2014 Canceled sales orders" 
		And I click "Registrations report" button
		And I select "R2014 Canceled sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'   | ''                      | ''            | ''           | ''             | ''               | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                | ''                        |
			| 'Document registrations records'                    | ''                      | ''            | ''           | ''             | ''               | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                | ''                        |
			| 'Register  "R2014 Canceled sales orders"'           | ''                      | ''            | ''           | ''             | ''               | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                | ''                        |
			| ''                                                  | 'Period'                | 'Resources'   | ''           | ''             | 'Dimensions'     | ''                          | ''                               | ''           | ''                                          | ''           | ''                                       | ''                | 'Attributes'              |
			| ''                                                  | ''                      | 'Quantity'    | 'Amount'     | 'Net amount'   | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Order'                                     | 'Item key'   | 'Row key'                                | 'Cancel reason'   | 'Deferred calculation'    |
			| ''                                                  | '28.01.2021 14:46:50'   | '1'           | '16,26'      | '13,78'        | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '1'           | '84,57'      | '71,67'        | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '1'           | '95'         | '80,51'        | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '1'           | '95'         | '80,51'        | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '1'           | '494'        | '418,64'       | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '1'           | '494'        | '418,64'       | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '10'          | '569,24'     | '482,41'       | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '10'          | '3 325'      | '2 817,8'      | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '10'          | '3 325'      | '2 817,8'      | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '24'          | '2 732,35'   | '2 315,55'     | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '24'          | '15 960'     | '13 525,42'    | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'   | 'not available'   | 'No'                      |
			| ''                                                  | '28.01.2021 14:46:50'   | '24'          | '15 960'     | '13 525,42'    | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'   | 'not available'   | 'No'                      |
		And I close all client application windows
		

Scenario: _040162 check Sales order closing movements by the Register  "R2011 Shipment of sales orders"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50' | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| 'Document registrations records'                  | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| 'Register  "R2011 Shipment of sales orders"'      | ''            | ''                    | ''          | ''             | ''                        | ''                                        | ''         | ''                                     |
			| ''                                                | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                                        | ''         | ''                                     |
			| ''                                                | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Order'                                   | 'Item key' | 'Row key'                              |
			| ''                                                | 'Receipt'     | '28.01.2021 14:46:50' | '-24'       | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' |
			| ''                                                | 'Receipt'     | '28.01.2021 14:46:50' | '-10'       | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                                | 'Receipt'     | '28.01.2021 14:46:50' | '-1'        | 'Main Company' | 'Distribution department' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
		And I close all client application windows
		
Scenario: _040163 check Sales order closing movements by the Register  "R4011 Free stocks"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'                    | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                     | ''              | ''                      | ''            | ''             | ''            |
			| ''                                                  | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                  | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                  | 'Expense'       | '28.01.2021 14:46:50'   | '-1'          | 'Store 02'     | 'XS/Blue'     |

		And I close all client application windows
		
Scenario: _040164 check Sales order closing movements by the Register  "R4012 Stock Reservation"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4012 Stock Reservation" 
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'   | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Document registrations records'                    | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| 'Register  "R4012 Stock Reservation"'               | ''              | ''                      | ''            | ''             | ''           | ''                                           |
			| ''                                                  | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                                           |
			| ''                                                  | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Order'                                      |
			| ''                                                  | 'Receipt'       | '28.01.2021 14:46:50'   | '-1'          | 'Store 02'     | 'XS/Blue'    | 'Sales order 1 dated 27.01.2021 19:50:45'    |

		And I close all client application windows
		
Scenario: _040165 check Sales order closing movements by the Register  "R2013 Procurement of sales orders"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'   | ''                      | ''                   | ''                      | ''                    | ''                   | ''                   | ''                 | ''                     | ''                       | ''                        | ''                          | ''                      | ''                        | ''                   | ''                     | ''               | ''                          | ''                                          | ''           | ''                                        |
			| 'Document registrations records'                    | ''                      | ''                   | ''                      | ''                    | ''                   | ''                   | ''                 | ''                     | ''                       | ''                        | ''                          | ''                      | ''                        | ''                   | ''                     | ''               | ''                          | ''                                          | ''           | ''                                        |
			| 'Register  "R2013 Procurement of sales orders"'     | ''                      | ''                   | ''                      | ''                    | ''                   | ''                   | ''                 | ''                     | ''                       | ''                        | ''                          | ''                      | ''                        | ''                   | ''                     | ''               | ''                          | ''                                          | ''           | ''                                        |
			| ''                                                  | 'Period'                | 'Resources'          | ''                      | ''                    | ''                   | ''                   | ''                 | ''                     | ''                       | ''                        | ''                          | ''                      | ''                        | ''                   | ''                     | 'Dimensions'     | ''                          | ''                                          | ''           | ''                                        |
			| ''                                                  | ''                      | 'Ordered quantity'   | 'Re ordered quantity'   | 'Purchase quantity'   | 'Receipt quantity'   | 'Shipped quantity'   | 'Sales quantity'   | 'Ordered net amount'   | 'Ordered total amount'   | 'Re ordered net amount'   | 'Re ordered total amount'   | 'Purchase net amount'   | 'Purchase total amount'   | 'Sales net amount'   | 'Sales total amount'   | 'Company'        | 'Branch'                    | 'Order'                                     | 'Item key'   | 'Row key'                                 |
			| ''                                                  | '28.01.2021 14:46:50'   | '-24'                | ''                      | ''                    | ''                   | ''                   | ''                 | '-13 525,42'           | '-15 960'                | ''                        | ''                          | ''                      | ''                        | ''                   | ''                     | 'Main Company'   | 'Distribution department'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | '37/18SD'    | '                                    '    |
		And I close all client application windows
		
Scenario: _040166 check Sales order closing movements by the Register  "R4034 Scheduled goods shipments"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4034 Scheduled goods shipments" 
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                        | ''         | ''                                     |
			| 'Document registrations records'                  | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                        | ''         | ''                                     |
			| 'Register  "R4034 Scheduled goods shipments"'     | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                                        | ''         | ''                                     |
			| ''                                                | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                                        | ''         | ''                                     |
			| ''                                                | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'                  | 'Store'    | 'Basis'                                   | 'Item key' | 'Row key'                              |
			| ''                                                | 'Receipt'     | '28.01.2021 14:46:50' | '-24'       | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' |
			| ''                                                | 'Receipt'     | '28.01.2021 14:46:50' | '-10'       | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                                | 'Receipt'     | '28.01.2021 14:46:50' | '-1'        | 'Main Company' | 'Distribution department' | 'Store 02' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |


		And I close all client application windows
		
Scenario: _040167 check Sales order closing movements by the Register  "R2012 Invoice closing of sales orders"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R2012 Invoice closing of sales orders" 
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'     | ''              | ''                      | ''            | ''          | ''             | ''               | ''                          | ''                                          | ''           | ''           | ''                                        |
			| 'Document registrations records'                      | ''              | ''                      | ''            | ''          | ''             | ''               | ''                          | ''                                          | ''           | ''           | ''                                        |
			| 'Register  "R2012 Invoice closing of sales orders"'   | ''              | ''                      | ''            | ''          | ''             | ''               | ''                          | ''                                          | ''           | ''           | ''                                        |
			| ''                                                    | 'Record type'   | 'Period'                | 'Resources'   | ''          | ''             | 'Dimensions'     | ''                          | ''                                          | ''           | ''           | ''                                        |
			| ''                                                    | ''              | ''                      | 'Quantity'    | 'Amount'    | 'Net amount'   | 'Company'        | 'Branch'                    | 'Order'                                     | 'Currency'   | 'Item key'   | 'Row key'                                 |
			| ''                                                    | 'Receipt'       | '28.01.2021 14:46:50'   | '-24'         | '-15 960'   | '-13 525,42'   | 'Main Company'   | 'Distribution department'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'TRY'        | '37/18SD'    | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689'    |
			| ''                                                    | 'Receipt'       | '28.01.2021 14:46:50'   | '-10'         | '-3 325'    | '-2 817,8'     | 'Main Company'   | 'Distribution department'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'TRY'        | '36/Red'     | 'e34f52ea-1fe2-47b2-9b37-63c093896662'    |
			| ''                                                    | 'Receipt'       | '28.01.2021 14:46:50'   | '-1'          | '-494'      | '-418,64'      | 'Main Company'   | 'Distribution department'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'TRY'        | 'XS/Blue'    | '63008c12-b682-4aff-b29f-e6927036b05a'    |
			| ''                                                    | 'Receipt'       | '28.01.2021 14:46:50'   | '-1'          | '-95'       | '-80,51'       | 'Main Company'   | 'Distribution department'   | 'Sales order 1 dated 27.01.2021 19:50:45'   | 'TRY'        | 'Internet'   | '0a13bddb-cb97-4515-a9ef-777b6924ebf1'    |

		And I close all client application windows

Scenario: _0401671 check Sales order closing movements by the Register  "T2014 Advances info"
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 4 dated 10.03.2022 11:27:01' | ''             | ''                        | ''                    | ''                                     | ''         | ''          | ''                  | ''                                          | ''                  | ''                    | ''          | ''                         | ''        | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'                 | ''             | ''                        | ''                    | ''                                     | ''         | ''          | ''                  | ''                                          | ''                  | ''                    | ''          | ''                         | ''        | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                | 'Company'      | 'Branch'                  | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'   | 'Legal name'        | 'Order'                                     | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement'        | 'Project' | 'Currency movement type'  | 'Transaction currency' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                                | 'Main Company' | 'Distribution department' | '10.03.2022 11:27:01' | '                                    ' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Sales order 229 dated 10.03.2022 10:57:17' | 'No'                | 'Yes'                 | '*'         | 'Basic Partner terms, TRY' | ''        | 'en description is empty' | 'TRY'                  | ''       | 'No'                      | 'Yes'                  | 'Receipt'     |
		And I close all client application windows

Scenario: _040169 Sales order closing clear posting/mark for deletion
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'    |
			| 'Document registrations records'                     |
		And I close current window
	* Post Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2010 Sales orders'                       |
			| 'R4011 Free stocks'                        |
			| 'R4012 Stock Reservation'                  |
			| 'R2012 Invoice closing of sales orders'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
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
			| 'Sales order closing 1 dated 28.01.2021 14:46:50'    |
			| 'Document registrations records'                     |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
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
			| 'R2010 Sales orders'                       |
			| 'R4011 Free stocks'                        |
			| 'R4012 Stock Reservation'                  |
			| 'R2012 Invoice closing of sales orders'    |
		And I close all client application windows

Scenario: _040170 check Sales order closing movements by the Register "Posted documents registry"
	And I close all client application windows
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And I click the button named "FormPost"
	* Check movements by the Register "Posted documents registry" 
		And I click "Registrations report info" button
		And I select "Posted documents registry" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 1 dated 28.01.2021 14:46:50' | ''                                                | ''                    | ''       | ''            | ''            | ''                        | ''                        | ''                      |
			| 'Register  "Posted documents registry"'           | ''                                                | ''                    | ''       | ''            | ''            | ''                        | ''                        | ''                      |
			| ''                                                | 'Document'                                        | 'Date'                | 'Number' | 'Create date' | 'Modify date' | 'Author'                  | 'Editor'                  | 'Manual movements edit' |
			| ''                                                | 'Sales order closing 1 dated 28.01.2021 14:46:50' | '28.01.2021 14:46:50' | '1'      | '*'           | '*'           | 'en description is empty' | 'en description is empty' | 'No'                    |
		And I close all client application windows

Scenario: _040171 check Sales order closing movements by the Register (different ItemKey)		
	And I close all client application windows
	* Select Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I go to line in "List" table
			| 'Date'       |
			| '10.04.2025' |
		And I click the button named "FormPost"						
	* Check movements by the Register "Posted documents registry"
		And I click the button named "FormReportD0013_DocumentRegistrationsReportRegistrationsReportInfo"
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order closing 5 dated 10.04.2025 22:14:52'   | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| 'Register  "Posted documents registry"'             | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | 'Document'                                        | 'Date'                | 'Number'              | 'Create date'                          | 'Modify date'                               | 'Author'                                    | 'Editor'                               | 'Manual movements edit'                     | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | 'Sales order closing 5 dated 10.04.2025 22:14:52' | '10.04.2025 22:14:52' | '5'                   | '*'                                    | '*'                                         | 'en description is empty'                   | 'en description is empty'              | 'No'                                        | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| 'Register  "R2010 Sales orders"'                    | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | 'Period'                                          | 'Company'             | 'Branch'              | 'Multi currency movement type'         | 'Currency'                                  | 'Order'                                     | 'Item key'                             | 'Row key'                                   | 'Procurement method' | 'Sales person'        | 'Quantity'   | 'Amount'                   | 'Net amount' | 'Offers amount'           | 'Deferred calculation' | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Main Company'        | ''                    | 'Local currency'                       | 'TRY'                                       | 'Sales order 231 dated 10.04.2025 22:03:13' | 'ODS'                                  | '*'                                         | 'Stock'              | ''                    | '50'         | '27 500'                   | '23 305,08'  | ''                        | 'No'                   | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Main Company'        | ''                    | 'Local currency'                       | 'TRY'                                       | 'Sales order 231 dated 10.04.2025 22:03:13' | 'PZU'                                  | '*'                                         | 'Stock'              | ''                    | '50'         | '26 000'                   | '22 033,9'   | ''                        | 'No'                   | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Main Company'        | ''                    | 'Reporting currency'                   | 'USD'                                       | 'Sales order 231 dated 10.04.2025 22:03:13' | 'ODS'                                  | '*'                                         | 'Stock'              | ''                    | '50'         | '4 708'                    | '3 989,83'   | ''                        | 'No'                   | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Main Company'        | ''                    | 'Reporting currency'                   | 'USD'                                       | 'Sales order 231 dated 10.04.2025 22:03:13' | 'PZU'                                  | '*'                                         | 'Stock'              | ''                    | '50'         | '4 451,2'                  | '3 772,2'    | ''                        | 'No'                   | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Main Company'        | ''                    | 'en description is empty'              | 'TRY'                                       | 'Sales order 231 dated 10.04.2025 22:03:13' | 'ODS'                                  | '*'                                         | 'Stock'              | ''                    | '50'         | '27 500'                   | '23 305,08'  | ''                        | 'No'                   | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Main Company'        | ''                    | 'en description is empty'              | 'TRY'                                       | 'Sales order 231 dated 10.04.2025 22:03:13' | 'PZU'                                  | '*'                                         | 'Stock'              | ''                    | '50'         | '26 000'                   | '22 033,9'   | ''                        | 'No'                   | ''       | ''                        | ''                     | ''            |
			| ''                                                  | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| 'Register  "R2011 Shipment of sales orders"'        | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | 'Period'                                          | 'RecordType'          | 'Company'             | 'Branch'                               | 'Order'                                     | 'Item key'                                  | 'Row key'                              | 'Quantity'                                  | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Receipt'             | 'Main Company'        | ''                                     | 'Sales order 231 dated 10.04.2025 22:03:13' | 'ODS'                                       | '301edaee-47dc-4a86-905c-dfc21874661c' | '50'                                        | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Receipt'             | 'Main Company'        | ''                                     | 'Sales order 231 dated 10.04.2025 22:03:13' | 'PZU'                                       | 'dc45f5ab-d66f-4e97-9657-b9d795e3a812' | '50'                                        | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | 'Period'                                          | 'RecordType'          | 'Company'             | 'Branch'                               | 'Order'                                     | 'Currency'                                  | 'Item key'                             | 'Row key'                                   | 'Quantity'           | 'Amount'              | 'Net amount' | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Receipt'             | 'Main Company'        | ''                                     | 'Sales order 231 dated 10.04.2025 22:03:13' | 'TRY'                                       | 'ODS'                                  | '*'                                         | '50'                 | '27 500'              | '23 305,08'  | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | '10.04.2025 22:14:52'                             | 'Receipt'             | 'Main Company'        | ''                                     | 'Sales order 231 dated 10.04.2025 22:03:13' | 'TRY'                                       | 'PZU'                                  | '*'                                         | '50'                 | '26 000'              | '22 033,9'   | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'                   | ''                                                | ''                    | ''                    | ''                                     | ''                                          | ''                                          | ''                                     | ''                                          | ''                   | ''                    | ''           | ''                         | ''           | ''                        | ''                     | ''       | ''                        | ''                     | ''            |
			| ''                                                  | 'Company'                                         | 'Branch'              | 'Date'                | 'Key'                                  | 'Currency'                                  | 'Partner'                                   | 'Legal name'                           | 'Order'                                     | 'Is vendor advance'  | 'Is customer advance' | 'Unique ID'  | 'Advance agreement'        | 'Project'    | 'Currency movement type'  | 'Transaction currency' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                                  | 'Main Company'                                    | ''                    | '10.04.2025 22:14:52' | '                                    ' | 'TRY'                                       | 'Ferron BP'                                 | 'Company Ferron BP'                    | 'Sales order 231 dated 10.04.2025 22:03:13' | 'No'                 | 'Yes'                 | '*'          | 'Basic Partner terms, TRY' | ''           | 'en description is empty' | 'TRY'                  | ''       | 'No'                      | 'Yes'                  | 'Receipt'     |
		And I close all client application windows		
		