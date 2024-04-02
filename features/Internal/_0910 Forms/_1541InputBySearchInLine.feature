#language: en
@tree
@Positive

@InputBySearchInLine

Feature: input by search in line

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0154000 preparation
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use salary
	When set True value to the constant Use fixed assets
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog Partners objects (trade agent and consignor)
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
		When Create catalog CancelReturnReasons objects
		When Create catalog Projects objects
	* Data for salary
		When Create catalog EmployeePositions objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register Taxes records (VAT)
		When Create catalog EmployeeSchedule objects



Scenario: _01540001 check preparation
	When check preparation

		
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table	
		And in "ItemList" table drop-down list "Item" is equal to:
			| " (J22001) Jacket J22001 "    |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _0154053 check item and item key input by search in line in a document Sales return (in english)
	And I close all client application windows
	* Open a creation form Sales return 
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _0154054 check item and item key input by search in line in a document Purchase invoice (in english)
	And I close all client application windows
	* Open a creation form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.Purchaseinvoice"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And in "ItemList" table drop-down list "Item" is equal to:
			| " (J22001) Jacket J22001 "    |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _0154055 check item and item key input by search in line in a document Purchase order (in english)
	And I close all client application windows
	* Open a creation form Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _0154057 check item and item key input by search in line in a document Shipment confirmation (in english)
	And I close all client application windows
	* Open a creation form Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows
		And Delay 10

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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| '(J22001) Jacket J22001'   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _015406405 check item and item key input by search in line in a document ItemStockAdjustment (in english)
	And I close all client application windows
	And Delay 10
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
		| 'Item'   | 'Item key (surplus)'   |
		| 'Boots'  | '36/18SD'              |
		And in the table "ItemList" I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _015406406 check item and item key input by search in line in a document SalesReportFromTradeAgent (in english)
	And I close all client application windows
	* Open a creation form SalesReportFromTradeAgent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table	
		And in "ItemList" table drop-down list "Item" is equal to:
			| " (J22001) Jacket J22001 "    |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows

Scenario: _015406407 check item and item key input by search in line in a document SalesReportToConsignor (in english)
	And I close all client application windows
	* Open a creation form SalesReportToConsignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table	
		And in "ItemList" table drop-down list "Item" is equal to:
			| " (J22001) Jacket J22001 "    |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
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
		| 'Item'      | 'Item key'    |
		| 'Trousers'  | '36/Yellow'   |


	

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
		And I select from the drop-down list named "Store" by "re 01" string			
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	* Expense type input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service'        |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I select "exp" from "Expense type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Expense type'    |
			| 'Expense'         |
		And I select "sof" from "Expense type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Expense type'    |
			| 'Software'        |
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
		And I select from the drop-down list named "Store" by "re 01" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 01"
	* Expense type input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service'        |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I select "exp" from "Expense type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Expense type'    |
			| 'Expense'         |
		And I select "sof" from "Expense type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Expense type'    |
			| 'Software'        |
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "03" string
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
		And I select from the drop-down list named "Store" by "03" string
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "StoreSender" by "02" string
		And I select from the drop-down list named "StoreReceiver" by "03" string
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
		And I select from the drop-down list named "StoreSender" by "02" string
		And I select from the drop-down list named "StoreReceiver" by "03" string
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		| 'Partner'    | 'Payee'              | 'Partner term'               |
		| 'Ferron BP'  | 'Company Ferron BP'  | 'Basic Partner terms, TRY'   |
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
		| 'Partner'    | 'Payee'              | 'Partner term'               |
		| 'Ferron BP'  | 'Company Ferron BP'  | 'Basic Partner terms, TRY'   |
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
		| 'Partner'    | 'Payer'              | 'Partner term'   |
		| 'Ferron BP'  | 'Company Ferron BP'  | 'Ferron, USD'    |
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
		| 'Partner'    | 'Payer'              | 'Partner term'   |
		| 'Ferron BP'  | 'Company Ferron BP'  | 'Ferron, USD'    |
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

