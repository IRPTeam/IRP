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
	* Post Sales order
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder029201$$" variable
		And I delete "$$SalesOrder029201$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder029201$$"
		And I save the window as "$$SalesOrder029201$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesOrder029201$$'    |
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder029201$$'           | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' | '' |
		| ''                               | 'Expense'     | '*'      | '1'         | 'Main Company' | '36/18SD'   | '' | '' | '' | '' | '' |
		| ''                               | 'Expense'     | '*'      | '5'         | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' | '' |
		| ''                               | 'Expense'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' | '' |
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '1'         | 'Store 01'   | '36/18SD'   | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' | '' |
		And I select "Order procurement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order procurement"' | ''            | ''       | ''          | ''             | ''                     | ''         | ''          | ''        | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                     | ''         | ''          | ''        | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                | 'Store'    | 'Item key'  | 'Row key' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder029201$$' | 'Store 01' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder029201$$' | 'Store 01' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '1'         | 'Store 01'   | '36/18SD'  | '' | '' | '' | '' | '' |
		And I select "Shipment orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment orders"' | ''            | ''       | ''          | ''                     | ''                      | ''         | ''        | '' | '' | '' |
		| ''                            | 'Record type' | 'Period' | 'Resources' | 'Dimensions'           | ''                      | ''         | ''        | '' | '' | '' |
		| ''                            | ''            | ''       | 'Quantity'  | 'Order'                | 'Shipment confirmation' | 'Item key' | 'Row key' | '' | '' | '' |
		| ''                            | 'Receipt'     | '*'      | '1'         | '$$SalesOrder029201$$' | '$$SalesOrder029201$$'  | '36/18SD'  | '*'       | '' | '' | '' |
		And I select "Sales order turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Sales order turnovers"' | ''       | ''          | ''       | ''             | ''                     | ''         | ''          | ''        | ''                             | ''                     |
		| ''                                  | 'Period' | 'Resources' | ''       | 'Dimensions'   | ''                     | ''         | ''          | ''        | ''                             | 'Attributes'           |
		| ''                                  | ''       | 'Quantity'  | 'Amount' | 'Company'      | 'Sales order'          | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                  | '*'      | '1'         | '119,84' | 'Main Company' | '$$SalesOrder029201$$' | 'USD'      | '36/18SD'   | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '1'         | '700'    | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | '36/18SD'   | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '1'         | '700'    | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | '36/18SD'   | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '1'         | '700'    | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | '36/18SD'   | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '5'         | '445,12' | 'Main Company' | '$$SalesOrder029201$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 600'  | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 600'  | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 600'  | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '684,8'  | 'Main Company' | '$$SalesOrder029201$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder029201$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                     | ''          | ''        | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                     | ''          | ''        | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                | 'Item key'  | 'Row key' | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '1'         | 'Store 01'   | '$$SalesOrder029201$$' | '36/18SD'   | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 01'   | '$$SalesOrder029201$$' | 'XS/Blue'   | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$SalesOrder029201$$' | '38/Yellow' | '*'       | '' | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '1'         | 'Store 01'   | '36/18SD'  | '' | '' | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''                     | ''                      | ''          | ''          | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''          | ''          | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'              | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company'         | '$$SalesOrder029201$$'  | 'Store 01'  | '36/18SD'   | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company'         | '$$SalesOrder029201$$'  | 'Store 01'  | 'XS/Blue'   | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company'         | '$$SalesOrder029201$$'  | 'Store 01'  | '38/Yellow' | '*'       | '*'                            | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'         | 'Main Company'         | '$$SalesOrder029201$$'  | 'Store 01'  | '36/18SD'   | '*'       | '*'                            | ''                     |
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
	* Check movements
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesOrder0292012$$'    |
		And I click "Registrations report" button
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder0292012$$'          | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| 'Register  "Order reservation"'  | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' | '' |
		And I select "Order procurement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order procurement"' | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''         | ''          | ''        | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Row key' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '' | '' |
		And I select "Sales order turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Sales order turnovers"' | ''       | ''          | ''       | ''             | ''                      | ''         | ''          | ''        | ''                             | ''                     |
		| ''                                  | 'Period' | 'Resources' | ''       | 'Dimensions'   | ''                      | ''         | ''          | ''        | ''                             | 'Attributes'           |
		| ''                                  | ''       | 'Quantity'  | 'Amount' | 'Company'      | 'Sales order'           | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                  | '*'      | '5'         | '342,4'  | 'Main Company' | '$$SalesOrder0292012$$' | 'USD'      | '36/Yellow' | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 000'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | '36/Yellow' | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 000'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | '36/Yellow' | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 000'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | '36/Yellow' | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '684,8'  | 'Main Company' | '$$SalesOrder0292012$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '890,24' | 'Main Company' | '$$SalesOrder0292012$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '5 200'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '5 200'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '5 200'  | 'Main Company' | '$$SalesOrder0292012$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'  | 'Row key' | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$SalesOrder0292012$$' | '36/Yellow' | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | '38/Yellow' | '*'       | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                      | ''          | ''          | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02'  | '38/Yellow' | '*'       | '*'                            | ''                     |
		And I close all client application windows
	* Create one Purchase order based on two Sales orders
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number'                     | 'Partner'  |
		| '$$NumberSalesOrder029201$$' | 'Lomaniti' |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseOrderGeneratePurchaseOrder"
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
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder0292012$$" variable
		And I delete "$$PurchaseOrder0292012$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder0292012$$"
		And I save the window as "$$PurchaseOrder0292012$$"
	And I click the button named "FormPostAndClose"
	* Check movements Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder0292012$$'    |
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseOrder0292012$$'       | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' |
		And I select "Order procurement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order procurement"' | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''         | ''          | ''        | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Row key' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder029201$$'  | 'Store 01' | 'XS/Blue'   | '*'       | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder029201$$'  | 'Store 01' | '38/Yellow' | '*'       | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '' |
		And I select "Goods in transit incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'            | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' |
		And I select "Receipt orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Receipt orders"' | ''            | ''       | ''          | ''                         | ''                         | ''          | ''        | '' | '' |
		| ''                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                         | ''          | ''        | '' | '' |
		| ''                           | ''            | ''       | 'Quantity'  | 'Order'                    | 'Goods receipt'            | 'Item key'  | 'Row key' | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '5'         | '$$PurchaseOrder0292012$$' | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                         | ''         | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''         | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                    | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | '38/Yellow' | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | '38/Yellow' | '*'       | '*'             |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'  | 'Row key' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 01'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                         | ''                         | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                         | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                    | 'Item key'                 | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'                 | 'XS/Blue'                  | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'                 | '38/Yellow'                | ''          | ''          | ''        | ''              |
		And I close all client application windows

