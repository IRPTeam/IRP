#language: en
@tree
@Positive
@FillingDocuments

Feature: check calculation current prices in the documents



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _01202501 preparation
	* Create Price List (current date)
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		And I change "Set price" radio button value to "By item keys"
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Description'   | 'Reference'     |
			| 'Current Price' | 'Current Price' |
		And I select current line in "List" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of the attribute named "ItemKeyListItem" in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I select current line in "List" table
		And I activate field named "ItemKeyListPrice" in "ItemKeyList" table
		And I input "50,00" text in the field named "ItemKeyListPrice" of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of the attribute named "ItemKeyListItem" in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '39/19SD'  |
		And I select current line in "List" table
		And I activate field named "ItemKeyListPrice" in "ItemKeyList" table
		And I input "40,00" text in the field named "ItemKeyListPrice" of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "FormPostAndClose"

Scenario: _01202502 check current price in the Sales order
	* Open Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Add product
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I select current line in "List" table
		And Delay 4
		And I activate "Price type" field in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   | 'Reference'     |
			| 'Current Price' | 'Current Price' |
		And I select current line in "List" table
		And Delay 4
	* Check current price
		And "ItemList" table contains lines
		| 'Item'       | 'Price' | 'Item key' | 'Price type'    | 'Q'     |
		| 'High shoes' | '50,00' | '37/19SD'  | 'Current Price' | '1,000' |
		And I close all client application windows
		

Scenario: _01202503 check current price in the Sales invoice
	* Open Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Add product
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I select current line in "List" table
		And I activate "Price type" field in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   | 'Reference'     |
			| 'Current Price' | 'Current Price' |
		And I select current line in "List" table
	* Check current price
		And "ItemList" table contains lines
		| 'Item'       | 'Price' | 'Item key' | 'Price type'    | 'Q'     |
		| 'High shoes' | '50,00' | '37/19SD'  | 'Current Price' | '1,000' |
		And I close all client application windows


Scenario: _01202504 check current price in the Purchase order
	* Open Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Add product
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I select current line in "List" table
		And I activate "Price type" field in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   | 'Reference'     |
			| 'Current Price' | 'Current Price' |
		And I select current line in "List" table
	* Check current price
		And "ItemList" table contains lines
		| 'Item'       | 'Price' | 'Item key' | 'Price type'    | 'Q'     |
		| 'High shoes' | '50,00' | '37/19SD'  | 'Current Price' | '1,000' |
		And I close all client application windows


Scenario: _01202504 check current price in the Purchase invoice
	And I close all client application windows
	* Open Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Add product
		And I click the button named "Add"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key' |
			| 'High shoes' | '37/19SD'  |
		And I select current line in "List" table
		And I activate "Price type" field in "ItemList" table
		And I click choice button of "Price type" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'   | 'Reference'     |
			| 'Current Price' | 'Current Price' |
		And I select current line in "List" table
	* Check current price
		And "ItemList" table contains lines
		| 'Item'       | 'Price' | 'Item key' | 'Price type'    | 'Q'     |
		| 'High shoes' | '50,00' | '37/19SD'  | 'Current Price' | '1,000' |
		And I close all client application windows


Scenario: _999999 close TestClient session
	And I close TestClient session