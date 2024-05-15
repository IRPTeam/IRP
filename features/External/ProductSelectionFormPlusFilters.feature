#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one


# Pick up

Scenario: check the product selection form with price information in Sales order
# sale order and sales invoice, Basic Partner terms, TRY, Ferron
	And I click the button named "ItemListOpenPickupItems"
	# temporarily
	Then If dialog box is visible I click "OK" button
	# temporarily
	* Check selection by item type
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Clothes        |
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Title'                  | 'In stock'   | 'Unit'   | 'Price'   | 'Picked out'    |
			| 'Dress'                  | '*'          | 'pcs'    | ''        | ''              |
			| 'Trousers'               | '*'          | 'pcs'    | ''        | ''              |
			| 'Shirt'                  | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Shirt'      | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Trousers'   | ''           | 'pcs'    | ''        | ''              |
			| 'Scarf'                  | ''           | 'pcs'    | ''        | ''              |
	* Check selection updates when choosing another type of item
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Shoes          |
		And I select current line in "List" table
		And "ItemList" table became equal
			| Title        | Unit   | In stock   | Price   | Picked out    |
			| Boots        | '*'    | '*'        | '*'     | '*'           |
			| High shoes   | '*'    | '*'        | '*'     | '*'           |
	* Check the rejection
		And I click Clear button of "Item type" field
		And "ItemList" table contains lines
			| 'Title'                  | 'In stock'   | 'Unit'   | 'Price'   | 'Picked out'    |
			| 'Dress'                  | '*'          | 'pcs'    | ''        | ''              |
			| 'Trousers'               | '*'          | 'pcs'    | ''        | ''              |
			| 'Shirt'                  | ''           | 'pcs'    | ''        | ''              |
			| 'Boots'                  | ''           | 'pcs'    | ''        | ''              |
			| 'High shoes'             | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Shirt'      | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Trousers'   | ''           | 'pcs'    | ''        | ''              |
			| 'Service'                | ''           | 'pcs'    | ''        | ''              |
			| 'Router'                 | ''           | 'pcs'    | ''        | ''              |
			| 'Bag'                    | ''           | 'pcs'    | ''        | ''              |
			| 'Scarf'                  | ''           | 'pcs'    | ''        | ''              |
			| 'Chewing gum'            | ''           | 'pcs'    | ''        | ''              |
			| 'Skittles'               | ''           | 'pcs'    | ''        | ''              |
	* Check the display for item item key in the selection form
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And "ItemKeyList" table contains lines
			| Title       | Unit   | In stock   | Price   | Picked out    |
			| S/Yellow    | '*'    | '*'        | '*'     | '*'           |
			| XS/Blue     | '*'    | '*'        | '*'     | '*'           |
			| M/White     | '*'    | '*'        | '*'     | '*'           |
			| L/Green     | '*'    | '*'        | '*'     | '*'           |
			| XL/Green    | '*'    | '*'        | '*'     | '*'           |
			| Dress/A-8   | '*'    | '*'        | '*'     | '*'           |
			| XXL/Red     | '*'    | '*'        | '*'     | '*'           |
			| M/Brown     | '*'    | '*'        | '*'     | '*'           |
	* Check the items adding
		And I go to line in "ItemKeyList" table
			| Title       |
			| S/Yellow    |
		And I select current line in "ItemKeyList" table
		And "ItemTableValue" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'    |
			| 'Dress'   | '1,000'      | 'S/Yellow'    |
	* Add another line and change the quantity in the ItemTableValue table
		And in the table "ItemKeyList" I click the button named "ItemKeyListCommandBack"
		And I go to line in "ItemList" table
			| 'Title'       |
			| 'Trousers'    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'        |
			| '38/Yellow'    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'       |
		And I select current line in "ItemTableValue" table
		And I input "2,000" text in "Quantity" field of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And "ItemTableValue" table became equal
			| 'Item'       | 'Quantity'   | 'Item key'     |
			| 'Dress'      | '1,000'      | 'S/Yellow'     |
			| 'Trousers'   | '2,000'      | '38/Yellow'    |
	* Check the transfer of the picked items into a document
		And I click the button named "FormCommandSaveAndClose"
		And Delay 2
		And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'    |
			| 'Dress'      | '550,00'   | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '550*'            |
			| 'Trousers'   | '400,00'   | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '800*'            |
	* Add one more line to the order through the Add button
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Shirt          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			And I go to line in "List" table
			| Item    | Item key    |
			| Shirt   | 36/Red      |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the filling of the tabular part
		And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'    |
			| 'Dress'      | '550,00'   | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '550,00'          |
			| 'Trousers'   | '400,00'   | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '800,00'          |
			| 'Shirt'      | '350,00'   | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '350,00'          |
	* Add one more line to the order through the Pick up button
		And I click the button named "ItemListOpenPickupItems"
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| Title      |
			| L/Green    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
		| 'Item'   | 'Item key'   |
		| 'Dress'  | 'L/Green'    |
		And I select current line in "ItemTableValue" table
		And I activate field named "ItemTableValuePrice" in "ItemTableValue" table
		And I input "350,00" text in the field named "ItemTableValuePrice" of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And I click the button named "FormCommandSaveAndClose"
	* Check the filling of the tabular part
		And "ItemList" table became equal
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'    |
			| 'Dress'      | '550,00'   | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '550,00'          |
			| 'Trousers'   | '400,00'   | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '800,00'          |
			| 'Shirt'      | '350,00'   | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '350,00'          |
			| 'Dress'      | '350,00'   | 'L/Green'     | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '350,00'          |
	* Filling in procurement method
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		Then I select all lines of "ItemList" table
		And in the table "ItemList" I click "Procurement" button
		And I change checkbox "Stock"
		And I click "OK" button


