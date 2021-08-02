#language: en
@tree
@Positive
@PartnerCatalogs


Feature: filling in Retail customers catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one



	

Scenario: _005049 filling in the "Retail customers" catalog
	When set True value to the constant
	And I close TestClient session
	When Create catalog Companies objects (Main company)
	When Create catalog Stores objects
	When Create catalog PriceTypes objects
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Partners objects and Companies objects (Customer)
	When Create catalog Agreements objects (Customer)
	Given I open new TestClient session or connect the existing one
	* Open and filling in Retail customer with Partner and Legal name
		Given I open hyperlink "e1cib/list/Catalog.RetailCustomers"
		And I click the button named "FormCreate"
		And I input "Description Retail customer" text in the field named "Description"
		And I input "Name Retail customer" text in the field named "Name"
		And I input "Surname Retail customer" text in the field named "Surname"
		And I input "002" text in the field named "Code"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Customer'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description' |
			| 'Customer'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Customer partner term'    |
		And I select current line in "List" table		
		And I click "Save and close" button
		And Delay 2
	* Check for created Retail customer
		And "List" table contains lines
		| 'Description'                                  | 'Code' | 'Name'                 | 'Surname'                 |
		| 'Name Retail customer Surname Retail customer' | '002'  | 'Name Retail customer' | 'Surname Retail customer' |
		And I close all client application windows
