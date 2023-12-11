#language: en
@tree
@Positive
@Barcodes

Feature: barcode management

As a developer
I want to add barcode functionality
To work with the products


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _090500 preparation (Barcodes)
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

	
Scenario: _0905001 check preparation
	When check preparation

Scenario: _090501 barcode registry entry
	* Adding barcode entries for Dress
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And In this window I click command interface button "Barcodes"
		And I click the button named "FormCreate"
		And I input "2202283705" text in "Barcode" field
		And I click Select button of "Item key" field
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | XS/Blue     |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
		And I input "2202283705" text in "Presentation" field
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "2202283713" text in "Barcode" field
		And I click Select button of "Item key" field
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | S/Yellow    |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
		And I input "2202283713" text in "Presentation" field
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "2202283739" text in "Barcode" field
		And I click Select button of "Item key" field
		And I go to line in "List" table
			| Item    | Item key    |
			| Dress   | L/Green     |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
		And I input "2202283739" text in "Presentation" field
		And I click "Save and close" button
	And I close all client application windows
	* Adding barcode entries for Boots
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description    |
			| Boots          |
		And I select current line in "List" table
		And In this window I click command interface button "Barcodes"
		And I click the button named "FormCreate"
		And I input "4820024700016" text in "Barcode" field
		And I click Select button of "Item key" field
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item    | Item key    |
			| Boots   | 36/18SD     |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
		And I input "4820024700016" text in "Presentation" field
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "978020137962" text in "Barcode" field
		And I click Select button of "Item key" field
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item    | Item key    |
			| Boots   | 37/18SD     |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| Description    |
			| pcs            |
		And I select current line in "List" table
		And I input "978020137962" text in "Presentation" field
		And I click "Save and close" button
	And I close all client application windows

Scenario: _090502 check barcode display by Item and item key
	* Opening the item catalog and selecting Dress
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
	* CheckItem barcodes by Item
		And In this window I click command interface button "Barcodes"
		And "List" table contains lines
		| 'Barcode'     | 'Unit'  | 'Item key'   |
		| '2202283705'  | 'pcs'   | 'XS/Blue'    |
		| '2202283713'  | 'pcs'   | 'S/Yellow'   |
		| '2202283739'  | 'pcs'   | 'L/Green'    |
	* CheckItem barcodes by Item key
		And In this window I click command interface button "Item keys"
		And I go to line in "List" table
		| 'Item key'   |
		| 'S/Yellow'   |
		And I select current line in "List" table
		And In this window I click command interface button "Barcodes"
		And "List" table contains lines
		| 'Barcode'     | 'Unit'  | 'Item key'   |
		| '2202283713'  | 'pcs'   | 'S/Yellow'   |
	And I close all client application windows

Scenario: _090503 copy barcode
	And I close all client application windows
	* From item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And In this window I click command interface button "Barcodes"
		And I go to line in "List" table
			| 'Barcode'       |
			| '2202283713'    |
		And in the table "List" I click "Copy" button
		Then the form attribute named "Barcode" became equal to "2202283713"
		Then the form attribute named "ItemKey" became equal to "S/Yellow"
		Then the form attribute named "SerialLotNumber" became equal to ""
		Then the form attribute named "SourceOfOrigin" became equal to ""
		Then the form attribute named "Unit" became equal to "pcs"
		Then the form attribute named "Presentation" became equal to "2202283713"
		And I close all client application windows
	* From register
		Given I open hyperlink "e1cib/list/InformationRegister.Barcodes"
		And I go to line in "List" table
			| 'Barcode'       |
			| '2202283713'    |
		And in the table "List" I click "Copy" button		
		Then the form attribute named "Barcode" became equal to "2202283713"
		Then the form attribute named "ItemKey" became equal to "S/Yellow"
		Then the form attribute named "SerialLotNumber" became equal to ""
		Then the form attribute named "SourceOfOrigin" became equal to ""
		Then the form attribute named "Unit" became equal to "pcs"
		Then the form attribute named "Presentation" became equal to "2202283713"
		And I close all client application windows