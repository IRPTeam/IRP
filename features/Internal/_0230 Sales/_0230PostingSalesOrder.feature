#language: en
@tree
@Positive
@Group5
Feature: create document Sales order

As a sales manager
I want to create a Sales order document
To track the items ordered by the customer

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _023001 create document Sales order - Shipment confirmation is not used
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	Then "Partner terms" window is opened
	And I go to line in "List" table
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "4,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check store filling in the tabular section
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    |
		| 'Dress'    | '550,00' | 'L/Green'   | 'Store 01' |
	* Check default sales order status
		And I move to "Other" tab
		Then the form attribute named "Status" became equal to "Approved"
	* Filling Delivery date
		And I input current date in the field named "DeliveryDate"
	And I click "Post" button
	And I save the window as "$$SalesOrder1$$"
	And I close current window
	And I display "$$SalesOrder1$$" variable value

Scenario: _023002 check Sales Order posting by register OrderBalance (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Order'          | 'Item key' |
	| '5,000'    | '$$SalesOrder1$$' | 'Store 01' | '$$SalesOrder1$$' | 'L/Green'  |
	| '4,000'    | '$$SalesOrder1$$' | 'Store 01' | '$$SalesOrder1$$' | '36/Yellow'   |

Scenario: _023003 check Sales Order posting by register StockReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | '$$SalesOrder1$$' | 'Store 01' | 'L/Green'  |
	| '4,000'    | '$$SalesOrder1$$' | 'Store 01' | '36/Yellow'   |

Scenario: _023004 check Sales Order posting by register OrderReservation (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'       | 'Store'    | 'Item key' |
	| '5,000'    | '$$SalesOrder1$$' | 'Store 01' | 'L/Green'  |
	| '4,000'    | '$$SalesOrder1$$' | 'Store 01' | '36/Yellow'   |

Scenario: _023005 create document Sales order - Shipment confirmation used
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'       |
				| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description' |
				| 'Company Ferron BP'  |
		And I select current line in "List" table
	When adding the items to the sales order (Dress and Trousers)
	* Check default sales order status
		And I move to "Other" tab
		Then the form attribute named "Status" became equal to "Approved"
	And I click "Post" button
	And I save the window as "$$SalesOrder2$$"
	And I close current window
	And I display "$$SalesOrder2$$" variable value

Scenario: _023006 check Sales Order posting by register OrderBalance (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
	| 'Quantity'  | 'Recorder'        | 'Store'    | 'Order'          | 'Item key' |
	| '10,000'    | '$$SalesOrder2$$' | 'Store 02' | '$$SalesOrder2$$' | 'L/Green'  |
	| '14,000'    | '$$SalesOrder2$$' | 'Store 02' | '$$SalesOrder2$$' | '36/Yellow'   |

Scenario: _023007 check Sales Order posting by register StockReservation (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | '$$SalesOrder2$$' | 'Store 02' | 'L/Green'  |
	| '14,000'    | '$$SalesOrder2$$' | 'Store 02' | '36/Yellow'   |

Scenario: _023008 check Sales Order posting by register OrderReservation (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '10,000'    | '$$SalesOrder2$$' | 'Store 02' | 'L/Green'  |
	| '14,000'    | '$$SalesOrder2$$' | 'Store 02' | '36/Yellow'   |


Scenario: _023014 check movements by status and status history of a Sales Order document
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number' | 'Partner'   |
		| '1'      | 'Ferron BP' |
	And I select current line in "List" table
	* Change status to Wait (doesn't post)
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
	And I click "Post and close" button
	* Check the absence of movements Sales Order
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Recorder'       | 'Order'          |
			| '$$SalesOrder1$$' |'$$SalesOrder1$$'  |
			| '$$SalesOrder1$$' |'$$SalesOrder1$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table does not contain lines
			| 'Recorder'       |
			| '$$SalesOrder1$$' |
			| '$$SalesOrder1$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
		And "List" table does not contain lines
			| 'Recorder'       |
			| '$$SalesOrder1$$' |
			| '$$SalesOrder1$$' |
		And I close current window
	* Opening a previously created order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' | 'Partner'   |
			| '1'      | 'Ferron BP' |
		And I select current line in "List" table
	* Change sales order status to Approved
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'         | 'Status'   |
			| '$$SalesOrder1$$' | 'Wait'     |
			| '$$SalesOrder1$$' | 'Approved' |
		And I close current window
		And I click "Post and close" button
	* Check document movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Recorder'       | 'Order'          |
			| '$$SalesOrder1$$' |'$$SalesOrder1$$'  |
			| '$$SalesOrder1$$' |'$$SalesOrder1$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table contains lines
			| 'Recorder'       |
			| '$$SalesOrder1$$' |
			| '$$SalesOrder1$$' |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
		And "List" table contains lines
			| 'Recorder'       |
			| '$$SalesOrder1$$' |
			| '$$SalesOrder1$$' |
		And I close current window





