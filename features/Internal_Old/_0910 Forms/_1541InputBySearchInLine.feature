#language: en
@tree
@Positive

@InputBySearchInLine

Feature: input by search in line

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0154000 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
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
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog ChequeBonds objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog BankTerms objects
		When Create catalog SpecialOfferRules objects (Test)
		When Create catalog SpecialOfferTypes objects (Test)
		When Create catalog SpecialOffers objects (Test)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog Hardware objects  (Test)
		When Create catalog Workstations objects  (Test)
		When Create catalog ItemSegments objects
		When Create catalog PaymentTypes objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company



		
Scenario: _0154050 check item and item key input by search in line in a document Sales order (in english)
	And I close all client application windows
	* Open a creation form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

	

Scenario: _0154051 check item and item key input by search in line in a document Sales invoice (in english)
	And I close all client application windows
	* Open a creation form Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table	
		And in "ItemList" table drop-down list "Item" is equal to:
			|" (J22001) Jacket J22001 "|
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154052 check item and item key input by search in line in a document Sales return order (in english)
	And I close all client application windows
	* Open a creation form Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154053 check item and item key input by search in line in a document Sales return (in english)
	And I close all client application windows
	* Open a creation form Sales return 
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click the button named "Add"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001 |		
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154054 check item and item key input by search in line in a document Purchase invoice (in english)
	And I close all client application windows
	* Open a creation form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.Purchaseinvoice"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click the button named "Add"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click the button named "Add"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And in "ItemList" table drop-down list "Item" is equal to:
			|" (J22001) Jacket J22001 "|
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154055 check item and item key input by search in line in a document Purchase order (in english)
	And I close all client application windows
	* Open a creation form Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click the button named "Add"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154056 check item and item key input by search in line in a document Goods Receipt (in english)
	And I close all client application windows
	* Open a creation form Goods Receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154057 check item and item key input by search in line in a document Shipment confirmation (in english)
	And I close all client application windows
	* Open a creation form Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click the button named "Add"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154058 check item and item key input by search in line in a document InternalSupplyRequest (in english)
	And I close all client application windows
	* Open a creation form Internal Supply Request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154059 check item and item key input by search in line in a document InventoryTransferOrder (in english)
	And I close all client application windows
	* Open a creation form Inventory Transfer Order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154060 check item and item key input by search in line in a document InventoryTransfer (in english)
	And I close all client application windows
	* Open a creation form Inventory Transfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154061 check item and item key input by search in line in a document Bundling (in english)
	And I close all client application windows
	* Open a creation form Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154062 check item and item key input by search in line in a document UnBundling (in english)
	And I close all client application windows
	* Open a creation form UnBundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows


Scenario: _015406401 check item and item key input by search in line in a document StockAdjustmentAsSurplus (in english)
	And I close all client application windows
	* Open a creation form StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _015406402 check item and item key input by search in line in a document StockAdjustmentAsWriteOff (in english)
	And I close all client application windows
	* Open a creation form StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _015406403 check item and item key input by search in line in a document PhysicalInventory (in english)
	And I close all client application windows
	* Open a creation form PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _015406404 check item and item key input by search in line in a document PhysicalCountByLocation (in english)
	And I close all client application windows
	* Open a creation form PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _015406405 check item and item key input by search in line in a document ItemStockAdjustment (in english)
	And I close all client application windows
	* Open a creation form ItemStockAdjustment
		Given I open hyperlink "e1cib/list/Document.ItemStockAdjustment"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key (surplus)" field in "ItemList" table
		And I select "36" from "Item key (surplus)" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key (surplus)'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _0154065 check item, item key and properties input by search in line in a document Price list (in english)
	And I close all client application windows
	* Open a creation form Price List
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		And I change "Set price" radio button value to "By Item keys"
	* Item and item key input by search in line
		And I click the button named "ItemKeyListAdd"
		And I select "tr" from "Item" drop-down list by string in "ItemKeyList" table
		And I activate "Item key" field in "ItemKeyList" table
		And I select "36" from "Item key" drop-down list by string in "ItemKeyList" table
	* Check entered values
		And "ItemKeyList" table contains lines
		| 'Item'        | 'Item key'  |
		| 'Trousers'    | '36/Yellow' |


	

