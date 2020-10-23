#language: en
@tree
@Positive
@Catalogs

Feature: filling in Companies catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one



Scenario: _005013 filling in the "Companies" catalog
	* Preparation
		And I close all client application windows
		When Create catalog IntegrationSettings objects
		When Create catalog Currencies objects
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Buying' |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'  |
			| 'Forex Seling' |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description' |
			| 'Bank UA'     |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
	* Opening the form for filling in
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I click the button named "FormCreate"
	* Create Own company
		* Filling in company information
			And I click Open button of the field named "Description_en"
			And I input "Our Company" text in the field named "Description_en"
			And I input "Our Company TR" text in the field named "Description_tr"
			And I input "Главная компания" text in the field named "Description_ru"
			And I click "Ok" button
			And I input "Turkey" text in the field named "Country"
			And I set checkbox "Our Company"
			And I select "Company" exact value from the drop-down list named "Type"
			And I click "Save" button
		* Filling in currency information (Local currency, Reporting currency, Budgeting currency)
			And I move to "Currencies" tab
			* Creation and addition of Local currency
				And in the table "Currencies" I click the button named "CurrenciesAdd"
				And I click choice button of "Movement type" attribute in "Currencies" table
				And I click the button named "FormCreate"
				And I input "Local currency" text in the field named "Description_en"
				And I click Select button of "Currency" field
				And I go to line in "List" table
					| 'Code' | 'Description'  |
					| 'TRY'  | 'Turkish lira' |
				And I select current line in "List" table
				And I click Select button of "Source" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Forex Seling' |
				And I select current line in "List" table
				And I select "Legal" exact value from "Type" drop-down list
				And I click "Save and close" button
				And Delay 5
				And I click the button named "FormChoose"
				And I finish line editing in "Currencies" table
			* Creation and addition of Reporting currency
				And in the table "Currencies" I click the button named "CurrenciesAdd"
				And I click choice button of "Movement type" attribute in "Currencies" table
				And I click the button named "FormCreate"
				And I click Select button of "Currency" field
				And I go to line in "List" table
					| 'Code' | 'Description'     |
					| 'USD'  | 'American dollar' |
				And I activate "Description" field in "List" table
				And I select current line in "List" table
				And I click Select button of "Source" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Forex Seling' |
				And I select current line in "List" table
				And I select "Reporting" exact value from "Type" drop-down list
				And I input "Reporting currency" text in the field named "Description_en"
				And I click "Save and close" button
				And I click the button named "FormChoose"
			* Creation and addition of Budgeting currency
				And in the table "Currencies" I click the button named "CurrenciesAdd"
				And I click choice button of "Movement type" attribute in "Currencies" table
				And I click the button named "FormCreate"
				And I click Select button of "Currency" field
				And I go to line in "List" table
					| 'Code' | 'Description'     |
					| 'USD'  | 'American dollar' |
				And I activate "Description" field in "List" table
				And I select current line in "List" table
				And I click Select button of "Source" field
				And I go to line in "List" table
					| 'Description'  |
					| 'Forex Seling' |
				And I select current line in "List" table
				And I select "Budgeting" exact value from "Type" drop-down list
				And I input "Budgeting currency" text in the field named "Description_en"
				And I set checkbox "Deferred calculation"
				And I click "Save and close" button
				And I click the button named "FormChoose"
				And I finish line editing in "Currencies" table
			And I click "Save and close" button
			And Delay 5
		* Check the availability of the created company in the catalog
			Then I check for the "Companies" catalog element with the "Description_en" "Our Company" 
			Then I check for the "Companies" catalog element with the "Description_tr" "Our Company TR"
			Then I check for the "Companies" catalog element with the "Description_ru" "Главная компания"
	# * Clean catalog Companies
	# 	And I delete "Companies" catalog element with the Description_en "Main Company"

