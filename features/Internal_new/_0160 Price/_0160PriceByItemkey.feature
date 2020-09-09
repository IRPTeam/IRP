#language: en
@tree
@Positive



Feature: item key pricing

As commercial director 
I want to fill in the prices
To sell and purchase goods and services


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _016001 base price fill (incl. VAT)
	* Preparation
		When Create catalog ItemTypes objects
		Then Create catalog Items objects
		Then Create catalog ItemKeys objects
			When Create catalog ItemKeys objects
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
		And I click "Post" button
		And I save the window as "$$PriceListBasicPriceByItemKey016001$$"
		And I save the value of the field named "Number" as "$$NumberPriceListBasicPriceByItemKey016001$$"
		And I click "Post and close" button
		And Delay 5
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number'                                       | 'Price list type'    | 'Price type'        | 'Description' |
		| '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Price by item keys' | 'Basic Price Types' | 'Basic price' |
		And I close all client application windows

Scenario: _016005 check movements of the price list document by item key in register Prices by item keys
	* Opening register Prices by item keys
		Given I open hyperlink "e1cib/list/InformationRegister.PricesByItemKeys"
	* Check Price list movements 
		And "List" table contains lines
		| 'Price'    | 'Recorder'                                     | 'Price type'        | 'Item key'  |
		| '550,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'S/Yellow'  |
		| '520,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'XS/Blue'   |
		| '520,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'M/White'   |
		| '550,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'L/Green'   |
		| '550,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'XL/Green'  |
		| '400,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '36/Yellow' |
		| '400,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '38/Yellow' |
		| '350,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '36/Red'    |
		| '350,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '38/Black'  |
		| '700,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '36/18SD'   |
		| '700,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '37/18SD'   |
		| '650,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '38/18SD'   |
		| '650,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '39/18SD'   |
		| '500,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '39/19SD'   |
		| '540,00'   | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | '37/19SD'   |
		| '3 000,00' | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'Dress/A-8' |
		| '5 000,00' | '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Basic Price Types' | 'Boots/S-8' |


Scenario: _016002 base price fill and special price fill (not incl. VAT)
	* Opening  price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item key Basic Price without VAT
		And I change "Set price" radio button value to "By Item keys"
		And I move to "Other" tab
		And I input "Basic Price without VAT" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Basic Price without VAT'  |
		And I select current line in "List" table
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
	* Posting document
		And I click "Post" button
		And I save the window as "$$PriceListBasicPriceByItemKey016002$$"
		And I save the value of the field named "Number" as "$$NumberPriceListBasicPriceByItemKey016002$$"
		And I click "Post and close" button
		And Delay 5
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number'                                       | 'Price list type'    | 'Price type'              | 'Description'             |
		| '$$NumberPriceListBasicPriceByItemKey016002$$' | 'Price by item keys' | 'Basic Price without VAT' | 'Basic Price without VAT' |
		And I close all client application windows
	

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
	* Check dependent prices calculation
		* Opening price list
			Given I open hyperlink "e1cib/list/Document.PriceList"
			And I click the button named "FormCreate"
		* Filling in the details of the price list by item key Discount Price TRY 1
			And I change "Set price" radio button value to "By Item keys"
			And I move to "Other" tab
			And I input "Dependent Price" text in "Description" field
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
	* Posting document
		And I click "Post" button
		And I save the window as "$$PriceListBasicPriceByItemKey016010$$"
		And I save the value of the field named "Number" as "$$NumberPriceListBasicPriceByItemKey016010$$"
		And I click "Post and close" button
		And Delay 5
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number'                                       | 'Price list type'    | 'Price type'      | 'Description'     |
		| '$$NumberPriceListBasicPriceByItemKey016010$$' | 'Price by item keys' | 'Dependent Price' | 'Dependent Price' |
		And I close all client application windows
	
Scenario: _016011 check price calculation in the documents
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		* Basic price type
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Basic Price Types' | '1,000' |
		* Basic Price without VAT
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '440,68' | 'XS/Blue'  | 'Basic Price without VAT' | '1,000' |
		* Dependent Price
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Dependent Price' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '572,00' | 'XS/Blue'  | 'Dependent Price' | '1,000' |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		* Basic price type
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Basic Price Types' | '1,000' |
		* Basic Price without VAT
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '440,68' | 'XS/Blue'  | 'Basic Price without VAT' | '1,000' |
		* Dependent Price
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Dependent Price' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '572,00' | 'XS/Blue'  | 'Dependent Price' | '1,000' |
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		* Basic price type
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Basic Price Types' | '1,000' |
		* Basic Price without VAT
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '440,68' | 'XS/Blue'  | 'Basic Price without VAT' | '1,000' |
		* Dependent Price
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Dependent Price' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '572,00' | 'XS/Blue'  | 'Dependent Price' | '1,000' |
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		* Basic price type
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '520,00' | 'XS/Blue'  | 'Basic Price Types' | '1,000' |
		* Basic Price without VAT
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price without VAT' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '440,68' | 'XS/Blue'  | 'Basic Price without VAT' | '1,000' |
		* Dependent Price
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Dependent Price' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key' | 'Price type'        | 'Q'     |
			| 'Dress' | '572,00' | 'XS/Blue'  | 'Dependent Price' | '1,000' |
		
	
