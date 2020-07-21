#language: en
@tree
@Positive


Feature: create document Purchase order

As a procurement manager
I want to create a Purchase order document
For tracking an item that has been ordered from a vendor

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _017001 create document Purchase order - Goods receipt is not used
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Status filling
		And I select "Approved" exact value from "Status" drop-down list
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
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Filling in the document number №2
		And I move to "Other" tab
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100" text in "Q" field of "ItemList" table
		And I input "200" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200" text in "Q" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		And I select current line in "ItemList" table
		And I input "300" text in "Q" field of "ItemList" table
		And I input "250" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Q' | 'Item key'  | 'Store' | 'Unit' |
			| 'Dress'    | '100,000'  | 'M/White'   | 'Store 01'      | 'pcs' |
	* Post document
		And I click "Post and close" button

Scenario: _017002 check Purchase Order N2 posting by register Order Balance (+) - Goods receipt is not used
	* Opening register Order Balance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	* Check the register form
		If "List" table contains columns Then
			| 'Period' |
			| 'Quantity' |
			| 'Recorder' |
			| 'Line number' |
			| 'Store' |
			| 'Order' |
			| 'Item key' |
	* Check Purchase Order N2 posting by register Order Balance
		And "List" table contains lines
			| 'Quantity' | 'Recorder'          | 'Store'    | 'Order'             | 'Item key' |
			| '100,000'  | 'Purchase order 2*' | 'Store 01' | 'Purchase order 2*' | 'M/White' |
			| '200,000'  | 'Purchase order 2*' | 'Store 01' | 'Purchase order 2*' | 'L/Green'  |
			| '300,000'  | 'Purchase order 2*' | 'Store 01' | 'Purchase order 2*' | '36/Yellow'   |

Scenario: _017003 create document Purchase order - Goods receipt is used
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Company" field
		And I go to line in "List" table
		| Description  |
		| Main Company |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
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
			| Vendor Ferron, USD |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
	* Filling in the document number №3
		And I move to "Other" tab
		And I input "3" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3" text in "Number" field
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "500,000" text in "Q" field of "ItemList" table
		And I input "40,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click "Post and close" button

Scenario: _017004 check Purchase Order N3 posting by register Order Balance (+) - Goods receipt is not used
	* Opening of register Order Balance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	* Check Purchase Order N3 posting by register Order Balance
		And "List" table contains lines
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key' |
			| '500,000'  | 'Purchase order 3*' | '1'           | 'Store 02' | 'Purchase order 3*' | 'L/Green'  |

Scenario: _017005 check movements by status and status history of a Purchase Order document
	And I close all client application windows
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in the details
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
	* Check the default status "Wait"
		Then the form attribute named "Status" became equal to "Wait"
	* Filling in the document number №101
		And I move to "Other" tab
		And I input "101" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "101" text in "Number" field
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		And I select current line in "ItemList" table
		And I input "30,000" text in "Q" field of "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click "Post and close" button
		And I close current window
	* Check the absence of movements Purchase Order N101 by register Order Balance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Recorder'          | 'Store'    | 'Order'             |
			| 'Purchase order 101*' | 'Store 01' | 'Purchase order 101*' |
		And I close all client application windows
	* Setting the status by Purchase Order №101 'Approved'
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '101'      |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I click the hyperlink named "DecorationStatusHistory"
		And "List" table contains lines
			| Object             | Status   |
			| Purchase order 101* | Wait     |
			| Purchase order 101* | Approved |
		And I close current window
		And I click "Post and close" button
		And I close current window
	* Check document movements after the status is set to Approved
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Recorder'          | 'Store'    | 'Order'             |
			| 'Purchase order 101*' | 'Store 01' | 'Purchase order 101*' |
		And I close current window
	* Check for cancelled movements when the Approved status is changed to Wait
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '101'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
		And I click "Post" button
		And I click the hyperlink named "DecorationStatusHistory"
		And "List" table contains lines
			| 'Object'             | 'Status'   |
			| 'Purchase order 101*' | 'Wait'     |
			| 'Purchase order 101*' | 'Approved' |
			| 'Purchase order 101*' | 'Wait'     |
		And I close current window
		And I click "Post and close" button
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Recorder'          | 'Store'    | 'Order'             |
			| 'Purchase order 101*' | 'Store 01' | 'Purchase order 101*' |
		And I close current window



Scenario: _017011 check totals in the document Purchase Order
	* Opening a list of documents Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Selecting PurchaseOrder
		And I go to line in "List" table
		| Number |
		| 2      |
		And I select current line in "List" table
	* Check totals in the document
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"

	


Scenario: _017003 check the form Pick up items in the document Purchase order
	* Opening a form to create Purchase Order
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
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
	* Check the form Pick up items
		When check the product selection form with price information in Purchase order
		And I close all client application windows
	









