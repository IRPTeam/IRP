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

Scenario: _020002 check filling in Row Id info table in the ITO
	* Select ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberInventoryTransferOrder020001$$' |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1InventoryTransferOrder020001$$"
		And I go to line in "ItemList" table
			| '#' |
			| '2' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2InventoryTransferOrder020001$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                                  | 'Basis' | 'Row ID'                               | 'Next step' | 'Q' | 'Basis key' | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransferOrder020001$$' | ''      | '$$Rov1InventoryTransferOrder020001$$' | 'IT'        | '50,000'   | ''          | ''             | '$$Rov1InventoryTransferOrder020001$$' |
			| '$$Rov2InventoryTransferOrder020001$$' | ''      | '$$Rov2InventoryTransferOrder020001$$' | 'IT'        | '10,000'   | ''          | ''             | '$$Rov2InventoryTransferOrder020001$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Quantity'     |
			| '1' | 'Dress' | 'M/White'  | '50,000' |
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' |
			| '3' |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3InventoryTransferOrder020001$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                                  | 'Basis' | 'Row ID'                               | 'Next step' | 'Q' | 'Basis key' | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransferOrder020001$$' | ''      | '$$Rov1InventoryTransferOrder020001$$' | 'IT'        | '50,000'   | ''          | ''             | '$$Rov1InventoryTransferOrder020001$$' |
			| '$$Rov2InventoryTransferOrder020001$$' | ''      | '$$Rov2InventoryTransferOrder020001$$' | 'IT'        | '10,000'   | ''          | ''             | '$$Rov2InventoryTransferOrder020001$$' |
			| '$$Rov3InventoryTransferOrder020001$$' | ''      | '$$Rov3InventoryTransferOrder020001$$' | 'IT'        | '8,000'    | ''          | ''             | '$$Rov3InventoryTransferOrder020001$$' |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "RowIDInfo" table does not contain lines
			| 'Key'                                  | 'Basis' | 'Row ID'                               | 'Next step' | 'Q' | 'Basis key' | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransferOrder020001$$' | ''      | '$$Rov1InventoryTransferOrder020001$$' | 'IT'        | '8,000'    | ''          | ''             | '$$Rov1InventoryTransferOrder020001$$' |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Quantity'     |
			| '3' | 'Dress' | 'M/White'  | '8,000' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                                  | 'Basis' | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key' | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransferOrder020001$$' | ''      | '$$Rov1InventoryTransferOrder020001$$' | 'IT'        | '50,000' | ''          | ''             | '$$Rov1InventoryTransferOrder020001$$' |
			| '$$Rov2InventoryTransferOrder020001$$' | ''      | '$$Rov2InventoryTransferOrder020001$$' | 'IT'        | '10,000' | ''          | ''             | '$$Rov2InventoryTransferOrder020001$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Quantity' |
			| '1' | 'Dress' | 'M/White'  | '50,000'   |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                                  | 'Basis' | 'Row ID'                               | 'Next step' | 'Q' | 'Basis key' | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransferOrder020001$$' | ''      | '$$Rov1InventoryTransferOrder020001$$' | 'IT'        | '7,000'    | ''          | ''             | '$$Rov1InventoryTransferOrder020001$$' |
			| '$$Rov2InventoryTransferOrder020001$$' | ''      | '$$Rov2InventoryTransferOrder020001$$' | 'IT'        | '10,000'   | ''          | ''             | '$$Rov2InventoryTransferOrder020001$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Quantity'     |
			| '1' | 'Dress' | 'M/White'  | '7,000' |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"


Scenario: _020003 copy ITO and check filling in Row Id info table
	* Copy ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                     |
			| '$$NumberInventoryTransferOrder020001$$' |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 01"
		Then the form attribute named "StoreReceiver" became equal to "Store 02"
		Then the form attribute named "Status" became equal to "Approved"
		And "ItemList" table became equal
			| '#' | 'Item'  | 'Item key' | 'Quantity' | 'Unit' | 'Internal supply request' | 'Purchase order' |
			| '1' | 'Dress' | 'M/White'  | '50,000'   | 'pcs'  | ''                        | ''               |
			| '2' | 'Dress' | 'S/Yellow' | '10,000'   | 'pcs'  | ''                        | ''               |
	* Post ITO and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                                  | 'Basis' | 'Row ID'                               | 'Next step' | 'Q'      | 'Basis key' | 'Current step' | 'Row ref'                              |
			| '$$Rov1InventoryTransferOrder020001$$' | ''      | '$$Rov1InventoryTransferOrder020001$$' | 'IT'        | '50,000' | ''          | ''             | '$$Rov1InventoryTransferOrder020001$$' |
			| '$$Rov2InventoryTransferOrder020001$$' | ''      | '$$Rov2InventoryTransferOrder020001$$' | 'IT'        | '10,000' | ''          | ''             | '$$Rov2InventoryTransferOrder020001$$' |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I close all client application windows


# 2
Scenario: _020004 create document Inventory Transfer Order- Store sender use Shipment confirmation, Store receiver use Goods receipt
	When create InventoryTransferOrder020004








# 4
Scenario: _020010 create document Inventory Transfer Order- Store sender does not use Shipment confirmation, Store receiver does not use Goods receipt 
	When create InventoryTransferOrder020010



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
				| '$$InventoryTransferOrder020013$$' | 'Approved'     |
				| '$$InventoryTransferOrder020013$$' | 'Receive'  |
			And I close current window
			And I click the button named "FormPostAndClose"
			Given I open hyperlink "e1cib/list/AccumulationRegister.TransferOrderBalance"
			And "List" table contains lines
			| 'Recorder'                    |
			| '$$InventoryTransferOrder020013$$' |
			And I close current window

	



		
				


	