Scenario: _029202 create Goods receipt based on Purchase order that based on Sales order (Goods receipt before Purchase invoice)
	* Create Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'    |
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Check filling of the tabular part
		And "ItemList" table contains lines
			| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'      | 'Store'    | 'Receipt basis'       |
			| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
			| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | '$$SalesOrder0292012$$' | 'Store 02' | '$$PurchaseOrder0292012$$' |
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt0292022$$" variable
		And I delete "$$GoodsReceipt029202$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt0292022$$"
		And I save the window as "$$GoodsReceipt029202$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt0292022$$'    |
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt029202$$'         | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Main Company' | '36/Yellow' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' |
		And I select "Goods in transit outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'        | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$SalesOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Goods in transit incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'            | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		And I select "Receipt orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Receipt orders"' | ''            | ''       | ''          | ''                         | ''                       | ''          | ''        | '' | '' |
		| ''                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                       | ''          | ''        | '' | '' |
		| ''                           | ''            | ''       | 'Quantity'  | 'Order'                    | 'Goods receipt'          | 'Item key'  | 'Row key' | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '5'         | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029202$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029202$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029202$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                         | ''         | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''         | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                    | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                         | ''                         | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                         | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                    | 'Item key'                 | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'                 | '36/Yellow'                | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                 | 'XS/Blue'                  | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                 | '38/Yellow'                | ''          | ''          | ''        | ''              |
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
		* Check movements
			Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
			And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'    |
			And I click "Registrations report" button
			And I select "Inventory balance" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseOrder0292012$$'       | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
			| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
			| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' |
			| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | '5'         | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' |
			And I select "Order procurement" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Order procurement"' | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''         | ''          | ''        | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Row key' | '' |
			| ''                              | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder029201$$'  | 'Store 01' | 'XS/Blue'   | '*'       | '' |
			| ''                              | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder029201$$'  | 'Store 01' | '38/Yellow' | '*'       | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '' |
			And I select "Goods in transit incoming" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'            | 'Item key'  | 'Row key' | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'M/White'   | '*'       | '' | '' |
			And I select "Stock reservation" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' |
			| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' |
			| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' |
			And I select "Receipt orders" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Receipt orders"' | ''            | ''       | ''          | ''                         | ''                         | ''          | ''        | '' | '' |
			| ''                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                         | ''          | ''        | '' | '' |
			| ''                           | ''            | ''       | 'Quantity'  | 'Order'                    | 'Goods receipt'            | 'Item key'  | 'Row key' | '' | '' |
			| ''                           | 'Receipt'     | '*'      | '5'         | '$$PurchaseOrder0292012$$' | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
			| ''                           | 'Receipt'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
			And I select "Goods receipt schedule" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                         | ''         | ''          | ''        | ''              |
			| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''         | ''          | ''        | 'Attributes'    |
			| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                    | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' |
			| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | 'XS/Blue'   | '*'       | '*'             |
			| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             |
			| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | '38/Yellow' | '*'       | '*'             |
			| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             |
			| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             |
			| ''                                   | 'Receipt'     | '*'      | '50'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | 'M/White'   | '*'       | '*'             |
			| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | 'XS/Blue'   | '*'       | '*'             |
			| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 01' | '38/Yellow' | '*'       | '*'             |
			And I select "Order balance" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' |
			| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' |
			| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'  | 'Row key' | '' | '' |
			| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 01'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
			| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
			| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
			| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
			| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
			| ''                          | 'Receipt'     | '*'      | '50'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'M/White'   | '*'       | '' | '' |
			And I select "Stock balance" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                         | ''                         | ''          | ''          | ''        | ''              |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                         | ''          | ''          | ''        | ''              |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                    | 'Item key'                 | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 01'                 | 'XS/Blue'                  | ''          | ''          | ''        | ''              |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 01'                 | '38/Yellow'                | ''          | ''          | ''        | ''              |
	* Create GoodsReceipt 457
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'    |
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
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
	* Check movements
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt029203$$'    |
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt029203$$'         | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Main Company' | '36/Yellow' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '50'        | 'Main Company' | 'M/White'   | '' | '' | '' | '' |
		And I select "Goods in transit outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'        | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$SalesOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Goods in transit incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'            | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '50'        | 'Store 02'   | '$$PurchaseOrder0292012$$' | 'M/White'   | '*'       | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '50'        | 'Store 02'   | 'M/White'   | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		And I select "Receipt orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Receipt orders"' | ''            | ''       | ''          | ''                         | ''                       | ''          | ''        | '' | '' |
		| ''                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                       | ''          | ''        | '' | '' |
		| ''                           | ''            | ''       | 'Quantity'  | 'Order'                    | 'Goods receipt'          | 'Item key'  | 'Row key' | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '5'         | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | '38/Yellow' | '*'       | '' | '' |
		| ''                           | 'Receipt'     | '*'      | '50'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | 'M/White'   | '*'       | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                         | ''         | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''         | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                    | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '50'        | 'Main Company' | '$$PurchaseOrder0292012$$' | 'Store 02' | 'M/White'   | '*'       | '*'             |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''                         | ''                         | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                         | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'                    | 'Item key'                 | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'                 | '36/Yellow'                | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                 | 'XS/Blue'                  | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'                 | '38/Yellow'                | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '50'        | 'Store 02'                 | 'M/White'                  | ''          | ''          | ''        | ''              |
	And I close all client application windows

Scenario: _029204 create Purchase invoice based on Purchase order that based on Sales order (Goods receipt before Purchase invoice)
	* Create Purchase invoice based on Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292012$$'   |
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		And I click the button named "FormSelectAll"
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
	* Check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice029204$$'    |
		And I click "Registrations report" button
		And I select "Purchase turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice029204$$'      | ''       | ''          | ''        | ''           | ''             | ''                          | ''         | ''          | ''        | ''                             | ''                     | '' | '' |
		| 'Document registrations records' | ''       | ''          | ''        | ''           | ''             | ''                          | ''         | ''          | ''        | ''                             | ''                     | '' | '' |
		| 'Register  "Purchase turnovers"' | ''       | ''          | ''        | ''           | ''             | ''                          | ''         | ''          | ''        | ''                             | ''                     | '' | '' |
		| ''                               | 'Period' | 'Resources' | ''        | ''           | 'Dimensions'   | ''                          | ''         | ''          | ''        | ''                             | 'Attributes'           | '' | '' |
		| ''                               | ''       | 'Quantity'  | 'Amount'  | 'Net amount' | 'Company'      | 'Purchase invoice'          | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                               | '*'      | '5'         | '154,08'  | '130,58'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'USD'      | '36/Yellow' | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '171,2'   | '145,09'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '900'     | '762,71'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '36/Yellow' | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '900'     | '762,71'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '36/Yellow' | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '900'     | '762,71'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '36/Yellow' | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '1 000'   | '847,46'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '1 000'   | '847,46'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '1 000'   | '847,46'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '308,16'  | '261,15'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '308,16'  | '261,15'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '342,4'   | '290,17'     | 'Main Company' | '$$PurchaseInvoice029204$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'   | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'   | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'   | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'   | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'   | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'   | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '2 000'   | '1 694,92'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '2 000'   | '1 694,92'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '2 000'   | '1 694,92'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '50'        | '1 797,6' | '1 523,39'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'USD'      | 'M/White'   | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '50'        | '10 500'  | '8 898,31'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'M/White'   | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '50'        | '10 500'  | '8 898,31'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'M/White'   | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '50'        | '10 500'  | '8 898,31'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'TRY'      | 'M/White'   | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                          | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
		| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'                | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
		| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'                  | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                            | '*'      | '23,5'      | '23,5'          | '130,58'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '26,11'     | '26,11'         | '145,09'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '47,01'     | '47,01'         | '261,15'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '47,01'     | '47,01'         | '261,15'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '52,23'     | '52,23'         | '290,17'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '137,29'    | '137,29'        | '762,71'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '137,29'    | '137,29'        | '762,71'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '137,29'    | '137,29'        | '762,71'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '152,54'    | '152,54'        | '847,46'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '152,54'    | '152,54'        | '847,46'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '152,54'    | '152,54'        | '847,46'     | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '274,21'    | '274,21'        | '1 523,39'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '1 601,69'  | '1 601,69'      | '8 898,31'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '1 601,69'  | '1 601,69'      | '8 898,31'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '1 601,69'  | '1 601,69'      | '8 898,31'   | '$$PurchaseInvoice029204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''                          | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''                          | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document'            | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | '18 000'         | ''                       | ''               | 'Main Company' | 'Ferron BP' | 'Company Ferron BP' | '$$PurchaseInvoice029204$$' | 'TRY'      | '' | '' |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Expense'     | '*'      | '18 000'    | 'Main Company' | 'Company Ferron BP' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Receipt orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Receipt orders"' | ''            | ''       | ''          | ''                         | ''                       | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'               | ''                       | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                           | ''            | ''       | 'Quantity'  | 'Order'                    | 'Goods receipt'          | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
		| ''                           | 'Expense'     | '*'      | '5'         | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | '36/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                           | 'Expense'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                           | 'Expense'     | '*'      | '10'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                           | 'Expense'     | '*'      | '50'        | '$$PurchaseOrder0292012$$' | '$$GoodsReceipt029203$$' | 'M/White'   | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''                          | ''          | ''                  | ''                   | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''          | ''                  | ''                   | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'            | 'Partner'   | 'Legal name'        | 'Partner term'       | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '3 081,6'   | 'Main Company' | '$$PurchaseInvoice029204$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '18 000'    | 'Main Company' | '$$PurchaseInvoice029204$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '18 000'    | 'Main Company' | '$$PurchaseInvoice029204$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '18 000'    | 'Main Company' | '$$PurchaseInvoice029204$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"'            | ''            | ''          | ''                     | ''                         | ''                          | ''                          | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'               | ''                          | ''                          | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'             | 'Store'                    | 'Order'                     | 'Item key'                  | 'Row key'           | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'         | '5'                    | 'Store 02'                 | '$$PurchaseOrder0292012$$'  | '36/Yellow'                 | '*'                 | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'         | '10'                   | 'Store 02'                 | '$$PurchaseOrder0292012$$'  | 'XS/Blue'                   | '*'                 | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'         | '10'                   | 'Store 02'                 | '$$PurchaseOrder0292012$$'  | '38/Yellow'                 | '*'                 | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'         | '50'                   | 'Store 02'                 | '$$PurchaseOrder0292012$$'  | 'M/White'                   | '*'                 | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		And I close all client application windows

