#language: en
@tree
@Positive
@CompanyCatalogs

Feature: filling in Companies catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _0050130 preparation (Companies)
	Given I open hyperlink "e1cib/list/Catalog.Extensions"
	If "List" table does not contain lines Then
			| "Description"     |
			| "VAExtension"     |
		When add VAExtension

Scenario: _005013 filling in the "Companies" catalog
	When set True value to the constant
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window
	* Preparation
		And I close all client application windows
		When Create catalog IntegrationSettings objects
		When Create catalog Currencies objects
		Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
		And I go to line in "List" table
			| 'Description'     |
			| 'Forex Buying'    |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Forex Seling'    |
		And I select current line in "List" table
		And I select "Currency rates" exact value from "Integration type" drop-down list
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'    |
			| 'Bank UA'        |
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
					| 'Code'     | 'Description'       |
					| 'TRY'      | 'Turkish lira'      |
				And I select current line in "List" table
				And I click Select button of "Source" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Forex Seling'      |
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
					| 'Code'     | 'Description'          |
					| 'USD'      | 'American dollar'      |
				And I activate "Description" field in "List" table
				And I select current line in "List" table
				And I click Select button of "Source" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Forex Seling'      |
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
					| 'Code'     | 'Description'          |
					| 'USD'      | 'American dollar'      |
				And I activate "Description" field in "List" table
				And I select current line in "List" table
				And I click Select button of "Source" field
				And I go to line in "List" table
					| 'Description'       |
					| 'Forex Seling'      |
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

Scenario: _005015 create Projects
	* Open a creation form Projects
		Given I open hyperlink "e1cib/list/Catalog.Projects"
		* Check hierarchical
			When create Groups in the catalog
	* Create 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Project 01" text in the field named "Description_en"
		And I input "Project 01 TR" text in the field named "Description_tr"
		And I input "Проект 01" text in "RU" field
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 3
	* Check creation
		Then I check for the "Projects" catalog element with the "Description_en" "Project 01"
		Then I check for the "Projects" catalog element with the "Description_tr" "Project 01 TR"
		Then I check for the "Projects" catalog element with the "Description_ru" "Проект 01"

Scenario: _005016 name uniqueness control (Projects)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.Projects"
		And I click "List" button
		If "List" table does not contain lines Then
			| 'Description' |
			| 'Project 01'       |
			Then I stop script execution "Skipped"
	* Create project
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Project 01" text in the field named "Description_en"
		And I input "Project 01 TR" text in the field named "Description_tr"
		And I input "Проект 01" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
	* Check uniqueness control
		Then there are lines in TestClient message log
			|'Description not unique [Project 01]'|
		And I click Open button of the field named "Description_en"
		And I input "1" text in the field named "Description_en"	
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		Then there are lines in TestClient message log
			|'Description not unique [Project 01]'|	
		And I click Open button of the field named "Description_en"
		And I input "1" text in the field named "Description_tr"	
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		Then there are lines in TestClient message log
			|'Description not unique [Project 01]'|	
		And I close all client application windows	

Scenario: _0050161 create Incoterms
	* Open a creation form Incoterms
		Given I open hyperlink "e1cib/list/Catalog.Incoterms"
	* Create 
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Cost and Freight" text in the field named "Description_en"
		And I input "Cost and Freight TR" text in the field named "Description_tr"
		And I input "Cost and Freight RU" text in "RU" field
		And I click "Ok" button
		And I input "CFR" text in the field named "Code"
		And I click "Yes" button	
		And I click the button named "FormWriteAndClose"
		And Delay 3
	* Check creation
		Then I check for the "Incoterms" catalog element with the "Description_en" "Cost and Freight"
		Then I check for the "Incoterms" catalog element with the "Description_tr" "Cost and Freight TR"
		Then I check for the "Incoterms" catalog element with the "Description_ru" "Cost and Freight RU"

Scenario: _0050162 create Hardware
		And I close all client application windows
	* Open a creation form Hardware
		Given I open hyperlink "e1cib/list/Catalog.Hardware"
	* Create Group 01
		And I click the button named "FormCreateFolder"
		And I input "Group 01" text in "Description" field
		And I click "Save and close" button
	* Create Group 02
		And I click the button named "FormCreateFolder"
		And I input "Group 02" text in "Description" field
		And I click Choice button of the field named "Parent"
		And I go to line in "List" table
			| "Description" |
			| "Group 01"    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check 
		And "List" table became equal
			| 'Description' |
			| 'Group 01'    |
			| 'Group 02'    |
	* Create element in Group
		And I click "Create" button
		And I input "Test element" text in "Description" field
		And I select "Fiscal printer" exact value from "Types of Equipment" drop-down list	
		And I click Choice button of the field named "Parent"
		And I expand current line in "List" table
		And I go to line in "List" table
			| "Description" |
			| "Group 02"    |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'  |
			| 'Group 01'     |
			| 'Test element' |

Scenario: _0050163 create PlanningPeriods
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
		And Delay 2
	* Create Group 01
		And I click the button named "FormCreateFolder"
		And I input "Group 01" text in "Description" field
		And I click "Save and close" button
	* Create Group 02
		And I click the button named "FormCreateFolder"
		And I input "Group 02" text in "Description" field
		And I click Choice button of the field named "Parent"
		And I go to line in "List" table
			| "Description" |
			| "Group 01"    |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check 
		And "List" table became equal
			| 'Description' |
			| 'Group 01'    |
			| 'Group 02'    |
	* Create element in Group
		And I click "Create" button
		And I input "Test element" text in "Description" field
		And I click Choice button of the field named "Parent"
		And I expand current line in "List" table
		And I go to line in "List" table
			| "Description" |
			| "Group 02"    |
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'  |
			| 'Group 01'     |
			| 'Test element' |
		And I close all client application windows

Scenario: _005064 name uniqueness control (Company)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		If "List" table does not contain lines Then
			| 'Description' |
			| 'Our Company' |
			Then I stop script execution "Skipped"
	* Create company (legal name for Our company)
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Our Company" text in the field named "Description_en"
		And I input "Our Company TR" text in the field named "Description_tr"
		And I input "Наша компания 01" text in the field named "Description_ru"
		And I click "Ok" button
		And I select "Company" exact value from the drop-down list named "Type"
		And I click the button named "FormWrite"
	* Check uniqueness control
		Then user message window does not contain messages
		And current window form does not have modification mark (extension)
	* Check uniqueness control (two identical names for own companies)
		And I set checkbox "Our Company"
		And I click the button named "FormWrite"		
		Then there are lines in TestClient message log
			|'Description not unique [Our Company]'|	
		And current window form has modification mark (extension)
	* Check uniqueness control (two identical names for legal name)
		And I click Open button of the field named "Description_en"
		And I input "Our Company L" text in the field named "Description_en"
		And I input "Our Company L TR" text in the field named "Description_tr"
		And I input "Наша компания L 01" text in the field named "Description_ru"
		And I click "Ok" button
		And I select "Company" exact value from the drop-down list named "Type"
		And I remove checkbox "Our Company"
		And I click the button named "FormWriteAndClose"
		And I go to line in "List" table
			| "Description" |
			| "Our Company" |
		And I select current line in "List" table
		And I remove checkbox "Our Company"
		And I click Open button of the field named "Description_en"
		And I input "Our Company L" text in the field named "Description_en"
		And I input "Our Company L TR" text in the field named "Description_tr"
		And I input "Наша компания L 01" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"		
		Then there are lines in TestClient message log
			|'Description not unique [Our Company L]'|	
		And current window form has modification mark (extension)
		And I close all client application windows