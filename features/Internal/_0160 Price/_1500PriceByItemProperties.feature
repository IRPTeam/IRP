#language: en
@tree
@Positive
@Price

Feature: check setting item prices for Item

As a sales manager.
I want to put a price on the Item and the properties
In order to have the same price applied to all item key of one Item, and also to be able to set prices for the properties of

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: _150000 preparation
	When set True value to the constant
	* Load info
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When  Create catalog Currencies objects
	* Select in Item type properties that will affect the price
		* For item type Clothes
			Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
			And I go to line in "List" table
				| Description     |
				| Clothes         |
			And I select current line in "List" table
			And I go to line in "AvailableAttributes" table
				| Attribute     |
				| Color         |
			And I set "Affect pricing" checkbox in "AvailableAttributes" table
			And I finish line editing in "AvailableAttributes" table
			And I go to line in "AvailableAttributes" table
				| Attribute     |
				| Size          |
			And I set "Affect pricing" checkbox in "AvailableAttributes" table
			And I finish line editing in "AvailableAttributes" table
			And I click "Save and close" button
			And Delay 5
		* For item type Shoes
			Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
			And I go to line in "List" table
				| Description     |
				| Shoes           |
			And I select current line in "List" table
			And I go to line in "AvailableAttributes" table
				| Attribute     |
				| Size          |
			And I set "Affect pricing" checkbox in "AvailableAttributes" table
			And I finish line editing in "AvailableAttributes" table
			And I click "Save and close" button
			And Delay 5
		And I close all client application windows

Scenario: _1500001 check preparation
	When check preparation

Scenario: _150001 basic price entry by properties (including VAT)
	* Create price list by property for item type Clothes
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in price list
		And I move to "Other" tab
		And I click the hyperlink named "Description"
		And I input "Basic price" text in the field named "Text"
		And I click "OK" button
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
	* Filling in tabular part
		And I change "Set price" radio button value to "By Properties"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Clothes        |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of "Item" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Size                   | L              |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Color                  | Green          |
		And I select current line in "List" table
		And I input "350,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of "Item" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Size                   | S              |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Color                  | Yellow         |
		And I select current line in "List" table
		And I input "300,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of "Item" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Description    |
			| Dress          |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Size                   | M              |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| Additional attribute   | Description    |
			| Color                  | Yellow         |
		And I select current line in "List" table
		And I input "415,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I click the button named "FormPost"
		And I delete "$$PriceListBasicPriceByProperties150001$$" variable
		And I delete "$$NumberPriceListBasicPriceByProperties150001$$" variable
		And I save the window as "$$PriceListBasicPriceByProperties150001$$"
		And I save the value of the field named "Number" as "$$NumberPriceListBasicPriceByProperties150001$$"
		And I click the button named "FormPostAndClose"
		And Delay 5
	* Check document saving
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And "List" table contains lines
		| 'Number'                                           | 'Price list type'      | 'Price type'         | 'Comment'   |
		| '$$NumberPriceListBasicPriceByProperties150001$$'  | 'Price by properties'  | 'Basic Price Types'  | 'Basic price'   |
		And I close all client application windows
	* Create Price key for Dress
		Given I open hyperlink "e1cib/list/Catalog.PriceKeys"
		And "List" table contains lines
			| 'Price key'    |
			| 'L/Green'      |
			| 'S/Yellow'     |
			| 'M/Yellow'     |
		* PriceKeys MD5 completion check
			And I go to line in "List" table
			| 'Price key'    |
			| 'S/Yellow'     |
			And I select current line in "List" table
			And field "Affect pricing MD5" is filled
		And I close all client application windows