Scenario: _0154066 check partner, legal name, Partner term, company and store input by search in line in a document Sales order (in english)
	And I close all client application windows
	* Open a creation form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154066 check partner, legal name, company, currency input by search in line in a document Reconcilation statement (in english)
	And I close all client application windows
	* Open a creation form Reconciliation Statement
		Given I open hyperlink "e1cib/list/Document.ReconciliationStatement"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Currency input by search in line
		And I select from the drop-down list named "Currency" by "t" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
	And I close all client application windows

Scenario: _0154067 check partner, legal name, Partner term, company and store input by search in line in a document Sales invoice (in english)
	And I close all client application windows
	* Open a creation form Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154068 check partner, legal name, Partner term, company and store input by search in line in a document Sales return (in english)
	And I close all client application windows
	* Open a creation form Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154069 check partner, legal name, Partner term, company and store input by search in line in a document Sales return order (in english)
	And I close all client application windows
	* Open a creation form Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154070 check partner, legal name, Partner term, company and store input by search in line in a document Purchase order (in english)
	And I close all client application windows
	* Open a creation form Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154071 check partner, legal name, Partner term, company and store input by search in line in a document Purchase invoice (in english)
	And I close all client application windows
	* Open a creation form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154072 check partner, legal name, Partner term, company and store input by search in line in a document Purchase return (in english)
	And I close all client application windows
	* Open a creation form Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154073 check partner, legal name, Partner term, company and store input by search in line in a document Purchase return order (in english)
	And I close all client application windows
	* Open a creation form Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows

Scenario: _0154074 check partner, legal name, company, store input by search in line in a document Goods Receipt (in english)
	And I close all client application windows
	* Open a creation form Goods Receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
		And I select "Purchase" exact value from "Transaction type" drop-down list
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "02" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I close all client application windows

Scenario: _0154075 check partner, legal name, company, store input by search in line in a document Shipment confirmation (in english)
	And I close all client application windows
	* Open a creation form Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Sales" exact value from "Transaction type" drop-down list
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "02" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I close all client application windows

Scenario: _0154076 check company, store input by search in line in a document InternalSupplyRequest (in english)
	And I close all client application windows
	* Open a creation form InternalSupplyRequest
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	And I close all client application windows



Scenario: _0154077 check partner, legal name, company, store input by search in line in a document InventoryTransferOrder (in english)
	And I close all client application windows
	* Open a creation form InventoryTransferOrder
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "StoreSender" by "01" string
		And I select from the drop-down list named "StoreReceiver" by "02" string
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 01"
		Then the form attribute named "StoreReceiver" became equal to "Store 02"
	And I close all client application windows


Scenario: _0154078 check company, store input by search in line in a InventoryTransfer (in english)
	And I close all client application windows
	* Open a creation form InventoryTransfer
		Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "StoreSender" by "01" string
		And I select from the drop-down list named "StoreReceiver" by "02" string
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "StoreSender" became equal to "Store 01"
		Then the form attribute named "StoreReceiver" became equal to "Store 02"
	And I close all client application windows

Scenario: _0154079 check item and item key input by search in line in a document Retail sales receipt (in english)
	And I close all client application windows
	* Open a creation form Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I close all client application windows

Scenario: _0154080 check partner, legal name, Partner term, company and store input by search in line in a document Retail sales receipt (in english)
	And I close all client application windows
	* Open a creation form Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"



Scenario: _0154081 check company, store, item bundle input by search in line in a Bundling (in english)
	And I close all client application windows
	* Open a creation form Bundling
		Given I open hyperlink "e1cib/list/Document.Bundling"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Input by string Item bundle
		And I select from the drop-down list named "ItemBundle" by "Trousers" string
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "ItemBundle" became equal to "Trousers"
	And I close all client application windows

