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
	Then the number of "List" table lines is "равно" "5"
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

Scenario: _206106 try to change item type in item that used in the documents
	And I close all client application windows
	* Select item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'   |
			| 'Dress'         |
		And I select current line in "List" table
	* Try change item type
		And I select from "Item type" drop-down list by "service" string
		And I click "Save and close" button
		Then I wait that in user messages the "[Item type] cannot be changed, has posted documents" substring will appear in 10 seconds

Scenario: _206107 try to change type in item type that used in the documents
	And I close all client application windows
	* Select item
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description'   |
			| 'Clothes'       |
		And I select current line in "List" table
	* Try change item type
		And I change the radio button named "Type" value to "Service"		
		And I click "Save and close" button
		Then I wait that in user messages the "[Stock balance detail] cannot be changed, has posted documents" substring will appear in 10 seconds
				
Scenario: _206108 try to change Use item type marker and stock balance details in item type that used in the documents
	And I close all client application windows
	* Select item
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description'   |
			| 'Clothes'       |
		And I select current line in "List" table
	* Try change item type
		And I set checkbox "Use serial lot number"
		And I select "By item key" exact value from "Stock balance detail" drop-down list
		And I click "Save" button
		Then there are lines in TestClient message log
			|'[Use serial lot number] cannot be changed, has posted documents'|
			|'[Stock balance detail] cannot be changed, has posted documents'|
		And I close "Clothes (Item type) *" window
		Then "1C:Enterprise" window is opened
		And I click "No" button

Scenario: _206109 try to change Specification marker in item key that used in the documents	
	And I close all client application windows
	* Select item key
		Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
		And I go to line in "List" table
			| 'Item key' |
			| 'S/Yellow' |
		And I select current line in "List" table	
	* Try to change item key
		And I set checkbox named "SpecificationMode"
		And I click Choice button of the field named "Specification"
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I click "Save" button
		Then there are lines in TestClient message log
			|'[Specification] cannot be changed, has posted documents'|
		And I close "S/Yellow (Item key) *" window
		Then "1C:Enterprise" window is opened
		And I click "No" button		
				

				
				
