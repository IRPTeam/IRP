#language: en
@tree
@Positive
@SettingsCatalogs

Feature: filling in Price types catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005028 filling in the "Price types" catalog  
	When set True value to the constant
	* Preparation
		When Create catalog Currencies objects
		When Create catalog IntegrationSettings objects
	* Opening a form and creating customer prices Basic Price Types
		Given I open hyperlink "e1cib/list/Catalog.PriceTypes"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Basic Price Types" text in the field named "Description_en"
		And I input "Basic Price Types TR" text in the field named "Description_tr"
		And I input "Базовая цена" text in the field named "Description_ru"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code    |
			| TRY     |
		And I select current line in "List" table
		And I click the button named "FormWrite"
		When TestClient log message contains '"Source" is a required field.' string
		* Filling Source
			And I click Choice button of the field named "Source"
			And I go to line in "List" table
				| 'Description'      |
				| 'Forex Buying'     |
			And I select current line in "List" table	
			And I click the button named "FormWrite"		
		* Check data save
			Then the form attribute named "Currency" became equal to "TRY"
			Then the form attribute named "Description_en" became equal to "Basic Price Types"
		And I click the button named "FormWriteAndClose"
	* Check for created price types
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Basic Price Types"
		Then I check for the "PriceTypes" catalog element with the "Description_tr" "Basic Price Types TR"
		Then I check for the "PriceTypes" catalog element with the "Description_ru" "Базовая цена"
	* Check manual price type
		Given I open hyperlink "e1cib/list/Catalog.PriceTypes"
		And I go to line in "List" table
			| 'Code'    |
			| ''        |
		And I select current line in "List" table
		And I input "Manual price type" text in "ENG" field
		And I click "Save and close" button
		And Delay 3
		Then I check for the "PriceTypes" catalog element with the "Description_en" "Manual price type"
				
	# * Clean catalog
	# 	And I delete "PriceTypes" catalog element with the Description_en "Basic Price Types"


Scenario: _005029 check hierarchical in the catalog PriceTypes	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.PriceTypes"	
	* Create Group 01
		And I click the button named "FormCreateFolder"
		And I input "Group 01" text in "ENG" field
		And I click "Save and close" button
	* Create Group 02
		And I click the button named "FormCreateFolder"
		And I input "Group 02" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Group 02 tr" text in "TR" field
		And I click "Ok" button
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
		And I input "Test element" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Test element tr" text in "TR" field
		And I click "Ok" button
		And I click Choice button of the field named "Parent"
		And I expand current line in "List" table
		And I go to line in "List" table
			| "Description" |
			| "Group 02"    |
		And I click the button named "FormChoose"
		And I click Select button of "Currency" field	
		And I go to line in "List" table
			| 'Code'    |
			| 'TRY'     |
		And I select current line in "List" table
		And I click Select button of "Source" field	
		And I go to line in "List" table
				| 'Description'      |
				| 'Forex Buying'     |
		And I select current line in "List" table	
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'  |
			| 'Group 01'     |
			| 'Test element' |