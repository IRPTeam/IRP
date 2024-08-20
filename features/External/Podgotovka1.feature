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
				| 'Description'     |
				| 'Lomaniti'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'               |
				| 'Basic Agreements, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description'          |
				| 'Company Lomaniti'     |
		And I select current line in "List" table
		* Adding items to sales order
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'XS/Blue'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'     |
				| 'Boots'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| '36/18SD'      |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "5,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"


	

Scenario: create an order for Ferron BP Basic Agreements, TRY (Dress -10 and Trousers - 5)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'              |
			| 'Basic Agreements, TRY'    |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'     |
			| '36/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
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
		| Description    |
		| Main Company   |
		And I select current line in "List" table
	* Filling in vendor's info
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description           |
			| Vendor Ferron, TRY    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'S/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'XS/Blue'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'M/White'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'M/White'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XL/Green'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'XL/Green'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| '36/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Unit'    |
			| 'Trousers'   | '36/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| '38/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Unit'    |
			| 'Trousers'   | '38/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '36/Red'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Shirt'   | '36/Red'     | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Shirt'   | '38/Black'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "240,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '36/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '36/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '37/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '37/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '38/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '38/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '39/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '39/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
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
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		And I go to line in "List" table
			| Description    |
			| pcs            |
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
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, USD     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
			And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| 'Dress/A-8'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "100,000" text in "Quantity" field of "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I input "80,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "50,000" text in "Quantity" field of "ItemList" table
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


Scenario: Create document PhysicalInventory objects (for copy lines)

	And I check or create document "PhysicalInventory" objects:
		| 'Ref'                                                                         | 'DeletionMark'  | 'Number'  | 'Date'                 | 'Posted'  | 'RuleEditQuantity'  | 'Status'                                                                  | 'Store'                                                           | 'UseSerialLot'  | 'Author'                                                         | 'Comment'   |
		| 'e1cib/data/Document.PhysicalInventory?ref=b79597b9cc8778aa11edb1f937094eda'  | 'False'         | 1024      | '21.02.2023 17:37:59'  | 'False'   | 'False'             | 'e1cib/data/Catalog.ObjectStatuses?ref=aa78120ed92fbced11eaf13c5c2df447'  | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c'  | 'True'          | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0'  | ''              |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                         | 'Key'                                   | 'Item'                                                           | 'ItemKey'                                                           | 'SerialLotNumber'                                                           | 'Unit'                                                           | 'ExpCount'  | 'PhysCount'  | 'ManualFixedCount'  | 'Difference'  | 'Description'  | 'UseSerialLotNumber'   |
		| 'e1cib/data/Document.PhysicalInventory?ref=b79597b9cc8778aa11edb1f937094eda'  | '60af177f-9071-4600-8562-68713b189fc5'  | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f'  | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72070'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a015'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |             | 3            |                     | 3             | ''             | 'True'                 |
		| 'e1cib/data/Document.PhysicalInventory?ref=b79597b9cc8778aa11edb1f937094eda'  | 'c9e543c8-4897-4bfc-be4f-e01bdc298b0d'  | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f'  | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72070'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a016'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |             | 2            |                     | 2             | ''             | 'True'                 |
		| 'e1cib/data/Document.PhysicalInventory?ref=b79597b9cc8778aa11edb1f937094eda'  | '0571391f-10d4-4e54-b05b-38777a637d19'  | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3'  | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc'  | ''                                                                          | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |             | 3            |                     | 3             | ''             | 'False'                |
		| 'e1cib/data/Document.PhysicalInventory?ref=b79597b9cc8778aa11edb1f937094eda'  | '234d590e-c22e-4212-a827-51f3a19e34e5'  | 'e1cib/data/Catalog.Items?ref=b781cf3f5e36b25611ecd69f89585359'  | 'e1cib/data/Catalog.ItemKeys?ref=b781cf3f5e36b25611ecd69f8958535c'  | ''                                                                          | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  |             | 4            |                     | 4             | ''             | 'True'                 |



