#language: en
@tree
@Positive
@Movements3
@MovementsCommissioningOfFixedAsset

Feature: check Expense and revenue accruals movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _051500 preparation (CommissioningOfFixedAsset movements)
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

Scenario: _051501 check preparation
	When check preparation

Scenario: _051502 check Commissioning of fixed asset movements by the Register "R4010 Actual stocks"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report info" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''           | ''         | ''              | ''                  | ''         |
			| 'Register  "R4010 Actual stocks"'                           | ''                    | ''           | ''         | ''              | ''                  | ''         |
			| ''                                                          | 'Period'              | 'RecordType' | 'Store'    | 'Item key'      | 'Serial lot number' | 'Quantity' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Expense'    | 'Store 02' | 'Fixed asset 1' | ''                  | '1'        |		
	And I close all client application windows

Scenario: _051503 check Commissioning of fixed asset movements by the Register "R4011 Free stocks"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''           | ''         | ''              | ''         |
			| 'Register  "R4011 Free stocks"'                             | ''                    | ''           | ''         | ''              | ''         |
			| ''                                                          | 'Period'              | 'RecordType' | 'Store'    | 'Item key'      | 'Quantity' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Expense'    | 'Store 02' | 'Fixed asset 1' | '1'        |	
	And I close all client application windows

Scenario: _051504 check Commissioning of fixed asset movements by the Register "R4050 Stock inventory"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report info" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''           | ''             | ''         | ''              | ''         |
			| 'Register  "R4050 Stock inventory"'                         | ''                    | ''           | ''             | ''         | ''              | ''         |
			| ''                                                          | 'Period'              | 'RecordType' | 'Company'      | 'Store'    | 'Item key'      | 'Quantity' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Store 02' | 'Fixed asset 1' | '1'        |		
	And I close all client application windows

Scenario: _051505 check Commissioning of fixed asset movements by the Register "R6020 Batch balance"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R6020 Batch balance" 
		And I click "Registrations report info" button
		And I select "R6020 Batch balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''           | ''             | ''         | ''              | ''                                              | ''                         | ''                 | ''                 | ''                  | ''        | ''          | ''           | ''         | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''                 | ''                 | ''                                                        |
			| 'Register  "R6020 Batch balance !Manual edit"'              | ''                    | ''           | ''             | ''         | ''              | ''                                              | ''                         | ''                 | ''                 | ''                  | ''        | ''          | ''           | ''         | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''                 | ''                 | ''                                                        |
			| ''                                                          | 'Period'              | 'RecordType' | 'Company'      | 'Store'    | 'Item key'      | 'Batch'                                         | 'Batch key'                | 'Inventory origin' | 'Source of origin' | 'Serial lot number' | 'Partner' | 'Agreement' | 'Legal name' | 'Quantity' | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' | 'Total amount' | 'Total net amount' | 'Total tax amount' | 'Calculation movement cost'                               |
			| ''                                                          | '12.01.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Store 02' | 'Fixed asset 1' | 'Purchase invoice 78 dated 10.01.2024 12:00:00' | 'Fixed asset 1 - Store 02' | 'Own stocks'       | ''                 | ''                  | ''        | ''          | ''           | '1'        | '5 000'          | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''                 | ''                 | 'Calculation movement costs 78 dated 31.01.2024 12:00:00' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Expense'    | 'Main Company' | 'Store 02' | 'Fixed asset 1' | 'Purchase invoice 78 dated 10.01.2024 12:00:00' | 'Fixed asset 1 - Store 02' | 'Own stocks'       | ''                 | ''                  | ''        | ''          | ''           | '1'        | '5 000'          | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | '5 000'        | '5 000'            | ''                 | 'Calculation movement costs 78 dated 31.01.2024 12:00:00' |		
	And I close all client application windows

