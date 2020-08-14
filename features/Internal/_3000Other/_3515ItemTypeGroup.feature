#language: en
@tree
@Positive
Feature: create a group of item types



Background:
    Given I launch TestClient opening script or connect the existing one


Scenario: _351501 create a group of item types
    * Open catalog Item Type
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
    * Create Item Type group
        And I click the button named "FormCreateFolder"
        And I click Open button of "TR" field
        And I input "Accessories" text in the field named "Description_en"
        And I input "Accessories TR" text in the field named "Description_tr"
        And I click "Ok" button
        And I click "Save and close" button
    * Create item type in group Accessories
        And I click the button named "FormCreate"
        And I click Open button of "TR" field
        And I input "Earrings" text in the field named "Description_en"
        And I input "Earrings TR" text in the field named "Description_tr"
        And I click "Ok" button
        And I select from "Parent" drop-down list by "Accessories" string
        And I click "Save and close" button
    * Create item type Earrings
        And I go to line in "List" table
            | 'Description' |
            | 'Accessories TR'            |
        And I move one level down in "List" table
        And "List" table became equal
            | 'Description'    |
            | 'Accessories TR' |
            | 'Earrings TR'    |
        And I close all client application windows
    * Check the items group display in AddAttributeAndPropertySets by item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
        | 'Predefined data item name' |
        | 'Catalog_ItemKeys'          |
        And I select current line in "List" table
        And "AttributesTree" table contains lines
            | 'Presentation'      |
            | 'Accessories TR'    |
            | 'Earrings TR'       |
        And I close all client application windows







