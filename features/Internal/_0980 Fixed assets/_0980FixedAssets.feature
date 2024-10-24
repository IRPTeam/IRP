﻿#language: en
@tree
@Positive
@FixedAssets

Feature: check fixed assets


Variables:
import "Variables.feature"

Background:
		Given I open new TestClient session or connect the existing one


Scenario: _980001 preparation (fixed assets)
	When set True value to the constant
	When set True value to the constant Use fixed assets
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
		When Create catalog Units objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog ItemTypes objects
		When Create catalog Items objects
		When Create catalog ItemKeys objects
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
		When Create catalog Projects objects
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
		When Create information register Taxes records (VAT)
		When Create test data for fixed assets
		When Create document PurchaseInvoice and Calculation movement cost objects (fixed assets)
		* Posting Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "5"
		* Posting Calculation movement costs
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			Then "Calculations movement costs" window is opened
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "5"
	And I close all client application windows
	
Scenario: _980002 check preparation
	When check preparation

Scenario: _980003 create fixed asset
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.FixedAssets"
	* Check hierarchical
		And I click the button named "FormCreateFolder"
		And I input "Group 01" text in "ENG" field
		And I click "Save and close" button
		* Create Group 02
			And I click the button named "FormCreateFolder"
			And I input "Group 02" text in "ENG" field
			And I click Open button of "ENG" field
			And I input "Group 02 tr" text in "TR" field
			And I click "Ok" button
			And I click Choice button of the field named "Parent"
			And I go to line in "List" table
				| "Description" |
				| "Group 01"    |
			And I select current line in "List" table
			And I click "Save and close" button
		* Check 
			And "List" table became equal
				| 'Description' |
				| 'Group 01'    |
				| 'Group 02'    |
	And I click "Create" button
	* Filling description
		And I input "Fixed asset" text in "ENG" field
		And I click Open button of "ENG" field
		Then "Edit descriptions" window is opened
		And I input "Fixed asset TR" text in "TR" field
		And I click "Ok" button
	And I input "09089797970" text in "Inventory number" field
	And I select "Tangible assets" exact value from the drop-down list named "Type"
	* Add depreciation info
		And in the table "DepreciationInfo" I click the button named "DepreciationInfoAdd"
		And I click choice button of "Ledger type" attribute in "DepreciationInfo" table
		And I go to line in "List" table
			| 'Description'                          |
			| 'Computer Hardware (with deprecation)' |
		And I select current line in "List" table	
		And I activate "Schedule" field in "DepreciationInfo" table
		And I click choice button of "Schedule" attribute in "DepreciationInfo" table
		And I go to line in "List" table
			| 'Description'                   |
			| 'Declining balance (60 months)' |
		And I select current line in "List" table
		And I select "36" from "Schedule" drop-down list by string in "DepreciationInfo" table
		And I select "compute" from "Ledger type" drop-down list by string in "DepreciationInfo" table
		And I finish line editing in "DepreciationInfo" table
	* Check
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description' | 'Type'            |
			| 'Fixed asset' | 'Tangible assets' |
	And I close all client application windows
	
Scenario: _980004 create depreciation schedules		
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.DepreciationSchedules"
	* Create depreciation schedules	(Straight line)
		And I click "Create" button
		And I input "Test deprecation schedules 1" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Test deprecation schedules 1 TR" text in "TR" field
		And I click "Ok" button
		And I select "Straight line" exact value from "Calculation method" drop-down list
		And I input "72" text in "Useful life (Months)" field
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'                  |
			| 'Test deprecation schedules 1' |
	* Create depreciation schedules	(Declining balance)
		And I click "Create" button
		And I input "Test deprecation schedules 2" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Test deprecation schedules 2 TR" text in "TR" field
		And I click "Ok" button
		And I select "Declining balance" exact value from "Calculation method" drop-down list
		And I input "20" text in "Useful life (Months)" field
		And I input "5,00" text in the field named "Rate"
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'                  |
			| 'Test deprecation schedules 2' |
	And I close all client application windows
			
				
Scenario: _980005 create fixed assets ledger type	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.FixedAssetsLedgerTypes"
	* Create fixed assets ledger type (calculate deprecation = true)
		And I click "Create" button
		And I input "Calculate deprecation 1" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Calculate deprecation 1 TR" text in "TR" field
		And I click "Ok" button
		And I set checkbox "Calculate depreciation"
		And I select from "Expense type" drop-down list by "Expense" string		
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'             |
			| 'Calculate deprecation 1' |
	* Create fixed assets ledger type (calculate deprecation = false)
		And I click "Create" button
		And I input "Calculate deprecation 2" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Calculate deprecation 2 TR" text in "TR" field
		And I click "Ok" button
		And I remove checkbox "Calculate depreciation"
		And I select from "Expense type" drop-down list by "Expense" string		
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'             |
			| 'Calculate deprecation 2' |
	And I close all client application windows				

