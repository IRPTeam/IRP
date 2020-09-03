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


Scenario: _018001 create document Purchase Invoice based on order - Goods receipt is not used
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number' |
		| '2'      |
	And I select current line in "List" table
	* Check filling of elements upon entry based on
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I select current line in "List" table
	* Check filling items table
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit'| 'Q'       |
		| 'Dress'    | 'Purchase order 2*' | 'M/White'  | 'pcs' | '100,000' |
		| 'Dress'    | 'Purchase order 2*' | 'L/Green'  | 'pcs' | '200,000' |
		| 'Trousers' | 'Purchase order 2*' | '36/Yellow'| 'pcs' | '300,000' |
	* Check filling prices
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'Item key'  | 'Q'       | 'Price type'                         | 'Store'    |
		| '200,00' | 'Dress'    | 'M/White'   | '100,000' | 'en description is empty'           | 'Store 01' |
		| '210,00' | 'Dress'    | 'L/Green'   | '200,000' | 'en description is empty'           | 'Store 01' |
		| '250,00' | 'Trousers' | '36/Yellow' | '300,000' | 'en description is empty'           | 'Store 01' |
	* Filling in the document number 1
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	* Check addition of the store in tabular part
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'       |
		| 'Dress'    | 'M/White'   | 'Store 01' | 'pcs' | '100,000' |
	And I click "Post and close" button
	

Scenario: _018002 check Purchase Invoice movements by register Order Balance (minus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            |  'Store'    | 'Order'             | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*' |  'Store 01' | 'Purchase order 2*' | '36/Yellow'|


Scenario: _018003 check Purchase Invoice movements by register Stock Balance (plus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Store'     | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*' | 'Store 01'  | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*' |  'Store 01' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*' |  'Store 01' | '36/Yellow'|

Scenario: _018004 check Purchase Invoice movements by register Stock Reservation (plus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Store'    | 'Item key'  |
		| '100,000'  | 'Purchase invoice 1*'  |  'Store 01' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*'  |  'Store 01' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*'  |  'Store 01' | '36/Yellow'|

Scenario: _018005 check Purchase Invoice movements by register Inventory Balance - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             |  'Company'     | 'Item key' |
		| '100,000'  | 'Purchase invoice 1*'  | 'Main Company' | 'M/White'  |
		| '200,000'  | 'Purchase invoice 1*'  | 'Main Company' | 'L/Green'  |
		| '300,000'  | 'Purchase invoice 1*'  | 'Main Company' | '36/Yellow'|

Scenario: _018006 create document Purchase Invoice based on order - Goods receipt is used
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number' |
		| '3'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	* Check filling of elements upon entry based on
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "Store" became equal to "Store 02"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I select current line in "List" table
	* Check filling items table
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit' | 'Q'       |
		| 'Dress'    | 'Purchase order 3*' | 'L/Green'  | 'pcs' | '500,000' |
	* Filling prices
		And "ItemList" table contains lines
		| 'Price' | 'Item'  | 'Item key' | 'Q'       | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' |
		| '40,00' | 'Dress' | 'L/Green'  | '500,000' | 'en description is empty' | 'pcs'  | '3 050,85'   | '16 949,15'  | '20 000,00'    |
	* Filling in the document number 2
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	And I click "Post and close" button
	

Scenario: _018007 check Purchase Invoice movements by register Order Balance (minus) - Goods receipt is used
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'            | 'Line number' | 'Store'    | 'Order'             | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*' | '1'           | 'Store 02' | 'Purchase order 3*' | 'L/Green'  |


Scenario: _018008 check Purchase Invoice movements by register Inventory Balance (plus) - Goods receipt is used
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Company'      | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Main Company' | 'L/Green'  |

Scenario: _018009 check Purchase Invoice movements by register GoodsInTransitIncoming (plus) - Goods receipt is used
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Receipt basis'        | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | 'Purchase invoice 2*'  | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _018010 check that there are no movements of Purchase Invoice document by register StockBalance if used Goods receipt 
# if Goods receipt is used, there will be no posting
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _018011 check that there are no movements of Purchase Invoice document by register StockReservation if used Goods receipt 
# if Goods receipt is used, there will be no posting
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'             | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Purchase invoice 2*'  | '1'           | 'Store 01' | 'L/Green'  |

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
	* Filling in the document number
		And I input "5" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5" text in "Number" field
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
		And I click "Post and close" button
	* Check movements by register
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key' |
			| '10,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Dress/A-8'|
			| '20,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Boots/S-8'|
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Store'    | 'Item key' |
			| '10,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Dress/A-8'|
			| '20,000'   | 'Purchase invoice 5*'        | 'Store 01' | 'Boots/S-8'|
		Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                   | 'Item key' |
			| '10,000'   | 'Purchase invoice 5*'        | 'Dress/A-8'|
			| '20,000'   | 'Purchase invoice 5*'        | 'Boots/S-8'|


Scenario: _018018 check totals in the document Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Select Purchase Invoice
		And I go to line in "List" table
		| Number |
		| 2      |
		And I select current line in "List" table
	* Check totals
		Then the form attribute named "ItemListTotalNetAmount" became equal to "16 949,15"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "3 050,85"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "20 000,00"


Scenario: _018020 check the form Pick up items in the document Purchase invoice
	And I close all client application windows
	* Opening a form for creating Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in the main details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
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
			| Vendor Ferron, TRY |
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	When check the product selection form with price information in Purchase invoice
	And I close all client application windows


