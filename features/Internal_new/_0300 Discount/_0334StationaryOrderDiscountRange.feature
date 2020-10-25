#language: en
@tree
@Positive
@Discount
@SpecialOffersMaxInRow



Feature: range discount

As a sales manager
I want to check the calculation and order of applying the range discount (applied to the string manually, summed up with other discounts).
So that the range discount is calculated correctly


Background:
	Given I launch TestClient opening script or connect the existing one

# For each product, a discount is given in the form of a percentage (e.g. Product A from 2 to 5%, Product B from 3 to 7%). 
# A sales rep can set a discount from the specified range in a sales order himself

Scenario: _033401 preparation
	When change the Discount Price 2 manual
	When change the manual setting of the Discount Price 1 discount.
	When move the discount 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms to the group Maximum
	When move the discount 4+1 Dress and Trousers, Discount on Basic Partner terms to the group Maximum
	When move the discount All items 5+1, Discount on Basic Partner terms to the group Maximum
	When change manually setting All items 5+1, Discount on Basic Partner terms
	When  move the Discount Price 1 to Maximum 
	When change manually setting 3+1 Dress and Trousers (not multiplicity), Discount on Basic Partner terms
	When change manually setting 4+1 Dress and Trousers, Discount on Basic Partner terms


Scenario: _033402 range discount calculation by line 
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 6%
		And I go to line in "ItemList" table
			| 'Item'      |
			| 'Trousers'     |
		And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
		And I go to line in "Offers" table
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		And I activate "∑" field in "Offers" table
		And I select current line in "Offers" table
		And I input "6" text in the field named "PercentNumber"
		And I click the button named "FormOk"
		And I click the button named "FormOK"
		And Delay 2
	* Calculate range discount for Dress - 5%
		And I go to line in "ItemList" table
			| 'Item'      |
			| 'Dress' |
		And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
		And I go to line in "Offers" table
			| 'Presentation'                               |
			| 'Range Discount Basic (Dress)' |
		And I activate "∑" field in "Offers" table
		And I select current line in "Offers" table
		And I input "5" text in the field named "PercentNumber"
		And I click the button named "FormOk"
		And I click the button named "FormOK"
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '260,00'        | 'pcs'  | '4 940,00'        |
		| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '120,00'        | 'pcs'  | '1 880,00'        |
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
		| 'Partner'    | 'Σ'     |
		| 'Ferron BP'  |  '6 820,00'|
	

Scenario: _033403 check of the minimum percentage of the range discount by lines
# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
		When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
		* Calculate range discount for Trousers - 4%
			And I go to line in "ItemList" table
				| 'Item'      |
				| 'Trousers' |
			And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
			And I go to line in "Offers" table
				| 'Presentation'                               |
				| 'Range Discount Basic (Trousers)' |
			And I activate "∑" field in "Offers" table
			And I select current line in "Offers" table
			And I input "5" text in the field named "PercentNumber"
			And I click the button named "FormOk"
			And I click the button named "FormOK"
			And Delay 2
		* Calculate range discount for Dress - 3%
			And I go to line in "ItemList" table
				| 'Item'      |
				| 'Dress' |
			And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
			And I go to line in "Offers" table
				| 'Presentation'                               |
				| 'Range Discount Basic (Dress)' |
			And I activate "∑" field in "Offers" table
			And I select current line in "Offers" table
			And I input "3" text in the field named "PercentNumber"
			And I click the button named "FormOk"
			And I click the button named "FormOK"
			And Delay 2
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'| 'Total amount'    |
				| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '156,00'        | 'pcs' | '5 044,00'        |
				| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '100,00'        | 'pcs' | '1 900,00'        |
			And in the table "ItemList" I click "% Offers" button
			And I click "OK" button
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 944,00'|
		