Scenario: _150002 basic price entry by items (including VAT)
	Given I open hyperlink "e1cib/list/Document.PriceList"
	And I click the button named "FormCreate"
	* Filling in price list by item
		And I move to "Other" tab
		And I click the hyperlink named "Description"
		And I input "Basic price" text in the field named "Text"
		And I click "OK" button
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Basic Price Types'    |
		And I select current line in "List" table
		And I input begin of the current month date in "Date" field
	And I move to "Item keys" tab
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Dress'         |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "700,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Trousers'      |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "500,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Shirt'         |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "400,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Boots'         |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "6000,00" text in "Price" field of "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'      |
		| 'Boots (12 pcs)'   |
	And I select current line in "List" table	
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'High shoes'    |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "400,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'Boots'         |
	And I select current line in "List" table
	And I move to the next attribute
	And I input "700,00" text in "Price" field of "ItemList" table
	And I select current line in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description'   |
		| 'pcs'           |
	And I select current line in "List" table	
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$PriceListBasicPriceByItems150002$$" variable
	And I delete "$$NumberPriceListBasicPriceByItems150002$$" variable
	And I save the window as "$$PriceListBasicPriceByItems150002$$"
	And I save the value of the field named "Number" as "$$NumberPriceListBasicPriceByItems150002$$"
	And I click the button named "FormPostAndClose"
	And Delay 10


Scenario: _150003 check that the current prices are displayed in the Item
	* OPen item Dress
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
		| 'Description'   |
		| 'Dress'         |
		And I select current line in "List" table
	* Open price report (tab Price info)
		And In this window I click command interface button "Price info"
		Then "Result" spreadsheet document is equal by template
			| 'Prices on*'         | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| ''                   | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Item'               | 'Item Key'    | 'Basic Price Types'   | ''                            | 'Basic Price without VAT'   | ''                      | 'Dependent Price New'   | ''                             |
			| ''                   | ''            | 'Price'               | 'Reason'                      | 'Price'                     | 'Reason'                | 'Price'                 | 'Reason'                       |
			| 'Dress'              | 'S/Yellow'    | '550'                 | 'Item key = S/Yellow'         | '466,1'                     | 'Item key = S/Yellow'   | '605'                   | 'Item key = S/Yellow'          |
			| 'Dress'              | 'XS/Blue'     | '520'                 | 'Item key = XS/Blue'          | '440,68'                    | 'Item key = XS/Blue'    | '572'                   | 'Item key = XS/Blue'           |
			| 'Dress'              | 'M/White'     | '520'                 | 'Item key = M/White'          | '440,68'                    | 'Item key = M/White'    | '572'                   | 'Item key = M/White'           |
			| 'Dress'              | 'L/Green'     | '550'                 | 'Item key = L/Green'          | '466,1'                     | 'Item key = L/Green'    | '605'                   | 'Item key = L/Green'           |
			| 'Dress'              | 'XL/Green'    | '550'                 | 'Item key = XL/Green'         | '466,1'                     | 'Item key = XL/Green'   | '605'                   | 'Item key = XL/Green'          |
			| 'Dress'              | 'Dress/A-8'   | '3 000'               | 'Specification = Dress/A-8'   | ''                          | ''                      | '3 300'                 | 'Specification = Dress/A-8'    |
			| 'Dress'              | 'XXL/Red'     | '700'                 | 'Item = Dress'                | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'M/Brown'     | '700'                 | 'Item = Dress'                | ''                          | ''                      | ''                      | ''                             |
			| ''                   | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'All prices'         | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| ''                   | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Item'               | 'Item Key'    | 'Basic Price Types'   | ''                            | 'Basic Price without VAT'   | ''                      | 'Dependent Price New'   | ''                             |
			| ''                   | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| '1. By item keys'    | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'S/Yellow'    | '550'                 | ''                            | '466,1'                     | ''                      | '605'                   | ''                             |
			| 'Dress'              | 'XS/Blue'     | '520'                 | ''                            | '440,68'                    | ''                      | '572'                   | ''                             |
			| 'Dress'              | 'M/White'     | '520'                 | ''                            | '440,68'                    | ''                      | '572'                   | ''                             |
			| 'Dress'              | 'L/Green'     | '550'                 | ''                            | '466,1'                     | ''                      | '605'                   | ''                             |
			| 'Dress'              | 'XL/Green'    | '550'                 | ''                            | '466,1'                     | ''                      | '605'                   | ''                             |
			| '2. By properties'   | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'S/Yellow'    | '300'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'L/Green'     | '350'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| '3. By items'        | ''            | ''                    | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'S/Yellow'    | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'XS/Blue'     | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'M/White'     | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'L/Green'     | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'XL/Green'    | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'XXL/Red'     | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
			| 'Dress'              | 'M/Brown'     | '700'                 | ''                            | ''                          | ''                      | ''                      | ''                             |
		* Check to display the current prices at an earlier date
			And I input "12.12.2019" text in "on date" field
			And I click "Refresh" button
			Then "Result" spreadsheet document is equal by template
			| 'Prices on 12.12.2019'   | ''            | ''                    | ''                            | ''                          | ''                       |
			| ''                       | ''            | ''                    | ''                            | ''                          | ''                       |
			| 'Item'                   | 'Item Key'    | 'Basic Price Types'   | ''                            | 'Basic Price without VAT'   | ''                       |
			| ''                       | ''            | 'Price'               | 'Reason'                      | 'Price'                     | 'Reason'                 |
			| 'Dress'                  | 'S/Yellow'    | '550'                 | 'Item key = S/Yellow'         | '466,1'                     | 'Item key = S/Yellow'    |
			| 'Dress'                  | 'XS/Blue'     | '520'                 | 'Item key = XS/Blue'          | '440,68'                    | 'Item key = XS/Blue'     |
			| 'Dress'                  | 'M/White'     | '520'                 | 'Item key = M/White'          | '440,68'                    | 'Item key = M/White'     |
			| 'Dress'                  | 'L/Green'     | '550'                 | 'Item key = L/Green'          | '466,1'                     | 'Item key = L/Green'     |
			| 'Dress'                  | 'XL/Green'    | '550'                 | 'Item key = XL/Green'         | '466,1'                     | 'Item key = XL/Green'    |
			| 'Dress'                  | 'Dress/A-8'   | '3 000'               | 'Specification = Dress/A-8'   | ''                          | ''                       |
			| ''                       | ''            | ''                    | ''                            | ''                          | ''                       |
			| 'All prices'             | ''            | ''                    | ''                            | ''                          | ''                       |
			| ''                       | ''            | ''                    | ''                            | ''                          | ''                       |
			| 'Item'                   | 'Item Key'    | 'Basic Price Types'   | ''                            | 'Basic Price without VAT'   | ''                       |
			| ''                       | ''            | ''                    | ''                            | ''                          | ''                       |
			| '1. By item keys'        | ''            | ''                    | ''                            | ''                          | ''                       |
			| 'Dress'                  | 'S/Yellow'    | '550'                 | ''                            | '466,1'                     | ''                       |
			| 'Dress'                  | 'XS/Blue'     | '520'                 | ''                            | '440,68'                    | ''                       |
			| 'Dress'                  | 'M/White'     | '520'                 | ''                            | '440,68'                    | ''                       |
			| 'Dress'                  | 'L/Green'     | '550'                 | ''                            | '466,1'                     | ''                       |
			| 'Dress'                  | 'XL/Green'    | '550'                 | ''                            | '466,1'                     | ''                       |
			| '2. By properties'       | ''            | ''                    | ''                            | ''                          | ''                       |
			| '3. By items'            | ''            | ''                    | ''                            | ''                          | ''                       |






