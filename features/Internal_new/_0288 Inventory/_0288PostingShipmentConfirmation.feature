#language: en
@tree
@Positive
@Inventory



Feature: create Shipment confirmation


As a storekeeper
I want to create a Shipment confirmation
For shipment of products from store


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _028800 preparation (Shipment confirmation)
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
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create information register CurrencyRates records
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023005$$" |
			When create SalesOrder023005
	* Check or create SalesInvoice024008 based on SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024008$$" |
			When create SalesInvoice024008
	* Check or create SalesInvoice024025
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024025$$" |
			When create SalesInvoice024025
	* Check or create PurchaseOrder017003
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017003$$" |
			When create PurchaseOrder017003
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018006$$" |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
	
	* Check or create PurchaseReturn022314
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseReturn022314$$" |
			When create PurchaseReturn022314
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			And I go to line in "List" table
					| 'Number'                          |
					| "$$NumberPurchaseReturn022314$$"|
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPostAndClose"
	* Check or create InventoryTransfer021030
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberInventoryTransfer021030$$" |	
			When create InventoryTransfer021030

Scenario: _028801 create document Shipment confirmation based on Sales Invoice (with Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                       | 'Partner'   |
		| '$$NumberSalesInvoice024008$$' | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check if the product is filled in
		And "ItemList" table contains lines
		| 'Item'     | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| 'Dress'    | '10,000'   | 'L/Green'  | 'pcs' | '$$SalesInvoice024008$$' |
		| 'Trousers' | '14,000'   | '36/Yellow'| 'pcs' | '$$SalesInvoice024008$$' |
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028801$$"
	And I save the window as "$$ShipmentConfirmation0028801$$"
	And I click the button named "FormPostAndClose"
	And I close current window
	

Scenario: _028802 check Shipment confirmation posting (based on Sales invoice with Sales order) by register GoodsInTransitOutgoing (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Shipment basis'    | 'Store'    | 'Item key' |
		| '10,000'   | '$$ShipmentConfirmation0028801$$' | '$$SalesInvoice024008$$' | 'Store 02' | 'L/Green'  |
		| '14,000'   | '$$ShipmentConfirmation0028801$$' | '$$SalesInvoice024008$$' | 'Store 02' | '36/Yellow'   |

Scenario: _028803 check Shipment confirmation posting (based on Sales invoice with Sales order) by register StockBalance (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Store'    | 'Item key' |
		| '10,000'   | '$$ShipmentConfirmation0028801$$' | 'Store 02' | 'L/Green'  |
		| '14,000'   | '$$ShipmentConfirmation0028801$$' | 'Store 02' | '36/Yellow'   |


Scenario: _028804 create document Shipment confirmation  based on Sales Invoice (without Sales order)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number' | 'Partner'    |
		| '$$NumberSalesInvoice024025$$'      | 'Kalipso' |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check if the product is filled in
		And "ItemList" table contains lines
		| '#' | 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'   |
		| '1' | 'Dress' | '20,000'   | 'L/Green'  | 'pcs'  | '$$SalesInvoice024025$$' |
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028804$$"
	And I save the window as "$$ShipmentConfirmation0028804$$"
	And I click the button named "FormPostAndClose"
	And I close current window

Scenario: _028805 check Shipment confirmation posting (based on Sales invoice without Sales order) by register GoodsInTransitOutgoing (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Shipment basis'         | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | '$$ShipmentConfirmation0028804$$' | '$$SalesInvoice024025$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028806 check Shipment confirmation posting (based on Sales invoice without Sales order) by register StockBalance (-)
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                        | 'Line number' | 'Store'    | 'Item key' |
		| '20,000'   | '$$ShipmentConfirmation0028804$$' | '1'           | 'Store 02' | 'L/Green'  |



Scenario: _028807 create document Shipment confirmation based on Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseReturn022314$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	Then the form attribute named "Company" became equal to "Main Company"
	Then the form attribute named "Store" became equal to "Store 02"
	And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Unit' | 'Shipment basis'                              |
		| 'Dress' | '10,000'    | 'L/Green'  | 'pcs'  | '$$PurchaseReturn022314$$' |
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028807$$"
	And I save the window as "$$ShipmentConfirmation0028807$$"
	And I click the button named "FormPostAndClose"
	And I close current window

Scenario: _028808 check Shipment confirmation posting (based on Purchase return) by register StockBalance
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'    | '$$ShipmentConfirmation0028807$$' | '1'           | 'Store 02' | 'L/Green'  |



Scenario: _028809 check Shipment confirmation posting (based on Purchase return) by register GoodsInTransitOutgoing
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitOutgoing"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                 | 'Shipment basis'     | 'Line number' | 'Store'    | 'Item key' |
		| '10,000'   | '$$ShipmentConfirmation0028807$$' | '$$PurchaseReturn022314$$' | '1'           | 'Store 02' | 'L/Green'  |

Scenario: _028810 create document Shipment confirmation  based on Inventory transfer
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I go to line in "List" table
		| 'Number'                           |
		| '$$NumberInventoryTransfer021030$$' |
	And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
	And Delay 1
	Then the form attribute named "Company" became equal to "Main Company"
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberShipmentConfirmation028810$$"
	And I save the window as "$$ShipmentConfirmation0028810$$"
	And I click the button named "FormPostAndClose"
	



Scenario: _028811 check the output of the document movement report for Shipment Confirmation
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberShipmentConfirmation028801$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$ShipmentConfirmation0028801$$'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | '$$SalesInvoice024008$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '$$SalesInvoice024008$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberShipmentConfirmation028801$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$ShipmentConfirmation0028801$$'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | '$$SalesInvoice024008$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '$$SalesInvoice024008$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
	And I close all client application windows


Scenario: _02881101 clear movements Shipment confirmation and check that there is no movements on the registers 
	* Open list form Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Check the report generation
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberShipmentConfirmation028801$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Goods in transit outgoing"'      |
			| 'Register  "Stock balance"'                  |
			| 'Register  "Shipment confirmation schedule"' |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberShipmentConfirmation028801$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$ShipmentConfirmation0028801$$'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Document registrations records'             | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | '$$SalesInvoice024008$$' | 'L/Green'   | '*'         | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '$$SalesInvoice024008$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Stock balance"'                  | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'         | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Store 02'     | 'L/Green'          | ''          | ''          | ''        | ''              |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Store 02'     | '36/Yellow'        | ''          | ''          | ''        | ''              |
		| ''                                           | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''             | ''                 | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'            | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | 'L/Green'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '14'        | 'Main Company' | '$$SalesInvoice024008$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		And I close all client application windows


Scenario: _300506 check connection to Shipment Confirmation report "Related documents"
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberShipmentConfirmation028801$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