Scenario: _980007 create commissioning of fixed asset
	And I close all client application windows
	* Create first commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I click "Create" button
	* Filling main details
		And I select from the drop-down list named "Company" by "Main Company" string
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I move to the next attribute
		And I click Select button of "Fixed asset" field
		And I go to line in "List" table
			| 'Description'      |
			| 'Computer Servers' |
		And I select current line in "List" table
		And I click Select button of "Profit loss center" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I click Select button of "Responsible person" field
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown'    |
		And I select current line in "List" table
		And I move to the next attribute
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Fixed asset 1' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I move to "More" tab
		And I input "12.01.2024 00:00:00" text in the field named "Date"
		And I move to the next attribute
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I click "Post" button
	* Check
		And I delete "$$NumberCommissioningOfFixedAsset1$$" variable
		And I delete "$$CommissioningOfFixedAsset1$$" variable
		And I save the value of "Number" field as "$$NumberCommissioningOfFixedAsset1$$"
		And I save the window as "$$CommissioningOfFixedAsset1$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberCommissioningOfFixedAsset1$$' |		
	* Create second commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I click "Create" button
	* Filling main details
		And I select from the drop-down list named "Company" by "Main Company" string
		And I activate field named "ItemListLineNumber" in "ItemList" table
		And I move to the next attribute
		And I select from "Fixed asset" drop-down list by "Office Furniture" string
		And I select from "Profit loss center" drop-down list by "Logistics department" string
		And I select from "Responsible person" drop-down list by "Arina Brown" string
		And I select from the drop-down list named "Store" by "Store 02" string
		And in the table "ItemList" I click "Add" button
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Fixed asset 2" from "Item" drop-down list by string in "ItemList" table
		And I move to "Other" tab
		And I move to "More" tab
		And I input "03.02.2024 00:00:00" text in the field named "Date"
		And I move to the next attribute
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I click "Post" button
		And "ItemList" table became equal
			| '#' | 'Item'          | 'Item key'      | 'Serial lot numbers' | 'Unit' | 'Source of origins' | 'Quantity' | 'Store'    |
			| '1' | 'Fixed asset 2' | 'Fixed asset 2' | ''                   | 'pcs'  | ''                  | '1,000'    | 'Store 02' |		
	* Check
		And I delete "$$NumberCommissioningOfFixedAsset2$$" variable
		And I delete "$$CommissioningOfFixedAsset2$$" variable
		And I save the value of "Number" field as "$$NumberCommissioningOfFixedAsset2$$"
		And I save the window as "$$CommissioningOfFixedAsset2$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberCommissioningOfFixedAsset2$$' |
	And I close all client application windows

