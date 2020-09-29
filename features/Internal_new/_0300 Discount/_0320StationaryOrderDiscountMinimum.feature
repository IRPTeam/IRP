#language: en
@Positive
@Discount
@SpecialOffersMinimum
@Group8

Feature: calculation of discounts in a group Minimum (type joings Minimum, Special Offers MaxInRow)

As a sales manager
I want to check the order of discounts in the general group SpecialOffersMaxInRow, subgroup Minimum.
So that discounts in the Minimal group are calculated by choosing the lowest discount in the line.


Background:
	Given I launch TestClient opening script or connect the existing one

# Checking the discount calculation in the group Minimum created inside the group Minimum, which is in the group Maximum
# With Type joins Minimum, discounts in this group will work out the discounts that are least beneficial to the client. 
# Checking for overall discounts on orders (not on lines). 
# Discounts that are outside the group are at least checked by lines and applied according to the rule "most advantageous to the client". 


Scenario: _032001 discount calculation Discount 2 without Vat in the group Sum in Minimum and Discount 1 without Vat in the group Minimum (manual)
	# Discounted Discount 1 without Vat
	When move the group Sum in Minimum to Minimum
	When move the Discount 1 without Vat discount to the Sum in Minimum group
	When move the Discount 1 without Vat discount to Minimum
	* Add Kalipso to the Retail segment
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		
		And I go to line in "List" table
			| Description |
			| Retail      |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Kalipso     |
		And I select current line in "List" table
		And I click "Save and close" button
		If window with "1C:Enterprise" header has appeared Then
		And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I click "List" button	
	And I go to line in "List" table
		| 'Description'             |
		| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
		| 'Description'                     |
		| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'  |
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
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
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
		And I input "4,000" text in "Q" field of "ItemList" table
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
	And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |

Scenario: _032002 discount calculation Discount 2 without Vat in the group Sum in Minimum and Discount 1 without Vat in the group Minimum (auto)
	# Discounted Discount 1 without Vat
	When changing the auto apply of Discount 1 without Vat
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
	* Add Kalipso to the Retail segment
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		
		And I go to line in "List" table
			| Description |
			| Retail      |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Kalipso     |
		And I select current line in "List" table
		And I click "Save and close" button
		If window with "1C:Enterprise" header has appeared Then
		And I close all client application windows
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
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'  |
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
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
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
		And I input "4,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	And I click "Save" button
	And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '474,56'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '271,20'        |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |
		| 'MIO'       | '3 519,99' |


Scenario: _032003 discount calculation Discount 2 without Vat in the main group Special Offers, Discount 1 without Vat in the group Sum in Minimum (auto)
	# Discounted Discount 2 without Vat
	When move the Discount 2 without Vat discount to Special Offers
	* Add Kalipso to the Retail segment
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		
		And I go to line in "List" table
			| Description |
			| Retail      |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Kalipso     |
		And I select current line in "List" table
		And I click "Save and close" button
		If window with "1C:Enterprise" header has appeared Then
		And I close all client application windows
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
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'  |
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
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
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
		And I input "4,000" text in "Q" field of "ItemList" table
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
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '716,88'        | 'pcs' |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '395,92'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
	
	

Scenario: _032004 discount calculation Discount 1 without Vat in the main group Special Offers, Discount 2 without Vat in the group Sum in Minimum (auto)
	# Discounted Discount 2 without Vat
	When move the Discount 1 without Vat discount to the Sum in Minimum group
	When move Discount 1 without Vat in Special Offers
	* Add Kalipso to the Retail segment
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		And I go to line in "List" table
			| Description |
			| Retail      |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Kalipso     |
		And I select current line in "List" table
		And I click "Save and close" button
		If window with "1C:Enterprise" header has appeared Then
		And I close all client application windows
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
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Kalipso'  |
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
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
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
		And I input "4,000" text in "Q" field of "ItemList" table
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
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    | 'Q'     | 'Offers amount' |
		| 'Shirt'    | '296,61' | '38/Black'  | 'Store 02' | '8,000' | '716,88'        |
		| 'Trousers' | '338,98' | '36/Yellow' | 'Store 02' | '4,000' | '395,92'        |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'        |
		| 'MIO'       | '3 086,88' |
		| 'MIO'       | '3 086,88' |


# Procedure for calculating discounts in the main group Minimum


