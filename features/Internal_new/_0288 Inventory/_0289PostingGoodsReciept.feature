#language: en
@tree
@Positive
@Inventory

Feature: create document Goods receipt

As a storekeeper
I want to create a Goods receipt
To take products to the store


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _028900 preparation (Goods receipt)
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
	* Check or create PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
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
	

Scenario: _028901 create document Goods Reciept based on Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Check that information is filled in when creating based on
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	// * Change of document number - 106
	// 	And I input "1" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "106" text in "Number" field
	* Check the filling in the tabular part of the  items
		And "ItemList" table contains lines
		| '#' | 'Item'     | 'Receipt basis'     | 'Item key' | 'Unit' | 'Quantity'       |
		| '1' | 'Dress'    | '$$PurchaseInvoice018006$$' | 'L/Green'  | 'pcs' | '500,000' |
		And "ItemList" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Store'    | 'Unit' |
		| 'Dress' | '500,000'  | 'L/Green'  | 'Store 02' | 'pcs' |
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberGoodsReceipt028901$$"
	And I save the window as "$$GoodsReceipt028901$$"
	And I click the button named "FormPostAndClose"
	And I close current window
	

Scenario: _028902 check  Goods Reciept posting by register GoodsInTransitIncoming (-)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.GoodsInTransitIncoming"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'          | 'Receipt basis'         | 'Line number' | 'Store'    | 'Item key'  |
		| '500,000'  | '$$GoodsReceipt028901$$'  | '$$PurchaseInvoice018006$$'   | '1'           | 'Store 02' | 'L/Green'   |

Scenario: _028903 check  Goods Reciept posting by register StockBalance (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockBalance"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'             | 'Line number'  | 'Store'    | 'Item key' |
		| '500,000'  | '$$GoodsReceipt028901$$'   | '1'            | 'Store 02' | 'L/Green'  |

Scenario: _028904 check  Goods Reciept posting by register StockReservation (+)
	
	Given I open hyperlink "e1cib/list/AccumulationRegister.StockReservation"
	And "List" table contains lines
		| 'Quantity' | 'Recorder'                          | 'Line number' | 'Store'    | 'Item key' |
		| '500,000'  | '$$GoodsReceipt028901$$'                 | '1'           | 'Store 02'    | 'L/Green'  |





Scenario: _028905 check the output of the document movement report for Goods Receipt
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Check the report output for the selected document from the list
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt028901$$'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | '$$PurchaseInvoice018006$$' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | '$$PurchaseInvoice018006$$' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |


	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Check the report output from the selected document
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
		And I select current line in "List" table
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
	* Check the report generation
		And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt028901$$'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | '$$PurchaseInvoice018006$$' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | '$$PurchaseInvoice018006$$' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |


	And I close all client application windows


Scenario: _02890501 clear movements Goods receipt and check that there is no movements on the registers 
	* Open list form Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Check the report generation
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberGoodsReceipt028901$$'      |
	* Clear movements document and check that there is no movement on the registers
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "Goods in transit incoming"' |
			| 'Register  "Stock reservation"'         |
			| 'Register  "Goods receipt schedule"'    |
			| 'Register  "Stock balance"'             |
		And I close all client application windows
	* Posting the document and check movements
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt028901$$'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I click the button named "FormReportDocumentRegistrationsReportRegistrationsReport"
		And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt028901$$'                    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Document registrations records'        | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Receipt basis'       | 'Item key' | 'Row key'  | ''        | ''              |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Store 02'     | '$$PurchaseInvoice018006$$' | 'L/Green'  | '*'        | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock reservation"'         | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Goods receipt schedule"'    | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | 'Attributes'    |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'               | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' |
		| ''                                      | 'Expense'     | '*'      | '500'       | 'Main Company' | '$$PurchaseInvoice018006$$' | 'Store 02' | 'L/Green'  | '*'       | '*'             |
		| ''                                      | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                    | ''         | ''         | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'            | ''         | ''         | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '500'       | 'Store 02'     | 'L/Green'             | ''         | ''         | ''        | ''              |
		And I close all client application windows


Scenario: _300507 check connection to GoodsReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberGoodsReceipt028901$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows