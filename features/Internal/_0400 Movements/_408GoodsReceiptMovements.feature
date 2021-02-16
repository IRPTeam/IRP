#language: en
@tree
@Positive
@Movements
@MovementsGoodsReceipt

Functionality: check Goods receipt movements


Scenario: _04010 preparation (Goods receipt)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
	* Load PO
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseOrder.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseOrder.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |	
	* Load GR
		When Create document GoodsReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);" |		
	* Load PI
		When create document PurchaseInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.PurchaseInvoice.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.PurchaseInvoice.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);" |	

//PO-GR-PI (use sheduling)

Scenario: _04011 check Goods receipt movements by the Register  "R4010 Actual stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4010 Actual stocks"'             | ''            | ''                    | ''          | ''           | ''          |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                            | 'Receipt'     | '12.02.2021 15:10:35' | '5'         | 'Store 02'   | '36/Yellow' |
			| ''                                            | 'Receipt'     | '12.02.2021 15:10:35' | '10'        | 'Store 02'   | 'S/Yellow'  |	
		And I close all client application windows
		
Scenario: _04012 check Goods receipt movements by the Register  "R4017 Procurement of internal supply requests" (without ISR)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4017 Procurement of internal supply requests"
		And I click "Registrations report" button
		And I select "R4017 Procurement of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4017 Procurement of internal supply requests"'                     |
			
		And I close all client application windows
		
Scenario: _04013 check Goods receipt movements by the Register  "R4011 Free stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4011 Free stocks"'               | ''            | ''                    | ''          | ''           | ''          |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                            | 'Receipt'     | '12.02.2021 15:10:35' | '5'         | 'Store 02'   | '36/Yellow' |
			| ''                                            | 'Receipt'     | '12.02.2021 15:10:35' | '10'        | 'Store 02'   | 'S/Yellow'  |
			
		And I close all client application windows
		
Scenario: _04014 check Goods receipt movements by the Register  "R1031 Receipt invoicing" (without PI)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R1031 Receipt invoicing"
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35' | ''            | ''                    | ''          | ''             | ''         | ''                                            | ''          |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''         | ''                                            | ''          |
			| 'Register  "R1031 Receipt invoicing"'         | ''            | ''                    | ''          | ''             | ''         | ''                                            | ''          |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                            | ''          |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                       | 'Item key'  |
			| ''                                            | 'Receipt'     | '12.02.2021 15:10:35' | '5'         | 'Main Company' | 'Store 02' | 'Goods receipt 115 dated 12.02.2021 15:10:35' | '36/Yellow' |
			| ''                                            | 'Receipt'     | '12.02.2021 15:10:35' | '10'        | 'Main Company' | 'Store 02' | 'Goods receipt 115 dated 12.02.2021 15:10:35' | 'S/Yellow'  |
		And I close all client application windows
		
Scenario: _04015 check Goods receipt movements by the Register  "R4035 Incoming stocks"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4035 Incoming stocks"
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35' | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| 'Register  "R4035 Incoming stocks"'           | ''            | ''                    | ''          | ''           | ''          | ''                                             |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          | ''                                             |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  | 'Order'                                        |
			| ''                                            | 'Expense'     | '12.02.2021 15:10:35' | '5'         | 'Store 02'   | '36/Yellow' | 'Purchase order 115 dated 12.02.2021 12:44:43' |
			| ''                                            | 'Expense'     | '12.02.2021 15:10:35' | '10'        | 'Store 02'   | 'S/Yellow'  | 'Purchase order 115 dated 12.02.2021 12:44:43' |
		And I close all client application windows
		

		
Scenario: _04017 check Goods receipt movements by the Register  "R2013 Procurement of sales orders"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R2013 Procurement of sales orders"
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'                     |	
		And I close all client application windows
		
Scenario: _04018 check Goods receipt movements by the Register  "R4033 Scheduled goods receipts" (use shedule)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4033 Scheduled goods receipts"
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35' | ''            | ''                    | ''          | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                                             | ''         | ''          | ''                                     |
			| 'Register  "R4033 Scheduled goods receipts"'  | ''            | ''                    | ''          | ''             | ''                                             | ''         | ''          | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''         | ''          | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                        | 'Store'    | 'Item key'  | 'Row key'                              |
			| ''                                            | 'Expense'     | '12.02.2021 15:10:35' | '5'         | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Store 02' | '36/Yellow' | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' |
			| ''                                            | 'Expense'     | '12.02.2021 15:10:35' | '10'        | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'Store 02' | 'S/Yellow'  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' |
		And I close all client application windows

