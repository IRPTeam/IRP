#language: en
@tree
@Positive
@Movements3
@MovementsExpenseRevenueAccruals

Feature: check Expense and revenue accruals movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _051300 preparation (ExpenseRevenueAccruals)
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
			| "Documents.ExpenseAccruals.FindByNumber(173).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ExpenseAccruals.FindByNumber(174).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ExpenseAccruals.FindByNumber(175).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(172).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(174).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(175).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RevenueAccruals.FindByNumber(176).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _0513001 check preparation
	When check preparation

Scenario: _0513002 check Expense accruals movements by the Register "R5022 Expenses" (without basis)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '170'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                    | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                              | '30.04.2024 12:30:37' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '100'    | ''                  | ''            | ''                          |
			| ''                                              | '30.04.2024 12:30:37' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '100'    | ''                  | ''            | ''                          |
			| ''                                              | '30.04.2024 12:30:37' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '19,12'  | ''                  | ''            | ''                          |
	And I close all client application windows

Scenario: _0513003 check Expense accruals movements by the Register "R6070 Other periods expenses" (without basis)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '170'       |
	* Check movements by the Register  "R6070 Other periods expenses" 
		And I click "Registrations report info" button
		And I select "R6070 Other periods expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| 'Register  "R6070 Other periods expenses"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period expense type' | 'Expense type' | 'Profit loss center' | 'Amount' | 'Amount tax' |
			| ''                                              | '30.04.2024 12:30:37' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Expense accruals'          | 'Expense'      | 'Front office'       | '100'    | ''           |
			| ''                                              | '30.04.2024 12:30:37' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Expense accruals'          | 'Expense'      | 'Front office'       | '100'    | ''           |
			| ''                                              | '30.04.2024 12:30:37' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Expense accruals'          | 'Expense'      | 'Front office'       | '19,12'  | ''           |			
	And I close all client application windows
#
Scenario: _0513004 check Expense accruals movements by the Register "R5022 Expenses" (Void)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '173'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 173 dated 02.05.2024 18:00:06' | ''                    | ''             | ''             | ''                        | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                    | ''                    | ''             | ''             | ''                        | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center'      | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                              | '02.05.2024 18:00:06' | 'Main Company' | 'Front office' | 'Front office'            | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '-100'   | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:06' | 'Main Company' | 'Front office' | 'Front office'            | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-100'   | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:06' | 'Main Company' | 'Front office' | 'Front office'            | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-18,12' | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:06' | 'Main Company' | 'Front office' | 'Distribution department' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '-80'    | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:06' | 'Main Company' | 'Front office' | 'Distribution department' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-80'    | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:06' | 'Main Company' | 'Front office' | 'Distribution department' | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-14,5'  | ''                  | ''            | ''                          |
	And I close all client application windows

Scenario: _0513005 check Expense accruals movements by the Register "R6070 Other periods expenses" (Void)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '173'       |
	* Check movements by the Register  "R6070 Other periods expenses" 
		And I click "Registrations report info" button
		And I select "R6070 Other periods expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 173 dated 02.05.2024 18:00:06' | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                        | ''       | ''           |
			| 'Register  "R6070 Other periods expenses"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                        | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period expense type' | 'Expense type' | 'Profit loss center'      | 'Amount' | 'Amount tax' |
			| ''                                              | '02.05.2024 18:00:06' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 171 dated 30.04.2024 14:01:53' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Expense accruals'          | 'Expense'      | 'Front office'            | '-100'   | ''           |
			| ''                                              | '02.05.2024 18:00:06' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 171 dated 30.04.2024 14:01:53' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Expense accruals'          | 'Expense'      | 'Distribution department' | '-80'    | ''           |
			| ''                                              | '02.05.2024 18:00:06' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 171 dated 30.04.2024 14:01:53' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Expense accruals'          | 'Expense'      | 'Front office'            | '-100'   | ''           |
			| ''                                              | '02.05.2024 18:00:06' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 171 dated 30.04.2024 14:01:53' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Expense accruals'          | 'Expense'      | 'Distribution department' | '-80'    | ''           |
			| ''                                              | '02.05.2024 18:00:06' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 171 dated 30.04.2024 14:01:53' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Expense accruals'          | 'Expense'      | 'Front office'            | '-18,12' | ''           |
			| ''                                              | '02.05.2024 18:00:06' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 171 dated 30.04.2024 14:01:53' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Expense accruals'          | 'Expense'      | 'Distribution department' | '-14,5'  | ''           |	
	And I close all client application windows

