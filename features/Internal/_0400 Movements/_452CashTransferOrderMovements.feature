#language: en
@tree
@Positive
@Movements
@MovementsCashTransferOrder


Feature: check Cash transfer order movements


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045200 preparation (Cash transfer order)
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
	* Load Cash transfer order
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows

Scenario: _045203 check Cash transfer order movements by the Register "R3035 Cash planning"
	* Select Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash transfer order 2 dated 05.04.2021 12:09:54' | ''                    | ''          | ''             | ''                                                | ''                    | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Document registrations records'                  | ''                    | ''          | ''             | ''                                                | ''                    | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| 'Register  "R3035 Cash planning"'                 | ''                    | ''          | ''             | ''                                                | ''                    | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | ''                     |
			| ''                                                | 'Period'              | 'Resources' | 'Dimensions'   | ''                                                | ''                    | ''         | ''                    | ''        | ''           | ''                             | ''                | ''                | 'Attributes'           |
			| ''                                                | ''                    | 'Amount'    | 'Company'      | 'Basis document'                                  | 'Account'             | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Movement type'   | 'Planning period' | 'Deferred calculation' |
			| ''                                                | '05.04.2021 12:09:54' | '500'       | 'Main Company' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'Bank account, EUR'   | 'EUR'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1' | 'First'           | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | '500'       | 'Main Company' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'Bank account 2, EUR' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | '550'       | 'Main Company' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'Bank account, EUR'   | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1' | 'First'           | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | '550'       | 'Main Company' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'Bank account 2, EUR' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1' | 'Second'          | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | '4 500'     | 'Main Company' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'Bank account, EUR'   | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1' | 'First'           | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | '4 500'     | 'Main Company' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'Bank account 2, EUR' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1' | 'Second'          | 'No'                   |
	And I close all client application windows


Scenario: _045212 Cash transfer order  clear posting/mark for deletion
	And I close all client application windows
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash transfer order 2 dated 05.04.2021 12:09:54' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash transfer order 2 dated 05.04.2021 12:09:54' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning' |
		And I close all client application windows				
