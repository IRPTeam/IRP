#language: en
@tree
@Positive
@Movements
@MovementsPurchaseInvoice

Functionality: check Purchase invoice movements

Variables:
import "Variables.feature"

Scenario: _04096 preparation (Purchase invoice)
	When set True value to the constant
	When set True value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
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
		When Create catalog Projects objects
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog LegalNameContracts objects
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog SerialLotNumbers objects
	When settings for Main Company (commission trade)
	* Load Bank payment
	When Create document BankPayment objects (check movements, advance)
	And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
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
	When Create document PurchaseOrder objects (with aging, prepaid, post-shipment credit)	
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load GR
	When Create document GoodsReceipt objects (check movements)
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server	
			| "Documents.GoodsReceipt.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"    |
			// | "Documents.GoodsReceipt.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.GoodsReceipt.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load PI
	When Create document PurchaseInvoice objects (check movements)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server	
		| "Documents.PurchaseInvoice.FindByNumber(116).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(118).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(119).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document PurchaseInvoice objects (with aging, prepaid, post-shipment credit)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(323).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server	
		| "Documents.PurchaseInvoice.FindByNumber(324).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I close all client application windows
	When Create document PurchaseInvoice and InventoryTransfer objects (Store distributed purchase, movements)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(1501).GetObject().Write(DocumentWriteMode.Posting);"   |
	* Load PI comission trade 
	When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
	And I execute 1C:Enterprise script at server	
		| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"   |
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
			| "Documents.InventoryTransfer.FindByNumber(2503).GetObject().Write(DocumentWriteMode.Posting);"   |
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
	


Scenario: _040961 check preparation
	When check preparation

// 115
Scenario: _04097 check Purchase invoice movements by the Register  "R1021 Vendors transactions"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1021 Vendors transactions"
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                 | ''                                               | ''           | ''                       | ''                            |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                 | ''                                               | ''           | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'           | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                 | ''                                               | ''           | ''                       | ''                            |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''                     | ''                                                 | ''                                               | ''           | 'Attributes'             | ''                            |
			| ''                                                 | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Agreement'            | 'Basis'                                            | 'Order'                                          | 'Project'    | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '393,76'      | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | ''           | 'No'                     | ''                            |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '2 300'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | ''           | 'No'                     | ''                            |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '2 300'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | ''           | 'No'                     | ''                            |
		And I close all client application windows
		
Scenario: _04098 check Purchase invoice movements by the Register  "R1001 Purchases"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1001 Purchases"
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56' | ''                    | ''          | ''       | ''           | ''              | ''             | ''             | ''                             | ''         | ''                                               | ''          | ''                  | ''                                     | ''                     |
			| 'Document registrations records'                 | ''                    | ''          | ''       | ''           | ''              | ''             | ''             | ''                             | ''         | ''                                               | ''          | ''                  | ''                                     | ''                     |
			| 'Register  "R1001 Purchases"'                    | ''                    | ''          | ''       | ''           | ''              | ''             | ''             | ''                             | ''         | ''                                               | ''          | ''                  | ''                                     | ''                     |
			| ''                                               | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''             | ''                             | ''         | ''                                               | ''          | ''                  | ''                                     | 'Attributes'           |
			| ''                                               | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Invoice'                                        | 'Item key'  | 'Serial lot number' | 'Row key'                              | 'Deferred calculation' |
			| ''                                               | '12.02.2021 15:13:56' | '2'         | '51,36'  | '43,53'      | ''              | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Internet'  | ''                  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '2'         | '300'    | '254,24'     | ''              | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Internet'  | ''                  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '2'         | '300'    | '254,24'     | ''              | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'Internet'  | ''                  | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '5'         | '171,2'  | '145,09'     | ''              | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | '36/Yellow' | ''                  | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '5'         | '1 000'  | '847,46'     | ''              | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | '36/Yellow' | ''                  | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '5'         | '1 000'  | '847,46'     | ''              | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | '36/Yellow' | ''                  | '18d36228-af88-4ba5-a17a-f3ab3ddb6816' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '10'        | '171,2'  | '145,09'     | ''              | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'S/Yellow'  | ''                  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '10'        | '1 000'  | '847,46'     | ''              | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'S/Yellow'  | ''                  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |
			| ''                                               | '12.02.2021 15:13:56' | '10'        | '1 000'  | '847,46'     | ''              | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'Purchase invoice 115 dated 12.02.2021 15:13:56' | 'S/Yellow'  | ''                  | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce' | 'No'                   |
			
		And I close all client application windows
		