#
Scenario: _0513006 check Expense accruals movements by the Register "R5022 Expenses" (Reverse)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '174'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 174 dated 02.05.2024 18:00:55' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                    | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                              | '02.05.2024 18:00:55' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '-100'   | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:55' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-100'   | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:00:55' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-19,12' | ''                  | ''            | ''                          |
	And I close all client application windows

Scenario: _0513007 check Expense accruals movements by the Register "R6070 Other periods expenses" (Reverse)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '174'       |
	* Check movements by the Register  "R6070 Other periods expenses" 
		And I click "Registrations report info" button
		And I select "R6070 Other periods expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 174 dated 02.05.2024 18:00:55' | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| 'Register  "R6070 Other periods expenses"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period expense type' | 'Expense type' | 'Profit loss center' | 'Amount' | 'Amount tax' |
			| ''                                              | '02.05.2024 18:00:55' | 'Receipt'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Expense accruals'          | 'Expense'      | 'Front office'       | '100'    | ''           |
			| ''                                              | '02.05.2024 18:00:55' | 'Receipt'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Expense accruals'          | 'Expense'      | 'Front office'       | '100'    | ''           |
			| ''                                              | '02.05.2024 18:00:55' | 'Receipt'    | 'Main Company' | 'Front office' | '                                    ' | 'Expense accrual 170 dated 30.04.2024 12:30:37' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Expense accruals'          | 'Expense'      | 'Front office'       | '19,12'  | ''           |	
	And I close all client application windows

#
Scenario: _0513008 check Expense accruals movements by the Register "R5022 Expenses" (with PI)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '175'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 175 dated 02.05.2024 18:01:03' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                    | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                              | '02.05.2024 18:01:03' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '1 000'  | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:01:03' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '1 000'  | ''                  | ''            | ''                          |
			| ''                                              | '02.05.2024 18:01:03' | 'Main Company' | 'Front office' | 'Front office'       | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '251,71' | ''                  | ''            | ''                          |
	And I close all client application windows

Scenario: _0513009 check Expense accruals movements by the Register "R6070 Other periods expenses" (with PI)
		And I close all client application windows
	* Select Expense accruals
		Given I open hyperlink "e1cib/list/Document.ExpenseAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '175'       |
	* Check movements by the Register  "R6070 Other periods expenses" 
		And I click "Registrations report info" button
		And I select "R6070 Other periods expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Expense accrual 175 dated 02.05.2024 18:01:03' | ''                    | ''           | ''             | ''             | ''                                     | ''                                               | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| 'Register  "R6070 Other periods expenses"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                               | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                          | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period expense type' | 'Expense type' | 'Profit loss center' | 'Amount' | 'Amount tax' |
			| ''                                              | '02.05.2024 18:01:03' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Purchase invoice 171 dated 30.04.2024 12:55:27' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Expense accruals'          | 'Expense'      | 'Front office'       | '1 000'  | ''           |
			| ''                                              | '02.05.2024 18:01:03' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Purchase invoice 171 dated 30.04.2024 12:55:27' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Expense accruals'          | 'Expense'      | 'Front office'       | '1 000'  | ''           |
			| ''                                              | '02.05.2024 18:01:03' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Purchase invoice 171 dated 30.04.2024 12:55:27' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Expense accruals'          | 'Expense'      | 'Front office'       | '251,71' | ''           |	
	And I close all client application windows

Scenario: _0513010 check Revenue accruals movements by the Register "R5021 Revenues" (without basis)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '171'       |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                    | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                              | '01.05.2024 18:35:11' | 'Main Company' | 'Front office' | 'Front office'       | 'Software'     | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '100'    | ''                  |
			| ''                                              | '01.05.2024 18:35:11' | 'Main Company' | 'Front office' | 'Front office'       | 'Software'     | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        | '100'    | ''                  |
			| ''                                              | '01.05.2024 18:35:11' | 'Main Company' | 'Front office' | 'Front office'       | 'Software'     | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '17,12'  | ''                  |
	And I close all client application windows

