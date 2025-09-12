#language: en
@tree
@Positive
@ItemCatalogs

Feature: filling in catalog Partner Items



Background:
	Given I open new TestClient session or connect the existing one


Scenario: _005210 filling in the "Partner Items" catalog 
	When set True value to the constant
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Units objects (box (8 pcs))
		When Create catalog Units objects (pcs)
	* Check user language	
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		If "Data localization" field value does not contain "English" text Then
			And I select "English" exact value from "Data localization" drop-down list
			And I click "Save and close" button
			And I close TestClient session
			Given I open new TestClient session or connect the existing one	
		And I close all client application windows	
	* Create Partner Items
		Given I open hyperlink "e1cib/list/Catalog.PartnerItems"
		And I click the button named "FormCreate"
		And I click Open button of "ENG" field
		And I input "Dress XS/Blue Ferron" text in "ENG" field
		And I input "Dress XS/Blue Ferron TR" text in "TR" field
		And I click "Ok" button
		And I input "QN90999" text in "Item ID" field
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I click Select button of "Item key" field
		And "List" table does not contain lines
			| 'Item'     |
			| 'Boots'    |
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check creation
		And I go to line in "List" table
			| 'Description'            | 'Partner'     | 'Item ID'   | 'Item'    | 'Item key'    |
			| 'Dress XS/Blue Ferron'   | 'Ferron BP'   | 'QN90999'   | 'Dress'   | 'XS/Blue'     |
		And I select current line in "List" table
		Then the form attribute named "ItemID" became equal to "QN90999"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Item" became equal to "Dress"
		Then the form attribute named "ItemKey" became equal to "XS/Blue"
		Then the form attribute named "Code" became equal to "1"
		Then the form attribute named "Description_en" became equal to "Dress XS/Blue Ferron"
		And I close all client application windows
		
Scenario: _005211 check hierarchical in the catalog PartnerItems	
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.PartnerItems"	
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
		And I select from the drop-down list named "Partner" by "Ferron BP" string
		And I select from the drop-down list named "Item" by "Dress" string
		And I select from "Item key" drop-down list by "M/Brown" string		
		And I click "Save and close" button
		And "List" table contains lines
			| 'Description'  |
			| 'Group 01'     |
			| 'Test element' |