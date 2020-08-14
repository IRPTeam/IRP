#language: en
@tree
@Positive


Feature: check specification filling 



Background:
	Given I launch TestClient opening script or connect the existing one
	
Scenario: _206001 check message output when creating a Bundle with empty item
	* Open the list of specifications
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
	* Filling in the Bundle name and items (without quantity)
		And I change "Type" radio button value to "Bundle"
		And I input "Test" text in the field named "Description_en"
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bound Dress+Trousers' |
		And I select current line in "List" table
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Blue'        |
		And I select current line in "List" table
		And I finish line editing in "FormTable*" table
		And I click "Save" button
	* Check the output of the message that the quantity is not filled
		Then I wait that in user messages the "Field [Quantity] is empty." substring will appear in 10 seconds
	* Filling in the quantity and check the saving
		And I select current line in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click "Save and close" button
		And Delay 10
		Then I check for the "Specifications" catalog element with the "Description_en" "Test"
		And I go to line in "List" table
			| 'Description' |
			| 'Test'        |
		And I select current line in "List" table
	* Check for errors when saving without a filled item
		And I input "" text in "Item" field
		And I click "Save" button
		* Check the output of the message that the item is not filled
			Then I wait that in user messages the "Field [Item] is empty." substring will appear in 10 seconds
	* Check for errors when saving without a filled item bundle
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I select current line in "FormTable*" table
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'White'       |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I input "" text in "Item bundle" field
		And I click "Save" button
		* Check the output of the message that the item bundle is not filled
			Then I wait that in user messages the "Field [Item Bundle] is empty." substring will appear in 10 seconds
	* Check for errors when saving without a filled property
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bound Dress+Trousers' |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I select current line in "FormTable*" table
		And I click Clear button of "Color" attribute in "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click "Save" button
		* Check the output of the message that the quantity is not filled
			Then I wait that in user messages the "Field [Color] is empty." substring will appear in 10 seconds
	* Check for errors when saving with the same lines
		And I select current line in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Yellow'      |
		And I select current line in "List" table
		And I finish line editing in "FormTable*" table
		And I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Yellow'      |
		And I select current line in "List" table
		And I finish line editing in "FormTable*" table
		And I activate "Quantity" field in "FormTable*" table
		And I select current line in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click "Save" button
		* Check the output of the message that the quantity is not filled
			Then I wait that in user messages the "Value is not unique." substring will appear in 10 seconds
	* Delete double and check saving
		And I delete a line in "FormTable*" table
		And I click "Save" button
		And I click "Save and close" button
		And I wait "Test (Specification) *" window closing in 10 seconds
		Then I check for the "Specifications" catalog element with the "Description_en" "Test"
	* Mark to delete the created specification
		And I go to line in "List" table
			| 'Description' | 'Type'   |
			| 'Test'        | 'Bundle' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	And I close all client application windows


Scenario: create a specification double
	# the double is created for the A-8 specification
	* Open specification catalog
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		Then I check for the "Specifications" catalog element with the "Description_en" "A-8"
	* Create a copy of the A-8 specification set
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| 'XS'          |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Blue'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'M'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Brown'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'L'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click Open button of the field named "Description_en"
		And I input "Duplicate A-8" text in the field named "Description_en"
		And I input "Duplicate A-8" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save" button
	* Check the output message that the specification cannot be saved
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		Then I wait that in user messages the "Specification is not unique." substring will appear in 10 seconds
		And I close all client application windows