Scenario: _04099 check Purchase invoice movements by the Register  "R1005 Special offers of purchases" (without special offers)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1005 Special offers of purchases"
		And I click "Registrations report" button
		And I select "R1005 Special offers of purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1005 Special offers of purchases"'    |
			
		And I close all client application windows
		
Scenario: _040100 check Purchase invoice movements by the Register  "R5010 Reconciliation statement"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| 'Register  "R5010 Reconciliation statement"'       | ''              | ''                      | ''            | ''               | ''               | ''           | ''                    | ''                       |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                    | ''                       |
			| ''                                                 | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'          | 'Legal name contract'    |
			| ''                                                 | 'Expense'       | '12.02.2021 15:13:56'   | '2 300'       | 'Main Company'   | 'Front office'   | 'TRY'        | 'Company Ferron BP'   | 'Contract Ferron BP'     |
		And I close all client application windows
		
Scenario: _040101 check Purchase invoice movements by the Register  "R4010 Actual stocks" (use GR)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'    |
			
		And I close all client application windows
		
Scenario: _040102 check Purchase invoice movements by the Register  "R4017 Procurement of internal supply requests" (without ISR)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
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
		
		
Scenario: _040104 check Purchase invoice movements by the Register  "R4050 Stock inventory"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | ''              | ''                      | ''            | ''               | ''           | ''             |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''           | ''             |
			| 'Register  "R4050 Stock inventory"'                | ''              | ''                      | ''            | ''               | ''           | ''             |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''             |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'     |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '5'           | 'Main Company'   | 'Store 02'   | '36/Yellow'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '10'          | 'Main Company'   | 'Store 02'   | 'S/Yellow'     |
		And I close all client application windows
		
Scenario: _040105 check Purchase invoice movements by the Register  "R4011 Free stocks"  (use GR)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'    |
			
		And I close all client application windows
		
Scenario: _040106 check Purchase invoice movements by the Register  "R1031 Receipt invoicing" (PO-GR-PI)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1031 Receipt invoicing"
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                              | ''             |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                              | ''             |
			| 'Register  "R1031 Receipt invoicing"'              | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                              | ''             |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                              | ''             |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Basis'                                         | 'Item key'     |
			| ''                                                 | 'Expense'       | '12.02.2021 15:13:56'   | '5'           | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Goods receipt 115 dated 12.02.2021 15:10:35'   | '36/Yellow'    |
			| ''                                                 | 'Expense'       | '12.02.2021 15:13:56'   | '10'          | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Goods receipt 115 dated 12.02.2021 15:10:35'   | 'S/Yellow'     |

		And I close all client application windows
		
Scenario: _040107 check Purchase invoice movements by the Register  "R1040 Taxes outgoing"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1040 Taxes outgoing"
		And I click "Registrations report" button
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56' | ''            | ''                    | ''          | ''             | ''             | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''             | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| 'Register  "R1040 Taxes outgoing"'               | ''            | ''                    | ''          | ''             | ''             | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''    | ''         | ''             | ''                             | ''         | ''                     |
			| ''                                               | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Tax' | 'Tax rate' | 'Invoice type' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' |
			| ''                                               | 'Receipt'     | '12.02.2021 15:13:56' | '60,06'     | 'Main Company' | 'Front office' | 'VAT' | '18%'      | 'Invoice'      | 'Reporting currency'           | 'USD'      | 'TRY'                  |
			| ''                                               | 'Receipt'     | '12.02.2021 15:13:56' | '350,84'    | 'Main Company' | 'Front office' | 'VAT' | '18%'      | 'Invoice'      | 'Local currency'               | 'TRY'      | 'TRY'                  |
			| ''                                               | 'Receipt'     | '12.02.2021 15:13:56' | '350,84'    | 'Main Company' | 'Front office' | 'VAT' | '18%'      | 'Invoice'      | 'en description is empty'      | 'TRY'      | 'TRY'                  |		
		And I close all client application windows
		
Scenario: _040108 check Purchase invoice movements by the Register  "R1012 Invoice closing of purchase orders" (PO exists)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders"
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'         | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                               | ''           | ''            | ''                                        |
			| 'Document registrations records'                         | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                               | ''           | ''            | ''                                        |
			| 'Register  "R1012 Invoice closing of purchase orders"'   | ''              | ''                      | ''            | ''         | ''             | ''               | ''               | ''                                               | ''           | ''            | ''                                        |
			| ''                                                       | 'Record type'   | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''               | ''                                               | ''           | ''            | ''                                        |
			| ''                                                       | ''              | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'         | 'Order'                                          | 'Currency'   | 'Item key'    | 'Row key'                                 |
			| ''                                                       | 'Expense'       | '12.02.2021 15:13:56'   | '2'           | '300'      | '254,24'       | 'Main Company'   | 'Front office'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'TRY'        | 'Internet'    | '9db770ce-c5f9-4f4c-a8a9-7adc10793d77'    |
			| ''                                                       | 'Expense'       | '12.02.2021 15:13:56'   | '5'           | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'TRY'        | '36/Yellow'   | '18d36228-af88-4ba5-a17a-f3ab3ddb6816'    |
			| ''                                                       | 'Expense'       | '12.02.2021 15:13:56'   | '10'          | '1 000'    | '847,46'       | 'Main Company'   | 'Front office'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'TRY'        | 'S/Yellow'    | '3e2661d8-cf3b-4695-8cf7-a14ecc9f32ce'    |
		And I close all client application windows
		
