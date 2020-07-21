#language: en
@tree
@Positive
Feature: incoming services

As a financier
I want to fill out the information on the services I received and which I provided
For cost analysis

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _029101 create item type for services
	Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	And I click the button named "FormCreate"
	And I input "Service" text in "ENG" field
	And I click Open button of "ENG" field
	And I input "Service TR" text in "TR" field
	And I click "Ok" button
	And I change "Type" radio button value to "Service"
	And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
	And I click choice button of "Attribute" attribute in "AvailableAttributes" table
	And I click the button named "FormCreate"
	And I input "Service type" text in "ENG" field
	And I click Open button of "ENG" field
	And I input "Service type TR" text in "TR" field
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
	And I input "Service" text in "ENG" field
	And I click Open button of "ENG" field
	And I input "Service TR" text in "TR" field
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
		And I input "Interner" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Interner TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And I click the button named "FormChoose"
		And I click "Save and close" button
	* Adding an item key for Rent
		And I click the button named "FormCreate"
		And I click Select button of "Service type" field
		And I click the button named "FormCreate"
		And I input "Rent" text in "ENG" field
		And I click Open button of "ENG" field
		And I input "Rent TR" text in "TR" field
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
	* Filling in the document number 123
		And I move to "Other" tab
		And I expand "More" group
		And I input "123" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "123" text in "Number" field
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
		And I click "Post" button


Scenario: _029104 create a Purchase invoice for service (based on Purchase order)
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number' |
		| '123'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	* Check the filling of the tabular part
		And "ItemList" table contains lines
		| 'Price'    | 'Item'    | 'VAT' | 'Item key' | 'Q'     | 'Tax amount' | 'Unit' | 'Net amount' | 'Total amount' | 'Expense type'             | 'Business unit' | 'Purchase order'      |
		| '1 000,00' | 'Service' | '18%' | 'Interner' | '1,000' | '152,54'     | 'pcs'  | '847,46'     | '1 000,00'     | 'Telephone communications' | 'Front office'  | 'Purchase order 123*' |
	* Filling in the document number 123
		And I move to "Other" tab
		And I input "123" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "123" text in "Number" field
	And I click "Post" button
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.PurchaseTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Quantity' | 'Recorder'              | 'Row key'                     | 'Company'      | 'Purchase invoice'      | 'Item key'  | 'Amount'   |
		| 'TRY'      | '1,000'    | 'Purchase invoice 123*' | '*'                           | 'Main Company' | 'Purchase invoice 123*' | 'Interner'  | '1 000,00' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.ExpensesTurnovers"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Company'      | 'Business unit' | 'Item key' | 'Amount' | 'Expense type'               |
		| 'TRY'      | 'Purchase invoice 123*' | 'Main Company' | 'Front office'  | 'Interner' | '1 000,00' | 'Telephone communications' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'              | 'Legal name'        | 'Basis document'        | 'Company'      | 'Amount' | 'Partner term'          | 'Partner'   |
		| 'TRY'      | 'Purchase invoice 123*' | 'Company Ferron BP' | 'Purchase invoice 123*' | 'Main Company' | '1 000,00' | 'Vendor Ferron, TRY' | 'Ferron BP' |
		And I close all client application windows
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
		| 'Quantity' | 'Recorder'              | 'Row key'   | 'Order'               | 'Item key' |
		| '1,000'    | 'Purchase invoice 123*' | '*'         | 'Purchase order 123*' | 'Interner' |
		And I close all client application windows
	
	
