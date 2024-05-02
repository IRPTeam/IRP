#language: en
@tree
@Positive
@CashManagement

Feature: expense accruals and revenue accruals


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _085100 preparation (ExpenseRevenueAccruals)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog ItemKeys objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog PlanningPeriods objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create catalog Stores objects
		When Create catalog PriceTypes objects
		When Create catalog CashAccounts objects (Second Company)
		When Create information register Taxes records (VAT)
		When Create test data for ExpenseRevenueAccruals (movements)
	* Post
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ExpenseAccruals.FindByNumber(170).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ExpenseAccruals.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(172).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows


Scenario: _0851001 check preparation
	When check preparation

Scenario: _0851002 create Expense accruals (without PI and empty basis)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Accrual" exact value from "Transaction type" drop-down list		
	* Filling in the tabular part
		And in the table "CostList" I click the button named "CostListAdd"
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "100,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "20,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And in the table "CostList" I click the button named "CostListAdd"
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "80,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "16,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
	* Check currency rate (from basis)
		And I delete "$$NumberExpenseAccruals1$$" variable
		And I delete "$$ExpenseAccruals1$$" variable
		And I save the value of "Number" field as "$$NumberExpenseAccruals1$$"
		And I save the window as "$$ExpenseAccruals1$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberExpenseAccruals1$$'    |
		And I close all client application windows 


Scenario: _0851003 create Expense accruals (without PI, Void)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Void" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		And I go to line in "ExpenseValueTable" table
			| 'Document'                                      |
			| 'Expense accrual 171 dated 30.04.2024 14:01:53' |
		And I select current line in "ExpenseValueTable" table
		Then the form attribute named "Basis" became equal to "Expense accrual 171 dated 30.04.2024 14:01:53"		
		And "CostList" table became equal
			| 'Amount'  | 'Amount tax' |
			| '-180,00' | '-36,00'     |				
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "-100,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "-20,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And in the table "CostList" I click the button named "CostListAdd"
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "-80,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "-16,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (4)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'  | 'Is fixed' |
			| 'TRY'           | '0,181200' | '5,518764'     | 'No'                | '1'            | 'Reporting currency' | '-18,12'  | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '-100,00' | 'No'       |
			| 'TRY'           | '0,181200' | '5,518764'     | 'No'                | '1'            | 'Reporting currency' | '-14,50'  | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '-80,00'  | 'No'       |
		And I close "Edit hidden tables" window
		And I delete "$$NumberExpenseAccruals2$$" variable
		And I delete "$$ExpenseAccruals2$$" variable
		And I save the value of "Number" field as "$$NumberExpenseAccruals2$$"
		And I save the window as "$$ExpenseAccruals2$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberExpenseAccruals2$$'|
		And I close all client application windows 

Scenario: _0851004 create Expense accruals (without PI, Reverse)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Reverse" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		And I go to line in "ExpenseValueTable" table
			| 'Document'                                      |
			| 'Expense accrual 170 dated 30.04.2024 12:30:37' |
		And I select current line in "ExpenseValueTable" table
		Then the form attribute named "Basis" became equal to "Expense accrual 170 dated 30.04.2024 12:30:37"		
		And "CostList" table became equal
			| 'Amount'  | 'Amount tax' |
			| '-100,00' | '-20,00'     |				
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "-100,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "-20,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (2)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'  | 'Is fixed' |
			| 'TRY'           | '0,191200' | '5,230126'     | 'No'                | '1'            | 'Reporting currency' | '-19,12'  | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '-100,00' | 'No'       |		
		And I close "Edit hidden tables" window
		And I delete "$$NumberExpenseAccruals3$$" variable
		And I delete "$$ExpenseAccruals3$$" variable
		And I save the value of "Number" field as "$$NumberExpenseAccruals3$$"
		And I save the window as "$$ExpenseAccruals3$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberExpenseAccruals3$$'|
		And I close all client application windows 

Scenario: _0851005 check selection form for Expense accruals
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Reverse" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		Then "ExpenseValueTable" table does not contain lines
			| 'Document'                                      |
			| 'Expense accrual 170 dated 30.04.2024 12:30:37' |
			| 'Expense accrual 171 dated 30.04.2024 14:01:53' |
	And I close all client application windows

		
