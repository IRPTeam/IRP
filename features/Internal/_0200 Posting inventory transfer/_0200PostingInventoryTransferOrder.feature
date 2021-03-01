#language: en
@tree
@Positive
@Group4
@InventoryTransfer

Feature: create document Inventory transfer order

As a procurement manager
I want to create a Inventory transfer order
To coordinate the transfer of items from one store to another

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _020000 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When update ItemKeys
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


# 1
Scenario: _020001 create document Inventory Transfer Order - Store sender does not use Shipment confirmation, Store receiver use Goods receipt
	When create InventoryTransferOrder020001

Scenario: _020002 check Inventory transfer order posting by register TransferOrderBalance (Store sender does not use Goods receipt, Store receiver use Shipment confirmaton)
checking Purchase Order N2 posting by register Order Balance (plus) - Goods receipt is not used
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                         | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key' |
		| '10,000'   | '$$InventoryTransferOrder020001$$' | 'Store 01'     | 'Store 02'       | '$$InventoryTransferOrder020001$$' | 'S/Yellow' |
		| '50,000'   | '$$InventoryTransferOrder020001$$' | 'Store 01'     | 'Store 02'       | '$$InventoryTransferOrder020001$$' | 'M/White'  |

Scenario: _020003 check Inventory transfer order posting by register StockReservation (Store sender does not use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      |'Store'    | 'Item key' |
	| '10,000'   | '$$InventoryTransferOrder020001$$' |'Store 01' | 'S/Yellow' |
	| '50,000'   | '$$InventoryTransferOrder020001$$' |'Store 01' | 'M/White'  |




# 2
Scenario: _020004 create document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver use Goods receipt
	When create InventoryTransferOrder020004

Scenario: _020005 check Inventory transfer order posting by register TransferOrderBalance (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                         | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key' |
		| '20,000'   | '$$InventoryTransferOrder020004$$' | '1'           | 'Store 02'     | 'Store 03'       | '$$InventoryTransferOrder020004$$' | 'L/Green'  |

Scenario: _020006 check Inventory transfer order posting by register StockReservation (Store sender use Goods receipt, Store receiver use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                         | 'Line number' | 'Store'    | 'Item key' |
	| '20,000'   | '$$InventoryTransferOrder020004$$' | '1'           | 'Store 02' | 'L/Green'  |

# 3
Scenario: _020007 create document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver does not use Goods receipt 
	When create InventoryTransferOrder020007


Scenario: _020008 check Inventory transfer order posting by register TransferOrderBalance (Store sender use Goods receipt, Store receiver does not use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                       | 'Item key' |
		| '17,000'   | '$$InventoryTransferOrder020007$$' | '1'           | 'Store 02'     | 'Store 01'       | '$$InventoryTransferOrder020007$$' | 'L/Green'  |

Scenario: _020009 check Inventory transfer order posting by register StockReservation (Store sender use Goods receipt, Store receiver does not use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                    | 'Line number' | 'Store'    | 'Item key' |
		| '17,000'   | '$$InventoryTransferOrder020007$$' | '1'           | 'Store 02' | 'L/Green'  |




# 4
Scenario: _020010 create document Inventory Transfer Order- Store sender does not use Shipment confirmation, Store receiver does not use Goods receipt 
	When create InventoryTransferOrder020010

Scenario: _020011 check Inventory transfer order posting by register TransferOrderBalance (Store sender does not use Goods receipt, Store receiver does not use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                         | 'Line number' | 'Store sender' | 'Store receiver' | 'Order'                            | 'Item key'  |
		| '10,000'   | '$$InventoryTransferOrder020010$$' | '1'           | 'Store 01'     | 'Store 04'       | '$$InventoryTransferOrder020010$$' | '36/Yellow' |


Scenario: _020012 check Inventory transfer order posting by register StockReservation (Store sender does not use Goods receipt, Store receiver does not use Shipment confirmaton)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                         | 'Line number' | 'Store'    | 'Item key'  |
	| '10,000'   | '$$InventoryTransferOrder020010$$' | '1'           | 'Store 01' | '36/Yellow' |


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
		And I click the button named "FormPost"
		And I delete "$$NumberInventoryTransferOrder020013$$" variable
		And I delete "$$InventoryTransferOrder020013$$" variable
		And I save the value of "Number" field as "$$NumberInventoryTransferOrder020013$$"
		And I save the window as "$$InventoryTransferOrder020013$$"
		And I click the button named "FormPostAndClose"
		And I close current window
		* Check that there is no movement in Wait status
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table does not contain lines
				| 'Recorder'                    |
				| '$$InventoryTransferOrder020013$$' |
			And I close current window
		* Check Approve status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'   | 'Store sender' | 'Store receiver' |
				| '$$NumberInventoryTransferOrder020013$$'      |  'Store 02'     | 'Store 03'       |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPostAndClose"
			And I close all client application windows
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
				| 'Recorder'                    |
				| '$$InventoryTransferOrder020013$$' |
			And I close current window
		* Check Send status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'                                 | 'Store sender' | 'Store receiver' |
				| '$$NumberInventoryTransferOrder020013$$' | 'Store 02'     | 'Store 03'       |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Send" exact value from "Status" drop-down list
			And I click the button named "FormPostAndClose"
			And I close current window
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
				| 'Recorder'                    |
				| '$$InventoryTransferOrder020013$$' |
			And I close all client application windows
		* Check Receive status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'                                 | 'Store sender' | 'Store receiver' |
				| '$$NumberInventoryTransferOrder020013$$' | 'Store 02'     | 'Store 03'       |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Receive" exact value from "Status" drop-down list
			And I click the button named "FormPost"
			And I click "History" hyperlink
			And "List" table contains lines
				| 'Object'                         | 'Status'   |
				| '$$InventoryTransferOrder020013$$' | 'Wait' |
				| '$$InventoryTransferOrder020013$$' | 'Send'     |
				| '$$InventoryTransferOrder020013$$' | 'Receive'  |
			And I close current window
			And I click the button named "FormPostAndClose"
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
			| 'Recorder'                    |
			| '$$InventoryTransferOrder020013$$' |
			And I close current window

Scenario: _020014 check filling in fields Use GR and Use SC from Store in the Inventory transfer order (prohibit Use SC = True, Use GR = False)
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender (Use SC) and Store receiver (Use GR) and check filling fields Use GR and Use SC
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
		And I move to "Other" tab
		Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
	* Filling in Store sender (not use SC) and Store receiver ( not use GR) and check filling fields Use GR and Use SC
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
		And I move to "Other" tab
		Then the form attribute named "UseShipmentConfirmation" became equal to "No"
		Then the form attribute named "UseGoodsReceipt" became equal to "No"
	* Filling in Store sender (not use SC) and Store receiver ( use GR) and check filling fields Use GR and Use SC
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I move to "Other" tab
		Then the form attribute named "UseShipmentConfirmation" became equal to "No"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
	* Filling in Store sender (use SC) and Store receiver ( not use GR) and check filling fields Use GR and Use SC
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
		And I move to "Other" tab
		Then I wait that in user messages the "Сan not use confirmation of shipment without goods receipt. Use goods receipt mode is enabled." substring will appear in 20 seconds
		Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
		Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
		And I close all client application windows
		
	



		
				


	

