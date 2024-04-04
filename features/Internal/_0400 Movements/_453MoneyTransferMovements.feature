#language: en
@tree
@Positive
@Movements2
@MovementsMoneyTransfer


Feature: check Money Transfer movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045300 preparation (Money transfer movements)
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
		When Create catalog BusinessUnits objects
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
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
		When Create catalog CancelReturnReasons objects
		When Create catalog PlanningPeriods objects
		When Create POS cash account objects
		When Create information register Taxes records (VAT)
	* Load Money transfer order
		When Create document MoneyTransfer objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		When Create document MoneyTransfer and CashReceipt objects (for cash in, movements)
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		
		
		

Scenario: _0453001 check preparation
	When check preparation

Scenario: _045301 check Money transfer movements by the Register "R3035 Cash planning" (based on CTO)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33' | ''                    | ''          | ''             | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '19.02.2022 11:18:33' | '-900'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-900'      | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-900'      | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-178,5'    | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-170'      | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-154,08'   | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
	And I close all client application windows

Scenario: _045302 check Money transfer movements by the Register "R3010 Cash on hand" (bank)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Receipt'       | '19.02.2022 11:18:33'   | '170'         | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'EUR'        | 'EUR'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Receipt'       | '19.02.2022 11:18:33'   | '178,5'       | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Receipt'       | '19.02.2022 11:18:33'   | '900'         | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '19.02.2022 11:18:33'   | '154,08'      | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '19.02.2022 11:18:33'   | '900'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '19.02.2022 11:18:33'   | '900'         | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _045303 check Money transfer movements by the Register "R3010 Cash on hand" (cash)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 1 dated 19.02.2022 10:35:21'   | ''              | ''                      | ''            | ''               | ''                          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'               | ''              | ''                      | ''            | ''               | ''                          | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                             | 'Receipt'       | '19.02.2022 10:35:21'   | '500'         | 'Main Company'   | 'Front office'              | 'Cash desk №2'   | 'USD'        | 'USD'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Receipt'       | '19.02.2022 10:35:21'   | '500'         | 'Main Company'   | 'Front office'              | 'Cash desk №2'   | 'USD'        | 'USD'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Receipt'       | '19.02.2022 10:35:21'   | '2 813,75'    | 'Main Company'   | 'Front office'              | 'Cash desk №2'   | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
			| ''                                             | 'Expense'       | '19.02.2022 10:35:21'   | '500'         | 'Main Company'   | 'Distribution department'   | 'Cash desk №1'   | 'USD'        | 'USD'                    | 'Reporting currency'             | 'No'                      |
			| ''                                             | 'Expense'       | '19.02.2022 10:35:21'   | '500'         | 'Main Company'   | 'Distribution department'   | 'Cash desk №1'   | 'USD'        | 'USD'                    | 'en description is empty'        | 'No'                      |
			| ''                                             | 'Expense'       | '19.02.2022 10:35:21'   | '2 813,75'    | 'Main Company'   | 'Distribution department'   | 'Cash desk №1'   | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
		And I close all client application windows


Scenario: _045304 check absence Money transfer movements by the Register "R3035 Cash planning" (without CTO)
	And I close all client application windows
	* Select Money transfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R3035 Cash planning'    |
	And I close all client application windows


		

Scenario: _045305 Money transfer clear posting/mark for deletion
		And I close all client application windows
	* Select Money transfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33'    |
			| 'Document registrations records'                |
		And I close current window
	* Post Sales order closing
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
			| 'R3010 Cash on hand'     |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33'    |
			| 'Document registrations records'                |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
			| 'R3010 Cash on hand'     |
		And I close all client application windows				