Scenario: _0154082 check company, store, item box input by search in line in a UnBundling (in english)
	And I close all client application windows
	* Open a creation form Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Item bundle input by search in line
		And I select from "Item bundle" drop-down list by "Trousers" string
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "ItemBundle" became equal to "Trousers"
	And I close all client application windows

Scenario: _0154083 check company, Cash accounts, transaction type, currency, partner, payee, Partner term input by search in line in a Cash payment (in english)
	And I close all client application windows
	* Open a creation form Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Cash accounts input by search in line
		And I select from "Cash account" drop-down list by "3" string
	* Transaction type input by search in line
		And I select from "Transaction type" drop-down list by "vendor" string
	* Currency input by search in line
		And I select from the drop-down list named "Currency" by "T" string
	* Partner input by search in line
		And in the table "PaymentList" I click "Add" button
		And I select "fer" from "Partner" drop-down list by string in "PaymentList" table
	* Payee input by search in line
		And I activate "Payee" field in "PaymentList" table
		And I select "co" from "Payee" drop-down list by string in "PaymentList" table
	* Partner term input by search in line
		And I activate "Partner term" field in "PaymentList" table
		And I select "tr" from "Partner term" drop-down list by string in "PaymentList" table
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
		| 'Partner'   | 'Payee'             | 'Partner term'             |
		| 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' |
	And I close all client application windows


Scenario: _0154084 check company, Cash/Bank accounts, transaction type, currency, partner, payee, Partner term input by search in line in a Bank payment (in english)
	And I close all client application windows
	* Open a creation form Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Cash/Bank accounts input by search in line
		And I select from "Account" drop-down list by "usd" string
	* Transaction type input by search in line
		And I select from "Transaction type" drop-down list by "vendor" string
	* Currency input by search in line
		And I select from the drop-down list named "Currency" by "dol" string
	* Partner input by search in line
		And in the table "PaymentList" I click "Add" button
		And I select "fer" from "Partner" drop-down list by string in "PaymentList" table
	* Payee input by search in line
		And I activate "Payee" field in "PaymentList" table
		And I select "co" from "Payee" drop-down list by string in "PaymentList" table
	* Partner term input by search in line
		And I activate "Partner term" field in "PaymentList" table
		And I select "tr" from "Partner term" drop-down list by string in "PaymentList" table
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, USD"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table contains lines
		| 'Partner'   | 'Payee'             | 'Partner term'             |
		| 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' |
	And I close all client application windows

Scenario: _0154085 check company, Cash/Bank accounts, transaction type, currency, partner, payee, input by search in line in a Bank receipt (in english)
	And I close all client application windows
	* Open a creation form Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Cash/Bank accounts input by search in line
		And I select from "Account" drop-down list by "usd" string
	* Transaction type input by search in line
		And I select from "Transaction type" drop-down list by "customer" string
	* Currency input by search in line
		And I select from the drop-down list named "Currency" by "dol" string
	* Partner input by search in line
		And in the table "PaymentList" I click "Add" button
		And I select "fer" from "Partner" drop-down list by string in "PaymentList" table
	* Payee input by search in line
		And I activate "Payer" field in "PaymentList" table
		And I select "co" from "Payer" drop-down list by string in "PaymentList" table
	* Partner term input by search in line
		And I activate "Partner term" field in "PaymentList" table
		And I select "usd" from "Partner term" drop-down list by string in "PaymentList" table
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, USD"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table contains lines
		| 'Partner'   | 'Payer'              | 'Partner term' |
		| 'Ferron BP' | 'Company Ferron BP' | 'Ferron, USD' |
	And I close all client application windows

