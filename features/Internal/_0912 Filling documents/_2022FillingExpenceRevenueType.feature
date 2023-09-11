#language: en
@tree
@Positive
@FillingDocuments

Feature: check filling in expence and revenue

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _0202100 preparation (filling expence, revenue)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
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
		When Create catalog Countries objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog PlanningPeriods objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create catalog PartnerItems objects
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
		When Create catalog CancelReturnReasons objects

Scenario: _02021001 check preparation
	When check preparation

Scenario: _0202101 filling revenue type in the SI (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"	
	* Check
		When check filling revenue type (from Company)
	And I close all client application windows
	

Scenario: _0202102 filling expense type in the PI (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Check
		When check	filling expense type (from Company)
	And I close all client application windows
			
Scenario: _0202103 filling revenue type in the SR (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	Given I open hyperlink "e1cib/list/Document.SalesReturn"	
	* Check
		When check filling revenue type (from Company)
	And I close all client application windows		
						

Scenario: _0202104 filling expense type in the PR (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"	
	* Check
		When check	filling expense type (from Company)
	And I close all client application windows

Scenario: _0202105 filling revenue type in the RSR (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"	
	* Check
		When check filling revenue type (from Company)
	And I close all client application windows

Scenario: _0202106 filling revenue type in the RRR (from Company)
	And I close all client application windows
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (Company)
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"	
	* Check
		When check filling revenue type (from Company)
	And I close all client application windows
		
Scenario: _0202110 filling revenue type in the SI (from item type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne SI
		When check filling revenue type (from item type)
	And I close all client application windows					

Scenario: _0202111 filling revenue type in the SR (from item type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne SR
		When check filling revenue type (from item type)
	And I close all client application windows

Scenario: _0202111 filling revenue type in the RSR (from item type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne RSR
		When check filling revenue type (from item type)
	And I close all client application windows

Scenario: _0202112 filling revenue type in the RRR (from item type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne RSR
		When check filling revenue type (from item type)
	And I close all client application windows

Scenario: _0202113 filling expence type in the PI (from item type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne PI
		When check filling expense type (from item type)
	And I close all client application windows

Scenario: _0202114 filling expence type in the PR (from item type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item type)
	* Check in tne PR
		When check filling expense type (from item type)
	And I close all client application windows

Scenario: _0202110 filling revenue type in the SI (from item)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item)
	* Check in tne SI
		When check filling revenue type (item)
	And I close all client application windows					

Scenario: _0202111 filling revenue type in the SR (from item)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item)
	* Check in tne SR
		When check filling revenue type (item)
	And I close all client application windows

Scenario: _0202111 filling revenue type in the RSR (from item)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item)
	* Check in tne RSR
		When check filling revenue type (item)
	And I close all client application windows

Scenario: _0202112 filling revenue type in the RRR (from)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item)
	* Check in tne RSR
		When check filling revenue type (item)
	And I close all client application windows

Scenario: _0202113 filling expence type in the PI (from item)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item)
	* Check in tne PI
		When check filling expense type (from item)
	And I close all client application windows

Scenario: _0202114 filling expence type in the PR (from item)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item)
	* Check in tne PR
		When check filling expense type (from item)
	And I close all client application windows


Scenario: _0202120 filling revenue type in the SI (from item key)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item key)
	* Check in tne SI
		When check filling revenue type (item key)
	And I close all client application windows					

Scenario: _0202121 filling revenue type in the SR (from item key)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item key)
	* Check in tne SR
		When check filling revenue type (item key)
	And I close all client application windows

Scenario: _0202122 filling revenue type in the RSR (from item key)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item key)
	* Check in tne RSR
		When check filling revenue type (item key)
	And I close all client application windows

Scenario: _0202123 filling revenue type in the RRR (from item key)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item key)
	* Check in tne RSR
		When check filling revenue type (item key)
	And I close all client application windows

Scenario: _0202124 filling expence type in the PI (from item key)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item key)
	* Check in tne PI
		When check filling expense type (from item key)
	And I close all client application windows

Scenario: _0202125 filling expence type in the PR (from item key)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	* Load registers settings
		When Create information register ExpenseRevenueTypeSettings records (item key)
	* Check in tne PR
		When check filling expense type (from item key)
	And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session
