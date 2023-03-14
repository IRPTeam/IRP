#language: en
@tree
@Positive
@ItemCatalogs

Feature: filling in catalog Partner Items



Background:
	Given I open new TestClient session or connect the existing one


Scenario: _005210 filling in the "Partner Items" catalog 
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When update ItemKeys
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
			| 'Description' |
			| 'Ferron BP'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click Select button of "Item key" field
		And "List" table does not contain lines
			| 'Item' |
			| 'Boots'       |
		And I go to line in "List" table
			| 'Item key'  |
			| 'XS/Blue' |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check creation
		And I go to line in "List" table
			| 'Description'          | 'Partner'   | 'Item ID' | 'Item'  | 'Item key' |
			| 'Dress XS/Blue Ferron' | 'Ferron BP' | 'QN90999' | 'Dress' | 'XS/Blue'  |
		And I select current line in "List" table
		Then the form attribute named "ItemID" became equal to "QN90999"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Item" became equal to "Dress"
		Then the form attribute named "ItemKey" became equal to "XS/Blue"
		Then the form attribute named "Code" became equal to "1"
		Then the form attribute named "Description_en" became equal to "Dress XS/Blue Ferron"
		And I close all client application windows
		
		
				
		
				
		
				