Scenario: _150004 check the price calculation according to the specification (based on the Item and properties price)
	* Unpost Basic Price list by item key
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
		| 'Description'  | 'Number'                                        | 'Price list type'      |
		| 'Basic price'  | '$$NumberPriceListBasicPriceByItemKey016001$$'  | 'Price by item keys'   |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key      |
				| Dress    | Dress/A-8     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'      | 'Item key'    | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '3 100,00'   | 'Dress/A-8'   | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key      |
				| Dress    | Dress/A-8     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'      | 'Item key'    | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '3 100,00'   | 'Dress/A-8'   | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key      |
				| Dress    | Dress/A-8     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'      | 'Item key'    | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '3 100,00'   | 'Dress/A-8'   | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key      |
				| Dress    | Dress/A-8     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'      | 'Item key'    | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '3 100,00'   | 'Dress/A-8'   | '1,000'      | 'pcs'     |
		And I close all client application windows


Scenario: _1500041 check price calculation in the documents (price by item, unit, Add button)
	* Unpost Basic Price list by item key
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
		| 'Description'  | 'Number'                                        | 'Price list type'      |
		| 'Basic price'  | '$$NumberPriceListBasicPriceByItemKey016001$$'  | 'Price by item keys'   |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And in the table "ItemList" I click "Add" button
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '36/18SD'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		* By pcs
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
				| 'Item'     | 'Price'     | 'Item key'    | 'Price type'           | 'Quantity'     |
				| 'Boots'    | '700,00'    | '36/18SD'     | 'Basic Price Types'    | '1,000'        |
		* By box
			And I activate "Unit" field in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'        |
				| 'Boots (12 pcs)'     |
			And I select current line in "List" table
			And "ItemList" table contains lines
				| 'Item'     | 'Price'       | 'Item key'    | 'Price type'           | 'Quantity'    | 'Unit'               |
				| 'Boots'    | '6 000,00'    | '36/18SD'     | 'Basic Price Types'    | '1,000'       | 'Boots (12 pcs)'     |
			And I close all client application windows