Scenario: _029205 create Shipment confirmation based on Sales order, procurement method - purchase (Shipment confirmation before Sales invoice, store use Shipment confirmation)
	* Create Shipment confirmation based on Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292012$$'  |
		And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
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
	* Check movements
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$ShipmentConfirmation029205$$' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' |
		| ''                               | 'Expense'     | '*'      | '5'         | 'Main Company' | '36/Yellow' | '' | '' | '' | '' |
		| ''                               | 'Expense'     | '*'      | '10'        | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                               | 'Expense'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' |
		And I select "Goods in transit outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'        | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'   | '$$SalesOrder0292012$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292012$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Shipment orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment orders"' | ''            | ''       | ''          | ''                      | ''                               | ''          | ''        | '' | '' |
		| ''                            | 'Record type' | 'Period' | 'Resources' | 'Dimensions'            | ''                               | ''          | ''        | '' | '' |
		| ''                            | ''            | ''       | 'Quantity'  | 'Order'                 | 'Shipment confirmation'          | 'Item key'  | 'Row key' | '' | '' |
		| ''                            | 'Receipt'     | '*'      | '5'         | '$$SalesOrder0292012$$' | '$$ShipmentConfirmation029205$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                            | 'Receipt'     | '*'      | '10'        | '$$SalesOrder0292012$$' | '$$ShipmentConfirmation029205$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                            | 'Receipt'     | '*'      | '10'        | '$$SalesOrder0292012$$' | '$$ShipmentConfirmation029205$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment confirmation schedule"' | ''            | ''       | ''          | ''                      | ''                               | ''          | ''          | ''        | ''              |
		| ''                                           | 'Record type' | 'Period' | 'Resources' | 'Dimensions'            | ''                               | ''          | ''          | ''        | 'Attributes'    |
		| ''                                           | ''            | ''       | 'Quantity'  | 'Company'               | 'Order'                          | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                           | 'Expense'     | '*'      | '5'         | 'Main Company'          | '$$SalesOrder0292012$$'          | 'Store 02'  | '36/Yellow' | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company'          | '$$SalesOrder0292012$$'          | 'Store 02'  | 'XS/Blue'   | '*'       | '*'             |
		| ''                                           | 'Expense'     | '*'      | '10'        | 'Main Company'          | '$$SalesOrder0292012$$'          | 'Store 02'  | '38/Yellow' | '*'       | '*'             |
		And I close all client application windows

Scenario: _029206 create Sales invoice based on Sales order, procurement method - purchase (Shipment confirmation before Sales invoice, store use Shipment confirmation)
	* Create Sales invoice based on Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| Number |
			| $$NumberSalesOrder0292012$$   |
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
		And I click the button named "FormSelectAll"
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
	* Check movements Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
		| Number |
		| $$NumberSalesInvoice0292012$$    |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice0292012$$'             | ''            | ''       | ''          | ''             | ''                        | ''          | ''                  | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                        | ''          | ''                  | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                        | ''          | ''                  | ''                         | ''         | ''                             | ''                     | '' | '' |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''          | ''                  | ''                         | ''         | ''                             | 'Attributes'           | '' | '' |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'          | 'Partner'   | 'Legal name'        | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '1 917,44'  | 'Main Company' | '$$SalesInvoice0292012$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 200'    | 'Main Company' | '$$SalesInvoice0292012$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 200'    | 'Main Company' | '$$SalesInvoice0292012$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 200'    | 'Main Company' | '$$SalesInvoice0292012$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Order reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                        | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
			| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'              | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
			| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'                | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                            | '*'      | '52,23'     | '52,23'         | '290,17'     | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '104,46'    | '104,46'        | '580,34'     | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '135,8'     | '135,8'         | '754,44'     | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '793,22'    | '793,22'        | '4 406,78'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '793,22'    | '793,22'        | '4 406,78'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '793,22'    | '793,22'        | '4 406,78'   | '$$SalesInvoice0292012$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''                        | ''         | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''                        | ''         | '' | '' |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document'          | 'Currency' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '11 200'         | 'Main Company' | 'Ferron BP' | 'Company Ferron BP' | '$$SalesInvoice0292012$$' | 'TRY'      | '' | '' |
		And I select "Sales turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Sales turnovers"' | ''       | ''          | ''       | ''           | ''              | ''             | ''                        | ''         | ''          | ''        | ''                             | ''                  | ''                     |
			| ''                            | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''         | ''          | ''        | ''                             | ''                  | 'Attributes'           |
			| ''                            | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Sales invoice'           | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
			| ''                            | '*'      | '5'         | '342,4'  | '290,17'     | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'USD'      | '36/Yellow' | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | '36/Yellow' | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | '36/Yellow' | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | '36/Yellow' | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '684,8'  | '580,34'     | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '890,24' | '754,44'     | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '5 200'  | '4 406,78'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '5 200'  | '4 406,78'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '5 200'  | '4 406,78'   | ''              | 'Main Company' | '$$SalesInvoice0292012$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | ''                  | 'No'                   |
		And I select "Shipment orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Shipment orders"' | ''            | ''       | ''          | ''                      | ''                               | ''          | ''        | '' | '' | '' | '' | '' | '' |
			| ''                            | 'Record type' | 'Period' | 'Resources' | 'Dimensions'            | ''                               | ''          | ''        | '' | '' | '' | '' | '' | '' |
			| ''                            | ''            | ''       | 'Quantity'  | 'Order'                 | 'Shipment confirmation'          | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
			| ''                            | 'Expense'     | '*'      | '5'         | '$$SalesOrder0292012$$' | '$$ShipmentConfirmation029205$$' | '36/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                            | 'Expense'     | '*'      | '10'        | '$$SalesOrder0292012$$' | '$$ShipmentConfirmation029205$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                            | 'Expense'     | '*'      | '10'        | '$$SalesOrder0292012$$' | '$$ShipmentConfirmation029205$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '11 200'    | 'Main Company' | 'Company Ferron BP' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Revenues turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Revenues turnovers"' | ''       | ''          | ''             | ''              | ''             | ''          | ''         | ''                    | ''                             | ''                     | '' | '' | '' |
			| ''                               | 'Period' | 'Resources' | 'Dimensions'   | ''              | ''             | ''          | ''         | ''                    | ''                             | 'Attributes'           | '' | '' | '' |
			| ''                               | ''       | 'Amount'    | 'Company'      | 'Business unit' | 'Revenue type' | 'Item key'  | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
			| ''                               | '*'      | '290,17'    | 'Main Company' | ''              | ''             | '36/Yellow' | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '580,34'    | 'Main Company' | ''              | ''             | '38/Yellow' | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '754,44'    | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | '36/Yellow' | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | '36/Yellow' | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | '36/Yellow' | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '4 406,78'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '4 406,78'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '4 406,78'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Order balance"'            | ''            | ''          | ''                     | ''                 | ''                           | ''               | ''                   | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'       | ''                           | ''               | ''                   | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                     | ''            | ''          | 'Quantity'             | 'Store'            | 'Order'                      | 'Item key'       | 'Row key'            | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'         | '5'                    | 'Store 02'         | '$$SalesOrder0292012$$'           | '36/Yellow'      | '*'                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'                   | 'Store 02'         | '$$SalesOrder0292012$$'           | 'XS/Blue'        | '*'                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'         | '10'                   | 'Store 02'         | '$$SalesOrder0292012$$'           | '38/Yellow'      | '*'                  | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows



# Sales order - Purchase order - Purchase invoice- Goods receipt - Sales invoice - Shipment confirmation 

Scenario: _029207 create Purchase order based on Sales order (Purchase invoice before Goods receipt, Sales order contains services and products)
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
	* Add service
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Service    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item     | Item key  |
			| Service  | Rent |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
	* Post Sales order
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder0292071$$" variable
		And I delete "$$SalesOrder0292071$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder0292071$$"
		And I save the window as "$$SalesOrder0292071$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesOrder0292071$$'    |
		And I click "Registrations report" button
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder0292071$$'          | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| 'Register  "Order reservation"'  | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '1'         | 'Store 01'   | '36/18SD'   | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' | '' |
		And I select "Order procurement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order procurement"' | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''         | ''          | ''        | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Row key' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '1'         | 'Store 01'   | '36/18SD'  | '' | '' | '' | '' | '' |
		And I select "Sales order turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Sales order turnovers"' | ''       | ''          | ''       | ''             | ''                      | ''         | ''          | ''        | ''                             | ''                     |
		| ''                                  | 'Period' | 'Resources' | ''       | 'Dimensions'   | ''                      | ''         | ''          | ''        | ''                             | 'Attributes'           |
		| ''                                  | ''       | 'Quantity'  | 'Amount' | 'Company'      | 'Sales order'           | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                  | '*'      | '1'         | '119,84' | 'Main Company' | '$$SalesOrder0292071$$' | 'USD'      | '36/18SD'   | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '1'         | '700'    | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | '36/18SD'   | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '1'         | '700'    | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | '36/18SD'   | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '1'         | '700'    | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | '36/18SD'   | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '5'         | '445,12' | 'Main Company' | '$$SalesOrder0292071$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 600'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 600'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 600'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '342,4'  | 'Main Company' | '$$SalesOrder0292071$$' | 'USD'      | 'Rent'      | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '684,8'  | 'Main Company' | '$$SalesOrder0292071$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '2 000'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | 'Rent'      | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '2 000'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | 'Rent'      | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '2 000'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | 'Rent'      | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292071$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'  | 'Row key' | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '1'         | 'Store 01'   | '$$SalesOrder0292071$$' | '36/18SD'   | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 01'   | '$$SalesOrder0292071$$' | 'XS/Blue'   | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$SalesOrder0292071$$' | '38/Yellow' | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '$$SalesOrder0292071$$' | 'Rent'      | '*'       | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                      | ''          | ''          | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01'  | '36/18SD'   | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01'  | 'XS/Blue'   | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01'  | '38/Yellow' | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01'  | 'Rent'      | '*'       | '*'                            | ''                     |
		And I close all client application windows
	* Create one more Sales order with procurement methot - purchase
		When create an order for Ferron BP Basic Partner term, TRY (Dress -10 and Trousers - 5)
		* Change of Store to Store that use Shipment confirmation
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| Description |
				| Store 02    |
			And I select current line in "List" table
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
		* Add service
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Service    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key  |
				| Service  | Rent |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "300,00" text in "Price" field of "ItemList" table
	* Post Sales order
			And I click the button named "FormPost"
			And I delete "$$NumberSalesOrder0292072$$" variable
			And I delete "$$SalesOrder0292072$$" variable
			And I save the value of "Number" field as "$$NumberSalesOrder0292072$$"
			And I save the window as "$$SalesOrder0292072$$"
			And I click the button named "FormPostAndClose"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesOrder0292072$$'   |
		And I click "Registrations report" button
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder0292072$$'          | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| 'Register  "Order reservation"'  | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' | '' |
		And I select "Order procurement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order procurement"' | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''         | ''          | ''        | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Row key' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02' | '36/Yellow' | '*'       | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02' | '38/Yellow' | '*'       | '' | '' |
		And I select "Sales order turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Sales order turnovers"' | ''       | ''          | ''       | ''             | ''                      | ''         | ''          | ''        | ''                             | ''                     |
		| ''                                  | 'Period' | 'Resources' | ''       | 'Dimensions'   | ''                      | ''         | ''          | ''        | ''                             | 'Attributes'           |
		| ''                                  | ''       | 'Quantity'  | 'Amount' | 'Company'      | 'Sales order'           | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                  | '*'      | '1'         | '51,36'  | 'Main Company' | '$$SalesOrder0292072$$' | 'USD'      | 'Rent'      | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '1'         | '300'    | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | 'Rent'      | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '1'         | '300'    | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | 'Rent'      | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '1'         | '300'    | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | 'Rent'      | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '5'         | '342,4'  | 'Main Company' | '$$SalesOrder0292072$$' | 'USD'      | '36/Yellow' | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 000'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | '36/Yellow' | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 000'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | '36/Yellow' | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '5'         | '2 000'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | '36/Yellow' | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '684,8'  | 'Main Company' | '$$SalesOrder0292072$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '890,24' | 'Main Company' | '$$SalesOrder0292072$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '4 000'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   |
		| ''                                  | '*'      | '10'        | '5 200'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                  | '*'      | '10'        | '5 200'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   |
		| ''                                  | '*'      | '10'        | '5 200'  | 'Main Company' | '$$SalesOrder0292072$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'  | 'Row key' | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '1'         | 'Store 02'   | '$$SalesOrder0292072$$' | 'Rent'      | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$SalesOrder0292072$$' | '36/Yellow' | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292072$$' | 'XS/Blue'   | '*'       | '' | '' | '' |
		| ''                          | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292072$$' | '38/Yellow' | '*'       | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                      | ''          | ''          | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                      | ''          | ''          | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'     | 'Item key'  | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02'  | 'Rent'      | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '5'         | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02'  | '36/Yellow' | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02'  | 'XS/Blue'   | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02'  | '38/Yellow' | '*'       | '*'                            | ''                     |

		And I close all client application windows
	* Create Purchase order based on Sales orders
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
		| 'Number'                      | 'Partner'  |
		| '$$NumberSalesOrder0292071$$' | 'Lomaniti' |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseOrderGeneratePurchaseOrder"
	* Check the filling of the tabular part of the Purchase order
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    | 'Unit' | 'Q'      | 'Purchase basis'        |
		| 'Dress'    | 'XS/Blue'   | 'Store 01' | 'pcs'  | '5,000'  | '$$SalesOrder0292071$$' |
		| 'Trousers' | '38/Yellow' | 'Store 01' | 'pcs'  | '10,000' | '$$SalesOrder0292071$$' |
		| 'Dress'    | 'XS/Blue'   | 'Store 02' | 'pcs'  | '10,000' | '$$SalesOrder0292072$$' |
		| 'Trousers' | '36/Yellow' | 'Store 02' | 'pcs'  | '5,000'  | '$$SalesOrder0292072$$' |
		| 'Trousers' | '38/Yellow' | 'Store 02' | 'pcs'  | '10,000' | '$$SalesOrder0292072$$' |
	* Filling in vendor and prices
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
		# message about prices
		And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
		And I change checkbox "Do you want to update filled prices?"
		And I click "OK" button
		# message about prices
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
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseOrder0292073$$" variable
	And I delete "$$PurchaseOrder0292073$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseOrder0292073$$"
	And I save the window as "$$PurchaseOrder0292073$$"
	And I click the button named "FormPostAndClose"
	* Check movements Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder0292073$$'    |
		And I click "Registrations report" button
		And I select "Order procurement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseOrder0292073$$'       | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' |
		| 'Register  "Order procurement"'  | ''            | ''       | ''          | ''             | ''                      | ''         | ''          | ''        | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                      | ''         | ''          | ''        | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                 | 'Store'    | 'Item key'  | 'Row key' | '' |
		| ''                               | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01' | 'XS/Blue'   | '*'       | '' |
		| ''                               | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02' | '36/Yellow' | '*'       | '' |
		| ''                               | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292071$$' | 'Store 01' | '38/Yellow' | '*'       | '' |
		| ''                               | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02' | 'XS/Blue'   | '*'       | '' |
		| ''                               | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$SalesOrder0292072$$' | 'Store 02' | '38/Yellow' | '*'       | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                         | ''         | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''         | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                    | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 01' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 01' | '38/Yellow' | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"'          | ''            | ''       | ''          | ''             | ''                         | ''          | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''          | ''          | ''        | ''              |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Store'        | 'Order'                    | 'Item key'  | 'Row key'   | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Store 01'     | '$$PurchaseOrder0292073$$' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Store 02'     | '$$PurchaseOrder0292073$$' | '36/Yellow' | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Store 01'     | '$$PurchaseOrder0292073$$' | '38/Yellow' | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$PurchaseOrder0292073$$' | 'XS/Blue'   | '*'         | ''        | ''              |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '$$PurchaseOrder0292073$$' | '38/Yellow' | '*'         | ''        | ''              |
		And I close all client application windows

