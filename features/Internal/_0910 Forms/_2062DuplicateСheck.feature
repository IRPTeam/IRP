#language: en
@tree
@Positive
@Forms
Feature: duplicate check



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _206200 preparation
	* Auto filling Configuration metadata catalog
		When auto filling Configuration metadata catalog
	* Create test bank term
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		If "List" table does not contain lines Then
			| 'Description' |
			| 'Test02'  |
			And I click the button named "FormCreate"
			And I click Open button of "ENG" field
			And I input "Test02" text in "RU" field
			And I input "Test02" text in "TR" field
			And I input "Test02" text in "ENG" field
			And I click "Ok" button		
			And I click "Save and close" button
			And "List" table contains lines
				| 'Description' |
				| 'Test02'  |
		And I close all client application windows
	* Create test Addresses hierarchy element
	 	Given I open hyperlink "e1cib/list/Catalog.IDInfoAddresses"
		 If "List" table does not contain lines Then
			| 'Description' |
			| 'Test02'  |
			And I click the button named "FormCreate"
			And I input "Test02" text in "Description" field
			And I click Select button of "Owner" field
			And I click the button named "FormCreate"
			And I input "Test02" text in "ENG" field
			And I click "Save and close" button
			And I click the button named "FormChoose"	
			And I click "Save and close" button
			And "List" table contains lines
				| 'Description' |
				| 'Test02'  |
		And I close all client application windows
		

Scenario: _206201 duplicate check (multi language catalog)
	* Add settings for duplicate check
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Bank terms'  |
		And I select current line in "List" table
		And I set checkbox "Check description duplicate"
		And I click "Save and close" button
	* Duplicate check (Description_en)
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I input "Test02" text in "ENG" field
		And I click "Save and close" button
		Then I wait that in user messages the 'Description (en) "Test02" is already in use.' substring will appear in "10" seconds
	* Duplicate check (Description_tr)
		And I click Open button of "ENG" field
		And I input "Test02" text in "TR" field
		And I input "Test03" text in "ENG" field
		And I click "Ok" button	
		And I click "Save and close" button
		Then I wait that in user messages the 'Description (tr) "Test02" is already in use.' substring will appear in "10" seconds
	* Duplicate check (Description_ru)
		And I click Open button of "ENG" field
		And I input "Test03" text in "TR" field
		And I input "Test02" text in "RU" field
		And I click "Ok" button	
		And I click "Save and close" button
		Then I wait that in user messages the 'Description (ru) "Test02" is already in use.' substring will appear in "10" seconds
	* Duplicate check (all Descriptions)
		And I click Open button of "ENG" field
		And I input "Test02" text in "TR" field
		And I input "Test02" text in "ENG" field
		And I click "Ok" button	
		And I click "Save and close" button
		Then I wait that in user messages the 'Description (ru) "Test02" is already in use.' substring will appear in "10" seconds
		Then I wait that in user messages the 'Description (en) "Test02" is already in use.' substring will appear in "10" seconds
		Then I wait that in user messages the 'Description (tr) "Test02" is already in use.' substring will appear in "10" seconds
		And I close all client application windows

Scenario: _206202 switch-off duplicate checks
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Bank terms'  |
		And I select current line in "List" table
		And I remove checkbox "Check description duplicate"	
		And I click "Save and close" button
		Given I open hyperlink "e1cib/list/Catalog.BankTerms"
		And I click the button named "FormCreate"
		And I click Open button of "ENG" field
		And I input "Test02" text in "RU" field
		And I input "Test02" text in "TR" field
		And I input "Test02" text in "ENG" field
		And I click "Ok" button		
		And I click "Save and close" button
		Then user message window does not contain messages
		And "List" table contains lines
			| 'Description' |
			| 'Test02'  |
			| 'Test02'  |
		And I close all client application windows


Scenario: _206205 duplicate check (not multi language catalog)
	* Add settings for duplicate check
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I click "List" button
		And I go to line in "List" table
			| 'Description' |
			| 'Addresses hierarchy'  |
		And I select current line in "List" table
		And I set checkbox "Check description duplicate"
		And I click "Save and close" button
	* Duplicate check (Description)
		Given I open hyperlink "e1cib/list/Catalog.IDInfoAddresses"
		And I click the button named "FormCreate"
		And I input "Test02" text in "Description" field
		And I click Select button of "Owner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Test02'      |
		And I select current line in "List" table		
		And I click "Save and close" button
		Then I wait that in user messages the 'Description "Test02" is already in use.' substring will appear in "10" seconds
		And I close all client application windows
		



		

		
				
		
				


		
				
		
				

	