Scenario: _0851006 create Expense accruals (other period expense)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Accrual" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		And I go to line in "ExpenseValueTable" table
			| 'Document'                                       |
			| 'Purchase invoice 171 dated 30.04.2024 12:55:27' |
		And I select current line in "ExpenseValueTable" table
		Then the form attribute named "Basis" became equal to "Purchase invoice 171 dated 30.04.2024 12:55:27"		
		And "CostList" table became equal
			| 'Amount'   | 'Amount tax' |
			| '3 000,00' | '540,00'     |				
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "1000,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "180,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (2)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'   | 'Is fixed' |
			| 'TRY'           | '0,251710' | '3,972826'     | 'No'                | '1'            | 'Reporting currency' | '251,71'   | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '1 000,00' | 'No'       |			
		And I close "Edit hidden tables" window
		And I delete "$$NumberExpenseAccruals4$$" variable
		And I delete "$$ExpenseAccruals4$$" variable
		And I save the value of "Number" field as "$$NumberExpenseAccruals4$$"
		And I save the window as "$$ExpenseAccruals4$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberExpenseAccruals4$$'|
	* Create one more ExpenseAccrual for the same PI
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Accrual" exact value from "Transaction type" drop-down list
		And I input begin of the next month date in "Date" field	
		And I click Choice button of the field named "Basis"
		And I go to line in "ExpenseValueTable" table
			| 'Document'                                       |
			| 'Purchase invoice 171 dated 30.04.2024 12:55:27' |
		And I select current line in "ExpenseValueTable" table
		Then the form attribute named "Basis" became equal to "Purchase invoice 171 dated 30.04.2024 12:55:27"		
		And "CostList" table became equal
			| 'Amount'   | 'Amount tax' |
			| '2 000,00' | '360,00'     |
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Expense" from "Expense type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "1000,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "180,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (2)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'   | 'Is fixed' |
			| 'TRY'           | '0,251710' | '3,972826'     | 'No'                | '1'            | 'Reporting currency' | '251,71'   | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '1 000,00' | 'No'       |			
		And I close "Edit hidden tables" window
		And I delete "$$NumberExpenseAccruals5$$" variable
		And I delete "$$ExpenseAccruals5$$" variable
		And I save the value of "Number" field as "$$NumberExpenseAccruals5$$"
		And I save the window as "$$ExpenseAccruals5$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberExpenseAccruals5$$'|
	And I close all client application windows 

#
Scenario: _0851007 create Revenue accruals (without SI and empty basis)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Accrual" exact value from "Transaction type" drop-down list		
	* Filling in the tabular part
		And in the table "CostList" I click the button named "CostListAdd"
		And I select "Revenue" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "100,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "20,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And in the table "CostList" I click the button named "CostListAdd"
		And I select "Revenue" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "80,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "16,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
	* Check currency rate (from basis)
		And I delete "$$NumberRevenueAccruals1$$" variable
		And I delete "$$RevenueAccruals1$$" variable
		And I save the value of "Number" field as "$$NumberrevenueAccruals1$$"
		And I save the window as "$$RevenueAccruals1$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberRevenueAccruals1$$'    |
		And I close all client application windows 


Scenario: _0851008 create Revenue accruals (without SI, Void)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Void" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		And I go to line in "RevenueValueTable" table
			| 'Document'                                      |
			| 'Revenue accrual 172 dated 01.05.2024 18:43:16' |
		And I select current line in "RevenueValueTable" table
		Then the form attribute named "Basis" became equal to "Revenue accrual 172 dated 01.05.2024 18:43:16"		
		And "CostList" table became equal
			| 'Amount'  | 'Amount tax' |
			| '-180,00' | '-36,00'     |				
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Software" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "-100,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "-20,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And in the table "CostList" I click the button named "CostListAdd"
		And I select "Fuel" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "-80,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "-16,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (4)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'  | 'Is fixed' |
			| 'TRY'           | '0,191200' | '5,230126'     | 'No'                | '1'            | 'Reporting currency' | '-19,12'  | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '-100,00' | 'No'       |
			| 'TRY'           | '0,191200' | '5,230126'     | 'No'                | '1'            | 'Reporting currency' | '-15,30'  | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '-80,00'  | 'No'       |	
		And I close "Edit hidden tables" window
		And I delete "$$NumberRevenueAccruals2$$" variable
		And I delete "$$RevenueAccruals2$$" variable
		And I save the value of "Number" field as "$$NumberRevenueAccruals2$$"
		And I save the window as "$$RevenueAccruals2$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberRevenueAccruals2$$'|
		And I close all client application windows 

