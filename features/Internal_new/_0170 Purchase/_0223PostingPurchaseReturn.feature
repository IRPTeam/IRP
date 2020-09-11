#language: en
@tree
@Positive
@Group3

Feature: create document Purchase return

As a procurement manager
I want to create a Purchase return document
To track a product that returned to the vendor

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _022301 create document Purchase return, store use Shipment confirmation, based on Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
	* Check the addition of the store to the tabular part
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'Store 02' | 'pcs' | '2,000' |
	// * Filling in the document number 1
	// 	And I move to "Other" tab
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "1" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberPurchaseReturn022301$$"
	And I save the window as "$$PurchaseReturn022301$$"
	And I click "Post and close" button

Scenario: _022302 check movements of the document Purchase return order in the OrderBalance (store use Shipment confirmation, based on Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                         | 'Item key' |
		| '2,000'    | '$$PurchaseReturn022301$$' | '1'           | 'Store 02' | '$$PurchaseReturnOrder022001$$' | 'L/Green'  |

Scenario: _022303 check movements of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, based on Purchase return order - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Company'      | 'Item key' |
	| '2,000'    | '$$PurchaseReturn022301$$' | '1'           | 'Main Company' | 'L/Green'  |

Scenario: _022304 check movements of the document Purchase return order in the GoodsInTransitOutgoing (store use Shipment confirmation, based on Purchase return order) - plus
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Shipment basis'           | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturn022301$$' | '$$PurchaseReturn022301$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022305 check movements of the document Purchase return order in the OrderReservation (store use Shipment confirmation, based on Purchase return order) - plus
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturn022301$$' | '1'           | 'Store 02' | 'L/Green'  |

	
Scenario: _022306 check that there are no movements of Purchase return in register PurchaseTurnovers (store use Shipment confirmation, based on Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'           |
		| '-2,000'   | '$$PurchaseReturn022301$$' |
	

Scenario: _022307 check that there are no movements of Purchase return in register StockBalance (store use Shipment confirmation, based on Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '2,000'    | '$$PurchaseReturn022301$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _022308 check that there are no movements of Purchase return in register StockReservation (store use Shipment confirmation, based on Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturn022301$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _022309 create document Purchase retur, store use Shipment confirmation, based on Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
//	Temporarily prices
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in the document number 2
		And I move to "Other" tab
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberPurchaseReturn022309$$"
	And I save the window as "$$PurchaseReturn022309$$"
	And I close current window

Scenario: _022310 check movements of the document Purchase return order in the OrderBalance (store use Shipment confirmation, based on Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Order'                         | 'Item key'  |
		| '3,000'    | '$$PurchaseReturn022309$$' | '1'           | 'Store 01' | '$$PurchaseReturnOrder022006$$' | '36/Yellow' |

Scenario: _022311 check movements of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, based on Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Company'      | 'Item key'  |
	| '3,000'    | '$$PurchaseReturn022309$$' | '1'           | 'Main Company' | '36/Yellow' |

Scenario: _022312 check movements of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, based on Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
		| '3,000'    | '$$PurchaseReturn022309$$' | '1'           | 'Store 01' | '36/Yellow' |

Scenario: _022313 check movements of the document Purchase return order in the OrderReservation (store use Shipment confirmation, based on Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
		| '3,000'    | '$$PurchaseReturn022309$$' | '1'           | 'Store 01' | '36/Yellow' |

Scenario: _022314 create document Purchase return, store use Shipment confirmation, without Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 02'  |
	And I select current line in "List" table
	* Check that the amount from the receipt minus the previous returns is pulled into the return
		And "ItemList" table contains lines
			| 'Purchase return order' | 'Item'  | 'Item key' | 'Purchase invoice'          | 'Unit' | 'Q'       |
			| ''                      | 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'pcs'  | '498,000' |
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "10,000" text in "Q" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberPurchaseReturn022314$$"
	And I save the window as "$$PurchaseReturn022314$$"
	And I click "Post and close" button
	And I close current window

Scenario: _022315 check that there are no movements of Purchase return document by OrderBalance (store use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022316 check movements Purchase return in the register PurchaseTurnovers (store use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 |
		| '-10,000'  | '$$PurchaseReturn022314$$' |

Scenario: _022317 check movements of the document Purchase return order in the InventoryBalance (store use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Company'      | 'Item key' |
	| '10,000'   | '$$PurchaseReturn022314$$' | '1'           | 'Main Company' | 'L/Green'  |

Scenario: _022318 check movements of the document Purchase return order in the GoodsInTransitOutgoing (store use Shipment confirmation, without Purchase return order) - plus
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Shipment basis'           | 'Line number' | 'Store'    | 'Item key' |
	| '10,000'   | '$$PurchaseReturn022314$$' | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022319 check that there are no movements of Purchase return in register StockBalance (store use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022320 check purchase return movements by register StockReservation (store use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022321 check purchase return movements by register Purchase return in the register OrderReservation (store use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _022322 create document Purchase return, store doesn't use Shipment confirmation, without Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 01'  |
	And I select current line in "List" table
	And Delay 2
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key' |
		| 'Trousers' | '36/Yellow'|
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And Delay 2
	And I input "12,000" text in "Q" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'  | 'Item key' | 'Unit' |
		| 'Dress' | 'L/Green'  | 'pcs'  |
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'  |
		| 'Dress' |
	And I delete a line in "ItemList" table
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberPurchaseReturn022322$$"
	And I save the window as "$$PurchaseReturn022322$$"
	And I click "Post and close" button
	// 4
	And I close current window

Scenario: _022323 check movements of the document Purchase return order in the PurchaseTurnovers (store doesn't use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 |
		| '-12,000'  | '$$PurchaseReturn022322$$' |

Scenario: _022324 check movements of the document Purchase return order in the InventoryBalance (store doesn't use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.InventoryBalance"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                 | 'Line number' | 'Company'      | 'Item key'  |
	| '12,000'   | '$$PurchaseReturn022322$$' | '1'           | 'Main Company' | '36/Yellow' |

Scenario: _022325 check that there are no movements of Purchase return document by GoodsInTransitOutgoing (store doesn't use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table does not contain lines
	| 'Quantity' | 'Recorder'                 | 'Shipment basis'           | 'Line number' | 'Item key'  |
	| '12,000'   | '$$PurchaseReturn022322$$' | '$$PurchaseReturn022322$$' | '1'           | '36/Yellow' |

Scenario: _022326 check movements of the document Purchase return order in the StockBalance (store doesn't use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | '$$PurchaseReturn022322$$' | '1'           | 'Store 01' | '36/Yellow'  |

Scenario: _022327 check movements of the document Purchase return order in the StockReservation (store doesn't use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | '$$PurchaseReturn022322$$' | '1'           | 'Store 01' | '36/Yellow'  |

Scenario: _022328 check that there are no movements of Purchase return in register StockReservation (store doesn't use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'   | '$$PurchaseReturn022322$$' | '1'           | 'Store 01' | '36/Yellow' |

Scenario: _022329 check that there are no movements of Purchase return document by OrderReservation (store doesn't use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table does not contain lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key'  |
		| '12,000'   | '$$PurchaseReturn022314$$' | '1'           | 'Store 01' | '36/Yellow' |


Scenario: _022335 check totals in the document Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Select Purchase Return
		And I go to line in "List" table
		| 'Number' |
		| '$NumberPurchaseReturn022301$$'     |
		And I select current line in "List" table
	* Check totals in the document Purchase return
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "12,20"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "67,80"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "80,00"






