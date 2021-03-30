#language: en
@tree
@Positive
@SalesOrderProcurement

Feature: create Purchase order based on a Sales order

As a sales manager
I want to create Purchase order based on a Sales order
To implement a sales-for-purchase scheme


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _029200 preparation (create Purchase order based on a Sales order)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When  Create catalog Partners objects (Lomaniti)
		When  Create catalog Partners objects (Ferron BP)
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
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Create Sales order 501
		* Open form for create order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling the document heading
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Lomaniti'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Lomaniti' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
		* Filling items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I move to "Item list" tab
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "5,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I set checkbox "Shipment confirmations before sales invoice"
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292001$$" variable
			And I delete "$$SalesOrder0292001$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292001$$"
			And I save the window as "$$SalesOrder0292001$$"
			And I click the button named "FormPostAndClose"
	* Create Sales order 502
		* Open form for create order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling the document heading
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Lomaniti'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Lomaniti' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		* Filling items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I move to "Item list" tab
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "8,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "11,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I input end of the current month date in "Delivery date" field
		* Save number
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292002$$" variable
			And I delete "$$SalesOrder0292002$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292002$$"
			And I save the window as "$$SalesOrder0292002$$"
			And I click the button named "FormPostAndClose"
	* Create Sales order 503
		* Open form for create order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling the document heading
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Lomaniti'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Lomaniti' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
		* Filling items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I move to "Item list" tab
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "12,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "7,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I input end of the current month date in "Delivery date" field
		* Save number
			And I move to "Other" tab
			And I set checkbox "Shipment confirmations before sales invoice"
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292003$$" variable
			And I delete "$$SalesOrder0292003$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292003$$"
			And I save the window as "$$SalesOrder0292003$$"
			And I click the button named "FormPostAndClose"
	* Create Sales order 504
		* Open form for create order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling the document heading
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Lomaniti'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Lomaniti' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                   |
				| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
		* Filling items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I move to "Item list" tab
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "7,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I input end of the current month date in "Delivery date" field
		* Save number
			And I move to "Other" tab
			And I set checkbox "Shipment confirmations before sales invoice"
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292004$$" variable
			And I delete "$$SalesOrder0292004$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292004$$"
			And I save the window as "$$SalesOrder0292004$$"
			And I click the button named "FormPostAndClose"
	* Create Sales order 505
		* Open form for create order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
		* Filling the document heading
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Lomaniti'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Lomaniti' |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		* Filling items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I move to "Item list" tab
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "31,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Shirt'       |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Shirt' | '38/Black' |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "40,000" text in "Q" field of "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I input end of the current month date in "Delivery date" field
		* Save number
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292005$$" variable
			And I delete "$$SalesOrder0292005$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292005$$"
			And I save the window as "$$SalesOrder0292005$$"
			And I click the button named "FormPostAndClose"



