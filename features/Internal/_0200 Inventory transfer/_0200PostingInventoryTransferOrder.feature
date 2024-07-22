#language: en
@tree
@Positive
@Group4
@InventoryTransfer

Feature: create document Inventory transfer order

As a procurement manager
I want to create a Inventory transfer order
To coordinate the transfer of items from one store to another

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _020000 preparation
	When set True value to the constant
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
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create information register Taxes records (VAT)


Scenario: _0200001 check preparation
	When check preparation

# 1
Scenario: _020001 create document Inventory Transfer Order - Store sender does not use Shipment confirmation, Store receiver use Goods receipt
	When create InventoryTransferOrder020001

Scenario: _020002 check filling in Row Id info table in the ITO
	* Select ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                                    |
			| '$$NumberInventoryTransferOrder020001$$'    |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1InventoryTransferOrder020001$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2InventoryTransferOrder020001$$"
	* Check Row Id info table
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1InventoryTransferOrder020001$$'   | ''        | '$$Rov1InventoryTransferOrder020001$$'   | 'IT'          | '50,000'     | ''            | ''               | '$$Rov1InventoryTransferOrder020001$$'    |
			| '$$Rov2InventoryTransferOrder020001$$'   | ''        | '$$Rov2InventoryTransferOrder020001$$'   | 'IT'          | '10,000'     | ''            | ''               | '$$Rov2InventoryTransferOrder020001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Copy string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'M/White'    | '50,000'      |
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "8,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#'    |
			| '3'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov3InventoryTransferOrder020001$$"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1InventoryTransferOrder020001$$'   | ''        | '$$Rov1InventoryTransferOrder020001$$'   | 'IT'          | '50,000'     | ''            | ''               | '$$Rov1InventoryTransferOrder020001$$'    |
			| '$$Rov2InventoryTransferOrder020001$$'   | ''        | '$$Rov2InventoryTransferOrder020001$$'   | 'IT'          | '10,000'     | ''            | ''               | '$$Rov2InventoryTransferOrder020001$$'    |
			| '$$Rov3InventoryTransferOrder020001$$'   | ''        | '$$Rov3InventoryTransferOrder020001$$'   | 'IT'          | '8,000'      | ''            | ''               | '$$Rov3InventoryTransferOrder020001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "3"
		And "RowIDInfo" table does not contain lines
			| 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1InventoryTransferOrder020001$$'   | ''        | '$$Rov1InventoryTransferOrder020001$$'   | 'IT'          | '8,000'      | ''            | ''               | '$$Rov1InventoryTransferOrder020001$$'    |
	* Delete string and check Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '3'   | 'Dress'   | 'M/White'    | '8,000'       |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I move to "Row ID Info" tab
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1InventoryTransferOrder020001$$'   | ''        | '$$Rov1InventoryTransferOrder020001$$'   | 'IT'          | '50,000'     | ''            | ''               | '$$Rov1InventoryTransferOrder020001$$'    |
			| '$$Rov2InventoryTransferOrder020001$$'   | ''        | '$$Rov2InventoryTransferOrder020001$$'   | 'IT'          | '10,000'     | ''            | ''               | '$$Rov2InventoryTransferOrder020001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
	* Change quantity and check  Row ID Info tab
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'M/White'    | '50,000'      |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "7,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And "RowIDInfo" table contains lines
			| 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1InventoryTransferOrder020001$$'   | ''        | '$$Rov1InventoryTransferOrder020001$$'   | 'IT'          | '7,000'      | ''            | ''               | '$$Rov1InventoryTransferOrder020001$$'    |
			| '$$Rov2InventoryTransferOrder020001$$'   | ''        | '$$Rov2InventoryTransferOrder020001$$'   | 'IT'          | '10,000'     | ''            | ''               | '$$Rov2InventoryTransferOrder020001$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'    |
			| '1'   | 'Dress'   | 'M/White'    | '7,000'       |
		And I activate "Quantity" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "50,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"


