#language: en
@tree
@Positive
Feature: create document Goods receipt

As a storekeeper
I want to create a Goods receipt
To take products to the store


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _028901 create document Goods Reciept based on Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '2'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Change of document number - 106
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "106" text in "Number" field
	* Check the filling in the tabular part of the  items
		And "ItemList" table contains lines
		| '#' | 'Item'     | 'Receipt basis'     | 'Item key' | 'Unit' | 'Quantity'       |
		| '1' | 'Dress'    | 'Purchase invoice 2*' | 'L/Green'  | 'pcs' | '500,000' |
		And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' |
		| 'Dress' | '500,000'  | 'L/Green'  | 'Store 02' | 'pcs' |
	And I click "Post and close" button
	And I close current window
	

Scenario: _028902 check  Goods Reciept posting by register GoodsInTransitIncoming (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'          | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key'  |
		| '500,000'  | 'Goods receipt 106*'  | 'Purchase invoice 2*'   | '1'           | 'Store 02' | 'L/Green'   |

Scenario: _028903 check  Goods Reciept posting by register StockBalance (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Line number'  | 'Store'    | 'Item key' |
		| '500,000'  | 'Goods receipt 106*'   | '1'            | 'Store 02' | 'L/Green'  |

Scenario: _028904 check  Goods Reciept posting by register StockReservation (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                          | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | 'Goods receipt 106*'                 | '1'           | 'Store 02'    | 'L/Green'  |


