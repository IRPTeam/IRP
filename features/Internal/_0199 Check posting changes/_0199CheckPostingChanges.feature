#language: en
@tree
@Positive


Feature: register changes when documents are changed 

As a Developer
I want to develop a system to check if the movements need to be changed when documents are changed.
In order not to double entries in the registers

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _019901 check changes in movements on a Purchase Order document when quantity changes
	When create a Purchase Order document
	When change purchase order number to 103
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
		And I close all client application windows
	* Changing the quantity by Item Dress 'S/Yellow' by 250 pcs
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'        | 'Unit' |
			| 'Dress' | 'S/Yellow' | '200,000'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "250,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | '1'           | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
	
Scenario: _019902 delete line in Purchase order and chek movements changes
	* Delete last line in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to the last line in "ItemList" table
		And I delete current line in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
	
Scenario: _019903 add line in Purchase order and chek movements changes
	* Add line in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And Delay 2
		And I select current line in "List" table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '39/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "100,000" text in "Q" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "50,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And Delay 2
		And "List" table contains lines
			| 'Quantity' | 'Recorder'          | 'Store'    | 'Order'             | 'Item key'  |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '50,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
	
Scenario: _019904 add package in Purchase order and chek movements (conversion to storage unit)
	* Add package in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to the last line in "ItemList" table
		And I delete current line in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'High shoes box (8 pcs)' |
		And I select current line in "List" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'High shoes box (8 pcs)' |
		And I select current line in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
	# Packages are converted into pcs.
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '80,000'   | 'Purchase order 103*' | '13'          | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
	
Scenario: _019905 mark for deletion document Purchase Order and check cancellation of movements
	* Mark for deletion document Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '103' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
 
Scenario: _019906 post a document previously marked for deletion and check of movements
	* Post a document previously marked for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '103' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And in the table "List" I click the button named "ListContextMenuPost"
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
		And I close current window


Scenario: _019907 clear posting document Purchase Order and check cancellation of movements
	* Clear posting document Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '103' |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close current window
	* Check registry entries (Order Balance)
		And Delay 5
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'          |
			| '250,000'  | 'Purchase order 103*' |
			| '200,000'  | 'Purchase order 103*' |
		And I close current window
	* Post a document with previously cleared movements
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '103' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close current window
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'            | 'Store'    | 'Order'             | 'Item key'  |
			| '250,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'S/Yellow'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XS/Blue'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'M/White'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | 'XL/Green'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Yellow' |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/Red'    |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/Black'  |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '36/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '37/18SD'   |
			| '200,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '38/18SD'   |
			| '100,000'  | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/18SD'   |
			| '80,000'   | 'Purchase order 103*' | 'Store 03' | 'Purchase order 103*' | '39/19SD'   |
		And I close current window
	
Scenario: _019908 create Purchase invoice and Goods receipt based on a Purchase order with that contains packages
	# Packages are converted into pcs.
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number'    |
		| '103' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	And I click Select button of "Company" field
	And I click the button named "FormChoose"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 03'  |
	And I select current line in "List" table
	And I click "Post" button
	* Post Goods receipt
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I click "Post and close" button
	And I close current window