Scenario: _040109 check Purchase invoice movements by the Register  "R4035 Incoming stocks"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4035 Incoming stocks"
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4035 Incoming stocks"'    |
			
		And I close all client application windows
		
Scenario: _040110 check Purchase invoice movements by the Register  "R4012 Stock Reservation" (without IncomingStocksRequested)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
			
		And I close all client application windows
		
Scenario: _040111 check Purchase invoice movements by the Register  "R2013 Procurement of sales orders" (without SO)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
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
		
Scenario: _040112 check Purchase invoice movements by the Register  "R4036 Incoming stock requested" (without IncomingStocksRequested)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
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
		
Scenario: _040113 check Purchase invoice movements by the Register  "R4014 Serial lot numbers" (not use Serial lot numbers)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'    |
			
		And I close all client application windows
		
Scenario: _040114 check Purchase invoice movements by the Register  "R1011 Receipt of purchase orders" (use GR)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R1011 Receipt of purchase orders"
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1011 Receipt of purchase orders"'    |
			
		And I close all client application windows




		

// 117

		
		
Scenario: _040993 check Purchase invoice movements by the Register  "R1005 Special offers of purchases" (with special offers)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R1005 Special offers of purchases"
		And I click "Registrations report" button
		And I select "R1005 Special offers of purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | ''                      | ''                | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                   | ''                        |
			| 'Document registrations records'                   | ''                      | ''                | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                   | ''                        |
			| 'Register  "R1005 Special offers of purchases"'    | ''                      | ''                | ''               | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                   | ''                        |
			| ''                                                 | 'Period'                | 'Resources'       | 'Dimensions'     | ''               | ''                               | ''           | ''                                                 | ''            | ''                                       | ''                   | 'Attributes'              |
			| ''                                                 | ''                      | 'Offers amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                          | 'Item key'    | 'Row key'                                | 'Special offer'      | 'Deferred calculation'    |
			| ''                                                 | '12.02.2021 15:12:15'   | '5,14'            | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '17,12'           | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '17,12'           | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '30'              | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '30'              | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'Internet'    | '1b90516b-b3ac-4ca5-bb47-44477975f242'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '100'             | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '100'             | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   |'923e7825-c20f-4a3e-a983-2b85d80e475a'    | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '100'             | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | 'S/Yellow'    | '4fcbb4cf-3824-47fb-89b5-50d151315d4d'   | 'DocumentDiscount'   | 'No'                      |
			| ''                                                 | '12.02.2021 15:12:15'   | '100'             | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'   | '923e7825-c20f-4a3e-a983-2b85d80e475a'   | 'DocumentDiscount'   | 'No'                      |
			
		And I close all client application windows
		



		
Scenario: _0401063 check Purchase invoice movements by the Register  "R1031 Receipt invoicing" (PO-PI)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R1031 Receipt invoicing"
		And I click "Registrations report" button
		And I select "R1031 Receipt invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                 | ''             |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                 | ''             |
			| 'Register  "R1031 Receipt invoicing"'              | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                 | ''             |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                                 | ''             |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Basis'                                            | 'Item key'     |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:12:15'   | '5'           | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | '36/Yellow'    |


		And I close all client application windows
		


Scenario: _0401066 check Purchase invoice movements by the Register  "R4017 Procurement of internal supply requests" (ISR exists)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R4017 Procurement of internal supply requests"
		And I click "Registrations report" button
		And I select "R4017 Procurement of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'              | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                        | ''            |
			| 'Document registrations records'                              | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                        | ''            |
			| 'Register  "R4017 Procurement of internal supply requests"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                                                        | ''            |
			| ''                                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                                                        | ''            |
			| ''                                                            | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'      | 'Internal supply request'                                 | 'Item key'    |
			| ''                                                            | 'Expense'       | '12.02.2021 15:12:15'   | '10'          | 'Main Company'   | 'Front office'   | 'Store 02'   | 'Internal supply request 117 dated 12.02.2021 14:39:38'   | 'S/Yellow'    |

		And I close all client application windows


