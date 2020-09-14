#language: en
@tree
@Positive
@Group7
Feature: create Shipment confirmation


As a storekeeper
I want to create a Goods receipt
For shipment of products from store


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028801 create document Shipment confirmation based on Sales Invoice (with Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                       | 'Partner'   |
		| '$$NumberSalesInvoice024008$$' | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "95" text in "Number" field
	* Check if the product is filled in
		And "ItemList" table contains lines
		| 'Item'     | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'L/Green'  | 'pcs' | '$$SalesInvoice024008$$' |
		| 'Trousers' | '14,000'   | '36/Yellow'| 'pcs' | '$$SalesInvoice024008$$' |
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028801$$"
	And I save the window as "$$ShipmentConfirmation0028801$$"
	And I click "Post and close" button
	And I close current window
	

Scenario: _028802 check Shipment confirmation posting (based on Sales invoice with Sales order) by register GoodsInTransitOutgoing (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Shipment basis'    | 'Store'    | 'Item key' |
		| '10,000'   | '$$ShipmentConfirmation0028801$$' | '$$SalesInvoice024008$$' | 'Store 02' | 'L/Green'  |
		| '14,000'   | '$$ShipmentConfirmation0028801$$' | '$$SalesInvoice024008$$' | 'Store 02' | '36/Yellow'   |

Scenario: _028803 check Shipment confirmation posting (based on Sales invoice with Sales order) by register StockBalance (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key' |
		| '10,000'   | '$$ShipmentConfirmation0028801$$' | 'Store 02' | 'L/Green'  |
		| '14,000'   | '$$ShipmentConfirmation0028801$$' | 'Store 02' | '36/Yellow'   |


Scenario: _028804 create document Shipment confirmation  based on Sales Invoice (without Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'    |
		| '$$NumberSalesInvoice024025$$'      | 'Kalipso' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "98" text in "Number" field
	* Check if the product is filled in
		And "ItemList" table contains lines
		| '#' | 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| '1' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | '$$SalesInvoice024025$$' |
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028804$$"
	And I save the window as "$$ShipmentConfirmation0028804$$"
	And I click "Post and close" button
	And I close current window

Scenario: _028805 check Shipment confirmation posting (based on Sales invoice without Sales order) by register GoodsInTransitOutgoing (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Shipment basis'         | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | '$$ShipmentConfirmation0028804$$' | '$$SalesInvoice024025$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028806 check Shipment confirmation posting (based on Sales invoice without Sales order) by register StockBalance (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | '$$ShipmentConfirmation0028804$$' | '1'           | 'Store 02' | 'L/Green'  |



Scenario: _028807 create document Shipment confirmation based on Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022301$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "101" text in "Number" field
	And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'                              |
		| 'Dress' | '2,000'    | 'L/Green'  | 'pcs'  | '$$PurchaseReturn022301$$' |
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028807$$"
	And I save the window as "$$ShipmentConfirmation0028807$$"
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
		| '2,000'   | 'Shipment confirmation 101*' | '$$PurchaseReturn022301$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028810 create document Shipment confirmation  based on Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'                            | 'Store receiver' | 'Store sender' |
		| '$$NumberInventoryTransfer021006$$' | 'Store 03'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "102" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation0288101$$"
	And I save the window as "$$ShipmentConfirmation00288101$$"
	And I click "Post and close" button
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number' | 'Store receiver' | 'Store sender' |
		| '$$NumberInventoryTransfer021012$$'      | 'Store 01'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "103" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028810$$"
	And I save the window as "$$ShipmentConfirmation0028810$$"
	And I click "Post and close" button
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'                            | 'Store receiver' | 'Store sender' |
		| '$$NumberInventoryTransfer021030$$' | 'Store 03'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "104" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation0288104$$"
	And I save the window as "$$ShipmentConfirmation00288104$$"
	And I click "Post and close" button
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'                            | 'Store receiver' | 'Store sender' |
		| '$$NumberInventoryTransfer021036$$' | 'Store 01'       | 'Store 02'     |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	// * Change of document number
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "105" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberShipmentConfirmation0288103$$"
	And I save the window as "$$ShipmentConfirmation00288103$$"
	And I click "Post and close" button



