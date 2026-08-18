#language: en
@tree
@Positive
@Movements3
@MovementsFixedAssetRevaluation

Feature: check Fixed asset revaluation movements



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _051700 preparation (FixedAssetRevaluation movements)
	When set True value to the constant
	When set True value to the constant Use fixed assets
	When set True value to the constant Use accounting
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
		* Create Fixed asset revaluation
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
			And I click the button named "FormCreate"
			And I select from the drop-down list named "Company" by "Main Company" string
			And I move to the tab named "GroupOther"
			And I input "30.04.2024 12:00:00" text in the field named "Date"
			And I move to the tab named "GroupMore"
			And I select from the drop-down list named "Branch" by "Front office" string
			And I move to the tab named "GroupCalculations"
			And in the table "Calculations" I click the button named "CalculationsFillCalculations"
		* Mark down the first fixed asset
			And I go to line in "Calculations" table
				| 'Fixed asset'      |
				| 'Office Furniture' |
			And I select current line in "Calculations" table
			And I input "5 000,00" text in the field named "CalculationsNewAmountBalance" of "Calculations" table
			And I finish line editing in "Calculations" table
		* Mark up the second fixed asset
			And I go to line in "Calculations" table
				| 'Fixed asset'      |
				| 'Computer Servers' |
			And I select current line in "Calculations" table
			And I input "5 000,00" text in the field named "CalculationsNewAmountBalance" of "Calculations" table
			And I select "Revenue" by string from the drop-down list named "CalculationsRevenueType" in "Calculations" table
			And I finish line editing in "Calculations" table
		* Post
			And I click the button named "FormPostAndClose"
		And I close all client application windows

Scenario: _051701 check preparation
	When check preparation

Scenario: _051702 check Fixed asset revaluation movements by the Register "R8510 Book value of fixed asset"
	And I close all client application windows
	* Select Fixed asset revaluation
		Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements by the Register  "R8510 Book value of fixed asset"
		And I click "Registrations report info" button
		And I select "R8510 Book value of fixed asset" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | ''                    | ''           | ''             | ''             | ''                     | ''                 | ''                                          | ''                              | ''         | ''                        | ''                     | ''       | ''                          |
			| 'Register  "R8510 Book value of fixed asset"'         | ''                    | ''           | ''             | ''             | ''                     | ''                 | ''                                          | ''                              | ''         | ''                        | ''                     | ''       | ''                          |
			| ''                                                    | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Fixed asset'      | 'Ledger type'                               | 'Schedule'                      | 'Currency' | 'Currency movement type'  | 'Transaction currency' | 'Amount' | 'Calculation movement cost' |
			| ''                                                    | '30.04.2024 12:00:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)'      | 'Straight line (36 months)'     | 'TRY'      | 'Local currency'          | 'TRY'                  | '416,67' | ''                          |
			| ''                                                    | '30.04.2024 12:00:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)'      | 'Straight line (36 months)'     | 'TRY'      | 'en description is empty' | 'TRY'                  | '416,67' | ''                          |
			| ''                                                    | '30.04.2024 12:00:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)'      | 'Straight line (36 months)'     | 'USD'      | 'Reporting currency'      | 'TRY'                  | '71,33'  | ''                          |
			| ''                                                    | '30.04.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Office Furniture' | 'Furniture and Fixtures (with deprecation)' | 'Declining balance (60 months)' | 'TRY'      | 'Local currency'          | 'TRY'                  | '833,33' | ''                          |
			| ''                                                    | '30.04.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Office Furniture' | 'Furniture and Fixtures (with deprecation)' | 'Declining balance (60 months)' | 'TRY'      | 'en description is empty' | 'TRY'                  | '833,33' | ''                          |
			| ''                                                    | '30.04.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Office Furniture' | 'Furniture and Fixtures (with deprecation)' | 'Declining balance (60 months)' | 'USD'      | 'Reporting currency'      | 'TRY'                  | '142,67' | ''                          |
	And I close all client application windows

Scenario: _051703 check Fixed asset revaluation movements by the Register "R5022 Expenses"
	And I close all client application windows
	* Select Fixed asset revaluation
		Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements by the Register  "R5022 Expenses"
		And I click "Registrations report info" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | ''                    | ''             | ''             | ''                     | ''             | ''         | ''                 | ''                                          | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| 'Register  "R5022 Expenses"'                          | ''                    | ''             | ''             | ''                     | ''             | ''         | ''                 | ''                                          | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''            | ''                          |
			| ''                                                    | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Expense type' | 'Item key' | 'Fixed asset'      | 'Ledger type'                               | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Amount cost' | 'Calculation movement cost' |
			| ''                                                    | '30.04.2024 12:00:00' | 'Main Company' | 'Front office' | 'Logistics department' | 'Expense'      | ''         | 'Office Furniture' | 'Furniture and Fixtures (with deprecation)' | 'TRY'      | ''                    | 'en description is empty'      | ''        | '833,33' | '833,33'            | ''            | ''                          |
	And I close all client application windows

