#language: en
@tree
@Positive
@NotCritical

Feature: check required fields



Background:
	Given I launch TestClient opening script or connect the existing one
	
Scenario: check of the sign of required filling at the additional attribute and check for filling
	* Opening of additional details settings
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
	* Check of the sign of required filling at the additional attribute for Item
		And I go to line in "List" table
			| 'Description' |
			| 'Items'       |
		And I select current line in "List" table
		And I go to line in "Attributes" table
			| 'Attribute'  |
			| 'Article'    |
		And I activate "Required" field in "Attributes" table
		And I set "Required" checkbox in "Attributes" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
	* Check of the sign of required filling at the additional attribute for item key (shoes)
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'       |
		And I select current line in "List" table
		And I go to line in "AvailableAttributes" table
			| 'Attribute' |
			| 'Season'    |
		And I activate "Required" field in "AvailableAttributes" table
		And I set "Required" checkbox in "AvailableAttributes" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save and close" button
	* Check that the Article in Item is required to be filled in
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I input "" text in "Article" field
		And I click "Save" button
		Then I wait that in user messages the "Field: [Article] is empty" substring will appear in 30 seconds
		And I close all client application windows
	* Check that the Season account in the Item key is required by Shoes
		Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I input "" text in "Season" field
		And I click "Save" button
		Then I wait that in user messages the "Field: [Season] is empty" substring will appear in 30 seconds
		And I close all client application windows
	* Putt in an optional filling in the details
		* Open add attribute settings
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
	* Check of the sign of required filling at the additional attribute for Item
		And I go to line in "List" table
			| 'Description' |
			| 'Items'       |
		And I select current line in "List" table
		And I go to line in "Attributes" table
			| 'Attribute'  |
			| 'Article'    |
		And I activate "Required" field in "Attributes" table
		And I remove "Required" checkbox in "Attributes" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
	* Check of the sign of required filling at the additional attribute for item key (shoes)
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'       |
		And I select current line in "List" table
		And I go to line in "AvailableAttributes" table
			| 'Attribute' |
			| 'Season'    |
		And I activate "Required" field in "AvailableAttributes" table
		And I remove "Required" checkbox in "AvailableAttributes" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save and close" button