Scenario: _0401068 check Purchase invoice movements by the Register  "R1011 Receipt of purchase orders" (PO exists, not use GR)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register "R1011 Receipt of purchase orders"
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''         | ''                                     |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''         | ''                                     |
			| 'Register  "R1011 Receipt of purchase orders"'   | ''            | ''                    | ''          | ''             | ''             | ''                                             | ''         | ''                                     |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                             | ''         | ''                                     |
			| ''                                               | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'       | 'Order'                                        | 'Item key' | 'Row key'                              |
			| ''                                               | 'Expense'     | '12.02.2021 15:12:15' | '10'        | 'Main Company' | 'Front office' | 'Purchase order 117 dated 12.02.2021 12:45:05' | 'S/Yellow' | '4fcbb4cf-3824-47fb-89b5-50d151315d4d' |

		And I close all client application windows

Scenario: _0401069 check Purchase invoice movements by the Register  "R4014 Serial lot numbers" (use Serial lot numbers)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | ''              | ''                      | ''            | ''               | ''               | ''        | ''           | ''                     |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''        | ''           | ''                     |
			| 'Register  "R4014 Serial lot numbers"'             | ''              | ''                      | ''            | ''               | ''               | ''        | ''           | ''                     |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''        | ''           | ''                     |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'         | 'Store'   | 'Item key'   | 'Serial lot number'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:12:15'   | '10'          | 'Main Company'   | 'Front office'   | ''        | 'S/Yellow'   | '0512'                 |
		And I close all client application windows

Scenario: _0401070 check Purchase invoice movements by the Register  "R5022 Expenses" (PO-PI)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R5022 Expenses"
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| 'Document registrations records'                 | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| 'Register  "R5022 Expenses"'                     | ''                    | ''          | ''                  | ''            | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| ''                                               | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | 'Attributes'                |
			| ''                                               | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'    | 'Calculation movement cost' |
			| ''                                               | '12.02.2021 15:12:15' | '39,17'     | '46,22'             | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' | ''                          |
			| ''                                               | '12.02.2021 15:12:15' | '228,81'    | '270'               | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' | ''                          |
			| ''                                               | '12.02.2021 15:12:15' | '228,81'    | '270'               | ''            | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | 'Internet' | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' | ''                          |
		And I close all client application windows

//PI (without GR)

	
Scenario: _0401054 check Purchase invoice movements by the Register  "R4011 Free stocks" (not use GR, GR not exists)
	And I close all client application windows
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '118'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 118 dated 12.02.2021 16:08:41'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                    | ''              | ''                      | ''            | ''             | ''             |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                 | 'Receipt'       | '12.02.2021 16:08:41'   | '5'           | 'Store 02'     | '36/Yellow'    |
		And I close all client application windows




Scenario: _0401093 check Purchase invoice movements by the Register  "R1012 Invoice closing of purchase orders" (without PO)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '118'       |
	* Check movements by the Register  "R1012 Invoice closing of purchase orders"
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1012 Invoice closing of purchase orders"'    |
			
		And I close all client application windows

Scenario: _0401014 check Purchase invoice movements by the Register  "R4010 Actual stocks" (not use GR)
	And I close all client application windows
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                  | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:12:15'   | '10'          | 'Store 02'     | 'S/Yellow'   | '0512'                 |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:12:15'   | '24'          | 'Store 02'     | '37/18SD'    | ''                     |
		And I close all client application windows

Scenario: _0401015 check Purchase invoice movements by the Register  "R4031 Goods in transit (incoming)" (one string use GR, 2 string not use GR)
	And I close all client application windows
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '118'       |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 118 dated 12.02.2021 16:08:41'   | ''              | ''                      | ''            | ''             | ''                                                 | ''            |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''             | ''                                                 | ''            |
			| 'Register  "R4031 Goods in transit (incoming)"'    | ''              | ''                      | ''            | ''             | ''                                                 | ''            |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                                 | ''            |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                            | 'Item key'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 16:08:41'   | '10'          | 'Store 02'     | 'Purchase invoice 118 dated 12.02.2021 16:08:41'   | 'S/Yellow'    |
		And I close all client application windows

Scenario: _0401016 check Purchase invoice movements by the Register  "R4031 Goods in transit (incoming)" (GR-PI)
	And I close all client application windows
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '119'       |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 119 dated 12.02.2021 16:21:23'   | ''              | ''                      | ''            | ''             | ''                                              | ''             |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''             | ''                                              | ''             |
			| 'Register  "R4031 Goods in transit (incoming)"'    | ''              | ''                      | ''            | ''             | ''                                              | ''             |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                              | ''             |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                         | 'Item key'     |
			| ''                                                 | 'Receipt'       | '12.02.2021 16:21:23'   | '5'           | 'Store 02'     | 'Goods receipt 119 dated 12.02.2021 16:20:35'   | '36/Yellow'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 16:21:23'   | '10'          | 'Store 02'     | 'Goods receipt 119 dated 12.02.2021 16:20:35'   | 'S/Yellow'     |
		And I close all client application windows