Scenario: _051704 check Fixed asset revaluation movements by the Register "R5021 Revenues"
	And I close all client application windows
	* Select Fixed asset revaluation
		Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report info" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | ''                    | ''             | ''             | ''                     | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''                          |
			| 'Register  "R5021 Revenues"'                          | ''                    | ''             | ''             | ''                     | ''             | ''         | ''         | ''                    | ''                             | ''        | ''       | ''                  | ''                          |
			| ''                                                    | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' | 'Amount' | 'Amount with taxes' | 'Calculation movement cost' |
			| ''                                                    | '30.04.2024 12:00:00' | 'Main Company' | 'Front office' | 'Logistics department' | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        | '416,67' | '416,67'            | ''                          |
	And I close all client application windows

Scenario: _051705 check Fixed asset revaluation movements by the Register "R8515 Cost of fixed asset"
	And I close all client application windows
	* Select Fixed asset revaluation
		Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements by the Register  "R8515 Cost of fixed asset"
		And I click "Registrations report info" button
		And I select "R8515 Cost of fixed asset" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | ''                    | ''             | ''                 | ''                                          | ''       | ''                          |
			| 'Register  "R8515 Cost of fixed asset"'               | ''                    | ''             | ''                 | ''                                          | ''       | ''                          |
			| ''                                                    | 'Period'              | 'Company'      | 'Fixed asset'      | 'Ledger type'                               | 'Amount' | 'Calculation movement cost' |
			| ''                                                    | '30.04.2024 12:00:00' | 'Main Company' | 'Office Furniture' | 'Furniture and Fixtures (with deprecation)' | '-2 000' | ''                          |
	And I close all client application windows

Scenario: _051706 check Fixed asset revaluation movements by the Register "T1040 Accounting amounts"
	And I close all client application windows
	* Select Fixed asset revaluation
		Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements by the Register  "T1040 Accounting amounts"
		And I click "Registrations report info" button
		And I select "T1040 Accounting amounts" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains lines
			| 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | ''                    | ''                                     | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''        | ''                   | ''                   | ''                     | ''                 |
			| 'Register  "T1040 Accounting amounts"'                | ''                    | ''                                     | ''                        | ''                             | ''         | ''                    | ''            | ''            | ''        | ''                   | ''                   | ''                     | ''                 |
			| ''                                                    | 'Period'              | 'Row key'                              | 'Operation'               | 'Multi currency movement type' | 'Currency' | 'Revaluated currency' | 'Dr currency' | 'Cr currency' | 'Amount'  | 'Dr currency amount' | 'Cr currency amount' | 'Deferred calculation' | 'Advances closing' |
			| ''                                                    | '30.04.2024 12:00:00' | '*' | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | ''            | ''            | '416,67'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '30.04.2024 12:00:00' | '*' | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | ''            | ''            | '71,33'   | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '30.04.2024 12:00:00' | '*' | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | ''            | ''            | '416,67'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '30.04.2024 12:00:00' | '*' | 'en description is empty' | 'Local currency'               | 'TRY'      | ''                    | ''            | ''            | '833,33'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '30.04.2024 12:00:00' | '*' | 'en description is empty' | 'Reporting currency'           | 'USD'      | ''                    | ''            | ''            | '142,67'  | ''                   | ''                   | 'No'                   | ''                 |
			| ''                                                    | '30.04.2024 12:00:00' | '*' | 'en description is empty' | 'en description is empty'      | 'TRY'      | ''                    | ''            | ''            | '833,33'  | ''                   | ''                   | 'No'                   | ''                 |
	And I close all client application windows

Scenario: _051707 check Fixed asset revaluation movements by the Register "Posted documents registry"
	And I close all client application windows
	* Select Fixed asset revaluation
		Given I open hyperlink "e1cib/list/Document.FixedAssetRevaluation"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements by the Register  "Posted documents registry"
		And I click "Registrations report info" button
		And I select "Posted documents registry" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | ''                                                    | ''                    | ''       | ''                    | ''            | ''                        | ''       | ''                      |
			| 'Register  "Posted documents registry"'               | ''                                                    | ''                    | ''       | ''                    | ''            | ''                        | ''       | ''                      |
			| ''                                                    | 'Document'                                            | 'Date'                | 'Number' | 'Create date'         | 'Modify date' | 'Author'                  | 'Editor' | 'Manual movements edit' |
			| ''                                                    | 'Fixed asset revaluation 1 dated 30.04.2024 12:00:00' | '30.04.2024 12:00:00' | '1'      | '*'                   | ''            | '*'                       | ''       | 'No'                    |
	And I close all client application windows
