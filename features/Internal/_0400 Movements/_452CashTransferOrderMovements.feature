#language: en
@tree
@Positive
@Movements2
@MovementsCashTransferOrder


Feature: check Cash transfer order movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _045200 preparation (Cash transfer order)
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
		When Create catalog Countries objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog CancelReturnReasons objects
		When Create catalog PlanningPeriods objects
		When Create information register Taxes records (VAT)
	* Load Cash transfer order
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _0452001 check preparation
	When check preparation

Scenario: _045203 check Cash transfer order movements by the Register "R3035 Cash planning"
	* Select Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R3035 Cash planning" 
		And I click "Registrations report info" button
		And I select "R3035 Cash planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash transfer order 2 dated 05.04.2021 12:09:54' | ''                    | ''             | ''                   | ''                    | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''       | ''                     |
			| 'Register  "R3035 Cash planning"'                 | ''                    | ''             | ''                   | ''                    | ''                                                | ''         | ''                    | ''        | ''           | ''                             | ''                        | ''                | ''       | ''                     |
			| ''                                                | 'Period'              | 'Company'      | 'Branch'             | 'Account'             | 'Basis document'                                  | 'Currency' | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Multi currency movement type' | 'Financial movement type' | 'Planning period' | 'Amount' | 'Deferred calculation' |
			| ''                                                | '05.04.2021 12:09:54' | 'Main Company' | 'Front office'       | 'Bank account, EUR'   | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'TRY'      | 'Outgoing'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | 'First'           | '4 500'  | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | 'Main Company' | 'Front office'       | 'Bank account, EUR'   | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'USD'      | 'Outgoing'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | 'First'           | '550'    | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | 'Main Company' | 'Front office'       | 'Bank account, EUR'   | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'EUR'      | 'Outgoing'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | 'First'           | '500'    | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | 'Main Company' | 'Accountants office' | 'Bank account 2, EUR' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'TRY'      | 'Incoming'            | ''        | ''           | 'Local currency'               | 'Movement type 1'         | 'Second'          | '4 500'  | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | 'Main Company' | 'Accountants office' | 'Bank account 2, EUR' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'USD'      | 'Incoming'            | ''        | ''           | 'Reporting currency'           | 'Movement type 1'         | 'Second'          | '550'    | 'No'                   |
			| ''                                                | '05.04.2021 12:09:54' | 'Main Company' | 'Accountants office' | 'Bank account 2, EUR' | 'Cash transfer order 2 dated 05.04.2021 12:09:54' | 'EUR'      | 'Incoming'            | ''        | ''           | 'en description is empty'      | 'Movement type 1'         | 'Second'          | '500'    | 'No'                   |	
	And I close all client application windows


Scenario: _045212 Cash transfer order  clear posting/mark for deletion
	And I close all client application windows
	* Select Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash transfer order 2 dated 05.04.2021 12:09:54'    |
			| 'Document registrations records'                     |
		And I close current window
	* Post Outgoing payment order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3035 Cash planning'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash transfer order 2 dated 05.04.2021 12:09:54'    |
			| 'Document registrations records'                     |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
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
		And I close all client application windows				