Scenario: _032005 change Special offers main group Maximum by row to Minimum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'      |
		| 'Special Offers' |
	And in the table "List" I click the button named "ListContextMenuChange"
	And I click Open button of "Special offer type" field
	And I click "Set settings" button
	Then "Special offer rules" window is opened
	And I select "Minimum" exact value from "Type joining" drop-down list
	And I click "Save settings" button
	And I click "Save and close" button
	And Delay 10
	And I click "Save and close" button
	And Delay 10
	And I close all client application windows

Scenario: _032006 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification (auto)
	And I close all client application windows
	When  move the Discount Price 1 to Maximum
	When transfer the Discount Price 2 discount to the Minimum group
	When change the priority Discount Price 1 from 1 to 3
	When change the priority special offer Discount Price 2 from 4 to 2
	When change the auto setting of the special offer Discount Price 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
	

Scenario: _032007 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1 
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Scenario: _032008 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 from 1 to 3
	When change the manual setting of the Discount Price 1 discount.
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|



Scenario: _032009 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Minimum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
		Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
		And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		And I click "Post and close" button
		And Delay 2
		And "List" table contains lines
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|

Scenario: _032010 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (2 auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		When  move the Discount Price 1 to Minimum
		When  move the Discount Price 2 special offer to Maximum
		When change the auto setting of the Discount Price 2
		When change the auto setting of the special offer Discount Price 1
		When change the priority Discount Price 1 from 1 to 3
		When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
		Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
		And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		And I click "Post and close" button
		And Delay 2
		And "List" table contains lines
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Scenario: _032011 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
		When change the priority Discount Price 1 to 1
		When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
		And in the table "ItemList" I click "% Offers" button
		And I click "OK" button
		Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
		And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
			| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
		And I click "Post and close" button
		And Delay 2
		And "List" table contains lines
			| 'Partner'   | 'Σ'     |
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|
			| 'Lomaniti'  |  '3 070,00'|


Scenario: _032012 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the manual setting of the Discount Price 1 discount.
	When change the priority Discount Price 1 from 1 to 3
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit' |
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Scenario: _032013 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Scenario: _032014 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 from 1 to 3
	When change the manual setting of the Discount Price 1 discount.
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032015 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Maximum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032016 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When  move the Discount Price 1 to Maximum
	When change the auto setting of the special offer Discount Price 1
	When change the priority Discount Price 1 from 1 to 3
	When move the Discount Price 2 special offer to Sum
	When change the auto setting of the Discount Price 2
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And Delay 2
	And I click "Post and close" button
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032017 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032018 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the manual setting of the Discount Price 1 discount.
	When change the priority Discount Price 1 from 1 to 3
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Scenario: _032019 check the discount order (same application rule), Discount Price 1 in the group Maximum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032020 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When  move the Discount Price 1 to Minimum
	When change the auto setting of the special offer Discount Price 1
	When change the auto setting of the Discount Price 2
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|


Scenario: _032021 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 to 1
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032022 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 1 manual, Discount Price 2 - auto), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
	When change the priority Discount Price 1 from 1 to 3
	When change the manual setting of the Discount Price 1 discount.
	When create an order for Lomaniti Basic Partner terms, TRY (Dress and Boots)
	And in the table "ItemList" I click "% Offers" button
	And I go to line in "Offers" table
		| 'Presentation'                  |
		| 'Discount Price 1' |
	And I select current line in "Offers" table
	And I click "OK" button
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032023 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (Discount Price 2 manual, Discount Price 1 - auto), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032024 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 higher than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|

Scenario: _032025 check the discount order (same application rule), Discount Price 1 in the group Minimum, Discount Price 2 in the group Sum (manual), priority Discount Price 1 lower than Discount Price 2
	# Discounted Discount Price 1, and also discounted special offer from group Maximum Special Message Notification
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
	Then I wait that in user messages the "Message Notification" substring will appear in 10 seconds
	And "ItemList" table contains lines
		| 'Item'  | 'Price'  | 'Item key' | 'Store'    | 'Q'     | 'Offers amount' | 'Unit'|
		| 'Dress' | '520,00' | 'XS/Blue'  | 'Store 01' | '5,000' | '130,00'        | 'pcs' |
		| 'Boots' | '700,00' | '36/18SD'  | 'Store 01' | '1,000' | '100,00'        | 'pcs' |
	And I click "Post and close" button
	And Delay 2
	And "List" table contains lines
		| 'Partner'   | 'Σ'     |
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|
		| 'Lomaniti'  |  '3 070,00'|