Scenario: check the product selection form with price information in Sales invoice
# sale order and sales invoice, Basic Partner terms, TRY, Ferron
	And I click the button named "ItemListOpenPickupItems"
	# temporarily
	Then If dialog box is visible I click "OK" button
	# temporarily
	* Check selection by item type
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Clothes        |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Title'                  | 'In stock'   | 'Unit'   | 'Price'   | 'Picked out'    |
			| 'Dress'                  | '*'          | 'pcs'    | ''        | ''              |
			| 'Trousers'               | '*'          | 'pcs'    | ''        | ''              |
			| 'Shirt'                  | '*'          | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Shirt'      | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Trousers'   | ''           | 'pcs'    | ''        | ''              |
			| 'Scarf'                  | ''           | 'pcs'    | ''        | ''              |
	* Check selection updates when choosing another type of item
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Shoes          |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| Title        | Unit   | In stock   | Price   | Picked out    |
			| Boots        | '*'    | '*'        | '*'     | '*'           |
			| High shoes   | '*'    | '*'        | '*'     | '*'           |
	* Check the rejection
		And I click Clear button of "Item type" field
		And "ItemList" table contains lines
			| 'Title'                  | 'In stock'   | 'Unit'   | 'Price'   | 'Picked out'    |
			| 'Dress'                  | '*'          | 'pcs'    | ''        | ''              |
			| 'Trousers'               | '*'          | 'pcs'    | ''        | ''              |
			| 'Shirt'                  | '*'          | 'pcs'    | ''        | ''              |
			| 'Boots'                  | ''           | 'pcs'    | ''        | ''              |
			| 'High shoes'             | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Shirt'      | ''           | 'pcs'    | ''        | ''              |
			| 'Bound Dress+Trousers'   | ''           | 'pcs'    | ''        | ''              |
			| 'Service'                | ''           | 'pcs'    | ''        | ''              |
			| 'Router'                 | ''           | 'pcs'    | ''        | ''              |
			| 'Bag'                    | ''           | 'pcs'    | ''        | ''              |
			| 'Scarf'                  | ''           | 'pcs'    | ''        | ''              |
			| 'Chewing gum'            | ''           | 'pcs'    | ''        | ''              |
			| 'Skittles'               | ''           | 'pcs'    | ''        | ''              |
	* Check the display for item item key in the selection form
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And "ItemKeyList" table contains lines
			| Title       | Unit   | In stock   | Price   | Picked out    |
			| S/Yellow    | '*'    | '*'        | '*'     | '*'           |
			| XS/Blue     | '*'    | '*'        | '*'     | '*'           |
			| M/White     | '*'    | '*'        | '*'     | '*'           |
			| L/Green     | '*'    | '*'        | '*'     | '*'           |
			| XL/Green    | '*'    | '*'        | '*'     | '*'           |
			| Dress/A-8   | '*'    | '*'        | '*'     | '*'           |
			| XXL/Red     | '*'    | '*'        | '*'     | '*'           |
			| M/Brown     | '*'    | '*'        | '*'     | '*'           |
	* Check the items adding
		And I go to line in "ItemKeyList" table
			| Title       |
			| S/Yellow    |
		And I select current line in "ItemKeyList" table
		And "ItemTableValue" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'    |
			| 'Dress'   | '1,000'      | 'S/Yellow'    |
	* Add one more line and change the quantity in the ItemTableValue table
		And in the table "ItemKeyList" I click the button named "ItemKeyListCommandBack"
		And I go to line in "ItemList" table
			| 'Title'       |
			| 'Trousers'    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'        |
			| '38/Yellow'    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'       |
		And I select current line in "ItemTableValue" table
		And I input "2,000" text in "Quantity" field of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And "ItemTableValue" table became equal
			| 'Item'       | 'Quantity'   | 'Item key'     |
			| 'Dress'      | '1,000'      | 'S/Yellow'     |
			| 'Trousers'   | '2,000'      | '38/Yellow'    |
	* Check the transfer of the picked items into a document
		And I click the button named "FormCommandSaveAndClose"
		And Delay 2
		And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'    |
			| 'Dress'      | '550,00'   | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '550*'            |
			| 'Trousers'   | '400,00'   | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '800*'            |
	* Add one more line to the order through the Add button
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Shirt          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			And I go to line in "List" table
			| Item    | Item key    |
			| Shirt   | 36/Red      |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the filling of the tabular part
		And "ItemList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'    |
			| 'Dress'      | '550,00'   | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '550,00'          |
			| 'Trousers'   | '400,00'   | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '800,00'          |
			| 'Shirt'      | '350,00'   | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '350,00'          |
	* Add one more line to the order through the Pick up button
		And I click the button named "ItemListOpenPickupItems"
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| Title      |
			| L/Green    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
		| 'Item'   | 'Item key'   |
		| 'Dress'  | 'L/Green'    |
		And I select current line in "ItemTableValue" table
		And I activate field named "ItemTableValuePrice" in "ItemTableValue" table
		And I input "350,00" text in the field named "ItemTableValuePrice" of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And I click the button named "FormCommandSaveAndClose"
	* Check the filling of the tabular part
		And "ItemList" table became equal
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'    |
			| 'Dress'      | '550,00'   | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '550,00'          |
			| 'Trousers'   | '400,00'   | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '800,00'          |
			| 'Shirt'      | '350,00'   | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '350,00'          |
			| 'Dress'      | '350,00'   | 'L/Green'     | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '350,00'          |

Scenario: check the product selection form with price information in Purchase invoice
	# purchase order and purchase invoice, Basic Partner terms, TRY, Ferron
	And I click the button named "OpenPickupItems"
	# temporarily
	Then If dialog box is visible I click "OK" button
	# temporarily
	* Check selection by item type
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Clothes        |
		And I select current line in "List" table
		And "ItemList" table became equal
			| Title      | Unit   | In stock   | Price   | Picked out    |
			| Dress      | '*'    | '*'        | '*'     | '*'           |
			| Trousers   | '*'    | '*'        | '*'     | '*'           |
			| Shirt      | '*'    | '*'        | '*'     | '*'           |
	* Check selection updates when choosing another type of item
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Shoes          |
		And I select current line in "List" table
		And "ItemList" table became equal
			| Title        | Unit   | In stock   | Price   | Picked out    |
			| Boots        | '*'    | '*'        | '*'     | '*'           |
			| High shoes   | '*'    | '*'        | '*'     | '*'           |
	* Check the rejection
		And I click Clear button of "Item type" field
		And "ItemList" table became equal
			| Title        | Unit   | In stock   | Price   | Picked out    |
			| Dress        | '*'    | '*'        | '*'     | '*'           |
			| Trousers     | '*'    | '*'        | '*'     | '*'           |
			| Shirt        | '*'    | '*'        | '*'     | '*'           |
			| Boots        | '*'    | '*'        | '*'     | '*'           |
			| High shoes   | '*'    | '*'        | '*'     | '*'           |
	* Check the display for item item key in the selection form
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And "ItemKeyList" table became equal
			| Title       | Unit   | In stock   | Price   | Picked out    |
			| S/Yellow    | '*'    | '*'        | '*'     | '*'           |
			| XS/Blue     | '*'    | '*'        | '*'     | '*'           |
			| M/White     | '*'    | '*'        | '*'     | '*'           |
			| L/Green     | '*'    | '*'        | '*'     | '*'           |
			| XL/Green    | '*'    | '*'        | '*'     | '*'           |
			| Dress/A-8   | '*'    | '*'        | '*'     | '*'           |
			| XXL/Red     | '*'    | '*'        | '*'     | '*'           |
			# | M/Brown   | '*'   | '*'      |'*'     | '*'         |
	* Check the items adding
		And I go to line in "ItemKeyList" table
			| Title       |
			| S/Yellow    |
		And I select current line in "ItemKeyList" table
		And "ItemTableValue" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'    |
			| 'Dress'   | '1,000'      | 'S/Yellow'    |
	* Add another line and change the quantity in the ItemTableValue table
		And in the table "ItemKeyList" I click the button named "ItemKeyListCommandBack"
		And I go to line in "ItemList" table
			| 'Title'       |
			| 'Trousers'    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'        |
			| '38/Yellow'    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'       |
		And I select current line in "ItemTableValue" table
		And I input "2,000" text in "Quantity" field of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And "ItemTableValue" table became equal
			| 'Item'       | 'Quantity'   | 'Item key'     |
			| 'Dress'      | '1,000'      | 'S/Yellow'     |
			| 'Trousers'   | '2,000'      | '38/Yellow'    |
	* Check the transfer of the picked items into a document
		And I click the button named "FormCommandSaveAndClose"
		And Delay 2
		And "ItemList" table contains lines
			| 'Item'       | 'Price'   | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'       | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Trousers'   | '*'       | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
	* Add one more line to the order through the Add button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Shirt          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			And I go to line in "List" table
			| Item    | Item key    |
			| Shirt   | 36/Red      |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the filling of the tabular part
		And "ItemList" table contains lines
			| 'Item'       | 'Price'   | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'       | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Trousers'   | '*'       | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Shirt'      | '*'       | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
	* Add one more line to the order through the Pick up button
		And I click the button named "OpenPickupItems"
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| Title      |
			| L/Green    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
		| 'Item'   | 'Item key'   |
		| 'Dress'  | 'L/Green'    |
		And I select current line in "ItemTableValue" table
		And I activate field named "ItemTableValuePrice" in "ItemTableValue" table
		And I input "350,00" text in the field named "ItemTableValuePrice" of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And I click the button named "FormCommandSaveAndClose"
	* Check the filling of the tabular part
		And "ItemList" table became equal
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'        | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Trousers'   | '*'        | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Shirt'      | '*'        | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Dress'      | '350,00'   | 'L/Green'     | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |

Scenario: check the product selection form with price information in Purchase order
	# purchase order and purchase invoice, Basic Partner terms, TRY, Ferron
	And I click the button named "ItemListOpenPickupItems"
	# temporarily
	Then If dialog box is visible I click "OK" button
	# temporarily
	* Check selection by item type
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Clothes        |
		And I select current line in "List" table
		And "ItemList" table became equal
			| Title      | Unit   | In stock   | Price   | Picked out    |
			| Dress      | '*'    | '*'        | '*'     | '*'           |
			| Trousers   | '*'    | '*'        | '*'     | '*'           |
			| Shirt      | '*'    | '*'        | '*'     | '*'           |
	* Check selection updates when choosing another type of item
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Shoes          |
		And I select current line in "List" table
		And "ItemList" table became equal
			| Title        | Unit   | In stock   | Price   | Picked out    |
			| Boots        | '*'    | '*'        | '*'     | '*'           |
			| High shoes   | '*'    | '*'        | '*'     | '*'           |
	* Check the rejection
		And I click Clear button of "Item type" field
		And "ItemList" table became equal
			| Title        | Unit   | In stock   | Price   | Picked out    |
			| Dress        | '*'    | '*'        | '*'     | '*'           |
			| Trousers     | '*'    | '*'        | '*'     | '*'           |
			| Shirt        | '*'    | '*'        | '*'     | '*'           |
			| Boots        | '*'    | '*'        | '*'     | '*'           |
			| High shoes   | '*'    | '*'        | '*'     | '*'           |
	* Check the display for item item key in the selection form
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And "ItemKeyList" table became equal
			| Title       | Unit   | In stock   | Price   | Picked out    |
			| S/Yellow    | '*'    | '*'        | '*'     | '*'           |
			| XS/Blue     | '*'    | '*'        | '*'     | '*'           |
			| M/White     | '*'    | '*'        | '*'     | '*'           |
			| L/Green     | '*'    | '*'        | '*'     | '*'           |
			| XL/Green    | '*'    | '*'        | '*'     | '*'           |
			| Dress/A-8   | '*'    | '*'        | '*'     | '*'           |
			| XXL/Red     | '*'    | '*'        | '*'     | '*'           |
	* Check the items adding
		And I go to line in "ItemKeyList" table
			| Title       |
			| S/Yellow    |
		And I select current line in "ItemKeyList" table
		And "ItemTableValue" table contains lines
			| 'Item'    | 'Quantity'   | 'Item key'    |
			| 'Dress'   | '1,000'      | 'S/Yellow'    |
	* Add one more line and change the quantity in the ItemTableValue table
		And in the table "ItemKeyList" I click the button named "ItemKeyListCommandBack"
		And I go to line in "ItemList" table
			| 'Title'       |
			| 'Trousers'    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'Title'        |
			| '38/Yellow'    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'       | 'Item key'    | 'Quantity'    |
			| 'Trousers'   | '38/Yellow'   | '1,000'       |
		And I select current line in "ItemTableValue" table
		And I input "2,000" text in "Quantity" field of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And "ItemTableValue" table became equal
			| 'Item'       | 'Quantity'   | 'Item key'     |
			| 'Dress'      | '1,000'      | 'S/Yellow'     |
			| 'Trousers'   | '2,000'      | '38/Yellow'    |
	* Check the transfer of the picked items into a document
		And I click the button named "FormCommandSaveAndClose"
		And Delay 2
		And "ItemList" table contains lines
			| 'Item'       | 'Price'   | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'       | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Trousers'   | '*'       | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
	* Add one more line to the order through the Add button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Shirt          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			And I go to line in "List" table
			| Item    | Item key    |
			| Shirt   | 36/Red      |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check the filling of the tabular part
		And "ItemList" table contains lines
			| 'Item'       | 'Price'   | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'       | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Trousers'   | '*'       | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Shirt'      | '*'       | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
	* Add one more line to the order through the Pick up button
		And I click the button named "ItemListOpenPickupItems"
		And I go to line in "ItemList" table
			| Title    |
			| Dress    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| Title      |
			| L/Green    |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
		| 'Item'   | 'Item key'   |
		| 'Dress'  | 'L/Green'    |
		And I select current line in "ItemTableValue" table
		And I activate field named "ItemTableValuePrice" in "ItemTableValue" table
		And I input "350,00" text in the field named "ItemTableValuePrice" of "ItemTableValue" table
		And I finish line editing in "ItemTableValue" table
		And I click the button named "FormCommandSaveAndClose"
	* Check the filling of the tabular part
		And "ItemList" table became equal
			| 'Item'       | 'Price'    | 'Item key'    | 'Store'      | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Net amount'   | 'Total amount'    |
			| 'Dress'      | '*'        | 'S/Yellow'    | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Trousers'   | '*'        | '38/Yellow'   | 'Store 01'   | '2,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Shirt'      | '*'        | '36/Red'      | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |
			| 'Dress'      | '350,00'   | 'L/Green'     | 'Store 01'   | '1,000'      | '*'               | '*'            | 'pcs'    | '*'            | '*'               |


Scenario: check the product selection form in StockAdjustmentAsWriteOff/StockAdjustmentAsSurplus
	And I click "Pickup" button
	* Check the display of remains by Item
		And "ItemList" table contains lines
		| 'Title'                 | 'In stock'  | 'Unit'  | 'Picked out'   |
		| 'Dress'                 | '331'       | 'pcs'   | ''             |
		| 'Trousers'              | ''          | 'pcs'   | ''             |
		| 'Shirt'                 | '7'         | 'pcs'   | ''             |
		| 'Boots'                 | '4'         | 'pcs'   | ''             |
		| 'High shoes'            | ''          | 'pcs'   | ''             |
		| 'Bound Dress+Shirt'     | ''          | 'pcs'   | ''             |
		| 'Bound Dress+Trousers'  | ''          | 'pcs'   | ''             |
		| 'Router'                | ''          | 'pcs'   | ''             |
	* Check the display of remains by Item key
		And I go to line in "ItemList" table
		| 'In stock'  | 'Title'   |
		| '331'       | 'Dress'   |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'In stock'   | 'Title'     | 'Unit'    |
			| '197'        | 'XS/Blue'   | 'pcs'     |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemKeyList" table
			| 'In stock'   | 'Title'      | 'Unit'    |
			| '134'        | 'S/Yellow'   | 'pcs'     |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'     |
		And I activate "Quantity" field in "ItemTableValue" table
		And I select current line in "ItemTableValue" table
		And I input "4,000" text in "Quantity" field of "ItemTableValue" table
		And I click "Transfer to document" button
	* Check the transfer of remains to the document
		And "ItemList" table contains lines
		| 'Item'   | 'Quantity'  | 'Item key'  | 'Unit'   |
		| 'Dress'  | '1,000'     | 'XS/Blue'   | 'pcs'    |
		| 'Dress'  | '4,000'     | 'S/Yellow'  | 'pcs'    |
	* Check of remains change at re-selection of a store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I click "Pickup" button
		And "ItemList" table contains lines
		| 'Title'     | 'In stock'  | 'Unit'  | 'Picked out'   |
		| 'Dress'     | '398'       | 'pcs'   | ''             |
		| 'Trousers'  | '405'       | 'pcs'   | ''             |