Scenario: _0154088 check company, operation type, partner, legal name, Partner term, profit loss center, expence type input by search in line in a CreditNote (in english)
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
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I select "lo" from "Profit loss center" drop-down list by string in "Transactions" table
		And I activate "Expense type" field in "Transactions" table
		And I select "fu" from "Expense type" drop-down list by string in "Transactions" table
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		// Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And "Transactions" table contains lines
		| 'Legal name'         | 'Partner'    | 'Partner term'                      | 'Profit loss center'    | 'Currency'  | 'Expense type'   |
		| 'Company Ferron BP'  | 'Ferron BP'  | 'Basic Partner terms, without VAT'  | 'Logistics department'  | 'TRY'       | 'Fuel'           |
		And I close all client application windows


Scenario: _0154089 check company, sender, receiver, send currency, receive currency, cash advance holder input by search in line in a Money transfer (in english)
	And I close all client application windows
	* Open a creation form Money transfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
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
	* Check entered values
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №3"
		Then the form attribute named "SendCurrency" became equal to "USD"
		Then the form attribute named "Receiver" became equal to "Cash desk №1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And I close all client application windows

Scenario: _0154090 check partner, legal name, Partner term and company input by search in line in a document SalesReportFromTradeAgent (in english)
	And I close all client application windows
	* Open a creation form SalesReportFromTradeAgent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "Trade agent 1" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "Trade agent 1" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "1" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Trade agent 1"
		Then the form attribute named "LegalName" became equal to "Trade agent 1"
		Then the form attribute named "Agreement" became equal to "Trade agent partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
	* Revenue type input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I select "rev" from "Revenue type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Revenue type'    |
			| 'Revenue'         |
		And I select "sof" from "Revenue type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Revenue type'    |
			| 'Software'        |
	And I close all client application windows


Scenario: _0154091 check partner, legal name, Partner term and company input by search in line in a document SalesReportToConsignor (in english)
	And I close all client application windows
	* Open a creation form SalesReportToConsignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "Consignor 1" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "Consignor 1" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "Consignor partner term 1" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Consignor 1"
		Then the form attribute named "LegalName" became equal to "Consignor 1"
		Then the form attribute named "Agreement" became equal to "Consignor partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _0154092 check partner, legal name, Partner term and company input by search in line in a document SalesReportFromTradeAgent (in english)
	And I close all client application windows
	* Open a creation form SalesReportFromTradeAgent
		Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "Trade agent 1" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "Trade agent 1" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "Trade agent partner term 1" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Trade agent 1"
		Then the form attribute named "LegalName" became equal to "Trade agent 1"
		Then the form attribute named "Agreement" became equal to "Trade agent partner term 1"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _0154100 check company, operation type, partner, legal name, Partner term, profit loss center, expence type input by search in line in a DebitNote (in english)
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
		And I activate "Profit loss center" field in "Transactions" table
		And I select current line in "Transactions" table
		And I select "lo" from "Profit loss center" drop-down list by string in "Transactions" table
		And I activate "Revenue type" field in "Transactions" table
		And I select "fu" from "Revenue type" drop-down list by string in "Transactions" table
	* Filling check
		Then the form attribute named "Company" became equal to "Main Company"
		// Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And "Transactions" table contains lines
		| 'Legal name'         | 'Partner'    | 'Partner term'                      | 'Profit loss center'    | 'Currency'  | 'Revenue type'   |
		| 'Company Ferron BP'  | 'Ferron BP'  | 'Basic Partner terms, without VAT'  | 'Logistics department'  | 'TRY'       | 'Fuel'           |
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
		| 'Partner'    | 'Payer'                      |
		| 'Ferron BP'  | 'Second Company Ferron BP'   |
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
		| 'Partner'    | 'Payee'                      |
		| 'Ferron BP'  | 'Second Company Ferron BP'   |
		And I close all client application windows