Scenario: _020003 copy ITO and check filling in Row Id info table
	* Copy ITO
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'                                    |
			| '$$NumberInventoryTransferOrder020001$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
	* Check copy info
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 01"
		Then the form attribute named "StoreReceiver" became equal to "Store 02"
		Then the form attribute named "Status" became equal to "Approved"
		And "ItemList" table became equal
			| '#'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Internal supply request'   | 'Purchase order'    |
			| '1'   | 'Dress'   | 'M/White'    | '50,000'     | 'pcs'    | ''                          | ''                  |
			| '2'   | 'Dress'   | 'S/Yellow'   | '10,000'     | 'pcs'    | ''                          | ''                  |
	* Post ITO and check Row ID Info tab
		And I click the button named "FormPost"
		And I click "Show row key" button
		And I move to "Row ID Info" tab
		And "RowIDInfo" table does not contain lines
			| 'Key'                                    | 'Basis'   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'   | 'Current step'   | 'Row ref'                                 |
			| '$$Rov1InventoryTransferOrder020001$$'   | ''        | '$$Rov1InventoryTransferOrder020001$$'   | 'IT'          | '50,000'     | ''            | ''               | '$$Rov1InventoryTransferOrder020001$$'    |
			| '$$Rov2InventoryTransferOrder020001$$'   | ''        | '$$Rov2InventoryTransferOrder020001$$'   | 'IT'          | '10,000'     | ''            | ''               | '$$Rov2InventoryTransferOrder020001$$'    |
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
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 03'        |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
		* Check the default status "Wait"
			Then the form attribute named "Status" became equal to "Wait"
		* Filling in items table
			And I move to "Item list" tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
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
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4020T_StockTransferOrders"
			And "List" table does not contain lines
				| 'Recorder'                             |
				| '$$InventoryTransferOrder020013$$'     |
			And I close current window
		* Check Approve status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'                                    | 'Store sender'    | 'Store receiver'     |
				| '$$NumberInventoryTransferOrder020013$$'    | 'Store 02'        | 'Store 03'           |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPostAndClose"
			And I close all client application windows
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4020T_StockTransferOrders"
			And "List" table contains lines
				| 'Recorder'                             |
				| '$$InventoryTransferOrder020013$$'     |
			And I close current window
		* Check Send status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'                                    | 'Store sender'    | 'Store receiver'     |
				| '$$NumberInventoryTransferOrder020013$$'    | 'Store 02'        | 'Store 03'           |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Send" exact value from "Status" drop-down list
			And Delay 2
			And I click the button named "FormPostAndClose"
			And I close current window
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4020T_StockTransferOrders"
			And "List" table contains lines
				| 'Recorder'                             |
				| '$$InventoryTransferOrder020013$$'     |
			And I close all client application windows
		* Check Receive status - makes movements
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I go to line in "List" table
				| 'Number'                                    | 'Store sender'    | 'Store receiver'     |
				| '$$NumberInventoryTransferOrder020013$$'    | 'Store 02'        | 'Store 03'           |
			And I select current line in "List" table
			And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
			And I select "Receive" exact value from "Status" drop-down list
			And I click the button named "FormPost"
			And I click "History" hyperlink
			And "List" table contains lines
				| 'Status'       |
				| 'Wait'         |
				| 'Approved'     |
				| 'Receive'      |
			And I close current window
			And I click the button named "FormPostAndClose"
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4020T_StockTransferOrders"
			And "List" table contains lines
			| 'Recorder'                            |
			| '$$InventoryTransferOrder020013$$'    |
			And I close current window



