#language: en
@tree
@Positive
@Other

Feature: image setting

As a Developer
I want to create an image subsystem

Background:
    Given I launch TestClient opening script or connect the existing one

Scenario: _300100 preparation (image setting)
    When set True value to the constant
    And I close TestClient session
    Given I open new TestClient session or connect the existing one
    * Load info
        When Create catalog ObjectStatuses objects
        When Create catalog ItemKeys objects
        When Create catalog ItemTypes objects
        When Create catalog Units objects
        When Create catalog Items objects
        When Create catalog PriceTypes objects
        When Create catalog Specifications objects
        When Create chart of characteristic types AddAttributeAndProperty objects
        When Create catalog AddAttributeAndPropertySets objects
        When Create catalog AddAttributeAndPropertyValues objects
        When Create catalog Currencies objects
        When Create catalog Companies objects (Main company)
        When Create catalog Stores objects
        When Create catalog Partners objects (Ferron BP)
        When Create catalog Partners objects (Kalipso)
        When Create catalog Companies objects (partners company)
        When Create information register PartnerSegments records
        When Create catalog PartnerSegments objects
        When Create catalog Agreements objects
        When Create chart of characteristic types CurrencyMovementType objects
        When Create information register PricesByItemKeys records
        When Create catalog IntegrationSettings objects
        When Create information register CurrencyRates records
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description" |
				| "TestExtension" |
		When add test extension

Scenario: _300101 image setting
    * Filling in settings in  File storages info
        Given I open hyperlink "e1cib/list/Catalog.FileStoragesInfo"
        And I click "Create" button
        And I input "#workingDir#\DataProcessor\Picture\Preview" text in "Path to catalog at server" field
        And I input "preview" text in "URL alias" field
        And I click "Save and close" button
        Given I open hyperlink "e1cib/list/Catalog.FileStoragesInfo"
        And I click "Create" button
        And I input "#workingDir#\DataProcessor\Picture\Script" text in "Path to catalog at server" field
        And I input "js" text in "URL alias" field
        And I click "Save and close" button
        Given I open hyperlink "e1cib/list/Catalog.FileStoragesInfo"
        And I click "Create" button
        And I input "#workingDir#\DataProcessor\Picture\Source" text in "Path to catalog at server" field
        And I input "pic" text in "URL alias" field
        And I click "Save and close" button
* Filling in settings in Integration Settings for PICTURE STORAGE
        Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
        And I click "Create" button
        And I input "PICTURE STORAGE" text in "Description" field
        And I select "Local file storage" exact value from "Integration type" drop-down list
        And in the table "ConnectionSetting" I click the button named "ConnectionSettingFillByDefault"
        And I go to line in "ConnectionSetting" table
            | 'Key'         |
            | 'AddressPath' |
        And I activate "Value" field in "ConnectionSetting" table
        And I select current line in "ConnectionSetting" table
        And I input "#workingDir#\DataProcessor\Picture\Source" text in "Value" field of "ConnectionSetting" table
        And I finish line editing in "ConnectionSetting" table
        And I go to line in "ConnectionSetting" table
            | 'Key'       | 'Value' |
            | 'QueryType' | 'POST'  |
        And I activate "Key" field in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I click "Save and close" button
    * Filling in settings in  Integration Settings for PREVIEW STORAGE
        Given I open hyperlink "e1cib/list/Catalog.IntegrationSettings"
        And I click "Create" button
        And I input "PREWIEV STORAGE" text in "Description" field
        And I select "Local file storage" exact value from "Integration type" drop-down list
        And in the table "ConnectionSetting" I click the button named "ConnectionSettingFillByDefault"
        And I go to line in "ConnectionSetting" table
            | 'Key'         |
            | 'AddressPath' |
        And I activate "Value" field in "ConnectionSetting" table
        And I select current line in "ConnectionSetting" table
        And I input "C:\Users\NTrukhacheva\Desktop\Picture\Prewiev" text in "Value" field of "ConnectionSetting" table
        And I finish line editing in "ConnectionSetting" table
        And I go to line in "ConnectionSetting" table
            | 'Key'       | 'Value' |
            | 'QueryType' | 'POST'  |
        And I activate "Key" field in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I delete a line in "ConnectionSetting" table
        And I click "Save and close" button
    * Filling in settings in  File Storage Volumes
        Given I open hyperlink "e1cib/list/Catalog.FileStorageVolumes"
        And I click "Create" button
        And I input "DEFAULT PICTURE STORAGE" text in "Description" field
        And I select "Picture" exact value from "Files type" drop-down list
        And I click Select button of "POST Integration settings" field
        And I go to line in "List" table
            | Description     |
            | PICTURE STORAGE |
        And I select current line in "List" table
        And I click Select button of "GET Integration settings" field
        And I go to line in "List" table
            | Description     |
            | PICTURE STORAGE |
        And I select current line in "List" table
        And I click "Save and close" button
    * Filling a constant by the location of the pictures
        When in sections panel I select "Settings"
        And in functions panel I select "Default picture storage volume"
        And I click Select button of "Default picture storage volume" field
        And I click the button named "FormChoose"
        And I click "Save and close" button
        And Delay 3


