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


Scenario: _005011 check that a country cannot be created manually from the choice form
	And I close all client application windows
	* Open the Countries choice form from the Company card
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Country"
		Then "Countries" window is opened
	* Manual creation commands are not available
		If 'FormCreate' attribute is present on the form Then
			Then I raise "Create command must not be available on the Countries choice form" exception
		If 'FormCopy' attribute is present on the form Then
			Then I raise "Copy command must not be available on the Countries choice form" exception
	And I close all client application windows


Scenario: _005012 check that a country can be loaded from the classifier out of the choice form
	And I close all client application windows
	* Open the Countries choice form from the Company card
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Country"
		Then "Countries" window is opened
	* Load a country from the classifier
		And I click "Load countries" button
		And I go to line in "CountryList" table
			| "Code" | "Description" |
			| "792"  | "Turkey"      |
		And I click "Create selected" button
		And I close current window
	* The loaded country can be selected into the Company card
		And I go to line in "List" table
			| "Description" |
			| "Turkey"      |
		And I click the button named "FormChoose"
		Then the form attribute named "Country" became equal to "Turkey"
	And I close all client application windows


Scenario: _005013 check that a country cannot be created manually from the list form
	And I close all client application windows
	* Open the Countries list form
		Given I open hyperlink "e1cib/list/Catalog.Countries"
		Then "Countries" window is opened
	* Manual creation commands are not available
		If 'FormCreate' attribute is present on the form Then
			Then I raise "Create command must not be available on the Countries list form" exception
		If 'FormCopy' attribute is present on the form Then
			Then I raise "Copy command must not be available on the Countries list form" exception
	And I close all client application windows