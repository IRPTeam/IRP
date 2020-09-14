#language: en
@tree
@Positive
@Group3

Feature: create document Purchase return order

As a procurement manager
I want to create a Purchase return order document
To track a product that needs to be returned to the vendor

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _022001 create document Purchase return order, store use Shipment confirmation based on Purchase invoice + check status
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	And I select "Wait" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "2,000" text in "Q" field of "ItemList" table
	And I input "40,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Check the addition of the store to the tabular partner
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'Store 02' | 'pcs' | '2,000' |
	// * Filling in the document number 1
	// 	And I move to "Other" tab
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "1" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022001$$"
	And I save the window as "$$PurchaseReturnOrder022001$$"
	And I click "Post and close" button
	And I close current window
	And I close current window
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Order'                         | 'Item key' |
			| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | '$$PurchaseReturnOrder022001$$' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Purchase invoice'          | 'Item key' |
			| '-2,000'   | '$$PurchaseReturnOrder022001$$' | '1'           | '$$PurchaseInvoice018006$$' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
			| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
			| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |
		And I close all client application windows
	* Set Approved status
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturnOrder022001$$'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                        | 'Status'   |
			| '$$PurchaseReturnOrder022001$$' | 'Wait'     |
			| '$$PurchaseReturnOrder022001$$' | 'Approved' |
		And I close current window
		And I click "Post and close" button


Scenario: _022002 check movements of the document Purchase return order in the OrderBalance register (store doesn't use Shipment confirmation) 
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Order'                         | 'Item key' |
		| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | '$$PurchaseReturnOrder022001$$' | 'L/Green'  |

Scenario: _022003 check movements of the document Purchase return order in the OrderBalance register PurchaseTurnovers (store use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      | 'Line number' | 'Purchase invoice'          | 'Item key' |
		| '-2,000'   | '$$PurchaseReturnOrder022001$$' | '1'           | '$$PurchaseInvoice018006$$' | 'L/Green'  |

Scenario: _022004 check movements of the document Purchase return order in the OrderReservation register (store use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022005 check movements of the document Purchase return order in the StockReservation register (store use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _022006 create document Purchase return order, store doesn't use Shipment confirmation, based on Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Filling in the main details of the document
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Trousers'    | '36/Yellow'   | 'pcs' |
	And I select current line in "ItemList" table
	And Delay 2
	And I input "3,000" text in "Q" field of "ItemList" table
	And Delay 2
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'L/Green'   | 'pcs' |
	And Delay 2
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'M/White'   | 'pcs' |
	And I delete a line in "ItemList" table
	// * Filling in the document number 2
	// 	And I move to "Other" tab
	// 	And I input "2" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "2" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022006$$"
	And I save the window as "$$PurchaseReturnOrder022006$$"
	And I click "Post and close" button
	And I close current window

Scenario: _022007 check movements of the document Purchase return order in the OrderBalance (store doesn't use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Order'                         | 'Item key'  |
		| '3,000'    | '$$PurchaseReturnOrder022006$$' | '1'           | 'Store 01' | '$$PurchaseReturnOrder022006$$' | '36/Yellow' |

Scenario: _022008 check movements of the document Purchase return order in the PurchaseTurnovers (store doesn't use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Purchase invoice'          | 'Item key'  |
	| '-3,000'   | '$$PurchaseReturnOrder022006$$' | '1'           | '$$PurchaseInvoice018001$$' | '36/Yellow' |

Scenario: _022009 check movements of the document Purchase return order in the PurchaseTurnovers (store doesn't use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | '$$PurchaseReturnOrder022006$$' | '1'           | 'Store 01' | '36/Yellow' |

Scenario: _022010 check movements of the document Purchase return order in the StockReservation (store doesn't use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | '$$PurchaseReturnOrder022006$$' | '1'           | 'Store 01' | '36/Yellow' |


Scenario: _022016 check totals in the document Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Select PurchaseReturnOrder
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
		And I select current line in "List" table
	* Check totals in the document Purchase return order
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "12,20"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "67,80"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "80,00"