Scenario: _029208 create Purchase invoice based on Purchase order (Purchase invoice before Goods receipt, products)
	* Create Purchase invoice based on Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder0292073$$'   |
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	* Check filling of the tabular part
		And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      |'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date'| 'Purchase order'           | 'Sales order'           |
			| '847,46'     | 'Dress'    | '200,00' | 'XS/Blue'   | '5,000'  |'152,54'     | 'pcs'  | '1 000,00'     | 'Store 01' | '*'            | '$$PurchaseOrder0292073$$' | '$$SalesOrder0292071$$' |
			| '1 694,92'   | 'Dress'    | '200,00' | 'XS/Blue'   | '10,000' |'305,08'     | 'pcs'  | '2 000,00'     | 'Store 02' | '*'            | '$$PurchaseOrder0292073$$' | '$$SalesOrder0292072$$' |
			| '762,71'     | 'Trousers' | '180,00' | '36/Yellow' | '5,000'  |'137,29'     | 'pcs'  | '900,00'       | 'Store 02' | '*'            | '$$PurchaseOrder0292073$$' | '$$SalesOrder0292072$$' |
			| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' |'274,58'     | 'pcs'  | '1 800,00'     | 'Store 01' | '*'            | '$$PurchaseOrder0292073$$' | '$$SalesOrder0292071$$' |
			| '1 525,42'   | 'Trousers' | '180,00' | '38/Yellow' | '10,000' |'274,58'     | 'pcs'  | '1 800,00'     | 'Store 02' | '*'            | '$$PurchaseOrder0292073$$' | '$$SalesOrder0292072$$' |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice0292008$$" variable
		And I delete "$$PurchaseInvoice0292008$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice0292008$$"
		And I save the window as "$$PurchaseInvoice0292008$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice0292008$$'    |
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice0292008$$'     | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '5'         | 'Main Company' | '36/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Purchase turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Purchase turnovers"' | ''       | ''          | ''       | ''           | ''             | ''                           | ''         | ''          | ''        | ''                             | ''                     | '' | '' |
		| ''                               | 'Period' | 'Resources' | ''       | ''           | 'Dimensions'   | ''                           | ''         | ''          | ''        | ''                             | 'Attributes'           | '' | '' |
		| ''                               | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Purchase invoice'           | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                               | '*'      | '5'         | '154,08' | '130,58'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'USD'      | '36/Yellow' | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '171,2'  | '145,09'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '900'    | '762,71'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '36/Yellow' | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '900'    | '762,71'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '36/Yellow' | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '900'    | '762,71'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '36/Yellow' | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '1 000'  | '847,46'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '1 000'  | '847,46'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '5'         | '1 000'  | '847,46'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '308,16' | '261,15'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '308,16' | '261,15'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '342,4'  | '290,17'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'  | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'  | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'  | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'  | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'  | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '1 800'  | '1 525,42'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '2 000'  | '1 694,92'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '2 000'  | '1 694,92'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '10'        | '2 000'  | '1 694,92'   | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                           | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
		| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'                 | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
		| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'                   | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                            | '*'      | '23,5'      | '23,5'          | '130,58'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '26,11'     | '26,11'         | '145,09'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '47,01'     | '47,01'         | '261,15'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '47,01'     | '47,01'         | '261,15'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '52,23'     | '52,23'         | '290,17'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '137,29'    | '137,29'        | '762,71'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '137,29'    | '137,29'        | '762,71'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '137,29'    | '137,29'        | '762,71'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '152,54'    | '152,54'        | '847,46'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '152,54'    | '152,54'        | '847,46'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '152,54'    | '152,54'        | '847,46'     | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '274,58'    | '274,58'        | '1 525,42'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$PurchaseInvoice0292008$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		And I select "Goods in transit incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                           | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                           | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'              | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseInvoice0292008$$' | '36/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseInvoice0292008$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseInvoice0292008$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''                           | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''                           | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document'             | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | '7 500'          | ''                       | ''               | 'Main Company' | 'Ferron BP' | 'Company Ferron BP' | '$$PurchaseInvoice0292008$$' | 'TRY'      | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Expense'     | '*'      | '7 500'     | 'Main Company' | 'Company Ferron BP' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                         | ''         | ''          | ''        | ''              | '' | '' | '' | '' |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                         | ''         | ''          | ''        | 'Attributes'    | '' | '' | '' | '' |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                    | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 01' | 'XS/Blue'   | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 01' | '38/Yellow' | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseOrder0292073$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''                           | ''          | ''                  | ''                   | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                           | ''          | ''                  | ''                   | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'             | 'Partner'   | 'Legal name'        | 'Partner term'       | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '1 284'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '7 500'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '7 500'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '7 500'     | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                         | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                         | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                    | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '5'         | 'Store 01'   | '$$PurchaseOrder0292073$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseOrder0292073$$' | '36/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 01'   | '$$PurchaseOrder0292073$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292073$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseOrder0292073$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'             | ''            | ''          | ''                     | ''               | ''                           | ''                           | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                           | ''                           | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'                   | ''                           | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '5'                    | 'Store 01'       | 'XS/Blue'                    | ''                           | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                      | 'Receipt'     | '*'         | '10'                   | 'Store 01'       | '38/Yellow'                  | ''                           | ''                  | ''                   | ''                        | ''                             | ''                     | ''                             | ''                     |

	And I close all client application windows