Scenario: Create document SalesInvoice objects (for copy lines)

	And I check or create document "SalesInvoice" objects:
		| 'Ref'                                                                    | 'DeletionMark'  | 'Number'  | 'Date'                 | 'Posted'  | 'Agreement'                                                           | 'BasisDocument'  | 'Company'                                                            | 'Currency'                                                            | 'DateOfShipment'      | 'LegalName'                                                          | 'Manager'  | 'ManagerSegment'                                                           | 'Partner'                                                           | 'PriceIncludeTax'  | 'LegalNameContract'  | 'TransactionType'                   | 'Author'                                                         | 'Branch'  | 'Comment'  | 'DocumentAmount'   |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'False'         | 1290      | '20.02.2023 13:31:11'  | 'False'   | 'e1cib/data/Catalog.Agreements?ref=aa78120ed92fbced11eaf118bdb7bb75'  | ''               | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c'  | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855'  | '01.01.0001 0:00:00'  | 'e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf116b32709a4'  | ''         | 'e1cib/data/Catalog.PartnerSegments?ref=aa78120ed92fbced11eaf116b327099c'  | 'e1cib/data/Catalog.Partners?ref=aa78120ed92fbced11eaf113ba6c1873'  | 'False'            | ''                   | 'Enum.SalesTransactionTypes.Sales'  | 'e1cib/data/Catalog.Users?ref=aa7f120ed92fbced11eb13d7279770c0'  | ''        | ''             | 9223.55            |

	And I refill object tabular section "ItemList":
		| 'Ref'                                                                    | 'TotalAmount'  | 'NetAmount'  | 'Item'                                                           | 'ItemKey'                                                           | 'Store'                                                           | 'OffersAmount'  | 'Price'  | 'Quantity'  | 'TaxAmount'  | 'Key'                                   | 'Unit'                                                           | 'PriceType'                                                           | 'SalesOrder'  | 'WorkOrder'  | 'DeliveryDate'        | 'Detail'  | 'ProfitLossCenter'  | 'RevenueType'  | 'AdditionalAnalytic'  | 'DontCalculateRow'  | 'QuantityInBaseUnit'  | 'UseShipmentConfirmation'  | 'UseWorkSheet'  | 'OtherPeriodRevenueType'  | 'SalesPerson'  | 'UseSerialLotNumber'  | 'IsService'  | 'InventoryOrigin'                       |'VatRate'                                                         |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 357            | 300          | 'e1cib/data/Catalog.Items?ref=b780c87413d4c65f11ecd519fda7206f'  | 'e1cib/data/Catalog.ItemKeys?ref=b780c87413d4c65f11ecd519fda72071'  | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c'  |                 | 100      | 3           | 57           | 'f546302b-dda0-44d8-ae8a-6495320b2fe0'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'e1cib/data/Catalog.PriceTypes?refName=ManualPriceType'               | ''            | ''           | '01.01.0001 0:00:00'  | ''        | ''                  | ''             | ''                    | 'False'             | 3                     | 'True'                     | 'False'         | ''                         | ''             | 'True'                | 'False'      | 'Enum.InventoryOriginTypes.OwnStocks'   | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010'  |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 8390.55        | 7050.88      | 'e1cib/data/Catalog.Items?ref=aa78120ed92fbced11eaf115bcc9c5f3'  | 'e1cib/data/Catalog.ItemKeys?ref=aa78120ed92fbced11eaf115bcc9c5fc'  | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c'  |                 | 3525.44  | 2           | 1339.67      | '81190efb-49ec-4562-b051-5bc2cf8a995a'  | 'e1cib/data/Catalog.Units?ref=b75dad46e66c4c2c11eb393335f89c15'  | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59ef002'  | ''            | ''           | '01.01.0001 0:00:00'  | ''        | ''                  | ''             | ''                    | 'False'             | 16                    | 'True'                     | 'False'         | ''                         | ''             | 'False'               | 'False'      | 'Enum.InventoryOriginTypes.OwnStocks'   | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010'  |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 476            | 400          | 'e1cib/data/Catalog.Items?ref=b781cf3f5e36b25611ecd69f89585358'  | 'e1cib/data/Catalog.ItemKeys?ref=b781cf3f5e36b25611ecd69f8958535b'  | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c'  |                 | 200      | 2           | 76           | 'c2db98f2-5749-4426-9ff5-15e88303339e'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'e1cib/data/Catalog.PriceTypes?refName=ManualPriceType'               | ''            | ''           | '01.01.0001 0:00:00'  | ''        | ''                  | ''             | ''                    | 'False'             | 2                     | 'True'                     | 'False'         | ''                         | ''             | 'True'                | 'False'      | 'Enum.InventoryOriginTypes.OwnStocks'   | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010'  |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  |                |              | 'e1cib/data/Catalog.Items?ref=b781cf3f5e36b25611ecd69f89585358'  | 'e1cib/data/Catalog.ItemKeys?ref=b781cf3f5e36b25611ecd69f8958535a'  | 'e1cib/data/Catalog.Stores?ref=aa78120ed92fbced11eaf114c59ef00c'  |                 |          | 8           |              | '552e350a-7fa5-448a-88e4-bedb488559ae'  | 'e1cib/data/Catalog.Units?ref=aa78120ed92fbced11eaf113ba6c1862'  | 'e1cib/data/Catalog.PriceTypes?ref=aa78120ed92fbced11eaf114c59ef002'  | ''            | ''           | '01.01.0001 0:00:00'  | ''        | ''                  | ''             | ''                    | 'False'             | 8                     | 'True'                     | 'False'         | ''                         | ''             | 'True'                | 'False'      | 'Enum.InventoryOriginTypes.OwnStocks'   | 'e1cib/data/Catalog.TaxRates?ref=aa78120ed92fbced11eaf114c59ef010'  |

	And I refill object tabular section "Currencies":
		| 'Ref'                                                                    | 'Key'                                   | 'CurrencyFrom'                                                        | 'Rate'  | 'ReverseRate'  | 'ShowReverseRate'  | 'Multiplicity'  | 'MovementType'                                                                                     | 'Amount'  | 'IsFixed'   |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | '                                    '  | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855'  | 1       | 1              | 'False'            | 1               | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185f'  | 9223.55   | 'False'     |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | '                                    '  | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855'  | 1       | 1              | 'False'            | 1               | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185d'  | 9223.55   | 'False'     |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | '                                    '  | 'e1cib/data/Catalog.Currencies?ref=aa78120ed92fbced11eaf113ba6c1855'  | 0.1712  | 5.8411         | 'False'            | 1               | 'e1cib/data/ChartOfCharacteristicTypes.CurrencyMovementType?ref=aa78120ed92fbced11eaf113ba6c185e'  | 1579.07   | 'False'     |

	And I refill object tabular section "SerialLotNumbers":
		| 'Ref'                                                                    | 'Key'                                   | 'SerialLotNumber'                                                           | 'Quantity'   |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'f546302b-dda0-44d8-ae8a-6495320b2fe0'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a015'  | 2            |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'f546302b-dda0-44d8-ae8a-6495320b2fe0'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a016'  | 1            |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'c2db98f2-5749-4426-9ff5-15e88303339e'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a016'  | 2            |

	
	And I refill object tabular section "SourceOfOrigins":
		| 'Ref'                                                                    | 'Key'                                   | 'SerialLotNumber'                                                           | 'SourceOfOrigin'  | 'Quantity'   |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'f546302b-dda0-44d8-ae8a-6495320b2fe0'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a015'  | ''                | 2            |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'f546302b-dda0-44d8-ae8a-6495320b2fe0'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a016'  | ''                | 1            |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | '81190efb-49ec-4562-b051-5bc2cf8a995a'  | ''                                                                          | ''                | 16           |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | 'c2db98f2-5749-4426-9ff5-15e88303339e'  | 'e1cib/data/Catalog.SerialLotNumbers?ref=b76197e183b782dc11eb6e1d5573a016'  | ''                | 2            |
		| 'e1cib/data/Document.SalesInvoice?ref=b79597b9cc8778aa11edb10bccda179d'  | '552e350a-7fa5-448a-88e4-bedb488559ae'  | ''                                                                          | ''                | 8            |



	Scenario: create purchase invoice without order (Vendor Ferron, USD)
	* Create Purchase Invoice without order	
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I remove checkbox named "FilterCompanyUse"				
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, USD     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| 'Dress/A-8'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "100,000" text in "Quantity" field of "ItemList" table
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
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, TRY     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| 'Dress/A-8'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "100,000" text in "Quantity" field of "ItemList" table
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
					| 'Description'       |
					| 'Main Company'      |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, TRY     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'      |
				| 'Dress/A-8'     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "100,000" text in "Quantity" field of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Boots           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key      |
				| Boots    | Boots/S-8     |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "200,000" text in "Quantity" field of "ItemList" table
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
					| 'Description'       |
					| 'Main Company'      |
			And I select current line in "List" table
			And I click the button named "FormPostAndClose"
			And I wait "Goods receipt (create)" window closing in 20 seconds
			And I close all client application windows
	
	Scenario: create Sales invoice for Ferron BP in USD
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I click the button named "FormCreate"
		* Create partner term in USD
			And I input "Ferron, USD" text in the field named "Description_en"
			And I change "Type" radio button value to "Customer"
			And I change "AP/AR posting detail" radio button value to "By documents"
			And I expand "Agreement info" group
			And I expand "Price settings" group
			And I expand "Store and delivery" group
			And I input "234" text in "Number" field
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main company     |
			And I select current line in "List" table
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Multi currency movement type" field
			And I go to line in "List" table
				| 'Currency'    | 'Type'             |
				| 'USD'         | 'Partner term'     |
			And I select current line in "List" table
			And I click Select button of "Price type" field
			And I go to line in "List" table
				| Description     |
				| Price USD       |
			And I select current line in "List" table
			And I input "01.01.2019" text in "Start using" field
			And I change checkbox "Price includes tax"
			And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description    |
			| Ferron, USD    |
		And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Trousers        |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item        | Item key      |
				| Trousers    | 38/Yellow     |
			And I select current line in "List" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| Description     |
				| Store 01        |
			And I select current line in "List" table
			And I activate "Sales order" field in "ItemList" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
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
		| 'Description'   |
		| 'Dress'         |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key'   |
		| 'L/Green'    |
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "10,000" text in "Quantity" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| Description   |
		| Trousers      |
	And I select current line in "List" table
	And I move to the next attribute
	And I click choice button of "Item key" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "14,000" text in "Quantity" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I finish line editing in "ItemList" table

