#language: en
@tree
@Positive
@Other
@ExtensionReportForm

Feature: add extension



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _4000100 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Constants
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
		When Create catalog Companies objects (Main company)
		When Create information register Barcodes records
		When Create catalog Users objects
		When Create catalog AccessGroups objects
		When Create catalog AccessProfiles objects
		* Change test user info
			Given I open hyperlink "e1cib/list/Catalog.Users"
			And I go to line in "List" table
					| 'Description'                 |
					| 'Arina Brown (Financier 3)' |
			And I select current line in "List" table
			And I input "en" text in "Localization code" field	
			And I click "Save" button
			Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
			And I go to line in "List" table
				| 'Description'    |
				| 'Administrators' |
			And I select current line in "List" table
			And I click "Save and close" button
		And I close all client application windows
	* Add test extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description" |
				| "TestExtension" |
			When add test extension
						


Scenario: _4000105 check add attributes from extensions
	Given I open hyperlink "e1cib/list/Catalog.Currencies"
	And I click the button named "FormCreate"
	And the field named "REP_Attribute1" exists on the form
	And I close all client application windows
	
Scenario: _4000120 check reports option save
	* Open test report	
		And In the command interface I select "Reports" "Barcodes"
		And I click "Run report" button
	* Change report and check option save
		And I click "Change option..." button
		Then "Report \"Barcodes\" option \"Default\"" window is opened
		And I move to "Fields" tab
		And I expand a line in "SettingsComposerSettingsSelectionSelectionAvailableFields" table
			| 'Available fields' |
			| 'Item'             |
		And I go to line in "SettingsComposerSettingsSelectionSelectionAvailableFields" table
			| 'Available fields' |
			| 'Item type'        |
		And I select current line in "SettingsComposerSettingsSelectionSelectionAvailableFields" table
		And I click "Finish editing" button
		And I click "Run report" button
		And "Result" spreadsheet document contains lines:
			| 'Item, Item type'               | 'Barcode'       |
			| 'Dress, Clothes'                | '2202283705'    |
			| 'Dress, Clothes'                | '2202283713'    |
			| 'Dress, Clothes'                | '2202283739'    |
			| 'Trousers, Clothes'             | ''              |
			| 'Shirt, Clothes'                | ''              |
			| 'Boots, Shoes'                  | '4820024700016' |
			| 'Boots, Shoes'                  | '978020137962'  |
			| 'High shoes, Shoes'             | ''              |
			| 'Bound Dress+Shirt, Clothes'    | ''              |
			| 'Bound Dress+Trousers, Clothes' | ''              |
			| 'Service, Service'              | ''              |
			| 'Router, Equipment'             | ''              |
			| 'Bag, Bags'                     | ''              |
			| 'Scarf, Clothes'                | ''              |
			| 'Chewing gum, Chewing gum'      | ''              |
			| 'Skittles, Candy TR'            | ''              |
			| 'Total'                         | ''              |
		And I click "Save option..." button
		And I click "Save as..." button
		Then "Enter a new option name" window is opened
		And I input "test1" text in "InputFld" field
		And I click "OK" button
	* Check one more option save 
		And I click "Change option..." button
		Then "Report \"Barcodes\" option \"test1\"" window is opened
		And I move to "Fields" tab
		And I expand a line in "SettingsComposerSettingsSelectionSelectionAvailableFields" table
			| 'Available fields' |
			| 'Item'             |
		And I go to line in "SettingsComposerSettingsSelectionSelectionAvailableFields" table
			| 'Available fields' |
			| 'Unit'             |
		And I select current line in "SettingsComposerSettingsSelectionSelectionAvailableFields" table
		And I click "Finish editing" button
		And I click "Run report" button
		And "Result" spreadsheet document contains lines:
			| 'Item, Item type, Unit'              | 'Barcode'       |
			| 'Dress, Clothes, pcs'                | '2202283705'    |
			| 'Dress, Clothes, pcs'                | '2202283713'    |
			| 'Dress, Clothes, pcs'                | '2202283739'    |
			| 'Trousers, Clothes, pcs'             | ''              |
			| 'Shirt, Clothes, pcs'                | ''              |
			| 'Boots, Shoes, pcs'                  | '4820024700016' |
			| 'Boots, Shoes, pcs'                  | '978020137962'  |
			| 'High shoes, Shoes, pcs'             | ''              |
			| 'Bound Dress+Shirt, Clothes, pcs'    | ''              |
			| 'Bound Dress+Trousers, Clothes, pcs' | ''              |
			| 'Service, Service, pcs'              | ''              |
			| 'Router, Equipment, pcs'             | ''              |
			| 'Bag, Bags, pcs'                     | ''              |
			| 'Scarf, Clothes, pcs'                | ''              |
			| 'Chewing gum, Chewing gum, pcs'      | ''              |
			| 'Skittles, Candy TR, pcs'            | ''              |
			| 'Total'                              | ''              |
		And I click "Save option..." button
		And I click "Save as..." button
		Then "Enter a new option name" window is opened
		And I input "test2" text in "InputFld" field
		And I click "OK" button
		And I click "Save option..." button
		And "OptionsList" table became equal
		| 'Is current option' | 'Report option' | 'Shared' |
		| 'No'                | 'test1'         | 'No'     |
		| 'Yes'               | 'test2'         | 'No'     |
	And I close all client application windows
	
