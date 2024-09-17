#language: en
@tree
@Positive
@Movements
@MovementsGoodsReceipt

Functionality: check Goods receipt movements

Variables:
import "Variables.feature"



Scenario: _04010 preparation (Goods receipt)
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load PO
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load GR
		When Create document GoodsReceipt objects (check movements)
		When Create document GoodsReceipt objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load PI
		When create document PurchaseInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load documents (purchase for sales)
		When data preparation for stock reserve check for purchase for sales
		And I execute 1C:Enterprise script at server	
			| "Documents.SalesOrder.FindByNumber(2316).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseOrder.FindByNumber(2325).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(2502).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(2502).GetObject().Write(DocumentWriteMode.Posting);"   |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(2113).GetObject().Write(DocumentWriteMode.Posting);"   |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(2503).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.PurchaseInvoice.FindByNumber(2504).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(2114).GetObject().Write(DocumentWriteMode.Posting);"   |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(2116).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I close all client application windows


Scenario: _040101 check preparation
	When check preparation

//PO-GR-PI (use sheduling)

Scenario: _04011 check Goods receipt movements by the Register  "R4010 Actual stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'               | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                              | 'Receipt'       | '12.02.2021 15:10:35'   | '5'           | 'Store 02'     | '36/Yellow'   | ''                     |
			| ''                                              | 'Receipt'       | '12.02.2021 15:10:35'   | '10'          | 'Store 02'     | 'S/Yellow'    | ''                     |
		And I close all client application windows
		
Scenario: _04012 check Goods receipt movements by the Register  "R4017 Procurement of internal supply requests" (without ISR)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4017 Procurement of internal supply requests"
		And I click "Registrations report" button
		And I select "R4017 Procurement of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4017 Procurement of internal supply requests"'    |
			
		And I close all client application windows
		
Scenario: _04013 check Goods receipt movements by the Register  "R4011 Free stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                 | ''              | ''                      | ''            | ''             | ''             |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                              | 'Receipt'       | '12.02.2021 15:10:35'   | '5'           | 'Store 02'     | '36/Yellow'    |
			| ''                                              | 'Receipt'       | '12.02.2021 15:10:35'   | '10'          | 'Store 02'     | 'S/Yellow'     |
			
		And I close all client application windows
		
Scenario: _04014 check Goods receipt movements by the Register  "R1031 Receipt invoicing" (without PI)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1031 Receipt invoicing"
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                              | ''             |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                              | ''             |
			| 'Register  "R1031 Receipt invoicing"'           | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                              | ''             |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                              | ''             |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Basis'                                         | 'Item key'     |
			| ''                                              | 'Receipt'       | '12.02.2021 15:10:35'   | '5'           | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Goods receipt 115 dated 12.02.2021 15:10:35'   | '36/Yellow'    |
			| ''                                              | 'Receipt'       | '12.02.2021 15:10:35'   | '10'          | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Goods receipt 115 dated 12.02.2021 15:10:35'   | 'S/Yellow'     |
		And I close all client application windows
		
Scenario: _04015 check Goods receipt movements by the Register  "R4035 Incoming stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4035 Incoming stocks"
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'   | ''              | ''                      | ''            | ''             | ''            | ''                                                |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''             | ''            | ''                                                |
			| 'Register  "R4035 Incoming stocks"'             | ''              | ''                      | ''            | ''             | ''            | ''                                                |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                                                |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Order'                                           |
			| ''                                              | 'Expense'       | '12.02.2021 15:10:35'   | '5'           | 'Store 02'     | '36/Yellow'   | 'Purchase order 115 dated 12.02.2021 12:44:43'    |
			| ''                                              | 'Expense'       | '12.02.2021 15:10:35'   | '10'          | 'Store 02'     | 'S/Yellow'    | 'Purchase order 115 dated 12.02.2021 12:44:43'    |
		And I close all client application windows
		
Scenario: _04016 check Goods receipt with serial lot numbers movements by the Register  "R4010 Actual stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 1 112 dated 20.05.2022 17:44:58'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                 | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                | 'Receipt'       | '20.05.2022 17:44:58'   | '5'           | 'Store 03'     | 'PZU'        | '8908899877'           |
			| ''                                                | 'Receipt'       | '20.05.2022 17:44:58'   | '5'           | 'Store 03'     | 'PZU'        | '8908899879'           |
			| ''                                                | 'Receipt'       | '20.05.2022 17:44:58'   | '10'          | 'Store 03'     | 'XL/Green'   | ''                     |
			| ''                                                | 'Receipt'       | '20.05.2022 17:44:58'   | '10'          | 'Store 03'     | 'UNIQ'       | ''                     |
		And I close all client application windows
		
