#language: en
@tree
@Positive
@Movements2
@MovementsUnbundling


Feature: check Unbundling movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _042700 preparation (Unbundling)
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
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create information register Taxes records (VAT)
		When Create document Unbundling objects
		And I execute 1C:Enterprise script at server
			| "Documents.Unbundling.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _0427001 check preparation
	When check preparation	

Scenario: _042701 check Unbundling movements by the Register  "R4010 Actual stocks"
	* Select Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Unbundling 1 dated 07.09.2020 18:23:12'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'           | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'          | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                         | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                         | 'Receipt'       | '07.09.2020 18:23:12'   | '2'           | 'Store 01'     | 'S/Yellow'    | ''                     |
			| ''                                         | 'Receipt'       | '07.09.2020 18:23:12'   | '2'           | 'Store 01'     | 'XS/Blue'     | ''                     |
			| ''                                         | 'Receipt'       | '07.09.2020 18:23:12'   | '4'           | 'Store 01'     | 'L/Green'     | ''                     |
			| ''                                         | 'Receipt'       | '07.09.2020 18:23:12'   | '4'           | 'Store 01'     | 'M/Brown'     | ''                     |
			| ''                                         | 'Expense'       | '07.09.2020 18:23:12'   | '2'           | 'Store 01'     | 'Dress/A-8'   | ''                     |
		And I close all client application windows

Scenario: _042702 check Unbundling movements by the Register  "R4011 Free stocks"
	* Select Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report info" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Unbundling 1 dated 07.09.2020 18:23:12' | ''                    | ''           | ''         | ''          | ''         |
			| 'Register  "R4011 Free stocks"'          | ''                    | ''           | ''         | ''          | ''         |
			| ''                                       | 'Period'              | 'RecordType' | 'Store'    | 'Item key'  | 'Quantity' |
			| ''                                       | '07.09.2020 18:23:12' | 'Receipt'    | 'Store 01' | 'S/Yellow'  | '2'        |
			| ''                                       | '07.09.2020 18:23:12' | 'Receipt'    | 'Store 01' | 'XS/Blue'   | '2'        |
			| ''                                       | '07.09.2020 18:23:12' | 'Receipt'    | 'Store 01' | 'L/Green'   | '4'        |
			| ''                                       | '07.09.2020 18:23:12' | 'Receipt'    | 'Store 01' | 'M/Brown'   | '4'        |
			| ''                                       | '07.09.2020 18:23:12' | 'Expense'    | 'Store 01' | 'Dress/A-8' | '2'        |		
		And I close all client application windows
			
Scenario: _042730 Unbundling clear posting/mark for deletion
	And I close all client application windows
	* Select Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Unbundling 1 dated 07.09.2020 18:23:12'    |
			| 'Document registrations records'            |
		And I close current window
	* Post UnBundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.Unbundling"
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
			| 'Unbundling 1 dated 07.09.2020 18:23:12'    |
			| 'Document registrations records'            |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.Unbundling"
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
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
