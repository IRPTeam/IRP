#language: en
@tree
@Positive
@Movements
@MovementsMoneyTransfer


Feature: check Cash transfer order movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045300 preparation (Cash transfer order)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog CancelReturnReasons objects
		When Create catalog PlanningPeriods objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load Money transfer order
		When Create document MoneyTransfer objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.MoneyTransfer.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.MoneyTransfer.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.MoneyTransfer.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.MoneyTransfer.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows


Scenario: _045301 check Money transfer movements by the Register "R3035 Cash planning" (based on CTO)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33' | ''                    | ''          | ''             | ''             | ''                                                | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''             | ''                                                | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'            | ''                    | ''          | ''             | ''             | ''                                                | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''                     |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                | ''                  | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | 'Attributes'           |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Basis document'                                  | 'Account'           | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Deferred calculation' |
			| ''                                           | '19.02.2022 11:18:33' | '-900'      | 'Main Company' | 'Front office' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-900'      | 'Main Company' | 'Front office' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'Bank account, TRY' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-900'      | 'Main Company' | 'Front office' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'Bank account, EUR' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-178,5'    | 'Main Company' | 'Front office' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'Bank account, EUR' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-170'      | 'Main Company' | 'Front office' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'Bank account, EUR' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | 'First'           | 'No'                   |
			| ''                                           | '19.02.2022 11:18:33' | '-154,08'   | 'Main Company' | 'Front office' | 'Cash transfer order 3 dated 05.04.2021 12:23:49' | 'Bank account, TRY' | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | 'First'           | 'No'                   |
	And I close all client application windows

Scenario: _045302 check Money transfer movements by the Register "R3010 Cash on hand" (bank)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33' | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''             | ''                  | ''         | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                  | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Account'           | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Receipt'     | '19.02.2022 11:18:33' | '170'       | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'EUR'      | 'en description is empty'      | 'No'                   |
			| ''                                           | 'Receipt'     | '19.02.2022 11:18:33' | '178,5'     | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Receipt'     | '19.02.2022 11:18:33' | '900'       | 'Main Company' | 'Front office' | 'Bank account, EUR' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | 'Expense'     | '19.02.2022 11:18:33' | '154,08'    | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Expense'     | '19.02.2022 11:18:33' | '900'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | 'Expense'     | '19.02.2022 11:18:33' | '900'       | 'Main Company' | 'Front office' | 'Bank account, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows

Scenario: _045303 check Money transfer movements by the Register "R3010 Cash on hand" (cash)
	* Select Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 1 dated 19.02.2022 10:35:21' | ''            | ''                    | ''          | ''             | ''                        | ''             | ''         | ''                             | ''                     |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                        | ''             | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'             | ''            | ''                    | ''          | ''             | ''                        | ''             | ''         | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''                             | 'Attributes'           |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'                  | 'Account'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                           | 'Receipt'     | '19.02.2022 10:35:21' | '500'       | 'Main Company' | 'Distribution department' | 'Cash desk №2' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Receipt'     | '19.02.2022 10:35:21' | '500'       | 'Main Company' | 'Distribution department' | 'Cash desk №2' | 'USD'      | 'en description is empty'      | 'No'                   |
			| ''                                           | 'Receipt'     | '19.02.2022 10:35:21' | '2 813,75'  | 'Main Company' | 'Distribution department' | 'Cash desk №2' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                           | 'Expense'     | '19.02.2022 10:35:21' | '500'       | 'Main Company' | 'Distribution department' | 'Cash desk №1' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                           | 'Expense'     | '19.02.2022 10:35:21' | '500'       | 'Main Company' | 'Distribution department' | 'Cash desk №1' | 'USD'      | 'en description is empty'      | 'No'                   |
			| ''                                           | 'Expense'     | '19.02.2022 10:35:21' | '2 813,75'  | 'Main Company' | 'Distribution department' | 'Cash desk №1' | 'TRY'      | 'Local currency'               | 'No'                   |
		And I close all client application windows


Scenario: _045304 check absence Money transfer movements by the Register "R3035 Cash planning" (without CTO)
	And I close all client application windows
	* Select Money transfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R3035 Cash planning'   |     
	And I close all client application windows
		

Scenario: _045305 Money transfer clear posting/mark for deletion
		And I close all client application windows
	* Select Money transfer
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales order closing
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'   | 
			| 'R3010 Cash on hand' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Money transfer 4 dated 19.02.2022 11:18:33' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'   | 
			| 'R3010 Cash on hand' |
		And I close all client application windows				