Scenario: check the product selection form in InventoryTransferOrder/InventoryTransfer
	And I click "Pickup" button
	* Check the display of remains by Item
		And "ItemList" table contains lines
		| 'Title'     | 'In stock'  | 'Unit'  | 'In stock receiver'  | 'Picked out'   |
		| 'Dress'     | '331'       | 'pcs'   | '398'                | ''             |
		| 'Trousers'  | ''          | 'pcs'   | '405'                | ''             |
		| 'Shirt'     | '7'         | 'pcs'   | ''                   | ''             |
		| 'Boots'     | '4'         | 'pcs'   | ''                   | ''             |
	* Check the display of remains by Item key
		And I go to line in "ItemList" table
			| 'In stock'   | 'Title'    |
			| '331'        | 'Dress'    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'In stock'   | 'Title'     | 'Unit'    |
			| '197'        | 'XS/Blue'   | 'pcs'     |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemKeyList" table
			| 'In stock'   | 'Title'      | 'Unit'    |
			| '134'        | 'S/Yellow'   | 'pcs'     |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'     |
		And I activate "Quantity" field in "ItemTableValue" table
		And I select current line in "ItemTableValue" table
		And I input "4,000" text in "Quantity" field of "ItemTableValue" table
		And I click "Transfer to document" button
	* Check the transfer of remains to the document PhysicalInventory
		And "ItemList" table contains lines
			| 'Quantity'   | 'Item'    | 'Item key'   | 'Unit'    |
			| '4,000'      | 'Dress'   | 'S/Yellow'   | 'pcs'     |
			| '1,000'      | 'Dress'   | 'XS/Blue'    | 'pcs'     |
	* Check of remains change at re-selection of a store
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 05'       |
		And I select current line in "List" table
		And I click "Pickup" button
		And "ItemList" table contains lines
		| 'Title'     | 'In stock'  | 'Unit'  | 'In stock receiver'  | 'Picked out'   |
		| 'Dress'     | '398'       | 'pcs'   | '331'                | ''             |
		| 'Trousers'  | '405'       | 'pcs'   | ''                   | ''             |





# Filters

Scenario: check the filter by Legal name
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And "List" table became equal
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
	* Check the filter by string input
		And Delay 2
		And I input "Company Ferron BP" text in "Legal name" field
		And Delay 2
		And I click Select button of "Company" field
		And "List" table does not contain lines
			| Description          |
			| Company Ferron BP    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "LegalName" became equal to 'Company Ferron BP''    |
	And I close all client application windows

Scenario: check the filter by Legal name (Ferron)
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And "List" table became equal
			| 'Description'                 |
			| 'Company Ferron BP'           |
			| 'Second Company Ferron BP'    |
		And I click the button named "FormChoose"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Legal name" field
		And Delay 2
		And I click Select button of "Company" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "LegalName" became equal to 'Company Kalipso''    |
	And I close all client application windows

Scenario: check the filter by Legal name (Ferron) in Goods receipt and Shipment confirmation
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And "List" table became equal
			| 'Description'                 |
			| 'Company Ferron BP'           |
			| 'Second Company Ferron BP'    |
		And I click the button named "FormChoose"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Legal name" field
		And Delay 2
		And I click Select button of "Company" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "LegalName" became equal to 'Company Kalipso''    |
	* Check the automatic completion of the Legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| DFC            |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "DFC"
	And I close all client application windows

Scenario: check the filter by Company
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Partner" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "Company" became equal to 'Company Kalipso''    |
	And I close all client application windows

Scenario: check the filter by Company  in the inventory transfer
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Store Sender" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "Company" became equal to 'Company Kalipso''    |
	And I close all client application windows

Scenario: check the filter by Company  in the Shipment cinfirmation and Goods receipt
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Store" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "Company" became equal to 'Company Kalipso''    |
		And I close all client application windows

Scenario: check the filter by Company (Ferron)
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Partner" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "Company" became equal to 'Company Kalipso''    |
	And I close all client application windows


Scenario: check the filter by my own company
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Partner" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "LegalName" became equal to 'Company Kalipso''    |
	And I close all client application windows

Scenario: check the filter by my own company in Cash expence/Cash revenue
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Account" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "LegalName" became equal to 'Company Kalipso''    |
	And I close all client application windows

Scenario: check the filter by my own company in Reconcilation statement
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Legal name" field
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "LegalName" became equal to 'Company Kalipso''    |
	And I close all client application windows



Scenario: check the filter by my own company in Opening entry/Item stock adjustment
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
	And I close all client application windows

Scenario: check the filter by Partner term (by segments + expiration date)
	And I click the button named "FormCreate"
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I click the button named "FormChoose"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And "List" table became equal
			| 'Description'                         |
			| 'Basic Partner terms, TRY'            |
			| 'Basic Partner terms, without VAT'    |
			| 'Personal Partner terms, $'           |
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description                  |
			| Personal Partner terms, $    |
		And I select current line in "List" table
		Then the form attribute named "Agreement" became equal to "Personal Partner terms, $"
	* Check the filter by string input
		And Delay 2
		And I input "Sale autum, TRY" text in "Partner term" field
		And Delay 2
		And I click Select button of "Partner" field
		And "List" table does not contain lines
			| Description        |
			| Sale autum, TRY    |
		And I go to line in "List" table
			| Description                  |
			| Personal Partner terms, $    |
		And I select current line in "List" table
		When I Check the steps for Exception
			| 'Then the form attribute named "Agreement" became equal to 'Sale autum, TRY''    |
	And I close all client application windows


Scenario: check the filter by customers in the sales documents
* Check visual filter
	And I click Select button of "Partner" field
	And I click "List" button
	And I save number of "List" table lines as "QS"
	Then "QS" variable is equal to 25
	And "List" table contains lines
		| Description    |
		| Ferron BP      |
		| Kalipso        |
		| Manager B      |
		| Lomaniti       |
		| Anna Petrova   |
		| Alians         |
		| MIO            |
		| Seven Brand    |
	And I select current line in "List" table
* Check the filter by string input
	And Delay 2
	And I input "Alexander Orlov" text in "Partner" field
	And Delay 2
	And I click Select button of "Company" field
	And "List" table does not contain lines
			| Description        |
			| Alexander Orlov    |
	And I select current line in "List" table
	When I Check the steps for Exception
		| 'Then the form attribute named "Partner" became equal to 'Alexander Orlov''   |
And I close all client application windows

Scenario: check the filter by vendors in the purchase documents
* Check visual filter
	And I click Select button of "Partner" field
	And I click "List" button
	And I save number of "List" table lines as "QS"
	Then "QS" variable is equal to 18
	And "List" table contains lines
		| 'Description'       |
		| 'Ferron BP'         |
		| 'DFC'               |
		| 'Big foot'          |
		| 'Nicoletta'         |
		| 'Veritas'           |
		| 'Partner Kalipso'   |
	And I select current line in "List" table
* Check the filter by string input
	And Delay 2
	And I input "Kalipso" text in "Partner" field
	And Delay 2
	And I click Select button of "Company" field
	And "List" table does not contain lines
			| Description    |
			| Kalipso        |
	And I select current line in "List" table
	When I Check the steps for Exception
		| 'Then the form attribute named "Partner" became equal to 'Kalipso''   |
And I close all client application windows

Scenario: check the filter by customer partner terms in the sales documents
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And "List" table does not contain lines
			| Description           |
			| Vendor Ferron, TRY    |
			| Vendor Ferron, USD    |
			| Vendor Ferron, EUR    |
	And I select current line in "List" table
	* Check the filter by string input
		And Delay 2
		And I input "Vendor Ferron, TRY" text in "Partner term" field
		And Delay 2
		And I click Select button of "Partner" field
		And "List" table does not contain lines
			| Description           |
			| Vendor Ferron, TRY    |
		And I select current line in "List" table
		When I Check the steps for Exception
		| 'Then the form attribute named "Agreement" became equal to 'Vendor Ferron, TRY''   |
	And I close all client application windows
	
Scenario: check the filter by vendor partner terms in the purchase documents
	* Check visual filter
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And "List" table contains lines
			| Description           |
			| Vendor Ferron, TRY    |
			| Vendor Ferron, USD    |
			| Vendor Ferron, EUR    |
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 3
	And I select current line in "List" table
	* Check the filter by string input
		And Delay 2
		And I input "Basic Partner terms, TRY" text in "Partner term" field
		And Delay 2
		And I click Select button of "Partner" field
		And "List" table does not contain lines
			| Description                 |
			| Basic Partner terms, TRY    |
		And I select current line in "List" table
		When I Check the steps for Exception
		| 'Then the form attribute named "Agreement" became equal to 'Basic Partner terms, TRY''   |
	And I close all client application windows

Scenario: check Description
	And I click the button named "FormCreate"
	And I click "Description" hyperlink
	And I input "Test description" text in "Text" field
	And I click "OK" button
	Then the form attribute named "Description" became equal to "Test description"
	And I close all client application windows

Scenario: check filter for Legal name contract (in BP, CP)
	And I click the button named "FormCreate"
	And I select from the drop-down list named "Company" by "Main Company" string
	And in the table "PaymentList" I click the button named "PaymentListAdd"
	And I select "Ferron BP" from "Partner" drop-down list by string in "PaymentList" table
	And I select "Company Ferron BP" from "Payee" drop-down list by string in "PaymentList" table
	* Check list from
		And I activate "Legal name contract" field in "PaymentList" table
		And I click choice button of "Legal name contract" attribute in "PaymentList" table
		And "List" table became equal
			| 'Description'              |
			| 'Contract (Empty Company)' |
		And I close current window
	* Check input by string
		And I select "Contract (Empty Company)" from "Legal name contract" drop-down list by string in "PaymentList" table
	* Change Company
		And I select from the drop-down list named "Company" by "Second Company" string
		And I activate "Legal name contract" field in "PaymentList" table
		And I click choice button of "Legal name contract" attribute in "PaymentList" table
		And "List" table became equal
			| 'Description'               |
			| 'Contract (Empty Company)'  |
			| 'Contract (Second Company)' |
		And I go to line in "List" table
			| 'Description'               |
			| 'Contract (Second Company)' |
		And I select current line in "List" table
		And "PaymentList" table became equal
			| 'Partner'   | 'Payee'             | 'Legal name contract'       |
			| 'Ferron BP' | 'Company Ferron BP' | 'Contract (Second Company)' |
		And I finish line editing in "PaymentList" table
		And I select from the drop-down list named "Company" by "main" string
		And "PaymentList" table became equal
			| 'Partner'   | 'Payee'             | 'Legal name contract' |
			| 'Ferron BP' | 'Company Ferron BP' | ''                    |			
		And I close all client application windows
		
Scenario: check filter for Legal name contract (in BR, CR)
	And I click the button named "FormCreate"
	And I select from the drop-down list named "Company" by "Main Company" string
	And in the table "PaymentList" I click the button named "PaymentListAdd"
	And I select "Ferron BP" from "Partner" drop-down list by string in "PaymentList" table
	And I select "Company Ferron BP" from "Payer" drop-down list by string in "PaymentList" table
	* Check list from
		And I activate "Legal name contract" field in "PaymentList" table
		And I click choice button of "Legal name contract" attribute in "PaymentList" table
		And "List" table became equal
			| 'Description'              |
			| 'Contract (Empty Company)' |
		And I close current window
	* Check input by string
		And I select "Contract (Empty Company)" from "Legal name contract" drop-down list by string in "PaymentList" table
	* Change Company
		And I select from the drop-down list named "Company" by "Second Company" string
		And I activate "Legal name contract" field in "PaymentList" table
		And I click choice button of "Legal name contract" attribute in "PaymentList" table
		And "List" table became equal
			| 'Description'               |
			| 'Contract (Empty Company)'  |
			| 'Contract (Second Company)' |
		And I go to line in "List" table
			| 'Description'               |
			| 'Contract (Second Company)' |
		And I select current line in "List" table
		And "PaymentList" table became equal
			| 'Partner'   | 'Payer'             | 'Legal name contract'       |
			| 'Ferron BP' | 'Company Ferron BP' | 'Contract (Second Company)' |
		And I finish line editing in "PaymentList" table
		And I select from the drop-down list named "Company" by "main" string
		And "PaymentList" table became equal
			| 'Partner'   | 'Payer'             | 'Legal name contract' |
			| 'Ferron BP' | 'Company Ferron BP' | ''                    |			
		And I close all client application windows		

Scenario: check filter for Legal name contract (in CN, DN)
	And I click the button named "FormCreate"
	And I select from the drop-down list named "Company" by "Main Company" string
	And in the table "Transactions" I click the button named "TransactionsAdd"
	And I select "Ferron BP" from "Partner" drop-down list by string in "Transactions" table
	And I select "Company Ferron BP" from "Legal name" drop-down list by string in "Transactions" table
	* Check list from
		And I activate "Legal name contract" field in "Transactions" table
		And I click choice button of "Legal name contract" attribute in "Transactions" table
		And "List" table became equal
			| 'Description'              |
			| 'Contract (Empty Company)' |
		And I close current window
	* Check input by string
		And I select "Contract (Empty Company)" from "Legal name contract" drop-down list by string in "Transactions" table
	* Change Company
		And I select from the drop-down list named "Company" by "Second Company" string
		And I activate "Legal name contract" field in "Transactions" table
		And I click choice button of "Legal name contract" attribute in "Transactions" table
		And "List" table became equal
			| 'Description'               |
			| 'Contract (Empty Company)'  |
			| 'Contract (Second Company)' |
		And I go to line in "List" table
			| 'Description'               |
			| 'Contract (Second Company)' |
		And I select current line in "List" table
		And "Transactions" table became equal
			| 'Partner'   | 'Legal name'             | 'Legal name contract'       |
			| 'Ferron BP' | 'Company Ferron BP'      | 'Contract (Second Company)' |
		And I finish line editing in "Transactions" table
		And I select from the drop-down list named "Company" by "main" string
		And "Transactions" table became equal
			| 'Partner'   | 'Legal name'             | 'Legal name contract' |
			| 'Ferron BP' | 'Company Ferron BP'      | ''                    |			
		And I close all client application windows

