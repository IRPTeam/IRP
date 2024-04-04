#language: en
@tree
@Positive
@Movements
@MovementsPayroll


Feature: check Payroll movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040990 preparation (payroll movements)
	When set True value to the constant
	When set True value to the constant use salary
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create PaymentType (advance)
		When Create catalog PaymentTypes objects
		When Create catalog PlanningPeriods objects
		When Create catalog BankTerms objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog RetailCustomers objects (check POS)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog CashAccounts objects
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create catalog CancelReturnReasons objects
	* Data for salary
		When Create catalog EmployeePositions objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register T9500S_AccrualAndDeductionValues records
		When create Payroll object (movements)
		And I execute 1C:Enterprise script at server
			| "Documents.Payroll.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _040991 check Payroll movements by the Register  "R3027 Employee cash advance"
		And I close all client application windows
	* Select Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Payroll 4 dated 27.04.2023 12:39:37'       | ''              | ''                      | ''            | ''               | ''               | ''           | ''                       | ''                | ''                               | ''                        |
			| 'Document registrations records'            | ''              | ''                      | ''            | ''               | ''               | ''           | ''                       | ''                | ''                               | ''                        |
			| 'Register  "R3027 Employee cash advance"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                       | ''                | ''                               | ''                        |
			| ''                                          | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                       | ''                | ''                               | 'Attributes'              |
			| ''                                          | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Transaction currency'   | 'Partner'         | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                          | 'Expense'       | '27.04.2023 12:39:37'   | '11,98'       | 'Main Company'   | 'Front office'   | 'USD'        | 'TRY'                    | 'David Romanov'   | 'Reporting currency'             | 'No'                      |
			| ''                                          | 'Expense'       | '27.04.2023 12:39:37'   | '70'          | 'Main Company'   | 'Front office'   | 'TRY'        | 'TRY'                    | 'David Romanov'   | 'Local currency'                 | 'No'                      |
			| ''                                          | 'Expense'       | '27.04.2023 12:39:37'   | '70'          | 'Main Company'   | 'Front office'   | 'TRY'        | 'TRY'                    | 'David Romanov'   | 'en description is empty'        | 'No'                      |
		And I close all client application windows
		
				
Scenario: _040992 check Payroll movements by the Register  "R5021 Revenues"
		And I close all client application windows
	* Select Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Payroll 4 dated 27.04.2023 12:39:37' | ''                    | ''          | ''                  | ''             | ''             | ''                     | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Document registrations records'      | ''                    | ''          | ''                  | ''             | ''             | ''                     | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Register  "R5021 Revenues"'          | ''                    | ''          | ''                  | ''             | ''             | ''                     | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                    | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''             | ''                     | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                    | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' |
			| ''                                    | '27.04.2023 12:39:37' | '8,56'      | ''                  | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                    | '27.04.2023 12:39:37' | '50'        | ''                  | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                    | '27.04.2023 12:39:37' | '50'        | ''                  | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        |
		And I close all client application windows		

Scenario: _040993 check Payroll movements by the Register  "R5022 Expenses"
		And I close all client application windows
	* Select Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Payroll 4 dated 27.04.2023 12:39:37' | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'          | ''                    | ''             | ''             | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                    | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '-30'    | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '800'    | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | '1 500'  | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '-30'    | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '800'    | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | '1 500'  | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '-5,14'  | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '136,96' | ''                  | ''            | ''                          |
			| ''                                    | '27.04.2023 12:39:37' | 'Main Company' | 'Front office' | 'Accountants office' | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | '256,8'  | ''                  | ''            | ''                          |	
		And I close all client application windows


Scenario: _040994 check Payroll movements by the Register  "R9510 Salary payment"
		And I close all client application windows
	* Select Payroll
		Given I open hyperlink "e1cib/list/Document.Payroll"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Payroll 4 dated 27.04.2023 12:39:37'   | ''              | ''                      | ''            | ''               | ''               | ''                  | ''                      | ''           | ''                       | ''                                |
			| 'Document registrations records'        | ''              | ''                      | ''            | ''               | ''               | ''                  | ''                      | ''           | ''                       | ''                                |
			| 'Register  "R9510 Salary payment"'      | ''              | ''                      | ''            | ''               | ''               | ''                  | ''                      | ''           | ''                       | ''                                |
			| ''                                      | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                  | ''                      | ''           | ''                       | ''                                |
			| ''                                      | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Employee'          | 'Payment period'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'    |
			| ''                                      | 'Receipt'       | '27.04.2023 12:39:37'   | '136,96'      | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                      | 'Receipt'       | '27.04.2023 12:39:37'   | '256,8'       | 'Main Company'   | 'Front office'   | 'Alexander Orlov'   | 'Third (only salary)'   | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                      | 'Receipt'       | '27.04.2023 12:39:37'   | '800'         | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                      | 'Receipt'       | '27.04.2023 12:39:37'   | '800'         | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'en description is empty'         |
			| ''                                      | 'Receipt'       | '27.04.2023 12:39:37'   | '1 500'       | 'Main Company'   | 'Front office'   | 'Alexander Orlov'   | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                      | 'Receipt'       | '27.04.2023 12:39:37'   | '1 500'       | 'Main Company'   | 'Front office'   | 'Alexander Orlov'   | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'en description is empty'         |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '5,14'        | 'Main Company'   | 'Front office'   | 'Alexander Orlov'   | 'Third (only salary)'   | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '8,56'        | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '11,98'       | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '30'          | 'Main Company'   | 'Front office'   | 'Alexander Orlov'   | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '30'          | 'Main Company'   | 'Front office'   | 'Alexander Orlov'   | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'en description is empty'         |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '50'          | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '50'          | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'en description is empty'         |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '70'          | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                      | 'Expense'       | '27.04.2023 12:39:37'   | '70'          | 'Main Company'   | 'Front office'   | 'David Romanov'     | 'Third (only salary)'   | 'TRY'        | 'TRY'                    | 'en description is empty'         |
		And I close all client application windows