Scenario: _0154086 check company, Cash accounts, transaction type, currency, partner, payee, input by search in line in a Cash receipt (in english)
	And I close all client application windows
	* Open a creation form Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Cash/Bank accounts input by search in line
		And I select from "Cash account" drop-down list by "3" string
	* Transaction type input by search in line
		And I select from "Transaction type" drop-down list by "customer" string
	* Currency input by search in line
		And I select from the drop-down list named "Currency" by "dol" string
	* Partner input by search in line
		And in the table "PaymentList" I click "Add" button
		And I select "fer" from "Partner" drop-down list by string in "PaymentList" table
	* Payee input by search in line
		And I activate "Payer" field in "PaymentList" table
		And I select "co" from "Payer" drop-down list by string in "PaymentList" table
	* Partner term input by search in line
		And I activate "Partner term" field in "PaymentList" table
		And I select "usd" from "Partner term" drop-down list by string in "PaymentList" table
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table contains lines
		| 'Partner'   | 'Payer'              | 'Partner term' |
		| 'Ferron BP' | 'Company Ferron BP' | 'Ferron, USD' |
	And I close all client application windows




Scenario: _0154087 check company, sender, receiver, send currency, receive currency, cash advance holder input by search in line in a Cash Transfer Order (in english)
	And I close all client application windows
	* Open a creation form Cash Transfer Order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Sender input by search in line
		And I select from "Sender" drop-down list by "3" string
	* Input by string Receiver
		And I select from "Receiver" drop-down list by "1" string
	* Currency input by search in line
		And I select from "Send currency" drop-down list by "dol" string
		And I select from "Receive currency" drop-down list by "EUR" string
	* Cash advance holder input by search in line
		And I select from "Cash advance holder" drop-down list by "ari" string
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №3"
		Then the form attribute named "SendCurrency" became equal to "USD"
		Then the form attribute named "CashAdvanceHolder" became equal to "Arina Brown"
		Then the form attribute named "Receiver" became equal to "Cash desk №1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And I close all client application windows

Scenario: _0154088 check company, operation type, partner, legal name, Partner term, business unit, expence type input by search in line in a CreditNote (in english)
	And I close all client application windows
	* Open a creation form CreditNote
		Given I open hyperlink "e1cib/list/Document.CreditNote"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Filling the tabular part by searching the value by line
		And in the table "Transactions" I click "Add" button
		And I activate "Partner" field in "Transactions" table
		And I select "fer" from "Partner" drop-down list by string in "Transactions" table
		And I select "Company Ferr" from "Legal name" drop-down list by string in "Transactions" table
		And I activate "Partner term" field in "Transactions" table
		And I select "without" from "Partner term" drop-down list by string in "Transactions" table
		And I select "lir" from "Currency" drop-down list by string in "Transactions" table
		And I activate "Business unit" field in "Transactions" table
		And I select current line in "Transactions" table
		And I select "lo" from "Business unit" drop-down list by string in "Transactions" table
		And I activate "Expense type" field in "Transactions" table
		And I select "fu" from "Expense type" drop-down list by string in "Transactions" table
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		// Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And "Transactions" table contains lines
		| 'Legal name'          | 'Partner'   | 'Partner term'                     | 'Business unit'        | 'Currency' | 'Expense type' |
		| 'Company Ferron BP'   | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Logistics department' | 'TRY'      | 'Fuel'         |
		And I close all client application windows


Scenario: _0154100 check company, operation type, partner, legal name, Partner term, business unit, expence type input by search in line in a DebitNote (in english)
	And I close all client application windows
	* Open a creation form DebitNote
		Given I open hyperlink "e1cib/list/Document.DebitNote"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Filling the tabular part by searching the value by line
		And in the table "Transactions" I click "Add" button
		And I activate "Partner" field in "Transactions" table
		And I select "fer" from "Partner" drop-down list by string in "Transactions" table
		And I select "Company Ferr" from "Legal name" drop-down list by string in "Transactions" table
		And I activate "Partner term" field in "Transactions" table
		And I select "without" from "Partner term" drop-down list by string in "Transactions" table
		And I select "lir" from "Currency" drop-down list by string in "Transactions" table
		And I activate "Business unit" field in "Transactions" table
		And I select current line in "Transactions" table
		And I select "lo" from "Business unit" drop-down list by string in "Transactions" table
		And I activate "Revenue type" field in "Transactions" table
		And I select "fu" from "Revenue type" drop-down list by string in "Transactions" table
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		// Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And "Transactions" table contains lines
		| 'Legal name'          | 'Partner'   | 'Partner term'                     | 'Business unit'        | 'Currency' | 'Revenue type' |
		| 'Company Ferron BP'   | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Logistics department' | 'TRY'      | 'Fuel'         |
		And I close all client application windows



