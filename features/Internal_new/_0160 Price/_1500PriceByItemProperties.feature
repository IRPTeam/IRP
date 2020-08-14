#language: en
@tree
@Positive


Feature: check setting item prices for Item

As a sales manager.
I want to put a price on the Item and the properties
In order to have the same price applied to all item key of one Item, and also to be able to set prices for the properties of

Background:
	Given I launch TestClient opening script or connect the existing one


//дописать на проверку проводок + проверка цены по айтем в документах

Scenario: _150000 preparation
	* Select in Item type properties that will affect the price
		* For item type Clothes
			Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
			And I go to line in "List" table
				| Description |
				| Clothes     |
			And I select current line in "List" table
			And I go to line in "AvailableAttributes" table
				| Attribute |
				| Color     |
			And I set "Affect pricing" checkbox in "AvailableAttributes" table
			And I finish line editing in "AvailableAttributes" table
			And I go to line in "AvailableAttributes" table
				| Attribute |
				| Size      |
			And I set "Affect pricing" checkbox in "AvailableAttributes" table
			And I finish line editing in "AvailableAttributes" table
			And I click "Save and close" button
			And Delay 5
		* For item type Shoes
			Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
			And I go to line in "List" table
				| Description |
				| Shoes     |
			And I select current line in "List" table
			And I go to line in "AvailableAttributes" table
				| Attribute |
				| Size      |
			And I set "Affect pricing" checkbox in "AvailableAttributes" table
			And I finish line editing in "AvailableAttributes" table
			And I click "Save and close" button
			And Delay 5
		And I close all client application windows


Scenario: _150001 basic price entry by properties (including VAT)
	* Create price list by property for item type Clothes
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in price list
		And I move to "Other" tab
		And I input "Basic price" text in "Description" field
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description' |
				| 'Basic Price Types'  |
		And I select current line in "List" table
	* Filling in tabular part
		And I change "Set price" radio button value to "By Properties"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description |
			| Clothes     |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of "Item" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute | Description |
			| Size          | L           |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute | Description |
			| Color         | Green       |
		And I select current line in "List" table
		And I input "350,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of "Item" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute | Description |
			| Size          | S           |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute | Description |
			| Color         | Yellow       |
		And I select current line in "List" table
		And I input "300,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of "Item" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute | Description |
			| Size          | M           |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute | Description |
			| Color         | Yellow       |
		And I select current line in "List" table
		And I input "415,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then "Price list (create) *" window is opened
		And I input "107" text in "Number" field
		And I input begin of the current month date in "Date" field
		And I click "Post and close" button
		And Delay 5
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number'                                       | 'Price list type'    | 'Price type'        | 'Description' |
		| '$$NumberPriceListBasicPriceByItemKey016001$$' | 'Price by item keys' | 'Basic Price Types' | 'Basic price' |
		And I close all client application windows
	* Create Price key for Dress
		Given I open hyperlink "e1cib/list/Catalog.PriceKeys"
		And "List" table contains lines
			| 'Price key'|
			| 'L/Green'  |
			| 'S/Yellow' |
			| 'M/Yellow' |
		* PriceKeys MD5 completion check
			And I go to line in "List" table
			| 'Price key'|
			| 'S/Yellow' |
			And I select current line in "List" table
			And field "Affect pricing MD5" is filled
		And I close all client application windows



Scenario: _150002 basic price entry by items (including VAT)
	Given I open hyperlink "e1cib/list/Document.PriceList"
	And I click the button named "FormCreate"
	* Filling in price list by item key
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
		Then "Price list (create) *" window is opened
		And I input "110" text in "Number" field
		And I input begin of the current month date in "Date" field
	And I move to "Item keys" tab
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "700,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Trousers'       |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "500,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Shirt'       |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "400,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Boots'       |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "600,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'High shoes'       |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "400,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click "Post and close" button
	And Delay 10


