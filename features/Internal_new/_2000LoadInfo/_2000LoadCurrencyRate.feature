#language: en
@tree
@Positive
@LoadInfo

Feature: check loading currency from external resources

As a developer
I want to create a processing to download currency rates from external resources.
To upload currency rates to the base

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _020000 preparation (Loadinfo)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog CashAccounts objects
		When Create catalog PriceTypes objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog IntegrationSettings objects
		* Integration settings
			

Scenario: _020001 check load currency rate
	And I turn on asynchronous execution mode with interval "1"
	* Filling in the setting for currency rate loading from Bank UA
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| Description |
			| Bank UA     |
		And I select current line in "List" table
		And I click "Settings" button
		And I click Select button of "Currency from" field
		And I go to line in "List" table
			| Code | Description     |
			| UAH  | Ukraine Hryvnia |
		And I select current line in "List" table
		And I click "Ok" button
		And I click "Save and close" button
	* Open catalog currency
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
	* Upload currency rate Forex Buying (from tcmb.gov.tr)
		And I click "Integrations" button
		And I go to line in "IntegrationTable" table
			| Integration settings |
			| Forex Buying         |
		And I click "Ok" button
		And I click Select button of "Period" field
		And I click "Clear period" button
		And I input begin of the current month date in "DateBegin" field
		And I input current date in "DateEnd" field
		And I click "Select" button
		And I go to line in "Currencies" table
			| 'Code' |
			| 'USD'  |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And I go to line in "Currencies" table
			| 'Code' |
			| 'EUR'  |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And in the table "Currencies" I click "Download" button
		And Delay 40
		And I close all client application windows
	* Upload currency rate Forex Selling (from tcmb.gov.tr)
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I click "Integrations" button
		And I go to line in "IntegrationTable" table
			| Integration settings |
			| Forex Seling         |
		And I click "Ok" button
		And I click Select button of "Period" field
		And I click "Clear period" button
		And I input begin of the current month date in "DateBegin" field
		And I input current date in "DateEnd" field
		And I click "Select" button
		And I go to line in "Currencies" table
			| Code |
			| USD  |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And in the table "Currencies" I click "Download" button
		And Delay 40
		And I close all client application windows
	* Upload currency rate Bank UA (from bank.gov.ua)
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
		And I click "Integrations" button
		And I go to line in "IntegrationTable" table
			| Integration settings |
			| Bank UA         |
		And I click "Ok" button
		And I click Select button of "Period" field
		And I click "Clear period" button
		And I input begin of the current month date in "DateBegin" field
		And I input current date in "DateEnd" field
		And I click "Select" button
		And I go to line in "Currencies" table
			| 'Code' |
			| 'USD'  |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And I go to line in "Currencies" table
			| 'Code' |
			| 'EUR'  |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And I go to line in "Currencies" table
			| 'Code' |
			| 'TRY'  |
		And I set "Download" checkbox in "Currencies" table
		And I finish line editing in "Currencies" table
		And in the table "Currencies" I click "Download" button
		And Delay 40
		And I close all client application windows
	* Check currency downloads
		Given I open hyperlink "e1cib/list/InformationRegister.CurrencyRates"
		And "List" table contains lines
			| 'Currency from'  | 'Currency to'   | 'Source'        | 'Multiplicity' | 'Rate'  |
			| 'UAH'            | 'USD'           | 'Bank UA'       | '1'            | '*'     |
			| 'UAH'            | 'EUR'           | 'Bank UA'       | '1'            | '*'     |
			| 'UAH'            | 'TRY'           | 'Bank UA'       | '1'            | '*'     |
		And I close all client application windows



Scenario: _999999 close TestClient session
	And I close TestClient session