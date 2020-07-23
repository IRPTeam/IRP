#language: en
@tree
@Positive
Feature: create document Inventory transfer order

As a procurement manager
I want to create a Inventory transfer order
To coordinate the transfer of items from one store to another

Background:
	Given I launch TestClient opening script or connect the existing one

# 1
Scenario: _020001 create document Inventory Transfer Order - Store sender doesn't use Shipment confirmation, Store receiver use Goods receipt
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "201" text in "Number" field
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'M/White' |
		And I select current line in "List" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "50,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'S/Yellow' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post and close" button

Scenario: _020002 check Inventory transfer order posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
checking Purchase Order N2 posting by register Order Balance (plus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      |'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '10,000'   | 'Inventory transfer order 201*' |'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'S/Yellow' |
		| '50,000'   | 'Inventory transfer order 201*' |'Store 01'     | 'Store 02'       | 'Inventory transfer order 201*' | 'M/White'  |

Scenario: _020003 check Inventory transfer order posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      |'Store'    | 'Item key' |
	| '10,000'   | 'Inventory transfer order 201*' |'Store 01' | 'S/Yellow' |
	| '50,000'   | 'Inventory transfer order 201*' |'Store 01' | 'M/White'  |




# 2
Scenario: _020004 create document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver use Goods receipt
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "202" text in "Number" field
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'L/Green' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post and close" button

Scenario: _020005 check Inventory transfer order posting by register TransferOrderBalance (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '20,000'   | 'Inventory transfer order 202*' | '1'           | 'Store 02'     | 'Store 03'       | 'Inventory transfer order 202*' | 'L/Green'  |

Scenario: _020006 check Inventory transfer order posting by register StockReservation (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | 'Inventory transfer order 202*' | '1'           | 'Store 02' | 'L/Green'  |

# 3
Scenario: _020007 create document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver doesn't use Goods receipt 
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "203" text in "Number" field
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'L/Green' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "17,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post and close" button


Scenario: _020008 check Inventory transfer order posting by register TransferOrderBalance (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '17,000'   | 'Inventory transfer order 203*' | '1'           | 'Store 02'     | 'Store 01'       | 'Inventory transfer order 203*' | 'L/Green'  |

Scenario: _020009 check Inventory transfer order posting by register StockReservation (Store sender use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
		| '17,000'   | 'Inventory transfer order 203*' | '1'           | 'Store 02' | 'L/Green'  |




# 4
Scenario: _020010 create document Inventory Transfer Order- Store sender doesn't use Shipment confirmation, Store receiver doesn't use Goods receipt 
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in the document number
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "204" text in "Number" field
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '36/Yellow' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click "Post and close" button

Scenario: _020011 check Inventory transfer order posting by register TransferOrderBalance (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key'  |
		| '10,000'   | 'Inventory transfer order 204*' | '1'           | 'Store 01'     | 'Store 04'       | 'Inventory transfer order 204*' | '36/Yellow' |


Scenario: _020012 check Inventory transfer order posting by register StockReservation (Store sender doesn't use Goods receipt, Store receiver doesn't use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key'  |
	| '10,000'   | 'Inventory transfer order 204*' | '1'           | 'Store 01' | '36/Yellow' |


Scenario: _020013 check movements by status and status history of an Inventory Transfer Order
	And I close all client application windows
	* Create Inventory Transfer Order
		* Opening a form to create Inventory transfer order
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I click the button named "FormCreate"
		* Filling in Store sender and Store receiver
			And I click Select button of "Store sender" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 03'  |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Check the default status "Wait"
			Then the form attribute named "Status" became equal to "Wait"
		* Filling in the document number 101
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "205" text in "Number" field
		* Filling in items table
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'  |
				| 'L/Green' |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I move to the next attribute
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
		And I close current window
		* Check that there is no movement in Wait status
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table does not contain lines
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			And I close current window
		* Check Approve status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'   | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Approved" exact value from "Status" drop-down list
			And I click "Post and close" button
			And I close all client application windows
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			And I close current window
		* Check Send status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number' | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Send" exact value from "Status" drop-down list
			And I click "Post and close" button
			And I close current window
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
				| 'Recorder'                    |
				| 'Inventory transfer order 205*' |
			And I close all client application windows
		* Check Receive status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number' | 'Store sender' | 'Store receiver' |
				| '205'      |  'Store 02'     | 'Store 03'       |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Receive" exact value from "Status" drop-down list
			And I click "Post" button
			And I click "History" hyperlink
			And "List" table contains lines
				| 'Object'                         | 'Status'   |
				| 'Inventory transfer order 205*' | 'Wait' |
				| 'Inventory transfer order 205*' | 'Send'     |
				| 'Inventory transfer order 205*' | 'Receive'  |
			And I close current window
			And I click "Post and close" button
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
			| 'Recorder'                    |
			| 'Inventory transfer order 205*' |
			And I close current window



	