Scenario: _033404 check of the maximum percentage of the range discount by lines
# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
		When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
		* Calculate range discount for Trousers - 8%
			And I go to line in "ItemList" table
				| 'Item'      |
				| 'Trousers' |
			And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
			And I go to line in "Offers" table
				| 'Presentation'                               |
				| 'Range Discount Basic (Trousers)' |
			And I activate "∑" field in "Offers" table
			And I select current line in "Offers" table
			And I input "7" text in the field named "PercentNumber"
			And I click the button named "FormOk"
			And I click the button named "FormOK"
			And Delay 2
		* Calculate range discount for Dress - 10%
			And I go to line in "ItemList" table
				| 'Item'      |
				| 'Dress' |
			And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
			And I go to line in "Offers" table
				| 'Presentation'                               |
				| 'Range Discount Basic (Dress)' |
			And I activate "∑" field in "Offers" table
			And I select current line in "Offers" table
			And I input "10" text in the field named "PercentNumber"
			And I click the button named "FormOk"
			And I click the button named "FormOK"
			And Delay 2
			And "ItemList" table contains lines
				| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
				| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '520,00'        | 'pcs'  | '4 680,00'        |
				| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '140,00'        | 'pcs'  | '1 860,00'        |
			And in the table "ItemList" I click "% Offers" button
			And I click "OK" button
			And I click the button named "FormPostAndClose"
			And "List" table contains lines
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 540,00'|
		

Scenario: _033405 Range discount and Special price discount calculation 
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 7%
		And I go to line in "ItemList" table
			| 'Item'      |
			| 'Trousers' |
		And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
		And I go to line in "Offers" table
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		And I activate "∑" field in "Offers" table
		And I select current line in "Offers" table
		And I input "7" text in the field named "PercentNumber"
		And I click the button named "FormOk"
		And I click the button named "FormOK"
		And Delay 2
	* Calculate Discount price 1
		And in the table "ItemList" I click "% Offers" button
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'Discount Price 1' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I click "OK" button
	* Check that the calculation is correct
		And "ItemList" table contains lines
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount' |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '260,00'        | 'pcs'  | '4 940,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '540,00'        | 'pcs'  | '1 460,00'        |
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '6 400,00'|


Scenario: _033406 check the discount order Range discount and crowding out 2 price special offers
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	When  move the Discount Price 2 special offer to Maximum
	When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 7%
		And I go to line in "ItemList" table
			| 'Item'      |
			| 'Trousers' |
		And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
		And I go to line in "Offers" table
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		And I activate "∑" field in "Offers" table
		And I select current line in "Offers" table
		And I input "7" text in the field named "PercentNumber"
		And I click the button named "FormOk"
		And I click the button named "FormOK"
		And Delay 2
	* Calculate discount Discount price 1
		And in the table "ItemList" I click "% Offers" button
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'Discount Price 1' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I go to line in "Offers" table
			| 'Presentation'                  |
			| 'Discount Price 2' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I click "OK" button
	* Check that the calculation is correct
		And "ItemList" table contains lines
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | '1 310,00'      | 'pcs'  | '3 890,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '725,00'        | 'pcs'  | '1 275,00'        |
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
				| 'Partner'    | 'Σ'     |
				| 'Ferron BP'  |  '5 165,00'|


Scenario: _033407 range discount recalculation when the quantity of items in the order changes
	# Trousers - 5-7%, Dress XS/Blue - 3-10%, Dress S/Yellow - 4-8%
	When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	* Calculate range discount for Trousers - 7%
		And I go to line in "ItemList" table
			| 'Item'      |
			| 'Trousers' |
		And in the table "ItemList" I click the button named "ItemListContextMenuSetSpecialOffersAtRow"
		And I go to line in "Offers" table
			| 'Presentation'                               |
			| 'Range Discount Basic (Trousers)' |
		And I activate "∑" field in "Offers" table
		And I select current line in "Offers" table
		And I input "7" text in the field named "PercentNumber"
		And I click the button named "FormOk"
		And I click the button named "FormOK"
		And Delay 2
	* Recalculation
		And "ItemList" table contains lines
			| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit'| 'Total amount'    |
			| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | ''              | 'pcs' | '5 200,00'        |
			| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '5,000'  | '140,00'        | 'pcs' | '1 860,00'        |
	* Change the quantity by Trousers by 30 pieces
		And I go to line in "ItemList" table
		| 'Item'      |
		| 'Trousers' |
		And I input "30,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Recalculation
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
	* Check recalculation
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'      | 'Offers amount' | 'Unit' | 'Total amount'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | 'Store 01' | '10,000' | ''              | 'pcs'  | '5 200,00'        |
		| 'Trousers' | '400,00' | '36/Yellow' | 'Store 01' | '30,000' | '140,00'        | 'pcs'  | '11 860,00'       |
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| 'Partner'    | 'Σ'     |
		| 'Ferron BP'  |  '17 060,00'|


	


	







	













