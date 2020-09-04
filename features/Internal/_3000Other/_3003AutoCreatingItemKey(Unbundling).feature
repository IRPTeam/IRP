#language: en
@tree
@Positive
@Group18

Feature: auto creation item key when Unbundling (by specification)


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _300301 preparation
	* Create item  for bundle
		* Open a creation form Items
			Given I open hyperlink "e1cib/list/Catalog.Items"
			And I click the button named "FormCreate"
		* Create item type Chewing gum
			And I click Open button of the field named "Description_tr"
			And I input "Chewing gum" text in the field named "Description_en"
			And I input "Chewing gum TR" text in the field named "Description_tr"
			And I click "Ok" button
			* Create item type for candy
				And I click Select button of "Item type" field
				And I click the button named "FormCreate"
				And I input "Chewing gum" text in the field named "Description_tr"
				And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
				And I click choice button of "Attribute" attribute in "AvailableAttributes" table
				And I click the button named "FormCreate"
				And I input "Chewing gum taste" text in the field named "Description_tr"
				And I click "Save and close" button
				And I click the button named "FormCreate"
				And I input "Chewing gum brand" text in the field named "Description_tr"
				And I click "Save and close" button
				And Delay 5
				And I click the button named "FormChoose"
				And I finish line editing in "AvailableAttributes" table
				And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
				And I click choice button of "Attribute" attribute in "AvailableAttributes" table
				And I go to line in "List" table
					| 'Description' |
					| 'Chewing gum taste' |
				And I click the button named "FormChoose"
				And I finish line editing in "AvailableAttributes" table
				And I click "Save and close" button
				And Delay 5
				And I click the button named "FormChoose"
			* Select unit
				And I click Select button of "Unit" field
				And I go to line in "List" table
					| 'Description' |
					| 'adet'         |
				And I select current line in "List" table
			And I click the button named "FormWriteAndClose"
			And Delay 5
	* Filling in add attribute and property values for Chewing gum brand and Chewing gum taste
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "Cherry" text in the field named "Description_tr"
		And I click Select button of "Additional attribute" field
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum taste' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "Mango" text in the field named "Description_tr"
		And I click Select button of "Additional attribute" field
		And I go to line in "List" table
			| 'Description' |
			| 'Chewing gum taste' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And I click the button named "FormCreate"
		And I input "Mint" text in the field named "Description_tr"
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
				| 'Mango'          |
			And I select current line in "List" table
			And I activate "Chewing gum brand" field in "FormTable*" table
			And I click choice button of "Chewing gum brand" attribute in "FormTable*" table
			And I select current line in "List" table
			And I activate "Quantity" field in "FormTable*" table
			And I input "10,000" text in "Quantity" field of "FormTable*" table
			And I finish line editing in "FormTable*" table
			And in the table "FormTable*" I click "Add" button
			And I click choice button of "Chewing gum taste" attribute in "FormTable*" table
			And I go to line in "List" table
				| 'Description' |
				| 'Cherry'          |
			And I select current line in "List" table
			And I activate "Chewing gum brand" field in "FormTable*" table
			And I click choice button of "Chewing gum brand" attribute in "FormTable*" table
			And I select current line in "List" table
			And I activate "Quantity" field in "FormTable*" table
			And I input "10,000" text in "Quantity" field of "FormTable*" table
			And I finish line editing in "FormTable*" table
			And I click Open button of the field named "Description_tr"
			And I input "Chewing gum" text in the field named "Description_en"
			And I input "Chewing gum" text in the field named "Description_tr"
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
			| Item key  |
			| Chewing gum TR/Chewing gum |
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
			| 'Chewing gum TR' | '10,000'   | 'Mint/Mango'  | 'adet' |
			| 'Chewing gum TR' | '10,000'   | 'Mint/Cherry' | 'adet' |
		And I click "Post and close" button
	* Create item key
		Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
		And "List" table contains lines
		| 'Item key'                                     |
		| 'Mint/Mango'                                   |
		| 'Mint/Cherry'                                  |
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
				| Item key  |
				| Chewing gum TR/Chewing gum |
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
				| 'Chewing gum TR' | '10,000'   | 'Mint/Mango'  | 'adet' |
				| 'Chewing gum TR' | '10,000'   | 'Mint/Cherry' | 'adet' |
			And I click "Post and close" button
		* Check that item key was not duplicated
			Given I open hyperlink "e1cib/list/Catalog.Items"
			And I go to line in "List" table
				| 'Description' |
				| 'Chewing gum TR'          |
			And I select current line in "List" table
			And In this window I click command interface button "Item keys"
			Then the number of "List" table lines is "меньше или равно" 3
			And I close all client application windows


