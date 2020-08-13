#language: en
@tree
@Positive
Feature: checking a bunch of additional details in the item type for the item key composition

As a Developer
I want to create a link to transfer the extra details from item type to item key
For appropriation of their items

Background:
    Given I launch TestClient opening script or connect the existing one


Scenario: _350000 preparation for check a bunch of additional details in item type and their display in the set for item key / price key
    * Open Add attribute and property sets for item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        And I select current line in "List" table
        And I click Open button of "TR" field
        And I input "Item key" text in the field named "Description_en"
        And I click "Ok" button
        And I click "Save" button
    * Create item type
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And Delay 2
        And I click the button named "FormCreate"
        And Delay 2
        And I click Open button of "TR" field
        And I input "Socks" text in the field named "Description_en"
        And I input "Socks TR" text in the field named "Description_tr"
        And I click "Ok" button
        And I click "Save" button
    * Create Add attribute for Socks
        * Create Add attribute Color Socks TR
            Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
            And I click the button named "FormCreate"
            And I click Open button of "TR" field
            And I input "Color Socks TR" text in the field named "Description_tr"
            And I input "Color Socks" text in the field named "Description_en"
            And I click "Ok" button
        * Setting the required filling additional attribute Color Socks TR
            And I click "Set \"Required\" at all sets" button
            Then "Choice value" window is opened
            And I select "Yes" exact value from "InputFld" drop-down list
            And I click "OK" button
            And I click "Save and close" button
            And Delay 2
        * Create Add attribute Brand Socks TR
            Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
            And I click the button named "FormCreate"
            And I click Open button of "TR" field
            And I input "Brand Socks TR" text in the field named "Description_tr"
            And I input "Brand Socks" text in the field named "Description_en"
            And I click "Ok" button
            And I click "Save and close" button
            And I close all client application windows
        * Create Add attribute Article Socks TR
            Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
            And I click the button named "FormCreate"
            And I click Open button of "TR" field
            And I input "Article Socks TR" text in the field named "Description_tr"
            And I input "Article Socks" text in the field named "Description_en"
            And I click "Ok" button
            And I click "Save and close" button
            And I close all client application windows
    * Filling in sescription AddAttributeAndProperty sets for Price key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
        | 'Predefined data item name' |
        | 'Catalog_PriceKeys'          |
        And I select current line in "List" table
        And I click Open button of "TR" field
        And I input "Price Keys" text in the field named "Description_en"
        And I click "Ok" button
        And I click "Save" button
    And I close all client application windows



Scenario: _350001 check the connection between adding additional details to item type and displaying them in the set for item key
    * Open item type Socks
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And I go to line in "List" table
            | 'Description' |
            | 'Socks TR'    |
        And I select current line in "List" table
    * Open Additional attribute sets for item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        And I select current line in "List" table
    * Check the ligament
        * Add additional attribute in item type
            When in opened panel I select "Item types"
            And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
            And I click choice button of "Attribute" attribute in "AvailableAttributes" table
            And I go to line in "List" table
                | 'Description' |
                | 'Brand Socks TR'    |
            And I select current line in "List" table
            And I set "Required" checkbox in "AvailableAttributes" table
            And I finish line editing in "AvailableAttributes" table
            And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
            And I click choice button of "Attribute" attribute in "AvailableAttributes" table
            And I go to line in "List" table
                | 'Description' |
                | 'Color Socks TR'    |
            And I select current line in "List" table
            And I finish line editing in "AvailableAttributes" table
            And I click "Save" button
        * Check to add them to Additional attribute sets by item key
            When in opened panel I select "Additional attribute sets"
            And "AttributesTree" table contains lines
                | 'Presentation'    |
                | 'Socks TR'        |
                | 'Brand Socks TR'       |
                | 'Color Socks TR'        |
        * Removing an additional attribute from an item type and checking to delete it from Additional attribute sets by item key
            When in opened panel I select "Item types"
            And I go to line in "AvailableAttributes" table
                | 'Attribute' |
                | 'Brand Socks TR'  |
            And I delete a line in "AvailableAttributes" table
            And I click "Save" button
            When in opened panel I select "Additional attribute sets"
            And "AttributesTree" table does not contain lines
                | 'Presentation'    |
                |  'Brand Socks TR' |
        * Add additional attribute back and check ligament 
            When in opened panel I select "Item types"
            And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
            And I click choice button of "Attribute" attribute in "AvailableAttributes" table
            And I go to line in "List" table
                | 'Description' |
                | 'Brand Socks TR'    |
            And I select current line in "List" table
            And I click "Save" button
            When in opened panel I select "Additional attribute sets"
            And "AttributesTree" table contains lines
                | 'Presentation'    |
                | 'Brand Socks TR'  |
        And I close all client application windows
        * Deletion of additional attributes from Additional attribute sets by item key and check of linkage with item type
            * Delete additional attribute AddAttributeAndPropertySets from item key
                Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
                And I go to line in "List" table
                    | 'Predefined data item name' |
                    | 'Catalog_ItemKeys'          |
                And I select current line in "List" table
                And I go to line in "AttributesTree" table
                    | 'Presentation'    |
                    | 'Brand Socks TR'  |
                And I click "DeleteItemType" button
            * Open item type and check deletion
                Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
                And I go to line in "List" table
                    | 'Description' |
                    | 'Socks TR'    |
                And I select current line in "List" table
                And "AvailableAttributes" table does not contain lines
                    | 'Attribute' |
                    | 'Brand Socks TR'  |
            * Add additional attribute back
                And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
                And I click choice button of "Attribute" attribute in "AvailableAttributes" table
                And I go to line in "List" table
                    | 'Description' |
                    | 'Brand Socks TR'    |
                And I select current line in "List" table
                And I click "Save" button
        And I close all client application windows

