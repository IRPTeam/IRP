#language: en
@tree
@Positive
@Movements
@MovementsPurchaseOrder


Feature: check Purchase order movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _040115 preparation (Purchase order)
	
	When set True value to the constant
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
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create catalog CancelReturnReasons objects
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseOrder objects (with aging, prepaid, post-shipment credit)	
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
	# * Check query for Purchase order movements
	# 	Given I open hyperlink "e1cib/app/DataProcessor.AnaliseDocumentMovements"
	# 	And in the table "Info" I click "Fill movements" button
	# 	And "Info" table contains lines
	# 		| 'Document'      | 'Register'                             | 'Recorder' | 'Conditions'                                                                                                | 'Query'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          | 'Parameters'                                        | 'Receipt' | 'Expense' |
	# 		| 'PurchaseOrder' | 'R1012B_PurchaseOrdersInvoiceClosing'  | 'Yes'      | 'NOT IsCanceled'                                                                                            | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R1012B_PurchaseOrdersInvoiceClosing\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled'                                                                                                                                                                                                                                                                            | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'Yes'     | 'No'      |
	# 		| 'PurchaseOrder' | 'R4035B_IncomingStocks'                | 'Yes'      | 'NOT UseSalesOrder\nNOT IsService\nNOT IsCanceled'                                                          | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.Period AS Period,\n    QueryTable.Store AS Store,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.Order AS Order,\n    QueryTable.Quantity AS Quantity\nINTO R4035B_IncomingStocks\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.UseSalesOrder\n    AND NOT QueryTable.IsService\n    AND NOT QueryTable.IsCanceled'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'Yes'     | 'No'      |
	# 		| 'PurchaseOrder' | 'R2013T_SalesOrdersProcurement'        | 'Yes'      | 'NOT IsCanceled\nNOT IsService\nNOT SalesOrder = VALUE(Document.SalesOrder.EmptyRef)'                       | 'SELECT\n    QueryTable.Quantity AS ReOrderedQuantity,\n    QueryTable.SalesOrder AS Order,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order1,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R2013T_SalesOrdersProcurement\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled\n    AND NOT QueryTable.IsService\n    AND NOT QueryTable.SalesOrder = VALUE(Document.SalesOrder.EmptyRef)'                                                                                                                                            | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'No'      | 'No'      |
	# 		| 'PurchaseOrder' | 'R1014T_CanceledPurchaseOrders'        | 'Yes'      | 'IsCanceled'                                                                                                | 'SELECT\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R1014T_CanceledPurchaseOrders\nFROM\n    ItemList AS QueryTable\nWHERE\n    QueryTable.IsCanceled'                                                                                                                                                                                                                                                                                                                                                | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'No'      | 'No'      |
	# 		| 'PurchaseOrder' | 'R4016B_InternalSupplyRequestOrdering' | 'Yes'      | 'NOT IsCanceled\nNOT IsService\nNOT InternalSupplyRequest = VALUE(Document.InternalSupplyRequest.EmptyRef)' | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity1,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest1,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R4016B_InternalSupplyRequestOrdering\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled\n    AND NOT QueryTable.IsService\n    AND NOT QueryTable.InternalSupplyRequest = VALUE(Document.InternalSupplyRequest.EmptyRef)'                                  | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'Yes'     | 'No'      |
	# 		| 'PurchaseOrder' | 'R1010T_PurchaseOrders'                | 'Yes'      | 'NOT IsCanceled'                                                                                            | 'SELECT\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R1010T_PurchaseOrders\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled'                                                                                                                                                                                                                                                                                                                                                    | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'No'      | 'No'      |
	# 		| 'PurchaseOrder' | 'R4033B_GoodsReceiptSchedule'          | 'Yes'      | 'NOT IsCanceled\nNOT IsService\nUseItemsReceiptScheduling'                                                  | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    CASE\n        WHEN QueryTable.DeliveryDate = DATETIME(1, 1, 1)\n            THEN QueryTable.Period\n        ELSE QueryTable.DeliveryDate\n    END AS Period,\n    QueryTable.Order AS Basis,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period1,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R4033B_GoodsReceiptSchedule\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled\n    AND NOT QueryTable.IsService\n    AND QueryTable.UseItemsReceiptScheduling' | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'Yes'     | 'No'      |
	# 		| 'PurchaseOrder' | 'R1011B_PurchaseOrdersReceipt'         | 'Yes'      | 'NOT IsCanceled\nNOT IsService'                                                                             | 'SELECT\n    VALUE(AccumulationRecordType.Receipt) AS RecordType,\n    QueryTable.Company AS Company,\n    QueryTable.Store AS Store,\n    QueryTable.UseGoodsReceipt AS UseGoodsReceipt,\n    QueryTable.GoodsReceiptBeforePurchaseInvoice AS GoodsReceiptBeforePurchaseInvoice,\n    QueryTable.Order AS Order,\n    QueryTable.PurchaseBasis AS PurchaseBasis,\n    QueryTable.Item AS Item,\n    QueryTable.ItemKey AS ItemKey,\n    QueryTable.UnitQuantity AS UnitQuantity,\n    QueryTable.Quantity AS Quantity,\n    QueryTable.Unit AS Unit,\n    QueryTable.Period AS Period,\n    QueryTable.RowKey AS RowKey,\n    QueryTable.BusinessUnit AS BusinessUnit,\n    QueryTable.ExpenseType AS ExpenseType,\n    QueryTable.IsService AS IsService,\n    QueryTable.DeliveryDate AS DeliveryDate,\n    QueryTable.InternalSupplyRequest AS InternalSupplyRequest,\n    QueryTable.SalesOrder AS SalesOrder,\n    QueryTable.IsCanceled AS IsCanceled,\n    QueryTable.CancelReason AS CancelReason,\n    QueryTable.Amount AS Amount,\n    QueryTable.NetAmount AS NetAmount,\n    QueryTable.UseItemsReceiptScheduling AS UseItemsReceiptScheduling,\n    QueryTable.UseSalesOrder AS UseSalesOrder,\n    QueryTable.Currency AS Currency\nINTO R1011B_PurchaseOrdersReceipt\nFROM\n    ItemList AS QueryTable\nWHERE\n    NOT QueryTable.IsCanceled\n    AND NOT QueryTable.IsService'                                                                                                                                                                                                                                                 | 'Ref: Purchase order\nStatusInfoPosting: Structure' | 'Yes'     | 'No'      |
		And I close all client application windows