Scenario: check filter for Legal name contract (LNC in header)
	And I click the button named "FormCreate"
	And I select from the drop-down list named "Partner" by "Ferron BP" string
	And I activate field named "ItemListLineNumber" in "ItemList" table
	And I select from "Legal name" drop-down list by "Company Ferron BP" string
	And I select from the drop-down list named "Company" by "Main Company" string
	* Check list form
		And I click Select button of "Legal name contract" field
		And "List" table became equal
			| 'Description'              |
			| 'Contract (Empty Company)' |
		And I close current window	
	* Check input by string
		And I select from "Legal name contract" drop-down list by "empty" string
		When I Check the steps for Exception
			| 'And I select from "Legal name contract" drop-down list by "Contract (Second Company)" string'   |
		And I input "" text in "Legal name contract" field			
	* Change Company
		And I select from the drop-down list named "Company" by "Second Company" string	
		And I click Select button of "Legal name contract" field
		And "List" table became equal
			| 'Description'               |
			| 'Contract (Empty Company)'  |
			| 'Contract (Second Company)' |
		And I go to line in "List" table
			| 'Description'               |
			| 'Contract (Second Company)' |
		And I select current line in "List" table
		Then the form attribute named "LegalNameContract" became equal to "Contract (Second Company)"
		And I select from the drop-down list named "Company" by "main" string
		Then the form attribute named "LegalNameContract" became equal to ""
		And I close all client application windows
						

# Collapsible group

Scenario: check the display of the header of the collapsible group in sales, purchase and return documents
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Partner" attribute is editable Then
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		If "Legal name" attribute is present on the form Then
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
				| Description      |
				| Main Company     |
		And I select current line in "List" table


Scenario: check the display of the header of the collapsible group in SalesReportFromTradeAgent
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Partner" attribute is editable Then
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description      |
			| Trade agent 1    |
		And I select current line in "List" table
		If "Legal name" attribute is present on the form Then
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description      |
			| Trade agent 1    |
		And I select current line in "List" table
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
				| Description      |
				| Main Company     |
		And I select current line in "List" table

Scenario: check the display of the header of the collapsible group in SalesReportToConsignor
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Partner" attribute is editable Then
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Consignor 1    |
		And I select current line in "List" table
		If "Legal name" attribute is present on the form Then
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description    |
			| Consignor 1    |
		And I select current line in "List" table
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
				| Description      |
				| Main Company     |
		And I select current line in "List" table

Scenario: check the display of the header of the collapsible group in expence/revenue documents
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is editable Then
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		If "Accoun" attribute is present on the form Then
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description          |
			| Bank account, TRY    |
		And I select current line in "List" table




Scenario: check the display of the header of the collapsible group in PhysicalInventory
	And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description    |
			| Store 01       |
		And I select current line in "List" table
	

Scenario: check the display of the header of the collapsible group in OpeningEntry
	And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
				| Description      |
				| Main Company     |
		And I select current line in "List" table


Scenario: check the display of the header of the collapsible group in inventory transfer
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
				| Description      |
				| Main Company     |
		And I select current line in "List" table
		If "Store sender" attribute is present on the form Then
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		If "Store receiver" attribute is present on the form Then
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| Description    |
			| Store 03       |
		And I select current line in "List" table

Scenario: check the display of the header of the collapsible group in Shipment confirmation, Goods receipt, Bundling/Unbundling
	And I click the button named "FormCreate"
	If "Company" attribute is present on the form Then
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	And I click Choice button of the field named "Store"
	And I go to line in "List" table
		| Description   |
		| Store 03      |
	And I select current line in "List" table

Scenario: check the product selection form in PhysicalInventory
	And I click "Pickup" button
	* Check the display of remains by Item
		And "ItemList" table contains lines
		| 'Title'                 | 'In stock'  | 'Unit'  | 'Picked out'   |
		| 'Dress'                 | '331'       | 'pcs'   | ''             |
		| 'Trousers'              | ''          | 'pcs'   | ''             |
		| 'Shirt'                 | '7'         | 'pcs'   | ''             |
		| 'Boots'                 | '4'         | 'pcs'   | ''             |
		| 'High shoes'            | ''          | 'pcs'   | ''             |
		| 'Bound Dress+Shirt'     | ''          | 'pcs'   | ''             |
		| 'Bound Dress+Trousers'  | ''          | 'pcs'   | ''             |
		| 'Router'                | ''          | 'pcs'   | ''             |
	* Check the display of remains by Item key
		And I go to line in "ItemList" table
			| 'In stock'   | 'Title'    |
			| '331'        | 'Dress'    |
		And I select current line in "ItemList" table
		And I go to line in "ItemKeyList" table
			| 'In stock'   | 'Title'     | 'Unit'    |
			| '197'        | 'XS/Blue'   | 'pcs'     |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemKeyList" table
			| 'In stock'   | 'Title'      | 'Unit'    |
			| '134'        | 'S/Yellow'   | 'pcs'     |
		And I select current line in "ItemKeyList" table
		And I go to line in "ItemTableValue" table
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'     |
		And I activate "Quantity" field in "ItemTableValue" table
		And I select current line in "ItemTableValue" table
		And I input "4,000" text in "Quantity" field of "ItemTableValue" table
		And I click "Transfer to document" button
	* Check the transfer of remains to the document PhysicalInventory
		And "ItemList" table contains lines
			| 'Phys. count'   | 'Item'    | 'Difference'   | 'Item key'   | 'Unit'    |
			| '4,000'         | 'Dress'   | '4,000'        | 'S/Yellow'   | 'pcs'     |
			| '1,000'         | 'Dress'   | '1,000'        | 'XS/Blue'    | 'pcs'     |
	* Check of remains change at re-selection of a store
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 06'       |
		And I select current line in "List" table
		And I click "Pickup" button
		And "ItemList" table contains lines
		| 'Title'     | 'In stock'  | 'Unit'  | 'Picked out'   |
		| 'Dress'     | '398'       | 'pcs'   | ''             |
		| 'Trousers'  | '405'       | 'pcs'   | ''             |



Scenario: check the display of the header of the collapsible group in bank payments documents
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description          |
			| Bank account, USD    |
		And I select current line in "List" table

Scenario: check the display of the header of the collapsible group in cash receipt document
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I select "Payment from customer" exact value from "Transaction type" drop-down list

Scenario: check the display of the header of the collapsible group in cash payment document
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list

