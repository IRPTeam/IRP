#language: en
@tree
@Positive
Feature: create Shipment confirmation


As a storekeeper
I want to create a Goods receipt
For shipment of products from store


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028801 create document Shipment confirmation based on Sales Invoice (with Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'    |
		| '2'      | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "95" text in "Number" field
	* Check if the product is filled in
		And "ItemList" table contains lines
		| 'Item'     | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'L/Green'  | 'pcs' | 'Sales invoice 2*' |
		| 'Trousers' | '14,000'   | '36/Yellow'| 'pcs' | 'Sales invoice 2*' |
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click "Post and close" button
	And I close current window
	

Scenario: _028802 check Shipment confirmation posting (based on Sales invoice with Sales order) by register GoodsInTransitOutgoing (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Shipment basis'    | 'Store'    | 'Item key' |
		| '10,000'   | 'Shipment confirmation 95*' | 'Sales invoice 2*' | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Shipment confirmation 95*' | 'Sales invoice 2*' | 'Store 02' | '36/Yellow'   |

Scenario: _028803 check Shipment confirmation posting (based on Sales invoice with Sales order) by register StockBalance (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key' |
		| '10,000'   | 'Shipment confirmation 95*' | 'Store 02' | 'L/Green'  |
		| '14,000'   | 'Shipment confirmation 95*' | 'Store 02' | '36/Yellow'   |


Scenario: _028804 create document Shipment confirmation  based on Sales Invoice (without Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'    |
		| '4'      | 'Kalipso' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "98" text in "Number" field
	* Check if the product is filled in
		And "ItemList" table contains lines
		| '#' | 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| '1' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | 'Sales invoice 4*' |
	And I click "Post and close" button
	And I close current window

Scenario: _028805 check Shipment confirmation posting (based on Sales invoice without Sales order) by register GoodsInTransitOutgoing (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | 'Shipment confirmation 98*' | 'Sales invoice 4*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028806 check Shipment confirmation posting (based on Sales invoice without Sales order) by register StockBalance (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | 'Shipment confirmation 98*' | '1'           | 'Store 02' | 'L/Green'  |



Scenario: _028807 create document Shipment confirmation based on Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '1'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "101" text in "Number" field
	And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'                              |
		| 'Dress' | '2,000'    | 'L/Green'  | 'pcs'  | 'Purchase return 1*' |
	And I click "Post and close" button
	And I close current window

Scenario: _028808 check Shipment confirmation posting (based on Purchase return) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'    | 'Shipment confirmation 101*' | '1'           | 'Store 02' | 'L/Green'  |



Scenario: _028809 check Shipment confirmation posting (based on Purchase return) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'   | 'Shipment confirmation 101*' | 'Purchase return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028810 create document Shipment confirmation  based on Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '2'      | 'Store 03'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "102" text in "Number" field
	And I click "Post and close" button
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '3'      | 'Store 01'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "103" text in "Number" field
	And I click "Post and close" button
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '6'      | 'Store 03'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "104" text in "Number" field
	And I click "Post and close" button
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '7'      | 'Store 01'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	* Change of document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "105" text in "Number" field
	And I click "Post and close" button