Scenario: _300102 item/item key details display in list form (html field)
    * Opening the form for setting additional details for Item
        Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
        And I go to line in "List" table
            | 'Description' | 'Predefined data item name' |
            | 'Items'       | 'Catalog_Items'             |
        And I select current line in "List" table
    * Setting display details in the html field
        If "Attributes" table does not contain lines Then
                | "Attribute" |
                | "Brand" |
            And in the table "Attributes" I click the button named "AttributesAdd"
            And I click choice button of "Attribute" attribute in "Attributes" table
            And I go to line in "List" table
                | 'Description' |
                | 'Brand'     |
            And I select current line in "List" table
        And I go to line in "Attributes" table
            | 'Attribute' |
            | 'Brand'     |
        And I set checkbox named "AttributesShowInHTML" in "Attributes" table
        And I finish line editing in "Attributes" table
        If "Attributes" table does not contain lines Then
                | "Attribute" |
                | "Country of consignment" |
            And in the table "Attributes" I click the button named "AttributesAdd"
            And I click choice button of "Attribute" attribute in "Attributes" table
            And I go to line in "List" table
                | 'Description' |
                | 'Country of consignment'     |
            And I select current line in "List" table
        And I go to line in "Attributes" table
            | 'Attribute'              |
            | 'Country of consignment' |
        And I set checkbox named "AttributesShowInHTML" in "Attributes" table
        And I finish line editing in "Attributes" table
        And I click "Save and close" button
    * Opening the form for setting additional details for Item key
        Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
        And I go to line in "List" table
            | 'Description'   |
            | 'Clothes'       |
        And I select current line in "List" table
    * Setting display details in the html field
        And I go to line in "AvailableAttributes" table
            | 'Attribute' |
            | 'Color'     |
        And I set "Show in HTML" checkbox in "AvailableAttributes" table
        And I finish line editing in "AvailableAttributes" table
        And I go to line in "AvailableAttributes" table
            | 'Attribute' |
            | 'Size'     |
        And I set "Show in HTML" checkbox in "AvailableAttributes" table
        And I finish line editing in "AvailableAttributes" table
        And I click "Save and close" button




Scenario:_300110 add pictures to additional details and additional properties
    * Open add attribute and property
        Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
    * Add a picture to an additional attribute / additional property
        And I go to line in "List" table
        | 'Description' |
        | 'Brand'     |
        And I select current line in "List" table
        And I select external file "#workingDir#\features\Internal_new\_3000Other\16466.png"
        And I click "Icon" hyperlink
    * Check adding a picture to an additional attribute
        Then If dialog box is visible I click "Change" button		
        Then the field named "Icon" value contains "e1cib/tempstorage/" text
        And I click "Save and close" button

Scenario: _300111 cleaning up the added picture to the additional details and additional properties
    * Open add attribute and property
        Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
    * Add a picture to an additional attribute / additional property
        And I go to line in "List" table
        | 'Description' |
        | 'Brand'     |
        And I select current line in "List" table
        And I click "Icon" hyperlink
        Then "1C:Enterprise" window is opened
        And I click "Clear" button
    * Check deletion picture
        Then the field named "Icon" value does not contain "e1cib/tempstorage/" text
        And I click "Save and close" button
    * Add back a picture to an additional attribute / additional property
        And I go to line in "List" table
        | 'Description' |
        | 'Brand'     |
        And I select current line in "List" table
        And I select external file "#workingDir#\features\Internal_new\_3000Other\16466.png"
        And I click "Icon" hyperlink
    * Check adding a picture to an additional attribute
        Then the field named "Icon" value contains "e1cib/tempstorage/" text
        And I click "Save and close" button



Scenario: _300103 item pictures upload
    * Open item list form and select item
        Given I open hyperlink "e1cib/list/Catalog.Items"
        And I go to line in "List" table
            | 'Description'  |
            | 'Dress'     |
        And I select current line in "List" table
    * Add picture
        And I select external file "#workingDir#\features\Internal_new\_3000Other\16466.png"
        And I click "add_picture" button
    * Check adding picture 
        And In this window I click command interface button "Attached files"
        And "List" table contains lines
            | 'Owner'    | 'File'      |
            | 'Dress'    | 'reddress.png' |
    * Add one more picture
        And In this window I click command interface button "Main"
        And I select external file "#workingDir#\features\Internal_new\_3000Other\dressblue.jpg"
        And I click "add_picture" button
        And I click "update_slider" button
        Then system warning window does not appear	
    * Check adding picture 
        And In this window I click command interface button "Attached files"
        And I click "Refresh" button
        And "List" table contains lines
            | 'Owner'    | 'File'          |
            | 'Dress'    | 'reddress.png'     |
            | 'Dress'    | 'dressblue.jpg' |
        And I close all client application windows




Scenario: _300107 item key pictures upload
    * Open Item list form
        Given I open hyperlink "e1cib/list/Catalog.Items"
        And I go to line in "List" table
            | 'Description'  |
            | 'Dress'     |
        And I select current line in "List" table
        And In this window I click command interface button "Item keys"
        And I go to line in "List" table
            | 'Item key'     |
            | 'M/White' |
        And I select current line in "List" table
    * Add picture
        And I select external file "#workingDir#\features\Internal_new\_3000Other\dresswhite.jpg"
        And I click "add_picture" button
    * Check adding picture
        And In this window I click command interface button "Attached files"
        And "List" table contains lines
            | 'Owner'   | 'File'      |
            | 'M/White' | 'dresswhite.jpg' |
        And I close all client application windows


Scenario: _300108 open picture gallery from Item and item key
    * Open picture gallery from Item
            Given I open hyperlink "e1cib/list/Catalog.Items"
            And I go to line in "List" table
                | 'Description'  |
                | 'Dress'     |
            And I select current line in "List" table
        * Open gallery
            And I click "addImagesFromGallery" button
            And I wait "" window opening in 5 seconds
            And I close current window
    * Open picture gallery from Item key
            And In this window I click command interface button "Item keys"
            And I go to line in "List" table
                | 'Item key'     |
                | 'M/White' |
            And I select current line in "List" table
        * Open gallery
            And I click "addImagesFromGallery" button
            And I wait "" window opening in 5 seconds
            And I close all client application windows


// Scenario: _300110 opening Files catalog element
//     * Open catalog Files
//         Given I open hyperlink "e1cib/list/Catalog.Files"
//     * Open element
//         And I go to line in "List" table
//             | 'Extension' | 'File name' |
//             | 'JPG'       | 'dresswhite.jpg' |
//         And I select current line in "List" table
//         Then system warning window does not appear

# Scenario: _300115 check removal of pictures from Item and item key
#     * Open Item list form
#         Given I open hyperlink "e1cib/list/Catalog.Items"
#         And I go to line in "List" table
#             | 'Description'  |
#             | 'Trousers'     |
#         And I select current line in "List" table
#     * Delete picture from Item
#         Given cursor to "deletepic" picture
#         Then click "deletepic" picture
#         Then system warning window does not appear
#     And I close all client application windows
#     * Open Item list form
#         Given I open hyperlink "e1cib/list/Catalog.Items"
#         And I go to line in "List" table
#             | 'Description'     |
#             | 'Trousers'     |
#         And I select current line in "List" table
#         And In this window I click command interface button "Item keys"
#         And I go to line in "List" table
#             | 'Item key'     |
#             | '38/Yellow' |
#         And I select current line in "List" table
#     * Delete picture from Item key
#         Given cursor to "deletepic" picture
#         Then click "deletepic" picture
#         Then system warning window does not appear
#     And I close all client application windows



# // to do after bug fix
# Scenario: _300106 removal of unused elements of the Files catalog
#     * Open catalog Files
#         Given I open hyperlink "e1cib/list/Catalog.Files"
#     * Calling the delete unused items command
#         And I click "Delete unused files" button
#     * Search unused files
#         And in the table "Files" I click "Find unused files" button
#         And Delay 3
#     * Select all unused files
#         And in the table "Files" I click "Check all" button
#     * Delete unused files
#         And in the table "Files" I click "Delete unused files" button
#     And I close all client application windows