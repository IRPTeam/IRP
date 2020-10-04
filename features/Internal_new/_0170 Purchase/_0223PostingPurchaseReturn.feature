#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase return

As a procurement manager
I want to create a Purchase return document
To track a product that returned to the vendor

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _022300 preparation
	* Constants
		When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017003$$" |
			When create PurchaseOrder017003
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018001$$" |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018006$$" |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
	* Check or create PurchaseReturnOrder022001
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturnOrder022001$$" |
			When create PurchaseReturnOrder022001 based on PurchaseInvoice018006 (PurchaseOrder017003)
	* Check or create PurchaseReturnOrder022006
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturnOrder022006$$" |
			When create PurchaseReturnOrder022006 based on PurchaseInvoice018001 (PurchaseOrder017001)
	



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
	When create PurchaseReturn022314
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022314$$'      |
	And I select current line in "List" table
	* Check that the amount from the receipt minus the previous returns is pulled into the return
		And "ItemList" table contains lines
			| 'Purchase return order' | 'Item'  | 'Item key' | 'Purchase invoice'          | 'Unit' | 'Q'       |
			| ''                      | 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'pcs'  | '498,000' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button

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

Scenario: _022327 check movements of the document Purchase return in the StockReservation (store doesn't use Shipment confirmation, without Purchase return order) - minus
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'           | 'Line number' | 'Store'    | 'Item key' |
		| '12,000'   | '$$PurchaseReturn022322$$' | '1'           | 'Store 01' | '36/Yellow'  |

Scenario: _022328 check movements of Purchase return in register StockReservation (store doesn't use Shipment confirmation, without Purchase return order)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
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
		| '$$NumberPurchaseReturn022301$$'     |
		And I select current line in "List" table
	* Check totals in the document Purchase return
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "12,20"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "67,80"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "80,00"




Scenario: _022336 check the output of the document movement report for Purchase Return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022301$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseReturn022301$$'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Partner term'          | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en description is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturn022301$$'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturnOrder022001$$' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022301$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseReturn022301$$'                    | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Basis document'           | 'Partner'   | 'Legal name'        | 'Partner term'          | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'en description is empty' | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'Reporting currency'       | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                      | 'USD'                      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'    | 'Main Company' | ''                         | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                      | 'Local currency'           | 'No'                   |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | 'Attributes'               | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Purchase invoice'         | 'Currency'  | 'Item key'          | 'Row key'            | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'   | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'TRY'       | 'L/Green'           | '*'                  | 'Local currency'           | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'en description is empty' | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'Reporting currency'       | 'No'                       | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'       | 'Main Company' | '$$PurchaseInvoice018006$$'      | 'USD'       | 'L/Green'           | '*'                  | 'USD'                      | 'No'                       | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Company'      | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Main Company' | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'           | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturn022301$$'       | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'                 | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | 'L/Green'                  | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Accounts statement"'              | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | 'Record type'         | 'Period'              | 'Resources'           | ''               | ''                                                  | ''               | 'Dimensions'                           | ''                                     | ''                         | ''                         | ''                     |
		| ''                                            | ''                    | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                            | 'Transaction AR' | 'Company'                              | 'Partner'                              | 'Legal name'               | 'Basis document'           | 'Currency'             |
		| ''                                            | 'Receipt'             | '*'                   | ''                    | '-80'            | ''                                                  | ''               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'        | ''                         | 'USD'                  |
		| ''                                            | ''                    | ''                    | ''                    | ''               | ''                                                  | ''               | ''                                     | ''                                     | ''                         | ''                         | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Amount'    | 'Company'      | 'Legal name'               | 'Currency'  | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'        | 'Main Company' | 'Company Ferron BP'        | 'USD'       | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''          | ''             | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                         | ''          | ''                  | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'           | ''                   | ''                         | ''                         | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'         | 'Store 02'     | '$$PurchaseReturnOrder022001$$' | 'L/Green'   | '*'                 | ''                   | ''                         | ''                         | ''                     |
	And I close all client application windows


Scenario: _02233601 clear movements Purchase Return and check that there is no movements on the registers 
	* Open list form Purchase Return Order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturn022301$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Partner AR transactions"'   |
			| 'Register  "Inventory balance"'         |
			| 'Register  "Goods in transit outgoing"' |
			| 'Register  "Order reservation"'         |
			| 'Register  "Reconciliation statement"'  |
			| 'Register  "Order balance"'             |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturn022301$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseReturn022301$$'              | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Document registrations records'        | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'   | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | 'Attributes'           |
		| ''                                      | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'                | 'Partner'        | 'Legal name'        | 'Partner term'       | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                          | 'en description is empty'      | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                          | 'Reporting currency'           | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'USD'                          | 'USD'                          | 'No'                   |
		| ''                                      | 'Receipt'     | '*'         | '451,98'               | 'Main Company'   | ''                              | 'Ferron BP'      | 'Company Ferron BP' | 'Vendor Ferron, USD' | 'TRY'                          | 'Local currency'               | 'No'                   |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Purchase return turnovers"' | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Period'      | 'Resources' | ''                     | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | 'Attributes'                   | ''                     |
		| ''                                      | ''            | 'Quantity'  | 'Amount'               | 'Company'        | 'Purchase invoice'              | 'Currency'       | 'Item key'          | 'Row key'            | 'Multi currency movement type' | 'Deferred calculation'         | ''                     |
		| ''                                      | '*'           | '-2'        | '-451,98'              | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'TRY'            | 'L/Green'           | '*'                  | 'Local currency'               | 'No'                           | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'                  | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'USD'            | 'L/Green'           | '*'                  | 'en description is empty'      | 'No'                           | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'                  | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'USD'            | 'L/Green'           | '*'                  | 'Reporting currency'           | 'No'                           | ''                     |
		| ''                                      | '*'           | '-2'        | '-80'                  | 'Main Company'   | '$$PurchaseInvoice018006$$'     | 'USD'            | 'L/Green'           | '*'                  | 'USD'                          | 'No'                           | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Inventory balance"'         | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'                      | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'                    | 'Main Company'   | 'L/Green'                       | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Goods in transit outgoing"' | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Shipment basis'                | 'Item key'       | 'Row key'           | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '2'                    | 'Store 02'       | '$$PurchaseReturn022301$$'      | 'L/Green'        | '*'                 | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Order reservation"'         | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'                      | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'                    | 'Store 02'       | 'L/Green'                       | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Accounts statement"'        | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                              | ''               | 'Dimensions'        | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'        | 'Transaction AR' | 'Company'           | 'Partner'            | 'Legal name'                   | 'Basis document'               | 'Currency'             |
		| ''                                      | 'Receipt'     | '*'         | ''                     | '-80'            | ''                              | ''               | 'Main Company'      | 'Ferron BP'          | 'Company Ferron BP'            | ''                             | 'USD'                  |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Reconciliation statement"'  | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'                    | 'Currency'       | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '80'                   | 'Main Company'   | 'Company Ferron BP'             | 'USD'            | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| 'Register  "Order balance"'             | ''            | ''          | ''                     | ''               | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                              | ''               | ''                  | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Order'                         | 'Item key'       | 'Row key'           | ''                   | ''                             | ''                             | ''                     |
		| ''                                      | 'Expense'     | '*'         | '2'                    | 'Store 02'       | '$$PurchaseReturnOrder022001$$' | 'L/Green'        | '*'                 | ''                   | ''                             | ''                             | ''                     |
		And I close all client application windows


Scenario: _300509 check connection to PurchaseReturn report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberPurchaseReturn022301$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows



