#language: en
@tree
@Positive
@Forms
Feature: check item unit form



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _206101 check item unit list form
	Given I open hyperlink "e1cib/list/Catalog.Units"
	And "List" table contains lines
		| 'Description'  |
		| 'pcs'          |
		| 'box (8 pcs)'  |
		| 'box (16 pcs)' |
	Then the number of "List" table lines is "равно" "3"
	And I click "Show all units" button
	And "List" table contains lines
		| 'Description'            |
		| 'pcs'                    |
		| 'box (4 pcs)'            |
		| 'box (8 pcs)'            |
		| 'box (16 pcs)'           |
		| 'High shoes box (8 pcs)' |
		| 'Boots (12 pcs)'         |
		| 'box Dress (8 pcs)'      |



Scenario: _206102 try to change item unit that was used in the documents
	Given I open hyperlink "e1cib/list/Catalog.Units"
	And I go to line in "List" table
		| 'Description' |
		| 'pcs'         |
	And I select current line in "List" table
	And the attribute named "BasisUnit" is read-only
	And the attribute named "Item" is read-only
	And the attribute named "Quantity" is read-only
	And I click "Unlock attributes" button
	If user messages contain "Can not unlock attributes, this is element used * times, ex.:" string Then	
	When there are lines in TestClient message log
		| "Bundling" |
		| "Goods receipt" |
		| "Internal supply request" |
		| "Inventory transfer" |
		| "Inventory transfer order" |
	And the attribute named "BasisUnit" is read-only
	And the attribute named "Item" is read-only
	And the attribute named "Quantity" is read-only
	And I close current window
	

Scenario: _206103 try to change item unit that was not used in the documents
	Given I open hyperlink "e1cib/list/Catalog.Units"
	If "List" table does not contain lines Then
			| 'Description' |
			| 'box Dress (8 pcs)'         |
		And I click "Show all units" button
	And I go to line in "List" table
		| 'Description' |
		| 'box Dress (8 pcs)'         |
	And I select current line in "List" table
	And the attribute named "BasisUnit" is read-only
	And the attribute named "Item" is read-only
	And the attribute named "Quantity" is read-only
	And I click "Unlock attributes" button
	Then user message window does not contain messages
	And I click Select button of "Item" field
	And I go to line in "List" table
		| 'Description' |
		| 'Trousers'    |
	And I select current line in "List" table
	And I click Select button of "Basis unit" field
	And I go to line in "List" table
		| 'Description' |
		| 'pcs'    |
	And I select current line in "List" table
	And I click "Save and close" button
	And I go to line in "List" table
		| 'Description'       |
		| 'box Dress (8 pcs)' |
	And I select current line in "List" table
	And I click "Unlock attributes" button
	Then user message window does not contain messages
	And I click Select button of "Item" field
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'    |
	And I select current line in "List" table
	And I click Select button of "Basis unit" field
	And I go to line in "List" table
		| 'Description' |
		| 'pcs'    |
	And I select current line in "List" table
	And I click "Save and close" button
	And I close all client application windows
	
	

	
		
		


	
	