#  Sales order - Purchase order - Goods receipt - Purchase invoice - Shipment confirmation - Sales invoice
Scenario: _029201 create Purchase order based on Sales order (Shipment confirmation before Sales invoice)
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
			| 'Basic Partner terms, TRY' |
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
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| 'XS/Blue'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
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
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '36/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	* Change the procurement method by rows and add a new row
		And I go to line in "ItemList" table
			| Item  |
			| Dress |
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| Item  |
			| Boots |
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
		And I activate "Procurement method" field in "ItemList" table
		And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
		And I move to the next attribute
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change of document number 455
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I input end of the current month date in "Delivery date" field
	* Post Sales order
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder029201$$" variable
		And I delete "$$SalesOrder029201$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029201$$"
		And I save the window as "$$SalesOrder029201$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create one more Sales order
		When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
		* Change of store to the one with Shipment confirmation
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| Description |
				| Store 02    |
			And I select current line in "List" table
			Then "Update item list info" window is opened
			Then the form attribute named "Stores" became equal to "Yes"
			And I click "OK" button
	* Change the procurement method by rows and add a new row
			And I go to line in "ItemList" table
				| Item  |
				| Dress |
			And I activate "Procurement method" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| Item  | 
				| Trousers |
			And I activate "Procurement method" field in "ItemList" table
			And I select current line in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
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
			And I activate "Procurement method" field in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I move to the next attribute
			And I activate "Q" field in "ItemList" table
			And I input "10,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
	* Change of document number 456
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Shipment confirmations before sales invoice"
	* Post Sales order
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292012$$" variable
			And I delete "$$SalesOrder0292012$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292012$$"
			And I save the window as "$$SalesOrder0292012$$"
			And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create one Purchase order based on two Sales orders
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number'                     | 'Partner'  |
		| '$$NumberSalesOrder029201$$' | 'Lomaniti' |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseOrderGenerate"
		And I click "Ok" button
	* Check filling of the tabular part of the Purchase order
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      | 'Purchase basis'   |
		| 'Dress'    | 'XS/Blue'   | 'Store 01' | 'pcs'  | '5,000'  | '$$SalesOrder029201$$' |
		| 'Trousers' | '38/Yellow' | 'Store 01' | 'pcs'  | '10,000' | '$$SalesOrder029201$$' |
		| 'Dress'    | 'XS/Blue'   | 'Store 02' | 'pcs'  | '10,000' | '$$SalesOrder0292012$$' |
		| 'Trousers' | '36/Yellow' | 'Store 02' | 'pcs'  | '5,000'  | '$$SalesOrder0292012$$' |
		| 'Trousers' | '38/Yellow' | 'Store 02' | 'pcs'  | '10,000' | '$$SalesOrder0292012$$' |
	* Filling in vendors and prices
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| Description |
			| Company Ferron BP   |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| Description        |
			| Vendor Ferron, TRY |
		And I select current line in "List" table
		# message on price changes
		And I remove checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
		And I remove checkbox "Do you want to update filled prices?"
		And I click "OK" button
		# message on price changes
		And I select "Approved" exact value from "Status" drop-down list
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'Store 01' |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '38/Yellow'  | 'Store 01' |
		And I select current line in "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Store'    |
			| 'Dress' | 'XS/Blue'  | 'Store 02' |
		And I select current line in "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '36/Yellow'  | 'Store 02' |
		And I select current line in "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'     | 'Item key'   | 'Store'    |
			| 'Trousers' | '38/Yellow'  | 'Store 02' |
		And I select current line in "ItemList" table
		And I input "180,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Change of document number - 456
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0292012$$" variable
		And I delete "$$PurchaseOrder0292012$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0292012$$"
		And I save the window as "$$PurchaseOrder0292012$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows

Scenario: _029202 create Goods receipt based on Purchase order that based on Sales order (Goods receipt before Purchase invoice)
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'    |
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button
	* Check filling of the tabular part
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'           | 'Store'    | 'Receipt basis'            |
			| 'Dress'    | '5,000'    | 'XS/Blue'   | 'pcs'  | '$$SalesOrder029201$$'  | 'Store 01' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | '$$SalesOrder029201$$'  | 'Store 01' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt0292022$$" variable
		And I delete "$$GoodsReceipt029202$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt0292022$$"
		And I save the window as "$$GoodsReceipt029202$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows

Scenario: _029203 check movements if there is an additional line in the Purchase order that is not in the Sales order (Goods receipt before Purchase invoice)
	* Mark for deletion Goods receipt 456
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt0292022$$'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I close all client application windows
	* Adding one more line to Purchase order 456 which is not in the Sales order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'    |
		And I select current line in "List" table
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
		And I input "50" text in "Q" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I click choice button of "Store" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Store 02    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPostAndClose"
	* Create GoodsReceipt 457
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'    |
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button	
	* Check filling of the tabular part of Goods receipt
			And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'      | 'Store'    | 'Receipt basis'       |
			| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Dress'    | '50,000'   | 'M/White'   | 'pcs'  | ''                 | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt029203$$" variable
		And I delete "$$GoodsReceipt029203$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029203$$"
		And I save the window as "$$GoodsReceipt029203$$"
		And I click the button named "FormPostAndClose"
	And I close all client application windows