Scenario: _0401017 check Purchase invoice movements by the Register  "R4031 Goods in transit (incoming)" (PO-GR-PI)
	And I close all client application windows
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'   | ''              | ''                      | ''            | ''             | ''                                              | ''             |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''             | ''                                              | ''             |
			| 'Register  "R4031 Goods in transit (incoming)"'    | ''              | ''                      | ''            | ''             | ''                                              | ''             |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''                                              | ''             |
			| ''                                                 | ''              | ''                      | 'Quantity'    | 'Store'        | 'Basis'                                         | 'Item key'     |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '5'           | 'Store 02'     | 'Goods receipt 115 dated 12.02.2021 15:10:35'   | '36/Yellow'    |
			| ''                                                 | 'Receipt'       | '12.02.2021 15:13:56'   | '10'          | 'Store 02'     | 'Goods receipt 115 dated 12.02.2021 15:10:35'   | 'S/Yellow'     |
		And I close all client application windows

Scenario: _0401020 check there is no Purchase invoice movements by the Register  "R1022 Vendors payment planning" (with aging, Prepaid)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '323'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 323 dated 30.05.2021 15:08:40'    |
			| 'Document registrations records'                    |
		And I close all client application windows

Scenario: _0401021 check Purchase invoice movements by the Register  "R1022 Vendors payment planning" (with aging, Post-shipment credit)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 324 dated 30.05.2021 15:09:00'   | ''              | ''                      | ''            | ''               | ''               | ''                                                 | ''                    | ''            | ''                      |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''                                                 | ''                    | ''            | ''                      |
			| 'Register  "R1022 Vendors payment planning"'       | ''              | ''                      | ''            | ''               | ''               | ''                                                 | ''                    | ''            | ''                      |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                                                 | ''                    | ''            | ''                      |
			| ''                                                 | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Basis'                                            | 'Legal name'          | 'Partner'     | 'Agreement'             |
			| ''                                                 | 'Receipt'       | '30.05.2021 15:09:00'   | '1 170'       | 'Main Company'   | 'Front office'   | 'Purchase invoice 324 dated 30.05.2021 15:09:00'   | 'Company Ferron BP'   | 'Ferron BP'   | 'Vendor Ferron, TRY'    |
		And I close all client application windows

Scenario: _0401022 check there is no Purchase invoice movements by the Register  "R1022 Vendors payment planning" (without aging)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R1022 Vendors payment planning" 
		And I click "Registrations report" button
		And I select "R1022 Vendors payment planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'    |
			| 'Document registrations records'                    |
		And I close all client application windows

Scenario: _0401023 check there is no Purchase invoice movements by the Register  "R5012 Vendors aging" (without aging)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "R5012 Vendors aging" 
		And I click "Registrations report" button
		And I select "R5012 Vendors aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15'    |
			| 'Document registrations records'                    |
		And I close all client application windows

Scenario: _0401024 check Purchase invoice movements by the Register  "R5012 Vendors aging" (with aging)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '324'       |
	* Check movements by the Register  "R5012 Vendors aging" 
		And I click "Registrations report" button
		And I select "R5012 Vendors aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 324 dated 30.05.2021 15:09:00'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                     | ''            | ''                                                 | ''                      | ''                 |
			| 'Document registrations records'                   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                     | ''            | ''                                                 | ''                      | ''                 |
			| 'Register  "R5012 Vendors aging"'                  | ''              | ''                      | ''            | ''               | ''               | ''           | ''                     | ''            | ''                                                 | ''                      | ''                 |
			| ''                                                 | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                     | ''            | ''                                                 | ''                      | 'Attributes'       |
			| ''                                                 | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Agreement'            | 'Partner'     | 'Invoice'                                          | 'Payment date'          | 'Aging closing'    |
			| ''                                                 | 'Receipt'       | '30.05.2021 15:09:00'   | '1 170'       | 'Main Company'   | 'Front office'   | 'TRY'        | 'Vendor Ferron, TRY'   | 'Ferron BP'   | 'Purchase invoice 324 dated 30.05.2021 15:09:00'   | '07.06.2021 00:00:00'   | ''                 |
		And I close all client application windows

