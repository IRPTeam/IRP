#language: en
@tree
@Positive
@Group18

Feature: product labeling

As a developer
I want to create a product labeling document
To assign a unique barcode (series) to products


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _300000 user check for Turkish data
	* Open users list
		Given I open hyperlink "e1cib/list/Catalog.Users"
	* Change localization code for CI
		And I go to line in "List" table
			| 'Description' |
			| 'CI'          |
		And I select current line in "List" table
		And I input "tr" text in "Localization code" field
		And I click "Save and close" button
	And I close TestClient session


Scenario: _300201 add-on plugin to generate unique barcodes
	Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	And I click the button named "FormCreate"
	And I select external file "C:\Users\Severnity\Desktop\ExtDataProc\GenerateBarcode.epf"
	And I click the button named "FormAddExtDataProc"
	And I input "" text in "Path to plugin for test" field
	And I input "GenerateBarcode" text in "Name" field
	And I click Open button of the field named "Description_tr"
	And I input "GenerateBarcode" text in the field named "Description_en"
	And I input "GenerateBarcodeTR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I wait "Plugins (create)" window closing in 10 seconds
	Then I check for the "ExternalDataProc" catalog element with the "Description_en" "GenerateBarcode"

Scenario: _300202 setting up barcode generation button display in Purchase order document
	* Add settings to the catalog ConfigurationMetadata
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I move one level down in "List" table
		And I click the button named "FormCreate"
		And I input "Labeling" text in "Description" field
		And I click Select button of "Parent" field
		And I go to line in "List" table
			| Description |
			| Documents   |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
	* Add settings to the register ExternalCommands
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
		And I click Select button of "Configuration metadata" field
		And I go to line in "List" table
			| Description |
			| Documents   |
		And I go to line in "List" table
			| Description         |
			| Labeling |
		And I select current line in "List" table
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| Description       |
			| GenerateBarcodeTR |
		And I select current line in "List" table
		And I select "Object form" exact value from "Form type" drop-down list
		And I click "Save and close" button
		And Delay 5
	* Check the display of the GenerateBarcode button in the Labeling document
		Given I open hyperlink "e1cib/list/Document.Labeling"
		And I click the button named "FormCreate"
		And field "GenerateBarcodeTR" is present on the form

Scenario: _300203 create Labeling based on Purchase order
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| Number |
		| 101 |
	And I select current line in "List" table
	And I click "Labeling" button
	And I click "GenerateBarcodeTR" button
	* Check filling in document
		And "Items" table contains lines
			| '#'  | 'Item'        | 'Item key'     | 'Item serial/lot number' | 'Barcode' |
			| '1'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '2'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '3'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '4'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '5'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '6'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '7'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '8'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '9'  | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '10' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '11' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '12' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '13' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '14' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '15' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '16' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '17' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '18' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '19' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '20' | 'Dress TR'    | 'M/White TR'   | '*'                 | '*'       |
			| '21' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '22' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '23' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '24' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '25' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '26' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '27' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '28' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '29' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '30' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '31' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '32' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '33' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '34' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '35' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '36' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '37' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '38' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '39' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '40' | 'Dress TR'    | 'L/Green TR'   | '*'                 | '*'       |
			| '41' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '42' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '43' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '44' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '45' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '46' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '47' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '48' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '49' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '50' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '51' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '52' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '53' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '54' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '55' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '56' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '57' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '58' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '59' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '60' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '61' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '62' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '63' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '64' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '65' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '66' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '67' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '68' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '69' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
			| '70' | 'Trousers TR' | '36/Yellow TR' | '*'                 | '*'       |
	And I click "Post and close" button
