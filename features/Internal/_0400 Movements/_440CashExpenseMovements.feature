#language: en
@tree
@Positive
@Movements
@MovementsCashExpense

Feature: check Cash expense movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _044000 preparation (Cash expense)
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
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		When Create document CashExpense objects
		And I execute 1C:Enterprise script at server
			| "Documents.CashExpense.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows
		


Scenario: _044001 check Cash expense movements by the Register "R3010 Cash on hand"
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17' | ''            | ''                    | ''          | ''             | ''                  | ''         | ''                             | ''                     |
			| 'Document registrations records'           | ''            | ''                    | ''          | ''             | ''                  | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'           | ''            | ''                    | ''          | ''             | ''                  | ''         | ''                             | ''                     |
			| ''                                         | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                  | ''         | ''                             | 'Attributes'           |
			| ''                                         | ''            | ''                    | 'Amount'    | 'Company'      | 'Account'           | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                         | 'Expense'     | '07.09.2020 19:25:17' | '100'       | 'Main Company' | 'Bank account, TRY' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                         | 'Expense'     | '07.09.2020 19:25:17' | '100'       | 'Main Company' | 'Bank account, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                         | 'Expense'     | '07.09.2020 19:25:17' | '584'       | 'Main Company' | 'Bank account, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   |
	And I close all client application windows



Scenario: _044002 check Cash expense movements by the Register "R5022 Expenses"
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5022 Expenses" 
		And I click "Registrations report" button
		And I select "R5022 Expenses" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17' | ''                    | ''          | ''             | ''              | ''             | ''         | ''         | ''                    | ''                             |
			| 'Document registrations records'           | ''                    | ''          | ''             | ''              | ''             | ''         | ''         | ''                    | ''                             |
			| 'Register  "R5022 Expenses"'               | ''                    | ''          | ''             | ''              | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                         | 'Period'              | 'Resources' | 'Dimensions'   | ''              | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                         | ''                    | 'Amount'    | 'Company'      | 'Profit loss center' | 'Expense type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' |
			| ''                                         | '07.09.2020 19:25:17' | '100'       | 'Main Company' | 'Front office'  | 'Fuel'         | ''         | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                         | '07.09.2020 19:25:17' | '100'       | 'Main Company' | 'Front office'  | 'Fuel'         | ''         | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                         | '07.09.2020 19:25:17' | '584'       | 'Main Company' | 'Front office'  | 'Fuel'         | ''         | 'USD'      | ''                    | 'Reporting currency'           |
	And I close all client application windows

Scenario: _044030 Cash expense clear posting/mark for deletion
	And I close all client application windows
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash expense 1 dated 07.09.2020 19:25:17' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand' |
		And I close all client application windows		