Scenario: _029204 create Purchase invoice based on Purchase order that based on Sales order (Goods receipt before Purchase invoice)
	* Create Purchase invoice based on Purchase order
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt029203$$'   |
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"			
		And I click "OK" button
	* Check filling of the tabular part
		And "ItemList" table contains lines
		| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Purchase order'           | 'Sales order'           |
		| '762,71'     | 'Trousers' | '180,00' | '36/Yellow' | '5,000'  | '137,29'     | 'pcs'  | '900,00'       | 'Store 02' | '$$PurchaseOrder0292012$$' | '$$SalesOrder0292012$$' |
		| '1 694,92'   | 'Dress'    | '200,00' | 'XS/Blue'   | '10,000' | '305,08'     | 'pcs'  | '2 000,00'     | 'Store 02' | '$$PurchaseOrder0292012$$' | '$$SalesOrder0292012$$' |
		| '8 898,31'   | 'Dress'    | '210,00' | 'M/White'   | '50,000' | '1 601,69'   | 'pcs'  | '10 500,00'    | 'Store 02' | '$$PurchaseOrder0292012$$' | ''                      |
		| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' | '274,58'     | 'pcs'  | '1 800,00'     | 'Store 02' | '$$PurchaseOrder0292012$$' | '$$SalesOrder0292012$$' |
		| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' | '274,58'     | 'pcs'  | '1 800,00'     | 'Store 01' | '$$PurchaseOrder0292012$$' | '$$SalesOrder029201$$'  |
		| '847,46'     | 'Dress'    | '200,00' | 'XS/Blue'   | '5,000'  | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 01' | '$$PurchaseOrder0292012$$' | '$$SalesOrder029201$$'  |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice029204$$" variable
		And I delete "$$PurchaseInvoice029204$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029204$$"
		And I save the window as "$$PurchaseInvoice029204$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows

Scenario: _029205 create Shipment confirmation based on Sales order, procurement method - purchase (Shipment confirmation before Sales invoice, store use Shipment confirmation)
	* Create Shipment confirmation based on Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292012$$'  |
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button	
	* Check filling of the tabular part
		And "ItemList" table contains lines
		| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Store'    | 'Shipment basis'        |
		| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | 'Store 02' | '$$SalesOrder0292012$$' |
		| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | 'Store 02' | '$$SalesOrder0292012$$' |
		| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | 'Store 02' | '$$SalesOrder0292012$$' |
	* Change of document number
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentConfirmation029205$$" variable
		And I delete "$$ShipmentConfirmation029205$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029205$$"
		And I save the window as "$$ShipmentConfirmation029205$$"
		And I click the button named "FormPost"
		And I close all client application windows

Scenario: _029206 create Sales invoice based on Sales order, procurement method - purchase (Shipment confirmation before Sales invoice, store use Shipment confirmation)
	* Create Sales invoice based on Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| Number |
			| $$NumberSalesOrder0292012$$   |
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "OK" button
	* Check filling of the tabular part
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Q'      |'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
		| 'Dress'    | '520,00' | 'XS/Blue'   | '10,000' |'793,22'     | 'pcs'  | '4 406,78'   | '5 200,00'     | 'Store 02' |
		| 'Trousers' | '400,00' | '36/Yellow' | '5,000'  |'305,08'     | 'pcs'  | '1 694,92'   | '2 000,00'     | 'Store 02' |
		| 'Trousers' | '400,00' | '38/Yellow' | '10,000' |'610,17'     | 'pcs'  | '3 389,83'   | '4 000,00'     | 'Store 02' |
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice0292012$$" variable
		And I delete "$$SalesInvoice0292012$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice0292012$$"
		And I save the window as "$$SalesInvoice0292012$$"
		And I close all client application windows