Scenario: _0154089 check company, account, currency input by search in line in Incoming payment order (in english)
	And I close all client application windows
	* Open a creation form IncomingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Input by string Account
		And I select from "Account" drop-down list by "2" string
	* Currency input by search in line
		And I select from "Currency" drop-down list by "dol" string
	* Filling the tabular part by searching the value by line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "fer" from "Partner" drop-down list by string in "PaymentList" table
		And I activate "Payer" field in "PaymentList" table
		And I select "Second Company F" from "Payer" drop-down list by string in "PaymentList" table
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Cash desk №2"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table contains lines
		| 'Partner'   | 'Payer'                    |
		| 'Ferron BP' | 'Second Company Ferron BP' |
		And I close all client application windows

Scenario: _0154090 check company, account, currency input by search in line in Outgoing payment order (in english)
	And I close all client application windows
	* Open a creation form OutgoingPaymentOrder
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Input by string Account
		And I select from "Account" drop-down list by "2" string
	* Currency input by search in line
		And I select from "Currency" drop-down list by "dol" string
	* Filling the tabular part by searching the value by line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select "fer" from "Partner" drop-down list by string in "PaymentList" table
		And I activate "Payee" field in "PaymentList" table
		And I select "Second Company F" from "Payee" drop-down list by string in "PaymentList" table
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Cash desk №2"
		Then the form attribute named "Currency" became equal to "USD"
		And "PaymentList" table contains lines
		| 'Partner'   | 'Payee'                    |
		| 'Ferron BP' | 'Second Company Ferron BP' |
		And I close all client application windows


Scenario: _0154091 check company, account, currency input by search in line in ChequeBondTransaction (in english)
	And I close all client application windows
	* Open a creation form ChequeBondTransaction
		Given I open hyperlink "e1cib/list/Document.ChequeBondTransaction"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Currency input by search in line
		And I select from "Currency" drop-down list by "lir" string
	* Filling the tabular part by searching the value by line (partner and legal name)
		And in the table "ChequeBonds" I click the button named "ChequeBondsAdd"
		And I activate "Partner" field in "ChequeBonds" table
		And I select "fer" from "Partner" drop-down list by string in "ChequeBonds" table
		And I select "se" from "Legal name" drop-down list by string in "ChequeBonds" table
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		And "ChequeBonds" table contains lines
		| 'Legal name'               | 'Partner'   |
		| 'Second Company Ferron BP' | 'Ferron BP' |
		And I close all client application windows


Scenario: _0154092 check store, responsible person input by search in line in PhysicalCountByLocation (in english)
	And I close all client application windows
	* Open a creation form PhysicalCountByLocation
		Given I open hyperlink "e1cib/list/Document.PhysicalCountByLocation"
		And I click the button named "FormCreate"
	* Store input by search in line
		And I select from "Store" drop-down list by "02" string
	* Responsible person input by search in line
		And I select from "Responsible person" drop-down list by "Anna" string
	* Check filling in
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "ResponsiblePerson" became equal to "Anna Petrova"
		And I close all client application windows


Scenario: _0154093 check store input by search in line in PhysicalInventory (in english)
	And I close all client application windows
	* Open a creation form PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Store input by search in line
		And I select from "Store" drop-down list by "02" string
	* Check filling in
		Then the form attribute named "Store" became equal to "Store 02"
		And I close all client application windows


