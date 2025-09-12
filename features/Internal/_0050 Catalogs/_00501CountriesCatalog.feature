#language: en
@tree
@Positive
@CompanyCatalogs

Feature: filling in Countries catalogs

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one




Scenario: _005010 filling in the "Countries" catalog
	When set True value to the constant
		And I close all client application windows
	* Open Country list form
		Given I open hyperlink "e1cib/list/Catalog.Countries"
	* Load selected countries
		And I click "Load countries" button
		And I go to line in "CountryList" table
			| "Code" | "Description" | "Exists" |
			| "380"  | "Italy"       | "No"     |
		And I click "Create selected" button
		And I go to line in "CountryList" table
			| "Code" | "Description" | "Exists" |
			| "792"  | "Turkey"      | "No"     |
		And I click "Create selected" button
		And I go to line in "CountryList" table
			| "Code" | "Description"    | "Exists" |
			| "826"  | "United Kingdom" | "No"     |
		And I click "Create selected" button
	* Check for added countries in the catalog
		When in opened panel I select "Countries"
		And "List" table became equal
			| "Code" | "Alpha code 2" | "Alpha code 3" | "Description"    |
			| "380"  | "IT"           | "ITA"          | "Italy"          |
			| "792"  | "TR"           | "TUR"          | "Turkey"         |
			| "826"  | "GB"           | "GBR"          | "United Kingdom" |
		And I go to line in "List" table
			| "Alpha code 2" | "Alpha code 3" | "Code" | "Description" |
			| "TR"           | "TUR"          | "792"  | "Turkey"      |
		And I select current line in "List" table
		Then the form attribute named "PhonePrefix" became equal to "+9(0)"
		And I close current window	
	* Load all countries
		When in opened panel I select "Load countries"
		Then I select all lines of "CountryList" table
		And I click "Create selected" button
		And Delay 20
	* Check
		When in opened panel I select "Countries"
		Then the number of "List" table lines is "равно" "250"