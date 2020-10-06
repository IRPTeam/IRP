#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase invoice

As a procurement manager
I want to create a Purchase invoice document
To track a product that has been received from a vendor

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _018000 preparation
	* Constants
		When set True value to the constant
	* Load info
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseOrder017003
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017003$$" |
			When create PurchaseOrder017001
	



Scenario: _018001 create document Purchase Invoice based on order - Goods receipt is not used
	When create PurchaseInvoice018001 based on PurchaseOrder017001
	

Scenario: _018002 check Purchase Invoice movements by register Order Balance (minus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Store'    | 'Order'                   | 'Item key'  |
		| '100,000'  | '$$PurchaseInvoice018001$$' | 'Store 01' | '$$PurchaseOrder017001$$' | 'M/White'   |
		| '200,000'  | '$$PurchaseInvoice018001$$' | 'Store 01' | '$$PurchaseOrder017001$$' | 'L/Green'   |
		| '300,000'  | '$$PurchaseInvoice018001$$' | 'Store 01' | '$$PurchaseOrder017001$$' | '36/Yellow' |


Scenario: _018003 check Purchase Invoice movements by register Stock Balance (plus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Store'     | 'Item key' |
		| '100,000'  | '$$PurchaseInvoice018001$$' | 'Store 01'  | 'M/White'  |
		| '200,000'  | '$$PurchaseInvoice018001$$' |  'Store 01' | 'L/Green'  |
		| '300,000'  | '$$PurchaseInvoice018001$$' |  'Store 01' | '36/Yellow'|

Scenario: _018004 check Purchase Invoice movements by register Stock Reservation (plus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key'  |
		| '100,000'  | '$$PurchaseInvoice018001$$' | 'Store 01' | 'M/White'   |
		| '200,000'  | '$$PurchaseInvoice018001$$' | 'Store 01' | 'L/Green'   |
		| '300,000'  | '$$PurchaseInvoice018001$$' | 'Store 01' | '36/Yellow' |

Scenario: _018005 check Purchase Invoice movements by register Inventory Balance - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Company'      | 'Item key'  |
		| '100,000'  | '$$PurchaseInvoice018001$$' | 'Main Company' | 'M/White'   |
		| '200,000'  | '$$PurchaseInvoice018001$$' | 'Main Company' | 'L/Green'   |
		| '300,000'  | '$$PurchaseInvoice018001$$' | 'Main Company' | '36/Yellow' |

Scenario: _018006 create document Purchase Invoice based on order - Goods receipt is used
	When create PurchaseInvoice018006 based on PurchaseOrder017003
	

Scenario: _018007 check Purchase Invoice movements by register Order Balance (minus) - Goods receipt is used
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Line number' | 'Store'    | 'Order'                   | 'Item key' |
		| '500,000'  | '$$PurchaseInvoice018006$$' | '1'           | 'Store 02' | '$$PurchaseOrder017003$$' | 'L/Green'  |


Scenario: _018008 check Purchase Invoice movements by register Inventory Balance (plus) - Goods receipt is used
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Line number' | 'Company'      | 'Item key' |
		| '500,000'  | '$$PurchaseInvoice018006$$' | '1'           | 'Main Company' | 'L/Green'  |

Scenario: _018009 check Purchase Invoice movements by register GoodsInTransitIncoming (plus) - Goods receipt is used
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Receipt basis'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | '$$PurchaseInvoice018006$$' | '$$PurchaseInvoice018006$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _018010 check that there are no movements of Purchase Invoice document by register StockBalance if used Goods receipt 
# if Goods receipt is used, there will be no posting
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                  | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | '$$PurchaseInvoice018006$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _018011 check that there are no movements of Purchase Invoice document by register StockReservation if used Goods receipt 
# if Goods receipt is used, there will be no posting
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                  | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | '$$PurchaseInvoice018006$$' | '1'           | 'Store 01' | 'L/Green'  |

Scenario: _018012 Purchase invoice creation on set, store does not use Goods receipt
	* Creating Purchase Invoice without Purchase order	
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
	// * Filling in the document number
	// 	And I input "5" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "5" text in "Number" field
	* Filling in vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description        |
			| Vendor Ferron, EUR |
		And I select current line in "List" table
	* Filling in store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Dress/A-8'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Boots       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key  |
			| Boots | Boots/S-8 |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018012$$"
		And I save the window as "$$PurchaseInvoice018012$$"
		And I click the button named "FormPostAndClose"
	* Check movements by register
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key'  |
			| '10,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Dress/A-8' |
			| '20,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Boots/S-8' |
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key'  |
			| '10,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Dress/A-8' |
			| '20,000'   | '$$PurchaseInvoice018012$$' | 'Store 01' | 'Boots/S-8' |
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                  | 'Item key'  |
			| '10,000'   | '$$PurchaseInvoice018012$$' | 'Dress/A-8' |
			| '20,000'   | '$$PurchaseInvoice018012$$' | 'Boots/S-8' |


Scenario: _018018 check totals in the document Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Select Purchase Invoice
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
		And I select current line in "List" table
	* Check totals
		Then the form attribute named "ItemListTotalNetAmount" became equal to "16 949,15"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "3 050,85"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "20 000,00"


// Scenario: _018020 check the form Pick up items in the document Purchase invoice
// 	And I close all client application windows
// 	* Opening a form for creating Purchase invoice
// 		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
// 		And I click the button named "FormCreate"
// 	* Filling in the main details of the document
// 		And I click Select button of "Company" field
// 		And I go to line in "List" table
// 			| Description  |
// 			| Main Company |
// 		And I select current line in "List" table
// 	* Filling in vendor information
// 		And I click Select button of "Partner" field
// 		And I go to line in "List" table
// 			| Description |
// 			| Ferron BP   |
// 		And I select current line in "List" table
// 		And I click Select button of "Legal name" field
// 		And I activate "Description" field in "List" table
// 		And I go to line in "List" table
// 			| Description       |
// 			| Company Ferron BP |
// 		And I select current line in "List" table
// 		And I click Select button of "Partner term" field
// 		And I go to line in "List" table
// 			| Description        |
// 			| Vendor Ferron, TRY |
// 		And I select current line in "List" table
// 		And I click Select button of "Store" field
// 		Then "Stores" window is opened
// 		And I select current line in "List" table
// 	When check the product selection form with price information in Purchase invoice
// 	And I close all client application windows



Scenario: _018019 check the output of the document movement report for Purchase Invoice
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice018001$$'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | '$$PurchaseInvoice018001$$'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Partner term'          | 'Currency'                | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice018001$$'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | '$$PurchaseInvoice018001$$'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Partner term'          | 'Currency'                | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
	And I close all client application windows

Scenario: _01801901 clear movements Purchase invoice and check that there is no movements on the registers 
	* Open list form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| Register  "Purchase turnovers" |
			| 'Register  "Inventory balance"'        |
			| 'Register  "Taxes turnovers"'          |
			| 'Register  "Stock reservation"'        |
			| 'Register  "Reconciliation statement"' |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice018001$$'                  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Document registrations records'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Inventory balance"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Main Company' | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Main Company' | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Main Company' | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Purchase turnovers"'       | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | 'Quantity'  | 'Amount'        | 'Net amount'   | 'Company'             | 'Purchase invoice'    | 'Currency'          | 'Item key'           | 'Row key'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '3 424,66'      | '2 902,25'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'M/White'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '100'       | '20 000'        | '16 949,15'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'M/White'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '7 191,78'      | '6 094,73'     | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | 'L/Green'            | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '200'       | '42 000'        | '35 593,22'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | 'L/Green'            | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '12 842,47'     | '10 883,45'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'USD'               | '36/Yellow'          | '*'                       | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | '*'           | '300'       | '75 000'        | '63 559,32'    | 'Main Company'        | '$$PurchaseInvoice018001$$' | 'TRY'               | '36/Yellow'          | '*'                       | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Taxes turnovers"'          | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Period'      | 'Resources' | ''              | ''             | 'Dimensions'          | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | 'Attributes'           |
		| ''                                     | ''            | 'Amount'    | 'Manual amount' | 'Net amount'   | 'Document'            | 'Tax'                 | 'Analytics'         | 'Tax rate'           | 'Include to total amount' | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                     | '*'           | '522,41'    | '522,41'        | '2 902,25'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 097,05'  | '1 097,05'      | '6 094,73'     | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '1 959,02'  | '1 959,02'      | '10 883,45'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '3 050,85'  | '3 050,85'      | '16 949,15'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '6 406,78'  | '6 406,78'      | '35 593,22'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'en description is empty' | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
		| ''                                     | '*'           | '11 440,68' | '11 440,68'     | '63 559,32'    | '$$PurchaseInvoice018001$$' | 'VAT'                 | ''                  | '18%'                | 'Yes'                     | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Accounts statement"'               | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                             | ''                                             | 'Dimensions'                           | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                       | 'Transaction AR'                               | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                       | 'Currency'             | ''                         | ''                     |
		| ''                                             | 'Receipt'             | '*'                   | ''                    | '137 000'        | ''                                             | ''                                             | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | '$$PurchaseInvoice018001$$'                  | 'TRY'                  | ''                         | ''                     |
		| ''                                             | ''                    | ''                    | ''                    | ''               | ''                                             | ''                                             | ''                                     | ''                                     | ''                                     | ''                                     | ''                     | ''                         | ''                     |
		| 'Register  "Stock reservation"'        | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Legal name'          | 'Currency'            | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '137 000'       | 'Main Company' | 'Company Ferron BP'   | 'TRY'                 | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Goods receipt schedule"'   | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | 'Attributes'              | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Company'      | 'Order'               | 'Store'               | 'Item key'          | 'Row key'            | 'Delivery date'           | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'M/White'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | 'L/Green'           | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Main Company' | '$$PurchaseOrder017001$$'   | 'Store 01'            | '36/Yellow'         | '*'                  | '*'                       | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | 'Attributes'           | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Amount'        | 'Company'      | 'Basis document'      | 'Partner'             | 'Legal name'        | 'Partner term'          | 'Currency'                | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '23 458,9'      | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'                     | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'en description is empty' | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'Local currency'           | 'No'                   | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '137 000'       | 'Main Company' | '$$PurchaseInvoice018001$$' | 'Ferron BP'           | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'                     | 'TRY'                      | 'No'                   | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Order balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Order'               | 'Item key'            | 'Row key'           | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '100'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'M/White'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '200'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | 'L/Green'             | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Expense'     | '*'         | '300'           | 'Store 01'     | '$$PurchaseOrder017001$$'   | '36/Yellow'           | '*'                 | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| 'Register  "Stock balance"'            | ''            | ''          | ''              | ''             | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'   | ''                    | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'      | 'Store'        | 'Item key'            | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '100'           | 'Store 01'     | 'M/White'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '200'           | 'Store 01'     | 'L/Green'             | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '300'           | 'Store 01'     | '36/Yellow'           | ''                    | ''                  | ''                   | ''                        | ''                         | ''                     | ''                         | ''                     |
		And I close all client application windows


Scenario: _300503 check connection to Purchase invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberPurchaseInvoice018006$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