Scenario: check the display of the header of the collapsible group in consolidated retail sales
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I select "Open" exact value from the drop-down list named "Status"




Scenario: check the display of the header of the collapsible group in planned incoming/outgoing documents
	And I click the button named "FormCreate"
	* Filling in the details of the document
		If "Company" attribute is present on the form Then
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code   | Description     |
			| TRY    | Turkish lira    |
		And I select current line in "List" table

Scenario: create a test partner with one vendor partner term and one customer partner term
	* Create Partner Kalipso
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I click the button named "FormCreate"
		And I input "Partner Kalipso New" text in the field named "Description_en"
		And I click Select button of "Main partner" field
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And I set checkbox "Customer"
		And I set checkbox "Vendor"
		And I click "Save" button
	* Add customer partner term
		And In this window I click command interface button "Partner terms"
		And I click the button named "FormCreate"
		And I input "Partner Kalipso Customer" text in the field named "Description_en"
		And I change "Type" radio button value to "Customer"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "#1001" text in "Number" field
		And I input "28.08.2019" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Type'            |
			| 'TRY'        | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| Description          |
			| Basic Price Types    |
		And I select current line in "List" table
		And I input "28.08.2019" text in "Start using" field
		And I set checkbox "Price includes tax"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Partner term (create) *" window closing in 20 seconds
	* Add vendor partner term
		And In this window I click command interface button "Partner terms"
		And I click the button named "FormCreate"
		And I input "Partner Kalipso Vendor" text in the field named "Description_en"
		And I change "Type" radio button value to "Vendor"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "#1001" text in "Number" field
		And I input "28.08.2019" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Type'            |
			| 'TRY'        | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| Description          |
			| Vendor price, TRY    |
		And I select current line in "List" table
		And I input "28.08.2019" text in "Start using" field
		And I set checkbox "Price includes tax"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| Description    |
			| Store 02       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Partner term (create) *" window closing in 20 seconds
	And I close all client application windows

Scenario: check the autocompletion of the partner term (by vendor) in the documents of purchase/returns 
	* Check the autofill partner term, legal name, company
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| Description    |
			| Veritas        |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Veritas"
		Then the form attribute named "LegalName" became equal to "Company Veritas "
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term (Veritas)"
		Then the form attribute named "Company" became equal to "Main Company"


Scenario: check the autocompletion of the partner term (by customer) in the documents of sales/returns 
	* Check the autofill partner term, legal name, company
		And I click Select button of "Partner" field
		And I click "List" button
		And I go to line in "List" table
			| Description    |
			| Nicoletta      |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Nicoletta"
		Then the form attribute named "LegalName" became equal to "Company Nicoletta"
		Then the form attribute named "Agreement" became equal to "Posting by Standard Partner term Customer"
		Then the form attribute named "Company" became equal to "Main Company"

Scenario: create test item with one item key
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I click the button named "FormCreate"
	And I input "Scarf" text in the field named "Description_en"
	And I click Select button of "Item type" field
	And I go to line in "List" table
		| Description   |
		| Clothes       |
	And I select current line in "List" table
	And I click Select button of "Unit" field
	And I go to line in "List" table
		| Description   |
		| pcs           |
	And I select current line in "List" table
	And I click "Save" button
	And In this window I click command interface button "Item keys"
	And I click the button named "FormCreate"
	And I click Select button of "Size" field
	And I go to line in "List" table
		| Additional attribute  | Description   |
		| Size                  | XS            |
	And I select current line in "List" table
	And I click Select button of "Color" field
	And I go to line in "List" table
		| Additional attribute  | Description   |
		| Color                 | Red           |
	And I select current line in "List" table
	And I click "Save and close" button
	And In this window I click command interface button "Main"
	And I click "Save and close" button



Scenario: check item key autofilling in sales/returns documents for an item that has only one item key
	* Select Item Scarf
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Scarf          |
		And I select current line in "List" table
	* Check filling in item key
		# temporarily
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I close "Item keys" window
		# temporarily
		And "ItemList" table contains lines
			| Item    | Item key   | Unit    |
			| Scarf   | XS/Red     | pcs     |
	And I close all client application windows


Scenario: check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key
	* Select Item Scarf
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Scarf          |
		And I select current line in "List" table
	* Check filling in item key
		And "ItemList" table contains lines
			| Item    | Item key   | Unit    |
			| Scarf   | XS/Red     | pcs     |
	And I close all client application windows

Scenario: check item key autofilling in bundling/transfer documents for an item that has only one item key
	And I move to "Item list" tab
	* Select Item Scarf
		And I click "Add" button
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description    |
			| Scarf          |
		And I select current line in "List" table
	* Check filling in item key
		And "ItemList" table contains lines
			| Item    | Item key   | Unit    |
			| Scarf   | XS/Red     | pcs     |
	And I close all client application windows

Scenario: check the barcode search in the sales documents + price and tax filling in
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Kalipso'       |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                |
		| 'Basic Partner terms, TRY'   |
	And I select current line in "List" table
	And in the table "ItemList" I click "SearchByBarcode" button
	And I input "2202283705" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Stock quantity'    |
			| 'Dress'   | '520,00'   | 'XS/Blue'    | '1,000'      | 'pcs'    | '520,00'         | '1,000'             |
		And in the table "ItemList" I click "SearchByBarcode" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Stock quantity'    |
			| 'Dress'   | '520,00'   | 'XS/Blue'    | '2,000'      | 'pcs'    | '1 040,00'       | '2,000'             |
	And I close all client application windows


Scenario: check the barcode search in the sales report from trade agent + price and tax filling in
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'     |
		| 'Trade agent 1'   |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                  |
		| 'Trade agent partner term 1'   |
	And I select current line in "List" table
	And in the table "ItemList" I click "SearchByBarcode" button
	And I input "2202283705" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button		
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Stock quantity'    |
			| 'Dress'   | '520,00'   | 'XS/Blue'    | '1,000'      | 'pcs'    | '520,00'         | '1,000'             |
		And in the table "ItemList" I click "SearchByBarcode" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Stock quantity'    |
			| 'Dress'   | '520,00'   | 'XS/Blue'    | '2,000'      | 'pcs'    | '1 040,00'       | '2,000'             |
	And I close all client application windows

Scenario: check the barcode search in the sales report to consignor + price and tax filling in
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'   |
		| 'Consignor 1'   |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                |
		| 'Consignor partner term 1'   |
	And I select current line in "List" table
	And in the table "ItemList" I click "SearchByBarcode" button
	And I input "2202283705" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button		
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Stock quantity'    |
			| 'Dress'   | '520,00'   | 'XS/Blue'    | '1,000'      | 'pcs'    | '520,00'         | '1,000'             |
		And in the table "ItemList" I click "SearchByBarcode" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Total amount'   | 'Stock quantity'    |
			| 'Dress'   | '520,00'   | 'XS/Blue'    | '2,000'      | 'pcs'    | '1 040,00'       | '2,000'             |
	And I close all client application windows

Scenario: check the barcode search on the return documents
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| Description   |
		| Kalipso       |
	And I select current line in "List" table
	And I click "SearchByBarcode" button
	And I input "2202283705" text in the field named "Barcode"
	And I move to the next attribute
	* Check the items adding
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'    | '1,000'             |
		And I click "SearchByBarcode" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'XS/Blue'    | '2,000'      | 'pcs'    | '2,000'             |
	And I close all client application windows