Scenario: _0401025 check Purchase invoice movements by the Register  "R4010 Actual stocks" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'                | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                               | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '2'         | 'Store 02'   | 'ODS'      | '1123'              |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '10'        | 'Store 02'   | 'UNIQ'     | '0512'              |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '10'        | 'Store 02'   | 'UNIQ'     | '11111111111111'    |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '10'        | 'Store 02'   | 'M/Black'  | ''                  |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '14'        | 'Store 02'   | 'XL/Red'   | ''                  |		
		And I close all client application windows

Scenario: _0401026 check Purchase invoice movements by the Register  "R4011 Free stocks" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                  | ''            | ''                    | ''          | ''           | ''         |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                               | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '2'         | 'Store 02'   | 'ODS'      |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '10'        | 'Store 02'   | 'UNIQ'     |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '10'        | 'Store 02'   | 'UNIQ'     |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '10'        | 'Store 02'   | 'M/Black'  |
			| ''                                               | 'Receipt'     | '02.11.2022 16:31:38' | '14'        | 'Store 02'   | 'XL/Red'   |		
		And I close all client application windows

Scenario: _0401027 check Purchase invoice movements by the Register  "R4014 Serial lot numbers" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R4014 Serial lot numbers" 
		And I click "Registrations report info" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 195 dated 02.11.2022 16:31:38' | ''                    | ''           | ''             | ''                        | ''      | ''         | ''                  | ''         |
			| 'Register  "R4014 Serial lot numbers"'           | ''                    | ''           | ''             | ''                        | ''      | ''         | ''                  | ''         |
			| ''                                               | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Store' | 'Item key' | 'Serial lot number' | 'Quantity' |
			| ''                                               | '02.11.2022 16:31:38' | 'Receipt'    | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '0512'              | '10'       |
			| ''                                               | '02.11.2022 16:31:38' | 'Receipt'    | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '11111111111111'    | '5'        |
			| ''                                               | '02.11.2022 16:31:38' | 'Receipt'    | 'Main Company' | 'Distribution department' | ''      | 'UNIQ'     | '11111111111111'    | '10'       |
			| ''                                               | '02.11.2022 16:31:38' | 'Receipt'    | 'Main Company' | 'Distribution department' | ''      | 'ODS'      | '1123'              | '2'        |	
		And I close all client application windows


Scenario: _0401030 check there is no Purchase invoice movements by the Register  "R1001 Purchases" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1001 Purchases" 
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1001 Purchases"'    |
		And I close all client application windows

Scenario: _0401031 check there is no Purchase invoice movements by the Register  "R1021 Vendors transactions" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1001 Purchases" 
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1001 Purchases"'    |
		And I close all client application windows

Scenario: _0401031 check there is no Purchase invoice movements by the Register  "R1021 Vendors transactions" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1021 Vendors transactions"'    |
		And I close all client application windows


Scenario: _0401032 check there is no Purchase invoice movements by the Register  "R1040 Taxes outgoing" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R1040 Taxes outgoing" 
		And I click "Registrations report" button
		And I select "R1040 Taxes outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R1040 Taxes outgoing"'    |
		And I close all client application windows

Scenario: _0401033 check there is no Purchase invoice movements by the Register  "R4050 Stock inventory" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4050 Stock inventory"'    |
		And I close all client application windows

Scenario: _0401034 check there is no Purchase invoice movements by the Register  "R5010 Reconciliation statement" (Receipt from consignor)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5010 Reconciliation statement"'    |
		And I close all client application windows

Scenario: _0401035 check Purchase invoice movements by the Register  "S1001L Vendors prices by item key" (record purchase prices)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "S1001L Vendors prices by item key" 
		And I click "Registrations report" button
		And I select "S1001L Vendors prices by item key" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''                    | ''          | ''            | ''          | ''                        | ''          | ''          | ''     | ''         |
			| 'Document registrations records'                 | ''                    | ''          | ''            | ''          | ''                        | ''          | ''          | ''     | ''         |
			| 'Register  "S1001L Vendors prices by item key"'  | ''                    | ''          | ''            | ''          | ''                        | ''          | ''          | ''     | ''         |
			| ''                                               | 'Period'              | 'Resources' | ''            | ''          | 'Dimensions'              | ''          | ''          | ''     | ''         |
			| ''                                               | ''                    | 'Price'     | 'Total price' | 'Net price' | 'Price type'              | 'Partner'   | 'Item key'  | 'Unit' | 'Currency' |
			| ''                                               | '12.02.2021 15:12:15' | '100'       | '90'          | '76,27'     | 'en description is empty' | 'Ferron BP' | 'S/Yellow'  | 'pcs'  | 'TRY'      |
			| ''                                               | '12.02.2021 15:12:15' | '100'       | '100'         | '84,75'     | 'en description is empty' | 'Ferron BP' | '37/18SD'   | 'pcs'  | 'TRY'      |
			| ''                                               | '12.02.2021 15:12:15' | '150'       | '135'         | '114,41'    | 'en description is empty' | 'Ferron BP' | 'Internet'  | 'pcs'  | 'TRY'      |
			| ''                                               | '12.02.2021 15:12:15' | '200'       | '180'         | '152,54'    | 'en description is empty' | 'Ferron BP' | '36/Yellow' | 'pcs'  | 'TRY'      |	
		And I close all client application windows