Scenario: _150003 check that the current prices are displayed in the Item
	* OPen item Dress
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
		And I select current line in "List" table
	* Open price report (tab Price info)
		And In this window I click command interface button "Price info"
		Then "Result" spreadsheet document is equal by template
			| 'Prices on*'           | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     | 'Dependent Price' | ''                        |
			| ''                     | ''          | 'Price'             | 'Reason'                  | 'Price'                | 'Reason'               | 'Price'                | 'Reason'               | 'Price'                   | 'Reason'               | 'Price'                      | 'Reason'               | 'Price'                      | 'Reason'               | 'Price'           | 'Reason'                  |
			| 'Dress'                | 'S/Yellow'  | '550'               | 'Item key =  S/Yellow'    | '522,5'                | 'Item key =  S/Yellow' | '411'                  | 'Item key =  S/Yellow' | '466,1'                   | 'Item key =  S/Yellow' | '442,8'                      | 'Item key =  S/Yellow' | '349'                        | 'Item key =  S/Yellow' | '605'             | 'Item key =  S/Yellow'    |
			| 'Dress'                | 'XS/Blue'   | '520'               | 'Item key =  XS/Blue'     | '494'                  | 'Item key =  XS/Blue'  | '389'                  | 'Item key =  XS/Blue'  | '440,68'                  | 'Item key =  XS/Blue'  | '418,65'                     | 'Item key =  XS/Blue'  | '330'                        | 'Item key =  XS/Blue'  | '572'             | 'Item key =  XS/Blue'     |
			| 'Dress'                | 'M/White'   | '520'               | 'Item key =  M/White'     | '494'                  | 'Item key =  M/White'  | '389'                  | 'Item key =  M/White'  | '440,68'                  | 'Item key =  M/White'  | '418,65'                     | 'Item key =  M/White'  | '330'                        | 'Item key =  M/White'  | '572'             | 'Item key =  M/White'     |
			| 'Dress'                | 'L/Green'   | '550'               | 'Item key =  L/Green'     | '522,5'                | 'Item key =  L/Green'  | '413'                  | 'Item key =  L/Green'  | '466,1'                   | 'Item key =  L/Green'  | '442,8'                      | 'Item key =  L/Green'  | '350'                        | 'Item key =  L/Green'  | '605'             | 'Item key =  L/Green'     |
			| 'Dress'                | 'XL/Green'  | '550'               | 'Item key =  XL/Green'    | '522,5'                | 'Item key =  XL/Green' | '413'                  | 'Item key =  XL/Green' | '466,1'                   | 'Item key =  XL/Green' | '442,8'                      | 'Item key =  XL/Green' | '350'                        | 'Item key =  XL/Green' | '605'             | 'Item key =  XL/Green'    |
			| 'Dress'                | 'Dress/A-8' | '3 000'             | 'Specification Dress/A-8' | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    | '3 300'           | 'Specification Dress/A-8' |
			| 'Dress'                | 'XXL/Red'   | '700'               | 'Item =  Dress'           | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    | ''                | ' '                       |
			| 'Dress'                | 'M/Brown'   | '500'               | 'Item key =  M/Brown'     | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    | ''                | ' '                       |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'All prices'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     | 'Dependent Price' | ''                        |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| '1. By item keys'      | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'S/Yellow'  | '550'               | ''                        | '522,5'                | ''                     | '411'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '349'                        | ''                     | '605'             | ''                        |
			| 'Dress'                | 'XS/Blue'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     | '572'             | ''                        |
			| 'Dress'                | 'M/White'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     | '572'             | ''                        |
			| 'Dress'                | 'L/Green'   | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     | '605'             | ''                        |
			| 'Dress'                | 'XL/Green'  | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     | '605'             | ''                        |
			| 'Dress'                | 'M/Brown'   | '500'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| '2. By properties'     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'S/Yellow'  | '300'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'L/Green'   | '350'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| '3. By items'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'S/Yellow'  | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'XS/Blue'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'M/White'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'L/Green'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'XL/Green'  | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'XXL/Red'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
			| 'Dress'                | 'M/Brown'   | '700'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     | ''                | ''                        |
		* Check to display the current prices at an earlier date
			And I input "12.12.2019" text in "on date" field
			And I click "Refresh" button
			Then "Result" spreadsheet document is equal by template
			| 'Prices on 12.12.2019' | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     |
			| ''                     | ''          | 'Price'             | 'Reason'                  | 'Price'                | 'Reason'               | 'Price'                | 'Reason'               | 'Price'                   | 'Reason'               | 'Price'                      | 'Reason'               | 'Price'                      | 'Reason'               |
			| 'Dress'                | 'S/Yellow'  | '550'               | 'Item key =  S/Yellow'    | '522,5'                | 'Item key =  S/Yellow' | '411'                  | 'Item key =  S/Yellow' | '466,1'                   | 'Item key =  S/Yellow' | '442,8'                      | 'Item key =  S/Yellow' | '349'                        | 'Item key =  S/Yellow' |
			| 'Dress'                | 'XS/Blue'   | '520'               | 'Item key =  XS/Blue'     | '494'                  | 'Item key =  XS/Blue'  | '389'                  | 'Item key =  XS/Blue'  | '440,68'                  | 'Item key =  XS/Blue'  | '418,65'                     | 'Item key =  XS/Blue'  | '330'                        | 'Item key =  XS/Blue'  |
			| 'Dress'                | 'M/White'   | '520'               | 'Item key =  M/White'     | '494'                  | 'Item key =  M/White'  | '389'                  | 'Item key =  M/White'  | '440,68'                  | 'Item key =  M/White'  | '418,65'                     | 'Item key =  M/White'  | '330'                        | 'Item key =  M/White'  |
			| 'Dress'                | 'L/Green'   | '550'               | 'Item key =  L/Green'     | '522,5'                | 'Item key =  L/Green'  | '413'                  | 'Item key =  L/Green'  | '466,1'                   | 'Item key =  L/Green'  | '442,8'                      | 'Item key =  L/Green'  | '350'                        | 'Item key =  L/Green'  |
			| 'Dress'                | 'XL/Green'  | '550'               | 'Item key =  XL/Green'    | '522,5'                | 'Item key =  XL/Green' | '413'                  | 'Item key =  XL/Green' | '466,1'                   | 'Item key =  XL/Green' | '442,8'                      | 'Item key =  XL/Green' | '350'                        | 'Item key =  XL/Green' |
			| 'Dress'                | 'Dress/A-8' | '3 000'             | 'Specification Dress/A-8' | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    |
			| 'Dress'                | 'M/Brown'   | '500'               | 'Item key =  M/Brown'     | ''                     | ' '                    | ''                     | ' '                    | ''                        | ' '                    | ''                           | ' '                    | ''                           | ' '                    |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'All prices'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'Item'                 | 'Item Key'   | 'Basic Price Types' | ''                        | 'Discount Price TRY 1' | ''                     | 'Discount Price TRY 2' | ''                     | 'Basic Price without VAT' | ''                     | 'Discount 1 TRY without VAT' | ''                     | 'Discount 2 TRY without VAT' | ''                     |
			| ''                     | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| '1. By item keys'      | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| 'Dress'                | 'S/Yellow'  | '550'               | ''                        | '522,5'                | ''                     | '411'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '349'                        | ''                     |
			| 'Dress'                | 'XS/Blue'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     |
			| 'Dress'                | 'M/White'   | '520'               | ''                        | '494'                  | ''                     | '389'                  | ''                     | '440,68'                  | ''                     | '418,65'                     | ''                     | '330'                        | ''                     |
			| 'Dress'                | 'L/Green'   | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     |
			| 'Dress'                | 'XL/Green'  | '550'               | ''                        | '522,5'                | ''                     | '413'                  | ''                     | '466,1'                   | ''                     | '442,8'                      | ''                     | '350'                        | ''                     |
			| 'Dress'                | 'M/Brown'   | '500'               | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| '2. By properties'    | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |
			| '3. By items'          | ''          | ''                  | ''                        | ''                     | ''                     | ''                     | ''                     | ''                        | ''                     | ''                           | ''                     | ''                           | ''                     |





