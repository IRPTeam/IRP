#language: en
@tree
@Positive
@Discount

Feature: check discounts in purchase documents Purchase order/Purchase invoice

As a developer
I want to add discount functionality to the purchase documents
So you can display the amount of the vendor's discount

Background:
	Given I launch TestClient opening script or connect the existing one
# discount for document

Scenario: check the Document discount in Purchase order
	* Activating discount Document discount
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Document discount' |
		And I select current line in "List" table
		And I set checkbox "Launch"
		And I click "Save and close" button
	* Create Purchase order
		* Open a form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in the necessary details
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'M/White' | 'pcs' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "100" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '2' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "200" text in "Q" field of "ItemList" table
			And I input "210" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'     | 'Item key' | 'Unit' |
				| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
			And I select current line in "ItemList" table
			And I input "300" text in "Q" field of "ItemList" table
			And I input "250" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
	* Calculate Document discount for Purchase order
		And I click "% Offers" button
		And I select current line in "Offers" table
		And I input "10,00" text in "Percent" field
		And I click "Ok" button
		And in the table "Offers" I click "OK" button
	* Check the discount calculation
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'       | 'Offers amount' | 'Unit' | 'Total amount' | 'Store'    |
		| 'Dress'    | '200,00' | 'M/White'   | '100,000' | '2 000,00'      | 'pcs'  | '18 000,00'    | 'Store 01' |
		| 'Dress'    | '210,00' | 'L/Green'   | '200,000' | '4 200,00'      | 'pcs'  | '37 800,00'    | 'Store 01' |
		| 'Trousers' | '250,00' | '36/Yellow' | '300,000' | '7 500,00'      | 'pcs'  | '67 500,00'    | 'Store 01' |
	* Check the transfer of the discount value from Purchase order to Purchase invoice when creating based on
		And I click the button named "FormPost"
		And I click "Purchase invoice" button
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'       | 'Offers amount' | 'Unit' | 'Total amount' | 'Store'    |
		| 'Dress'    | '200,00' | 'M/White'   | '100,000' | '2 000,00'      | 'pcs'  | '18 000,00'    | 'Store 01' |
		| 'Dress'    | '210,00' | 'L/Green'   | '200,000' | '4 200,00'      | 'pcs'  | '37 800,00'    | 'Store 01' |
		| 'Trousers' | '250,00' | '36/Yellow' | '300,000' | '7 500,00'      | 'pcs'  | '67 500,00'    | 'Store 01' |
		And I close all client application windows

Scenario: check the Document discount in Purchase invoice
	* Activating discount Document discount
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Document discount' |
		And I select current line in "List" table
		And I set checkbox "Launch"
		And I click "Save and close" button
	* Create Purchase invoice
		* Open form for creating Purchase invoice
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'M/White'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'M/White' | 'pcs' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "100" text in "Q" field of "ItemList" table
			And I input "200" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '2' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "200" text in "Q" field of "ItemList" table
			And I input "210" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'     | 'Item key' | 'Unit' |
				| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
			And I select current line in "ItemList" table
			And I input "300" text in "Q" field of "ItemList" table
			And I input "250" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
	* Calculate Document discount for Purchase invoice
		And I click "% Offers" button
		And I select current line in "Offers" table
		And I input "10,00" text in "Percent" field
		And I click "Ok" button
		And in the table "Offers" I click "OK" button
	* Check the discount calculation
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'       | 'Offers amount' | 'Unit' | 'Total amount' | 'Store'    |
		| 'Dress'    | '200,00' | 'M/White'   | '100,000' | '2 000,00'      | 'pcs'  | '18 000,00'    | 'Store 01' |
		| 'Dress'    | '210,00' | 'L/Green'   | '200,000' | '4 200,00'      | 'pcs'  | '37 800,00'    | 'Store 01' |
		| 'Trousers' | '250,00' | '36/Yellow' | '300,000' | '7 500,00'      | 'pcs'  | '67 500,00'    | 'Store 01' |
		And I close all client application windows

Scenario: check that discounts with the Sales document type are not displayed in the purchase documents
	* Open Purchase Invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Check the discount tree
		And I click "% Offers" button
		And "Offers" table became equal
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		And I close all client application windows
	* Open Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Check the discount tree
		And I click "% Offers" button
		And "Offers" table became equal
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		And I close all client application windows


Scenario: check that discounts with the Purchase document type are not displayed in the sales documents
	* Change the type of Document discount from Purchases and sales to Purchases
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Document discount' |
		And I select current line in "List" table
		And I select "Purchases" exact value from "Document type" drop-down list
		And I click "Save and close" button
	* Check that the Document discount is not displayed in the Sales order document
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click "% Offers" button
		And "Offers" table does not contain lines
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		And I close all client application windows
	* Check that the Document discount is not displayed in the Sales invoice document
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click "% Offers" button
		And "Offers" table does not contain lines
		| 'Presentation'      | 'Is select' | '%' | '∑' |
		| 'Document discount' | ' '         | ''  | ''  |
		And I close all client application windows
	* Then I return the Document discount type back
		Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
		And I click "List" button
		And I go to line in "List" table
			| 'Description'              |
			| 'Document discount' |
		And I select current line in "List" table
		And I select "Purchases and sales" exact value from "Document type" drop-down list
		And I click "Save and close" button




