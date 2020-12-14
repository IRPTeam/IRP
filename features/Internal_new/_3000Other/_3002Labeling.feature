#language: en
@tree
@Positive
@Other

Feature: product labeling

As a developer
I want to create a product labeling document
To assign a unique barcode (series) to products


Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _3001002 preparation
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
		* Check or create PurchaseOrder017001
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			If "List" table does not contain lines Then
					| "Number" |
					| "$$NumberPurchaseOrder017001$$" |
				When create PurchaseOrder017001
		When auto filling Configuration metadata catalog

Scenario: _300000 user check for Turkish data
	* Open users list
		Given I open hyperlink "e1cib/list/Catalog.Users"
	* Change localization code for CI
		And I go to line in "List" table
			| 'Login' |
			| 'CI'          |
		And I select current line in "List" table
		And I select "Turkish" exact value from "Data localization" drop-down list
		And I input "CI" text in the field named "Description_en"
		And I click "Save and close" button
	And I close TestClient session


Scenario: _300201 add-on plugin to generate unique barcodes
	Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#\DataProcessor\GenerateBarcode.epf"
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
	* Add settings to the register ExternalCommands
		Given I open hyperlink "e1cib/list/InformationRegister.ExternalCommands"
		And I click the button named "FormCreate"
		And I click Select button of "Configuration metadata" field
		And I go to line in "List" table
			| Description |
			| Documents   |
		And I move one level down in "List" table		
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
		| 'Number' |
		| '$$NumberPurchaseOrder017001$$'|
	And I select current line in "List" table
	And I click "Labeling" button
	And I click "GenerateBarcodeTR" button
	* Check filling in document
		And "Items" table contains lines
			| 'Item'        | 'Item key'     | 'Item serial/lot number' | 'Barcode' |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'M/White TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Dress TR'    | 'L/Green TR'   | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
			| 'Trousers TR' | '36/Yellow TR' | '*'                      | '*'       |
	And I click the button named "FormPostAndClose"
