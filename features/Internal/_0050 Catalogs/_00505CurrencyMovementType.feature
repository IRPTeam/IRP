#language: en
@tree
@Positive
@CompanyCatalogs

Feature: filling in Movement Type for Partner term currencies
As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one






Scenario: _005017 creation Movement Type for Partner term currencies
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Preparation
		When Create catalog Currencies objects
		When Create catalog IntegrationSettings objects
	* Opening charts of characteristic types - Currency movement
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Create currency for Partner terms - TRY
		And I click the button named "FormCreate"
		And I input "TRY" text in the field named "Description_en"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I click Select button of "Source" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Forex Seling'    |
		And I select current line in "List" table
		And I select "Partner term" exact value from "Type" drop-down list
		And I click "Save and close" button
	* Check data save
		And "List" table contains lines
		| 'Description'  | 'Type'          | 'Currency'  | 'Source'        | 'Deferred calculation'   |
		| 'TRY'          | 'Partner term'  | 'TRY'       | 'Forex Seling'  | 'No'                     |
		
