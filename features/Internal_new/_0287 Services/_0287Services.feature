#language: en
@tree
@Positive
@Services

Feature: incoming services

As a financier
I want to fill out the information on the services I received and which I provided
For cost analysis

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _029100 preparation
	* Constants
		When set True value to the constant
	* Load info
		When Create catalog ItemTypes objects (Furniture)	
		When Create catalog Items objects (Table)
		When Create catalog ItemKeys objects (Table)
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog PriceTypes objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company

Scenario: _029101 create item type for services
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	And I click the button named "FormCreate"
	And I input "Service" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Service TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I change "Type" radio button value to "Service"
	And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
	And I click choice button of "Attribute" attribute in "AvailableAttributes" table
	And I click the button named "FormCreate"
	And I input "Service type" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Service type TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save and close" button
	And I go to line in "List" table
		| Description  |
		| Service type |
	And I click the button named "FormChoose"
	And I finish line editing in "AvailableAttributes" table
	And I click "Save and close" button
	And Delay 2
	Then I check for the "ItemTypes" catalog element with the "Description_en" "Service"

Scenario: _029102 create Item - Service
	Given I open hyperlink "e1cib/list/Catalog.Items"
	And I click the button named "FormCreate"
	And I input "Service" text in the field named "Description_en"
	And I click Open button of "ENG" field
	And I input "Service TR" text in the field named "Description_tr"
	And I click "Ok" button
	And I click Select button of "Item type" field
	And I go to line in "List" table
		| Description |
		| Service     |
	And I select current line in "List" table
	And I click Select button of "Unit" field
	And I go to line in "List" table
		| Description |
		| pcs         |
	And I select current line in "List" table
	And I click "Save" button
	And In this window I click command interface button "Item keys"
	* Adding an item key for Internet service
		And I click the button named "FormCreate"
		And I click Select button of "Service type" field
		And I click the button named "FormCreate"
		And I input "Interner" text in the field named "Description_en"
		And I click Open button of "ENG" field
		And I input "Interner TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Adding an item key for Rent
		And I click the button named "FormCreate"
		And I click Select button of "Service type" field
		And I click the button named "FormCreate"
		And I input "Rent" text in the field named "Description_en"
		And I click Open button of "ENG" field
		And I input "Rent TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click "Save and close" button
	And I close all client application windows
	

Scenario: _029103 create a Purchase order for service
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in Company and Status
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description  |
			| Main Company |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
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
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Service     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate field named "ItemListStore" in "ItemList" table
		And I activate "Business unit" field in "ItemList" table
		And I click choice button of "Business unit" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Expense type" field in "ItemList" table
		And I click choice button of "Expense type" attribute in "ItemList" table
		And I go to line in "List" table
		| 'Description'              |
		| 'Telephone communications' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "1000,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberPurchaseOrder029103$$"
		And I save the window as "$$PurchaseOrder029103$$"
		And I click the button named "FormPost"


Scenario: _029104 create a Purchase invoice for service (based on Purchase order)
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder029103$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	* Check the filling of the tabular part
		And "ItemList" table contains lines
		| 'Price'    | 'Item'    | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Expense type'             | 'Business unit' | 'Purchase order'      |
		| '1 000,00' | 'Service' | '18%' | 'Interner' | '1,000' | '152,54'     | 'pcs'  | '847,46'     | '1 000,00'     | 'Telephone communications' | 'Front office'  | '$$PurchaseOrder029103$$' |
	And I click the button named "FormPost"
	And I save the value of "Number" field as "$$NumberPurchaseInvoice029104$$"
	And I save the window as "$$PurchaseInvoice029104$$"
	And I click the button named "FormPost"
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Quantity' | 'Recorder'                  | 'Row key' | 'Company'      | 'Purchase invoice'          | 'Item key' | 'Amount'   |
		| 'TRY'      | '1,000'    | '$$PurchaseInvoice029104$$' | '*'       | 'Main Company' | '$$PurchaseInvoice029104$$' | 'Interner' | '1 000,00' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.ExpensesTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                  | 'Company'      | 'Business unit' | 'Item key' | 'Amount'   | 'Expense type'             |
		| 'TRY'      | '$$PurchaseInvoice029104$$' | 'Main Company' | 'Front office'  | 'Interner' | '1 000,00' | 'Telephone communications' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                  | 'Legal name'        | 'Basis document'            | 'Company'      | 'Amount'   | 'Partner term'       | 'Partner'   |
		| 'TRY'      | '$$PurchaseInvoice029104$$' | 'Company Ferron BP' | '$$PurchaseInvoice029104$$' | 'Main Company' | '1 000,00' | 'Vendor Ferron, TRY' | 'Ferron BP' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
		| 'Quantity' | 'Recorder'                  | 'Row key' | 'Order'                   | 'Item key' |
		| '1,000'    | '$$PurchaseInvoice029104$$' | '*'       | '$$PurchaseOrder029103$$' | 'Interner' |
		And I close all client application windows
	
	
