#language: en
@tree
@Positive
@Other

Feature: create a group of item types



Background:
    Given I launch TestClient opening script or connect the existing one



Scenario: _351501 create a group of item types
    When set True value to the constant
    * Open catalog Item Type
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
    * Create Item Type group
        And I click the button named "FormCreateFolder"
        And I click Open button of "ENG" field
        And I input "Cosmetics" text in the field named "Description_en"
        And I input "Cosmetics TR" text in the field named "Description_tr"
        And I click "Ok" button
        And I click "Save and close" button
    * Create item type in group Cosmetics
        And I click the button named "FormCreate"
        And I click Open button of "ENG" field
        And I input "Lipstick" text in the field named "Description_en"
        And I input "Lipstick TR" text in the field named "Description_tr"
        And I click "Ok" button
//        And I select from "Parent" drop-down list by "Cosmetics" string
        And I click Choice button of the field named "Parent"
        And I go to line in "List" table
        	| "Description" |
        	| "Cosmetics"   |
        And I click the button named "FormChoose"		
        And I click "Save and close" button
    * Create item type Lipstick
        And I go to line in "List" table
			| 'Description'             |
			| 'Cosmetics'               |
        And I move one level down in "List" table
        And "List" table became equal
			| 'Description'             |
			| 'Cosmetics'               |
			| 'Lipstick'                |
        And I close all client application windows
    * Check the items group display in AddAttributeAndPropertySets by item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
			| 'Predefined data name'         |
			| 'Catalog_ItemKeys'             |
        And I select current line in "List" table
        And "AttributesTree" table contains lines
			| 'Presentation'             |
			| 'Cosmetics'                |
			| 'Lipstick'                 |
        And I close all client application windows







