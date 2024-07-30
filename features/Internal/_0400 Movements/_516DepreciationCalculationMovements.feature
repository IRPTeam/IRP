#language: en
@tree
@Positive
@Movements3
@MovementsDepreciationCalculation

Feature: check Expense and revenue accruals movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _051600 preparation (DepreciationCalculation movements)
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
		When Create document CommissioningOfFixedAsset objects (movements)
		When Create document DepreciationCalculation objects (movements)
		* Posting Purchase invoice
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(78).GetObject().Write(DocumentWriteMode.Posting);"    |
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(79).GetObject().Write(DocumentWriteMode.Posting);"    |
		* Posting Calculation movement costs
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			Then "Calculations movement costs" window is opened
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "5"
		* Posting Commissioning of fixed asset
			Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "2"
		* Reposting Calculation movement costs
			Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
			Then "Calculations movement costs" window is opened
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "5"
		* Posting Depreciation calculation
			Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
			Then I select all lines of "List" table
			And in the table "List" I click the button named "ListContextMenuPost"
			And Delay "2"

Scenario: _051601 check preparation
	When check preparation

Scenario: _051602 check Depreciation calculation movements by the Register "R5022 Expenses"
		And I close all client application windows
	* Select Depreciation calculation
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Depreciation calculation 11 dated 29.02.2024 12:00:00' | ''                    | ''             | ''             | ''                     | ''             | ''         | ''                 | ''                                     | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                            | ''                    | ''             | ''             | ''                     | ''             | ''         | ''                 | ''                                     | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                                      | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Expense type' | 'Item key' | 'Fixed asset'      | 'Ledger type'                          | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                                      | '29.02.2024 12:00:00' | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'TRY'      | ''                    | 'Local currency'               | ''        | '277,78' | ''                  | ''            | ''                          |
			| ''                                                      | '29.02.2024 12:00:00' | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'TRY'      | ''                    | 'en description is empty'      | ''        | '277,78' | ''                  | ''            | ''                          |
			| ''                                                      | '29.02.2024 12:00:00' | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'USD'      | ''                    | 'Reporting currency'           | ''        | '47,56'  | ''                  | ''            | ''                          |		
	And I close all client application windows

Scenario: _051603 check Depreciation calculation movements by the Register "R8510 Book value of fixed asset"
		And I close all client application windows
	* Select Depreciation calculation
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R8510 Book value of fixed asset" 
		And I click "Registrations report info" button
		And I select "R8510 Book value of fixed asset" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Depreciation calculation 11 dated 29.02.2024 12:00:00' | ''                    | ''           | ''             | ''             | ''                     | ''                 | ''                                     | ''                          | ''         | ''                        | ''                     | ''       | ''                          |
			| 'Register  "R8510 Book value of fixed asset"'           | ''                    | ''           | ''             | ''             | ''                     | ''                 | ''                                     | ''                          | ''         | ''                        | ''                     | ''       | ''                          |
			| ''                                                      | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Fixed asset'      | 'Ledger type'                          | 'Schedule'                  | 'Currency' | 'Currency movement type'  | 'Transaction currency' | 'Amount' | 'Calculation movement cost' |
			| ''                                                      | '29.02.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'TRY'      | 'Local currency'          | 'TRY'                  | '277,78' | ''                          |
			| ''                                                      | '29.02.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'TRY'      | 'en description is empty' | 'TRY'                  | '277,78' | ''                          |
			| ''                                                      | '29.02.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'USD'      | 'Reporting currency'      | 'TRY'                  | '47,56'  | ''                          |		
	And I close all client application windows


Scenario: _051604 check Depreciation calculation movements by the Register "T1040 Accounting amounts"
		And I close all client application windows
	* Select Depreciation calculation
		Given I open hyperlink "e1cib/list/Document.DepreciationCalculation"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "T1040 Accounting amounts" 
		And I click "Registrations report info" button
		And I select "T1040 Accounting amounts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Depreciation calculation 11 dated 29.02.2024 12:00:00' | ''                    | ''        | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''       | ''                   | ''                   | ''                     | ''                 |
			| 'Register  "T1040 Accounting amounts"'                  | ''                    | ''        | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''       | ''                   | ''                   | ''                     | ''                 |
			| ''                                                      | 'Period'              | 'Row key' | 'Operation'               | 'Multi currency movement type' | 'Currency' | 'Revaluated currency' | 'Dr currency' | 'Cr currency' | 'Amount' | 'Dr currency amount' | 'Cr currency amount' | 'Deferred calculation' | 'Advances closing' |
			| ''                                                      | '29.02.2024 12:00:00' | '*'       | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | ''            | ''            | '277,78' | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                      | '29.02.2024 12:00:00' | '*'       | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | ''            | ''            | '47,56'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                      | '29.02.2024 12:00:00' | '*'       | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | ''            | ''            | '277,78' | ''                   | ''                   | 'No'                   | ''                 |
	And I close all client application windows