Scenario: _0154093 check store input by search in line in PhysicalInventory (in english)
	And I close all client application windows
	* Open a creation form PhysicalInventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I click the button named "FormCreate"
	* Store input by search in line
		And I select from "Store" drop-down list by "02" string
	* Check filling in
		Then the form attribute named "Store" became equal to "Store 01"
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
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Company" became equal to "Main Company"
	* Profit loss center, expence type input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Profit loss center" field in "ItemList" table
		And I select "log" from "Profit loss center" drop-down list by string in "ItemList" table
		And I move to the next attribute
		And I activate "Expense type" field in "ItemList" table
		And I select "fu" from "Expense type" drop-down list by string in "ItemList" table
	* Check filling in
		And "ItemList" table contains lines
		| 'Profit loss center'    | 'Expense type'   |
		| 'Logistics department'  | 'Fuel'           |
	* Change expense type
		And I select "exp" from "Expense type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Profit loss center'     | 'Expense type'    |
			| 'Logistics department'   | 'Expense'         |
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
		Then the form attribute named "Store" became equal to "Store 01"
		Then the form attribute named "Company" became equal to "Main Company"
	* Profit loss center, expence type input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Profit loss center" field in "ItemList" table
		And I select "log" from "Profit loss center" drop-down list by string in "ItemList" table
		And I move to the next attribute
		And I activate "Revenue type" field in "ItemList" table
		And I select "fu" from "Revenue type" drop-down list by string in "ItemList" table
	* Check filling in
		And "ItemList" table contains lines
		| 'Profit loss center'    | 'Revenue type'   |
		| 'Logistics department'  | 'Fuel'           |
	* Change revenue type
		And I select "rev" from "Revenue type" drop-down list by string in "ItemList" table
		And "ItemList" table contains lines
			| 'Profit loss center'     | 'Revenue type'    |
			| 'Logistics department'   | 'Revenue'         |
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
		And I select "02" from "Store" drop-down list by string in "Inventory" table
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
		| 'Item'   | 'Quantity'  | 'Item key'  | 'Store'      |
		| 'Dress'  | '2,000'     | 'L/Green'   | 'Store 01'   |
		And "AccountBalance" table contains lines
			| 'Account'        | 'Currency'    |
			| 'Cash desk №1'   | 'TRY'         |
		And "AdvanceFromCustomers" table contains lines
			| 'Partner'     | 'Legal name'                  |
			| 'Ferron BP'   | 'Second Company Ferron BP'    |
		And "AdvanceToSuppliers" table contains lines
			| 'Partner'     | 'Legal name'                  |
			| 'Ferron BP'   | 'Second Company Ferron BP'    |
		And "AccountPayableByAgreements" table contains lines
			| 'Partner'     | 'Partner term'         | 'Legal name'                 | 'Currency'    |
			| 'Ferron BP'   | 'Vendor Ferron, USD'   | 'Second Company Ferron BP'   | 'TRY'         |
		And "AccountPayableByDocuments" table contains lines
			| 'Partner'     | 'Partner term'         | 'Legal name'                 | 'Currency'    |
			| 'Ferron BP'   | 'Vendor Ferron, TRY'   | 'Second Company Ferron BP'   | 'TRY'         |
		And "AccountReceivableByAgreements" table contains lines
			| 'Partner'   | 'Legal name'   | 'Currency'    |
			| 'DFC'       | 'DFC'          | 'TRY'         |
		And "AccountReceivableByDocuments" table contains lines
			| 'Partner'   | 'Legal name'   | 'Currency'    |
			| 'DFC'       | 'DFC'          | 'TRY'         |
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

Scenario: _0154099 check partner, legal name, Partner term, company input by search in line in a document Work order (in english)
	And I close all client application windows
	* Open a creation form Work order
		Given I open hyperlink "e1cib/list/Document.WorkOrder"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Partner term input by search in line
		And I select from "Partner term" drop-down list by "TRY" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: _01540100 check partner, legal name, company input by search in line in a document Work sheet (in english)
	And I close all client application windows
	* Open a creation form Work sheet
		Given I open hyperlink "e1cib/list/Document.WorkSheet"
		And I click the button named "FormCreate"
	* Partner input by search in line
		And I select from "Partner" drop-down list by "fer" string
	* Legal name input by search in line
		And I select from "Legal name" drop-down list by "com" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Check entered values
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
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
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
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
		And I select from the drop-down list named "Store" by "re 01" string
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
		And I select from the drop-down list named "Store" by "re 01" string		
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
		And I select "02" from "Store (requester)" drop-down list by string in "ItemList" table			
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Store (requester)'  | 'Unit'   |
		| 'Boots'  | '36/18SD'   | 'Store 01'           | 'pcs'    |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "J22001" text in "Item" field of "ItemList" table	
		And in "ItemList" table drop-down list "Item" is equal to:
			| " (J22001) Jacket J22001 "    |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows



Scenario: _01540113 check item input by search in line by code in a document Sales order
	And I close all client application windows
	* Open a creation form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Partner
		And I select from the drop-down list named "Partner" by "50" string
		Then the form attribute named "Partner" became equal to "Ferron BP"
		And I select from the drop-down list named "Partner" by " 50" string
		Then the form attribute named "Partner" became equal to "Ferron BP"
		And I select from the drop-down list named "Partner" by "50." string
		Then the form attribute named "Partner" became equal to "Ferron BP"
		And I select from the drop-down list named "Partner" by "50.," string
		Then the form attribute named "Partner" became equal to "Ferron BP"
	* Legal name
		And I select from "Legal name" drop-down list by "2" string
		Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
	* Partner term
		And I select from "Partner term" drop-down list by "52" string
		Then the form attribute named "Agreement" became equal to "Ferron, USD"
	* Company
		And I select from "Company" drop-down list by "3" string
		Then the form attribute named "Company" became equal to "Second Company"
	* Store
		And I select from the drop-down list named "Store" by "2" string
		Then the form attribute named "Store" became equal to "Store 01"
		And I select from the drop-down list named "Store" by " 2" string
		Then the form attribute named "Store" became equal to "Store 01"
		And I select from the drop-down list named "Store" by "2." string
		Then the form attribute named "Store" became equal to "Store 01"
		And I select from the drop-down list named "Store" by "2.," string
		Then the form attribute named "Store" became equal to "Store 01"
	* Branch
		And I select from the drop-down list named "Branch" by "3" string
		Then the form attribute named "Branch" became equal to "Distribution department"	
	* Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "1 111 111., " text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| [1 111 111] Jacket J22001   |
		And I select "[1 111 111] Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
	* Item key
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "4" from "Item" drop-down list by string in "ItemList" table
		And I select "15" from "Item key" drop-down list by string in "ItemList" table
		And "ItemList" table became equal
			| '#'   | 'Partner item'   | 'Cancel'   | 'Procurement method'   | 'Item key'   | 'Profit loss center'   | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Price'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'   | 'Reservation date'   | 'Revenue type'   | 'Detail'   | 'Delivery date'   | 'Cancel reason'   | 'Item'    | 'Price type'   | 'Sales person'    |
			| '1'   | ''               | 'No'       | 'Stock'                | '37/18SD'    | ''                     | '1,000'      | 'pcs'    | 'No'                   | ''        | ''                | ''             | ''               | ''        | ''                   | ''               | ''         | ''                | ''                | 'Boots'   | 'Price USD'    | ''                |
	* Unit
		And I select "7" from "Unit" drop-down list by string in "ItemList" table	
		And "ItemList" table became equal
			| '#'   | 'Partner item'   | 'Cancel'   | 'Procurement method'   | 'Item key'   | 'Profit loss center'   | 'Quantity'   | 'Unit'             | 'Dont calculate row'   | 'Price'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'   | 'Reservation date'   | 'Revenue type'   | 'Detail'   | 'Delivery date'   | 'Cancel reason'   | 'Item'    | 'Price type'   | 'Sales person'    |
			| '1'   | ''               | 'No'       | 'Stock'                | '37/18SD'    | ''                     | '1,000'      | 'Boots (12 pcs)'   | 'No'                   | ''        | ''                | ''             | ''               | ''        | ''                   | ''               | ''         | ''                | ''                | 'Boots'   | 'Price USD'    | ''                |
	* Revenue type
		And I select "8" from "Revenue type" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Revenue type'    |
			| 'Revenue'         |
	* Price type
		And I select "4" from "Price type" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Price type'           |
			| 'Basic Price Types'    |
	* Profit loss center
		And I select "4" from "Profit loss center" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Profit loss center'      |
			| 'Logistics department'    |
	* Cancel reason
		And I select "2" from "Cancel reason" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Cancel reason'    |
			| 'rejects'          |
	* Sales person
		And I select "54" from "Sales person" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Sales person'       |
			| 'Alexander Orlov'    |
		And I close all client application windows