Scenario: _0513011 check Revenue accruals movements by the Register "R6080 Other periods revenues" (without basis)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '171'       |
	* Check movements by the Register  "R6080 Other periods revenues" 
		And I click "Registrations report info" button
		And I select "R6080 Other periods revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| 'Register  "R6080 Other periods revenues"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period revenue type' | 'Revenue type' | 'Profit loss center' | 'Amount' | 'Amount tax' |
			| ''                                              | '01.05.2024 18:35:11' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Revenue accruals'          | 'Software'     | 'Front office'       | '100'    | ''           |
			| ''                                              | '01.05.2024 18:35:11' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Revenue accruals'          | 'Software'     | 'Front office'       | '100'    | ''           |
			| ''                                              | '01.05.2024 18:35:11' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Revenue accruals'          | 'Software'     | 'Front office'       | '17,12'  | ''           |		
	And I close all client application windows
#
Scenario: _0513012 check Revenue accruals movements by the Register "R5021 Revenues" (Void)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '174'       |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 174 dated 02.05.2024 18:04:29' | ''                    | ''             | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                    | ''                    | ''             | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center'      | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                              | '02.05.2024 18:04:29' | 'Main Company' | 'Front office' | 'Front office'            | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '-100'   | ''                  |
			| ''                                              | '02.05.2024 18:04:29' | 'Main Company' | 'Front office' | 'Front office'            | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-100'   | ''                  |
			| ''                                              | '02.05.2024 18:04:29' | 'Main Company' | 'Front office' | 'Front office'            | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-19,12' | ''                  |
			| ''                                              | '02.05.2024 18:04:29' | 'Main Company' | 'Front office' | 'Distribution department' | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '-80'    | ''                  |
			| ''                                              | '02.05.2024 18:04:29' | 'Main Company' | 'Front office' | 'Distribution department' | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-80'    | ''                  |
			| ''                                              | '02.05.2024 18:04:29' | 'Main Company' | 'Front office' | 'Distribution department' | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-15,3'  | ''                  |
	And I close all client application windows

Scenario: _0513013 check Revenue accruals movements by the Register "R6080 Other periods revenues" (Void)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '174'       |
	* Check movements by the Register  "R6080 Other periods revenues" 
		And I click "Registrations report info" button
		And I select "R6080 Other periods revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 174 dated 02.05.2024 18:04:29' | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                        | ''       | ''           |
			| 'Register  "R6080 Other periods revenues"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                        | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period revenue type' | 'Revenue type' | 'Profit loss center'      | 'Amount' | 'Amount tax' |
			| ''                                              | '02.05.2024 18:04:29' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 172 dated 01.05.2024 18:43:16' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Revenue accruals'          | 'Revenue'      | 'Front office'            | '-100'   | ''           |
			| ''                                              | '02.05.2024 18:04:29' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 172 dated 01.05.2024 18:43:16' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Revenue accruals'          | 'Revenue'      | 'Distribution department' | '-80'    | ''           |
			| ''                                              | '02.05.2024 18:04:29' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 172 dated 01.05.2024 18:43:16' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Revenue accruals'          | 'Revenue'      | 'Front office'            | '-100'   | ''           |
			| ''                                              | '02.05.2024 18:04:29' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 172 dated 01.05.2024 18:43:16' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Revenue accruals'          | 'Revenue'      | 'Distribution department' | '-80'    | ''           |
			| ''                                              | '02.05.2024 18:04:29' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 172 dated 01.05.2024 18:43:16' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Revenue accruals'          | 'Revenue'      | 'Front office'            | '-19,12' | ''           |
			| ''                                              | '02.05.2024 18:04:29' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 172 dated 01.05.2024 18:43:16' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Revenue accruals'          | 'Revenue'      | 'Distribution department' | '-15,3'  | ''           |	
	And I close all client application windows

#
Scenario: _0513014 check Revenue accruals movements by the Register "R5021 Revenues" (Reverse)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '175'       |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 175 dated 02.05.2024 18:08:21' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                    | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                              | '02.05.2024 18:08:21' | 'Main Company' | 'Front office' | 'Front office'       | 'Software'     | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '-100'   | ''                  |
			| ''                                              | '02.05.2024 18:08:21' | 'Main Company' | 'Front office' | 'Front office'       | 'Software'     | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-100'   | ''                  |
			| ''                                              | '02.05.2024 18:08:21' | 'Main Company' | 'Front office' | 'Front office'       | 'Software'     | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-17,12' | ''                  |
	And I close all client application windows

