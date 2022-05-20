#language: en
@tree
@Positive
@Discount

Feature: check discounts in POS


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _034901 preparation (discounts in POS)
	When Create catalog BusinessUnits objects
	When Create catalog PaymentTypes objects
	When Create information register UserSettings records (Retail document)
	
Scenario: _034902 check discount price type calculation in POS
	* Open POS and add items
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| 'Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| 'Dress, M/White' |
		And I select current line in "ItemsPickup" table
	* Check calculation
		And I click "Discount document" button
		And I go to line in "Offers" table
			| 'Presentation'     |
			| 'Discount Price 2' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Serials' | 'Quantity' | 'Price'  | 'Offers' | 'Total' |
			| 'Dress' | 'XS/Blue'  | ''        | '1,000'    | '520,00' | '131,00' | '389,00'|
			| 'Dress' | 'M/White'  | ''        | '1,000'    | '520,00' | '131,00' | '389,00'|
	* Add one more item and check discount calculation
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| 'Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| 'Dress, L/Green' |
		And I select current line in "ItemsPickup" table
		And I click "Discount document" button
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Serials' | 'Quantity' | 'Price'  | 'Offers' | 'Total' |
			| 'Dress' | 'XS/Blue'  | ''        | '1,000'    | '520,00' | '131,00' | '389,00'|
			| 'Dress' | 'M/White'  | ''        | '1,000'    | '520,00' | '131,00' | '389,00'|
			| 'Dress' | 'L/Green'  | ''        | '1,000'    | '550,00' | '137,00' | '413,00'|
		Then the form attribute named "ItemListTotalOffersAmount" became equal to "399"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "1 191"		
		And I close all client application windows
		

		
				




	