Scenario: _0401151 check preparation
	When check preparation

// 115

Scenario: _040116 check Purchase order movements by the Register  "R1012 Invoice closing of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'           | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                               | ''           | ''            | ''                                        |
			| 'Document registrations records'                         | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                               | ''           | ''            | ''                                        |
			| 'Register  "R1012 Invoice closing of purchase orders"'   | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                               | ''           | ''            | ''                                        |
			| ''                                                       | 'Record type'   | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                                               | ''           | ''            | ''                                        |
			| ''                                                       | ''              | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Order'                                          | 'Currency'   | 'Item key'    | 'Row key'                                 |
			| ''                                                       | 'Receipt'       | '12.02.2021 12:44:43'   | '2'           | '300'      | '254,24'       | 'Main Company'   | 'Front office'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'TRY'        | 'Internet'    | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'    |
			| ''                                                       | 'Receipt'       | '12.02.2021 12:44:43'   | '5'           | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'TRY'        | '36/Yellow'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'    |
			| ''                                                       | 'Receipt'       | '12.02.2021 12:44:43'   | '10'          | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'TRY'        | 'S/Yellow'    | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'    |
		And I close all client application windows
		
Scenario: _040117 check Purchase order movements by the Register  "R4035 Incoming stocks" (not use SO)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4035 Incoming stocks" 
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'   | ''              | ''                      | ''            | ''             | ''            | ''                                                |
			| 'Document registrations records'                 | ''              | ''                      | ''            | ''             | ''            | ''                                                |
			| 'Register  "R4035 Incoming stocks"'              | ''              | ''                      | ''            | ''             | ''            | ''                                                |
			| ''                                               | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                                                |
			| ''                                               | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Order'                                           |
			| ''                                               | 'Receipt'       | '12.02.2021 12:44:43'   | '5'           | 'Store 02'     | '36/Yellow'   | 'Purchase order 115 dated 12.02.2021 12:44:43'    |
			| ''                                               | 'Receipt'       | '12.02.2021 12:44:43'   | '10'          | 'Store 02'     | 'S/Yellow'    | 'Purchase order 115 dated 12.02.2021 12:44:43'    |
		And I close all client application windows
		
