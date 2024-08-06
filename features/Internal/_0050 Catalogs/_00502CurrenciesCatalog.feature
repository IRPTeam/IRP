#language: en
@tree
@Positive
@SettingsCatalogs

Feature: filling in Currencies catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005011 filling in the "Currencies" catalog
	When set True value to the constant
	* Open Currency list form
		Given I open hyperlink "e1cib/list/Catalog.Currencies"
	* Load selected currencies
		And I click "Load currency" button
		And I go to line in "CurrencyList" table
			| "Code" | "Numeric code" | "Description" |
			| "EUR"  | "978"          | "Euro"        |
		And I click "Create selected" button
		And I go to line in "CurrencyList" table
			| "Code" | "Numeric code" | "Description"   |
			| "TRY"  | "949"          | "Turkish Lira"  |
		And I click "Create selected" button
	* Check for added currencies in the catalog
		When in opened panel I select "Currencies"
		And "List" table became equal
			| "Numeric code" | "Code" | "Description"  |
			| ""             | "USD"  | ""             |
			| "978"          | "EUR"  | "Euro"         |
			| "949"          | "TRY"  | "Turkish Lira" |
		And I close all client application windows