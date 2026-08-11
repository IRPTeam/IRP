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
	* Preparation
		When Create catalog Currencies objects
		When Create catalog IntegrationSettings objects
	* Opening charts of characteristic types - Currency movement
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Create currency for Partner terms - TRY
		And I click the button named "FormCreate"
		And I input "TRY" text in the field named "Description_en"
		And I select "TRY" exact value from "Currency" drop-down list
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


Scenario: _005018 check the required fields of Movement Type for Partner term currencies
	And I close all client application windows
	* Open charts of characteristic types - Currency movement
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Try to save a new item with the description only
		And I click the button named "FormCreate"
		And I input "Required fields check" text in the field named "Description_en"
		And I click "Save" button
	* All three attributes are reported as required
		Then I wait that in user messages the "\"Currency\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Source\" is a required field" substring will appear in 5 seconds
		Then I wait that in user messages the "\"Type\" is a required field" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005019 check that Source is a required field of Movement Type for Partner term currencies
	And I close all client application windows
	* Open charts of characteristic types - Currency movement
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CurrencyMovementType"
	* Fill in everything except Source
		And I click the button named "FormCreate"
		And I input "Source check" text in the field named "Description_en"
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| 'Code'   | 'Description'     |
			| 'TRY'    | 'Turkish lira'    |
		And I select current line in "List" table
		And I select "Partner term" exact value from "Type" drop-down list
		And I click "Save" button
	* Only Source is reported as required
		Then I wait that in user messages the "\"Source\" is a required field" substring will appear in 5 seconds
	And I close all client application windows


Scenario: _005020 check that predefined Movement Types are saved with empty Currency, Source and Type
	And I close all client application windows
	* Get a reference to the predefined item SettlementCurrency
		And I execute 1C:Enterprise script at server
			| 'Объект.ЗначениеНаСервере = GetURL(ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);' |
		And I save 'Объект.ЗначениеНаСервере' in 'RefSettlementCurrency' variable
	* The predefined item is saved even though the required attributes are empty
		Given I open hyperlink "$RefSettlementCurrency$"
		And I save form header as 'PredefinedItemFormTitle' variable
		And I click "Save and close" button
		Then I wait "$PredefinedItemFormTitle$" window closing in 10 seconds
	And I close all client application windows
		
