#language: en

@tree
@Positive
@Discount
@SpecialOffersMaxInRow


Feature: create order with special offer type - price type (Type joings MaxInRow, Special Offers MaxInRow)

As a sales manager
I want to check the order of discounts in the general group SpecialOffersMaxInRow, subgroup Maximum (MaxInRow).
So that discounts in the Maximum group are calculated by choosing the highest discount in the line.



Background:
	Given I launch TestClient opening script or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one

# When Type joins MaxInRow in Maximum, the orders in this group with discounts will work out the discounts that are most beneficial to the client. 
# Checking the most advantageous discounts by lines.


Scenario: _033501 change in the main group Special offers rule Minimum to Maximum by row
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'      |
		| 'Special Offers' |
	And in the table "List" I click the button named "ListContextMenuChange"
	And I click Open button of "Special offer type" field
	And I click "Set settings" button
	Then "Special offer rules" window is opened
	And I select "Maximum by row" exact value from "Type joining" drop-down list
	And I click "Save settings" button
	And I click "Save and close" button
	And Delay 10
	And I click "Save and close" button
	And Delay 10
	And I close all client application windows


Scenario: _033502 order creation discounted by price Discount Price 1 (price including VAT)
# Discount Price 1 works under the Basic Price Partner term (price includes VAT), Discount Price 2  works in parallel under this Partner term (prices lower than Discount Price 1)
# Maximum group has 2 Discount Price 1 and Discount Price 2 discounts
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'             |
		| 'Ferron BP' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                     |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Dress' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Boots' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Boots (12 pcs)' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	* Calculate Discount Price 1
		And in the table "ItemList" I click "% Offers" button
		And I go to line in "Offers" table
			| 'Presentation'            |
			| 'Discount Price 1' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I click "OK" button
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'           | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs'            | '2 470,00'        |
		| 'Boots' | '8 400,00' | '36/18SD'  | 'Store 01' | '2,000' | '2 400,00'    | 'Boots (12 pcs)' | '14 400,00'       |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'         |
		| 'Ferron BP' | '16 870,00' |



Scenario: _033503 order creation discounted by price Discount Price 2 (price including VAT)
# Discount Price 2 works under the Basic Price Partner term (price includes VAT), Discount Price 1 works in parallel under this Partner term (prices lower than Discount Price 1)
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	And I click "Save" button
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'         | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01'      | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01'      | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'         |
		| 'Lomaniti' | '2 495,00' |

	
Scenario: _033504 check the discount order in group Maximum (manual)
# Discounted Discount Price 2
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
		| 'Description'             |
		| 'Lomaniti' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                     |
		| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Dress' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Boots' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Boots (12 pcs)' |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 1' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	And "ItemList" table contains lines
		| 'Item'  | 'Price'    | 'Item key' | 'Store'         | 'Q'     | 'Offers amount' | 'Unit'           | 'Total amount'    |
		| 'Dress' | '520,00'   | 'XS/Blue'  | 'Store 01'      | '5,000' | '655,00'        | 'pcs'            | '1 945,00'        |
		| 'Boots' | '8 400,00' | '36/18SD'  | 'Store 01'      | '2,000' | '3 600,00'      | 'Boots (12 pcs)' | '13 200,00'       |
	And I move to "Special offers" tab
	And "SpecialOffers" table became equal
		| 'Special offer'    | 'Amount'   |
		| 'Discount Price 2' | '655,00'   |
		| 'Discount Price 2' | '3 600,00' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'         |
		| 'Lomaniti' | '15 145,00' |

Scenario: _033505 check the application of discounts Discount Price 1 without Vat (price not include VAT) - manual in the group Minimum and Discount Price 2 without Vat
	When move the Discount 2 without Vat special offer from Maximum to Minimum
	When changing the manual apply of Discount 2 without Vat for test
	When transfer the Discount 1 without Vat discount from Maximum to Minimum.
	And Delay 2
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And Delay 2
	And I set checkbox named "Manually"
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount 1 without Vat' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	And "ItemList" table contains lines
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '593,20'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '813,60'        | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2


Scenario: _033506  check the application of discounts Discount Price 2 without Vat (price not include VAT)- manual in the group Minimum and Discount Price 1 without Vat
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount 2 without Vat' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	And I click "Save" button
	And "ItemList" table contains lines
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '1 187,76'      | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	

	

Scenario: _033507 check the discount order in group Minimum (auto)
# Discounted Discount Price without Vat 1
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 2 without Vat' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window
	When changing the auto apply of Discount 1 without Vat
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And Delay 2
	And I click "OK" button
	And I click "Save" button
	And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '593,20'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '813,60'        | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	
	

Scenario: _033508 check the discount order in group Maximum (auto)
# Discounted Discount Price without Vat 2
	When move Discount 2 without Vat and Discount 1 without Vat discounts from the group Minimum to the group Maximum 
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 2 without Vat' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	And I click "Save" button
	And "ItemList" table contains lines
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	

Scenario: _033509 check the discount order in group Sum (auto discount by price type + message)
# Discounted Discount Price without Vat 2 + message Special Message DialogBox
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I click "List" button
	And Delay 2
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Sum'                |
	And I click the button named "FormChoose"
	And I go to line in "List" table
		| 'Description'                 |
		| 'Special Message DialogBox' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And Delay 2
	And I fix current form
	And I click the button named "FormChoose"
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message 2" substring will appear in 30 seconds
	And I click "Save" button
	And "ItemList" table contains lines
	| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
	| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
	| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	