Scenario: create the first test PO for a test on the creation mechanism based on
	* Open a form to create Purchase Order
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description     |
			| Main Company    |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, TRY     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/White'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '1'    | 'Dress'    | 'M/White'     | 'pcs'      |
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '2'    | 'Dress'    | 'L/Green'     | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I input "210,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'        | 'Item key'     | 'Unit'     |
				| '3'    | 'Trousers'    | '36/Yellow'    | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "30,000" text in "Quantity" field of "ItemList" table
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
				| Description      |
				| Main Company     |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| Description                  |
				| Second Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description            |
				| Vendor Ferron, TRY     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/White'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '1'    | 'Dress'    | 'M/White'     | 'pcs'      |
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
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
			| Description     |
			| Main Company    |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/White'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'L/Green'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Trousers'        |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '1'    | 'Dress'    | 'M/White'     | 'pcs'      |
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '2'    | 'Dress'    | 'L/Green'     | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'        | 'Item key'     | 'Unit'     |
				| '3'    | 'Trousers'    | '36/Yellow'    | 'pcs'      |
			And I select current line in "ItemList" table
			And I input "30,000" text in "Quantity" field of "ItemList" table
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
				| Description      |
				| Main Company     |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| Description                  |
				| Second Company Ferron BP     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description                  |
				| Basic Partner terms, TRY     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description     |
				| Store 02        |
			And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Dress'           |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'     |
				| 'M/White'      |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#'    | 'Item'     | 'Item key'    | 'Unit'     |
				| '1'    | 'Dress'    | 'M/White'     | 'pcs'      |
			And I activate "Quantity" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"

