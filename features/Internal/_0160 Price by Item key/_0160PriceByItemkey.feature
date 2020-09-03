#language: en
@tree
@Positive
@Group2


Feature: item key pricing

As commercial director 
I want to fill in the prices
To sell and purchase goods and services


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _016001 base price fill (incl. VAT)
	* Opening  price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item key
		And I change "Set price" radio button value to "By Item keys"
		And I move to "Other" tab
		And I input "Basic price" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Basic Price Types'  |
		And I select current line in "List" table
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "100" text in "Number" field
		And I input "01.11.2018  12:32:21" text in "Date" field
	* Filling in prices by item key by price type Basic Price Types
		And I move to "Item keys" tab
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I move to the next attribute
		And I input "550,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "520,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "520,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "550,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green' |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "550,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "400,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '38/Yellow' |
		And I select current line in "List" table
		And I input "400,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "350,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black' |
		And I select current line in "List" table
		And I move to the next attribute
		And I input "350,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "700,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I input "700,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I input "650,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "650,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "500,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/19SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "540,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post" button
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Boots/S-8'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "5 000,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Dress/A-8'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "3 000,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
	* Posting document
		And I click "Post and close" button
		And Delay 10
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number' | 'Price list type'     | 'Price type'                 | 'Description' | 'Reference'       |
		| '100'    | 'Price by item keys'  | 'Basic Price Types'          | 'Basic price' | 'Price list 100*' |
		And I close all client application windows

Scenario: _016005 check movements of the price list document by item key in register Prices by item keys
	* Opening register Prices by item keys
		Given I open hyperlink "e1cib/list/InformationRegister.PricesByItemKeys"
	* Check Price list 100 movements 
		And "List" table contains lines
		| 'Price'    | 'Recorder'                                 | 'Price type'        | 'Item key'  |
		| '550,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'S/Yellow'  |
		| '520,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'XS/Blue'   |
		| '520,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'M/White'   |
		| '550,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'L/Green'   |
		| '550,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'XL/Green'  |
		| '400,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '36/Yellow' |
		| '400,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '38/Yellow' |
		| '350,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '36/Red'    |
		| '350,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '38/Black'  |
		| '700,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '36/18SD'   |
		| '700,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '37/18SD'   |
		| '650,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '38/18SD'   |
		| '650,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '39/18SD'   |
		| '500,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '39/19SD'   |
		| '540,00'   | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | '37/19SD'   |
		| '3 000,00' | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'Dress/A-8' |
		| '5 000,00' | 'Price list 100 dated 01.11.2018 12:32:21' | 'Basic Price Types' | 'Boots/S-8' |


Scenario: _016002 base price fill and special price fill (not incl. VAT)
	* Opening  price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item key Basic Price without VAT
		And I change "Set price" radio button value to "By Item keys"
		And I move to "Other" tab
		And I input "Basic price" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Basic Price without VAT'  |
		And I select current line in "List" table
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "103" text in "Number" field
		And I input "01.11.2018  12:32:21" text in "Date" field
		And I move to "Item keys" tab
	* Filling in prices by item key by price type Basic Price without VAT
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "466,10" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I input "440,68" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "440,68" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I input "466,10" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green' |
		And I select current line in "List" table
		And I input "466,10" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "338,98" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '38/Yellow' |
		And I select current line in "List" table
		And I input "338,98" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		Then "Item keys" window is opened
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "296,61" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black' |
		And I select current line in "List" table
		And I input "296,61" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "648,15" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I input "648,15" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I input "601,85" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "601,85" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "462,96" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/19SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "648,15" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post and close" button
		And Delay 10
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item key Discount 1 TRY without VAT
		And I change "Set price" radio button value to "By Item keys"
		And I move to "Other" tab
		And I input "Basic price" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Discount 1 TRY without VAT'  |
		And I select current line in "List" table
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "104" text in "Number" field
		And I input "01.11.2018  12:32:21" text in "Date" field
	* Filling in prices by item key by price type Discount 1 TRY without VAT
		And I move to "Item keys" tab
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I move to the next attribute
		And I input "442,80" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I input "418,65" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "418,65" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I input "442,80" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green' |
		And I select current line in "List" table
		And I input "442,80" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "271,18" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '38/Yellow' |
		And I select current line in "List" table
		And I input "271,18" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "237,29" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black' |
		And I select current line in "List" table
		And I input "237,29" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "615,74" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I input "615,74" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I input "571,75" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post and close" button
		And Delay 10
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item key Discount 2 TRY without VAT
		And I change "Set price" radio button value to "By Item keys"
		And I move to "Other" tab
		And I input "Basic price" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Discount 2 TRY without VAT'  |
		And I select current line in "List" table
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "105" text in "Number" field
		And I input "01.11.2018  12:32:21" text in "Date" field
	* Filling in prices by item key by price type Discount 2 TRY without VAT
		And I move to "Item keys" tab
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "349,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I input "330,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "330,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I input "350,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green' |
		And I select current line in "List" table
		And I input "350,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "240,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '38/Yellow' |
		And I select current line in "List" table
		And I input "240,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		Then "Item keys" window is opened
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "207,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black' |
		And I select current line in "List" table
		And I input "207,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "583,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I input "583,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I input "540,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post and close" button
		And Delay 10
	* Save verification
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number' | 'Price list type'     | 'Price type'                 | 'Reference'       |
		| '103'    | 'Price by item keys'  | 'Basic Price without VAT'    | 'Price list 103*' |
		| '104'    | 'Price by item keys'  | 'Discount 1 TRY without VAT' | 'Price list 104*' |
		| '105'    | 'Price by item keys'  | 'Discount 2 TRY without VAT' | 'Price list 105*' |