Scenario: _020014 create ITO based on Internal supply request
	And I close all client application windows
	* Add items from basis documents
		* Open form for create ITO
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I click the button named "FormCreate"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Store sender" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Select items from basis documents
			And I click the button named "AddBasisDocuments"
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '50,000'      | 'Dress (XS/Blue)'     | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I finish line editing in "BasisesTree" table
			And I go to line in "BasisesTree" table
				| 'Quantity'    | 'Row presentation'    | 'Unit'    | 'Use'     |
				| '10,000'      | 'Dress (S/Yellow)'    | 'pcs'     | 'No'      |
			And I change "Use" checkbox in "BasisesTree" table
			And I click "Ok" button
			And I click "Show row key" button			
			And I click "Post" button							
		* Check Item tab and RowID tab
			And in the table "ItemList" I click "Edit quantity in base unit" button	
			And "ItemList" table contains lines
				| 'Internal supply request'                                  | '#'    | 'Stock quantity'    | 'Item'     | 'Item key'    | 'Quantity'    | 'Unit'    | 'Purchase order'     |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38'    | '1'    | '10,000'            | 'Dress'    | 'S/Yellow'    | '10,000'      | 'pcs'     | ''                   |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38'    | '2'    | '50,000'            | 'Dress'    | 'XS/Blue'     | '50,000'      | 'pcs'     | ''                   |
			And "RowIDInfo" table contains lines
				| 'Basis'                                                    | 'Next step'    | 'Quantity'    | 'Current step'     |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38'    | 'IT'           | '10,000'      | 'ITO&PO&PI'        |
				| 'Internal supply request 117 dated 12.02.2021 14:39:38'    | 'IT'           | '50,000'      | 'ITO&PO&PI'        |
			Then the number of "RowIDInfo" table lines is "равно" "2"	
			And I click the button named "FormUndoPosting"	
		And I close all client application windows
	* Create ITO based on ISR (Create button)
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'    |
			| '117'       |
		And I select current line in "List" table
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov1InternalSupplyRequestr017006$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$Rov2InternalSupplyRequestr017006$$"
		And I click the button named "FormDocumentInventoryTransferOrderGenerate"
		And I click "Ok" button	
		And Delay 1
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreReceiver" became equal to "Store 02"
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And I click "Show row key" button	
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Internal supply request'                                 | '#'   | 'Stock quantity'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Purchase order'    |
			| 'Internal supply request 117 dated 12.02.2021 14:39:38'   | '1'   | '10,000'           | 'Dress'   | 'S/Yellow'   | '10,000'     | 'pcs'    | ''                  |
			| 'Internal supply request 117 dated 12.02.2021 14:39:38'   | '2'   | '50,000'           | 'Dress'   | 'XS/Blue'    | '50,000'     | 'pcs'    | ''                  |
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov1InventoryTransferOrder020014$$" variable
		And I save the current field value as "$$Rov1InventoryTransferOrder020014$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I activate "Key" field in "ItemList" table
		And I delete "$$Rov2InventoryTransferOrder020014$$" variable
		And I save the current field value as "$$Rov2InventoryTransferOrder020014$$"
		And I click "Post" button	
		And I move to "Row ID Info" tab
		And "RowIDInfo" table contains lines
			| '#'   | 'Key'                                    | 'Basis'                                                   | 'Row ID'                                 | 'Next step'   | 'Quantity'   | 'Basis key'                              | 'Current step'   | 'Row ref'                                 |
			| '1'   | '$$Rov1InventoryTransferOrder020014$$'   | 'Internal supply request 117 dated 12.02.2021 14:39:38'   | '$$Rov1InternalSupplyRequestr017006$$'   | 'IT'          | '10,000'     | '$$Rov1InternalSupplyRequestr017006$$'   | 'ITO&PO&PI'      | '$$Rov1InternalSupplyRequestr017006$$'    |
			| '2'   | '$$Rov2InventoryTransferOrder020014$$'   | 'Internal supply request 117 dated 12.02.2021 14:39:38'   | '$$Rov2InternalSupplyRequestr017006$$'   | 'IT'          | '50,000'     | '$$Rov2InternalSupplyRequestr017006$$'   | 'ITO&PO&PI'      | '$$Rov2InternalSupplyRequestr017006$$'    |
		Then the number of "RowIDInfo" table lines is "равно" "2"			
		And I delete "$$NumberInventoryTransferOrder020014$$" variable
		And I delete "$$InventoryTransferOrder020014$$" variable
		And I save the value of "Number" field as "$$NumberInventoryTransferOrder020014$$"
		And I save the window as "$$InventoryTransferOrder020014$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And "List" table contains lines
			| 'Number'                                    |
			| '$$NumberInventoryTransferOrder020014$$'    |
		And I close all client application windows

	



		
				


	

