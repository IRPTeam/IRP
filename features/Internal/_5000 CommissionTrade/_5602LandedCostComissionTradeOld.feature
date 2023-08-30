#language: en
@tree
@Positive



Feature: landed cost commission trade



Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one





Scenario: _05702 preparation (landed cost commission trade)
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog SourceOfOrigins objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When update ItemKeys
		When Create catalog Partners objects
		When Data preparation (comission stock)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
	* Load documents
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		When Create document InventoryTransfer objects (comission trade)
		When Create document SalesInvoice and SalesReturn objects (comission trade)
		When Create document SalesReportToConsignor objects (landed cost)
		When Create document CalculationMovementCosts objects (comission trade, consignment)
		When Create document OpeningEntry objects (comission trade, landed cost)
		When Create document Retail sales receipt and RetailReturnReceipt objects (comission trade, landed cost)
	* Post document
		* Posting Opening entry
			Given I open hyperlink "e1cib/list/Document.OpeningEntry"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesInvoice
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting PurchaseReturn
			Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesReturn
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting Inventory transfer
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesReportToConsignor
			Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting Retail sales receipt
			Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting Retail return receipt
			Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting CalculationMovementCosts
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		
	And I close all client application windows
		

Scenario: _05702 check preparation
	When check preparation

Scenario: _057003 check batch balance
	And I close all client application windows
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	* Select period
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "01.11.2022" text in the field named "DateBegin"
		And I input "04.11.2022" text in the field named "DateEnd"
		And I click the button named "Select"
	And I click "Generate" button
	And "Result" spreadsheet document contains "BathBalance_057_1" template lines by template
	And I close all client application windows