Scenario: _9800020 create depreciation calculation
	And I close all client application windows
	* Preparation (calculation movement cost)
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		Then "Calculations movement costs" window is opened
		Then I select all lines of "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
		And Delay "5"
	* Create deprecation calculation for first month
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I click "Create" button	
	* Filling main details
		And I select from the drop-down list named "Company" by "Main Company" string	
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
	* Fill deprecation calculation for first month (empty)
		And I click Choice button of the field named "Date"
		And I input "31.01.2024 00:00:00" text in the field named "Date"
		And in the table "Calculations" I click "Fill calculations" button
		Then the number of "Calculations" table lines is "равно" 0
	* Fill deprecation calculation for second month
		And I input "29.02.2024 00:00:00" text in the field named "Date"
		And I move to the next attribute
		And in the table "Calculations" I click "Fill calculations" button
		And "Calculations" table became equal
			| '#' | 'Fixed asset'      | 'Profit loss center'   | 'Ledger type'                          | 'Schedule'                  | 'Calculation method' | 'Currency' | 'Expense type' | 'Amount balance' | 'Amount' |
			| '1' | 'Computer Servers' | 'Logistics department' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'Straight line'      | 'TRY'      | 'Expense'      | '5 000,00'       | '138,89' |
		* Change amount
			And I activate "Amount" field in "Calculations" table
			And I select current line in "Calculations" table
			And I input "277,78" text in "Amount" field of "Calculations" table
			And I finish line editing in "Calculations" table
		And I click "Post" button
	* Check
		And I delete "$$NumberDepreciationCalculation1$$" variable
		And I delete "$$DepreciationCalculation1$$" variable
		And I save the value of "Number" field as "$$NumberDepreciationCalculation1$$"
		And I save the window as "$$DepreciationCalculation1$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                             |
			| '$$NumberDepreciationCalculation1$$' |
	* Fill deprecation calculation for third month
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I click "Create" button
		And I input "31.03.2024 00:00:00" text in the field named "Date"
		And I select from the drop-down list named "Company" by "Main Company" string	
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And in the table "Calculations" I click "Fill calculations" button
		And "Calculations" table became equal
			| '#' | 'Fixed asset'      | 'Profit loss center'   | 'Ledger type'                               | 'Schedule'                      | 'Calculation method' | 'Currency' | 'Expense type' | 'Amount balance' | 'Amount'   |
			| '1' | 'Computer Servers' | 'Logistics department' | 'Computer Hardware (with deprecation)'      | 'Straight line (36 months)'     | 'Straight line'      | 'TRY'      | 'Expense'      | '4 722,22'       | '138,89'   |
			| '2' | 'Office Furniture' | 'Logistics department' | 'Furniture and Fixtures (with deprecation)' | 'Declining balance (60 months)' | 'Declining balance'  | 'TRY'      | 'Expense'      | '7 000,00'       | '1 166,67' |
		And I click "Post" button
	* Check
		And I delete "$$NumberDepreciationCalculation2$$" variable
		And I delete "$$DepreciationCalculation2$$" variable
		And I save the value of "Number" field as "$$NumberDepreciationCalculation2$$"
		And I save the window as "$$DepreciationCalculation2$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                             |
			| '$$NumberDepreciationCalculation2$$' |
		And I close all client application windows

Scenario: _9800021 check filter by branch for Depreciation calculation
	And I close all client application windows
	* Create deprecation calculation for first month
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I click "Create" button
		And I click Choice button of the field named "Date"
		And I input "30.04.2024 00:00:00" text in the field named "Date"
		And I move to the next attribute		
	* Filling main details
		And I select from the drop-down list named "Company" by "Main Company" string	
		Then the form attribute named "Branch" became equal to ""		
	* Fill deprecation calculation for first month (empty)
		And I click Choice button of the field named "Date"
		And in the table "Calculations" I click "Fill calculations" button
		Then the number of "Calculations" table lines is "равно" 0
	And I close all client application windows	

Scenario: _9800022 manual filling Depreciation calculation
	And I close all client application windows
	* Create deprecation calculation
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I click "Create" button
		And I click Choice button of the field named "Date"
		And I input "30.05.2024 00:00:00" text in the field named "Date"
		And I move to the next attribute
		And I select from the drop-down list named "Company" by "Main Company" string	
		And I select from the drop-down list named "Branch" by "Front office" string	
	* Add fixed assets
		And I move to "Calculations" tab
		And in the table "Calculations" I click the button named "CalculationsAdd"
		And I activate "Fixed asset" field in "Calculations" table
		And I select current line in "Calculations" table
		And I click choice button of "Fixed asset" attribute in "Calculations" table
		And I go to line in "List" table
			| "Description"      |
			| "Computer Servers" |
		And I select current line in "List" table
		And I finish line editing in "Calculations" table
	* Check filling
		And "Calculations" table became equal
			| "Amount" | "Fixed asset"      | "Profit loss center"   | "Ledger type"                          | "Schedule"                  | "Expense type" | "Calculation method" | "Currency" | "Amount balance" |
			| "138,89" | "Computer Servers" | "Logistics department" | "Computer Hardware (with deprecation)" | "Straight line (36 months)" | "Expense"      | "Straight line"      | "TRY"      | "4 583,33"       |
	* Change amount
		And I select current line in "Calculations" table
		And I input "500,00" text in "Amount" field of "Calculations" table
		And I finish line editing in "Calculations" table
	* Post and check amount
		And I click "Post" button
		Then user message window does not contain messages
		And "Calculations" table became equal
			| "#" | "Amount" | "Fixed asset"      | "Profit loss center"   | "Ledger type"                          | "Schedule"                  | "Expense type" | "Calculation method" | "Currency" | "Amount balance" |
			| "1" | "500,00" | "Computer Servers" | "Logistics department" | "Computer Hardware (with deprecation)" | "Straight line (36 months)" | "Expense"      | "Straight line"      | "TRY"      | "4 583,33"       |
	And I close all client application windows
	
				
				
				
				
				