Scenario: _029209 create Goods receipt based on Purchase invoice (Purchase invoice before Goods receipt, products)
	* Create Goods receipt based on Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice0292008$$'  |
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
	* Check filling of the tabular part
		And "ItemList" table contains lines
		| 'Item'     | 'Quantity' | 'Item key'  | 'Unit' | 'Sales order'      | 'Store'    | 'Receipt basis'         |
		| 'Dress'    | '10,000'   | 'XS/Blue'   | 'pcs'  | '$$SalesOrder0292072$$' | 'Store 02' | '$$PurchaseInvoice0292008$$' |
		| 'Trousers' | '5,000'    | '36/Yellow' | 'pcs'  | '$$SalesOrder0292072$$' | 'Store 02' | '$$PurchaseInvoice0292008$$' |
		| 'Trousers' | '10,000'   | '38/Yellow' | 'pcs'  | '$$SalesOrder0292072$$' | 'Store 02' | '$$PurchaseInvoice0292008$$' |
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt0292009$$" variable
		And I delete "$$GoodsReceipt0292009$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt0292009$$"
		And I save the window as "$$GoodsReceipt0292009$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberGoodsReceipt0292009$$'    |
		And I click "Registrations report" button
		And I select "Goods in transit incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$GoodsReceipt0292009$$'               | ''            | ''       | ''          | ''           | ''                           | ''          | ''        | '' | '' |
		| 'Document registrations records'        | ''            | ''       | ''          | ''           | ''                           | ''          | ''        | '' | '' |
		| 'Register  "Goods in transit incoming"' | ''            | ''       | ''          | ''           | ''                           | ''          | ''        | '' | '' |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                           | ''          | ''        | '' | '' |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Receipt basis'              | 'Item key'  | 'Row key' | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '5'         | 'Store 02'   | '$$PurchaseInvoice0292008$$' | '36/Yellow' | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseInvoice0292008$$' | 'XS/Blue'   | '*'       | '' | '' |
		| ''                                      | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$PurchaseInvoice0292008$$' | '38/Yellow' | '*'       | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                           | ''         | ''          | ''        | ''              |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                           | ''         | ''          | ''        | 'Attributes'    |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                      | 'Store'    | 'Item key'  | 'Row key' | 'Delivery date' |
		| ''                                   | 'Expense'     | '*'      | '5'         | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Store 02' | '36/Yellow' | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Store 02' | 'XS/Blue'   | '*'       | '*'             |
		| ''                                   | 'Expense'     | '*'      | '10'        | 'Main Company' | '$$PurchaseInvoice0292008$$' | 'Store 02' | '38/Yellow' | '*'       | '*'             |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'             | ''            | ''       | ''          | ''             | ''                           | ''          | ''          | ''        | ''              |
		| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                           | ''          | ''          | ''        | ''              |
		| ''                                      | ''            | ''       | 'Quantity'  | 'Store'        | 'Item key'                   | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'     | '36/Yellow'                  | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | 'XS/Blue'                    | ''          | ''          | ''        | ''              |
		| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'     | '38/Yellow'                  | ''          | ''          | ''        | ''              |

Scenario: _029210 create Sales invoice based on Sales orders (purchase has already been made) - Store does not use Shipment confirmation
	* Create Sales invoice based on Sales order 460
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292071$$'  |
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	* Check filling of the tabular part
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'      |
		| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '5,000'  | '396,61'     | 'pcs'  | '2 203,39'   | '2 600,00'     | 'Store 01' | '$$SalesOrder0292071$$' |
		| '700,00' | 'Boots'    | '18%' | '36/18SD'   | '1,000'  | '106,78'     | 'pcs'  | '593,22'     | '700,00'       | 'Store 01' | '$$SalesOrder0292071$$' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '10,000' | '610,17'     | 'pcs'  | '3 389,83'   | '4 000,00'     | 'Store 01' | '$$SalesOrder0292071$$' |
		| '200,00' | 'Service'  | '18%' | 'Rent'      | '10,000' | '305,08'     | 'pcs'  | '1 694,92'   | '2 000,00'     | 'Store 01' | '$$SalesOrder0292071$$' |
	* Post Sales invoice
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice0292010$$" variable
		And I delete "$$SalesInvoice0292010$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice0292010$$"
		And I save the window as "$$SalesInvoice0292010$$"
		And I click the button named "FormPostAndClose"
	* Check movements Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice0292010$$'   |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesInvoice0292010$$'             | ''            | ''       | ''          | ''             | ''                        | ''         | ''                 | ''                         | ''         | ''                             | ''                     | '' | '' |
		| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                        | ''         | ''                 | ''                         | ''         | ''                             | ''                     | '' | '' |
		| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                        | ''         | ''                 | ''                         | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                        | ''         | ''                 | ''                         | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'          | 'Partner'  | 'Legal name'       | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '1 592,16'  | 'Main Company' | '$$SalesInvoice0292010$$' | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '9 300'     | 'Main Company' | '$$SalesInvoice0292010$$' | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '9 300'     | 'Main Company' | '$$SalesInvoice0292010$$' | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '9 300'     | 'Main Company' | '$$SalesInvoice0292010$$' | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Inventory balance"' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '1'         | 'Main Company' | '36/18SD'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '1'         | 'Store 01'   | '36/18SD'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Expense'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                        | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
		| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'              | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
		| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'                | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                            | '*'      | '18,28'     | '18,28'         | '101,56'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '52,23'     | '52,23'         | '290,17'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '67,9'      | '67,9'          | '377,22'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '104,46'    | '104,46'        | '580,34'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '106,78'    | '106,78'        | '593,22'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '106,78'    | '106,78'        | '593,22'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '106,78'    | '106,78'        | '593,22'     | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '396,61'    | '396,61'        | '2 203,39'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '396,61'    | '396,61'        | '2 203,39'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '396,61'    | '396,61'        | '2 203,39'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice0292010$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''         | ''                 | ''                        | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''         | ''                 | ''                        | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'  | 'Legal name'       | 'Basis document'          | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '9 300'          | 'Main Company' | 'Lomaniti' | 'Company Lomaniti' | '$$SalesInvoice0292010$$' | 'TRY'      | '' | '' |
		And I select "Sales turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Sales turnovers"' | ''       | ''          | ''       | ''           | ''              | ''             | ''                        | ''         | ''          | ''        | ''                             | ''                  | ''                     |
		| ''                            | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                        | ''         | ''          | ''        | ''                             | ''                  | 'Attributes'           |
		| ''                            | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Sales invoice'           | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
		| ''                            | '*'      | '1'         | '119,84' | '101,56'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'USD'      | '36/18SD'   | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                            | '*'      | '1'         | '700'    | '593,22'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | '36/18SD'   | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                            | '*'      | '1'         | '700'    | '593,22'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | '36/18SD'   | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                            | '*'      | '1'         | '700'    | '593,22'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | '36/18SD'   | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                            | '*'      | '5'         | '445,12' | '377,22'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                            | '*'      | '5'         | '2 600'  | '2 203,39'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                            | '*'      | '5'         | '2 600'  | '2 203,39'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                            | '*'      | '5'         | '2 600'  | '2 203,39'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '342,4'  | '290,17'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'USD'      | 'Rent'      | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '684,8'  | '580,34'     | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | 'Rent'      | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | 'Rent'      | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | 'Rent'      | '*'       | 'TRY'                          | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | ''                  | 'No'                   |
		| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice0292010$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | ''                  | 'No'                   |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'       | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Receipt'     | '*'      | '9 300'     | 'Main Company' | 'Company Lomaniti' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Revenues turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Revenues turnovers"' | ''       | ''          | ''             | ''              | ''             | ''          | ''         | ''                    | ''                             | ''                     | '' | '' | '' |
		| ''                               | 'Period' | 'Resources' | 'Dimensions'   | ''              | ''             | ''          | ''         | ''                    | ''                             | 'Attributes'           | '' | '' | '' |
		| ''                               | ''       | 'Amount'    | 'Company'      | 'Business unit' | 'Revenue type' | 'Item key'  | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
		| ''                               | '*'      | '101,56'    | 'Main Company' | ''              | ''             | '36/18SD'   | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '290,17'    | 'Main Company' | ''              | ''             | 'Rent'      | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '377,22'    | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '580,34'    | 'Main Company' | ''              | ''             | '38/Yellow' | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '593,22'    | 'Main Company' | ''              | ''             | '36/18SD'   | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '593,22'    | 'Main Company' | ''              | ''             | '36/18SD'   | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '593,22'    | 'Main Company' | ''              | ''             | '36/18SD'   | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | 'Rent'      | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | 'Rent'      | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | 'Rent'      | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '2 203,39'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '2 203,39'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '2 203,39'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
		| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' | '' | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '1'         | 'Store 01'   | '$$SalesOrder0292071$$' | '36/18SD'   | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '5'         | 'Store 01'   | '$$SalesOrder0292071$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 01'   | '$$SalesOrder0292071$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 01'   | '$$SalesOrder0292071$$' | 'Rent'      | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '1'         | 'Store 01'   | '36/18SD'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '5'         | 'Store 01'   | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                          | 'Expense'     | '*'      | '10'        | 'Store 01'   | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                        | ''               | ''                        | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                        | ''               | ''                        | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                   | 'Store'          | 'Item key'                | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '1'                    | 'Main Company'   | '$$SalesOrder0292071$$'   | 'Store 01'       | '36/18SD'                 | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder0292071$$'   | 'Store 01'       | 'XS/Blue'                 | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'                   | 'Main Company'   | '$$SalesOrder0292071$$'   | 'Store 01'       | '38/Yellow'               | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'                   | 'Main Company'   | '$$SalesOrder0292071$$'   | 'Store 01'       | 'Rent'                    | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows

Scenario: _029211 create Sales invoice based on Sales orders (purchase has already been made) - Store use Shipment confirmation
	* Create Sales invoice for Sales order 461
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292072$$'  |
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	* Check filling of the tabular part
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'      | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    |
		| '520,00' | 'Dress'    | '18%' | 'XS/Blue'   | '10,000' | '793,22'     | 'pcs'  | '4 406,78'   | '5 200,00'     | 'Store 02' |
		| '400,00' | 'Trousers' | '18%' | '36/Yellow' | '5,000'  | '305,08'     | 'pcs'  | '1 694,92'   | '2 000,00'     | 'Store 02' |
		| '400,00' | 'Trousers' | '18%' | '38/Yellow' | '10,000' | '610,17'     | 'pcs'  | '3 389,83'   | '4 000,00'     | 'Store 02' |
		| '300,00' | 'Service'  | '18%' | 'Rent'      | '1,000'  | '45,76'      | 'pcs'  | '254,24'     | '300,00'       | 'Store 02' |
	* Post Sales invoice
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029211$$" variable
		And I delete "$$SalesInvoice029211$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029211$$"
		And I save the window as "$$SalesInvoice029211$$"
		And I click the button named "FormPostAndClose"
	* Check movements Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberSalesInvoice029211$$'    |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice029211$$'              | ''            | ''       | ''          | ''             | ''                       | ''          | ''                  | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''                       | ''          | ''                  | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''                       | ''          | ''                  | ''                         | ''         | ''                             | ''                     | '' | '' |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                       | ''          | ''                  | ''                         | ''         | ''                             | 'Attributes'           | '' | '' |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document'         | 'Partner'   | 'Legal name'        | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '1 968,8'   | 'Main Company' | '$$SalesInvoice029211$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 500'    | 'Main Company' | '$$SalesInvoice029211$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 500'    | 'Main Company' | '$$SalesInvoice029211$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 500'    | 'Main Company' | '$$SalesInvoice029211$$' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Inventory balance"' | ''            | ''       | ''          | ''             | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '5'         | 'Main Company' | '36/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Main Company' | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Goods in transit outgoing" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Goods in transit outgoing"' | ''            | ''       | ''          | ''           | ''                       | ''          | ''        | '' | '' | '' | '' | '' | '' |
			| ''                                      | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                       | ''          | ''        | '' | '' | '' | '' | '' | '' |
			| ''                                      | ''            | ''       | 'Quantity'  | 'Store'      | 'Shipment basis'         | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '5'         | 'Store 02'   | '$$SalesInvoice029211$$' | '36/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesInvoice029211$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                                      | 'Receipt'     | '*'      | '10'        | 'Store 02'   | '$$SalesInvoice029211$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Order reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Order reservation"' | ''            | ''       | ''          | ''           | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''          | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key'  | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '5'         | 'Store 02'   | '36/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | 'XS/Blue'   | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '10'        | 'Store 02'   | '38/Yellow' | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                       | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
			| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'             | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
			| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'               | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                            | '*'      | '7,83'      | '7,83'          | '43,53'      | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '45,76'     | '45,76'         | '254,24'     | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '45,76'     | '45,76'         | '254,24'     | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '45,76'     | '45,76'         | '254,24'     | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '52,23'     | '52,23'         | '290,17'     | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '104,46'    | '104,46'        | '580,34'     | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '135,8'     | '135,8'         | '754,44'     | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '305,08'    | '305,08'        | '1 694,92'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '610,17'    | '610,17'        | '3 389,83'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '793,22'    | '793,22'        | '4 406,78'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                            | '*'      | '793,22'    | '793,22'        | '4 406,78'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '793,22'    | '793,22'        | '4 406,78'   | '$$SalesInvoice029211$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''                       | ''         | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''                       | ''         | '' | '' |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document'         | 'Currency' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '11 500'         | 'Main Company' | 'Ferron BP' | 'Company Ferron BP' | '$$SalesInvoice029211$$' | 'TRY'      | '' | '' |
		And I select "Sales turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Sales turnovers"' | ''       | ''          | ''       | ''           | ''              | ''             | ''                       | ''         | ''          | ''        | ''                             | ''                  | ''                     |
			| ''                            | 'Period' | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                       | ''         | ''          | ''        | ''                             | ''                  | 'Attributes'           |
			| ''                            | ''       | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Sales invoice'          | 'Currency' | 'Item key'  | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
			| ''                            | '*'      | '1'         | '51,36'  | '43,53'      | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'USD'      | 'Rent'      | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '1'         | '300'    | '254,24'     | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | 'Rent'      | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '1'         | '300'    | '254,24'     | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | 'Rent'      | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '1'         | '300'    | '254,24'     | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | 'Rent'      | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '342,4'  | '290,17'     | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'USD'      | '36/Yellow' | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | '36/Yellow' | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | '36/Yellow' | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '5'         | '2 000'  | '1 694,92'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | '36/Yellow' | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '684,8'  | '580,34'     | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'USD'      | '38/Yellow' | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '890,24' | '754,44'     | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'USD'      | 'XS/Blue'   | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | '38/Yellow' | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | '38/Yellow' | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '4 000'  | '3 389,83'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | '38/Yellow' | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '5 200'  | '4 406,78'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '5 200'  | '4 406,78'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '10'        | '5 200'  | '4 406,78'   | ''              | 'Main Company' | '$$SalesInvoice029211$$' | 'TRY'      | 'XS/Blue'   | '*'       | 'TRY'                          | ''                  | 'No'                   |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '11 500'    | 'Main Company' | 'Company Ferron BP' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Revenues turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Revenues turnovers"' | ''       | ''          | ''             | ''              | ''             | ''          | ''         | ''                    | ''                             | ''                     | '' | '' | '' |
			| ''                               | 'Period' | 'Resources' | 'Dimensions'   | ''              | ''             | ''          | ''         | ''                    | ''                             | 'Attributes'           | '' | '' | '' |
			| ''                               | ''       | 'Amount'    | 'Company'      | 'Business unit' | 'Revenue type' | 'Item key'  | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
			| ''                               | '*'      | '43,53'     | 'Main Company' | ''              | ''             | 'Rent'      | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '254,24'    | 'Main Company' | ''              | ''             | 'Rent'      | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '254,24'    | 'Main Company' | ''              | ''             | 'Rent'      | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '254,24'    | 'Main Company' | ''              | ''             | 'Rent'      | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '290,17'    | 'Main Company' | ''              | ''             | '36/Yellow' | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '580,34'    | 'Main Company' | ''              | ''             | '38/Yellow' | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '754,44'    | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | '36/Yellow' | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | '36/Yellow' | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '1 694,92'  | 'Main Company' | ''              | ''             | '36/Yellow' | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '3 389,83'  | 'Main Company' | ''              | ''             | '38/Yellow' | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '4 406,78'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '4 406,78'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '4 406,78'  | 'Main Company' | ''              | ''             | 'XS/Blue'   | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
		And I select "Order balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Order balance"' | ''            | ''       | ''          | ''           | ''                      | ''          | ''        | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''                      | ''          | ''        | '' | '' | '' | '' | '' | '' |
			| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Order'                 | 'Item key'  | 'Row key' | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Expense'     | '*'      | '1'         | 'Store 02'   | '$$SalesOrder0292072$$' | 'Rent'      | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Expense'     | '*'      | '5'         | 'Store 02'   | '$$SalesOrder0292072$$' | '36/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292072$$' | 'XS/Blue'   | '*'       | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Expense'     | '*'      | '10'        | 'Store 02'   | '$$SalesOrder0292072$$' | '38/Yellow' | '*'       | '' | '' | '' | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                       | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                       | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'               | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '1'                    | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | 'Rent'                   | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | '36/Yellow'              | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '10'                   | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | 'XS/Blue'                | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '10'                   | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | '38/Yellow'              | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Expense'     | '*'         | '1'                    | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | 'Rent'                   | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Expense'     | '*'         | '5'                    | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | '36/Yellow'              | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'                   | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | 'XS/Blue'                | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Expense'     | '*'         | '10'                   | 'Main Company'   | '$$SalesOrder0292072$$'  | 'Store 02'       | '38/Yellow'              | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows



# To Do align movements and add tests below

# Sales order (№501) - Purchase order- Purchase invoice - Goods receipt - Shipment confirmation - Sales invoice

Scenario: _029221 Sales order - Purchase order - Purchase invoice - Goods receipt - Shipment confirmation - Sales invoice
	* Create Purchase order based on Sales order №501
		* Select Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesOrder0292001$$'   |
			And I click the button named "FormDocumentPurchaseOrderGeneratePurchaseOrder"
		* Fill in Purchase order
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
			# message about prices
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			# message about prices
			And I select "Approved" exact value from "Status" drop-down list
			And I go to line in "ItemList" table
				| 'Item'     |
				| 'Trousers' |
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  |
				| 'Shirt' |
			And I select current line in "ItemList" table
			And I input "180,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder029221$$" variable
			And I delete "$$PurchaseOrder029221$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder029221$$"
			And I save the window as "$$PurchaseOrder029221$$"
			And I click the button named "FormPost"
	* Create Purchase invoice based on Purchase order №501
		And I click "Purchase invoice" button
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice029221$$" variable
		And I delete "$$PurchaseInvoice029221$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029221$$"
		And I save the window as "$$PurchaseInvoice029221$$"
		And I click the button named "FormPost"
	* Create Goods receipt based on Purchase invoice №501
		And I click "Goods receipt" button
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt029221$$" variable
		And I delete "$$GoodsReceipt029221$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029221$$"
		And I save the window as "$$GoodsReceipt029221$$"
		And I click the button named "FormPost"
	* Create Shipment confirmation based on Sales order №501
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292001$$'   |
		And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentConfirmation029221$$" variable
		And I delete "$$ShipmentConfirmation029221$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029221$$"
		And I save the window as "$$ShipmentConfirmation029221$$"
		And I click the button named "FormPost"
	* Create Sales invoice based on Shipment confirmation №501
		And I click "Sales invoice" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029221$$" variable
		And I delete "$$SalesInvoice029221$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029221$$"
		And I save the window as "$$SalesInvoice029221$$"
		And I click the button named "FormPost"
		And I close all client application windows




# Sales order (№502) - Purchase order - Purchase invoice - Sales invoice
Scenario: _029222 Sales order - Purchase order - Purchase invoice - Sales invoice
	And I close all client application windows
	* Create Purchase order based on Sales order №502
		* Select Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesOrder0292002$$'    |
			And I click the button named "FormDocumentPurchaseOrderGeneratePurchaseOrder"
		* Fill in Purchase order
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
			# message about prices
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			# message about prices
			And I select "Approved" exact value from "Status" drop-down list
			And I go to line in "ItemList" table
				| 'Item'     |
				| 'Trousers' |
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  |
				| 'Shirt' |
			And I select current line in "ItemList" table
			And I input "180,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder029222$$" variable
			And I delete "$$PurchaseOrder029222$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder029222$$"
			And I save the window as "$$PurchaseOrder029222$$"
			And I click the button named "FormPost"
	* Create Purchase invoice based on Purchase order №502
		And I click "Purchase invoice" button
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice029222$$" variable
		And I delete "$$PurchaseInvoice029222$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice029222$$"
		And I save the window as "$$PurchaseInvoice029222$$"
		And I click the button named "FormPostAndClose"
	* Create Sales invoice based on Sales order №502
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292002$$'    |
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029222$$" variable
		And I delete "$$SalesInvoice029222$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029222$$"
		And I save the window as "$$SalesInvoice029222$$"
		And I click the button named "FormPostAndClose"
	



# Sales order (№504)- Purchase invoice - Goods receipt - Shipment confirmation - Sales invoice
Scenario: _029224 Sales order - Purchase invoice - Goods receipt - Shipment confirmation - Sales invoice
	And I close all client application windows
	* Create Purchase invoice based on Sales order №504
		* Select Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesOrder0292004$$'    |
			And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		* Filling in Purchase invoice
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
			# message about prices
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			# message about prices
			And I go to line in "ItemList" table
				| 'Item'     |
				| 'Trousers' |
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  |
				| 'Shirt' |
			And I select current line in "ItemList" table
			And I input "180,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice029224$$" variable
			And I delete "$$PurchaseInvoice029224$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice029224$$"
			And I save the window as "$$PurchaseInvoice029224$$"
			And I click the button named "FormPost"
	* Create Goods receipt based on Purchase invoice №504
		And I click "Goods receipt" button
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt029224$$" variable
		And I delete "$$GoodsReceipt029224$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt029224$$"
		And I save the window as "$$GoodsReceipt029224$$"
		And I click the button named "FormPost"
	* Create Shipment confirmation based on Sales order №504
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesOrder0292004$$'    |
		And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentConfirmation029224$$" variable
		And I delete "$$ShipmentConfirmation029224$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation029224$$"
		And I save the window as "$$ShipmentConfirmation029224$$"
		And I click the button named "FormPost"
	* Create Sales invoice based on Shipment confirmation №504
		And I click "Sales invoice" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029224$$" variable
		And I delete "$$SalesInvoice029224$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029224$$"
		And I save the window as "$$SalesInvoice029224$$"
		And I click the button named "FormPost"
		And I close all client application windows


# Sales order (№505)- Purchase invoice - Sales invoice

Scenario: _029225 Sales order - Purchase invoice - Sales invoice
	And I close all client application windows
	* Create Purchase invoice based on Sales order №505
		*Select Sales order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesOrder0292005$$' |
			And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		* Filling in Purchase invoice
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
			# message about prices
			And I change checkbox "Do you want to replace filled price types with price type Vendor price, TRY?"
			And I change checkbox "Do you want to update filled prices?"
			And I click "OK" button
			# message about prices
			And I go to line in "ItemList" table
				| 'Item'     |
				| 'Trousers' |
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'  |
				| 'Shirt' |
			And I select current line in "ItemList" table
			And I input "180,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice029224$$" variable
			And I delete "$$PurchaseInvoice029224$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice029224$$"
			And I save the window as "$$PurchaseInvoice029224$$"
			And I click the button named "FormPost"
	* Create Sales invoice based on Sales order №502
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesOrder0292005$$' |
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice029224$$" variable
		And I delete "$$SalesInvoice029224$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice029224$$"
		And I save the window as "$$SalesInvoice029224$$"
		And I click the button named "FormPostAndClose"


// #  Sales order (№503) - Purchase order - Purchase invoice - Shipment confirmation - Sales invoice

// #  Sales order - Purchase order - Purchase invoice - Goods receipt - Sales invoice

// #  Sales order - Purchase order - Purchase invoice - Sales invoice - Shipment confirmation



