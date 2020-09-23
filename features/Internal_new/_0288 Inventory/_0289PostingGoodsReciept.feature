#language: en
@tree
@Positive
@Group7
Feature: create document Goods receipt

As a storekeeper
I want to create a Goods receipt
To take products to the store


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: preparation (Goods receipt)
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
				| "$$NumberPurchaseOrder017003" |
			When create PurchaseOrder017003
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018006" |
			When create PurchaseInvoice018006 based on PurchaseOrder017003
	* Check or create PurchaseInvoice018006
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018006" |
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
	And I click "Post" button
	And I save the value of "Number" field as "$$NumberGoodsReceipt028901$$"
	And I save the window as "$$GoodsReceipt028901$$"
	And I click "Post and close" button
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