Scenario: _04017 check Goods receipt movements by the Register  "R2013 Procurement of sales orders"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
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
		
Scenario: _04018 check Goods receipt movements by the Register  "R4033 Scheduled goods receipts" (use shedule)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4033 Scheduled goods receipts"
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35' | ''            | ''                    | ''          | ''             | ''             | ''         | ''                                             | ''          | ''                                     |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''             | ''         | ''                                             | ''          | ''                                     |
			| 'Register  "R4033 Scheduled goods receipts"'  | ''            | ''                    | ''          | ''             | ''             | ''         | ''                                             | ''          | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''         | ''                                             | ''          | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'       | 'Store'    | 'Basis'                                        | 'Item key'  | 'Row key'                              |
			| ''                                            | 'Expense'     | '12.02.2021 15:10:35' | '5'         | 'Main Company' | 'Front office' | 'Store 02' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                            | 'Expense'     | '12.02.2021 15:10:35' | '10'        | 'Main Company' | 'Front office' | 'Store 02' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |
		And I close all client application windows

Scenario: _040181 check Goods receipt movements by the Register  "R4033 Scheduled goods receipts" (not use shedule)
		And I close all client application windows
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
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
		
Scenario: _04019 check Goods receipt movements by the Register  "R4036 Incoming stock requested"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4036 Incoming stock requested"
		And I click "Registrations report" button
		And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4036 Incoming stock requested"'    |
			
		And I close all client application windows
		
Scenario: _04020 check Goods receipt movements by the Register  "R4021 Receipt of stock transfer orders"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4021 Receipt of stock transfer orders"
		And I click "Registrations report" button
		And I select "R4021 Receipt of stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4021 Receipt of stock transfer orders"'    |
			
		And I close all client application windows
		
Scenario: _04021 check Goods receipt movements by the Register  "R1011 Receipt of purchase orders" (PO exists)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1011 Receipt of purchase orders"
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'  | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''          | ''                                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''          | ''                                     |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''          | ''                                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                             | ''          | ''                                     |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'       | 'Order'                                        | 'Item key'  | 'Row key'                              |
			| ''                                             | 'Expense'     | '12.02.2021 15:10:35' | '5'         | 'Main Company' | 'Front office' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                             | 'Expense'     | '12.02.2021 15:10:35' | '10'        | 'Main Company' | 'Front office' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |
		And I close all client application windows


//117

Scenario: _040211 check Goods receipt movements by the Register  "R1031 Receipt invoicing" (PI exist)
		And I close all client application windows
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R1031 Receipt invoicing"
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 117 dated 12.02.2021 15:13:11'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                 | ''             |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                 | ''             |
			| 'Register  "R1031 Receipt invoicing"'           | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                 | ''             |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                                 | ''             |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Basis'                                            | 'Item key'     |
			| ''                                              | 'Expense'       | '12.02.2021 15:13:11'   | '5'           | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'    |
			| ''                                              | 'Expense'       | '12.02.2021 15:13:11'   | '10'          | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'     |
		And I close all client application windows

Scenario: _0401211 check Goods receipt movements by the Register  "R4017 Procurement of internal supply requests" (ISR exist)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R4017 Procurement of internal supply requests"
		And I click "Registrations report info" button
		And I select "R4017 Procurement of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 117 dated 12.02.2021 15:13:11'               | ''                    | ''           | ''             | ''             | ''         | ''                                                      | ''          | ''         |
			| 'Register  "R4017 Procurement of internal supply requests"' | ''                    | ''           | ''             | ''             | ''         | ''                                                      | ''          | ''         |
			| ''                                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Store'    | 'Internal supply request'                               | 'Item key'  | 'Quantity' |
			| ''                                                          | '12.02.2021 15:13:11' | 'Expense'    | 'Main Company' | 'Front office' | 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | 'S/Yellow'  | '10'       |
			| ''                                                          | '12.02.2021 15:13:11' | 'Expense'    | 'Main Company' | 'Front office' | 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '36/Yellow' | '5'        |	
		And I close all client application windows

Scenario: _0401220 check absence Goods receipt movements by the Register "R4012 Stock Reservation" (SalesOrder not exist)
	And I close all client application windows
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |	
		And I close all client application windows