Scenario: create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
	And I select current line in "List" table
	* Add items to the order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key'     |
			| '36/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
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
		| Description    |
		| Main Company   |
		And I select current line in "List" table
	* Filling in vendor's info
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description           |
			| Vendor Ferron, TRY    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 03'       |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in items table
		And I move to "Item list" tab
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'S/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'XS/Blue'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'M/White'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'M/White'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XL/Green'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Dress'   | 'XL/Green'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "205,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| '36/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Unit'    |
			| 'Trousers'   | '36/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'     |
			| '38/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key'    | 'Unit'    |
			| 'Trousers'   | '38/Yellow'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "220,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '36/Red'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Shirt'   | '36/Red'     | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "250,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Shirt'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '38/Black'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Shirt'   | '38/Black'   | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "240,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '36/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '36/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '37/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '37/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '38/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '38/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '39/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'   | 'Unit'    |
			| 'Boots'   | '39/18SD'    | 'pcs'     |
		And I select current line in "ItemList" table
		And I input "200,000" text in "Quantity" field of "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
	And I click the button named "FormPost"

Scenario: checkbox Use serial lot number in the Item type Clothes
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Check box Use serial lot number
		And I go to line in "List" table
			| 'Description'    |
			| 'Clothes'        |
		And I select current line in "List" table
		And I set checkbox "Use serial lot number"
		And I click "Save and close" button	



Scenario: check filling revenue type (from Company)
* Select Company
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Rent'           | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect Company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'               | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Telephone communications'   | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |


Scenario: check	filling expense type (from Company)
	* Select Company	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Service'        |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'Rent'        |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in Expense type
		And "ItemList" table became equal
			| 'Expense type'   | 'Item'      | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Rent'           | 'Service'   | 'Rent'       | '1,000'      | 'pcs'     |
	* Reselect Company
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
	* Check filling in Expense type
		And "ItemList" table became equal
			| 'Expense type'               | 'Item'      | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Telephone communications'   | 'Service'   | 'Rent'       | '1,000'      | 'pcs'     |


