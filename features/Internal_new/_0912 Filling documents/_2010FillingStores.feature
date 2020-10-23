#language: en
@tree
@Positive
@FillingDocuments

Feature: filling of stores in documents




Background:
	Given I launch TestClient opening script or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one


Scenario: _201000 preparation ( filling stores)
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register UserSettings records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	

Scenario: _201001 check filling in Store field in the document Sales order
	* Open document form Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in Partner and Legal name
	# the other details are filled in from the custom settings
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I select from "Legal name" drop-down list by "comp" string
	* Filling in items tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "dre" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "xs" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "sh" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check filling in Sales order
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		And I click Choice button of the field named "Agreement"
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		Then the form attribute named "Status" became equal to "Approved"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Change store on Store 03 (not specified in agreement or settings)
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Cleaning the store value
		And I input "" text in the field named "Store"
		And I click "OK" button
	* Check filling in store from agreement
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Choosing an agreement with an empty store field
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron, USD' |
		And I select current line in "List" table
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
		And I close all client application windows

Scenario: _201002 check filling in Store field in the document Sales invoice
	* Open document form Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Filling in Partner and Legal name
	# the other details are filled in from the custom settings
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I select from "Legal name" drop-down list by "comp" string
	* Filling in items tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "dre" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "xs" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I select "sh" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check filling in Sales order
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Store" became equal to "Store 01"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Change store on Store 03 (not specified in agreement or settings)
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Cleaning the store value
		And I input "" text in the field named "Store"
		And I click "OK" button
	* Check filling in store from agreement
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
	* Choosing an agreement with an empty store field
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron, USD' |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 01' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 01' |
		And I close all client application windows

Scenario: _201003 check filling in Store field in the document Purchase order
	* Open document form Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in partner, legal name, partner term (store not specified)
	# the other details are filled in from the custom settings
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
	* Filling in items tab
		And I click the button named "Add"
		And I select "dre" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "xs" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I select "sh" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check filling in Purchase order
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Store" became equal to "Store 03"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Changing store on Store 02 (not specified in the partner terms or in the settings)
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
	* Cleaning the store value
		And I input "" text in the field named "Store"
		And I click "OK" button
	* Check filling in store from user settings (store not specified in agreement)
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
	* Re-selecting a partner term with an empty store and check filling in the store from user settings
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 03' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 03' |
		And I close all client application windows


Scenario: _201004 check filling in Store field in the document Purchase invoice
	* Open document form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in partner, legal name, partner term (store not specified)
	# the other details are filled in from the custom settings
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
	* Filling in items tab
		And I click the button named "Add"
		And I select "dre" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "xs" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I select "sh" from "Item" drop-down list by string in "ItemList" table
		And I activate "Item key" field in "ItemList" table
		And I select "36" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Check filling in Purchase order
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
	* Change of store on Store 04 (not specified either in the partner terms or in the settings)
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 04' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 04' |
	* Cleaning the store value
		And I input "" text in the field named "Store"
		And I click "OK" button
	* Check filling in store from user settings (store in partner term not specified)
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
	* Re-selecting a partner term with an empty store and check filling in the store from user settings
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Q'     | 'Store'    |
			| 'Dress' | 'XS/Blue'  | '2,000' | 'Store 02' |
			| 'Shirt' | '36/Red'   | '1,000' | 'Store 02' |
		And I close all client application windows


Scenario: _201005 check filling in Store field in the Shipment confirmation
	* Open a creation form Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click "Create" button
	* Fillin in store and items tab
		* Filling store and type of operation
			And I select "Sales" exact value from "Transaction type" drop-down list
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
			And I select current line in "List" table
		* Add first line with the product
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second line
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListStore" in "ItemList" table
			And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
			And I select current line in "List" table
		* Check filling in store by lines
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 02' |
		* Change the store in the header and check the refill by lines
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
			And I select current line in "List" table
			* Info message
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 03' |
		* Delete a line
			And I go to the last line in "ItemList" table
			And I delete current line in "ItemList" table
		* Check that the warehouse is not cleared on the lines with the products
			And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
			| 'Trousers' | '38/Yellow' | '2,000'    | 'Store 03' | 'pcs'  |
			And I activate field named "ItemListStore" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "" text in the field named "ItemListStore" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			And I input "" text in the field named "Store"
			Then "1C:Enterprise" window is opened
			And I click "No" button
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			And I close all client application windows


Scenario: _201006 check filling in Store field in the Goods receipt
	* Open a creation form Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click "Create" button
	* Fillin in store and items tab
		* Filling store and type of operation
			And I select "Purchase" exact value from "Transaction type" drop-down list
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
			And I select current line in "List" table
		* Adding the first line with the product
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "2,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Add second line
			And I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Description' |
			| 'Shirt'       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "1,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I select current line in "ItemList" table
			And I click choice button of the attribute named "ItemListStore" in "ItemList" table
			And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
			And I select current line in "List" table
		* Check filling in store by lines
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 02' |
		* Change the store in the header and check the refill by lines
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
			| 'Description' |
			| 'Store 03'    |
			And I select current line in "List" table
			* Info message
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			| 'Shirt'    | '1,000'    | '38/Black'  | 'pcs'  | 'Store 03' |
		* Delete a line
			And I go to the last line in "ItemList" table
			And I delete current line in "ItemList" table
		* Check that the warehouse is not cleared on the lines with the products
			And I go to line in "ItemList" table
			| 'Item'     | 'Item key'  | 'Quantity' | 'Store'    | 'Unit' |
			| 'Trousers' | '38/Yellow' | '2,000'    | 'Store 03' | 'pcs'  |
			And I activate field named "ItemListStore" in "ItemList" table
			And I select current line in "ItemList" table
			And I input "" text in the field named "ItemListStore" of "ItemList" table
			And I finish line editing in "ItemList" table
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			And I input "" text in the field named "Store"
			Then "1C:Enterprise" window is opened
			And I click "No" button
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    |
			| 'Trousers' | '2,000'    | '38/Yellow' | 'pcs'  | 'Store 03' |
			And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session