Scenario: _350002 check the connection between the installation according to the additional attribute of the sign of influence on the price and Add atribute and property sets by Price key
        * Open Additional attribute sets for price key
            Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
            And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_PriceKeys'          |
            And I select current line in "List" table
        * Open item type Socks
            Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
            And I go to line in "List" table
            | 'Description' |
            | 'Socks TR'    |
            And I select current line in "List" table
            And "AvailableAttributes" table contains lines
            | 'Attribute'      | 'Affect pricing' |
            | 'Color Socks TR' | 'No'             |
            | 'Brand Socks TR' | 'No'             |
        * Add a sign that Color Socks TR will affect the price
            When in opened panel I select "Item types"
            And I activate "Attribute" field in "AvailableAttributes" table
            And I go to line in "AvailableAttributes" table
                | 'Attribute'      |
                | 'Color Socks TR' |
            And I activate "Affect pricing" field in "AvailableAttributes" table
            And I set "Affect pricing" checkbox in "AvailableAttributes" table
            And I finish line editing in "AvailableAttributes" table
            And I click "Save" button
        * Check the ligament with Additional attribute sets by price key
            When in opened panel I select "Additional attribute sets"
            And "AttributesTree" table contains lines
                | 'Presentation'   |
                | 'Socks TR'       |
                | 'Color Socks TR' |
        * Remove the sign that Color Socks TR will affect the price
            When in opened panel I select "Item types"
            And I activate "Attribute" field in "AvailableAttributes" table
            And I go to line in "AvailableAttributes" table
                | 'Attribute'      |
                | 'Color Socks TR' |
            And I activate "Affect pricing" field in "AvailableAttributes" table
            And I remove "Affect pricing" checkbox in "AvailableAttributes" table
            And I finish line editing in "AvailableAttributes" table
            And I click "Save" button
        * Check the ligament with Additional attribute sets by price key
            When in opened panel I select "Additional attribute sets"
            And "AttributesTree" table does not contain lines
                | 'Presentation'   |
                | 'Color Socks TR' |
        * Tick the price impact again
            When in opened panel I select "Item types"
            And I activate "Attribute" field in "AvailableAttributes" table
            And I go to line in "AvailableAttributes" table
                | 'Attribute'      |
                | 'Color Socks TR' |
            And I activate "Affect pricing" field in "AvailableAttributes" table
            And I set "Affect pricing" checkbox in "AvailableAttributes" table
            And I finish line editing in "AvailableAttributes" table
            And I click "Save" button
        * Check the ligament Additional attribute sets by price key
            When in opened panel I select "Additional attribute sets"
            And "AttributesTree" table contains lines
                | 'Presentation'   |
                | 'Socks TR'       |
                | 'Color Socks TR' |
        And I close all client application windows

Scenario: _350003 mark on removal of Item type and non-display in Add atribute and property sets by Price key and by item key
    * Open the list of item type selection and mark to delete the necessary item
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And I go to line in "List" table
            | 'Description' |
            | 'Socks TR'    |
        And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
        Then "1C:Enterprise" window is opened
        And I click "Yes" button
    * Check that Item type marked for deletion is not displayed in Add atribute and property sets by Price key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_PriceKeys'          |
        And I select current line in "List" table
        And "AttributesTree" table does not contain lines
            | 'Presentation'   |
            | 'Socks TR'       |
            | 'Color Socks TR' |
        And I close all client application windows
    * Check that the Item type marked for deletion is not displayed in Add atribute and property sets by item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        And I select current line in "List" table
        And "AttributesTree" table does not contain lines
            | 'Presentation'    |
            | 'Socks TR'        |
            | 'Brand Socks TR'       |
            | 'Color Socks TR'        |
        And I close all client application windows
    * Remove marking for removal from Item type
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And I go to line in "List" table
            | 'Description' |
            | 'Socks TR'    |
        And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
        Then "1C:Enterprise" window is opened
        And I click "Yes" button
    * Check that when removing the mark for deleting Item type is displayed in Add atribute and property sets by Price key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_PriceKeys'          |
        And I select current line in "List" table
        And "AttributesTree" table contains lines
            | 'Presentation'   |
            | 'Socks TR'       |
            | 'Color Socks TR' |
        And I close all client application windows
    * Check that when you uncheck Item type for deletion, it is displayed in Add atribute and property sets by item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        And I select current line in "List" table
        And "AttributesTree" table contains lines
            | 'Presentation'    |
            | 'Socks TR'        |
            | 'Brand Socks TR'       |
            | 'Color Socks TR'        |
        And I close all client application windows