Scenario: _01540114 check item input by search in line by code in a document Bank payment
	And I close all client application windows
	* Open a creation form Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
	* Company
		And I select from "Company" drop-down list by "45" string
		Then the form attribute named "Company" became equal to "Main Company"
	* Account
		And I select from "Account" drop-down list by "5" string
		Then the form attribute named "Account" became equal to "Bank account, USD"
	* Partner
		And in the table "PaymentList" I click the button named "PaymentListAdd"		
		And I select "50" from "Partner" drop-down list by string in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'      |
			| 'Ferron BP'    |
	* Payee
		And I select "46" from "Payee" drop-down list by string in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Payee'                |
			| 'Company Ferron BP'    |
	* Partner term
		And I select "46" from "Partner term" drop-down list by string in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner term'                        |
			| 'Basic Partner terms, without VAT'    |
	* Financial movement type
		And I select "10" from "Financial movement type" drop-down list by string in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Financial movement type'    |
			| 'Movement type 1'            |
	* Branch
		And I select from the drop-down list named "Branch" by "3" string
		Then the form attribute named "Branch" became equal to "Distribution department"
	And I close all client application windows
		
				

Scenario: _01540115 check item input by search in line by code in a document Purchase order
	And I close all client application windows
	* Open a creation form Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Partner
		And I select from the drop-down list named "Partner" by "50" string
		Then the form attribute named "Partner" became equal to "Ferron BP"
		And I select from the drop-down list named "Partner" by " 50" string
		Then the form attribute named "Partner" became equal to "Ferron BP"
		And I select from the drop-down list named "Partner" by "50." string
		Then the form attribute named "Partner" became equal to "Ferron BP"
		And I select from the drop-down list named "Partner" by "50.," string
		Then the form attribute named "Partner" became equal to "Ferron BP"
	* Legal name
		And I select from "Legal name" drop-down list by "2" string
		Then the form attribute named "LegalName" became equal to "Second Company Ferron BP"
	* Partner term
		And I select from "Partner term" drop-down list by "49" string
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
	* Company
		And I select from "Company" drop-down list by "3" string
		Then the form attribute named "Company" became equal to "Second Company"
	* Store
		And I select from the drop-down list named "Store" by "2" string
		Then the form attribute named "Store" became equal to "Store 01"
		And I select from the drop-down list named "Store" by " 2" string
		Then the form attribute named "Store" became equal to "Store 01"
		And I select from the drop-down list named "Store" by "2." string
		Then the form attribute named "Store" became equal to "Store 01"
		And I select from the drop-down list named "Store" by "2.," string
		Then the form attribute named "Store" became equal to "Store 01"
	* Branch
		And I select from the drop-down list named "Branch" by "3" string
		Then the form attribute named "Branch" became equal to "Distribution department"	
	* Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I input "1 111 111., " text in "Item" field of "ItemList" table		
		And drop-down list "Item" is equal to:
		| [1 111 111] Jacket J22001   |
		And I select "[1 111 111] Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
	* Item key
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "4" from "Item" drop-down list by string in "ItemList" table
		And I select "15" from "Item key" drop-down list by string in "ItemList" table
		And "ItemList" table became equal
			| '#'   | 'Partner item'   | 'Cancel'   | 'Item key'   | 'Profit loss center'   | 'Quantity'   | 'Unit'   | 'Dont calculate row'   | 'Price'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'   | 'Detail'   | 'Delivery date'   | 'Cancel reason'   | 'Item'    | 'Price type'           |
			| '1'   | ''               | 'No'       | '37/18SD'    | ''                     | '1,000'      | 'pcs'    | 'No'                   | ''        | ''                | ''             | ''               | ''        | ''         | ''                | ''                | 'Boots'   | 'Vendor price, USD'    |
	* Unit
		And I select "7" from "Unit" drop-down list by string in "ItemList" table	
		And "ItemList" table became equal
			| '#'   | 'Partner item'   | 'Cancel'   | 'Item key'   | 'Profit loss center'   | 'Quantity'   | 'Unit'             | 'Dont calculate row'   | 'Price'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Store'   | 'Detail'   | 'Delivery date'   | 'Cancel reason'   | 'Item'    | 'Price type'           |
			| '1'   | ''               | 'No'       | '37/18SD'    | ''                     | '1,000'      | 'Boots (12 pcs)'   | 'No'                   | ''        | ''                | ''             | ''               | ''        | ''         | ''                | ''                | 'Boots'   | 'Vendor price, USD'    |
	* Price type
		And I select "4" from "Price type" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Price type'           |
			| 'Basic Price Types'    |
	* Profit loss center
		And I select "4" from "Profit loss center" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Profit loss center'      |
			| 'Logistics department'    |
	* Cancel reason
		And I select "2" from "Cancel reason" drop-down list by string in "ItemList" table			
		And "ItemList" table contains lines
			| 'Cancel reason'    |
			| 'rejects'          |
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
		| 'Legal name'                | 'Partner'     |
		| 'Second Company Ferron BP'  | 'Ferron BP'   |
		And I close all client application windows

