#language: en
@tree
@Positive
@Group16
Feature: create Inventory transfer order based on several Internal supply request


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _295400 preparation 
	* Create first Internal supply request from Store 02
		* Open a creation form Internal Supply Request
			Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
			And I click the button named "FormCreate"
		* Change the document number
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "295" text in "Number" field
		* Filling in basic details
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		* Filling in the tabular part
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Create second Internal supply request from Store 02
		* Open a creation form Internal Supply Request
			Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
			And I click the button named "FormCreate"
		* Change the document number
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "296" text in "Number" field
		* Filling in basic details
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		* Filling in the tabular part
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Dress' | 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Create third Internal supply request from Store 03
		* Open a creation form Internal Supply Request
			Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
			And I click the button named "FormCreate"
		* Change the document number
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "297" text in "Number" field
		* Filling in basic details
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 03  |
			And I select current line in "List" table
		* Filling in the tabular part
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key'  |
				| 'Dress' | 'M/White' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'High shoes'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'       | 'Item key' |
				| 'High shoes' | '37/19SD'  |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post and close" button


Scenario: _295401 check filling in Inventory transfer order when creating based on two Internal supply requests with the same warehouse
	* Select InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'  |
			| '295' | 
		And I move one line down in "List" table and select line
	* Create Inventory transfer order and check filling in
		And I click the button named "FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder"
		And "ItemList" table contains lines
		| 'Item'       | 'Quantity' | 'Internal supply request'      | 'Item key'  | 'Unit' |
		| 'Dress'      | '2,000'    | 'Internal supply request 296*' | 'S/Yellow'  | 'pcs'  |
		| 'Trousers'   | '2,000'    | 'Internal supply request 295*' | '38/Yellow' | 'pcs'  |
		| 'Boots'      | '1,000'    | 'Internal supply request 295*' | '37/18SD'   | 'pcs'  |
		| 'Boots'      | '2,000'    | 'Internal supply request 296*' | '37/18SD'   | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 295*' | '37/19SD'   | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 296*' | '37/19SD'   | 'pcs'  |
	And I close all client application windows

Scenario: _295402 check filling in Inventory transfer order when creating based on two Internal supply requests with the different warehouse
	* Select InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'  |
			| '296' | 
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentInventoryTransferOrderGenerateInventoryTransferOrder"
		And I go to line in "Stores" table
			| 'Store'    |
			| 'Store 03' |
		And I set "Use" checkbox in "Stores" table
		And I finish line editing in "Stores" table
		And I click "Ok" button
	* Create Inventory transfer order and check filling in
		And "ItemList" table contains lines
		| 'Item'       | 'Quantity' | 'Internal supply request'      | 'Item key' | 'Unit' |
		| 'Dress'      | '2,000'    | 'Internal supply request 297*' | 'M/White'  | 'pcs'  |
		| 'Boots'      | '2,000'    | 'Internal supply request 297*' | '37/18SD'  | 'pcs'  |
		| 'High shoes' | '2,000'    | 'Internal supply request 297*' | '37/19SD'  | 'pcs'  |
	And I close all client application windows
