#language: en
@tree
@Positive
@Forms
Feature: check item unit form



Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _206100 preparation (check item unit form)
	When Create document InventoryTransfer objects (check movements)
	And I execute 1C:Enterprise script at server
		| "Documents.InventoryTransfer.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);"    |
	When create Test unit

Scenario: _206101 check item unit list form
	Given I open hyperlink "e1cib/list/Catalog.Units"
	And "List" table contains lines
		| 'Description'    |
		| 'pcs'            |
		| 'box (8 pcs)'    |
		| 'box (16 pcs)'   |
	Then the number of "List" table lines is "равно" "4"
	And I click "Show all units" button
	And "List" table contains lines
		| 'Description'              |
		| 'pcs'                      |
		| 'box (4 pcs)'              |
		| 'box (8 pcs)'              |
		| 'box (16 pcs)'             |
		| 'High shoes box (8 pcs)'   |
		| 'Boots (12 pcs)'           |
		| 'box Dress (8 pcs)'        |



Scenario: _206102 try to change item unit that was used in the documents
	Given I open hyperlink "e1cib/list/Catalog.Units"
	And I go to line in "List" table
		| 'Description'   |
		| 'pcs'           |
	And I select current line in "List" table
	And the attribute named "BasisUnit" is read-only
	And the attribute named "Item" is read-only
	And the attribute named "Quantity" is read-only
	And I click "Unlock attributes" button	
	Then in the TestClient message log contains lines by template:
		| "Can not unlock attributes, this is element used *"   |
	And the attribute named "BasisUnit" is read-only
	And the attribute named "Item" is read-only
	And the attribute named "Quantity" is read-only
	And I close current window
	

Scenario: _206103 try to change item unit that was not used in the documents
	Given I open hyperlink "e1cib/list/Catalog.Units"
	If "List" table does not contain lines Then
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I click "Show all units" button
	And I go to line in "List" table
		| 'Description'         |
		| 'box Dress (8 pcs)'   |
	And I select current line in "List" table
	And the attribute named "BasisUnit" is read-only
	And the attribute named "Item" is read-only
	And the attribute named "Quantity" is read-only
	And I click "Unlock attributes" button
	Then user message window does not contain messages
	And I click Select button of "Item" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Trousers'      |
	And I select current line in "List" table
	And I click Select button of "Basis unit" field
	And I go to line in "List" table
		| 'Description'   |
		| 'pcs'           |
	And I select current line in "List" table
	And I click "Save and close" button
	And I go to line in "List" table
		| 'Description'         |
		| 'box Dress (8 pcs)'   |
	And I select current line in "List" table
	And I click "Unlock attributes" button
	Then user message window does not contain messages
	And I click Select button of "Item" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Dress'         |
	And I select current line in "List" table
	And I click Select button of "Basis unit" field
	And I go to line in "List" table
		| 'Description'   |
		| 'pcs'           |
	And I select current line in "List" table
	And I click "Save and close" button
	And I close all client application windows
	
	

	
Scenario: _206104 try to change unit in item with actual/inventory movements
	And I close all client application windows
	* Try change unit for item
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3"
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| 'Description' |
			| 'Test unit'   |
		And I select current line in "List" table
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Cannot change the unit from [pcs] to [Test unit], used in document [Inventory transfer 201 dated 01.03.2021 09:55:16]'|
		And I close all client application windows
		Given I open hyperlink "e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3"		
		Then the form attribute named "Unit" became equal to "pcs"

Scenario: _206105 try to change unit in item with actual/inventory movements
	And I close all client application windows
	* Try change unit for item key with movements
		Given I open hyperlink "e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc"
		And I change the radio button named "UnitMode" value to "Own"		
		And I click Select button of "Unit" field		
		And I go to line in "List" table
			| 'Description' |
			| 'Test unit'   |
		And I select current line in "List" table
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Cannot change the unit from [pcs] to [Test unit], used in document [Inventory transfer 201 dated 01.03.2021 09:55:16]'|				
		And I close all client application windows
		Given I open hyperlink "e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc"		
		Then the form attribute named "InheritUnit" became equal to "pcs"
	* Try change unit for item key without movements
		Given I open hyperlink "e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf11992f9b8d3"	
		And I change the radio button named "UnitMode" value to "Own"		
		And I click Select button of "Unit" field		
		And I go to line in "List" table
			| 'Description' |
			| 'Test unit'   |
		And I select current line in "List" table
		And I click "Save and close" button
		Given I open hyperlink "e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf11992f9b8d3"		
		And I change the radio button named "UnitMode" value to "Inherit"
		And I click "Save" button
		Then the form attribute named "InheritUnit" became equal to "pcs"
		And I close all client application windows