Scenario: _0154092 check company, employee, currency, position, branch input by search in line in Payroll (in english)
	And I close all client application windows
	* Open a creation form Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Currency input by search in line
		And I select from "Currency" drop-down list by "lir" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* Filling the tabular part by searching the value by line employee and position)
		And in the table "AccrualList" I click the button named "AccrualListAdd"		
		And in the table "AccrualList" I click the button named "AccrualListAdd"
		And I activate "Employee" field in "AccrualList" table
		And I select current line in "AccrualList" table
		And I select "bro" from "Employee" drop-down list by string in "AccrualList" table
		And I activate "Position" field in "AccrualList" table
		And I select "mana" from "Position" drop-down list by string in "AccrualList" table
		And I activate "Accrual type" field in "AccrualList" table
		And I select "sa" from "Accrual type" drop-down list by string in "AccrualList" table
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "Branch" became equal to "Front office"
		And "AccrualList" table contains lines
			| 'Employee'      | 'Position'   | 'Accrual type'    |
			| 'Arina Brown'   | 'Manager'    | 'Salary'          |
		And I close all client application windows

Scenario: _0154092 check company, branch input by search in line in TimeSheet (in english)
	And I close all client application windows
	* Open a creation form TimeSheet
		Given I open hyperlink "e1cib/list/Document.TimeSheet"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		And I close all client application windows




Scenario: _0154093 check company, expense and revenue type input by search in line in ForeignCurrencyRevaluation (in english)
	And I close all client application windows
	* Open a creation form Staffing
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Expense input by search in line
		And I select from "(Expense) Type" drop-down list by "exp" string
	* Revenue input by search in line
		And I select from "(Revenue) Type" drop-down list by "rev" string
	* Profit loss center in line
		And I select from "(Expense) Profit loss center" drop-down list by "fron" string
		And I select from "(Revenue) Profit loss center" drop-down list by "fron" string		
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "ExpenseType" became equal to "Expense"
		Then the form attribute named "ExpenseProfitLossCenter" became equal to "Front office"
		Then the form attribute named "RevenueType" became equal to "Revenue"
		Then the form attribute named "RevenueProfitLossCenter" became equal to "Front office"
		And I close all client application windows


Scenario: _0154094 check item and item key input by search in line in a document Retail Shipment confirmation (in english)
	And I close all client application windows
	* Open a creation form Retail Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows


Scenario: _0154095 check partner, legal name, company, store input by search in line in a document Retail Shipment confirmation (in english)
	And I close all client application windows
	* Open a creation form Retail Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Courier delivery" exact value from "Transaction type" drop-down list
	* Retail customer input by search in line
		And I select from "Retail customer" drop-down list by "test" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "03" string
	* Courier input by search in line
		And I select from "Courier" drop-down list by "Lunch" string
	* Check entered values
		Then the form attribute named "Courier" became equal to "Lunch"
		Then the form attribute named "RetailCustomer" became equal to "Test01 Test01"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I close all client application windows


