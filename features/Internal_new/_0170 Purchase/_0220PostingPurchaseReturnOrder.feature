#language: en
@tree
@Positive
@Purchase

Feature: create document Purchase return order

As a procurement manager
I want to create a Purchase return order document
To track a product that needs to be returned to the vendor

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _022000 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		
	
	


Scenario: _022001 create document Purchase return order, store use Shipment confirmation based on Purchase invoice + check status
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	And I select "Wait" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "2,000" text in "Q" field of "ItemList" table
	And I input "40,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Check the addition of the store to the tabular partner
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'Store 02' | 'pcs' | '2,000' |
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder022001$$" variable
	And I delete "$$PurchaseReturnOrder022001$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022001$$"
	And I save the window as "$$PurchaseReturnOrder022001$$"
	And I click the button named "FormPostAndClose"
	And I close current window
	And I close current window
	* Check for no movements in the registers
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Order'                         | 'Item key' |
			| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | '$$PurchaseReturnOrder022001$$' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Purchase invoice'          | 'Item key' |
			| '-2,000'   | '$$PurchaseReturnOrder022001$$' | '1'           | '$$PurchaseInvoice018006$$' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
			| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
			| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |
		And I close all client application windows
	* Set Approved status
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturnOrder022001$$'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
	* Check history by status
		And I click "History" hyperlink
		And "List" table contains lines
			| 'Object'                        | 'Status'   |
			| '$$PurchaseReturnOrder022001$$' | 'Wait'     |
			| '$$PurchaseReturnOrder022001$$' | 'Approved' |
		And I close current window
		And I click the button named "FormPostAndClose"


Scenario: _022002 check movements of the document Purchase return order in the OrderBalance register (store does not use Shipment confirmation) 
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Order'                         | 'Item key' |
		| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | '$$PurchaseReturnOrder022001$$' | 'L/Green'  |

Scenario: _022003 check movements of the document Purchase return order in the OrderBalance register PurchaseTurnovers (store use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      | 'Line number' | 'Purchase invoice'          | 'Item key' |
		| '-2,000'   | '$$PurchaseReturnOrder022001$$' | '1'           | '$$PurchaseInvoice018006$$' | 'L/Green'  |

Scenario: _022004 check movements of the document Purchase return order in the OrderReservation register (store use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _022005 check movements of the document Purchase return order in the StockReservation register (store use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key' |
	| '2,000'    | '$$PurchaseReturnOrder022001$$' | '1'           | 'Store 02' | 'L/Green'  |


Scenario: _022006 create document Purchase return order, store does not use Shipment confirmation, based on Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Filling in the main details of the document
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Trousers'    | '36/Yellow'   | 'pcs' |
	And I select current line in "ItemList" table
	And Delay 2
	And I input "3,000" text in "Q" field of "ItemList" table
	And Delay 2
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'L/Green'   | 'pcs' |
	And Delay 2
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'M/White'   | 'pcs' |
	And I delete a line in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder022006$$" variable
	And I delete "$$PurchaseReturnOrder022006$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022006$$"
	And I save the window as "$$PurchaseReturnOrder022006$$"
	And I click the button named "FormPostAndClose"
	And I close current window

Scenario: _022007 check movements of the document Purchase return order in the OrderBalance (store does not use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Order'                         | 'Item key'  |
		| '3,000'    | '$$PurchaseReturnOrder022006$$' | '1'           | 'Store 01' | '$$PurchaseReturnOrder022006$$' | '36/Yellow' |

Scenario: _022008 check movements of the document Purchase return order in the PurchaseTurnovers (store does not use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Purchase invoice'          | 'Item key'  |
	| '-3,000'   | '$$PurchaseReturnOrder022006$$' | '1'           | '$$PurchaseInvoice018001$$' | '36/Yellow' |

Scenario: _022009 check movements of the document Purchase return order in the PurchaseTurnovers (store does not use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.OrderReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | '$$PurchaseReturnOrder022006$$' | '1'           | 'Store 01' | '36/Yellow' |

Scenario: _022010 check movements of the document Purchase return order in the StockReservation (store does not use Shipment confirmation)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
	| 'Quantity' | 'Recorder'                      | 'Line number' | 'Store'    | 'Item key'  |
	| '3,000'    | '$$PurchaseReturnOrder022006$$' | '1'           | 'Store 01' | '36/Yellow' |


Scenario: _022016 check totals in the document Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Select PurchaseReturnOrder
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
		And I select current line in "List" table
	* Check totals in the document Purchase return order
		And the editing text of form attribute named "ItemListTotalTaxAmount" became equal to "12,20"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "67,80"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "80,00"



Scenario: _022011 check the output of the document movement report for Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseReturnOrder022001$$'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'                    | ''                          | ''         | ''         | ''        | ''                             | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                       | 'Purchase invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | '-383,05'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'en description is empty'      | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'USD'                          | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                      | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                       | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                      | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                       | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                         | 'Item key'                  | 'Row key'  | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | '$$PurchaseReturnOrder022001$$' | 'L/Green'                   | '*'        | ''         | ''        | ''                             | ''                     |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturnOrder022001$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseReturnOrder022001$$'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'                    | ''                          | ''         | ''         | ''        | ''                             | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                       | 'Purchase invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | '-383,05'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'en description is empty'      | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'USD'                          | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                      | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                       | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                      | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                       | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                         | 'Item key'                  | 'Row key'  | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | '$$PurchaseReturnOrder022001$$' | 'L/Green'                   | '*'        | ''         | ''        | ''                             | ''                     |
	And I close all client application windows

Scenario: _02201101 clear movements Purchase Return Order and check that there is no movements on the registers 
	* Open list form Purchase Return Order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturnOrder022001$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Purchase turnovers"' |
			| 'Register  "Order reservation"'  |
			| 'Register  "Stock reservation"'  |
			| 'Register  "Order balance"'      |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseReturnOrder022001$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseReturnOrder022001$$'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Document registrations records' | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Purchase turnovers"' | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Period'      | 'Resources' | ''          | ''           | 'Dimensions'                    | ''                          | ''         | ''         | ''        | ''                             | 'Attributes'           |
		| ''                               | ''            | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'                       | 'Purchase invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                               | '*'           | '-2'        | '-451,98'   | '-383,05'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'en description is empty'      | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                               | '*'           | '-2'        | '-80'       | '-67,8'           | 'Main Company'                  | '$$PurchaseInvoice018006$$' | 'USD'      | 'L/Green'  | '*'       | 'USD'                          | 'No'                   |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order reservation"'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                      | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                       | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock reservation"'  | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Item key'                      | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Expense'     | '*'         | '2'         | 'Store 02'   | 'L/Green'                       | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order balance"'      | ''            | ''          | ''          | ''           | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Record type' | 'Period'    | 'Resources' | 'Dimensions' | ''                              | ''                          | ''         | ''         | ''        | ''                             | ''                     |
		| ''                               | ''            | ''          | 'Quantity'  | 'Store'      | 'Order'                         | 'Item key'                  | 'Row key'  | ''         | ''        | ''                             | ''                     |
		| ''                               | 'Receipt'     | '*'         | '2'         | 'Store 02'   | '$$PurchaseReturnOrder022001$$' | 'L/Green'                   | '*'        | ''         | ''        | ''                             | ''                     |
		And I close all client application windows



Scenario: _300508 check connection to PurchaseReturnOrder report "Related documents"
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberPurchaseReturnOrder022001$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows


