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
	* Launch Two plus part of third
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Two plus part of third' |
		And I select current line in "List" table
		And I set checkbox "Launch"
		And I click "Save and close" button
	* Launch Discount coupon 10%
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Discount coupon 10%' |
		And I select current line in "List" table
		And I set checkbox "Launch"
		And I click "Save and close" button
	* Remove Discount Price 1 to the group Сonsistently
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Discount Price 1' |
		And in the table "List" I click the button named "ListContextMenuMoveItem"
		Then "Special offers" window is opened
		And I click "List" button
		And I go to line in "List" table
			| 'Special offer type' |
			| 'Сonsistently'       |
		And I click the button named "FormChoose"

Scenario: _0349011 check preparation
	When check preparation
	
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
		
// Scenario: _034904 check two plus part of third discount in POS
// 		And I close all client application windows
// 	* Open POS and add items
// 		And In the command interface I select "Retail" "Point of sale"
// 		Then "Point of sales" window is opened
// 		And I click "Show items" button
// 		And I go to line in "ItemsPickup" table
// 			| 'Item'  |
// 			| 'Dress' |
// 		And I expand current line in "ItemsPickup" table
// 		And I go to line in "ItemsPickup" table
// 			| 'Item'                |
// 			| 'Dress, XS/Blue' |
// 		And I select current line in "ItemsPickup" table
// 		And I go to line in "ItemsPickup" table
// 			| 'Item'  |
// 			| 'Dress' |
// 		And I expand current line in "ItemsPickup" table
// 		And I go to line in "ItemsPickup" table
// 			| 'Item'                |
// 			| 'Dress, M/White' |
// 		And I select current line in "ItemsPickup" table
// 		And I go to line in "ItemsPickup" table
// 			| 'Item'  |
// 			| 'Bag' |
// 		And I expand current line in "ItemsPickup" table
// 		And I expand current line in "ItemsPickup" table
// 		And I go to line in "ItemsPickup" table
// 			| 'Item'                |
// 			| 'Bag, ODS' |
// 		And I select current line in "ItemsPickup" table
// 		And I go to line in "ItemList" table
// 			| 'Item' | 'Item key' |
// 			| 'Bag'  | 'ODS'      |
// 		And I select current line in "ItemList" table
// 		And I input "100,00" text in "Price" field of "ItemList" table
// 		And I finish line editing in "ItemList" table
// 	* Calculate discount
// 		Then "Point of sales *" window is opened
// 		And I move to the tab named "ButtonPage"
// 		And I click "Discount document" button
// 		Then "1C:Enterprise" window is opened
// 		And I click the button named "OK"
// 		Then "Point of sales *" window is opened
// 		And I click the button named "SetSpecialOffersAtRow"
// 		Then "Pickup special offers" window is opened
// 		And I close "Pickup special offers" window
				
				
	
		
				




	
