#language: en
@tree
@Positive
@Group5
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
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I select current line in "List" table
	* Select store 
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	// * Change of document number - 3
	// 	And I move to "Other" tab
	// 	And I expand "More" group
	// 	And I input "3" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "3" text in "Number" field
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post" button
		And in the table "ItemList" I click "% Offers" button
		And in the table "Offers" I click the button named "FormOK"
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberSalesInvoice024016$$"
	And I save the window as "$$SalesInvoice024016$$"
	And I click "Post and close" button

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



Scenario: _024025 create document Sales Invoice order - Shipment confirmation used
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	// * Change of document number - 4
	// 	And I move to "Other" tab
	// 	And I expand "More" group
	// 	And I input "4" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "4" text in "Number" field
	* Change store to Store 02
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| Description |
			| Store 02  |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberSalesInvoice024025$$"
	And I save the window as "$$SalesInvoice024025$$"
	And I click "Post and close" button

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











	
















	