Scenario: _016003 Discount Price TRY 1 fill and Discount Price TRY 2 fill
	* Opening  price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item key Discount Price TRY 1
		And I change "Set price" radio button value to "By Item keys"
		And I move to "Other" tab
		And I input "Basic price" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Discount Price TRY 1'  |
		And I select current line in "List" table
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "101" text in "Number" field
		And I input "03.11.2018  10:24:21" text in "Date" field
	* Filling in prices by item key by price type Discount Price TRY 1
		And I move to "Item keys" tab
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "522,50" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I input "494,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "494,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I input "522,50" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green' |
		And I select current line in "List" table
		And I input "522,50" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "320,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '38/Yellow' |
		And I select current line in "List" table
		And I input "320,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		Then "Item keys" window is opened
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "280,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black' |
		And I select current line in "List" table
		And I input "280,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "600,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I input "600,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I input "250,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post and close" button
		And Delay 10
	* Filling in the details of the price list by item key Discount Price TRY 2
		And I click the button named "FormCreate"
		* Filling in price list info by item key
			And I change "Set price" radio button value to "By Item keys"
			And I move to "Other" tab
			And I input "Basic price" text in "Description" field
			And I click Select button of "Price type" field
			And I go to line in "List" table
					| 'Description' |
					| 'Discount Price TRY 2'  |
			And I select current line in "List" table
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "102" text in "Number" field
			And I input "05.11.2018  10:24:21" text in "Date" field
	* Filling in prices by item key by price type Discount Price TRY 2
		And I move to "Item keys" tab
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "411,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I input "389,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I input "389,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'L/Green'  |
		And I select current line in "List" table
		And I input "413,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green' |
		And I select current line in "List" table
		And I input "413,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I select current line in "List" table
		And I input "283,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '38/Yellow' |
		And I select current line in "List" table
		And I input "283,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		Then "Item keys" window is opened
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "244,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black' |
		And I select current line in "List" table
		And I input "244,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Price" field in "ItemKeyList" table
		And I input "550,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I input "550,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click the button named "ItemKeyListAdd"
		And I click choice button of "Item" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemKeyList" table
		And I click choice button of "Item key" attribute in "ItemKeyList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I input "240,00" text in "Price" field of "ItemKeyList" table
		And I finish line editing in "ItemKeyList" table
		And I click "Post and close" button
		And Delay 10
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number' | 'Price list type'     | 'Price type'                 | 'Reference'       |
		| '101'    | 'Price by item keys'  | 'Discount Price TRY 1'       | 'Price list 101*' |
		| '102'    | 'Price by item keys'  | 'Discount Price TRY 2'       | 'Price list 102*' |

Scenario: _016010 check dependent prices calculation
	* Adding Plugin sessing
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		And I click the button named "FormCreate"
		And I select external file "#workingDir#\DataProcessor\SalesPriceCalculation.epf"
		And I click the button named "FormAddExtDataProc"
		And I input "" text in "Path to plugin for test" field
		And I input "SalesPriceCalculation" text in "Name" field
		And I click Open button of the field named "Description_en"
		And I input "SalesPriceCalculation" text in the field named "Description_en"
		And I input "SalesPriceCalculation" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I wait "Plugins (create)" window closing in 10 seconds
	* Creating price type that will use external processing
		Given I open hyperlink "e1cib/list/Catalog.PriceTypes"	
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Dependent Price" text in the field named "Description_en"
		And I input "Dependent Price TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code |
			| TRY  |
		And I select current line in "List" table
	* Adding external processing to the price type and filling in the settings
		And I click Select button of "Plugins" field
		And I go to line in "List" table
			| 'Description'         |
			| 'SalesPriceCalculation' |
		And I select current line in "List" table
		And I click "Settings" button
		And in the table "PriceTypes" I click the button named "PriceTypesAdd"
		And I click choice button of "Purchase price type" attribute in "PriceTypes" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Basic Price Types' |
		And I select current line in "List" table
		And I activate "Сalculation formula for sales price" field in "PriceTypes" table
		And I input "SalesPrice=PurchasePrice + (PurchasePrice /100 * 10)" text in "Сalculation formula for sales price" field of "PriceTypes" table
		And I finish line editing in "PriceTypes" table
		And I click "Ok" button
		And I click "Save and close" button
		And I wait "Dependent Price (Price type) *" window closing in 20 seconds
	* Check dependent prices calculation
		* Opening price list
			Given I open hyperlink "e1cib/list/Document.PriceList"
			And I click the button named "FormCreate"
		* Filling in the details of the price list by item key Discount Price TRY 1
			And I change "Set price" radio button value to "By Item keys"
			And I move to "Other" tab
			And I input "Basic price" text in "Description" field
			And I click Select button of "Price type" field
			And I go to line in "List" table
					| 'Description' |
					| 'Dependent Price'  |
			And I select current line in "List" table
		* Filling in price list
			And I click "Fill by rules" button
			And Delay 2
			And I change "PriceListType" radio button value to "By Item keys"
			And I change "Use" checkbox in "PriceTypes" table
			And I finish line editing in "PriceTypes" table
			And I click "Ok" button
		* Check filling in
			And "ItemKeyList" table contains lines
			| 'Item'       | 'Price'    | 'Item key'  |
			| 'Dress'      | '605,00'   | 'S/Yellow'  |
			| 'Dress'      | '572,00'   | 'XS/Blue'   |
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "200" text in "Number" field
		And I click "Post and close" button