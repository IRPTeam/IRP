#language: en
@tree
@Positive
@Other

Feature: auto creation item key when Unbundling (by specification)


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _300301 preparation (creation item key when create Unbundling)
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
		When update ItemKeys
	* Create item for bundle
	* Filling in add attribute and property values for Chewing gum brand and Chewing gum taste
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "Pineapple" text in the field named "Description_tr"
		And I click Select button of "Additional attribute" field
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum taste' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "Watermelon" text in the field named "Description_tr"
		And I click Select button of "Additional attribute" field
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum taste' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "Mentol" text in the field named "Description_tr"
		And I click Select button of "Additional attribute" field
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum brand' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Create Specification
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		* Create Specification Chewing gum
			And I click the button named "FormCreate"
			And I change "Type" radio button value to "Set"
			And I click Select button of "Item type" field
			And I go to line in "List" table
				| 'Description' |
				| 'Chewing gum'     |
			And I select current line in "List" table
			And in the table "FormTable*" I click "Add" button
			And I click choice button of "Chewing gum taste" attribute in "FormTable*" table
			And I go to line in "List" table
				| 'Description' |
				| 'Pineapple'          |
			And I select current line in "List" table
			And I activate "Chewing gum brand" field in "FormTable*" table
			And I click choice button of "Chewing gum brand" attribute in "FormTable*" table
			And I go to line in "List" table
				| 'Description' |
				| 'Mentol'          |
			And I select current line in "List" table
			And I activate "Quantity" field in "FormTable*" table
			And I input "5,000" text in "Quantity" field of "FormTable*" table
			And I finish line editing in "FormTable*" table
			And in the table "FormTable*" I click "Add" button
			And I click choice button of "Chewing gum taste" attribute in "FormTable*" table
			And I go to line in "List" table
				| 'Description' |
				| 'Watermelon'          |
			And I select current line in "List" table
			And I activate "Chewing gum brand" field in "FormTable*" table
			And I click choice button of "Chewing gum brand" attribute in "FormTable*" table
			And I select current line in "List" table
			And I activate "Quantity" field in "FormTable*" table
			And I input "5,000" text in "Quantity" field of "FormTable*" table
			And I finish line editing in "FormTable*" table
			And I click Open button of the field named "Description_tr"
			And I input "Chewing gum2" text in the field named "Description_en"
			And I input "Chewing gum2" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save" button
			And I close all client application windows
	* Create item key  for Chewing gum Specifications
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
				| 'Description' |
				| 'Chewing gum TR'          |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I set checkbox named "SpecificationMode"
		And I click Choice button of the field named "Specification"
		And I go to line in "List" table
				| 'Description' |
				| 'Chewing gum2'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10
		And I close all client application windows

Scenario: _300302 create Unbundling and check creation item key
	* Filling the document header Unbundling
		Given I open hyperlink "e1cib/list/Document.Unbundling"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company TR |
		And I select current line in "List" table
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| Description |
			| Chewing gum TR       |
		And I select current line in "List" table
		And I click Select button of "Item key bundle" field
		And I go to line in "List" table
			| 'Item key'  |
			| 'Chewing gum TR/Chewing gum2' |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| Description |
			| adet      |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01 TR' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And in the table "ItemList" I click "By specification" button
		And "ItemList" table contains lines
			| 'Item'           | 'Quantity' | 'Item key'    | 'Unit' |
			| 'Chewing gum TR' | '5,000'   | 'Mentol/Pineapple'  | 'adet' |
			| 'Chewing gum TR' | '5,000'   | 'Mint/Watermelon' | 'adet' |
		And I click the button named "FormPostAndClose"
	* Create item key
		Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
		And "List" table contains lines
		| 'Item key'                                     |
		| 'Mentol/Pineapple'                                   |
		| 'Mint/Watermelon'                                  |
		And I close all client application windows
	* Check that when re-create Unbundling, lines are not duplicated
		* Create one more Unbundling
			Given I open hyperlink "e1cib/list/Document.Unbundling"
			And I click the button named "FormCreate"
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company TR |
			And I select current line in "List" table
			And I click Select button of "Item bundle" field
			And I go to line in "List" table
				| Description |
				| Chewing gum TR       |
			And I select current line in "List" table
			And I click Select button of "Item key bundle" field
			And I go to line in "List" table
				| 'Item key'  |
				| 'Chewing gum TR/Chewing gum2' |
			And I select current line in "List" table
			And I click Choice button of the field named "Unit"
			And I go to line in "List" table
				| Description |
				| adet      |
			And I select current line in "List" table
			And I input "2,000" text in the field named "Quantity"
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01 TR' |
			And I select current line in "List" table
			And I move to "Item list" tab
			And in the table "ItemList" I click "By specification" button
			And "ItemList" table contains lines
				| 'Item'           | 'Quantity' | 'Item key'    | 'Unit' |
				| 'Chewing gum TR' | '5,000'   | 'Mentol/Pineapple'  | 'adet' |
				| 'Chewing gum TR' | '5,000'   | 'Mint/Watermelon' | 'adet' |
			And I click the button named "FormPostAndClose"
		* Check that item key was not duplicated
			Given I open hyperlink "e1cib/list/Catalog.Items"
			And I go to line in "List" table
				| 'Description' |
				| 'Chewing gum TR'          |
			And I select current line in "List" table
			And In this window I click command interface button "Item keys"
			Then the number of "List" table lines is "меньше или равно" 6
			And I close all client application windows