Scenario: _0851009 create Revenue accruals (without SI, Reverse)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Reverse" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		And I go to line in "RevenueValueTable" table
			| 'Document'                                      |
			| 'Revenue accrual 171 dated 01.05.2024 18:35:11' |
		And I select current line in "RevenueValueTable" table
		Then the form attribute named "Basis" became equal to "Revenue accrual 171 dated 01.05.2024 18:35:11"		
		And "CostList" table became equal
			| 'Amount'  | 'Amount tax' |
			| '-100,00' | '-20,00'     |				
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Software" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "-100,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "-20,00" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (2)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'  | 'Is fixed' |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '-100,00' | 'No'       |
			| 'TRY'           | '0,171200' | '5,841121'     | 'No'                | '1'            | 'Reporting currency' | '-17,12'  | 'No'       |			
		And I close "Edit hidden tables" window
		And I delete "$$NumberRevenueAccruals3$$" variable
		And I delete "$$RevenueAccruals3$$" variable
		And I save the value of "Number" field as "$$NumberRevenueAccruals3$$"
		And I save the window as "$$RevenueAccruals3$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberRevenueAccruals3$$'|
		And I close all client application windows 

Scenario: _0851010 check selection form for Revenue accruals
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Reverse" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		Then "RevenueValueTable" table does not contain lines
			| 'Document'                                      |
			| 'Revenue accrual 171 dated 30.04.2024 18:35:11' |
			| 'Revenue accrual 172 dated 01.05.2024 18:43:16' |
	And I close all client application windows

		
Scenario: _0851011 create Revenue accruals (other period expense)
	And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Accrual" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Basis"
		And I go to line in "RevenueValueTable" table
			| 'Document'                                    |
			| 'Sales invoice 171 dated 30.04.2024 13:36:19' |
		And I select current line in "RevenueValueTable" table
		Then the form attribute named "Basis" became equal to "Sales invoice 171 dated 30.04.2024 13:36:19"		
		And "CostList" table became equal
			| 'Amount'   | 'Amount tax' |
			| '847,46'   | '152,54'     |				
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Revenue" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I activate field named "CostListAmount" in "CostList" table
		And I input "500,00" text in the field named "CostListAmount" of "CostList" table
		And I activate "Amount tax" field in "CostList" table
		And I input "76,27" text in "Amount tax" field of "CostList" table
		And I finish line editing in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (2)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'   | 'Is fixed' |
			| 'TRY'           | '0,312100' | '3,204101'     | 'No'                | '1'            | 'Reporting currency' | '156,05'   | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '500,00'   | 'No'       |			
		And I close "Edit hidden tables" window
		And I delete "$$NumberRevenueAccruals4$$" variable
		And I delete "$$RevenueAccruals4$$" variable
		And I save the value of "Number" field as "$$NumberRevenueAccruals4$$"
		And I save the window as "$$RevenueAccruals4$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberRevenueAccruals4$$'|
	* Create one more RevenueAccrual for the same PI
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I select "Accrual" exact value from "Transaction type" drop-down list
		And I input begin of the next month date in "Date" field	
		And I click Choice button of the field named "Basis"
		And I go to line in "RevenueValueTable" table
			| 'Document'                                       |
			| 'Sales invoice 171 dated 30.04.2024 13:36:19' |
		And I select current line in "RevenueValueTable" table
		Then the form attribute named "Basis" became equal to "Sales invoice 171 dated 30.04.2024 13:36:19"		
		And "CostList" table became equal
			| 'Amount'   | 'Amount tax' |
			| '347,46'   | '76,27'      |
	* Filling in the tabular part
		And I select current line in "CostList" table
		And I select "Revenue" from "Revenue type" drop-down list by string in "CostList" table
		And I activate "Profit loss center" field in "CostList" table
		And I select "Front office" from "Profit loss center" drop-down list by string in "CostList" table
		And I click the button named "FormPost"
		And I click "Show hidden tables" button
		And I move to "Currencies (2)" tab
		And "Currencies" table became equal
			| 'Currency from' | 'Rate'     | 'Reverse rate' | 'Show reverse rate' | 'Multiplicity' | 'Movement type'      | 'Amount'   | 'Is fixed' |
			| 'TRY'           | '0,312100' | '3,204101'     | 'No'                | '1'            | 'Reporting currency' | '108,44'   | 'Yes'      |
			| 'TRY'           | '1,000000' | '1,000000'     | 'No'                | '1'            | 'Local currency'     | '347,46'   | 'No'       |			
		And I close "Edit hidden tables" window
		And I delete "$$NumberRevenueAccruals5$$" variable
		And I delete "$$RevenueAccruals5$$" variable
		And I save the value of "Number" field as "$$NumberRevenueAccruals5$$"
		And I save the window as "$$RevenueAccruals5$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberRevenueAccruals5$$'|
	And I close all client application windows 