Scenario: _150004 check the price calculation according to the specification (based on the Item and properties price)
	* Unpost Basic Price list by item key
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
		| 'Description' | 'Number'                                          | 'Price list type'    |
		| 'Basic price' | '$$NumberPriceListBasicPriceByItemKey016001$$'    | 'Price by item keys' |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item  | Item key  |
				| Dress | Dress/A-8 |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key'  | 'Store'    | 'Q'     | 'Unit' |
			| 'Dress' | '3 100,00' | 'Dress/A-8' | 'Store 01' | '1,000' | 'pcs'  |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item  | Item key  |
				| Dress | Dress/A-8 |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key'  | 'Store'    | 'Q'     | 'Unit' |
			| 'Dress' | '3 100,00' | 'Dress/A-8' | 'Store 01' | '1,000' | 'pcs'  |
		And I close all client application windows
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Add item
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item  | Item key  |
				| Dress | Dress/A-8 |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key'  | 'Store'    | 'Q'     | 'Unit' |
			| 'Dress' | '3 100,00' | 'Dress/A-8' | 'Store 01' | '1,000' | 'pcs'  |
		And I close all client application windows
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Add item
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item  | Item key  |
				| Dress | Dress/A-8 |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'    | 'Item key'  | 'Store'    | 'Q'     | 'Unit' |
			| 'Dress' | '3 100,00' | 'Dress/A-8' | 'Store 01' | '1,000' | 'pcs'  |
		And I close all client application windows