Scenario: _051506 check Commissioning of fixed asset movements by the Register "R8510 Book value of fixed asset"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R8510 Book value of fixed asset" 
		And I click "Registrations report info" button
		And I select "R8510 Book value of fixed asset" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''           | ''             | ''             | ''                     | ''                 | ''                                     | ''                          | ''         | ''                        | ''                     | ''       | ''                                                        |
			| 'Register  "R8510 Book value of fixed asset"'               | ''                    | ''           | ''             | ''             | ''                     | ''                 | ''                                     | ''                          | ''         | ''                        | ''                     | ''       | ''                                                        |
			| ''                                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Fixed asset'      | 'Ledger type'                          | 'Schedule'                  | 'Currency' | 'Currency movement type'  | 'Transaction currency' | 'Amount' | 'Calculation movement cost'                               |
			| ''                                                          | '12.01.2024 12:00:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'TRY'      | 'Local currency'          | 'TRY'                  | '5 000'  | 'Calculation movement costs 78 dated 31.01.2024 12:00:00' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'TRY'      | 'en description is empty' | 'TRY'                  | '5 000'  | 'Calculation movement costs 78 dated 31.01.2024 12:00:00' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Receipt'    | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | 'Straight line (36 months)' | 'USD'      | 'Reporting currency'      | 'TRY'                  | '856'    | 'Calculation movement costs 78 dated 31.01.2024 12:00:00' |		
	And I close all client application windows

Scenario: _051507 check Commissioning of fixed asset movements by the Register "R8515 Cost of fixed asset"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "R8515 Cost of fixed asset" 
		And I click "Registrations report info" button
		And I select "R8515 Cost of fixed asset" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''             | ''                 | ''                                     | ''       | ''                                                        |
			| 'Register  "R8515 Cost of fixed asset"'                     | ''                    | ''             | ''                 | ''                                     | ''       | ''                                                        |
			| ''                                                          | 'Period'              | 'Company'      | 'Fixed asset'      | 'Ledger type'                          | 'Amount' | 'Calculation movement cost'                               |
			| ''                                                          | '12.01.2024 12:00:00' | 'Main Company' | 'Computer Servers' | 'Computer Hardware (with deprecation)' | '5 000'  | 'Calculation movement costs 78 dated 31.01.2024 12:00:00' |	
	And I close all client application windows

Scenario: _051508 check Commissioning of fixed asset movements by the Register "T6020 Batch keys info"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "T6020 Batch keys info" 
		And I click "Registrations report info" button
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''             | ''             | ''         | ''              | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                     | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                 | ''         | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             |
			| 'Register  "T6020 Batch keys info"'                         | ''                    | ''             | ''             | ''         | ''              | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                     | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                 | ''         | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             |
			| ''                                                          | 'Period'              | 'Company'      | 'Branch'       | 'Store'    | 'Item key'      | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center'   | 'Expense type' | 'Work' | 'Work sheet' | 'DELETE batch consignor' | 'Serial lot number' | 'Source of origin' | 'Production document' | 'Purchase invoice document' | 'Fixed asset'      | 'Quantity' | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Main Company' | 'Front office' | 'Store 02' | 'Fixed asset 1' | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | 'Logistics department' | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | 'Computer Servers' | '1'        | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             |		
	And I close all client application windows

Scenario: _051509 check Commissioning of fixed asset movements by the Register "T8515 Fixed asset location"
		And I close all client application windows
	* Select Commissioning of fixed asset
		Given I open hyperlink "e1cib/list/Document.CommissioningOfFixedAsset"
		And I go to line in "List" table
			| 'Number'   |
			| '11'       |
	* Check movements by the Register  "T8515 Fixed asset location" 
		And I click "Registrations report info" button
		And I select "T8515 Fixed asset location" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Commissioning of fixed asset 11 dated 12.01.2024 12:00:00' | ''                    | ''             | ''             | ''                     | ''                 | ''                   | ''          |
			| 'Register  "T8515 Fixed asset location"'                    | ''                    | ''             | ''             | ''                     | ''                 | ''                   | ''          |
			| ''                                                          | 'Period'              | 'Company'      | 'Branch'       | 'Profit loss center'   | 'Fixed asset'      | 'Responsible person' | 'Is active' |
			| ''                                                          | '12.01.2024 12:00:00' | 'Main Company' | 'Front office' | 'Logistics department' | 'Computer Servers' | 'Arina Brown'        | 'Yes'       |		
	And I close all client application windows