Scenario: _040118 check Purchase order movements by the Register  "R2013 Procurement of sales orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'    |
			
		And I close all client application windows
		
Scenario: _040119 check Purchase order movements by the Register  "R1014 Canceled purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1014 Canceled purchase orders" 
		And I click "Registrations report" button
		And I select "R1014 Canceled purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'   | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                               | ''           | ''                                       | ''                | ''                        |
			| 'Document registrations records'                 | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                               | ''           | ''                                       | ''                | ''                        |
			| 'Register  "R1014 Canceled purchase orders"'     | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                               | ''           | ''                                       | ''                | ''                        |
			| ''                                               | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                               | ''           | ''                                               | ''           | ''                                       | ''                | 'Attributes'              |
			| ''                                               | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Order'                                          | 'Item key'   | 'Row key'                                | 'Cancel reason'   | 'Deferred calculation'    |
			| ''                                               | '12.02.2021 12:44:43'   | '8'           | '164,35'   | '139,28'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/18SD'    | '62d24ced-315a-473c-b47a-5bc9c4a824e0'   | 'not available'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '8'           | '960'      | '813,56'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/18SD'    | '62d24ced-315a-473c-b47a-5bc9c4a824e0'   | 'not available'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '8'           | '960'      | '813,56'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/18SD'    | '62d24ced-315a-473c-b47a-5bc9c4a824e0'   | 'not available'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '8'           | '960'      | '813,56'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/18SD'    | '62d24ced-315a-473c-b47a-5bc9c4a824e0'   | 'not available'   | 'No'                      |
		And I close all client application windows
		
Scenario: _040120 check Purchase order movements by the Register  "R4016 Ordering of internal supply requests" (without ISR)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4016 Ordering of internal supply requests" 
		And I click "Registrations report" button
		And I select "R4016 Ordering of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4016 Ordering of internal supply requests"'    |
			
		And I close all client application windows
		
Scenario: _040121 check Purchase order movements by the Register  "R1010 Purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'   | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | ''                        |
			| 'Document registrations records'                 | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | ''                        |
			| 'Register  "R1010 Purchase orders"'              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | ''                        |
			| ''                                               | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                               | ''           | ''                                               | ''            | ''                                       | 'Attributes'              |
			| ''                                               | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Order'                                          | 'Item key'    | 'Row key'                                | 'Deferred calculation'    |
			| ''                                               | '12.02.2021 12:44:43'   | '2'           | '51,36'    | '43,53'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Internet'    | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '2'           | '300'      | '254,24'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Internet'    | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '2'           | '300'      | '254,24'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Internet'    | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '2'           | '300'      | '254,24'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Internet'    | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '5'           | '171,2'    | '145,09'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/Yellow'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '5'           | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/Yellow'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '5'           | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/Yellow'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '5'           | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | '36/Yellow'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '10'          | '171,2'    | '145,09'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'S/Yellow'    | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '10'          | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'S/Yellow'    | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '10'          | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'S/Yellow'    | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'No'                      |
			| ''                                               | '12.02.2021 12:44:43'   | '10'          | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'S/Yellow'    | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'   | 'No'                      |
		And I close all client application windows
		
