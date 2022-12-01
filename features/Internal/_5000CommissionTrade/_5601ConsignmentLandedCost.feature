#language: en
@tree
@Positive
@CommissionTradeLandedCost


Feature: consignment landed cost



Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one





Scenario: _05602 preparation (consignment landed cost)
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
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Companies objects (own Second company)
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
		When Create information register TaxSettings records (Concignor 1)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Tax settings
		When filling in Tax settings for company
	* Post document
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseInvoice.FindByNumber(192).GetObject().Write(DocumentWriteMode.Posting);" |
	* Setting for Company
		When settings for Company (commission trade)
	And I close all client application windows
	* LoadDocuments
		When Create document PurchaseInvoice objects (comission trade, consignment)
		When Create document AdditionalCostAllocation objects (comission trade, consignment)
		When Create document SalesInvoice objects (comission trade, consignment)
		When Create document SalesReturn objects (comission trade, consignment)
		When Create document SalesReportFromTradeAgent objects (comission trade, consignment)
		When Create document OpeningEntry objects (commission trade)
		When Create document CalculationMovementCosts objects (comission trade, consignment)
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
		* Posting AdditionalCostAllocation
			Given I open hyperlink "e1cib/list/Document.AdditionalCostAllocation"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesInvoice
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesReturn
			Given I open hyperlink "e1cib/list/Document.SalesReturn"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting SalesReportFromTradeAgent
			Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
		* Posting CalculationMovementCosts
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "3"
	And I close all client application windows
	
		

Scenario: _056002 check preparation
	When check preparation

Scenario: _056003 check batch balance
	And I close all client application windows
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	* Select period
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "29.10.2022" text in the field named "DateBegin"
		And I input "06.11.2022" text in the field named "DateEnd"
		And I click the button named "Select"
	And I click "Generate" button
	And "Result" spreadsheet document contains "BathBalance_056_1" template lines by template
	And I close all client application windows

Scenario: _056004 check batch balance (Opening entry)
	And I close all client application windows
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	* Select period
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		And I input "01.12.2022" text in the field named "DateBegin"
		And I input "01.12.2022" text in the field named "DateEnd"
		And I click the button named "Select"
	And I click "Generate" button
	And "Result" spreadsheet document contains "BathBalance_056_2" template lines by template
	And I close all client application windows