#language: en
@tree
@Positive
@SettingsCatalogs

Feature: filling in Cheque bond catalog


Background:
	Given I open new TestClient session or connect the existing one

Scenario: _005230 preparation (Cheque bond catalog)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog Currencies objects


Scenario: _005231 create an incoming check in the Cheque bonds catalog
	* Open catalog form
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And I click the button named "FormCreate"
	* Create an incoming check
		And I input "Partner cheque 1" text in "Cheque No" field
		And I input "AA" text in "Cheque serial No" field
		And I select "Partner cheque" exact value from "Type" drop-down list
		And I input end of the current month date in "Due date" field
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I input "2 000,00" text in "Amount" field
		And I click "Save and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And "List" table contains lines
			| 'Cheque No'          | 'Cheque serial No'   | 'Amount'     | 'Type'             | 'Currency'    |
			| 'Partner cheque 1'   | 'AA'                 | '2 000,00'   | 'Partner cheque'   | 'TRY'         |
		And I close all client application windows

Scenario: _005232 create an outgoing check in the Cheque bonds catalog
		And I close all client application windows
	* Open catalog form
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And I click the button named "FormCreate"
	* Create an outgoing check
		And I input "Own cheque 1" text in "Cheque No" field
		And I input "BB" text in "Cheque serial No" field
		And I select "Own cheque" exact value from "Type" drop-down list
		And I input end of the current month date in "Due date" field
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I input "5 000,00" text in "Amount" field
		And I click "Save and close" button
	* Check creation
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
		And "List" table contains lines
			| 'Cheque No'      | 'Cheque serial No'   | 'Amount'     | 'Type'         | 'Currency'    |
			| 'Own cheque 1'   | 'BB'                 | '5 000,00'   | 'Own cheque'   | 'TRY'         |
		And I close all client application windows

Scenario: _005233 сheck the required fields
		And I close all client application windows
	* Open catalog form
		Given I open hyperlink "e1cib/list/Catalog.ChequeBonds"
	* Check required fields
		And I click the button named "FormCreate"
		And I click "Save" button
		Then I wait that in user messages the "\"Cheque No\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Type\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Due date\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Currency\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Amount\" is a required field" substring will appear in 5 seconds
		And I close all client application windows
	
