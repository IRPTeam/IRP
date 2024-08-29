#language: en
@tree
@Positive
@Movements2
@MovementsCashExpense

Feature: check Cash expense movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _044000 preparation (Cash expense)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
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
		When Create catalog Countries objects
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
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog Projects objects
		When Create catalog CashAccounts objects (Second Company)
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		When Create document CashExpense objects
		When Create document CashExpense objects (OtherCompanyExpense)
		And I execute 1C:Enterprise script at server
			| "Documents.CashExpense.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashExpense.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		
Scenario: _0440001 check preparation
	When check preparation

Scenario: _044001 check Cash expense movements by the Register "R3010 Cash on hand"
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17'   | ''              | ''                      | ''            | ''               | ''          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'             | ''              | ''                      | ''            | ''               | ''          | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                           | 'Expense'       | '07.09.2020 19:25:17'   | '20,2'        | 'Main Company'   | 'Shop 01'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                           | 'Expense'       | '07.09.2020 19:25:17'   | '118'         | 'Main Company'   | 'Shop 01'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                           | 'Expense'       | '07.09.2020 19:25:17'   | '118'         | 'Main Company'   | 'Shop 01'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows



Scenario: _044002 check Cash expense movements by the Register "R5022 Expenses"
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17' | ''                    | ''          | ''                  | ''            | ''             | ''        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| 'Document registrations records'           | ''                    | ''          | ''                  | ''            | ''             | ''        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| 'Register  "R5022 Expenses"'               | ''                    | ''          | ''                  | ''            | ''             | ''        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | ''                          |
			| ''                                         | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'   | ''        | ''                   | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''           | 'Attributes'                |
			| ''                                         | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'      | 'Branch'  | 'Profit loss center' | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'    | 'Calculation movement cost' |
			| ''                                         | '07.09.2020 19:25:17' | '17,12'     | '20,2'              | ''            | 'Main Company' | 'Shop 01' | 'Front office'       | 'Fuel'         | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | 'Project 01' | ''                          |
			| ''                                         | '07.09.2020 19:25:17' | '100'       | '118'               | ''            | 'Main Company' | 'Shop 01' | 'Front office'       | 'Fuel'         | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | 'Project 01' | ''                          |
			| ''                                         | '07.09.2020 19:25:17' | '100'       | '118'               | ''            | 'Main Company' | 'Shop 01' | 'Front office'       | 'Fuel'         | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | 'Project 01' | ''                          |
	And I close all client application windows

Scenario: _044003 check Cash expense movements by the Register "R3010 Cash on hand" (Other company expense)
		And I close all client application windows
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 15 dated 04.03.2023 10:57:29'   | ''              | ''                      | ''            | ''                 | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''                 | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'              | ''              | ''                      | ''            | ''                 | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'       | ''         | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'          | 'Branch'   | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | 'Receipt'       | '04.03.2023 10:57:29'   | '171,2'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 10:57:29'   | '342,4'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 10:57:29'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 10:57:29'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 10:57:29'   | '2 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 10:57:29'   | '2 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '171,2'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '171,2'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '342,4'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '342,4'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '1 000'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '1 000'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '2 000'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '2 000'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '2 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 10:57:29'   | '2 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows


Scenario: _044004 check Cash expense movements by the Register "R3027 Employee cash advance" (Other company expense)
		And I close all client application windows
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 15 dated 04.03.2023 10:57:29' | ''            | ''                    | ''          | ''               | ''       | ''             | ''          | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''               | ''       | ''             | ''          | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3027 Employee cash advance"'   | ''            | ''                    | ''          | ''               | ''       | ''             | ''          | ''         | ''                     | ''                             | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'     | ''       | ''             | ''          | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'        | 'Branch' | 'Partner'      | 'Agreement' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '04.03.2023 10:57:29' | '171,2'     | 'Main Company'   | ''       | 'Anna Petrova' | ''          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Receipt'     | '04.03.2023 10:57:29' | '342,4'     | 'Main Company'   | ''       | 'Arina Brown'  | ''          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Receipt'     | '04.03.2023 10:57:29' | '1 000'     | 'Main Company'   | ''       | 'Anna Petrova' | ''          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Receipt'     | '04.03.2023 10:57:29' | '1 000'     | 'Main Company'   | ''       | 'Anna Petrova' | ''          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
			| ''                                          | 'Receipt'     | '04.03.2023 10:57:29' | '2 000'     | 'Main Company'   | ''       | 'Arina Brown'  | ''          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Receipt'     | '04.03.2023 10:57:29' | '2 000'     | 'Main Company'   | ''       | 'Arina Brown'  | ''          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
			| ''                                          | 'Expense'     | '04.03.2023 10:57:29' | '171,2'     | 'Second Company' | ''       | 'Anna Petrova' | ''          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Expense'     | '04.03.2023 10:57:29' | '342,4'     | 'Second Company' | ''       | 'Arina Brown'  | ''          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                          | 'Expense'     | '04.03.2023 10:57:29' | '1 000'     | 'Second Company' | ''       | 'Anna Petrova' | ''          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Expense'     | '04.03.2023 10:57:29' | '1 000'     | 'Second Company' | ''       | 'Anna Petrova' | ''          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
			| ''                                          | 'Expense'     | '04.03.2023 10:57:29' | '2 000'     | 'Second Company' | ''       | 'Arina Brown'  | ''          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                          | 'Expense'     | '04.03.2023 10:57:29' | '2 000'     | 'Second Company' | ''       | 'Arina Brown'  | ''          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |		
	And I close all client application windows


