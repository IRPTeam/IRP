#language: en
@tree
@Positive
@Sales

Feature: create document Sales invoice

As a sales manager
I want to create a Sales invoice document
To sell a product to a customer


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _023000 preparation (Sales invoice)
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
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
	* Check or create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023001$$" |
			When create SalesOrder023001
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023005$$" |
			When create SalesOrder023005

Scenario: _024001 create document Sales Invoice based on order - Shipment confirmation doesn't used
	When create SalesInvoice024001

Scenario: _024002 check Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register OrderBalance (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'               | 'Store'    | 'Order'                | 'Item key'  |
	| '5,000'    | '$$SalesInvoice024001$$' | 'Store 01' | '$$SalesOrder023001$$' | 'L/Green'   |
	| '4,000'    | '$$SalesInvoice024001$$' | 'Store 01' | '$$SalesOrder023001$$' | '36/Yellow' |

Scenario: _024003 check Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register OrderReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'  |
		| '5,000'    | '$$SalesInvoice024001$$' | 'Store 01' | 'L/Green'   |
		| '4,000'    | '$$SalesInvoice024001$$' | 'Store 01' | '36/Yellow' |


Scenario: _024004 check Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register InventoryBalance (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Company'      | 'Item key'  |
		| '5,000'    | '$$SalesInvoice024001$$' | 'Main Company' | 'L/Green'   |
		| '4,000'    | '$$SalesInvoice024001$$' | 'Main Company' | '36/Yellow' |

Scenario: _024005 check Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register StockBalance (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'  |
		| '5,000'    | '$$SalesInvoice024001$$' | 'Store 01' | 'L/Green'   |
		| '4,000'    | '$$SalesInvoice024001$$' | 'Store 01' | '36/Yellow' |


Scenario: _024006 check the absence posting of Sales invoice (based on order, store doesn't use Shipment confirmation) by register StockReservation
# All lines in the sales invoice by order
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'  |
		| '5,000'    | '$$SalesInvoice024001$$' | 'Store 01' | 'L/Green'   |
		| '4,000'    | '$$SalesInvoice024001$$' | 'Store 01' | '36/Yellow' |

Scenario: _024007 check Sales invoice posting (based on order, store doesn't use Shipment confirmation) by register SalesTurnovers
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Sales invoice'          | 'Item key'  |
		| '5,000'    | '$$SalesInvoice024001$$' | '$$SalesInvoice024001$$' | 'L/Green'   |
		| '4,000'    | '$$SalesInvoice024001$$' | '$$SalesInvoice024001$$' | '36/Yellow' |

Scenario: _024008 create document Sales Invoice based on order - Shipment confirmation used
	When create SalesInvoice024008

Scenario: _024009  check Sales invoice posting (based on order, store use Shipment confirmation) by register SalesTurnovers
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Sales invoice'          | 'Item key'  |
		| '10,000'   | '$$SalesInvoice024008$$' | '$$SalesInvoice024008$$' | 'L/Green'   |
		| '14,000'   | '$$SalesInvoice024008$$' | '$$SalesInvoice024008$$' | '36/Yellow' |

Scenario: _024010  check Sales invoice posting (based on order, store use Shipment confirmation) by register OrderBalance (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'               | 'Store'    | 'Order'          | 'Item key'  |
	| '10,000'   | '$$SalesInvoice024008$$' | 'Store 02' | 'Sales order 2*' | 'L/Green'   |
	| '14,000'   | '$$SalesInvoice024008$$' | 'Store 02' | 'Sales order 2*' | '36/Yellow' |

Scenario: _024011  check Sales invoice posting (based on order, store use Shipment confirmation) by register InventoryBalance (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Company'      | 'Item key'  |
		| '10,000'   | '$$SalesInvoice024008$$' | 'Main Company' | 'L/Green'   |
		| '14,000'   | '$$SalesInvoice024008$$' | 'Main Company' | '36/Yellow' |

Scenario: _024012  check Sales invoice posting (based on order, store use Shipment confirmation) by register GoodsInTransitOutgoing
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '10,000'   | '$$SalesInvoice024008$$' | '$$SalesInvoice024008$$' | 'Store 02' | 'L/Green'  |
		| '14,000'   | '$$SalesInvoice024008$$' | '$$SalesInvoice024008$$' | 'Store 02' | '36/Yellow'   |

Scenario: _024013 check the absence posting of Sales invoice (based on order, store  use Shipment confirmation) by register StockBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'               | 'Store'    | 'Item key'  |
		| '10,000'   | '$$SalesInvoice024008$$' | 'Store 02' | 'L/Green'   |
		| '14,000'   | '$$SalesInvoice024008$$' | 'Store 02' | '36/Yellow' |

Scenario: _024014 check Sales invoice posting (based on order, store use Shipment confirmation) by register OrderReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '10,000'   | '$$SalesInvoice024008$$' | 'Store 02' | 'L/Green'   |
		| '14,000'   | '$$SalesInvoice024008$$' | 'Store 02' | '36/Yellow' |


Scenario: _024015 check the absence posting of Sales invoice (based on order, store  use Shipment confirmation) by register StockReservation
# All lines in the sales invoice by order
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
		| '5,000'    | '$$SalesInvoice024008$$'      | 'Store 02' | 'L/Green'  |
		| '4,000'    | '$$SalesInvoice024008$$'      | 'Store 02' | '36/Yellow'   |


Scenario: _024016 create document Sales Invoice order - Shipment confirmation doesn't used
	When create SalesInvoice024016 (Shipment confirmation does not used)

Scenario: _024017 check Sales invoice posting (without order, store doesn't use Shipment confirmation) by register StockReservation
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Item key' |
		| '1,000'    | '$$SalesInvoice024016$$'      | 'Store 01' | 'L/Green'  |

Scenario: _024018 check the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register OrderBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '1,000'    | '$$SalesInvoice024016$$'    | 'Store 01' | ''     | 'L/Green'  |

Scenario: _024019 check the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register OrderReservation
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
	| '1,000'    | '$$SalesInvoice024016$$'    | 'Store 01' |  'L/Green'  |

Scenario: _024020 check Sales invoice posting (without order, store doesn't use Shipment confirmation) by register InventoryBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key' |
		| '1,000'    | '$$SalesInvoice024016$$'    | 'Main Company' | 'L/Green'  |

Scenario: _024021 check Sales invoice posting (without order, store doesn't use Shipment confirmation) by register StockBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'           | 'Store'    | 'Item key' |
		| '1,000'    | '$$SalesInvoice024016$$'   | 'Store 01' | 'L/Green'  |

Scenario: _024022 check the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register GoodsInTransitOutgoing
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'         | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '1,000'   | '$$SalesInvoice024016$$'  | '$$SalesInvoice024016$$' | 'Store 01' | 'L/Green'  |

Scenario: _024023 check Sales invoice posting (without order, store doesn't use Shipment confirmation) by register SalesTurnovers
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key' |
		| '1,000'    | '$$SalesInvoice024016$$' | '$$SalesInvoice024016$$' | 'L/Green'  |

Scenario: _024024 check the absence posting of Sales invoice (without order, store  doesn't use Shipment confirmation) by register OrderReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
		| '1,000'   | '$$SalesInvoice024016$$' | 'Store 01' | 'L/Green'   |



Scenario: _024025 create document Sales Invoice without Sales order - Shipment confirmation used
	When create SalesInvoice024025

Scenario: _024026 check Sales invoice posting (without order, store use Shipment confirmation) by register StockReservation
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'               | 'Store'     | 'Item key' |
		| '20,000'    | '$$SalesInvoice024025$$'      | 'Store 02' | 'L/Green'  |

Scenario: _024027 check the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register OrderBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Order'              | 'Item key' |
	| '20,000'    | '$$SalesInvoice024025$$'   | 'Store 02' | ''                  | 'L/Green'  |

Scenario: _024028 check the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register OrderReservation
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
	| '20,000'    | '$$SalesInvoice024025$$'   | 'Store 02' | 'L/Green'  |

Scenario: _024029 check Sales invoice posting (without order, store use Shipment confirmation) by register InventoryBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'           | 'Company'      | 'Item key' |
		| '20,000'    | '$$SalesInvoice024025$$'  | 'Main Company' | 'L/Green'  |

Scenario: _024030 check Sales invoice posting (without order, store use Shipment confirmation) by register GoodsInTransitOutgoing
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'          | 'Shipment basis'   | 'Store'    | 'Item key' |
		| '20,000'   | '$$SalesInvoice024025$$'  | '$$SalesInvoice024025$$' | 'Store 02' | 'L/Green'  |

Scenario: _024031 check the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register StockBalance
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key' |
		| '20,000'    | '$$SalesInvoice024025$$'    | 'Store 02' | 'L/Green'  |

Scenario: _024032 check Sales invoice posting (without order, store use Shipment confirmation) by register SalesTurnovers
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key' |
		| '20,000'   | '$$SalesInvoice024025$$' | '$$SalesInvoice024025$$' | 'L/Green'  |

Scenario: _024033 check the absence posting of Sales invoice (without order, store  use Shipment confirmation) by register OrderReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
		| '20,000'   | '$$SalesInvoice024025$$' | 'Store 02' | 'L/Green'   |

Scenario: _024034 Sales invoice creation on set, store use Goods receipt
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Personal Partner terms, $' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'  |
		And I select current line in "List" table
	* Select store 
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Boots' | 'Boots/S-8' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key'  |
			| 'Dress' | 'Dress/A-8' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	// * Change of document number - 5
	// 	And I move to "Other" tab
	// 	And I expand "More" group
	// 	And I input "5" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "5" text in "Number" field
	And I move to "Item list" tab
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberSalesInvoice024034$$"
	And I save the window as "$$SalesInvoice024034$$"
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
			| 'Partner'       | 'Σ'        |
			| 'Kalipso'       | '8 000,00' |
	And I close all client application windows
	*  check movements by register
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Store'    | 'Item key'  |
			| '1,000'    | '$$SalesInvoice024034$$' | 'Store 02' | 'Dress/A-8' |
			| '1,000'    | '$$SalesInvoice024034$$' | 'Store 02' | 'Boots/S-8' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Company'      | 'Item key'  |
			| '1,000'   | '$$SalesInvoice024034$$'    | 'Main Company' | 'Dress/A-8' |
			| '1,000'   | '$$SalesInvoice024034$$'    | 'Main Company' | 'Boots/S-8' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'         | 'Sales invoice'    | 'Item key'  |
			| '1,000'    | '$$SalesInvoice024034$$' | '$$SalesInvoice024034$$' | 'Dress/A-8' |
			| '1,000'    | '$$SalesInvoice024034$$' | '$$SalesInvoice024034$$' | 'Boots/S-8' |
		And I close all client application windows

Scenario: _024035 check the form of selection of items (sales invoice)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
		And I select current line in "List" table
	* Select Store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	When check the product selection form with price information in Sales invoice
	And I click "Post and close" button
	* Save check
		And "List" table contains lines
			| 'Partner'     |'Σ'          |
			| 'Ferron BP'   | '2 050,00'  |
	And I close all client application windows



Scenario: _024042 check totals in the document Sales invoice
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Select Sales invoice
		And I go to line in "List" table
		| Number |
		| '$$NumberSalesInvoice024001$$'      |
		And I select current line in "List" table
	* Check totals
		Then the form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "3 686,44"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "663,56"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "4 350,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"





Scenario: _024043 check the output of the document movement report for Sales Invoice
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice024001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice024001$$'                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'        | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'               | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'             | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'               | 'Tax'            | 'Analytics'         | 'Tax rate'                 | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'                | '232,18'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'                | '399,06'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'           | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | ''                     | ''               | ''                       | '4 350'          | 'Main Company'      | 'Ferron BP'                | 'Company Ferron BP'            | '$$SalesInvoice024001$$'             | 'TRY'                          | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | ''                       | 'Dimensions'     | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Offers amount'          | 'Company'        | 'Sales invoice'     | 'Currency'                 | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'               | '232,18'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | '36/Yellow'                    | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'               | '399,06'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                       | ''               | ''                  | ''                         | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'       | 'Currency'          | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                  | 'Item key'       | 'Row key'           | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '$$SalesOrder023001$$'         | '36/Yellow'      | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | '$$SalesOrder023001$$'         | 'L/Green'        | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'          | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | '36/Yellow'         | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | 'L/Green'           | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |

	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice024001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice024001$$'                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'        | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'               | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'             | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'               | 'Tax'            | 'Analytics'         | 'Tax rate'                 | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'                | '232,18'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'                | '399,06'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'           | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | ''                     | ''               | ''                       | '4 350'          | 'Main Company'      | 'Ferron BP'                | 'Company Ferron BP'            | '$$SalesInvoice024001$$'             | 'TRY'                          | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | ''                       | 'Dimensions'     | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Offers amount'          | 'Company'        | 'Sales invoice'     | 'Currency'                 | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'               | '232,18'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | '36/Yellow'                    | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'               | '399,06'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                       | ''               | ''                  | ''                         | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'       | 'Currency'          | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                  | 'Item key'       | 'Row key'           | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '$$SalesOrder023001$$'         | '36/Yellow'      | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | '$$SalesOrder023001$$'         | 'L/Green'        | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'          | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | '36/Yellow'         | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | 'L/Green'           | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |

	And I close all client application windows


Scenario: __02404301 clear movements Sales invoice and check that there is no movements on the registers 
	* Open list form Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesInvoice024001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Partner AR transactions"'        |
			| 'Register  "Inventory balance"'              |
			| 'Register  "Order reservation"'              |
			| 'Register  "Taxes turnovers"'                |
			| 'Register  "Sales turnovers"'                |
			| 'Register  "Reconciliation statement"'       |
			| 'Register  "Order balance"'                  |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice024001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice024001$$'                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'        | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | 'Attributes'                   | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'        | 'Partner term'             | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '744,86'               | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'                          | 'Reporting currency'           | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'en description is empty'      | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'Local currency'               | 'No'                           | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | '$$SalesInvoice024001$$'       | 'Ferron BP'      | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'                          | 'TRY'                          | 'No'                           | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Taxes turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'             | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'               | 'Tax'            | 'Analytics'         | 'Tax rate'                 | 'Include to total amount'      | 'Row key'                      | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '41,79'     | '41,79'                | '232,18'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '71,83'     | '71,83'                | '399,06'         | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '244,07'    | '244,07'               | '1 355,93'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '419,49'    | '419,49'               | '2 330,51'       | '$$SalesInvoice024001$$'       | 'VAT'            | ''                  | '18%'                      | 'Yes'                          | '*'                            | 'TRY'                          | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'           | 'Partner'                  | 'Legal name'                   | 'Basis document'               | 'Currency'                     | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | ''                     | ''               | ''                       | '4 350'          | 'Main Company'      | 'Ferron BP'                | 'Company Ferron BP'            | '$$SalesInvoice024001$$'             | 'TRY'                          | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Sales turnovers"'                | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''                     | ''               | ''                       | 'Dimensions'     | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Offers amount'          | 'Company'        | 'Sales invoice'     | 'Currency'                 | 'Item key'                     | 'Row key'                      | 'Multi currency movement type' | 'Serial lot number'            | 'Deferred calculation' |
		| ''                                           | '*'           | '4'         | '273,97'               | '232,18'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | '36/Yellow'                    | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '4'         | '1 600'                | '1 355,93'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | '36/Yellow'                    | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '470,89'               | '399,06'         | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'USD'                      | 'L/Green'                      | '*'                            | 'Reporting currency'           | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'en description is empty'      | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'Local currency'               | ''                             | 'No'                   |
		| ''                                           | '*'           | '5'         | '2 750'                | '2 330,51'       | ''                       | 'Main Company'   | '$$SalesInvoice024001$$'  | 'TRY'                      | 'L/Green'                      | '*'                            | 'TRY'                          | ''                             | 'No'                   |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'       | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '4 350'                | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Revenues turnovers"'             | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                       | ''               | ''                  | ''                         | ''                             | 'Attributes'                   | ''                             | ''                             | ''                     |
		| ''                                           | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Revenue type'           | 'Item key'       | 'Currency'          | 'Additional analytic'      | 'Multi currency movement type' | 'Deferred calculation'         | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '232,18'    | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '399,06'    | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'USD'               | ''                         | 'Reporting currency'           | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '1 355,93'  | 'Main Company'         | ''               | ''                       | '36/Yellow'      | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'en description is empty'      | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'Local currency'               | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | '*'           | '2 330,51'  | 'Main Company'         | ''               | ''                       | 'L/Green'        | 'TRY'               | ''                         | 'TRY'                          | 'No'                           | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                  | 'Item key'       | 'Row key'           | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '$$SalesOrder023001$$'         | '36/Yellow'      | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | '$$SalesOrder023001$$'         | 'L/Green'        | '*'                 | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'               | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Store 01'       | '36/Yellow'              | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Store 01'       | 'L/Green'                | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                  | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'          | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '4'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | '36/Yellow'         | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder023001$$'         | 'Store 01'       | 'L/Green'           | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows


Scenario: _300505 check connection to Sales invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberSalesInvoice024001$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows







	
















	