Scenario: _1500042 check price calculation in the documents (price by item, unit, scan barcode)
	* Unpost Basic Price list by item key
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
		| 'Description'  | 'Number'                                        | 'Price list type'      |
		| 'Basic price'  | '$$NumberPriceListBasicPriceByItemKey016001$$'  | 'Price by item keys'   |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close all client application windows
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling partner and agreement
			And I click Choice button of the field named "Partner"
			And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I activate field named "ItemListLineNumber" in "ItemList" table
		* Add item by barcode
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "4820024700016" text in the field named "Barcode"
			And I move to the next attribute
			And in the table "ItemList" I click the button named "SearchByBarcode"
			And I input "89089988989989" text in the field named "Barcode"
			And I move to the next attribute
		* Check
			And "ItemList" table became equal
				| 'Item key'    | 'Price type'           | 'Item'     | 'Quantity'    | 'Unit'              | 'Price'       | 'VAT'    | 'Net amount'    | 'Total amount'     |
				| '36/18SD'     | 'Basic Price Types'    | 'Boots'    | '1,000'       | 'pcs'               | '700,00'      | '18%'    | '593,22'        | '700,00'           |
				| '36/18SD'     | 'Basic Price Types'    | 'Boots'    | '1,000'       | 'Boots (12 pcs)'    | '6 000,00'    | '18%'    | '5 084,75'      | '6 000,00'         |
			And I close all client application windows



Scenario: _1500043 check the price calculation for the bandle (based on the properties price)
	* Unpost Basic Price list by item key
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I go to line in "List" table
		| 'Description'  | 'Number'                                        | 'Price list type'      |
		| 'Basic price'  | '$$NumberPriceListBasicPriceByItemKey016001$$'  | 'Price by item keys'   |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description           |
				| Bound Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item                 | Item key                          |
				| Bound Dress+Shirt    | Bound Dress+Shirt/Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'                | 'Price'      | 'Item key'                        | 'Quantity'   | 'Unit'    |
			| 'Bound Dress+Shirt'   | '1 100,00'   | 'Bound Dress+Shirt/Dress+Shirt'   | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description           |
				| Bound Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item                 | Item key                          |
				| Bound Dress+Shirt    | Bound Dress+Shirt/Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'                | 'Price'      | 'Item key'                        | 'Quantity'   | 'Unit'    |
			| 'Bound Dress+Shirt'   | '1 100,00'   | 'Bound Dress+Shirt/Dress+Shirt'   | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description           |
				| Bound Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item                 | Item key                          |
				| Bound Dress+Shirt    | Bound Dress+Shirt/Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'                | 'Price'      | 'Item key'                        | 'Quantity'   | 'Unit'    |
			| 'Bound Dress+Shirt'   | '1 100,00'   | 'Bound Dress+Shirt/Dress+Shirt'   | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description           |
				| Bound Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item                 | Item key                          |
				| Bound Dress+Shirt    | Bound Dress+Shirt/Dress+Shirt     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'                | 'Price'      | 'Item key'                        | 'Unit'    |
			| 'Bound Dress+Shirt'   | '1 100,00'   | 'Bound Dress+Shirt/Dress+Shirt'   | 'pcs'     |
		And I close all client application windows