Scenario: _029106 create a Purchase invoice for service and product (based on Purchase order, Store use Goods receipt)
		* Create Item Router
			Given I open hyperlink "e1cib/list/Catalog.Items"
			And I click the button named "FormCreate"
			And I input "Router" text in "ENG" field
			And I click Select button of "Item type" field
			And I click the button named "FormCreate"
			And I input "Equipment" text in "ENG" field
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
		* Filling in the document number 124
			And I move to "Other" tab
			And I input "124" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "124" text in "Number" field
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
			And I click "Post" button
		* Check document movements using a report
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Purchase invoice 124*'                 | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Document registrations records'        | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Inventory balance"'         | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | 'Quantity'      | 'Company'       | 'Item key'                 | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Router'                   | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Purchase turnovers"'        | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'               | ''                      | ''                  | ''                    | ''                         | ''                         | 'Attributes'           | ''                         | ''                     |
			| ''                                      | ''            | 'Quantity'  | 'Amount'        | 'Net amount'    | 'Company'                  | 'Purchase invoice'      | 'Currency'          | 'Item key'            | 'Row key'                  | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '17,12'         | '14,51'         | 'Main Company'             | 'Purchase invoice 124*' | 'USD'               | 'Interner'            | '*'                        | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '34,25'         | '29,02'         | 'Main Company'             | 'Purchase invoice 124*' | 'USD'               | 'Router'              | '*'                        | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '100'           | '84,75'         | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Interner'            | '*'                        | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '100'           | '84,75'         | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Interner'            | '*'                        | 'Local currency'           | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '100'           | '84,75'         | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Interner'            | '*'                        | 'TRY'                      | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '200'           | '169,49'        | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Router'              | '*'                        | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '200'           | '169,49'        | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Router'              | '*'                        | 'Local currency'           | 'No'                   | ''                         | ''                     |
			| ''                                      | '*'           | '1'         | '200'           | '169,49'        | 'Main Company'             | 'Purchase invoice 124*' | 'TRY'               | 'Router'              | '*'                        | 'TRY'                      | 'No'                   | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Expenses turnovers"'        | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources' | 'Dimensions'    | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | 'Attributes'               | ''                     | ''                         | ''                     |
			| ''                                      | ''            | 'Amount'    | 'Company'       | 'Business unit' | 'Expense type'             | 'Item key'              | 'Currency'          | 'Additional analytic' | 'Multi currency movement type'   | 'Deferred calculation'     | ''                     | ''                         | ''                     |
			| ''                                      | '*'           | '17,12'     | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'USD'               | ''                    | 'Reporting currency'       | 'No'                       | ''                     | ''                         | ''                     |
			| ''                                      | '*'           | '100'       | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'TRY'               | ''                    | 'en descriptions is empty' | 'No'                       | ''                     | ''                         | ''                     |
			| ''                                      | '*'           | '100'       | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'TRY'               | ''                    | 'Local currency'           | 'No'                       | ''                     | ''                         | ''                     |
			| ''                                      | '*'           | '100'       | 'Main Company'  | 'Front office'  | 'Telephone communications' | 'Interner'              | 'TRY'               | ''                    | 'TRY'                      | 'No'                       | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Taxes turnovers"'           | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Period'      | 'Resources' | ''              | ''              | 'Dimensions'               | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | 'Attributes'           |
			| ''                                      | ''            | 'Amount'    | 'Manual amount' | 'Net amount'    | 'Document'                 | 'Tax'                   | 'Analytics'         | 'Tax rate'            | 'Include to total amount'  | 'Row key'                  | 'Currency'             | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                      | '*'           | '2,61'      | '2,61'          | '14,51'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '5,22'      | '5,22'          | '29,02'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'USD'                  | 'Reporting currency'       | 'No'                   |
			| ''                                      | '*'           | '15,25'     | '15,25'         | '84,75'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '15,25'     | '15,25'         | '84,75'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
			| ''                                      | '*'           | '15,25'     | '15,25'         | '84,75'         | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
			| ''                                      | '*'           | '30,51'     | '30,51'         | '169,49'        | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'en descriptions is empty' | 'No'                   |
			| ''                                      | '*'           | '30,51'     | '30,51'         | '169,49'        | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'Local currency'           | 'No'                   |
			| ''                                      | '*'           | '30,51'     | '30,51'         | '169,49'        | 'Purchase invoice 124*'    | 'VAT'                   | ''                  | '18%'                 | 'Yes'                      | '*'                        | 'TRY'                  | 'TRY'                      | 'No'                   |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Goods in transit incoming"' | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | 'Quantity'      | 'Store'         | 'Receipt basis'            | 'Item key'              | 'Row key'           | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'             | 'Store 02'      | 'Purchase invoice 124*'    | 'Router'                | '*'                 | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Accounts statement"'        | ''            | ''          | ''                    | ''               | ''                                               | ''                                               | ''                                     | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'           | ''               | ''                                               | ''                                               | 'Dimensions'                           | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                         | 'Transaction AR'                                 | 'Company'                              | 'Partner'                              | 'Legal name'                           | 'Basis document'                                 | 'Currency'             | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | ''                    | '300'            | ''                                               | ''                                               | 'Main Company'                         | 'Ferron BP'                            | 'Company Ferron BP'                    | 'Purchase invoice 124*' | 'TRY'                  | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''                    | ''               | ''                                               | ''                                               | ''                                     | ''                                     | ''                                     | ''                                               | ''                     | ''                         | ''                     |
			| 'Register  "Reconciliation statement"'  | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | 'Amount'        | 'Company'       | 'Legal name'               | 'Currency'              | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'         | '300'           | 'Main Company'  | 'Company Ferron BP'        | 'TRY'                   | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Goods receipt schedule"'    | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | 'Attributes'               | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | 'Quantity'      | 'Company'       | 'Order'                    | 'Store'                 | 'Item key'          | 'Row key'             | 'Delivery date'            | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Purchase invoice 124*'    | ''                      | 'Interner'          | '*'                   | '*'                        | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '1'             | 'Main Company'  | 'Purchase invoice 124*'    | 'Store 02'              | 'Router'            | '*'                   | '*'                        | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Expense'     | '*'         | '1'             | 'Main Company'  | 'Purchase invoice 124*'    | ''                      | 'Interner'          | '*'                   | '*'                        | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| 'Register  "Partner AP transactions"'   | ''            | ''          | ''              | ''              | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | ''                     | ''                         | ''                     |
			| ''                                      | 'Record type' | 'Period'    | 'Resources'     | 'Dimensions'    | ''                         | ''                      | ''                  | ''                    | ''                         | ''                         | 'Attributes'           | ''                         | ''                     |
			| ''                                      | ''            | ''          | 'Amount'        | 'Company'       | 'Basis document'           | 'Partner'               | 'Legal name'        | 'Partner term'           | 'Currency'                 | 'Multi currency movement type'   | 'Deferred calculation' | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '51,37'         | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'USD'                      | 'Reporting currency'       | 'No'                   | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '300'           | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                      | 'en descriptions is empty' | 'No'                   | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '300'           | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                      | 'Local currency'           | 'No'                   | ''                         | ''                     |
			| ''                                      | 'Receipt'     | '*'         | '300'           | 'Main Company'  | 'Purchase invoice 124*'    | 'Ferron BP'             | 'Company Ferron BP' | 'Vendor Ferron, TRY'  | 'TRY'                      | 'TRY'                      | 'No'                   | ''                         | ''                     |
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
			| Description |
			| Boots       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 37/18SD  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in document number
		And I move to "Other" tab
		And I expand "More" group
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "700" text in "Number" field
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Sales order 700*'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '17,12'     | 'Main Company' | 'Sales order 700*' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | 'Sales order 700*' | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | 'Sales order 700*' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company' | 'Sales order 700*' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 198,63'  | 'Main Company' | 'Sales order 700*' | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | 'Sales order 700*' | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | 'Sales order 700*' | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company' | 'Sales order 700*' | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'     | 'Sales order 700*' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'     | 'Sales order 700*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 700*' | 'Store 01' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 700*' | 'Store 01' | '37/18SD'  | '*'       | '*'                        | ''                     |



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
			| Description |
			| Boots       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 37/18SD  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in document number
		And in the table "ItemList" I click "% Offers" button
		And in the table "Offers" I click "OK" button
		And I move to "Other" tab
		And I expand "More" group
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "701" text in "Number" field
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Sales order 701*'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '20,21'     | 'Main Company' | 'Sales order 701*' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 701*' | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 701*' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 701*' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 309,62'  | 'Main Company' | 'Sales order 701*' | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 701*' | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 701*' | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 701*' | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | 'Sales order 701*' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 701*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 701*' | 'Store 02' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 701*' | 'Store 02' | '37/18SD'  | '*'       | '*'                        | ''                     |




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
			| Description |
			| Boots       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 37/18SD  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in document number
		And in the table "ItemList" I click "% Offers" button
		And in the table "Offers" I click "OK" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "702" text in "Number" field
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Sales order 702*'                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Inventory balance"'              | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'     | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'         | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'         | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment orders"'                | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Order'            | 'Shipment confirmation' | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Sales order 702*' | 'Sales order 702*'      | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'          | 'Sales order'           | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '17,12'     | 'Main Company'     | 'Sales order 702*'      | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '100'       | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 198,63'  | 'Main Company'     | 'Sales order 702*'      | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 000'     | 'Main Company'     | 'Sales order 702*'      | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Order'                 | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 01'         | 'Sales order 702*'      | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 01'         | 'Sales order 702*'      | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock balance"'                  | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'            | 'Item key'              | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 01'         | '37/18SD'               | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''                 | ''                      | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'       | ''                      | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'          | 'Order'                 | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company'     | 'Sales order 702*'      | 'Store 01' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company'     | 'Sales order 702*'      | 'Store 01' | '37/18SD'  | '*'       | '*'                        | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Main Company'     | 'Sales order 702*'      | 'Store 01' | '37/18SD'  | '*'       | '*'                        | ''                     |





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
			| Boots       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| Item  | Item key |
			| Boots | 37/18SD  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate "Procurement method" field in "ItemList" table
		And I select current line in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Filling in document number
		And in the table "ItemList" I click "% Offers" button
		And in the table "Offers" I click "OK" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "703" text in "Number" field
		And I click "Post" button
	* Check movements
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| 'Sales order 703*'                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Document registrations records'             | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Goods in transit outgoing"'      | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Shipment basis'   | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 703*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Stock reservation"'              | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Item key'         | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Expense'     | '*'         | '10'        | 'Store 02'     | '37/18SD'          | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Sales order turnovers"'          | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Period'      | 'Resources' | ''          | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | 'Attributes'           |
		| ''                                           | ''            | 'Quantity'  | 'Amount'    | 'Company'      | 'Sales order'      | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type'   | 'Deferred calculation' |
		| ''                                           | '*'           | '1'         | '20,21'     | 'Main Company' | 'Sales order 703*' | 'USD'      | 'Rent'     | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 703*' | 'TRY'      | 'Rent'     | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 703*' | 'TRY'      | 'Rent'     | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '1'         | '118'       | 'Main Company' | 'Sales order 703*' | 'TRY'      | 'Rent'     | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | '*'           | '10'        | '1 309,62'  | 'Main Company' | 'Sales order 703*' | 'USD'      | '37/18SD'  | '*'       | 'Reporting currency'       | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 703*' | 'TRY'      | '37/18SD'  | '*'       | 'en descriptions is empty' | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 703*' | 'TRY'      | '37/18SD'  | '*'       | 'Local currency'           | 'No'                   |
		| ''                                           | '*'           | '10'        | '7 648,17'  | 'Main Company' | 'Sales order 703*' | 'TRY'      | '37/18SD'  | '*'       | 'TRY'                      | 'No'                   |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Order balance"'                  | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Store'        | 'Order'            | 'Item key' | 'Row key'  | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Store 02'     | 'Sales order 703*' | 'Rent'     | '*'        | ''        | ''                         | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Store 02'     | 'Sales order 703*' | '37/18SD'  | '*'        | ''        | ''                         | ''                     |
		| ''                                           | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''          | ''             | ''                 | ''         | ''         | ''        | ''                         | ''                     |
		| ''                                           | 'Record type' | 'Period'    | 'Resources' | 'Dimensions'   | ''                 | ''         | ''         | ''        | 'Attributes'               | ''                     |
		| ''                                           | ''            | ''          | 'Quantity'  | 'Company'      | 'Order'            | 'Store'    | 'Item key' | 'Row key' | 'Delivery date'            | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '1'         | 'Main Company' | 'Sales order 703*' | 'Store 02' | 'Rent'     | '*'       | '*'                        | ''                     |
		| ''                                           | 'Receipt'     | '*'         | '10'        | 'Main Company' | 'Sales order 703*' | 'Store 02' | '37/18SD'  | '*'       | '*'                        | ''                     |