Scenario: _0154096 check item and item key input by search in line in a document Retail goods receipt (in english)
	And I close all client application windows
	* Open a creation form Retail goods receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I click the button named "FormCreate"
	* Item and item key input by search in line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "boo" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
	* Check entered values
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'   |
		| 'Boots'  | '36/18SD'    |
		And I click "Add" button
		And I input "J22001" text in "Item" field of "ItemList" table		
		And drop-down list named "ItemListItem" is equal to:
		| (J22001) Jacket J22001   |
		And I select "(J22001) Jacket J22001" exact value from "Item" drop-down list in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'            |
		| 'Jacket J22001'   |
		And I close all client application windows


Scenario: _0154097 check partner, legal name, company, store input by search in line in a document Retail Goods Receipt (in english)
	And I close all client application windows
	* Open a creation form Retail Goods Receipt
		Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
		And I click the button named "FormCreate"
		And I select "Courier delivery" exact value from "Transaction type" drop-down list
	* Retail customer input by search in line
		And I select from "Retail customer" drop-down list by "test" string
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Store input by search in line
		And I select from the drop-down list named "Store" by "03" string
	* Courier input by search in line
		And I select from "Courier" drop-down list by "Lunch" string
	* Check entered values
		Then the form attribute named "Courier" became equal to "Lunch"
		Then the form attribute named "RetailCustomer" became equal to "Test01 Test01"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	And I close all client application windows

Scenario: _0154098 check company, branch input by search in line in AdditionalAccrual (in english)
	And I close all client application windows
	* Open a creation form AdditionalAccrual
		Given I open hyperlink "e1cib/list/Document.AdditionalAccrual"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		And I close all client application windows

Scenario: _0154099 check company, branch input by search in line in AdditionalDeduction (in english)
	And I close all client application windows
	* Open a creation form AdditionalDeduction
		Given I open hyperlink "e1cib/list/Document.AdditionalDeduction"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		And I close all client application windows

Scenario: _01540100 check company, branch input by search in line in EmployeeHiring (in english)
	And I close all client application windows
	* Open a creation form EmployeeHiring
		Given I open hyperlink "e1cib/list/Document.EmployeeHiring"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* ProfitLossCenter input by search in line
		And I select from "Profit loss center" drop-down list by "front" string
	* Position input by search in line
		And I select from "Position" drop-down list by "Sales" string
	* Employee input by search in line
		And I select from "Employee" drop-down list by "Arina" string
	* EmployeeSchedule input by search in line
		And I select from "Employee schedule" drop-down list by "1 working day" string
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "ProfitLossCenter" became equal to "Front office"
		Then the form attribute named "Position" became equal to "Sales person"
		Then the form attribute named "EmployeeSchedule" became equal to "1 working day / 2 days off (day)"	
		Then the form attribute named "Employee" became equal to "Arina Brown"			
		And I close all client application windows
	
Scenario: _01540101 check company, branch input by search in line in EmployeeFiring (in english)
	And I close all client application windows
	* Open a creation form EmployeeFiring
		Given I open hyperlink "e1cib/list/Document.EmployeeFiring"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Employee input by search in line
		And I select from "Employee" drop-down list by "Arina" string
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Employee" became equal to "Arina Brown"			
		And I close all client application windows

Scenario: _01540102 check company, branch input by search in line in EmployeeTransfer (in english)
	And I close all client application windows
	* Open a creation form EmployeeTransfer
		Given I open hyperlink "e1cib/list/Document.EmployeeTransfer"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Employee input by search in line
		And I select from "Employee" drop-down list by "Arina" string
	* ToPosition input by search in line
		And I select from "To position" drop-down list by "Sales" string
	* ToEmployeeSchedule input by search in line
		And I select from "To employee schedule" drop-down list by "1 working day" string
	* ToBranch input by search in line
		And I select from "To branch" drop-down list by "Front" string
	* ToProfitLossCenter input by search in line
		And I select from "To profit loss center" drop-down list by "Front" string
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Employee" became equal to "Arina Brown"	
		Then the form attribute named "ToPosition" became equal to "Sales person"
		Then the form attribute named "ToEmployeeSchedule" became equal to "1 working day / 2 days off (day)"
		Then the form attribute named "ToBranch" became equal to "Front office"
		Then the form attribute named "ToProfitLossCenter" became equal to "Front office"
		And I close all client application windows

