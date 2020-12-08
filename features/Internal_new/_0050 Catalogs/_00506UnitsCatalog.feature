#language: en
@tree
@Positive
@ItemCatalogs

Feature: filling in Units catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one




Scenario: _00506 filling in the "Units" catalog
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog ItemTypes objects (Clothes, Shoes)
	When Create catalog Units objects (pcs)
	When Create catalog Items objects (Boots)
	* Opening the form for filling in "Units"
		Given I open hyperlink "e1cib/list/Catalog.Units"
		And I click the button named "FormCreate"
	* Creating a unit of measurement 'pcs'
		And I click Open button of the field named "Description_en"
		And I input "test pcs" text in the field named "Description_en"
		And I input "test adet" text in the field named "Description_tr"
		And I input "test шт" text in the field named "Description_ru"
		And I click "Ok" button
		And I input "1" text in the field named "Quantity"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create a unit of measurement for 4 pcs packaging
		And I click the button named "FormCreate"
		And I click Choice button of the field named "BasisUnit"
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "box (4 pcs)" text in the field named "Description_en"
		And I input "box (4 adet)" text in the field named "Description_tr"
		And I click "Ok" button
		And I input "4" text in the field named "Quantity"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Check for created elements
		Then I check for the "Units" catalog element with the "Description_en" "test pcs"  
		Then I check for the "Units" catalog element with the "Description_tr" "test adet"
		Then I check for the "Units" catalog element with the "Description_ru" "test шт"
		Then I check for the "Units" catalog element with the "Description_en" "box (4 pcs)"
	* Create individual unit from Item -tab Item unit (without base unit)
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'      |
		And I select current line in "List" table
		And In this window I click command interface button "Item units"
		And I click the button named "FormCreate"
		And I input "test individual unit 1" text in "ENG" field
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'      |
		And I select current line in "List" table
		And I input "1,00000" text in "Quantity" field
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'    |
		And I select current line in "List" table
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description' |
			| 'pcs'         |
			| 'test individual unit 1' |
	* Create individual unit from Item -tab Item unit (with base unit)
		And I click the button named "FormCreate"
		And I input "test individual unit 2" text in "ENG" field
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'      |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'test individual unit 1'    |
		And I select current line in "List" table	
		And I input "2,00000" text in "Quantity" field
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description' |
			| 'pcs'         |
			| 'test individual unit 1' |
			| 'test individual unit 2' |
	* Сheck that only a common storage unit can be selected (field Unit)
		And In this window I click command interface button "Main"
		And I click Select button of "Unit" field
		And "List" table does not contain lines
			| 'Description' |
			| 'test individual unit 1' |
			| 'test individual unit 2' |
		And I close current window
	* Сheck that when creating an individual unit you need to select a basis unit
		And In this window I click command interface button "Item units"
		And I click the button named "FormCreate"
		And I input "test individual unit 3" text in "ENG" field
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'      |
		And I select current line in "List" table
		And I input "1,00000" text in "Quantity" field
		And I click "Save and close" button
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Given Recent TestClient message contains "Basis unit has to be filled, if item filter used." string by template
		And I close all client application windows	

Scenario: _0050601 check Dimensions and weight information
	*  Select unit
		Given I open hyperlink "e1cib/list/Catalog.Units"
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'         |
		And I select current line in "List" table
	* Change dimensions and check volume calculation
		And I expand "Dimensions" group
		And I input "10,000" text in "Length" field
		And I input "10,000" text in "Width" field
		And I input "10,000" text in "Height" field
		Then the form attribute named "Volume" became equal to "1 000,000"
		And I input "0,020" text in "Length" field
		And the editing text of form attribute named "Volume" became equal to "2,000"
		And I click "Save" button
		And the editing text of form attribute named "Volume" became equal to "2,000"
		And I input "2,005" text in "Volume" field
		And I click "Save" button
		And the editing text of form attribute named "Volume" became equal to "2,005"
		And I input "20,000" text in "Width" field
		And the editing text of form attribute named "Volume" became equal to "2 000,000"
		And I input "20,000" text in "Height" field
		And the editing text of form attribute named "Volume" became equal to "4 000,000"
	* Change weight information and check saving
		And I expand "Weight information" group
		And I input "10,000" text in "Weight" field
		And I click "Save" button
		And the editing text of form attribute named "Weight" became equal to "10,000"
		And I close all client application windows
		
				

				
		
				
				


				

		
				

		
				

		