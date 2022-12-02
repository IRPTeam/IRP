#language: en
@tree
@LandedCost

Feature: Landed cost

Variables:
import "Variables.feature"

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _150041 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
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
		When Create catalog Agreements objects (commision trade, own companies)
		When Create information register TaxSettings records (Concignor 1)
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects 
		When Create catalog Countries objects
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
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When update ItemKeys
		When update ItemKeys
		When Create catalog Partners objects
		When Data preparation (comission stock)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Landed cost settings for company	
			Given I open hyperlink "e1cib/list/Catalog.Companies"
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I select "Company" exact value from the drop-down list named "Type"
			And I move to "Landed cost" tab
			And I click Select button of "Currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
				| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
			And I select current line in "List" table
			Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
			And I click "Save and close" button
			And I wait "Main Company (Company) *" window closing in 20 seconds
			Then "Companies" window is opened
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			And I select "Company" exact value from the drop-down list named "Type"
			And I move to "Landed cost" tab
			And I click Select button of "Currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
				| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
			And I select current line in "List" table
			Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
			And I click "Save and close" button
			And I wait "Second Company (Company) *" window closing in 20 seconds
	* Tax settings
		When filling in Tax settings for company
	And I close all client application windows
		