Scenario: _0401036 check Purchase invoice movements by the Register  "T2015 Transactions info" (Purchase)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 117 dated 12.02.2021 15:12:15' | ''             | ''             | ''                                             | ''                    | ''                                     | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                               | ''          | ''           | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'            | ''             | ''             | ''                                             | ''                    | ''                                     | ''         | ''          | ''                  | ''                   | ''                      | ''                        | ''                                               | ''          | ''           | ''       | ''       | ''        |
			| ''                                               | 'Company'      | 'Branch'       | 'Order'                                        | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'   | 'Legal name'        | 'Agreement'          | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                              | 'Unique ID' | 'Project'    | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                               | 'Main Company' | 'Front office' | ''                                             | '12.02.2021 15:12:15' | '                                    ' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Yes'                   | 'No'                      | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | '*'         | 'Project 01' | '2 400'  | 'Yes'    | 'No'      |
			| ''                                               | 'Main Company' | 'Front office' | 'Purchase order 117 dated 12.02.2021 12:45:05' | '12.02.2021 15:12:15' | '                                    ' | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'Yes'                   | 'No'                      | 'Purchase invoice 117 dated 12.02.2021 15:12:15' | '*'         | 'Project 01' | '2 070'  | 'Yes'    | 'No'      |
		And I close all client application windows

Scenario: _0401037 check absence Purchase invoice movements by the Register  "T2015 Transactions info" (Receipt from consignor)
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '195'       |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "T2015 Transactions info"'    |
		And I close all client application windows


Scenario: _0401038 check Purchase invoice movements by the Register  "R4032 Goods in transit (outgoing)" (Store distributed purchase=True)
	* Select Purchase invoice
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 501'     |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | ''                    | ''           | ''         | ''                                                 | ''         | ''                  | ''         |
			| 'Register  "R4032 Goods in transit (outgoing)"'    | ''                    | ''           | ''         | ''                                                 | ''         | ''                  | ''         |
			| ''                                                 | 'Period'              | 'RecordType' | 'Store'    | 'Basis'                                            | 'Item key' | 'Serial lot number' | 'Quantity' |
			| ''                                                 | '25.07.2024 13:46:27' | 'Receipt'    | 'Store 02' | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Blue'  | ''                  | '10'       |
			| ''                                                 | '25.07.2024 13:46:27' | 'Receipt'    | 'Store 02' | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Red'   | ''                  | '5'        |
			| ''                                                 | '25.07.2024 13:46:27' | 'Receipt'    | 'Store 02' | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'ODS'      | '9090098908'        | '10'       |
			| ''                                                 | '25.07.2024 13:46:27' | 'Receipt'    | 'Store 02' | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977889'    | '5'        |
			| ''                                                 | '25.07.2024 13:46:27' | 'Receipt'    | 'Store 02' | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977890'    | '5'        | 				
		And I close all client application windows

Scenario: _0401039 check absence Purchase invoice movements by the Register  "R4032 Goods in transit (outgoing)" (Store distributed purchase=False)
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '117'     |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report info" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4032 Goods in transit (outgoing)"'    |
		And I close all client application windows

