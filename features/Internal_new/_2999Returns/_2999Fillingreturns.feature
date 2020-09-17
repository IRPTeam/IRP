#language: en
@tree
@Positive
@Group17

Feature: check filling in and re-filling returns

As a QA
I want to check the filling and refilling of returns


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _299901 check filling in and re-filling Sales return order
	* Open form  Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "DFC"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Nicoletta'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term Customer"
	* Check filling in Company from Partner term
		* Change company in Sales return order
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		Then the form attribute named "Store" became equal to "Store 01"
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
	* Check filling in prices when adding an Item and selecting an item key
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
		* Check store and price re-filling in the added line
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 02' |
	* Check the re-drawing of the form for taxes at company re-selection.
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 02' |
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		If "ItemList" table does not contain "VAT" column Then
	* Check for clearing a line in the tax tree when deleting a line from a Sales return order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And I move to "Tax list" tab
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I close all client application windows


Scenario: _299902 check filling in and re-filling Sales return
	* Open form  Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "DFC"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Nicoletta'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term Customer"
	* Check filling in Company from Partner term
		* Change company in Sales return order
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		Then the form attribute named "Store" became equal to "Store 01"
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
	* Check re-filling store when re-select partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store overfill in the added string
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 01' |
	* Check the re-drawing of the form for taxes at company re-selection.
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 01' |
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		If "ItemList" table does not contain "VAT" column Then
	* Check for clearing a line in the tax tree when deleting a line from a Sales return order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And I move to "Tax list" tab
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I close all client application windows

Scenario: _299903 check filling in and re-filling Purchase return order
	* Open form  Purchase return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "DFC"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Veritas'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term (Veritas)"
	* Check filling in Company from Partner term
		* Change company in Purchase return order
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		Then the form attribute named "Store" became equal to "Store 01"
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
	* Check re-filling store when re-select partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store overfill in the added string
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		If "ItemList" table does not contain "VAT" column Then
	* Check for clearing a line in the tax tree when deleting a line from a Sales return order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And I move to "Tax list" tab
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I close all client application windows

Scenario: _299904 check filling in and re-filling Purchase return
	* Open form  Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'DFC'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "DFC"
	* Check filling in Partner term if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Veritas'         |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term (Veritas)"
	* Check filling in Company from Partner term
		* Change company in Purchase return
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'    |
				| 'Second Company' |
			And I select current line in "List" table
			Then the form attribute named "Company" became equal to "Second Company"
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Check the refill when selecting a partner term
			Then the form attribute named "Company" became equal to "Main Company"
	* Check filling in Store from Partner term
		Then the form attribute named "Store" became equal to "Store 01"
	* Check clearing legal name, Partner term when re-selecting a partner
		* Re-select partner
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
		* Check clearing fields
			Then the form attribute named "Agreement" became equal to ""
		* Check filling in legal name after re-selecting a partner
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
		* Select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Partner Kalipso Vendor' |
			And I select current line in "List" table
	* Check filling in Store and Compane from Partner term when re-selection partner
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check the item key autofill when adding Item (Item has one item key)
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Router'      |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'   | 'Item key' | 'Unit' | 'Store'    |
			| 'Router' | 'Router'   | 'pcs'  | 'Store 02' |
		* Filling in item and item key
			And I delete a line in "ItemList" table
			And I click "Add" button
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
	* Check re-filling store when re-select partner term
		* Re-select partner term
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Partner term vendor Partner Kalipso' |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			And I click "OK" button
		* Check store overfill in the added string
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Unit' | 'Store'    |
				| 'Trousers' | '500,00' | '38/Yellow' | '1,000' | 'pcs'  | 'Store 03' |
	* Check the re-drawing of the form for taxes at company re-selection.
		And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT'  | 'Item key'  | 'Tax amount'  | 'Q'     | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
			| '500,00' | 'Trousers' | '*'    | '38/Yellow' | '*'           | '1,000' | 'pcs'  | '*'          | '*'            | 'Store 03' |
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		If "ItemList" table does not contain "VAT" column Then
	* Check for clearing a line in the tax tree when deleting a line from a Sales return order
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I delete a line in "ItemList" table
		And I move to "Tax list" tab
		And "ItemList" table does not contain lines
			| 'Item'  | 'Item key' |
			| 'Trousers' | '38/Yellow' |
	* Add line
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I close all client application windows

	
	
