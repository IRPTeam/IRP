#language: en
@tree
@Positive
@Discount
@IgnoreOnCIMainBuild



Feature: check that the discount window is displayed in Sales Order

As a developer
I want to add a discount window to the order.
So that the manager can immediately see the interest and discount amount on the order.



Background:
	Given I launch TestClient opening script or connect the existing one
# For each product, a percentage discount is given (e.g. Product A from 2 to 5%, Product B from 3 to 7%). 
# The sales rep can set a discount from the specified range in the order himself

Scenario: _033901 check the discount window in the order (displaying discounts accrued on the order)
	* Inactive Discount on Basic Partner terms
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| '3+1 Product 1 and Product 2 (not multiplicity), Discount on Basic Partner terms' |
		And I select current line in "List" table
		And I change checkbox "Launch"
		And I click "Save and close" button
		And Delay 10
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	* Check display of valid discounts in % Offers window
		And in the table "ItemList" I click "% Offers" button
		And "Offers" table became equal
			| 'Presentation'                                                                 | 'Is select' | '%' | '∑' |
			| 'Special Offers'                                                               | ''          | ''  | ''  |
			| 'Sum'                                                                          | ''          | ''  | ''  |
			| 'Special Message Notification'                                                 | ' '         | ''  | ''  |
			| 'Minimum'                                                                      | ''          | ''  | ''  |
			| 'Special Message DialogBox'                                                    | ' '         | ''  | ''  |
			| 'Discount 1 without Vat'                                                       | ' '         | ''  | ''  |
			| 'Maximum'                                                                      | ''          | ''  | ''  |
			| 'Discount Price 1'                                                             | ' '         | ''  | ''  |
			| 'Discount Price 2'                                                             | ' '         | ''  | ''  |
			| 'Discount 2 without Vat'                                                       | ' '         | ''  | ''  |
			| 'All items 5+1, Discount on Basic Partner terms'                                  | ' '         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''  | ''  |
	* Check display of selected discount, its amount and percentage
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Partner terms' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And "Offers" table became equal
			| 'Presentation'                                                                 | 'Is select' | '%' | '∑' |
			| 'Special Offers'                                                               | ''          | ''  | ''  |
			| 'Sum'                                                                          | ''          | ''  | ''  |
			| 'Special Message Notification'                                                 | ' '         | ''  | ''  |
			| 'Minimum'                                                                      | ''          | ''  | ''  |
			| 'Special Message DialogBox'                                                    | ' '         | ''  | ''  |
			| 'Discount 1 without Vat'                                                       | ' '         | ''  | ''  |
			| 'Maximum'                                                                      | ''          | ''  | ''  |
			| 'Discount Price 1'                                                             | ' '         | ''  | ''  |
			| 'Discount Price 2'                                                             | ' '         | ''  | ''  |
			| 'Discount 2 without Vat'                                                       | ' '         | ''  | ''  |
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''  | ''  |
		And I click "OK" button
		And in the table "ItemList" I click "% Offers" button
		And "Offers" table became equal
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | ' '         | ''      | ''         |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '15,00' | '1 650,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
	* Check that the discount is not displayed after cancellation in the order.
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Partner terms' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And "Offers" table became equal
			| 'Presentation'                                              | 'Is select' | '%' | '∑' |
			| 'Special Offers'                                            | ''          | ''  | ''  |
			| 'Sum'                                                       | ''          | ''  | ''  |
			| 'Special Message Notification'                              | ' '         | ''  | ''  |
			| 'Minimum'                                                   | ''          | ''  | ''  |
			| 'Special Message DialogBox'                                 | ' '         | ''  | ''  |
			| 'Discount 1 without Vat'                                    | ' '         | ''  | ''  |
			| 'Maximum'                                                   | ''          | ''  | ''  |
			| 'Discount Price 1'                                          | ' '         | ''  | ''  |
			| 'Discount Price 2'                                          | ' '         | ''  | ''  |
			| 'Discount 2 without Vat'                                    | ' '         | ''  | ''  |
			| 'All items 5+1, Discount on Basic Partner terms'               | ' '         | ''  | ''  |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms' | ' '         | ''  | ''  |
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'All items 5+1, Discount on Basic Partner terms' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I click "OK" button
	* Check the discount recalculation in the discount window
		* Change q-ty for Product 1 to 30 pcs
			And in the table "ItemList" I click "Add" button
			Then "Pick up items" window is opened
			And I go to line in "ItemsList" table
				| 'Info'          | 'Item'      |
				| '20 unit × 550' | 'Product 1' |
			And I change "FastQuantity" radio button value to "10"
			And I activate "Info" field in "ItemsList" table
			And I select current line in "ItemsList" table
			And I click "OK" button
	* Discount recalculation check
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
		And in the table "ItemList" I click "% Offers" button
		And "Offers" table became equal
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | ' '         | ''      | ''         |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
		And I click "OK" button
	* The discount window shows several valid discounts on order
		And in the table "ItemList" I click "% Offers" button
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'Discount Price 1' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I click "OK" button
		And in the table "ItemList" I click "% Offers" button
		And "Offers" table became equal
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | '✔'         | '25,00' | '500,00'   |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
		And I click "OK" button
	* Check the range discount display (not displayed in this window)
		* Select discount 8% for Product 1
			And I go to line in "ItemList" table
				| 'Item'      |
				| 'Product 1' |
			And I activate field named "ItemListInfo" in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListContextMenuCheckOffersInRow"
			And I go to line in "Offers" table
				| 'Offer'                               |
				| 'Range Discount Basic (Product 1, 3)' |
			And I activate "∑" field in "Offers" table
			And I select current line in "Offers" table
			And I input "8" text in the field named "Percent"
			And I click "<< Back" button
			And in the table "Offers" I click "OK" button
			And Delay 2
		And in the table "ItemList" I click "% Offers" button
		And "Offers" table became equal
			| 'Presentation'                                                                 | 'Is select' | '%'     | '∑'        |
			| 'Special Offers'                                                               | ''          | ''      | ''         |
			| 'Sum'                                                                          | ''          | ''      | ''         |
			| 'Special Message Notification'                                                 | ' '         | ''      | ''         |
			| 'Minimum'                                                                      | ''          | ''      | ''         |
			| 'Special Message DialogBox'                                                    | ' '         | ''      | ''         |
			| 'Discount 1 without Vat'                                                       | ' '         | ''      | ''         |
			| 'Maximum'                                                                      | ''          | ''      | ''         |
			| 'Discount Price 1'                                                             | '✔'         | '25,00' | '500,00'   |
			| 'Discount Price 2'                                                             | ' '         | ''      | ''         |
			| 'Discount 2 without Vat'                                                       | ' '         | ''      | ''         |
			| 'All items 5+1, Discount on Basic Partner terms'                                  | '✔'         | '16,67' | '2 750,00' |
			| '4+1 Product 1 and Product 2, Discount on Basic Partner terms'                    | ' '         | ''      | ''         |
		And I click "OK" button
		And I click "Post and close" button







	






	











	







	