Scenario: _150004 check the price calculation for the bandle (based on the properties price)
	* Unpost Basic Price list by item key
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
		| 'Description' | 'Number'                                          | 'Price list type'    |
		| 'Basic price' | '$$NumberPriceListBasicPriceByItemKey016001$$'    | 'Price by item keys' |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Bound Dress+Shirt       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item              | Item key  |
				| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'              | 'Price'    | 'Item key'                      | 'Store'    | 'Q'     | 'Unit'  |
			| 'Bound Dress+Shirt' | '1 100,00' | 'Bound Dress+Shirt/Dress+Shirt' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Bound Dress+Shirt       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item              | Item key  |
				| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'              | 'Price'    | 'Item key'                      | 'Store'    | 'Q'     | 'Unit'  |
			| 'Bound Dress+Shirt' | '1 100,00' | 'Bound Dress+Shirt/Dress+Shirt' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Add item
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Bound Dress+Shirt       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item              | Item key  |
				| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'              | 'Price'    | 'Item key'                      | 'Store'    | 'Q'     | 'Unit'  |
			| 'Bound Dress+Shirt' | '1 100,00' | 'Bound Dress+Shirt/Dress+Shirt' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Add item
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Bound Dress+Shirt       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item              | Item key  |
				| Bound Dress+Shirt | Bound Dress+Shirt/Dress+Shirt |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'              | 'Price'    | 'Item key'                      | 'Store'    | 'Q'     | 'Unit'  |
			| 'Bound Dress+Shirt' | '1 100,00' | 'Bound Dress+Shirt/Dress+Shirt' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows

Scenario: _150005 price check by properties
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key  |
				| Dress    | L/Green |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key'| 'Store'    | 'Q'     | 'Unit'  |
			| 'Dress' | '350,00' | 'L/Green' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key  |
				| Dress    | L/Green |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key'| 'Store'    | 'Q'     | 'Unit'  |
			| 'Dress' | '350,00' | 'L/Green' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Add item
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key  |
				| Dress    | L/Green |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key'| 'Store'    | 'Q'     | 'Unit'  |
			| 'Dress' | '350,00' | 'L/Green' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Add item
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key  |
				| Dress    | L/Green |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'Basic Price Types' |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'  | 'Price'  | 'Item key'| 'Store'    | 'Q'     | 'Unit'  |
			| 'Dress' | '350,00' | 'L/Green' | 'Store 01' | '1,000' |  'pcs'  |
		And I close all client application windows


Scenario: _150006 check the redrawing of columns in the price list for additional properties when re-selecting the type of items
	* Open Price list with price variant by properties
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		And I change "Set price" radio button value to "By Properties"
	* Check the addition of properties for item type Clothes
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description |
			| Clothes     |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And "PriceKeyList" table became equal
			| 'Item' | 'Size' | 'Color' | 'Price' |
			| ''     | ''     | ''      | ''      |
		And I click choice button of the attribute named "PriceKeyListItem" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Size'          | 'M'           |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| 'Additional attribute' | 'Description' |
			| 'Color'         | 'Brown'       |
		And I select current line in "List" table
		And I input "200,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
	* Check the addition of properties for item type Clothes
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description |
			| Shoes     |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And "PriceKeyList" table became equal
			| 'Item' | 'Size' | 'Price' |
			| ''     | ''     | ''      |
	And I close all client application windows


Scenario: check input by line in the price list for additional properties
	And I close all client application windows
	* Open a creation form Price List
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Input additional properties by string 
		And I change "Set price" radio button value to "By Properties"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And I select "dress" by string from the drop-down list named "PriceKeyListItem" in "PriceKeyList" table
		And I activate "Size" field in "PriceKeyList" table
		And I select "36" from "Size" drop-down list by string in "PriceKeyList" table
		And I activate "Color" field in "PriceKeyList" table
		And I select "bla" from "Color" drop-down list by string in "PriceKeyList" table
	* Check entered values
		And "PriceKeyList" table contains lines
		| 'Item'  | 'Size' | 'Color' |
		| 'Dress' | '36'   | 'Black' |
	And I close all client application windows
