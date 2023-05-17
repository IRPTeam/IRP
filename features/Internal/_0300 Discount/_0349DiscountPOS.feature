#language: en
@tree
@Positive
@Discount

Feature: check discounts in POS


Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _034901 preparation (discounts in POS)
	When Create catalog BusinessUnits objects
	When Create catalog Users objects
	When Create catalog PaymentTypes objects
	When Create information register Barcodes records
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
	* Workstation
		When Create catalog Workstations objects
		When Create POS cash account objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	

Scenario: _0349011 check preparation
	When check preparation
	
Scenario: _034902 check discount price type calculation in POS
	* Open POS and add items
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, (BN898) M/White' |
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
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, L/Green' |
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
		* Payment
			And I click "Payment (+)" button
			Then "Payment" window is opened
			And I click the button named "Enter"
			And I close all client application windows		
		
		
Scenario: _034904 check two plus part of third discount in POS
		And I close all client application windows
	* Open POS and add items
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, (BN898) M/White' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(D18001) Bag' |
		And I expand current line in "ItemsPickup" table
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(D18001) Bag, ODS' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemList" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Calculate discount
		And I move to the tab named "ButtonPage"
		And I click "Discount document" button
		Then "Pickup special offers" window is opened
		And I go to line in "Offers" table
			| 'Is select' | 'Presentation'           |
			| '☐'         | 'Two plus part of third' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And in the table "Offers" I click "OK" button
	* Check discount calculation
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '520,00' | '1,000'    | ''       | '520,00' |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '1,000'    | ''       | '520,00' |
			| 'Bag'   | ''             | 'ODS'      | ''        | '100,00' | '1,000'    | '60,00'  | '40,00'  |
	* Change quantity and check discount calculation
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Total'  |
			| 'Dress' | 'XS/Blue'  | '520,00' | '1,000'    | '520,00' |
		And I select current line in "ItemList" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item' | 'Item key' | 'Offers' | 'Price'  | 'Quantity' | 'Total' |
			| 'Bag'  | 'ODS'      | '60,00'  | '100,00' | '1,000'    | '40,00' |
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Discount document" button
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'    |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '520,00' | '4,000'    | ''       | '2 080,00' |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '2,000'    | ''       | '1 040,00' |
			| 'Bag'   | ''             | 'ODS'      | ''        | '100,00' | '2,000'    | '120,00' | '80,00'    |
	* Delete string and check discount calculation
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Total'    |
			| 'Dress' | 'XS/Blue'  | '520,00' | '4,000'    | '2 080,00' |
		And in the table "ItemList" I click the button named "ItemListContextMenuDelete"
		And I click "Discount document" button
		Then "Pickup special offers" window is opened
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'    |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '2,000'    | ''       | '1 040,00' |
			| 'Bag'   | ''             | 'ODS'      | ''        | '100,00' | '2,000'    | '60,00'  | '140,00'   |
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click the button named "Enter"
		And I close all client application windows
		
				
Scenario: _034905 check price type discount + discount coupon in POS
		And I close all client application windows
	* Open POS and add items
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, (BN898) M/White' |
		And I select current line in "ItemsPickup" table
	* Check discounts
		And I click "Discount document" button
		Then "Pickup special offers" window is opened
		And I go to line in "Offers" table
			| 'Is select' | 'Presentation'     |
			| '☐'         | 'Discount Price 1' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I go to line in "Offers" table
			| '%'     | 'Is select' | 'Presentation'        |
			| '10,00' | '☐'         | 'Discount coupon 10%' |
		And I select current line in "Offers" table
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '520,00' | '1,000'    | '75,40'  | '444,60' |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '1,000'    | '75,40'  | '444,60' |
	* Change quantity and check discounts
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Discount document" button
		Then "Pickup special offers" window is opened
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '520,00' | '1,000'    | '75,40'  | '444,60' |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '2,000'    | '150,80' | '889,20' |
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click the button named "Enter"
		And I close all client application windows
		
						
Scenario: _034906 check price type discount + discount coupon in POS
		And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'         |
			| 'Discount coupon 10%' |
		And I select current line in "List" table
		And I remove checkbox named "Manually"	
		And I click "Save and close" button
	* Open POS and add items
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, (BN898) M/White' |
		And I select current line in "ItemsPickup" table	
	* Check calculate offers when press payment
		And I click "Payment (+)" button
		Then the form attribute named "SpecialOffer" became equal to "104"
		Then the form attribute named "Amount" became equal to "936"
	* Select one more discount and check discount recalculate
		And I close "Payment" window
		And I move to the tab named "ButtonPage"
		And I click "Discount document" button
		And I go to line in "Offers" table
			| 'Is select'  | 'Presentation'     |
			| '☐'         | 'Discount Price 1' |
		And I select current line in "Offers" table
		And in the table "Offers" I click "OK" button
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Payment (+)" button
		Then the form attribute named "SpecialOffer" became equal to "226,2"
		Then the form attribute named "Amount" became equal to "1 333,8"
		And I click the button named "Enter"		
	And I close all client application windows
	
				
Scenario: _034908 check return with discount from POS (first select basis document)
		And I close all client application windows
	* Preparation
		When Create document RetailSalesReceipt with discount
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(381).GetObject().Write(DocumentWriteMode.Posting);" |
	* Open POS
		And In the command interface I select "Retail" "Point of sale"
		And I click the button named "Return"
		And I click Select button of "Retail sales receipt (basis)" field
		And I go to line in "List" table
			| 'Retail sales receipt'                               |
			| 'Retail sales receipt 381 dated 28.01.2023 11:44:13' |
		And I select current line in "List" table
	* Check item tab
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers'    | 'Total'     |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '100,000'  | '13 520,00' | '38 480,00' |
			| 'Dress' | ''             | 'L/Green'  | ''        | '550,00' | '11,000'   | '1 155,00'  | '4 895,00'  |
	* Change quantity
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Offers'   | 'Price'  | 'Quantity' | 'Total'    |
			| 'Dress' | 'L/Green'  | '1 155,00' | '550,00' | '11,000'   | '4 895,00' |	
		And I select current line in "ItemList" table
		And I input "10,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Offers'    | 'Price'  | 'Quantity' | 'Total'     |
			| 'Dress' | 'M/White'  | '13 520,00' | '520,00' | '100,000'  | '38 480,00' |
		And I select current line in "ItemList" table
		And I input "50,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers'   | 'Total'     |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '50,000'   | '6 760,00' | '19 240,00' |
			| 'Dress' | ''             | 'L/Green'  | ''        | '550,00' | '10,000'   | '1 050,00' | '4 450,00'  |
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "ItemList" table
		And I input "11,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers'   | 'Total'     |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '50,000'   | '6 760,00' | '19 240,00' |
			| 'Dress' | ''             | 'L/Green'  | ''        | '550,00' | '11,000'   | '1 155,00' | '4 895,00'  |
	* Payment
		And I click "Payment Return" button
		Then "Payment" window is opened
		And I click the button named "Enter"
		And I close all client application windows
		
				
				
Scenario: _034910 check price type discount + sum in POS (Consequentially)
		And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I go to line in "List" table
			| 'Description'     |
			| 'Consequentially' |
		And I select current line in "List" table
		And I remove checkbox "Sequential calculation for each row in document"
		And I click "Save and close" button	
		And I go to line in "List" table
			| 'Description'         |
			| 'Discount coupon 10%' |
		And I select current line in "List" table
		And I remove checkbox named "Launch"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'       |
			| 'Document discount' |
		And in the table "List" I click the button named "ListContextMenuMoveItem"
		And I go to line in "List" table
			| 'Special offer type' |
			| 'Сonsistently'       |
		And I click the button named "FormChoose"
	* Open POS and add items
		And In the command interface I select "Retail" "Point of sale"
		Then "Point of sales" window is opened
		And I click "Show items" button
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, XS/Blue' |
		And I select current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'  |
			| '(10001) Dress' |
		And I expand current line in "ItemsPickup" table
		And I go to line in "ItemsPickup" table
			| 'Item'                |
			| '(10001) Dress, (BN898) M/White' |
		And I select current line in "ItemsPickup" table
		And I input "3,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table		
	* Check discounts
		And I click "Discount document" button
		Then "Pickup special offers" window is opened
		And I go to line in "Offers" table
			| 'Is select' | 'Presentation'     |
			| '☐'         | 'Discount Price 1' |
		And I activate "Is select" field in "Offers" table
		And I select current line in "Offers" table
		And I go to line in "Offers" table
			| 'Is select' | 'Presentation'        |
			| '☐'         | 'Document discount' |
		And I activate "%" field in "Offers" table
		And I select current line in "Offers" table
		And I change the radio button named "Type" value to "Amount"
		And I input "1 000,00" text in the field named "Amount"
		And I click the button named "Ok"
		Then "Pickup special offers" window is opened
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '520,00' | '1,000'    | '276,00' | '244,00' |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '3,000'    | '828,00' | '732,00' |			
	* Change quantity and check discounts
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'M/White'  |
		And I select current line in "ItemList" table
		And I input "4,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Discount document" button
		Then "Pickup special offers" window is opened
		And in the table "Offers" I click "OK" button
		And "ItemList" table became equal
			| 'Item'  | 'Sales person' | 'Item key' | 'Serials' | 'Price'  | 'Quantity' | 'Offers' | 'Total'    |
			| 'Dress' | ''             | 'XS/Blue'  | ''        | '520,00' | '1,000'    | '226,00' | '294,00'   |
			| 'Dress' | ''             | 'M/White'  | ''        | '520,00' | '4,000'    | '904,00' | '1 176,00' |				
	* Payment
		And I click "Payment (+)" button
		Then "Payment" window is opened
		And I click the button named "Enter"
		And I close all client application windows			
				
				
Scenario: _034912 check auto calculate discount
	And I close all client application windows
	* Select workstation 				
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'    |
			| 'Workstation 01' |
		And I select current line in "List" table
		And I set checkbox "Auto calculate discount"
		And I click "Save and close" button
	* Launch Discount coupon 10%
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I go to line in "List" table
			| 'Description'    |
			| 'Discount coupon 10%' |
		And I select current line in "List" table
		Then "Discount coupon 10% (Special offer) *" window is opened
		And I change checkbox named "Launch"
		And I click "Save and close" button
	* Check auto calculate discount
		And In the command interface I select "Retail" "Point of sale"
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | 'XS/Blue'  | '520,00' | '1,000'    | '52,00'  | '468,00' |
		And I click "Search by barcode (F7)" button
		And I input "2202283705" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | 'XS/Blue'  | '520,00' | '2,000'    | '104,00' | '936,00' |
		And I click "Search by barcode (F7)" button
		And I input "2202283714" text in the field named "Barcode"
		And I move to the next attribute
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Price'  | 'Quantity' | 'Offers' | 'Total'  |
			| 'Dress' | 'XS/Blue'  | '520,00' | '2,000'    | '104,00' | '936,00' |
			| 'Dress' | 'M/Brown'  | '500,00' | '1,000'    | '50,00'  | '450,00' |
		And I delete all lines of "ItemList" table
		
		
						

				
		
				
								

				
				
		
						
				
		
				
				
	
		
				




	