Scenario: check filling revenue type (from item type)
	* Select Company
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Fuel'           | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect item
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '37/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'               | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Telephone communications'   | 'Boots'   | '37/18SD'    | '1,000'      | 'pcs'     |

Scenario: check filling expense type (from item type)
	* Select Company	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Expense type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Fuel'           | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect item
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '37/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Expense type'               | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Telephone communications'   | 'Boots'   | '37/18SD'    | '1,000'      | 'pcs'     |

Scenario: check filling revenue type (item)
	* Select Company
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Software'       | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect item
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '37/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Rent'           | 'Boots'   | '37/18SD'    | '1,000'      | 'pcs'     |

Scenario: check filling expense type (from item)
	* Select Company	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Expense type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Software'       | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect item
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Boots'          |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| '37/18SD'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Expense type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Rent'           | 'Boots'   | '37/18SD'    | '1,000'      | 'pcs'     |

Scenario: check filling revenue type (item key)
	* Select Company
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Software'       | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect item
		And I select current line in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in revenue type
		And "ItemList" table became equal
			| 'Revenue type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Delivery'       | 'Dress'   | 'S/Yellow'   | '1,000'      | 'pcs'     |
	* Select item key without revenue type
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Unit' | 'Quantity' | 'Revenue type' |
			| 'Dress' | 'S/Yellow' | 'pcs'  | '1,000'    | 'Delivery'     |
			| 'Bag'   | 'ODS'      | 'pcs'  | '1,000'    | ''             |
		
				
Scenario: check filling expense type (from item key)
	* Select Company	
		And I click "Create" button
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Select Item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate field named "ItemListItem" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in expense type
		And "ItemList" table became equal
			| 'Expense type'   | 'Item'    | 'Item key'   | 'Quantity'   | 'Unit'    |
			| 'Software'       | 'Dress'   | 'XS/Blue'    | '1,000'      | 'pcs'     |
	* Reselect item
		And I select current line in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item key'    |
			| 'S/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table		
	* Check filling in expense type (item key without Expense type)
		And "ItemList" table became equal
			| 'Expense type' | 'Item'  | 'Item key' | 'Quantity' | 'Unit' |
			| 'Delivery'     | 'Dress' | 'S/Yellow' | '1,000'    | 'pcs'  |
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Bag'         |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item' | 'Item key' |
			| 'Bag'  | 'ODS'      |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And "ItemList" table became equal
			| 'Item'  | 'Item key' | 'Unit' | 'Quantity' | 'Expense type' |
			| 'Dress' | 'S/Yellow' | 'pcs'  | '1,000'    | 'Delivery'     |
			| 'Bag'   | 'ODS'      | 'pcs'  | '1,000'    | ''             |

Scenario: delete ExpenseRevenueTypeSettings records for Company
	And I close all client application windows
	Given I open hyperlink "e1cib/list/InformationRegister.ExpenseRevenueTypeSettings"
	If "List" table contains lines Then
		| 'Company'        | 'Item type' | 'Item'  | 'Item key' | 'Expense type'             | 'Revenue type'             |
		| 'Main Company'   | ''          | ''      | ''         | 'Rent'                     | 'Rent'                     |
		And I go to line in "List" table
			| 'Company'        | 'Item type' | 'Item'  | 'Item key' | 'Expense type'             | 'Revenue type'             |
			| 'Main Company'   | ''          | ''      | ''         | 'Rent'                     | 'Rent'                     |
		And in the table "List" I click the button named "ListContextMenuDelete"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
						
					
Scenario: add different items in POS
		* Product with SLN without marking code
			And I click "Search by barcode (F7)" button
			And I input "23455677788976667" text in the field named "Barcode"
			And I move to the next attribute
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Products with SLN and marking code
			And I click "Search by barcode (F7)" button
			And I input "57897909799" text in the field named "Barcode"
			And I move to the next attribute
			Then "Code string check" window is opened
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY0" text in the field named "Barcode"	
			And I move to the next attribute
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Search by barcode (F7)" button	
			And I input "999999999" text in the field named "Barcode"	
			And I move to the next attribute
			Then "Code string check" window is opened
			And I click "Search by barcode" button
			Then "Barcode" window is opened
			And I input "Q3VycmVudCByb3cgd2lsbCBkZWNvZGUgdG8gYmFzZTY1" text in the field named "Barcode"
			And I move to the next attribute
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Product without SLN
			And I click "Search by barcode (F7)" button
			And I input "2202283705" text in the field named "Barcode"
			And I move to the next attribute	
		* Service
			And I click "Search by barcode (F7)" button
			And I input "89908" text in the field named "Barcode"
			And I move to the next attribute
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table