Scenario: _029106 create a Purchase invoice for service and product (based on Purchase order, Store use Goods receipt)
		* Create Item Router
			Given I open hyperlink "e1cib/list/Catalog.Items"
			And I click the button named "FormCreate"
			And I input "Router" text in the field named "Description_en"
			And I click Select button of "Item type" field
			And I click the button named "FormCreate"
			And I input "Equipment" text in the field named "Description_en"
			And I click "Save and close" button
			And I click the button named "FormChoose"
			And I click Select button of "Unit" field
			And I select current line in "List" table
			And I click "Save" button
			And In this window I click command interface button "Item keys"
			And I click the button named "FormCreate"
			And I click "Save and close" button
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in vendor information
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
		* Filling in items table ((add product and service))
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Service     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate field named "ItemListStore" in "ItemList" table
			And I activate "Business unit" field in "ItemList" table
			And I click choice button of "Business unit" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I go to line in "List" table
			| Description              |
			| Telephone communications |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Router      |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I activate "Business unit" field in "ItemList" table
			And I click choice button of "Business unit" attribute in "ItemList" table
			And I go to line in "List" table
				| Description  |
				| Front office | 
			And I select current line in "List" table
			And I click choice button of "Store" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Store 02    |
			And I select current line in "List" table
			And I activate "Expense type" field in "ItemList" table
			And I click choice button of "Expense type" attribute in "ItemList" table
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description |
				| Software    |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I activate "Price" field in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I save the value of "Number" field as "$$NumberPurchaseInvoice029106$$"
			And I save the window as "$$PurchaseInvoice029106$$"
			And I click the button named "FormPost"
		* Check document movements using a report
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseInvoice029106$$'             | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Document registrations records'        | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Inventory balance"'         | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | 'Quantity'             | 'Company'        | 'Item key'                  | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'                    | 'Main Company'   | 'Router'                    | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Purchase turnovers"'        | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'                | ''                          | ''                  | ''                    | ''                             | ''                             | 'Attributes'           | ''                             | ''                     |
			| ''                                      | ''            | 'Quantity'  | 'Amount'               | 'Net amount'     | 'Company'                   | 'Purchase invoice'          | 'Currency'          | 'Item key'            | 'Row key'                      | 'Multi currency movement type' | 'Deferred calculation' | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '17,12'                | '14,51'          | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'USD'               | 'Interner'            | '*'                            | 'Reporting currency'           | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '34,25'                | '29,02'          | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'USD'               | 'Router'              | '*'                            | 'Reporting currency'           | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '100'                  | '84,75'          | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'TRY'               | 'Interner'            | '*'                            | 'en description is empty'      | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '100'                  | '84,75'          | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'TRY'               | 'Interner'            | '*'                            | 'Local currency'               | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '100'                  | '84,75'          | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'TRY'               | 'Interner'            | '*'                            | 'TRY'                          | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '200'                  | '169,49'         | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'TRY'               | 'Router'              | '*'                            | 'en description is empty'      | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '200'                  | '169,49'         | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'TRY'               | 'Router'              | '*'                            | 'Local currency'               | 'No'                   | ''                             | ''                     |
			| ''                                      | '*'           | '1'         | '200'                  | '169,49'         | 'Main Company'              | '$$PurchaseInvoice029106$$' | 'TRY'               | 'Router'              | '*'                            | 'TRY'                          | 'No'                   | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Expenses turnovers"'        | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'           | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | 'Attributes'                   | ''                     | ''                             | ''                     |
			| ''                                      | ''            | 'Amount'    | 'Company'              | 'Business unit'  | 'Expense type'              | 'Item key'                  | 'Currency'          | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation'         | ''                     | ''                             | ''                     |
			| ''                                      | '*'           | '17,12'     | 'Main Company'         | 'Front office'   | 'Telephone communications'  | 'Interner'                  | 'USD'               | ''                    | 'Reporting currency'           | 'No'                           | ''                     | ''                             | ''                     |
			| ''                                      | '*'           | '100'       | 'Main Company'         | 'Front office'   | 'Telephone communications'  | 'Interner'                  | 'TRY'               | ''                    | 'en description is empty'      | 'No'                           | ''                     | ''                             | ''                     |
			| ''                                      | '*'           | '100'       | 'Main Company'         | 'Front office'   | 'Telephone communications'  | 'Interner'                  | 'TRY'               | ''                    | 'Local currency'               | 'No'                           | ''                     | ''                             | ''                     |
			| ''                                      | '*'           | '100'       | 'Main Company'         | 'Front office'   | 'Telephone communications'  | 'Interner'                  | 'TRY'               | ''                    | 'TRY'                          | 'No'                           | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Taxes turnovers"'           | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Period'      | 'Resources' | ''                     | ''               | 'Dimensions'                | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | 'Attributes'           |
			| ''                                      | ''            | 'Amount'    | 'Manual amount'        | 'Net amount'     | 'Document'                  | 'Tax'                       | 'Analytics'         | 'Tax rate'            | 'Include to total amount'      | 'Row key'                      | 'Currency'             | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                      | '*'           | '2,61'      | '2,61'                 | '14,51'          | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'USD'                  | 'Reporting currency'           | 'No'                   |
			| ''                                      | '*'           | '5,22'      | '5,22'                 | '29,02'          | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'USD'                  | 'Reporting currency'           | 'No'                   |
			| ''                                      | '*'           | '15,25'     | '15,25'                | '84,75'          | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'TRY'                  | 'en description is empty'      | 'No'                   |
			| ''                                      | '*'           | '15,25'     | '15,25'                | '84,75'          | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                      | '*'           | '15,25'     | '15,25'                | '84,75'          | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'TRY'                  | 'TRY'                          | 'No'                   |
			| ''                                      | '*'           | '30,51'     | '30,51'                | '169,49'         | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'TRY'                  | 'en description is empty'      | 'No'                   |
			| ''                                      | '*'           | '30,51'     | '30,51'                | '169,49'         | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                      | '*'           | '30,51'     | '30,51'                | '169,49'         | '$$PurchaseInvoice029106$$' | 'VAT'                       | ''                  | '18%'                 | 'Yes'                          | '*'                            | 'TRY'                  | 'TRY'                          | 'No'                   |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Goods in transit incoming"' | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | 'Quantity'             | 'Store'          | 'Receipt basis'             | 'Item key'                  | 'Row key'           | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'                    | 'Store 02'       | '$$PurchaseInvoice029106$$' | 'Router'                    | '*'                 | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'            | ''               | ''                          | ''                          | 'Dimensions'        | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'    | 'Transaction AR'            | 'Company'           | 'Partner'             | 'Legal name'                   | 'Basis document'               | 'Currency'             | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | ''                     | '300'            | ''                          | ''                          | 'Main Company'      | 'Ferron BP'           | 'Company Ferron BP'            | '$$PurchaseInvoice029106$$'    | 'TRY'                  | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | 'Amount'               | 'Company'        | 'Legal name'                | 'Currency'                  | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Expense'     | '*'         | '300'                  | 'Main Company'   | 'Company Ferron BP'         | 'TRY'                       | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Goods receipt schedule"'    | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                  | ''                    | 'Attributes'                   | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                     | 'Store'                     | 'Item key'          | 'Row key'             | 'Delivery date'                | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'                    | 'Main Company'   | '$$PurchaseInvoice029106$$' | ''                          | 'Interner'          | '*'                   | '*'                            | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'                    | 'Main Company'   | '$$PurchaseInvoice029106$$' | 'Store 02'                  | 'Router'            | '*'                   | '*'                            | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Expense'     | '*'         | '1'                    | 'Main Company'   | '$$PurchaseInvoice029106$$' | ''                          | 'Interner'          | '*'                   | '*'                            | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| 'Register  "Partner AP transactions"'   | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | ''                     | ''                             | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                  | ''                    | ''                             | ''                             | 'Attributes'           | ''                             | ''                     |
			| ''                                      | ''            | ''          | 'Amount'               | 'Company'        | 'Basis document'            | 'Partner'                   | 'Legal name'        | 'Partner term'        | 'Currency'                     | 'Multi currency movement type' | 'Deferred calculation' | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '51,37'                | 'Main Company'   | '$$PurchaseInvoice029106$$' | 'Ferron BP'                 | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'USD'                          | 'Reporting currency'           | 'No'                   | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '300'                  | 'Main Company'   | '$$PurchaseInvoice029106$$' | 'Ferron BP'                 | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                          | 'en description is empty'      | 'No'                   | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '300'                  | 'Main Company'   | '$$PurchaseInvoice029106$$' | 'Ferron BP'                 | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                          | 'Local currency'               | 'No'                   | ''                             | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '300'                  | 'Main Company'   | '$$PurchaseInvoice029106$$' | 'Ferron BP'                 | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                          | 'TRY'                          | 'No'                   | ''                             | ''                     |
		And I close all client application windows