Scenario: _150005 price check by properties
	* Price calculation in the Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key     |
				| Dress    | L/Green      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '350,00'   | 'L/Green'    | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key     |
				| Dress    | L/Green      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '350,00'   | 'L/Green'    | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key     |
				| Dress    | L/Green      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '350,00'   | 'L/Green'    | '1,000'      | 'pcs'     |
		And I close all client application windows
	* Price calculation in the Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Add item
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Dress           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key     |
				| Dress    | L/Green      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I activate "Price type" field in "ItemList" table
			And I click choice button of "Price type" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
		* Check price calculation
			And "ItemList" table contains lines
			| 'Item'    | 'Price'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Dress'   | '350,00'   | 'L/Green'    | '1,000'      | 'pcs'     |
		And I close all client application windows


Scenario: _150006 check the redrawing of columns in the price list for additional properties when re-selecting the type of items
	* Open Price list with price variant by properties
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
		And I change "Set price" radio button value to "By Properties"
	* Check the addition of properties for item type Clothes
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Clothes        |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And "PriceKeyList" table became equal
			| 'Item'   | 'Size'   | 'Color'   | 'Price'    |
			| ''       | ''       | ''        | ''         |
		And I click choice button of the attribute named "PriceKeyListItem" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Size'                   | 'M'              |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Color'                  | 'Brown'          |
		And I select current line in "List" table
		And I input "200,00" text in "Price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
	* Check the addition of properties for item type Clothes
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| Description    |
			| Shoes          |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And "PriceKeyList" table became equal
			| 'Item'   | 'Size'   | 'Price'    |
			| ''       | ''       | ''         |
	And I close all client application windows


Scenario: _150007 check input by line in the price list for additional properties
	And I close all client application windows
	* Open a creation form Price List
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Input additional properties by string 
		And I change "Set price" radio button value to "By Properties"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And I select "dress" by string from the drop-down list named "PriceKeyListItem" in "PriceKeyList" table
		And I activate "Size" field in "PriceKeyList" table
		And I select "36" from "Size" drop-down list by string in "PriceKeyList" table
		And I activate "Color" field in "PriceKeyList" table
		And I select "bla" from "Color" drop-down list by string in "PriceKeyList" table
	* Check entered values
		And "PriceKeyList" table contains lines
		| 'Item'   | 'Size'  | 'Color'   |
		| 'Dress'  | '36'    | 'Black'   |
	And I close all client application windows


Scenario: _150017 price calculation when change input price in the Price list (by item)	
	* Opening  price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in the details of the price list by item
		And I change "Set price" radio button value to "By Items"
		And I click the hyperlink named "Description"
		And I input "Basic price" text in the field named "Text"
		And I click "OK" button
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
	* Filling in prices by item key by price type Basic Price Types
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
	* Check Input unit
		And "ItemList" table contains lines
			| 'Input price'   | 'Item'    | 'Input unit'   | 'Price'    |
			| ''              | 'Dress'   | 'pcs'          | ''         |
	* Check Price calculation when change input price
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListInputUnit" in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I move to the next attribute
		And I activate field named "ItemListInputPrice" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "500,000" text in the field named "ItemListInputPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to the next attribute
		And "ItemList"  table contains lines
			| '#'   | 'Input price'   | 'Item'    | 'Input unit'          | 'Price'    |
			| '1'   | '500,00'        | 'Dress'   | 'box Dress (8 pcs)'   | '62,50'    |
		And I activate field named "ItemListInputPrice" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "600,000" text in the field named "ItemListInputPrice" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to the next attribute
		And "ItemList" table contains lines
			| '#'   | 'Input price'   | 'Item'    | 'Input unit'          | 'Price'    |
			| '1'   | '600,00'        | 'Dress'   | 'box Dress (8 pcs)'   | '75,00'    |
	* Check Price calculation when change Input unit
		And I activate field named "ItemListInputUnit" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListInputUnit" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| '#'   | 'Input price'   | 'Item'    | 'Input unit'   | 'Price'     |
			| '1'   | '600,00'        | 'Dress'   | 'pcs'          | '600,00'    |
	* Change Item
		And I click choice button of the attribute named "ItemListInputUnit" in "ItemList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I activate field named "ItemListItem" in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| '#'   | 'Input price'   | 'Item'    | 'Input unit'   | 'Price'     |
			| '1'   | '600,00'        | 'Boots'   | 'pcs'          | '600,00'    |
		And I close all client application windows