Scenario: _01540103 check company, branch input by search in line in EmployeeVacation (in english)
	And I close all client application windows
	* Open a creation form EmployeeVacation
		Given I open hyperlink "e1cib/list/Document.EmployeeVacation"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* Employee input by search in line
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I select "arina" from "Employee" drop-down list by string in "EmployeeList" table
		And I finish line editing in "EmployeeList" table
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		And "EmployeeList" table became equal
			| '#' | 'Employee'    | 'Begin date' | 'End date' |
			| '1' | 'Arina Brown' | ''           | ''         |				
	And I close all client application windows
	
		
Scenario: _01540104 check company, branch input by search in line in EmployeeSickLeave (in english)
	And I close all client application windows
	* Open a creation form EmployeeSickLeave
		Given I open hyperlink "e1cib/list/Document.EmployeeSickLeave"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "front" string
	* Employee input by search in line
		And in the table "EmployeeList" I click the button named "EmployeeListAdd"
		And I select "arina" from "Employee" drop-down list by string in "EmployeeList" table
		And I finish line editing in "EmployeeList" table
	* Check
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Branch" became equal to "Front office"
		And "EmployeeList" table became equal
			| '#' | 'Employee'    | 'Begin date' | 'End date' |
			| '1' | 'Arina Brown' | ''           | ''         |				
	And I close all client application windows				

Scenario: _01540116 check partner, legal name, Partner term, company and store input by search in line in a document Debit credit note (in english)
	And I close all client application windows
	* Open a creation form DebitCreditNote
		Given I open hyperlink "e1cib/list/Document.DebitCreditNote"
		And I click the button named "FormCreate"
	* Company input by search in line
		And I select from "Company" drop-down list by "main" string
	* Partner send input by search in line
		And I select from "Partner (send)" drop-down list by "fer" string
	* Partner receive input by search in line
		And I select from "Partner (receive)" drop-down list by "kalip" string
	* Legal name send input by search in line
		And I select from "Legal name (send)" drop-down list by "fer" string
	* Legal name receive input by search in line
		And I select from "Legal name (receive)" drop-down list by "kalip" string
	* Partner term send input by search in line
		And I select from "Partner term (send)" drop-down list by "Basic Partner terms, TRY" string
	* Partner term receive input by search in line
		And I select from "Partner term (receive)" drop-down list by "Basic Partner terms, TRY" string	
	* Branch send input by search in line
		And I select from "Branch (send)" drop-down list by "Front office" string	
	* Branch receive input by search in line
		And I select from "Branch (receive)" drop-down list by "Front office" string
	* Project send input by search in line
		And I select from "Project (send)" drop-down list by "01" string
	* Project receive input by search in line
		And I select from "Project (receive)" drop-down list by "02" string
	* Branch input by search in line
		And I select from "Branch" drop-down list by "Front office" string
	* Currency input by search in line
		And I select from "Currency" drop-down list by "turk" string
	* Check entered values
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "ReceiveAgreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "ReceiveBranch" became equal to "Front office"
		Then the form attribute named "ReceiveLegalName" became equal to "Company Kalipso"
		Then the form attribute named "ReceivePartner" became equal to "Kalipso"
		Then the form attribute named "ReceiveProject" became equal to "Project 02"
		Then the form attribute named "SendAgreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "SendBranch" became equal to "Front office"
		Then the form attribute named "SendLegalName" became equal to "Company Ferron BP"
		Then the form attribute named "SendPartner" became equal to "Ferron BP"
		Then the form attribute named "SendProject" became equal to "Project 01"			
	And I close all client application windows