Scenario: _4000125 check switching between options and default settings
	* Open test report	
		And In the command interface I select "Reports" "Barcodes"
		And I click "Run report" button
	* Check switching between options
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Report option' | 'Shared' |
			| 'test1'         | 'No'     |
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click "Run report" button
		And "Result" spreadsheet document contains lines:
			| 'Item, Item type'               | 'Barcode'       |
			| 'Dress, Clothes'                | '2202283705'    |
			| 'Dress, Clothes'                | '2202283713'    |
			| 'Dress, Clothes'                | '2202283739'    |
			| 'Trousers, Clothes'             | ''              |
			| 'Shirt, Clothes'                | ''              |
			| 'Boots, Shoes'                  | '4820024700016' |
			| 'Boots, Shoes'                  | '978020137962'  |
			| 'High shoes, Shoes'             | ''              |
			| 'Bound Dress+Shirt, Clothes'    | ''              |
			| 'Bound Dress+Trousers, Clothes' | ''              |
			| 'Service, Service'              | ''              |
			| 'Router, Equipment'             | ''              |
			| 'Bag, Bags'                     | ''              |
			| 'Scarf, Clothes'                | ''              |
			| 'Chewing gum, Chewing gum'      | ''              |
			| 'Skittles, Candy TR'            | ''              |
			| 'Total'                         | ''              |
		And I click "Select option..." button
		Then "Load form" window is opened
		And I go to line in "OptionsList" table
			| 'Is current option' | 'Report option' | 'Shared' |
			| 'No'                | 'test2'         | 'No'     |
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click "Run report" button
		And "Result" spreadsheet document contains lines:
			| 'Item, Item type, Unit'              | 'Barcode'       |
			| 'Dress, Clothes, pcs'                | '2202283705'    |
			| 'Dress, Clothes, pcs'                | '2202283713'    |
			| 'Dress, Clothes, pcs'                | '2202283739'    |
			| 'Trousers, Clothes, pcs'             | ''              |
			| 'Shirt, Clothes, pcs'                | ''              |
			| 'Boots, Shoes, pcs'                  | '4820024700016' |
			| 'Boots, Shoes, pcs'                  | '978020137962'  |
			| 'High shoes, Shoes, pcs'             | ''              |
			| 'Bound Dress+Shirt, Clothes, pcs'    | ''              |
			| 'Bound Dress+Trousers, Clothes, pcs' | ''              |
			| 'Service, Service, pcs'              | ''              |
			| 'Router, Equipment, pcs'             | ''              |
			| 'Bag, Bags, pcs'                     | ''              |
			| 'Scarf, Clothes, pcs'                | ''              |
			| 'Chewing gum, Chewing gum, pcs'      | ''              |
			| 'Skittles, Candy TR, pcs'            | ''              |
			| 'Total'                              | ''              |
	* Check switch on default options
		And I click "Select option..." button
		And I move to "Standard" tab
		And I go to line in "StandardOptions" table
			| 'Report option' |
			| 'Default'       |
		And I select current line in "StandardOptions" table
		And I click "Run report" button
		And "Result" spreadsheet document contains lines:
			| 'Item'                 | 'Barcode'       |
			| 'Dress'                | '2202283705'    |
			| 'Dress'                | '2202283713'    |
			| 'Dress'                | '2202283739'    |
			| 'Trousers'             | ''              |
			| 'Shirt'                | ''              |
			| 'Boots'                | '4820024700016' |
			| 'Boots'                | '978020137962'  |
			| 'High shoes'           | ''              |
			| 'Bound Dress+Shirt'    | ''              |
			| 'Bound Dress+Trousers' | ''              |
			| 'Service'              | ''              |
			| 'Router'               | ''              |
			| 'Bag'                  | ''              |
			| 'Scarf'                | ''              |
			| 'Chewing gum'          | ''              |
			| 'Skittles'             | ''              |
			| 'Total'                | ''              |
	And I close all client application windows
	
