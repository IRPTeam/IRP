#language: en
@tree
@Positive


Feature: create missing Item key by Item when creating Purchase Order

As a procurement manager
I want to create an Item key for the items
In order to form an order with a vendor

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _017101 check input item key by line
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
	* Check input item key line by line
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I select "s" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| Item  | Item key |
		| Dress | S/Yellow |
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button


Scenario: _017102 check for the creation of the missing item key from the Purchase order document
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description        |
			| Vendor Ferron, TRY |
		And I select current line in "List" table
	* Creating an item key when filling out the tabular part
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I select from "Size" drop-down list by "xxl" string
		And I select from "Color" drop-down list by "red" string
		And I click "Create new" button
		And I click "Save and close" button
		And Delay 2
		And I input "" text in "Size" field
		And I input "" text in "Color" field
		And "List" table became equal
		| Item key  | Item  |
		| S/Yellow  | Dress |
		| XS/Blue   | Dress |
		| M/White   | Dress |
		| L/Green   | Dress |
		| XL/Green  | Dress |
		| Dress/A-8 | Dress |
		| XXL/Red   | Dress |
		And I close current window
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button


Scenario: _017105 filter when selecting item key in a purchase order document
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
	* Filter check on item key when filling out the commodity part
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I select from "Size" drop-down list by "l" string
		And "List" table became equal
		| Item key |
		| L/Green  |
		| Dress/A-8  |
		And I input "" text in "Size" field
		And I select from "Color" drop-down list by "gr" string
		And "List" table became equal
		| Item key |
		| L/Green  |
		| XL/Green |
		| Dress/A-8  |
		And I close current window
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button