Scenario: _0401040 check Purchase invoice movements by the Register  "R1001 Purchases"
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '1 501'     |
	* Check movements by the Register  "R1001 Purchases"
		And I click "Registrations report" button
		And I select "R1001 Purchases" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | ''                    | ''          | ''       | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                                 | ''         | ''                  | ''                                     | ''                     |
			| 'Document registrations records'                   | ''                    | ''          | ''       | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                                 | ''         | ''                  | ''                                     | ''                     |
			| 'Register  "R1001 Purchases"'                      | ''                    | ''          | ''       | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                                 | ''         | ''                  | ''                                     | ''                     |
			| ''                                                 | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''       | ''                             | ''         | ''                                                 | ''         | ''                  | ''                                     | 'Attributes'           |
			| ''                                                 | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                          | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Deferred calculation' |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '17,12'  | '14,51'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Red'   | ''                  | '0140fb0f-8cb5-4212-baf5-0a26dd56bbee' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '85,6'   | '72,54'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977889'    | 'e7872168-078c-4a82-b44f-4c96e4e18c3e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '85,6'   | '72,54'      | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977890'    | 'e7872168-078c-4a82-b44f-4c96e4e18c3e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '100'    | '84,75'      | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Red'   | ''                  | '0140fb0f-8cb5-4212-baf5-0a26dd56bbee' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '100'    | '84,75'      | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Red'   | ''                  | '0140fb0f-8cb5-4212-baf5-0a26dd56bbee' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '500'    | '423,73'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977889'    | 'e7872168-078c-4a82-b44f-4c96e4e18c3e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '500'    | '423,73'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977890'    | 'e7872168-078c-4a82-b44f-4c96e4e18c3e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '500'    | '423,73'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977889'    | 'e7872168-078c-4a82-b44f-4c96e4e18c3e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '5'         | '500'    | '423,73'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'UNIQ'     | '09987897977890'    | 'e7872168-078c-4a82-b44f-4c96e4e18c3e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '10'        | '171,2'  | '145,09'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Blue'  | ''                  | '474371a7-a9a5-4d6a-b58f-0abdd370c36e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '10'        | '171,2'  | '145,09'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'ODS'      | '9090098908'        | '29d1bdf0-143d-438a-9e1b-e5b25241d87e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '10'        | '1 000'  | '847,46'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Blue'  | ''                  | '474371a7-a9a5-4d6a-b58f-0abdd370c36e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '10'        | '1 000'  | '847,46'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'ODS'      | '9090098908'        | '29d1bdf0-143d-438a-9e1b-e5b25241d87e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '10'        | '1 000'  | '847,46'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'XS/Blue'  | ''                  | '474371a7-a9a5-4d6a-b58f-0abdd370c36e' | 'No'                   |
			| ''                                                 | '25.07.2024 13:46:27' | '10'        | '1 000'  | '847,46'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Purchase invoice 1 501 dated 25.07.2024 13:46:27' | 'ODS'      | '9090098908'        | '29d1bdf0-143d-438a-9e1b-e5b25241d87e' | 'No'                   |		
		And I close all client application windows

Scenario: _0401041 check absence Purchase invoice movements by the Register  "R4012 Stock Reservation" (SalesOrder not exist)
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '115'     |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows

Scenario: _0401042 check Purchase invoice movements by the Register  "R4012 Stock Reservation" (SalesOrderExists, GR not use)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2 502'     |
	* Check movements by the Register  ""R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 2 502 dated 11.09.2024 13:51:30' | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| 'Register  "R4012 Stock Reservation"'              | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| ''                                                 | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Order'                                       | 'Quantity' |
			| ''                                                 | '11.09.2024 13:51:30' | 'Receipt'    | 'Store 02' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '5'        |
			| ''                                                 | '11.09.2024 13:51:30' | 'Receipt'    | 'Store 02' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '5'        |
			| ''                                                 | '11.09.2024 13:51:30' | 'Receipt'    | 'Store 02' | 'UNIQ'     | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '5'        |		
		And I close all client application windows

Scenario: _0401043 check absence Purchase invoice movements by the Register "R4012 Stock Reservation" (SalesOrderExists, GR use, GR before PI)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2 503'   |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'    |
		And I close all client application windows

Scenario: _0401044 check Purchase invoice movements by the Register  "R4012 Stock Reservation" (SalesOrderExists, GR (1 line from 3), GR after PI)
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '2 504'     |
	* Check movements by the Register  ""R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 2 504 dated 11.09.2024 14:07:03' | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| 'Register  "R4012 Stock Reservation"'              | ''                    | ''           | ''         | ''         | ''                                            | ''         |
			| ''                                                 | 'Period'              | 'RecordType' | 'Store'    | 'Item key' | 'Order'                                       | 'Quantity' |
			| ''                                                 | '11.09.2024 14:07:03' | 'Receipt'    | 'Store 02' | 'ODS'      | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '3'        |
			| ''                                                 | '11.09.2024 14:07:03' | 'Receipt'    | 'Store 02' | 'UNIQ'     | 'Sales order 2 316 dated 11.09.2024 13:48:13' | '3'        |	
		And I close all client application windows

Scenario: _0401019 Purchase invoice clear posting/mark for deletion
	* Select Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'    |
			| 'Document registrations records'                    |
		And I close current window
	* Post Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '115'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1001 Purchases'               |
			| 'R1021 Vendors transactions'    |
			| 'R4050 Stock inventory'         |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
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
			| 'Purchase invoice 115 dated 12.02.2021 15:13:56'    |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
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
			| 'R1001 Purchases'               |
			| 'R1021 Vendors transactions'    |
			| 'R4050 Stock inventory'         |
		And I close all client application windows

