#language: en
@tree
@Positive
@Group3

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
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018012$$"
		And I save the window as "$$PurchaseInvoice018012$$"
		And I click "Post and close" button
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