Scenario: _040122 check Purchase order movements by the Register  "R4033 Scheduled goods receipts" (use shedule)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''            | ''                    | ''          | ''             | ''             | ''         | ''                                             | ''          | ''                                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''         | ''                                             | ''          | ''                                     |
			| 'Register  "R4033 Scheduled goods receipts"'   | ''            | ''                    | ''          | ''             | ''             | ''         | ''                                             | ''          | ''                                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''         | ''                                             | ''          | ''                                     |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'       | 'Store'    | 'Basis'                                        | 'Item key'  | 'Row key'                              |
			| ''                                             | 'Receipt'     | '12.02.2021 00:00:00' | '5'         | 'Main Company' | 'Front office' | 'Store 02' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                             | 'Receipt'     | '12.02.2021 00:00:00' | '10'        | 'Main Company' | 'Front office' | 'Store 02' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |
		And I close all client application windows
		
Scenario: _040123 check Purchase order movements by the Register  "R1011 Receipt of purchase orders"
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1011 Receipt of purchase orders" 
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43' | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''          | ''                                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''          | ''                                     |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''          | ''                                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                             | ''          | ''                                     |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'       | 'Order'                                        | 'Item key'  | 'Row key'                              |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:43' | '5'         | 'Main Company' | 'Front office' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                             | 'Receipt'     | '12.02.2021 12:44:43' | '10'        | 'Main Company' | 'Front office' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |
		And I close all client application windows
	

// 116




		
Scenario: _0401222 check Purchase order movements by the Register  "R4033 Scheduled goods receipts" (not use shedule)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '116'       |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4033 Scheduled goods receipts"'    |
		And I close all client application windows
		
// 117 

Scenario: _0401231 check Purchase order movements by the Register  "R4016 Ordering of internal supply requests" (ISR exists)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R4016 Ordering of internal supply requests" 
		And I click "Registrations report" button
		And I select "R4016 Ordering of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05'             | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                        | ''            |
			| 'Document registrations records'                           | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                        | ''            |
			| 'Register  "R4016 Ordering of internal supply requests"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                        | ''            |
			| ''                                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                                        | ''            |
			| ''                                                         | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Internal supply request'                                 | 'Item key'    |
			| ''                                                         | 'Receipt'       | '12.02.2021 12:45:05'   | '10'          | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Internal supply request 117 dated 12.02.2021 14:39:38'   | 'S/Yellow'    |
		And I close all client application windows

Scenario: _0401236 check there is no Purchase order movements by the Register  "R1022 Vendors payment planning" (without aging)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 117 dated 12.02.2021 12:45:05'    |
			| 'Document registrations records'                  |
		And I close all client application windows


Scenario: _0401237 check there is no Purchase order movements by the Register  "R1022 Vendors payment planning" (with aging, Post-shipment credit)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 324 dated 30.05.2021 12:56:02'    |
			| 'Document registrations records'                  |
		And I close all client application windows



Scenario: _0401238 check Purchase order movements by the Register  "R1022 Vendors payment planning" (with aging, Prepaid)
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report info" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 323 dated 30.05.2021 12:55:44' | ''                    | ''           | ''             | ''             | ''                                             | ''                  | ''          | ''                   | ''       |
			| 'Register  "R1022 Vendors payment planning"'   | ''                    | ''           | ''             | ''             | ''                                             | ''                  | ''          | ''                   | ''       |
			| ''                                             | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Basis'                                        | 'Legal name'        | 'Partner'   | 'Agreement'          | 'Amount' |
			| ''                                             | '30.05.2021 12:55:44' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase order 323 dated 30.05.2021 12:55:44' | 'Company Ferron BP' | 'Ferron BP' | 'Vendor Ferron, TRY' | '1 170'  |		
		And I close all client application windows

Scenario: _0401239 Purchase order clear posting/mark for deletion
	* Select Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'    |
			| 'Document registrations records'                  |
		And I close current window
	* Post Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1010 Purchase orders'                       |
			| 'R1014 Canceled purchase orders'              |
			| 'R1012 Invoice closing of purchase orders'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order 115 dated 12.02.2021 12:44:43'    |
			| 'Document registrations records'                  |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1010 Purchase orders'                       |
			| 'R1014 Canceled purchase orders'              |
			| 'R1012 Invoice closing of purchase orders'    |
		And I close all client application windows



	