Scenario: check the barcode search in the purchase/purchase returns
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| Description   |
		| Ferron BP     |
	And I select current line in "List" table
	And I click the button named "SearchByBarcode"
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'    | '1,000'             |
		And I click the button named "SearchByBarcode"
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | '2,000'      | 'pcs'    | '2,000'             |
	And I close all client application windows

Scenario: check the barcode search in storage operations documents	
	And I click the button named "FormCreate"
	And in the table "ItemList" I click the button named "SearchByBarcode"
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Unit'   | 'Quantity'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | 'pcs'    | '1,000'      | '1,000'             |
		And in the table "ItemList" I click the button named "SearchByBarcode"
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Unit'   | 'Quantity'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | 'pcs'    | '2,000'      | '2,000'             |
	And I close all client application windows
	
	
		

Scenario: check the barcode search in the product bundling documents
	And I click the button named "FormCreate"
	And I move to "Item list" tab
	And in the table "ItemList" I click "SearchByBarcode" button
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'    | '1,000'             |
		And in the table "ItemList" I click "SearchByBarcode" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'   | '2,000'      | 'pcs'    | '2,000'             |
	And I close all client application windows

Scenario: check the barcode search in the PhysicalInventory documents
	And I click the button named "FormCreate"
	And I click "SearchByBarcode" button
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in tabular part
		And I click "Show row key" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Unit'   | 'Phys. count'    |
			| 'Dress'   | 'S/Yellow'   | 'pcs'    | '1,000'          |
		And I click "SearchByBarcode" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key'   | 'Unit'   | 'Phys. count'    |
			| 'Dress'   | 'S/Yellow'   | 'pcs'    | '2,000'          |
	And I close all client application windows

Scenario: check the barcode search in the Item stock adjustment
	And I click the button named "FormCreate"
	And I click "SearchByBarcode" button
	And I input "2202283713" text in the field named "Barcode"
	And I move to the next attribute
	* Check adding an items and filling in the price in the tabular part
		And in the table "ItemList" I click "Edit quantity in base unit" button
		And "ItemList" table contains lines
			| 'Item'    | 'Item key (surplus)'   | 'Unit'   | 'Quantity'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'             | 'pcs'    | '1,000'      | '1,000'             |
		And I click "SearchByBarcode" button
		And I input "2202283713" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table contains lines
			| 'Item'    | 'Item key (surplus)'   | 'Unit'   | 'Quantity'   | 'Stock quantity'    |
			| 'Dress'   | 'S/Yellow'             | 'pcs'    | '2,000'      | '2,000'             |
	And I close all client application windows
	

Scenario: check clone value in the documents (Profit loss center, Expense type)
	* Add line and fill Profit loss center and Expense type
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Profit loss center" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "ItemList" table
		And I activate "Expense type" field in "ItemList" table
		And I select "Expense" from "Expense type" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Add" button
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Add" button
		And I finish line editing in "ItemList" table
	* Clone value
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And in "ItemList" table I select all lines below the current line
		And I activate "Expense type" field in "ItemList" table
		And in the table "ItemList" I click "Clone value from first row" button
		And I activate "Profit loss center" field in "ItemList" table
		And in the table "ItemList" I click "Clone value from first row" button
	* Check clone value
		And "ItemList" table became equal
			| '#' | 'Profit loss center'      | 'Expense type' |
			| '1' | 'Distribution department' | 'Expense'      |
			| '2' | 'Distribution department' | 'Expense'      |
			| '3' | 'Distribution department' | 'Expense'      |
		And I close all client application windows

Scenario: check clone value in the documents (Profit loss center, Revenue type)
	* Add line and fill Profit loss center and Revenue type
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Profit loss center" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "ItemList" table
		And I activate "Revenue type" field in "ItemList" table
		And I select "Revenue" from "Revenue type" drop-down list by string in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Add" button
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click "Add" button
		And I finish line editing in "ItemList" table
	* Clone value
		And I go to line in "ItemList" table
			| '#' |
			| '1' |
		And in "ItemList" table I select all lines below the current line
		And I activate "Revenue type" field in "ItemList" table
		And in the table "ItemList" I click "Clone value from first row" button
		And I activate "Profit loss center" field in "ItemList" table
		And in the table "ItemList" I click "Clone value from first row" button
	* Check clone value
		And "ItemList" table became equal
			| '#' | 'Profit loss center'      | 'Revenue type' |
			| '1' | 'Distribution department' | 'Revenue'      |
			| '2' | 'Distribution department' | 'Revenue'      |
			| '3' | 'Distribution department' | 'Revenue'      |
		And I close all client application windows

Scenario: check clone value in the documents (Financial movement type, Cash flow center, Project)
	* Add line and fill Financial movement type, Cash flow center, project
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "Movement type 1" from "Financial movement type" drop-down list by string in "PaymentList" table
		And I activate "Cash flow center" field in "PaymentList" table
		And I select "Distribution department" from "Cash flow center" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Project" field in "PaymentList" table
		And I select "Project 01" from "Project" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Add" button
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Add" button
		And I finish line editing in "PaymentList" table
	* Clone value
		And I go to line in "PaymentList" table
			| '#' |
			| '1' |
		And in "PaymentList" table I select all lines below the current line
		And I activate "Financial movement type" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
		And I activate "Cash flow center" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
		And I activate "Project" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
	* Check clone value
		And "PaymentList" table became equal
			| '#' | 'Cash flow center'        | 'Financial movement type' | 'Project'    |
			| '1' | 'Distribution department' | 'Movement type 1'         | 'Project 01' |
			| '2' | 'Distribution department' | 'Movement type 1'         | 'Project 01' |
			| '3' | 'Distribution department' | 'Movement type 1'         | 'Project 01' |
		And I close all client application windows

Scenario: check clone value in the documents (Financial movement type, Cash flow center, Project, Expense type)
	* Add line and fill Financial movement type, Cash flow center, project
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "Movement type 1" from "Financial movement type" drop-down list by string in "PaymentList" table
		And I activate "Cash flow center" field in "PaymentList" table
		And I select "Distribution department" from "Cash flow center" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Project" field in "PaymentList" table
		And I select "Project 01" from "Project" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Expense type" field in "PaymentList" table
		And I select "Expense" from "Expense type" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Add" button
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click "Add" button
		And I finish line editing in "PaymentList" table
	* Clone value
		And I go to line in "PaymentList" table
			| '#' |
			| '1' |
		And in "PaymentList" table I select all lines below the current line
		And I activate "Financial movement type" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
		And I activate "Cash flow center" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
		And I activate "Project" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
		And I activate "Expense type" field in "PaymentList" table
		And in the table "PaymentList" I click "Clone value from first row" button
	* Check clone value
		And "PaymentList" table became equal
			| '#' | 'Cash flow center'        | 'Financial movement type' | 'Project'    | 'Expense type' |
			| '1' | 'Distribution department' | 'Movement type 1'         | 'Project 01' | 'Expense'      |
			| '2' | 'Distribution department' | 'Movement type 1'         | 'Project 01' | 'Expense'      |
			| '3' | 'Distribution department' | 'Movement type 1'         | 'Project 01' | 'Expense'      |
		And I close all client application windows