Scenario: _4000128 check mark/unmark option for deletion
	* Open test report	
		And In the command interface I select "Reports" "Barcodes"
		And I click "Run report" button
	* Mark option for deletion
		And I click "Select option..." button
		And I move to "Custom" tab
		And I go to line in "OptionsList" table
			| 'Report option' |
			| 'test1'         |		
		And in the table "OptionsList" I click the button named "OptionsListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And "OptionsList" table became equal
			| 'Report option' |
			| 'test2'         |
	* Unmark option for deletion
		And in the table "OptionsList" I click "Show marked for deletion" button
		And "OptionsList" table became equal
			| 'Report option' |
			| 'test1'         |
			| 'test2'         |
		And I go to line in "OptionsList" table
			| 'Report option' |
			| 'test1'         |
		And in the table "OptionsList" I click the button named "OptionsListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close current window
		And I click "Select option..." button
		And "OptionsList" table became equal
			| 'Report option' |
			| 'test1'         |
			| 'test2'         |
	And I close all client application windows

Scenario: _4000128 check reports option share
	* Open test report	
		And In the command interface I select "Reports" "Barcodes"
	* Option share
		And I click "Select option..." button
		And I move to "Custom" tab
		And I go to line in "OptionsList" table
			| 'Report option' |
			| 'test2'         |	
		And I select current line in "OptionsList" table
		And I click "Run report" button	
		And I click "Save option..." button
		And I set checkbox "Share"		
		And I go to line in "OptionsList" table
			| 'Report option' |
			| 'test2'         |
		And I activate "Shared" field in "OptionsList" table
		And I select current line in "OptionsList" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "Share to users" window is opened
		And I go to line in "UsersList" table
			| 'User'                      |
			| 'Arina Brown (Financier 3)' |
		And I change "Use" checkbox in "UsersList" table
		And I finish line editing in "UsersList" table
		And I click "Save (share)" button
	* Check option share
		Given I open hyperlink "e1cib/list/InformationRegister.SharedReportOptions"
		And "List" table contains lines
			| 'User'                      | 'Report option' |
			| 'Arina Brown (Financier 3)' | 'test2'         |
			| 'CI'                        | 'test2'         |			
		And I connect "TestAdmin" TestClient using "ABrown" login and "" password
		And In the command interface I select "Reports" "Barcodes"
		And I click "Run report" button
		And I click "Select option..." button
		And I move to "Custom" tab
		And I go to line in "OptionsList" table
			| 'Author' | 'Report option' | 'Shared' |
			| 'CI'     | 'test2'         | 'Yes'    |
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		Then "Barcodes (test2)" window is opened
		And I click "Run report" button
		And "Result" spreadsheet document contains lines:
			| 'Item, Item type, Unit'              | 'Barcode'       |
			| 'Dress, Clothes, pcs'                | '2202283705'    |
			| 'Dress, Clothes, pcs'                | '2202283713'    |
			| 'Dress, Clothes, pcs'                | '2202283739'    |
			| 'Trousers, Clothes, pcs'             | ''              |
			| 'Shirt, Clothes, pcs'                | ''              |
			| 'Boots, Shoes, pcs'                  | '4820024700016' |
			| 'Boots, Shoes, pcs'                  | '978020137962'  |
			| 'High shoes, Shoes, pcs'             | ''              |
			| 'Bound Dress+Shirt, Clothes, pcs'    | ''              |
			| 'Bound Dress+Trousers, Clothes, pcs' | ''              |
			| 'Service, Service, pcs'              | ''              |
			| 'Router, Equipment, pcs'             | ''              |
			| 'Bag, Bags, pcs'                     | ''              |
			| 'Scarf, Clothes, pcs'                | ''              |
			| 'Chewing gum, Chewing gum, pcs'      | ''              |
			| 'Skittles, Candy TR, pcs'            | ''              |
			| 'Total'                              | ''              |
	And I close TestClient session
	Then I connect launched Test client "Этот клиент"