Scenario: _040181 check Goods receipt movements by the Register  "R4033 Scheduled goods receipts" (not use shedule)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '116' |
	* Check movements by the Register  "R4033 Scheduled goods receipts"
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4033 Scheduled goods receipts"'                     |	
		And I close all client application windows
		
Scenario: _04019 check Goods receipt movements by the Register  "R4036 Incoming stock requested"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4036 Incoming stock requested"
		And I click "Registrations report" button
		And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4036 Incoming stock requested"'                     |
			
		And I close all client application windows
		
Scenario: _04020 check Goods receipt movements by the Register  "R4021 Receipt of stock transfer orders"
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R4021 Receipt of stock transfer orders"
		And I click "Registrations report" button
		And I select "R4021 Receipt of stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4021 Receipt of stock transfer orders"'                     |
			
		And I close all client application windows
		
Scenario: _04021 check Goods receipt movements by the Register  "R1011 Receipt of purchase orders" (PO exists)
	* Select Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '115' |
	* Check movements by the Register  "R1011 Receipt of purchase orders"
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Goods receipt 115 dated 12.02.2021 15:10:35'  | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                    | ''          | ''             | ''                                             | ''          |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                             | ''          |
			| ''                                             | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                        | 'Item key'  |
			| ''                                             | 'Expense'     | '12.02.2021 15:10:35' | '5'         | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | '36/Yellow' |
			| ''                                             | 'Expense'     | '12.02.2021 15:10:35' | '10'        | 'Main Company' | 'Purchase order 115 dated 12.02.2021 12:44:43' | 'S/Yellow'  |
		And I close all client application windows


// //117

// Scenario: _040211 check Goods receipt movements by the Register  "R1031 Receipt invoicing" (PI exist)
// 	* Select Goods receipt
// 		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '117' |
// 	* Check movements by the Register  "R1031 Receipt invoicing"
// 		And I click "Registrations report" button
// 		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Goods receipt 117 dated 12.02.2021 15:13:11' | ''            | ''                    | ''          | ''             | ''         | ''                                               | ''          |
// 			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''         | ''                                               | ''          |
// 			| 'Register  "R1031 Receipt invoicing"'         | ''            | ''                    | ''          | ''             | ''         | ''                                               | ''          |
// 			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                               | ''          |
// 			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                          | 'Item key'  |
// 			| ''                                            | 'Expense'     | '12.02.2021 15:13:11' | '5'         | 'Main Company' | 'Store 02' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | '36/Yellow' |
// 			| ''                                            | 'Expense'     | '12.02.2021 15:13:11' | '10'        | 'Main Company' | 'Store 02' | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | 'S/Yellow'  |
// 		And I close all client application windows

// Scenario: _040121 check Goods receipt movements by the Register  "R4017 Procurement of internal supply requests" (ISR exist)
// 	* Select Goods receipt
// 		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '117' |
// 	* Check movements by the Register  "R4017 Procurement of internal supply requests"
// 		And I click "Registrations report" button
// 		And I select "R4017 Procurement of internal supply requests" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Goods receipt 117 dated 12.02.2021 15:13:11'               | ''            | ''                    | ''          | ''             | ''         | ''                                                      | ''          |
// 			| 'Document registrations records'                            | ''            | ''                    | ''          | ''             | ''         | ''                                                      | ''          |
// 			| 'Register  "R4017 Procurement of internal supply requests"' | ''            | ''                    | ''          | ''             | ''         | ''                                                      | ''          |
// 			| ''                                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                                      | ''          |
// 			| ''                                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Internal supply request'                               | 'Item key'  |
// 			| ''                                                          | 'Expense'     | '12.02.2021 15:13:11' | '5'         | 'Main Company' | 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | '36/Yellow' |
// 			| ''                                                          | 'Expense'     | '12.02.2021 15:13:11' | '10'        | 'Main Company' | 'Store 02' | 'Internal supply request 117 dated 12.02.2021 14:39:38' | 'S/Yellow'  |
// 		And I close all client application windows