Scenario: _0154094 check store, company, tabular part input by search in line in StockAdjustmentAsWriteOff (in english)
	And I close all client application windows
	* Open a creation form StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click the button named "FormCreate"
	* Store input by search in line
		And I select from "Store" drop-down list by "02" string
	* Company input by search in line
		And I select from "Company" drop-down list by "Main" string
	* Check filling in
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Company" became equal to "Main Company"
	* Business unit, expence type input by search in line
		And I click the button named "Add"
		And I activate "Business unit" field in "ItemList" table
		And I select "log" from "Business unit" drop-down list by string in "ItemList" table
		And I move to the next attribute
		And I activate "Expense type" field in "ItemList" table
		And I select "fu" from "Expense type" drop-down list by string in "ItemList" table
	* Check filling in
		And "ItemList" table contains lines
		| 'Business unit'        | 'Expense type' |
		| 'Logistics department' | 'Fuel'         |
		And I close all client application windows


Scenario: _0154095 check store, company, tabular part input by search in line in StockAdjustmentAsSurplus (in english)
	And I close all client application windows
	* Open a creation form StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click the button named "FormCreate"
	* Store input by search in line
		And I select from "Store" drop-down list by "02" string
	* Company input by search in line
		And I select from "Company" drop-down list by "Main" string
	* Check filling in
		Then the form attribute named "Store" became equal to "Store 02"
		Then the form attribute named "Company" became equal to "Main Company"
	* Business unit, expence type input by search in line
		And I click the button named "Add"
		And I activate "Business unit" field in "ItemList" table
		And I select "log" from "Business unit" drop-down list by string in "ItemList" table
		And I move to the next attribute
		And I activate "Revenue type" field in "ItemList" table
		And I select "fu" from "Revenue type" drop-down list by string in "ItemList" table
	* Check filling in
		And "ItemList" table contains lines
		| 'Business unit'        | 'Revenue type' |
		| 'Logistics department' | 'Fuel'         |
		And I close all client application windows