Scenario: _045306 check Money transfer movements by the Register "R3010 Cash on hand" (cash in)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 11 dated 25.08.2022 16:45:16'   | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                              | 'Expense'       | '25.08.2022 16:45:16'   | '171,2'       | 'Main Company'   | 'Shop 02'   | 'Cash desk №2'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                              | 'Expense'       | '25.08.2022 16:45:16'   | '1 000'       | 'Main Company'   | 'Shop 02'   | 'Cash desk №2'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                              | 'Expense'       | '25.08.2022 16:45:16'   | '1 000'       | 'Main Company'   | 'Shop 02'   | 'Cash desk №2'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _045307 check Money transfer movements by the Register "R3021 Cash in transit (incoming)" (cash in)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '11'        |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 11 dated 25.08.2022 16:45:16'  | ''            | ''                    | ''          | ''             | ''             | ''                   | ''                             | ''         | ''                     | ''                                            | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''             | ''                   | ''                             | ''         | ''                     | ''                                            | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''             | ''                   | ''                             | ''         | ''                     | ''                                            | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                   | ''                             | ''         | ''                     | ''                                            | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'            | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                       | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '25.08.2022 16:45:16' | '171,2'     | 'Main Company' | 'Front office' | 'Pos cash account 1' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Money transfer 11 dated 25.08.2022 16:45:16' | 'No'                   |
			| ''                                             | 'Receipt'     | '25.08.2022 16:45:16' | '1 000'     | 'Main Company' | 'Front office' | 'Pos cash account 1' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Money transfer 11 dated 25.08.2022 16:45:16' | 'No'                   |
			| ''                                             | 'Receipt'     | '25.08.2022 16:45:16' | '1 000'     | 'Main Company' | 'Front office' | 'Pos cash account 1' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Money transfer 11 dated 25.08.2022 16:45:16' | 'No'                   |
		And I close all client application windows


Scenario: _045308 check Money transfer movements by the Register "R3010 Cash on hand" (cash out)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '13'        |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 13 dated 25.08.2022 16:46:25'   | ''              | ''                      | ''            | ''               | ''          | ''                     | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''          | ''                     | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                | ''              | ''                      | ''            | ''               | ''          | ''                     | ''           | ''                       | ''                               | ''                        |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                     | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'              | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                              | 'Expense'       | '25.08.2022 16:46:25'   | '171,2'       | 'Main Company'   | 'Shop 02'   | 'Pos cash account 1'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                              | 'Expense'       | '25.08.2022 16:46:25'   | '1 000'       | 'Main Company'   | 'Shop 02'   | 'Pos cash account 1'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                              | 'Expense'       | '25.08.2022 16:46:25'   | '1 000'       | 'Main Company'   | 'Shop 02'   | 'Pos cash account 1'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows


Scenario: _045309 check Money transfer movements by the Register "R3021 Cash in transit (incoming)" (cash out)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '13'        |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 13 dated 25.08.2022 16:46:25'  | ''            | ''                    | ''          | ''             | ''        | ''             | ''                             | ''         | ''                     | ''                                            | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''        | ''             | ''                             | ''         | ''                     | ''                                            | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''        | ''             | ''                             | ''         | ''                     | ''                                            | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''                             | ''         | ''                     | ''                                            | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                       | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '25.08.2022 16:46:25' | '171,2'     | 'Main Company' | 'Shop 02' | 'Cash desk №2' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Money transfer 13 dated 25.08.2022 16:46:25' | 'No'                   |
			| ''                                             | 'Receipt'     | '25.08.2022 16:46:25' | '1 000'     | 'Main Company' | 'Shop 02' | 'Cash desk №2' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Money transfer 13 dated 25.08.2022 16:46:25' | 'No'                   |
			| ''                                             | 'Receipt'     | '25.08.2022 16:46:25' | '1 000'     | 'Main Company' | 'Shop 02' | 'Cash desk №2' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Money transfer 13 dated 25.08.2022 16:46:25' | 'No'                   |
		And I close all client application windows

Scenario: _045310 check Money transfer movements by the Register "R3011 Cash flow" (cash out)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '13'        |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 13 dated 25.08.2022 16:46:25' | ''                    | ''          | ''             | ''        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'              | ''                    | ''          | ''             | ''        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                 | ''                    | ''          | ''             | ''        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                            | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                   | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'            | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                            | '25.08.2022 16:46:25' | '171,2'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'Outgoing'  | 'Movement type 1'         | 'Shop 02'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                            | '25.08.2022 16:46:25' | '1 000'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'Outgoing'  | 'Movement type 1'         | 'Shop 02'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                            | '25.08.2022 16:46:25' | '1 000'     | 'Main Company' | 'Shop 02' | 'Pos cash account 1' | 'Outgoing'  | 'Movement type 1'         | 'Shop 02'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _045311 check Money transfer movements by the Register "R3011 Cash flow" (currency exchange)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33' | ''                    | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'                | ''                    | ''             | ''             | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                           | 'Period'              | 'Company'      | 'Branch'       | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                           | '19.02.2022 11:18:33' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | '900'    | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | '900'    | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | '154,08' | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | '900'    | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | '178,5'  | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'EUR'      | 'en description is empty'      | '170'    | 'No'                   |
		And I close all client application windows