Scenario: _0401221 check Goods receipt movements by the Register  "R4012 Stock Reservation" (SalesOrderExists, PurchaseOrderExists)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 113'     |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 2 113 dated 11.09.2024 14:03:25' | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| 'Register  "R4012 Stock Reservation"'           | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Order'                                       | 'Quantity' |
			| ''                                              | '11.09.2024 14:03:25' | 'Receipt'    | 'Store 01' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Receipt'    | 'Store 01' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Receipt'    | 'Store 01' | 'UNIQ'     | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '2'        |		
		And I close all client application windows

Scenario: _0401222 check Goods receipt movements by the Register  "R4011 Free stocks" (SalesOrderExists, PurchaseOrderExists)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 113'     |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 2 113 dated 11.09.2024 14:03:25' | ''                    | ''           | ''         | ''         | ''         |
			| 'Register  "R4011 Free stocks"'                 | ''                    | ''           | ''         | ''         | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Quantity' |
			| ''                                              | '11.09.2024 14:03:25' | 'Receipt'    | 'Store 01' | 'ODS'      | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Receipt'    | 'Store 01' | 'ODS'      | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Receipt'    | 'Store 01' | 'UNIQ'     | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Expense'    | 'Store 01' | 'ODS'      | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Expense'    | 'Store 01' | 'ODS'      | '2'        |
			| ''                                              | '11.09.2024 14:03:25' | 'Expense'    | 'Store 01' | 'UNIQ'     | '2'        |		
		And I close all client application windows
	
Scenario: _0401223 check Goods receipt movements by the Register  "R4012 Stock Reservation" (SalesOrderExists, PurchaseInvoiceExists)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 114'     |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 2 114 dated 11.09.2024 14:07:20' | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| 'Register  "R4012 Stock Reservation"'           | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Order'                                       | 'Quantity' |
			| ''                                              | '11.09.2024 14:07:20' | 'Receipt'    | 'Store 02' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '3'        |
		And I close all client application windows

Scenario: _0401224 check Goods receipt movements by the Register  "R4011 Free stocks" (SalesOrderExists, PurchaseInvoiceExists)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 114'     |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 2 114 dated 11.09.2024 14:07:20' | ''                    | ''           | ''         | ''         | ''         |
			| 'Register  "R4011 Free stocks"'                 | ''                    | ''           | ''         | ''         | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Quantity' |
			| ''                                              | '11.09.2024 14:07:20' | 'Receipt'    | 'Store 02' | 'ODS'      | '3'        |
			| ''                                              | '11.09.2024 14:07:20' | 'Expense'    | 'Store 02' | 'ODS'      | '3'        |	
		And I close all client application windows

Scenario: _0401225 check Goods receipt movements by the Register  "R4011 Free stocks" (InventoryTransferExists, SalesOrderExist)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 116'     |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 2 116 dated 11.09.2024 16:35:35' | ''                    | ''           | ''         | ''         | ''         |
			| 'Register  "R4011 Free stocks"'                 | ''                    | ''           | ''         | ''         | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Quantity' |
			| ''                                              | '11.09.2024 16:35:35' | 'Receipt'    | 'Store 01' | 'ODS'      | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Receipt'    | 'Store 01' | 'ODS'      | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Receipt'    | 'Store 01' | 'UNIQ'     | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Expense'    | 'Store 01' | 'ODS'      | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Expense'    | 'Store 01' | 'ODS'      | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Expense'    | 'Store 01' | 'UNIQ'     | '3'        |		
		And I close all client application windows

Scenario: _0401226 check Goods receipt movements by the Register  "R4012 Stock Reservation" (InventoryTransferExists, SalesOrderExist)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 116'     |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 2 116 dated 11.09.2024 16:35:35' | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| 'Register  "R4012 Stock Reservation"'           | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| ''                                              | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Order'                                       | 'Quantity' |
			| ''                                              | '11.09.2024 16:35:35' | 'Receipt'    | 'Store 01' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Receipt'    | 'Store 01' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '3'        |
			| ''                                              | '11.09.2024 16:35:35' | 'Receipt'    | 'Store 01' | 'UNIQ'     | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '3'        |		
		And I close all client application windows

Scenario: _0401219 Goods receipt clear posting/mark for deletion
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'    |
			| 'Document registrations records'                 |
		And I close current window
	* Post Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4010 Actual stocks'    |
			| 'R4011 Free stocks'      |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
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
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'    |
			| 'Document registrations records'                 |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
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
			| 'R4010 Actual stocks'    |
			| 'R4011 Free stocks'      |
		And I close all client application windows