Scenario: _033510 check the discount order in group Sum 2 auto message + price type discount
	# Discounted Discount Price without Vat 2 + Message 2 and Message 3
	When create discount Message Dialog Box 2 (Message 3)
	When changing the auto apply of Discount 1 without Vat
	When move the Discount 1 without Vat discount to the Sum group
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message 2" substring will appear in 30 seconds
	Then I wait that in user messages the "Message 3" substring will appear in 30 seconds
	And I click "Save" button
	And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02' | '10,000' | '896,10'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '12,000' | '1 187,76'      | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	

		

Scenario: _033511 check the discount order in group Sum 2 auto message
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And Delay 2
	And I set checkbox named "Manually"
	And checkbox "Manually" is equal to "Yes"
	And I click "Save and close" button
	And I close "Special offers" window
	When changing the manual apply of Discount 2 without Vat for test
	When create an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message 2" substring will appear in 30 seconds
	Then I wait that in user messages the "Message 3" substring will appear in 30 seconds
	And I click "Save" button
	And "ItemList" table contains lines
		| 'Item'       | 'Price'  | 'Item key' | 'Store'    | 'Offers amount' | 'Q'     | 'Unit' |
		| 'High shoes' | '462,96' | '39/19SD'  | 'Store 02' | ''              | '8,000' | 'pcs'  |
		| 'Boots'      | '601,85' | '39/18SD'  | 'Store 02' | ''              | '4,000' | 'pcs'  |
	And I click the button named "FormPostAndClose"
	And Delay 2


	

Scenario: _033512 check the discount order in group Minimum (manual)
    # Discounted Discount Price without Vat 1
	When transfer Discount 2 without Vat and Discount 1 without Vat discounts from Maximum to Minimum
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Shirt' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'                     |
			| 'Trousers' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "12,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount 1 without Vat' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount 2 without Vat' |
	And I select current line in "Offers" table
	And I click "OK" button
	And I click "Save" button
	And "ItemList" table contains lines:
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'         | 'Q'      | 'Offers amount' | 'Unit'|
		| 'Shirt'    | '296,61' | '36/Red'    | 'Store 02'      | '10,000' | '593,20'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02'      | '12,000' | '813,60'        | 'pcs' |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'MIO'         | '6 639,93' |




Scenario: _033513 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	# also checking for an unlisted discount of Discount 2 without Vat
	When  move the Discount Price 1 to Maximum
	When transfer the Discount Price 2 discount to the Minimum group
	When change the priority Discount Price 1 from 1 to 3
	When change the priority special offer Discount Price 2 from 4 to 2
	When change the auto setting of the special offer Discount Price 1
	When change the auto setting of the Discount Price 2
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount 2 without Vat' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033514 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1 
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033515 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 from 1 to 3
	When change the manual setting of the Discount Price 1 discount.
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
	| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
	| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
	| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033516 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When change the Discount Price 2 manual
	When change the auto setting of the special offer Discount Price 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033517 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (2 auto discount), priority Discount Price 1 higher than Discount Price 2
# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When  move the Discount Price 1 to Minimum
	When  move the Discount Price 2 special offer to Maximum
	When change the auto setting of the Discount Price 2
	When change the auto setting of the special offer Discount Price 1
	When change the priority Discount Price 1 from 1 to 3
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033518 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto), priority Discount Price 1 lower than Discount Price 2
# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |



Scenario: _033519 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the manual setting of the Discount Price 1 discount.
	When change the auto setting of the Discount Price 2 
	When change the priority Discount Price 1 from 1 to 3
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033520 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When change the auto setting of the special offer Discount Price 1
	When change the Discount Price 2 manual
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033521 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 from 1 to 3
	When change the manual setting of the Discount Price 1 discount.
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 1' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033522 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 1' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033523 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When  move the Discount Price 1 to Maximum
	When change the auto setting of the special offer Discount Price 1
	When change the priority Discount Price 1 from 1 to 3
	When move the Discount Price 2 special offer to Sum
	When change the auto setting of the Discount Price 2
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033524 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033525 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the manual setting of the Discount Price 1 discount.
	When change the priority Discount Price 1 from 1 to 3
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs'  | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs'  | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'     | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033526 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the Discount Price 2 manual
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 1' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |


Scenario: _033527 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When  move the Discount Price 1 to Minimum
	When change the auto setting of the special offer Discount Price 1
	When change the auto setting of the Discount Price 2
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033528 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033529 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 from 1 to 3
	When change the manual setting of the Discount Price 1 discount.
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033530 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the Discount Price 2 manual
	When change the auto setting of the special offer Discount Price 1
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033531 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the manual setting of the Discount Price 1 discount.
	When change the priority Discount Price 1 from 1 to 3
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 1' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |

Scenario: _033532 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 2, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 2' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I go to line in "Offers" table
		| 'Presentation'            |
		| 'Discount Price 1' |
	And I activate "Is select" field in "Offers" table
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 30 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'| 'Total amount'    |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '655,00'        | 'pcs' | '1 945,00'        |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '150,00'        | 'pcs' | '550,00'          |
	And I click the button named "FormPostAndClose"
	And Delay 2
	And "List" table contains lines
		| 'Partner'          | 'Σ'         |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
		| 'Lomaniti'         | '2 495,00' |
