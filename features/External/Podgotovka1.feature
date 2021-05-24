#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: creating an order for Lomaniti Basic Agreements (Dress and Boots)
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'             |
				| 'Lomaniti' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'                     |
				| 'Basic Agreements, TRY' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description' |
				| 'Company Lomaniti'  |
		And I select current line in "List" table
		* Adding items to sales order
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'                     |
				| 'Dress' |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'XS/Blue'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'                     |
				| 'Boots' |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| '36/18SD'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"


	

Scenario: create an order for Ferron BP Basic Agreements, TRY (Dress -10 and Trousers - 5)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Ferron BP' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Agreements, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Dress' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
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
		And I input "5,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"


Scenario: creating a Purchase Order document
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
		| Description  |
		| Main Company |
		And I select current line in "List" table
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
			| 'Store 03'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'S/Yellow'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'S/Yellow'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XS/Blue'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'M/White'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XL/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Trousers' | '36/Yellow'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Yellow'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Trousers' | '38/Yellow'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Shirt' | '36/Red'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Shirt' | '38/Black'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "240,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '36/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '37/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '38/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '39/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPostAndClose"




	Scenario: create an item for the set including the specification
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Hat + kerchief" text in the field named "Description_en"
		And I input "Hat + kerchief TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'       |
		And I select current line in "List" table
		And I go to line in "List" table
			| Description |
			| pcs      |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And Delay 5


Scenario: create purchase invoice without order (Vendor Ferron, USD, store 01)
	* Create Purchase Invoice without order	
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
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Dress/A-8'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "100,000" text in "Q" field of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "80,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "50,000" text in "Q" field of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "15,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I save "CurrentDate() - 10800" in "$$$$PreviousDate1$$$$" variable
		And I input "$$$$PreviousDate1$$$$" variable value in "Date" field
		And I move to the next attribute
		And I change checkbox "Do you want to replace filled price types with price type Vendor price, USD?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice31004$$" variable
		And I delete "$$PurchaseInvoice31004$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice31004$$"
		And I save the window as "$$PurchaseInvoice31004$$"
		And I click the button named "FormPostAndClose"


	Scenario: create purchase invoice without order (Vendor Ferron, USD)
	* Create Purchase Invoice without order	
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
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Dress/A-8'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "100,000" text in "Q" field of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "40,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice30004$$" variable
		And I delete "$$PurchaseInvoice30004$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice30004$$"
		And I save the window as "$$PurchaseInvoice30004$$"
		And I click the button named "FormPostAndClose"


	Scenario: create purchase invoice without order (Vendor Ferron, TRY)
	* Create Purchase Invoice without order	
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
				| 'Store 02'  |
			And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'Dress/A-8'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "100,000" text in "Q" field of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "40,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoiceAging$$" variable
		And I delete "$$PurchaseInvoiceAging$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoiceAging$$"
		And I save the window as "$$PurchaseInvoiceAging$$"
		And I click the button named "FormPostAndClose"

	Scenario: create a purchase invoice for the purchase of sets and dimensional grids at the tore 02
		* Create Purchase Invoice without order
			Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
			And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
			And I select current line in "List" table
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
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'Dress/A-8'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "100,000" text in "Q" field of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Boots       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item  | Item key  |
				| Boots | Boots/S-8 |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "200,000" text in "Q" field of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "45,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice29604$$" variable
			And I delete "$$PurchaseInvoice29604$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice29604$$"
			And I save the window as "$$PurchaseInvoice29604$$"
		* Create Goods receipt
			And I click the button named "FormDocumentGoodsReceiptGenerate"
			And I click "Ok" button
			And I click Select button of "Company" field
			And I go to line in "List" table
					| 'Description'  |
					| 'Main Company' |
			And I select current line in "List" table
			And I click the button named "FormPostAndClose"
			And I wait "Goods receipt (create)" window closing in 20 seconds
			And I close all client application windows
	
	Scenario: create Sales invoice for Ferron BP in USD
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I click the button named "FormCreate"
		* Create partner term in USD
			And I input "Ferron, USD" text in the field named "Description_en"
			And I change "Type" radio button value to "Customer"
			And I change "AP/AR posting detail" radio button value to "By documents"
			And I input "234" text in "Number" field
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description |
				| Main company     |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency' | 'Type'      |
				| 'USD'      | 'Partner term' |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| Description |
				| Price USD |
			And I select current line in "List" table
			And I input "01.01.2019" text in "Start using" field
			And I change checkbox "Price includes tax"
			And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description |
			| Ferron, USD |
		And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Trousers    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key  |
				| Trousers | 38/Yellow |
			And I select current line in "List" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Store 01  |
			And I select current line in "List" table
			And I activate "Sales order" field in "ItemList" table
			And I activate "Q" field in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "20,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			* Change the document number to 234
				And I move to "Other" tab
				And I expand "More" group
				And I input "182" text in "Number" field
				Then "1C:Enterprise" window is opened
				And I click "Yes" button
				And I input "234" text in "Number" field
			And in the table "ItemList" I click "% Offers" button
			And in the table "Offers" I click the button named "FormOK"
			And I click the button named "FormPostAndClose"
			And Delay 2





Scenario: adding the items to the sales order (Dress and Trousers)
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'  |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key' |
		| 'L/Green'  |
	And I select current line in "List" table
	And I activate "Q" field in "ItemList" table
	And I input "10,000" text in "Q" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| Description |
		| Trousers       |
	And I select current line in "List" table
	And I move to the next attribute
	And I click choice button of "Item key" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Q" field in "ItemList" table
	And I input "14,000" text in "Q" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I finish line editing in "ItemList" table

Scenario: create the first test PO for a test on the creation mechanism based on
	* Open a form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
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
				| Description |
				| Store 02  |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
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
			And I input "20,000" text in "Q" field of "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '2' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I input "210,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'     | 'Item key' | 'Unit' |
				| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
			And I select current line in "ItemList" table
			And I input "30,000" text in "Q" field of "ItemList" table
			And I input "210,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"


Scenario: create the second test PO for a test on the creation mechanism based on
	* Open a form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| Description       |
				| Second Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
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
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'M/White' | 'pcs' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"


Scenario: create the first test SO for a test on the creation mechanism based on
	* Open a form to create Sales Order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
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
				| Basic Partner terms, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And I input "20,000" text in "Q" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '2' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'     | 'Item key' | 'Unit' |
				| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
			And I select current line in "ItemList" table
			And I input "30,000" text in "Q" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"


Scenario: create the second test SO for a test on the creation mechanism based on
	* Open a form to create Sales Order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| Description       |
				| Second Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Basic Partner terms, TRY |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
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
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'M/White' | 'pcs' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"

Scenario: create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'Ferron BP' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	* Add items to the order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Dress' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
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
		And I input "5,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
	And I click the button named "FormPost"

Scenario: create a Purchase Order document
	* Open a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I go to line in "List" table
		| Description  |
		| Main Company |
		And I select current line in "List" table
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
			| 'Store 03'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'S/Yellow'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'S/Yellow'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XS/Blue'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'M/White'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Dress'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'XL/Green'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Dress' | 'XL/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Yellow'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Trousers' | '36/Yellow'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Yellow'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Trousers' | '38/Yellow'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/Red'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Shirt' | '36/Red'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Shirt'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/Black'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Shirt' | '38/Black'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "240,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '36/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '37/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '37/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '38/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '38/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '39/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Q" field of "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
	And I click the button named "FormPost"

Scenario: checkbox Use serial lot number in the Item type Clothes
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	

