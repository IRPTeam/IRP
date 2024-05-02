#language: en
@tree
@Positive
@Movements
@MovementsEmployeeCashAdvance


Feature: check Employee cash advance movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040910 preparation (Employee cash advance movements)
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
		When Create catalog SalaryCalculationType objects
		When Create catalog Taxes objects (Salary tax)
		When Create catalog Partners, Companies, Agreements for Tax authority
		When Create information register Taxes records (VAT)
		When Create catalog CancelReturnReasons objects
	* Data for employee cash adance
		When Create catalog EmployeePositions objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create information register T9500S_AccrualAndDeductionValues records
		When create EmployeeCashAdvance object (movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(213).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.EmployeeCashAdvance.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.VendorsAdvancesClosing.FindByNumber(213).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _040911 check preparation (Employee cash advance movements)
	When check preparation

Scenario: _040912 check EmployeeCashAdvance movements by the Register  "R3027 Employee cash advance"
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                     | ''                | ''                             | ''                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                     | ''                | ''                             | ''                     |
			| 'Register  "R3027 Employee cash advance"'           | ''            | ''                    | ''          | ''             | ''                        | ''         | ''                     | ''                | ''                             | ''                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                     | ''                | ''                             | 'Attributes'           |
			| ''                                                  | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Currency' | 'Transaction currency' | 'Partner'         | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '13,7'      | 'Main Company' | 'Distribution department' | 'USD'      | 'TRY'                  | 'Alexander Orlov' | 'Reporting currency'           | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '17,12'     | 'Main Company' | 'Distribution department' | 'USD'      | 'TRY'                  | 'Alexander Orlov' | 'Reporting currency'           | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '20,2'      | 'Main Company' | 'Distribution department' | 'USD'      | 'TRY'                  | 'Alexander Orlov' | 'Reporting currency'           | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '80'        | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'Local currency'               | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '80'        | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'en description is empty'      | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '100'       | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'Local currency'               | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '100'       | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'en description is empty'      | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'Local currency'               | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'TRY'                          | 'No'                   |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'TRY'      | 'TRY'                  | 'Alexander Orlov' | 'en description is empty'      | 'No'                   |	
		And I close all client application windows

Scenario: _040913 check EmployeeCashAdvance movements by the Register  "R5022 Expenses"
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Document registrations records'                    | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| 'Register  "R5022 Expenses"'                        | ''                    | ''          | ''                  | ''            | ''             | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | ''                          |
			| ''                                                  | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''                        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''        | 'Attributes'                |
			| ''                                                  | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'                  | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Calculation movement cost' |
			| ''                                                  | '02.05.2024 10:12:05' | '13,7'      | '13,7'              | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Delivery'     | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                                  | '02.05.2024 10:12:05' | '17,12'     | '17,12'             | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Fuel'         | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''        | ''                          |
			| ''                                                  | '02.05.2024 10:12:05' | '80'        | '80'                | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Delivery'     | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |
			| ''                                                  | '02.05.2024 10:12:05' | '80'        | '80'                | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Delivery'     | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | ''                          |
			| ''                                                  | '02.05.2024 10:12:05' | '100'       | '100'               | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Fuel'         | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''        | ''                          |
			| ''                                                  | '02.05.2024 10:12:05' | '100'       | '100'               | ''            | 'Main Company' | 'Distribution department' | 'Front office'       | 'Fuel'         | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''        | ''                          |	
		And I close all client application windows

Scenario: _040913 check EmployeeCashAdvance movements by the Register  "R1021 Vendors transactions" (with PI)
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''           | ''        | ''                        | ''                                               | ''      | ''        | ''                     | ''                         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''           | ''        | ''                        | ''                                               | ''      | ''        | ''                     | ''                         |
			| 'Register  "R1021 Vendors transactions"'            | ''            | ''                    | ''          | ''             | ''                        | ''                             | ''         | ''                     | ''           | ''        | ''                        | ''                                               | ''      | ''        | ''                     | ''                         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''                             | ''         | ''                     | ''           | ''        | ''                        | ''                                               | ''      | ''        | 'Attributes'           | ''                         |
			| ''                                                  | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner' | 'Agreement'               | 'Basis'                                          | 'Order' | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '20,2'      | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'DFC'        | 'DFC'     | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | ''      | ''        | 'No'                   | ''                         |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'DFC'        | 'DFC'     | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | ''      | ''        | 'No'                   | ''                         |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'DFC'        | 'DFC'     | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | ''      | ''        | 'No'                   | ''                         |
			| ''                                                  | 'Expense'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'DFC'        | 'DFC'     | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | ''      | ''        | 'No'                   | ''                         |	
		And I close all client application windows

Scenario: _040914 check EmployeeCashAdvance movements by the Register  "R5010 Reconciliation statement" (with PI)
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5010 Reconciliation statements" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''            | ''                    | ''          | ''             | ''                        | ''         | ''           | ''                    |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                        | ''         | ''           | ''                    |
			| 'Register  "R5010 Reconciliation statement"'        | ''            | ''                    | ''          | ''             | ''                        | ''         | ''           | ''                    |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''         | ''           | ''                    |
			| ''                                                  | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Currency' | 'Legal name' | 'Legal name contract' |
			| ''                                                  | 'Receipt'     | '02.05.2024 10:12:05' | '118'       | 'Main Company' | 'Distribution department' | 'TRY'      | 'DFC'        | ''                    |	
		And I close all client application windows

Scenario: _040915 check EmployeeCashAdvance movements by the Register  "R5020 Partners balance" (with PI)
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''                        | ''        | ''           | ''                        | ''                                               | ''         | ''                             | ''                     | ''                 |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''                        | ''        | ''           | ''                        | ''                                               | ''         | ''                             | ''                     | ''                 |
			| 'Register  "R5020 Partners balance"'                | ''            | ''                    | ''          | ''                     | ''                 | ''                   | ''               | ''                  | ''             | ''                        | ''        | ''           | ''                        | ''                                               | ''         | ''                             | ''                     | ''                 |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''                     | ''                 | ''                   | ''               | ''                  | 'Dimensions'   | ''                        | ''        | ''           | ''                        | ''                                               | ''         | ''                             | ''                     | 'Attributes'       |
			| ''                                                  | ''            | ''                    | 'Amount'    | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Company'      | 'Branch'                  | 'Partner' | 'Legal name' | 'Agreement'               | 'Document'                                       | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Advances closing' |
			| ''                                                  | 'Receipt'     | '02.05.2024 10:12:05' | '20,2'      | ''                     | ''                 | '20,2'               | ''               | ''                  | 'Main Company' | 'Distribution department' | 'DFC'     | 'DFC'        | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | 'USD'      | 'Reporting currency'           | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.05.2024 10:12:05' | '118'       | ''                     | ''                 | '118'                | ''               | ''                  | 'Main Company' | 'Distribution department' | 'DFC'     | 'DFC'        | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | 'TRY'      | 'Local currency'               | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.05.2024 10:12:05' | '118'       | ''                     | ''                 | '118'                | ''               | ''                  | 'Main Company' | 'Distribution department' | 'DFC'     | 'DFC'        | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | 'TRY'      | 'TRY'                          | 'TRY'                  | ''                 |
			| ''                                                  | 'Receipt'     | '02.05.2024 10:12:05' | '118'       | ''                     | ''                 | '118'                | ''               | ''                  | 'Main Company' | 'Distribution department' | 'DFC'     | 'DFC'        | 'Partner term vendor DFC' | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | 'TRY'      | 'en description is empty'      | 'TRY'                  | ''                 |	
		And I close all client application windows

Scenario: _040915 check EmployeeCashAdvance movements by the Register  "T2015 Transactions info" (with PI)
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''    | ''         | ''        | ''           | ''                        | ''                      | ''                        | ''                                               | ''          | ''        |
			| 'Document registrations records'                    | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''    | ''         | ''        | ''           | ''                        | ''                      | ''                        | ''                                               | ''          | ''        |
			| 'Register  "T2015 Transactions info"'               | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''    | ''         | ''        | ''           | ''                        | ''                      | ''                        | ''                                               | ''          | ''        |
			| ''                                                  | 'Resources' | ''       | ''        | 'Dimensions'   | ''                        | ''      | ''                    | ''    | ''         | ''        | ''           | ''                        | ''                      | ''                        | ''                                               | ''          | ''        |
			| ''                                                  | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name' | 'Agreement'               | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                              | 'Unique ID' | 'Project' |
			| ''                                                  | '118'       | 'No'     | 'Yes'     | 'Main Company' | 'Distribution department' | ''      | '02.05.2024 10:12:05' | '*'   | 'TRY'      | 'DFC'     | 'DFC'        | 'Partner term vendor DFC' | 'Yes'                   | 'No'                      | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | '*'         | ''        |
		And I close all client application windows

Scenario: _040916 check EmployeeCashAdvance movements by the Register  "R5012 Vendors aging" (with PI)
		And I close all client application windows
	* Select EmployeeCashAdvance
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5012 Vendors aging" 
		And I click "Registrations report info" button
		And I select "R5012 Vendors aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Employee cash advance 1 dated 02.05.2024 10:12:05' | ''                    | ''           | ''             | ''                        | ''         | ''                        | ''        | ''                                               | ''                    | ''       | ''                                                     |
			| 'Register  "R5012 Vendors aging"'                   | ''                    | ''           | ''             | ''                        | ''         | ''                        | ''        | ''                                               | ''                    | ''       | ''                                                     |
			| ''                                                  | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Currency' | 'Agreement'               | 'Partner' | 'Invoice'                                        | 'Payment date'        | 'Amount' | 'Aging closing'                                        |
			| ''                                                  | '02.05.2024 10:12:05' | 'Expense'    | 'Main Company' | 'Distribution department' | 'TRY'      | 'Partner term vendor DFC' | 'DFC'     | 'Purchase invoice 213 dated 01.05.2024 12:00:00' | '02.05.2024 00:00:00' | '118'    | 'Vendors advances closing 213 dated 02.05.2024 15:34:27' |	
		And I close all client application windows