#language: en
@tree
@Positive
@ProcurementDataProc


Feature: check procurement data processor

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario:_700000 preparation (procurement data proccessor)
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)	
	* Tax settings
		When filling in Tax settings for company
	When Create document InternalSupplyRequest objects (for procurement)
	* Change procurement date
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 240000" in "$$$$Date$$$$" variable
		And I input "$$$$Date$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 1200000" in "$$$$Date2$$$$" variable
		And I input "$$$$Date2$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '3'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 1500000" in "$$$$Date3$$$$" variable
		And I input "$$$$Date3$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
		And I go to line in "List" table
			| 'Number' |
			| '4'      |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate() + 1800000" in "$$$$Date4$$$$" variable
		And I input "$$$$Date4$$$$" variable value in "Procurement date" field
		And I move to the next attribute
		And I click "Post and close" button
	When Create document PriceList objects (for procurement)
	* Post document
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
			| 'Number' |
			| '58'      |
		And I select current line in "List" table
		And I click "Post and close" button
		And I close all client application windows

Scenario:_700001 procurement data proccessor form
	Given I open hyperlink "e1cib/app/DataProcessor.Procurement"
	Then the form attribute named "Company" became equal to ""
	Then the form attribute named "Store" became equal to ""
	Then the form attribute named "Period" became equal to ""
	Then the form attribute named "Periodicity" became equal to ""
	Then the number of "Analysis" table lines is "равно" 0
	Then the number of "Details" table lines is "равно" 0
	* Check company filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'    |
			| 'Main Company'   |
			| 'Second Company' |
		Then the number of "List" table lines is "меньше или равно" "2"
		And I go to line in "List" table
			| 'Description'    |
			| 'Main Company'   |
		And I select current line in "List" table
	* Check filling in store
		And I click Select button of "Store" field
		And "List" table contains lines
			| 'Description' |
			| 'Store 01'    |
			| 'Store 02'    |
			| 'Store 03'    |
			| 'Store 04'    |
			| 'Store 07'    |
			| 'Store 08'    |
			| 'Store 05'    |
			| 'Store 06'    |
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'   |
		And I select current line in "List" table
	* Check filling in Period
		And I click Select button of "Period" field
		And I input current date in "DateBegin" field
		And I input "$$$$Date4$$$$" text in "DateEnd" field
		And I click "Select" button
	* Check filling in periodicity
		And I select "Month" exact value from "Periodicity" drop-down list
		And I select "Day" exact value from "Periodicity" drop-down list
		And I select "Week" exact value from "Periodicity" drop-down list
		And in the table "Analysis" I click "Refresh" button
		And "Analysis" table contains lines
			| 'Item'       | 'Item key' | 'Total procurement' | 'Ordered'  | 'Shortage' |
			| 'Boots'      | '36/18SD'  | '48,000'            | ''         | '48,000'   |
			| 'Boots'      | '37/18SD'  | '30,000'            | ''         | '30,000'   |
			| 'Dress'      | 'XS/Blue'  | '70,000'            | ''         | '70,000'   |
			| 'High shoes' | '39/19SD'  | '15,000'            | ''         | '15,000'   |
		And "Details" table contains lines
			| 'Document'                   | 'Total quantity' |
			| 'Internal supply request 1*' | '5,000'          |
			| 'Internal supply request 2*' | '43,000'         |
		And I close all client application windows
		
		
				
		

		
				
		
				

		
				
		
				

				
		
				
		
				
		