Scenario: _0154096 check company, account, currency input by search in line in Opening Entry (in english)
	And I close all client application windows
	* Open a creation form OpeningEntry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Filling the tabular part by searching the value by line Inventory
		And I move to "Inventory" tab
		And in the table "Inventory" I click the button named "InventoryAdd"
		And I select "dress" from "Item" drop-down list by string in "Inventory" table
		And I activate "Item key" field in "Inventory" table
		And I select "L" from "Item key" drop-down list by string in "Inventory" table
		And I activate "Store" field in "Inventory" table
		And I select "01" from "Store" drop-down list by string in "Inventory" table
		And I activate "Quantity" field in "Inventory" table
		And I input "2,000" text in "Quantity" field of "Inventory" table
	* Filling the tabular part by searching the value by line Account balance
		And I move to "Account balance" tab
		And in the table "AccountBalance" I click the button named "AccountBalanceAdd"
		And I select "№1" from "Account" drop-down list by string in "AccountBalance" table
		And I select "t" from "Currency" drop-down list by string in "AccountBalance" table
	* Filling the tabular part by searching the value by line Advance
		And I move to "Advance" tab
		And in the table "AdvanceFromCustomers" I click the button named "AdvanceFromCustomersAdd"
		And I select "fer" from "Partner" drop-down list by string in "AdvanceFromCustomers" table
		And I move to the next attribute
		And I activate field named "AdvanceFromCustomersLegalName" in "AdvanceFromCustomers" table
		And I select "se" from "Legal name" drop-down list by string in "AdvanceFromCustomers" table
		And I select "t" from "Currency" drop-down list by string in "AccountBalance" table
		And I move to "To suppliers" tab
		And in the table "AdvanceToSuppliers" I click the button named "AdvanceToSuppliersAdd"
		And I select "fer" from "Partner" drop-down list by string in "AdvanceToSuppliers" table
		And I move to the next attribute
		And I activate field named "AdvanceFromCustomersLegalName" in "AdvanceFromCustomers" table
		And I select "se" from "Legal name" drop-down list by string in "AdvanceToSuppliers" table
		And I select "t" from "Currency" drop-down list by string in "AdvanceToSuppliers" table
	* Filling the tabular part by searching the value by line Account payable
		* By Partner terms
			And I move to "Account payable" tab
			And in the table "AccountPayableByAgreements" I click the button named "AccountPayableByAgreementsAdd"
			And I select "fer" by string from the drop-down list named "AccountPayableByAgreementsPartner" in "AccountPayableByAgreements" table
			And I move to the next attribute
			And I select "sec" by string from the drop-down list named "AccountPayableByAgreementsLegalName" in "AccountPayableByAgreements" table
			And I select "usd" by string from the drop-down list named "AccountPayableByAgreementsAgreement" in "AccountPayableByAgreements" table
			And I select "t" by string from the drop-down list named "AccountPayableByAgreementsCurrency" in "AccountPayableByAgreements" table
		* By documents
			And I move to the tab named "GroupAccountPayableByDocuments"
			And in the table "AccountPayableByDocuments" I click the button named "AccountPayableByDocumentsAdd"
			And I select "fer" by string from the drop-down list named "AccountPayableByDocumentsPartner" in "AccountPayableByDocuments" table
			And I move to the next attribute
			And I select "s" by string from the drop-down list named "AccountPayableByDocumentsLegalName" in "AccountPayableByDocuments" table
			And I activate field named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
			And I select "ve" by string from the drop-down list named "AccountPayableByDocumentsAgreement" in "AccountPayableByDocuments" table
			And I select "t" by string from the drop-down list named "AccountPayableByDocumentsCurrency" in "AccountPayableByDocuments" table
			And I finish line editing in "AccountPayableByDocuments" table
	* Filling the tabular part by searching the value by line Account receivable
		* By Partner terms
			And I move to "Account receivable" tab
			And in the table "AccountReceivableByAgreements" I click the button named "AccountReceivableByAgreementsAdd"
			And I select "DF" by string from the drop-down list named "AccountReceivableByAgreementsPartner" in "AccountReceivableByAgreements" table
			And I move to the next attribute
			And I select "DF" by string from the drop-down list named "AccountReceivableByAgreementsLegalName" in "AccountReceivableByAgreements" table
			And I select "t" by string from the drop-down list named "AccountReceivableByAgreementsCurrency" in "AccountReceivableByAgreements" table
		* By documents
			And I move to the tab named "GroupAccountReceivableByDocuments"
			And in the table "AccountReceivableByDocuments" I click the button named "AccountReceivableByDocumentsAdd"
			And I select "DF" by string from the drop-down list named "AccountReceivableByDocumentsPartner" in "AccountReceivableByDocuments" table
			And I move to the next attribute
			And I select "DF" by string from the drop-down list named "AccountReceivableByDocumentsLegalName" in "AccountReceivableByDocuments" table
			And I select "t" by string from the drop-down list named "AccountReceivableByDocumentsCurrency" in "AccountReceivableByDocuments" table
			And I finish line editing in "AccountReceivableByDocuments" table
	* Filling check
		And Delay 2
		And "Inventory" table contains lines
		| 'Item'  | 'Quantity' | 'Item key' | 'Store'    |
		| 'Dress' | '2,000'    | 'L/Green' | 'Store 01' |
		And "AccountBalance" table contains lines
			| 'Account'      | 'Currency' |
			| 'Cash desk №1' | 'TRY'      |
		And "AdvanceFromCustomers" table contains lines
			| 'Partner'   | 'Legal name'               |
			| 'Ferron BP' | 'Second Company Ferron BP' |
		And "AdvanceToSuppliers" table contains lines
			| 'Partner'   | 'Legal name'               |
			| 'Ferron BP' | 'Second Company Ferron BP' |
		And "AccountPayableByAgreements" table contains lines
			| 'Partner'   | 'Partner term'          | 'Legal name'               | 'Currency' |
			| 'Ferron BP' | 'Vendor Ferron, USD' | 'Second Company Ferron BP' | 'TRY'      |
		And "AccountPayableByDocuments" table contains lines
			| 'Partner'   | 'Partner term'          | 'Legal name'               | 'Currency' |
			| 'Ferron BP' | 'Vendor Ferron, TRY' | 'Second Company Ferron BP' | 'TRY'      |
		And "AccountReceivableByAgreements" table contains lines
			| 'Partner' | 'Legal name' | 'Currency' |
			| 'DFC'     | 'DFC'        | 'TRY'      |
		And "AccountReceivableByDocuments" table contains lines
			| 'Partner' | 'Legal name' | 'Currency' |
			| 'DFC'     | 'DFC'        | 'TRY'      |
	And I close all client application windows