Scenario: _044005 check Cash expense movements by the Register "R5022 Expenses" (Other company expense)
		And I close all client application windows
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 15 dated 04.03.2023 10:57:29' | ''                    | ''          | ''                  | ''            | ''               | ''       | ''                        | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                          | ''                          |
			| 'Document registrations records'            | ''                    | ''          | ''                  | ''            | ''               | ''       | ''                        | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                          | ''                          |
			| 'Register  "R5022 Expenses"'                | ''                    | ''          | ''                  | ''            | ''               | ''       | ''                        | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                          | ''                          |
			| ''                                          | 'Period'              | 'Resources' | ''                  | ''            | 'Dimensions'     | ''       | ''                        | ''             | ''         | ''            | ''            | ''         | ''                    | ''                             | ''                          | 'Attributes'                |
			| ''                                          | ''                    | 'Amount'    | 'Amount with taxes' | 'Amount cost' | 'Company'        | 'Branch' | 'Profit loss center'      | 'Expense type' | 'Item key' | 'Fixed asset' | 'Ledger type' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project'                          | 'Calculation movement cost' |
			| ''                                          | '04.03.2023 10:57:29' | '171,2'     | '171,2'             | ''            | 'Second Company' | ''       | 'Distribution department' | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''                          | ''                          |
			| ''                                          | '04.03.2023 10:57:29' | '342,4'     | '342,4'             | ''            | 'Second Company' | ''       | 'Logistics department'    | 'Expense'      | ''         | ''            | ''            | 'USD'      | ''                    | 'Reporting currency'           | ''                          | ''                          |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | '1 000'             | ''            | 'Second Company' | ''       | 'Distribution department' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                          | ''                          |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | '1 000'             | ''            | 'Second Company' | ''       | 'Distribution department' | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''                          | ''                          |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | '2 000'             | ''            | 'Second Company' | ''       | 'Logistics department'    | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'Local currency'               | ''                          | ''                          |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | '2 000'             | ''            | 'Second Company' | ''       | 'Logistics department'    | 'Expense'      | ''         | ''            | ''            | 'TRY'      | ''                    | 'en description is empty'      | ''                          | ''                          |
	And I close all client application windows

Scenario: _044006 check Cash expense movements by the Register "R3011 Cash flow" (Other company expense)
		And I close all client application windows
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 15 dated 04.03.2023 10:57:29' | ''                    | ''          | ''               | ''       | ''             | ''          | ''                        | ''                   | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'            | ''                    | ''          | ''               | ''       | ''             | ''          | ''                        | ''                   | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'               | ''                    | ''          | ''               | ''       | ''             | ''          | ''                        | ''                   | ''                | ''         | ''                             | ''                     |
			| ''                                          | 'Period'              | 'Resources' | 'Dimensions'     | ''       | ''             | ''          | ''                        | ''                   | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                          | ''                    | 'Amount'    | 'Company'        | 'Branch' | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center'   | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | '04.03.2023 10:57:29' | '171,2'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 2'         | 'Accountants office' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '171,2'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'       | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '171,2'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 2'         | 'Accountants office' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '342,4'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 2'         | 'Accountants office' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '342,4'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'       | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '342,4'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 2'         | 'Accountants office' | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'       | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'       | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'       | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'       | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 10:57:29' | '2 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 2'         | 'Accountants office' | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows


Scenario: _044007 check Cash expense movements by the Register "R3011 Cash flow"
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17' | ''                    | ''             | ''        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'              | ''                    | ''             | ''        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                         | 'Period'              | 'Company'      | 'Branch'  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                         | '07.09.2020 19:25:17' | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | '118'    | 'No'                   |
			| ''                                         | '07.09.2020 19:25:17' | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | '118'    | 'No'                   |
			| ''                                         | '07.09.2020 19:25:17' | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | '20,2'   | 'No'                   |	
	And I close all client application windows

Scenario: _044030 Cash expense clear posting/mark for deletion
	And I close all client application windows
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17'    |
			| 'Document registrations records'              |
		And I close current window
	* Post Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17'    |
			| 'Document registrations records'              |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'    |
		And I close all client application windows		