Scenario: _150018 price calculation when change input price in the Price list (by properties)	
	* Opening  price list
		Given I open hyperlink "e1cib/list/Document.PriceList"
		And I click the button named "FormCreate"
	* Filling in the details of the price list by properties
		And I change "Set price" radio button value to "By properties"
		And I click the hyperlink named "Description"
		And I input "Basic price" text in the field named "Text"
		And I click "OK" button
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
	* Filling in prices by item key by price type Basic Price Types
		And I click the button named "PriceKeyListAdd"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		And I click the button named "PriceKeyListAdd"
		And I click choice button of the attribute named "PriceKeyListItem" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Size" field in "PriceKeyList" table
		And I click choice button of "Size" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| 'Additional attribute'   | 'Code'   | 'Description'    |
			| 'Size'                   | '9'      | 'XS'             |
		And I select current line in "List" table
		And I activate "Color" field in "PriceKeyList" table
		And I click choice button of "Color" attribute in "PriceKeyList" table
		And I go to line in "List" table
			| 'Additional attribute'   | 'Code'   | 'Description'    |
			| 'Color'                  | '20'     | 'Blue'           |
		And I select current line in "List" table
	* Check Input unit
		And "PriceKeyList" table contains lines
			| 'Item'    | 'Input unit'   | 'Size'   | 'Color'   | 'Input price'   | 'Price'    |
			| 'Dress'   | 'pcs'          | 'XS'     | 'Blue'    | ''              | ''         |
	* Check Price calculation when change input price
		And I select current line in "PriceKeyList" table
		And I click choice button of the attribute named "PriceKeyListInputUnit" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I finish line editing in "PriceKeyList" table
		And I move to the next attribute
		And I activate field "Input price" in "PriceKeyList" table
		And I select current line in "PriceKeyList" table
		And I input "500,000" text in "Input price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I move to the next attribute
		And "PriceKeyList"  table contains lines
			| 'Item'    | 'Input unit'          | 'Size'   | 'Color'   | 'Input price'   | 'Price'    |
			| 'Dress'   | 'box Dress (8 pcs)'   | 'XS'     | 'Blue'    | '500,00'        | '62,50'    |
		And I activate field "Input price" in "PriceKeyList" table
		And I select current line in "PriceKeyList" table
		And I input "600,000" text in "Input price" field of "PriceKeyList" table
		And I finish line editing in "PriceKeyList" table
		And I move to the next attribute
		And "PriceKeyList" table contains lines
			| 'Item'    | 'Input unit'          | 'Size'   | 'Color'   | 'Input price'   | 'Price'    |
			| 'Dress'   | 'box Dress (8 pcs)'   | 'XS'     | 'Blue'    | '600,00'        | '75,00'    |
	* Check Price calculation when change Input unit
		And I activate field named "PriceKeyListInputUnit" in "PriceKeyList" table
		And I select current line in "PriceKeyList" table
		And I click choice button of the attribute named "PriceKeyListInputUnit" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I finish line editing in "PriceKeyList" table
		And "PriceKeyList" table contains lines
			| 'Item'    | 'Input unit'   | 'Size'   | 'Color'   | 'Input price'   | 'Price'     |
			| 'Dress'   | 'pcs'          | 'XS'     | 'Blue'    | '600,00'        | '600,00'    |
	* Change Item
		And I click choice button of the attribute named "PriceKeyListInputUnit" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'box Dress (8 pcs)'    |
		And I select current line in "List" table
		And I activate field named "PriceKeyListItem" in "PriceKeyList" table
		And I click choice button of the attribute named "PriceKeyListItem" in "PriceKeyList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And "PriceKeyList" table contains lines
			| 'Item'       | 'Input unit'   | 'Size'   | 'Color'   | 'Input price'   | 'Price'     |
			| 'Trousers'   | 'pcs'          | 'XS'     | 'Blue'    | '600,00'        | '600,00'    |
		And I close all client application windows

		
