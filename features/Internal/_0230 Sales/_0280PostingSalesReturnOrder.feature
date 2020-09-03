#language: en
@tree
@Positive
@Group5
Feature: create document Sales return order

As a sales manager
I want to create a Sales return order document
To track a product that needs to be returned from customer


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _028001 create document Sales return order, store use Goods receipt, based on Sales invoice + check status
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '2'      |  'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnOrderGenerateSalesReturnOrder"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
	And I select "Wait" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'     |
		| 'Trousers' |
	And I delete a line in "ItemList" table
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "1,000" text in "Q" field of "ItemList" table
	And I input "466,10" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Filling in the document number 1
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click "Post and close" button
	And I close all client application windows
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
			| '1,000'    | 'Sales return order 1*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
			| '-1,000'   | 'Sales return order 1*' | 'Sales invoice 2*' | 'L/Green'  |
		And I close all client application windows
	* And I set Approved status
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                 | 'Status'   |
			| 'Sales return order 1*' | 'Wait'     |
			| 'Sales return order 1*' | 'Approved' |
		And I close current window
		And I click "Post and close" button


Scenario: _028002 check  Sales  return order movements the OrderBalance register (store use Goods receipt, based on Sales invoice)  (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'              | 'Item key' |
		| '1,000'    | 'Sales return order 1*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |

Scenario: _028003 check  Sales  return order movements the SalesTurnovers register (store use Goods receipt, based on Sales invoice)  (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return order 1*' | 'Sales invoice 2*' | 'L/Green'  |


Scenario: _028004 create document Sales return order, store doesn't use Goods receipt, based on Sales invoice
	
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '1'      |  'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnOrderGenerateSalesReturnOrder"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	And I click Select button of "Store" field
	Then "Stores" window is opened
	And I go to line in "List" table
		| 'Description' |
		| 'Store 01'  |
	And I select current line in "List" table
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'  | 'Item key' |
		| 'Dress' | 'L/Green'  |
	And I select current line in "ItemList" table
	And I activate "Q" field in "ItemList" table
	And I input "2,000" text in "Q" field of "ItemList" table
	And I input "550,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| Item     | Item key  |
		| Trousers | 36/Yellow |
	And I select current line in "ItemList" table
	And I input "400,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Filling in the document number 2
		And I move to "Other" tab
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	And I click "Post and close" button
	And I close current window


Scenario: _028005 check Sales return order movements the OrderBalance register (store doesn't use Goods receipt, based on Sales invoice)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Store'    | 'Order'                 | 'Item key'  |
		| '2,000'    | 'Sales return order 2*' | 'Store 01' | 'Sales return order 2*' | 'L/Green'   |
		| '4,000'    | 'Sales return order 2*' | 'Store 01' | 'Sales return order 2*' | '36/Yellow' |

Scenario: _028006 check Sales return order movements the SalesTurnovers register (store doesn't use Goods receipt, based on Sales invoice) (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Sales invoice'    | 'Item key'  |
		| '-2,000'   | 'Sales return order 2*' | 'Sales invoice 1*' | 'L/Green'   |
		| '-4,000'   | 'Sales return order 2*' | 'Sales invoice 1*' | '36/Yellow' |



Scenario: _028012 check totals in the document Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	* Select Sales return
		And I go to line in "List" table
		| Number |
		| 1      |
		And I select current line in "List" table
	* Check totals in the document Sales return order
		Then the form attribute named "ItemListTotalNetAmount" became equal to "466,10"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "83,90"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "550,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"



