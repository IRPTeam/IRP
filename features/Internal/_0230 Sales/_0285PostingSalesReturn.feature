#language: en
@tree
@Positive
@Group5
Feature: create document Sales return

As a procurement manager
I want to create a Sales return document
To track a product that returned from customer

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _028501 create document Sales return, store use Goods receipt, without Sales return order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '3'      |  'Kalipso' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 02'  |
	And I select current line in "List" table
	And I click "OK" button
	And I move to "Item list" tab
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "1,000" text in "Q" field of "ItemList" table
	And I input "550,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I move to "Item list" tab
	And "ItemList" table contains lines
	| 'Item'     | 'Item key'  | 'Store'    |
	| 'Dress'    |  'L/Green'  | 'Store 02' |
	* Filling in the document number 1
		And I move to "Other" tab
		And I input "1" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	And I click "Post and close" button
	And I close current window


Scenario: _028502 check that there are no movements of Sales return in register OrderBalance (store use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _028503 check movements of Sales return in register SalesTurnovers (store use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return 1*' | '1'           | 'Sales invoice 3*' | 'L/Green'  |

Scenario: _028504 check movements of Sales return in register InventoryBalance (store use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 1*' | '1'           | 'Main Company' | 'L/Green'  |

Scenario: _028505 check movements of Sales return in register GoodsInTransitIncoming (store use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 1*' | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028506 check that there are no movements of Sales return in register StockBalance (store use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028507 check that there are no movements of Sales return in register StockReservation (store use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 1*' | '1'           | 'Store 02' | 'L/Green'  |



Scenario: _028508 create document Sales return, store doesn't use Goods receipt, without Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'     |
		| '2'      |  'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click "OK" button
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
	* Filling in the document number 2
		And I move to "Other" tab
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	And I click "Post and close" button
	And I close current window


Scenario: _028509 check that there are no movements of Sales return in register OrderBalance (store doesn't use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Scenario: _028510 check movements of Sales return in register SalesTurnovers (store doesn't use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Sales invoice'    | 'Item key' |
		| '-1,000'   | 'Sales return 2*' | '1'           | 'Sales invoice 2*' | 'L/Green'  |

Scenario: _028511 check movements of Sales return in register InventoryBalance (store doesn't use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Line number' | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 2*' | '1'           | 'Main Company' | 'L/Green'  |

Scenario: _028512 check that there are no movements of Sales return in register GoodsInTransitIncoming (store doesn't use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Line number' | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 2*' | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Scenario: _028513 check movements of Sales return in register StockBalance (store doesn't use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |

Scenario: _028514 check movements of Sales return in register StockReservation (store doesn't use Goods receipt, without Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Line number' | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 2*' | '1'           | 'Store 01' | 'L/Green'  |



Scenario: _028515 create document Sales return, store use Goods receipt, based on Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '1'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I input "466,10" text in "Price" field of "ItemList" table
	* Filling in the document number 3
		And I move to "Other" tab
		And I input "3" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3" text in "Number" field
	And I click "Post and close" button
	And I close current window

Scenario: _028516 check movements of Sales return in register OrderBalance (store use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Order'                 | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Store 02' | 'Sales return order 1*' | 'L/Green'  |

Scenario: _028517 check that there are no movements of Sales return in register SalesTurnovers (store use Goods receipt, based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Item key' |
		| '-1,000'   | 'Sales return 3*' | 'L/Green'  |

Scenario: _028518 check movements of Sales return in register InventoryBalance (store use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Company'      | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Main Company' | 'L/Green'  |

Scenario: _028519 check movements of Sales return in register GoodsInTransitIncoming (store use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Store'    | 'Item key' |
		| '1,000'    | 'Sales return 3*' | 'Sales return 3*' | 'Store 02' | 'L/Green'  |

Scenario: _028520 check that there are no movements of Sales return in register StockBalance (store use Goods receipt, based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 3*' | 'Store 02' | 'L/Green'  |

Scenario: _028521 check that there are no movements of Sales return in register StockReservation (store use Goods receipt, based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key' |
	| '1,000'    | 'Sales return 3*' | 'Store 02' | 'L/Green'  |


Scenario: _028522 create document Sales return, store doesn't use Goods receipt, based on Sales return order
	
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '2'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnGenerateSalesReturn"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	* Filling in the document number 4
		And I move to "Other" tab
		And I input "4" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "4" text in "Number" field
	And I click "Post and close" button
	And I close current window


Scenario: _028523 check movements of Sales return in register OrderBalance (store use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
		| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
		| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |

Scenario: _028524 check that there are no movements of Sales return in register SalesTurnovers (store doesn't use Goods receipt, based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.SalesTurnovers"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Sales invoice'    | 'Item key' |
		| '-2,000'   | 'Sales return 4*' | 'Sales invoice 4*' | 'L/Green'  |
		| '-4,000'   | 'Sales return 4*' | 'Sales invoice 4*' | '36/Yellow' |


Scenario: _028525 check movements of Sales return in register InventoryBalance (store doesn't use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'        | 'Company'      | 'Item key'  |
		| '2,000'    | 'Sales return 4*' | 'Main Company' | 'L/Green'   |
		| '4,000'    | 'Sales return 4*' | 'Main Company' | '36/Yellow' |


Scenario: _028526 check that there are no movements of Sales return in register GoodsInTransitIncoming (store doesn't use Goods receipt, based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'        | 'Receipt basis'   | 'Store'    | 'Item key' |
		| '2,000'    | 'Sales return 4*' | 'Sales return 4*' | 'Store 01' | 'L/Green'  |
		| '4,000'    | 'Sales return 4*' | 'Sales return 4*' | 'Store 01' | '36/Yellow'  |


Scenario: _028527 check movements of Sales return in register StockBalance (store doesn't use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
	| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
	| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |

Scenario: _028528 check movements of Sales return in register StockReservation (store doesn't use Goods receipt,  based on Sales return order) 
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'        | 'Store'    | 'Item key'  |
	| '2,000'    | 'Sales return 4*' | 'Store 01' | 'L/Green'   |
	| '4,000'    | 'Sales return 4*' | 'Store 01' | '36/Yellow' |




Scenario: _028534 check totals in the document Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Select Sales Return
		And I go to line in "List" table
		| Number |
		| 1      |
		And I select current line in "List" table
	* Check totals in the document Sales return
		Then the form attribute named "ItemListTotalNetAmount" became equal to "466,10"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "83,90"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "550,00"