Scenario: _0154097 check company and account (in english) input by search in line in Cash revenue
	And I close all client application windows
	* Open a creation form Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Company input by search in line and account
		And I select from "Company" drop-down list by "main" string
		And I select from "Account" drop-down list by "TRY" string
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
	And I close all client application windows



Scenario: _0154098 check company and account (in english) input by search in line in CashExpense
	And I close all client application windows
	* Open a creation form CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Company input by search in line and account
		And I select from "Company" drop-down list by "main" string
		And I select from "Account" drop-down list by "TRY" string
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
	And I close all client application windows

Scenario: _0154099 check partner and legal name (in english) input by search in line in Invoice Match
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.InvoiceMatch"
		And I click the button named "FormCreate"
	* Check the filter when typing by Partner/Legal name
		And in the table "Transactions" I click the button named "TransactionsAdd"
		And I select "MIO" by string from the drop-down list named "TransactionsPartner" in "Transactions" table
		And I select "Company Kalipso" by string from the drop-down list named "TransactionsLegalName" in "Transactions" table
	* Check that there is only one legal name available for selection
		And I click choice button of the attribute named "TransactionsLegalName" in "Transactions" table
		And "List" table became equal
		| 'Description' |
		| 'Company Kalipso'         |
		And I close all client application windows

Scenario: _01540105 check item and item key input by search in line in a document Retail return receipt (in english)
	And I close all client application windows
	* Open a creation form Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And I click "Add" button
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And I close all client application windows

Scenario: _01540106 check partner, legal name, Partner term, company and store input by search in line in a document Retail return receipt (in english)
	And I close all client application windows
	* Open a creation form Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"

Scenario: _01540107 company, store input by search in line in a document Planned receipt reservation (in english)
	And I close all client application windows
	* Open a creation form Planned receipt reservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string		
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
		And I close all client application windows

Scenario: _01540108 check item and item key input by search in line in a document Planned receipt reservation (in english)
	And I close all client application windows
	* Open a creation form Planned receipt reservation
		Given I open hyperlink "e1cib/list/Document.PlannedReceiptReservation"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
		And I select "01" from "Store (requester)" drop-down list by string in "ItemList" table			
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store (requester)'| 'Unit'|
		| 'Boots'    | '36/18SD'   | 'Store 01'         | 'pcs' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table	
		And in "ItemList" table drop-down list "Item" is equal to:
			|" (J22001) Jacket J22001 "|
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _01540109 check partner, legal name, Partner term, company and store input by search in line in a document Sales order closing (in english)
	And I close all client application windows
	* Open a creation form Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"


Scenario: _01540110 check item and item key input by search in line in a document Sales order closing (in english)
	And I close all client application windows
	* Open a creation form Sales order closing
		Given I open hyperlink "e1cib/list/Document.SalesOrderClosing"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  |
		| 'Boots'    | '36/18SD' |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001 |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'     |
		| 'Jacket J22001'    |
		And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session