Scenario: _029107 create a Sales order for service and product (Store doesn't use Shipment confirmation, Sales invoice before Shipment confirmation)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	Then "Partner terms" window is opened
	And I go to line in "List" table
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Service     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item    | Item key |
			| Service | Rent     |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Table'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Table' | 'Table'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberSalesOrder029107$$"
		And I save the window as "$$SalesOrder029107$$"
		And I click the button named "FormPost"
	* Check movements
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder029107$$'                       | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'             | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | 'Table'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'             | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'     | 'Table'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '17,12'     | 'Main Company' | '$$SalesOrder029107$$' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | '$$SalesOrder029107$$' | 'TRY'      | 'Rent'     | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | '$$SalesOrder029107$$' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | '$$SalesOrder029107$$' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 198,63'  | 'Main Company' | '$$SalesOrder029107$$' | 'USD'      | 'Table'  | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | '$$SalesOrder029107$$' | 'TRY'      | 'Table'  | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | '$$SalesOrder029107$$' | 'TRY'      | 'Table'  | '*'       | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | '$$SalesOrder029107$$' | 'TRY'      | 'Table'  | '*'       | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                | 'Item key' | 'Row key'  | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'     | '$$SalesOrder029107$$' | 'Rent'     | '*'        | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | '$$SalesOrder029107$$' | 'Table'  | '*'        | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'                | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | '$$SalesOrder029107$$' | 'Store 01' | 'Rent'     | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder029107$$' | 'Store 01' | 'Table'  | '*'       | '*'                            | ''                     |



Scenario: _029108 create a Sales order for service and product (Store use Shipment confirmation, Sales invoice before Shipment confirmation)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'       |
				| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description' |
				| 'Company Ferron BP'  |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| Description |
			| Service     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item    | Item key |
			| Service | Rent     |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Table'      |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Table' | 'Table'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "648,15" text in "Price" field of "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberSalesOrder029108$$"
		And I save the window as "$$SalesOrder029108$$"
		And I click the button named "FormPost"
	* Check movements
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder029108$$'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Table'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 02'     | 'Table'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '20,21'     | 'Main Company' | '$$SalesOrder029108$$' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | '$$SalesOrder029108$$' | 'TRY'      | 'Rent'     | '*'       | 'en description is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | '$$SalesOrder029108$$' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | '$$SalesOrder029108$$' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 309,62'  | 'Main Company' | '$$SalesOrder029108$$' | 'USD'      | 'Table'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | '$$SalesOrder029108$$' | 'TRY'      | 'Table'  | '*'       | 'en description is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | '$$SalesOrder029108$$' | 'TRY'      | 'Table'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | '$$SalesOrder029108$$' | 'TRY'      | 'Table'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | '$$SalesOrder029108$$' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '$$SalesOrder029108$$' | 'Table'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | '$$SalesOrder029108$$' | 'Store 02' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder029108$$' | 'Store 02' | 'Table'  | '*'       | '*'                        | ''                     |




Scenario: _029109 create a Sales order for service and product (Store doesn't use Shipment confirmation, Shipment confirmation before Sales invoice)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	Then "Partner terms" window is opened
	And I go to line in "List" table
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| Description |
			| Service     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item    | Item key |
			| Service | Rent     |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Table'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Table' | 'Table'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "700,00" text in "Price" field of "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in document number
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		// And I input "0" text in "Number" field
		// Then "1C:Enterprise" window is opened
		// And I click "Yes" button
		// And I input "702" text in "Number" field
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberSalesOrder029109$$"
		And I save the window as "$$SalesOrder029109$$"
		And I click the button named "FormPost"
	* Check movements
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder029109$$'                       | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'              | 'Item key'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'         | 'Table'               | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'                | 'Item key'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'             | 'Table'               | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'                | 'Item key'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'             | 'Table'               | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Shipment orders"'                | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Order'                | 'Shipment confirmation' | 'Item key' | 'Row key'  | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | '$$SalesOrder029109$$' | '$$SalesOrder029109$$'  | 'Table'  | '*'        | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'              | 'Sales order'           | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '17,12'     | 'Main Company'         | '$$SalesOrder029109$$'  | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'         | '$$SalesOrder029109$$'  | 'TRY'      | 'Rent'     | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'         | '$$SalesOrder029109$$'  | 'TRY'      | 'Rent'     | '*'       | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'         | '$$SalesOrder029109$$'  | 'TRY'      | 'Rent'     | '*'       | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 198,63'  | 'Main Company'         | '$$SalesOrder029109$$'  | 'USD'      | 'Table'  | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'         | '$$SalesOrder029109$$'  | 'TRY'      | 'Table'  | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'         | '$$SalesOrder029109$$'  | 'TRY'      | 'Table'  | '*'       | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'         | '$$SalesOrder029109$$'  | 'TRY'      | 'Table'  | '*'       | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'                | 'Order'                 | 'Item key' | 'Row key'  | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'             | '$$SalesOrder029109$$'  | 'Rent'     | '*'        | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'             | '$$SalesOrder029109$$'  | 'Table'  | '*'        | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'                | 'Item key'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'             | 'Table'               | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''                     | ''                      | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'           | ''                      | ''         | ''         | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'              | 'Order'                 | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company'         | '$$SalesOrder029109$$'  | 'Store 01' | 'Rent'     | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company'         | '$$SalesOrder029109$$'  | 'Store 01' | 'Table'  | '*'       | '*'                            | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'         | '$$SalesOrder029109$$'  | 'Store 01' | 'Table'  | '*'       | '*'                            | ''                     |





Scenario: _029110 create a Sales order for service and product (Store use Shipment confirmation, Shipment confirmation before Sales invoice)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'  |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'       |
				| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
				| 'Description' |
				| 'Company Ferron BP'  |
		And I select current line in "List" table
	* Filling in items table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Service     |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item    | Item key |
			| Service | Rent     |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Table       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key |
			| Table | Table  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "648,15" text in "Price" field of "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in document number
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		// And I input "0" text in "Number" field
		// Then "1C:Enterprise" window is opened
		// And I click "Yes" button
		// And I input "703" text in "Number" field
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberSalesOrder029110$$"
		And I save the window as "$$SalesOrder029110$$"
		And I click the button named "FormPost"
	* Check movements
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$SalesOrder029110$$'                       | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'       | 'Item key' | 'Row key'  | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '$$SalesOrder029110$$' | 'Table'  | '*'        | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'             | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Table'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'             | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 02'     | 'Table'              | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '20,21'     | 'Main Company' | '$$SalesOrder029110$$' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | '$$SalesOrder029110$$' | 'TRY'      | 'Rent'     | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | '$$SalesOrder029110$$' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | '$$SalesOrder029110$$' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                          | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 309,62'  | 'Main Company' | '$$SalesOrder029110$$' | 'USD'      | 'Table'  | '*'       | 'Reporting currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | '$$SalesOrder029110$$' | 'TRY'      | 'Table'  | '*'       | 'en description is empty'      | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | '$$SalesOrder029110$$' | 'TRY'      | 'Table'  | '*'       | 'Local currency'               | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | '$$SalesOrder029110$$' | 'TRY'      | 'Table'  | '*'       | 'TRY'                          | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'                | 'Item key' | 'Row key'  | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | '$$SalesOrder029110$$' | 'Rent'     | '*'        | ''        | ''                             | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '$$SalesOrder029110$$' | 'Table'  | '*'        | ''        | ''                             | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                     | ''         | ''         | ''        | ''                             | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                     | ''         | ''         | ''        | 'Attributes'                   | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'                | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'                | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | '$$SalesOrder029110$$' | 'Store 02' | 'Rent'     | '*'       | '*'                            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | '$$SalesOrder029110$$' | 'Store 02' | 'Table'  | '*'       | '*'                            | ''                     |

Scenario: _999999 close TestClient session
	And I close TestClient session