Scenario: _0513015 check Revenue accruals movements by the Register "R6080 Other periods revenues" (Reverse)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '175'       |
	* Check movements by the Register  "R6080 Other periods revenues" 
		And I click "Registrations report info" button
		And I select "R6080 Other periods revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 175 dated 02.05.2024 18:08:21' | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| 'Register  "R6080 Other periods revenues"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                              | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                         | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period revenue type' | 'Revenue type' | 'Profit loss center' | 'Amount' | 'Amount tax' |
			| ''                                              | '02.05.2024 18:08:21' | 'Receipt'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Revenue accruals'          | 'Software'     | 'Front office'       | '100'    | ''           |
			| ''                                              | '02.05.2024 18:08:21' | 'Receipt'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Revenue accruals'          | 'Software'     | 'Front office'       | '100'    | ''           |
			| ''                                              | '02.05.2024 18:08:21' | 'Receipt'    | 'Main Company' | 'Front office' | '                                    ' | 'Revenue accrual 171 dated 01.05.2024 18:35:11' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Revenue accruals'          | 'Software'     | 'Front office'       | '17,12'  | ''           |	
	And I close all client application windows

#
Scenario: _0513016 check Revenue accruals movements by the Register "R5021 Revenues" (with SI)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '176'       |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 176 dated 02.05.2024 18:10:47' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| 'Register  "R5021 Revenues"'                    | ''                    | ''             | ''             | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  |
			| ''                                              | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' |
			| ''                                              | '02.05.2024 18:10:47' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        | '500'    | ''                  |
			| ''                                              | '02.05.2024 18:10:47' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        | '500'    | ''                  |
			| ''                                              | '02.05.2024 18:10:47' | 'Main Company' | 'Front office' | 'Front office'       | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        | '156,05' | ''                  |
	And I close all client application windows

Scenario: _0513017 check Revenue accruals movements by the Register "R6080 Other periods revenues" (with SI)
		And I close all client application windows
	* Select Revenue accruals
		Given I open hyperlink "e1cib/list/Document.RevenueAccruals"
		And I go to line in "List" table
			| 'Number'    |
			| '176'       |
	* Check movements by the Register  "R6080 Other periods revenues" 
		And I click "Registrations report info" button
		And I select "R6080 Other periods revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Revenue accrual 176 dated 02.05.2024 18:10:47' | ''                    | ''           | ''             | ''             | ''                                     | ''                                            | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| 'Register  "R6080 Other periods revenues"'      | ''                    | ''           | ''             | ''             | ''                                     | ''                                            | ''         | ''         | ''                     | ''                        | ''                          | ''             | ''                   | ''       | ''           |
			| ''                                              | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Row ID'                               | 'Basis'                                       | 'Item key' | 'Currency' | 'Transaction currency' | 'Currency movement type'  | 'Other period revenue type' | 'Revenue type' | 'Profit loss center' | 'Amount' | 'Amount tax' |
			| ''                                              | '02.05.2024 18:10:47' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Sales invoice 171 dated 30.04.2024 13:36:19' | ''         | 'TRY'      | 'TRY'                  | 'Local currency'          | 'Revenue accruals'          | 'Revenue'      | 'Front office'       | '500'    | ''           |
			| ''                                              | '02.05.2024 18:10:47' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Sales invoice 171 dated 30.04.2024 13:36:19' | ''         | 'TRY'      | 'TRY'                  | 'en description is empty' | 'Revenue accruals'          | 'Revenue'      | 'Front office'       | '500'    | ''           |
			| ''                                              | '02.05.2024 18:10:47' | 'Expense'    | 'Main Company' | 'Front office' | '                                    ' | 'Sales invoice 171 dated 30.04.2024 13:36:19' | ''         | 'USD'      | 'TRY'                  | 'Reporting currency'      | 'Revenue accruals'          | 'Revenue'      | 'Front office'       | '156,05' | ''           |		
	And I close all client application windows