Scenario: _350004 edit Item type and check changes in Add atribute and property sets by item key
    * Open Additional attribute sets for item key
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_ItemKeys'          |
        And I select current line in "List" table
    * Edit item type Socks
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And I go to line in "List" table
            | 'Description' |
            | 'Socks TR'    |
        And I select current line in "List" table
        And I input "Warm Socks TR" text in the field named "Description_tr"
        And I click "Save and close" button
    * Check item type replacement in Add atribute and property sets by item key
        When in opened panel I select "Additional attribute sets"
        And "AttributesTree" table contains lines
            | 'Presentation'    |
            | 'Warm Socks TR'   |
            | 'Brand Socks TR'  |
            | 'Color Socks TR'  |
        And I close all client application windows


Scenario: _350005 check the selection conditions when adding additional details on item
    * Open Additional attribute sets for item
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_Items'          |
        And I select current line in "List" table
    * Add additional details only for item type Warm Socks TR
        And in the table "Attributes" I click the button named "AttributesAdd"
        And I click choice button of "Attribute" attribute in "Attributes" table
        And I go to line in "List" table
            | 'Description'      |
            | 'Article Socks TR' |
        And I select current line in "List" table
        And I click choice button of "UI group" attribute in "Attributes" table
        And I go to line in "List" table
            | 'Description'               |
            | 'Accounting information TR' |
        And I select current line in "List" table
        And I finish line editing in "Attributes" table
        And in the table "Attributes" I click the button named "AttributesSetCondition"
        Then "1C:Enterprise" window is opened
        And I click "Yes" button
        And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
        And I select "Item type" exact value from "Field" drop-down list in "SettingsFilter" table
        And I move to the next attribute
        And I click choice button of "Comparison type" attribute in "SettingsFilter" table
        And I activate "Value" field in "SettingsFilter" table
        And I click choice button of "Value" attribute in "SettingsFilter" table
        And I go to line in "List" table
            | 'Description'   |
            | 'Warm Socks TR' |
        And I select current line in "List" table
        And I finish line editing in "SettingsFilter" table
        And I click "Ok" button
        And I click "Save and close" button
        And Delay 5
    * Check the drawing of additional details for the product with the item type of Warm Socks TR
        * Create Item with item type Warm Socks TR
            Given I open hyperlink "e1cib/list/Catalog.Items"
            And I click the button named "FormCreate"
            And I input "Socks" text in the field named "Description_tr"
            And I click Select button of "Item type" field
            And I go to line in "List" table
                | 'Description'   |
                | 'Warm Socks TR' |
            And I select current line in "List" table
            And I click Select button of "Unit" field
            And I go to line in "List" table
                | 'Description' |
                | 'adet'        |
            And I select current line in "List" table
            And I click "Save and close" button
            And Delay 2
        * Check display Article Socks TR
            And I go to line in "List" table
                | 'Description' |
                | 'Socks'       |
            And I select current line in "List" table
            And field "Article Socks TR" exists
            And I close current window
            And I go to line in "List" table
                | 'Description' |
                | 'Dress TR'       |
            And I select current line in "List" table
            And field "Article Socks TR" does not exist
            And I close all client application windows


Scenario: _350006 check error when doubling additional attribute on item
    * Open Additional attribute sets for Items
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Predefined data item name' |
            | 'Catalog_Items'          |
        And I select current line in "List" table
    * Check additional attribute
        And "Attributes" table contains lines
        | 'Attribute'                 |
        | 'Producer TR'               |
        | 'Article TR'                |
        | 'Brand TR'                  |
        | 'Country of consignment TR' |
        | 'Article Socks TR'          |
    * Add additional attribute Brand TR
        And in the table "Attributes" I click the button named "AttributesAdd"
        And I click choice button of "Attribute" attribute in "Attributes" table
        And I go to line in "List" table
            | 'Description'      |
            | 'Brand TR' |
        And I select current line in "List" table
    * Check save error message
        And I click "Save" button
        Then I wait that in user messages the "Duplicate attribute. Brand TR." substring will appear in 10 seconds
    And I close all client application windows

Scenario: _350007 check error when duplicating an additional attribute of an item key
    * Open Item type for Socks
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And I go to line in "List" table
            | 'Description'   |
            | 'Warm Socks TR' |
        And I select current line in "List" table
    * Check additional attribute
        And "AvailableAttributes" table contains lines
            | 'Attribute'      |
            | 'Color Socks TR' |
            | 'Brand Socks TR' |
    * Add additional attribute Brand Socks TR
        And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
        And I click choice button of "Attribute" attribute in "AvailableAttributes" table
        And I go to line in "List" table
            | 'Description'    |
            | 'Brand Socks TR' |
        And I select current line in "List" table
        And I finish line editing in "AvailableAttributes" table
    * Check save error message
        And I click "Save" button
        Then I wait that in user messages the "Duplicate attribute. Brand Socks TR." substring will appear in 10 seconds
    And I close all client application windows
