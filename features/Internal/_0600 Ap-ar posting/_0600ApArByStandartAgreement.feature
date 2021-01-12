#language: en
@tree
@Positive
@StandartAgreement

Feature: accounting of receivables / payables under Standard type Partner terms

As an accountant
I want to settle general Partner terms for all partners.


Background:
	Given I launch TestClient opening script or connect the existing one



	
Scenario: _060000 preparation
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
		When Create catalog Partners objects
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
		When Create catalog CashAccounts objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Countries objects
		When Create catalog BusinessUnits objects 
	* Tax settings
		When filling in Tax settings for company


Scenario: _060002 create Sales invoice with the type of settlements under standard Partner terms and check its movements
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'     |
			And I select current line in "List" table
		* Adding items to Sales Invoice
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
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice060002$$" variable
			And I delete "$$SalesInvoice060002$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice060002$$"
			And I save the window as "$$SalesInvoice060002$$"
		* Check filling in sales invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'Basic Price Types' | 'pcs'  | '*'          | '*'          | '11 000,00'    | 'Store 01' |
			And I click the button named "FormPostAndClose"
		* Check Sales invoice movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice060002$$'  |
			And I click "Registrations report" button
			And I select "Partner AR transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice060002$$'              | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     | '' | '' |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     | '' | '' |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     | '' | '' |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''          | ''                  | ''                    | ''         | ''                             | 'Attributes'           | '' | '' |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'   | 'Legal name'        | 'Partner term'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
			And I select "Inventory balance" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Inventory balance"' | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '20'        | 'Main Company' | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
			And I select "Taxes turnovers" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                       | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
			| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'             | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
			| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'               | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                            | '*'      | '287,27'    | '287,27'        | '1 595,93'   | '$$SalesInvoice060002$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060002$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060002$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060002$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			And I select "Accounts statement" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''               | ''         | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''               | ''         | '' | '' |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document' | 'Currency' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | ''               | 'TRY'      | '' | '' |
			And I select "Stock reservation" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '20'        | 'Store 01'   | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
			And I select "Sales turnovers" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Sales turnovers"' | ''       | ''          | ''        | ''           | ''              | ''             | ''                       | ''         | ''         | ''        | ''                             | ''                  | ''                     |
			| ''                            | 'Period' | 'Resources' | ''        | ''           | ''              | 'Dimensions'   | ''                       | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
			| ''                            | ''       | 'Quantity'  | 'Amount'  | 'Net amount' | 'Offers amount' | 'Company'      | 'Sales invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
			| ''                            | '*'      | '20'        | '1 883,2' | '1 595,93'   | ''              | 'Main Company' | '$$SalesInvoice060002$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '20'        | '11 000'  | '9 322,03'   | ''              | 'Main Company' | '$$SalesInvoice060002$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '20'        | '11 000'  | '9 322,03'   | ''              | 'Main Company' | '$$SalesInvoice060002$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '20'        | '11 000'  | '9 322,03'   | ''              | 'Main Company' | '$$SalesInvoice060002$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
			And I select "Reconciliation statement" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | 'Company Nicoletta' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
			And I select "Revenues turnovers" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Revenues turnovers"' | ''       | ''          | ''             | ''              | ''             | ''         | ''         | ''                    | ''                             | ''                     | '' | '' | '' |
			| ''                               | 'Period' | 'Resources' | 'Dimensions'   | ''              | ''             | ''         | ''         | ''                    | ''                             | 'Attributes'           | '' | '' | '' |
			| ''                               | ''       | 'Amount'    | 'Company'      | 'Business unit' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
			| ''                               | '*'      | '1 595,93'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '9 322,03'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '9 322,03'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '9 322,03'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
			And I select "Stock balance" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Stock balance"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Expense'     | '*'      | '20'        | 'Store 01'   | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
			And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''               | ''                       | ''                    | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                       | ''                    | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'          | 'Item key'               | 'Row key'             | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '20'                   | 'Main Company'   | '$$SalesInvoice060002$$' | 'Store 01'       | 'L/Green'                | '*'                   | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Expense'     | '*'         | '20'                   | 'Main Company'   | '$$SalesInvoice060002$$' | 'Store 01'       | 'L/Green'                | '*'                   | '*'                            | ''                             | ''                             | ''                             | ''                     |
	And I close all client application windows

Scenario: _060003 create Cash receipt with the type of settlements under standard Partner terms and check its movements
	* Create Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code' |
				| 'TRY'  |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Posting by Standard Partner term Customer' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt060003$$" variable
		And I delete "$$CashReceipt060003$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt060003$$"
		And I save the window as "$$CashReceipt060003$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberCashReceipt060003$$'  |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CashReceipt060003$$'               | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''          | ''                  | ''                    | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'   | 'Legal name'        | 'Partner term'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' |
			| ''                                     | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Company Nicoletta' | 'TRY'      | '' | '' | '' | '' | '' |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | 'Attributes'           | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation' | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 883,2'             | 'Main Company'   | 'Cash desk №2'           | 'USD'            | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '11 000'               | 'Main Company'   | 'Cash desk №2'           | 'TRY'            | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '11 000'               | 'Main Company'   | 'Cash desk №2'           | 'TRY'            | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"'       | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'                   | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'                      | 'Partner'              | 'Legal name'        | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Expense'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company'                 | 'Nicoletta'            | 'Company Nicoletta' | ''                             | 'TRY'                  |
		And I close all client application windows

Scenario: _0600031 create Bank receipt with the type of settlements under standard Partner terms and check its movements
	* Create Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Posting by Standard Partner term Customer' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0600031$$" variable
		And I delete "$$BankReceipt0600031$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0600031$$"
		And I save the window as "$$BankReceipt0600031$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt0600031$$'  |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankReceipt0600031$$'              | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''          | ''                  | ''                    | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'   | 'Legal name'        | 'Partner term'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' |
			| ''                                     | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Company Nicoletta' | 'TRY'      | '' | '' | '' | '' | '' |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | 'Attributes'           | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation' | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 883,2'             | 'Main Company'   | 'Bank account, TRY'      | 'USD'            | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '11 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '11 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"'       | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'                   | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'                      | 'Partner'              | 'Legal name'        | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Expense'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company'                 | 'Nicoletta'            | 'Company Nicoletta' | ''                             | 'TRY'                  |
		And I close all client application windows

Scenario: _060004 check the offset of the advance for Sales invoice with the type of settlement under standard Partner terms and check its movements
	And I delete "$$NumberSalesInvoice060004$$" variable
	And I delete "$$SalesInvoice060004$$" variable
	And I delete "$$NumberBankReceipt060004$$" variable
	And I delete "$$BankReceipt060004$$" variable
	* Create Bank receipt №602
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'   |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "12 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click Clear button of "Partner term" field
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt060004$$" variable
		And I delete "$$BankReceipt060004$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt060004$$"
		And I save the window as "$$BankReceipt060004$$"
		And I click the button named "FormPostAndClose"
	* Check Bank Receipt movements 
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberBankReceipt060004$$' |
		And I click "Registrations report" button
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankReceipt060004$$'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''               | ''         |
			| 'Document registrations records' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''               | ''         |
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document' | 'Currency' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | '12 000'                 | ''               | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | ''               | 'TRY'      |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' |
			| ''                                     | 'Expense'     | '*'      | '12 000'    | 'Main Company' | 'Company Nicoletta' | 'TRY'      | '' | '' | '' | '' | '' |
		And I select "Advance from customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Advance from customers"' | ''            | ''       | ''          | ''             | ''          | ''                  | ''         | ''                      | ''                             | ''                     | '' |
			| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | ''                  | ''         | ''                      | ''                             | 'Attributes'           | '' |
			| ''                                   | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'   | 'Legal name'        | 'Currency' | 'Receipt document'      | 'Multi currency movement type' | 'Deferred calculation' | '' |
			| ''                                   | 'Receipt'     | '*'      | '2 054,4'   | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | 'USD'      | '$$BankReceipt060004$$' | 'Reporting currency'           | 'No'                   | '' |
			| ''                                   | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | 'TRY'      | '$$BankReceipt060004$$' | 'Local currency'               | 'No'                   | '' |
			| ''                                   | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | 'TRY'      | '$$BankReceipt060004$$' | 'en description is empty'      | 'No'                   | '' |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''                  | ''                             | ''                      | ''                             | ''                     | ''         |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''                  | ''                             | 'Attributes'            | ''                             | ''                     | ''         |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'          | 'Multi currency movement type' | 'Deferred calculation'  | ''                             | ''                     | ''         |
			| ''                                     | 'Receipt'     | '*'      | '2 054,4'             | 'Main Company'   | 'Bank account, TRY'      | 'USD'               | 'Reporting currency'           | 'No'                    | ''                             | ''                     | ''         |
			| ''                                     | 'Receipt'     | '*'      | '12 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'               | 'Local currency'               | 'No'                    | ''                             | ''                     | ''         |
			| ''                                     | 'Receipt'     | '*'      | '12 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'               | 'en description is empty'      | 'No'                    | ''                             | ''                     | ''         |
		And I close all client application windows
	* Create Sales invoice with the type of settlements under standard Partner terms
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Nicoletta'     |
			And I select current line in "List" table
		* Adding items to Sales Invoice
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
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice060004$$" variable
			And I delete "$$SalesInvoice060004$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice060004$$"
			And I save the window as "$$SalesInvoice060004$$"
			And I click the button named "FormPostAndClose"
	* Check SalesInvoice movements
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberSalesInvoice060004$$' |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice060004$$'              | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     | '' | '' |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     | '' | '' |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''          | ''                  | ''                    | ''         | ''                             | ''                     | '' | '' |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''          | ''                  | ''                    | ''         | ''                             | 'Attributes'           | '' | '' |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'   | 'Legal name'        | 'Partner term'        | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Nicoletta' | 'Company Nicoletta' | 'Standard (Customer)' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Inventory balance"' | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '20'        | 'Main Company' | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                       | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
			| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'             | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
			| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'               | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                            | '*'      | '287,27'    | '287,27'        | '1 595,93'   | '$$SalesInvoice060004$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060004$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060004$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060004$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''          | ''                  | ''               | ''         | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''          | ''                  | ''               | ''         | '' | '' |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'   | 'Legal name'        | 'Basis document' | 'Currency' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | ''               | 'TRY'      | '' | '' |
			| ''                               | 'Expense'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | ''               | 'TRY'      | '' | '' |
			| ''                               | 'Expense'     | '*'      | ''                     | ''               | '11 000'                 | ''               | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | ''               | 'TRY'      | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                              | 'Expense'     | '*'      | '20'        | 'Store 01'   | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Sales turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Sales turnovers"' | ''       | ''          | ''        | ''           | ''              | ''             | ''                       | ''         | ''         | ''        | ''                             | ''                  | ''                     |
			| ''                            | 'Period' | 'Resources' | ''        | ''           | ''              | 'Dimensions'   | ''                       | ''         | ''         | ''        | ''                             | ''                  | 'Attributes'           |
			| ''                            | ''       | 'Quantity'  | 'Amount'  | 'Net amount' | 'Offers amount' | 'Company'      | 'Sales invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Serial lot number' | 'Deferred calculation' |
			| ''                            | '*'      | '20'        | '1 883,2' | '1 595,93'   | ''              | 'Main Company' | '$$SalesInvoice060004$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | ''                  | 'No'                   |
			| ''                            | '*'      | '20'        | '11 000'  | '9 322,03'   | ''              | 'Main Company' | '$$SalesInvoice060004$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | ''                  | 'No'                   |
			| ''                            | '*'      | '20'        | '11 000'  | '9 322,03'   | ''              | 'Main Company' | '$$SalesInvoice060004$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | ''                  | 'No'                   |
			| ''                            | '*'      | '20'        | '11 000'  | '9 322,03'   | ''              | 'Main Company' | '$$SalesInvoice060004$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | ''                  | 'No'                   |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                  | ''         | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'        | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | 'Company Nicoletta' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Revenues turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Revenues turnovers"' | ''       | ''          | ''             | ''              | ''             | ''         | ''         | ''                    | ''                             | ''                     | '' | '' | '' |
			| ''                               | 'Period' | 'Resources' | 'Dimensions'   | ''              | ''             | ''         | ''         | ''                    | ''                             | 'Attributes'           | '' | '' | '' |
			| ''                               | ''       | 'Amount'    | 'Company'      | 'Business unit' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
			| ''                               | '*'      | '1 595,93'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'USD'      | ''                    | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '9 322,03'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'TRY'      | ''                    | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '9 322,03'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'TRY'      | ''                    | 'TRY'                          | 'No'                   | '' | '' | '' |
			| ''                               | '*'      | '9 322,03'  | 'Main Company' | ''              | ''             | 'L/Green'  | 'TRY'      | ''                    | 'en description is empty'      | 'No'                   | '' | '' | '' |
		And I select "Advance from customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Advance from customers"' | ''            | ''       | ''          | ''             | ''          | ''                  | ''         | ''                      | ''                             | ''                     | '' | '' | '' |
			| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''          | ''                  | ''         | ''                      | ''                             | 'Attributes'           | '' | '' | '' |
			| ''                                   | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'   | 'Legal name'        | 'Currency' | 'Receipt document'      | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
			| ''                                   | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | 'USD'      | '$$BankReceipt060004$$' | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                                   | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | 'TRY'      | '$$BankReceipt060004$$' | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                                   | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Nicoletta' | 'Company Nicoletta' | 'TRY'      | '$$BankReceipt060004$$' | 'en description is empty'      | 'No'                   | '' | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Stock balance"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                          | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
			| ''                          | 'Expense'     | '*'      | '20'        | 'Store 01'   | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''                  | ''                       | ''                      | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''                  | ''                       | ''                      | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'             | 'Item key'               | 'Row key'               | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '20'                   | 'Main Company'   | '$$SalesInvoice060004$$' | 'Store 01'          | 'L/Green'                | '*'                     | '*'                            | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Expense'     | '*'         | '20'                   | 'Main Company'   | '$$SalesInvoice060004$$' | 'Store 01'          | 'L/Green'                | '*'                     | '*'                            | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows


Scenario: _060005 create Purchase invoice with the type of settlements under standard contracts and check its movements
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'     |
			And I select current line in "List" table
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
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
			And I activate "Q" field in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "550,00" text in "Price" field of "ItemList" table
		* Check filling in purchase invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'en description is empty' | 'pcs'  | '1 677,97'   | '9 322,03'   | '11 000,00'    | 'Store 01' |
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice060005$$" variable
			And I delete "$$PurchaseInvoice060005$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060005$$"
			And I save the window as "$$PurchaseInvoice060005$$"
	* Check Purchase Invoice movements 
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice060005$$'      | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '20'        | 'Main Company' | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Purchase turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Purchase turnovers"' | ''       | ''          | ''        | ''           | ''             | ''                          | ''         | ''         | ''        | ''                             | ''                     | '' | '' |
		| ''                               | 'Period' | 'Resources' | ''        | ''           | 'Dimensions'   | ''                          | ''         | ''         | ''        | ''                             | 'Attributes'           | '' | '' |
		| ''                               | ''       | 'Quantity'  | 'Amount'  | 'Net amount' | 'Company'      | 'Purchase invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                               | '*'      | '20'        | '1 883,2' | '1 595,93'   | 'Main Company' | '$$PurchaseInvoice060005$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '20'        | '11 000'  | '9 322,03'   | 'Main Company' | '$$PurchaseInvoice060005$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '20'        | '11 000'  | '9 322,03'   | 'Main Company' | '$$PurchaseInvoice060005$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '20'        | '11 000'  | '9 322,03'   | 'Main Company' | '$$PurchaseInvoice060005$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                          | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
		| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'                | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
		| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'                  | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                            | '*'      | '287,27'    | '287,27'        | '1 595,93'   | '$$PurchaseInvoice060005$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$PurchaseInvoice060005$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$PurchaseInvoice060005$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$PurchaseInvoice060005$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''        | ''                 | ''               | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner' | 'Legal name'       | 'Basis document' | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '20'        | 'Store 01'   | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'       | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Company Veritas ' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                          | ''         | ''         | ''        | ''              | '' | '' | '' | '' |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''         | ''         | ''        | 'Attributes'    | '' | '' | '' | '' |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                     | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060005$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060005$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''        | ''                 | ''                  | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''        | ''                 | ''                  | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner' | 'Legal name'       | 'Partner term'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'            | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                 | ''                  | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                 | ''                  | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'                  | ''                          | ''                 | ''                  | ''                        | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '20'                   | 'Store 01'       | 'L/Green'                   | ''                          | ''                 | ''                  | ''                        | ''                             | ''                     | ''                             | ''                     |
		And I close all client application windows
	
Scenario: _060006 create Cash payment with the type of settlements under standard contracts and check its movements
	* Create Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Cash desk №2' |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code' |
				| 'TRY'  |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Posting by Standard Partner term (Veritas)' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashPayment060006$$" variable
			And I delete "$$CashPayment060006$$" variable
			And I save the value of "Number" field as "$$NumberCashPayment060006$$"
			And I save the window as "$$CashPayment060006$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberCashPayment060006$$' |
		And I click "Registrations report" button
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CashPayment060006$$'                | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''         | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'       | 'Currency' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | 'Company Veritas ' | 'TRY'      | '' | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''        | ''                 | ''                  | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''        | ''                 | ''                  | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner' | 'Legal name'       | 'Partner term'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                     | ''                 | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | 'Attributes'           | ''                 | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation' | ''                 | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 883,2'             | 'Main Company'   | 'Cash desk №2'           | 'USD'            | 'Reporting currency'           | 'No'                   | ''                 | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Cash desk №2'           | 'TRY'            | 'Local currency'               | 'No'                   | ''                 | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Cash desk №2'           | 'TRY'            | 'en description is empty'      | 'No'                   | ''                 | ''                             | ''                     |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''        | ''                 | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner' | 'Legal name'       | 'Basis document' | 'Currency' |
			| ''                               | 'Expense'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      |
		And I close all client application windows

Scenario: _060007 check the offset of Purchase invoice advance with the type of settlement under standard contracts and check its movements
	* Create Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'   |
			And I select current line in "List" table
			And I click Clear button of "Partner term" field
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "12 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment060007$$" variable
		And I delete "$$BankPayment060007$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment060007$$"
		And I save the window as "$$BankPayment060007$$"
		And I click the button named "FormPostAndClose"
	* Check Bank Payment movements
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberBankPayment060007$$' |
		And I click "Registrations report" button
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankPayment060007$$'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         |
			| 'Document registrations records' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         |
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''        | ''                 | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner' | 'Legal name'       | 'Basis document' | 'Currency' |
			| ''                               | 'Receipt'     | '*'      | '12 000'               | ''               | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''         | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'       | 'Currency' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Company Veritas ' | 'TRY'      | '' | '' | '' | '' | '' |
		And I select "Advance to suppliers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Advance to suppliers"' | ''            | ''       | ''          | ''             | ''        | ''                 | ''         | ''                      | ''                             | ''                     | '' |
			| ''                                 | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''        | ''                 | ''         | ''                      | ''                             | 'Attributes'           | '' |
			| ''                                 | ''            | ''       | 'Amount'    | 'Company'      | 'Partner' | 'Legal name'       | 'Currency' | 'Payment document'      | 'Multi currency movement type' | 'Deferred calculation' | '' |
			| ''                                 | 'Receipt'     | '*'      | '2 054,4'   | 'Main Company' | 'Veritas' | 'Company Veritas ' | 'USD'      | '$$BankPayment060007$$' | 'Reporting currency'           | 'No'                   | '' |
			| ''                                 | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Veritas' | 'Company Veritas ' | 'TRY'      | '$$BankPayment060007$$' | 'Local currency'               | 'No'                   | '' |
			| ''                                 | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Veritas' | 'Company Veritas ' | 'TRY'      | '$$BankPayment060007$$' | 'en description is empty'      | 'No'                   | '' |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''                 | ''                             | ''                      | ''                             | ''                     | ''         |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''                 | ''                             | 'Attributes'            | ''                             | ''                     | ''         |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation'  | ''                             | ''                     | ''         |
			| ''                                     | 'Expense'     | '*'      | '2 054,4'             | 'Main Company'   | 'Bank account, TRY'      | 'USD'              | 'Reporting currency'           | 'No'                    | ''                             | ''                     | ''         |
			| ''                                     | 'Expense'     | '*'      | '12 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'              | 'Local currency'               | 'No'                    | ''                             | ''                     | ''         |
			| ''                                     | 'Expense'     | '*'      | '12 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'              | 'en description is empty'      | 'No'                    | ''                             | ''                     | ''         |
		And I close all client application windows
	* Create Purchase Invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'     |
			And I select current line in "List" table
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "20,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "550,00" text in "Price" field of "ItemList" table
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice060007$$" variable
			And I delete "$$PurchaseInvoice060007$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060007$$"
			And I save the window as "$$PurchaseInvoice060007$$"
	* Check movements PurchaseInvoice by register PartnerApTransactions
		And I click "Registrations report" button
		And I select "Inventory balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$PurchaseInvoice060007$$'      | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| 'Document registrations records' | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| 'Register  "Inventory balance"'  | ''            | ''       | ''          | ''             | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | ''            | ''       | 'Quantity'  | 'Company'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | '20'        | 'Main Company' | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Purchase turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Purchase turnovers"' | ''       | ''          | ''        | ''           | ''             | ''                          | ''         | ''         | ''        | ''                             | ''                     | '' | '' |
		| ''                               | 'Period' | 'Resources' | ''        | ''           | 'Dimensions'   | ''                          | ''         | ''         | ''        | ''                             | 'Attributes'           | '' | '' |
		| ''                               | ''       | 'Quantity'  | 'Amount'  | 'Net amount' | 'Company'      | 'Purchase invoice'          | 'Currency' | 'Item key' | 'Row key' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                               | '*'      | '20'        | '1 883,2' | '1 595,93'   | 'Main Company' | '$$PurchaseInvoice060007$$' | 'USD'      | 'L/Green'  | '*'       | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                               | '*'      | '20'        | '11 000'  | '9 322,03'   | 'Main Company' | '$$PurchaseInvoice060007$$' | 'TRY'      | 'L/Green'  | '*'       | 'Local currency'               | 'No'                   | '' | '' |
		| ''                               | '*'      | '20'        | '11 000'  | '9 322,03'   | 'Main Company' | '$$PurchaseInvoice060007$$' | 'TRY'      | 'L/Green'  | '*'       | 'TRY'                          | 'No'                   | '' | '' |
		| ''                               | '*'      | '20'        | '11 000'  | '9 322,03'   | 'Main Company' | '$$PurchaseInvoice060007$$' | 'TRY'      | 'L/Green'  | '*'       | 'en description is empty'      | 'No'                   | '' | '' |
		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                          | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
		| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'                | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
		| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'                  | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                            | '*'      | '287,27'    | '287,27'        | '1 595,93'   | '$$PurchaseInvoice060007$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
		| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$PurchaseInvoice060007$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
		| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$PurchaseInvoice060007$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
		| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$PurchaseInvoice060007$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''        | ''                 | ''               | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner' | 'Legal name'       | 'Basis document' | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      | '' | '' |
		| ''                               | 'Expense'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      | '' | '' |
		| ''                               | 'Expense'     | '*'      | '11 000'               | ''               | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      | '' | '' |
		And I select "Stock reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock reservation"' | ''            | ''       | ''          | ''           | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Record type' | 'Period' | 'Resources' | 'Dimensions' | ''         | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | ''            | ''       | 'Quantity'  | 'Store'      | 'Item key' | '' | '' | '' | '' | '' | '' | '' | '' |
		| ''                              | 'Receipt'     | '*'      | '20'        | 'Store 01'   | 'L/Green'  | '' | '' | '' | '' | '' | '' | '' | '' |
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''         | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'       | 'Currency' | '' | '' | '' | '' | '' | '' | '' |
		| ''                                     | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Company Veritas ' | 'TRY'      | '' | '' | '' | '' | '' | '' | '' |
		And I select "Advance to suppliers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Advance to suppliers"' | ''            | ''       | ''          | ''             | ''        | ''                 | ''         | ''                      | ''                             | ''                     | '' | '' | '' |
		| ''                                 | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''        | ''                 | ''         | ''                      | ''                             | 'Attributes'           | '' | '' | '' |
		| ''                                 | ''            | ''       | 'Amount'    | 'Company'      | 'Partner' | 'Legal name'       | 'Currency' | 'Payment document'      | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
		| ''                                 | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | 'Veritas' | 'Company Veritas ' | 'USD'      | '$$BankPayment060007$$' | 'Reporting currency'           | 'No'                   | '' | '' | '' |
		| ''                                 | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Veritas' | 'Company Veritas ' | 'TRY'      | '$$BankPayment060007$$' | 'Local currency'               | 'No'                   | '' | '' | '' |
		| ''                                 | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Veritas' | 'Company Veritas ' | 'TRY'      | '$$BankPayment060007$$' | 'en description is empty'      | 'No'                   | '' | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                          | ''         | ''         | ''        | ''              | '' | '' | '' | '' |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''         | ''         | ''        | 'Attributes'    | '' | '' | '' | '' |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                     | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060007$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060007$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''        | ''                 | ''                  | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''        | ''                 | ''                  | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner' | 'Legal name'       | 'Partner term'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		And I select "Stock balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Stock balance"'            | ''            | ''          | ''                     | ''               | ''                          | ''                          | ''                 | ''                      | ''                             | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                          | ''                          | ''                 | ''                      | ''                             | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | ''            | ''          | 'Quantity'             | 'Store'          | 'Item key'                  | ''                          | ''                 | ''                      | ''                             | ''                             | ''                     | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '*'         | '20'                   | 'Store 01'       | 'L/Green'                   | ''                          | ''                 | ''                      | ''                             | ''                             | ''                     | ''                             | ''                     |
	And I close all client application windows
	

Scenario: _060008 create Bank payment with the type of settlements under standard contracts and check its movements
	* Create Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Bank account, TRY' |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Veritas'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Posting by Standard Partner term (Veritas)' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment060008$$" variable
			And I delete "$$BankPayment060008$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment060008$$"
			And I save the window as "$$BankPayment060008$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberBankPayment060008$$' |
		And I click "Registrations report" button
		And I select "Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankPayment060008$$'                | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| 'Document registrations records'       | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''             | ''                 | ''         | '' | '' | '' | '' | '' |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''         | '' | '' | '' | '' | '' |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'      | 'Legal name'       | 'Currency' | '' | '' | '' | '' | '' |
			| ''                                     | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | 'Company Veritas ' | 'TRY'      | '' | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''        | ''                 | ''                  | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''        | ''                 | ''                  | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner' | 'Legal name'       | 'Partner term'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Veritas' | 'Company Veritas ' | 'Standard (Vendor)' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                     | ''                 | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | 'Attributes'           | ''                 | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation' | ''                 | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 883,2'             | 'Main Company'   | 'Bank account, TRY'      | 'USD'            | 'Reporting currency'           | 'No'                   | ''                 | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'Local currency'               | 'No'                   | ''                 | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'en description is empty'      | 'No'                   | ''                 | ''                             | ''                     |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''        | ''                 | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''        | ''                 | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner' | 'Legal name'       | 'Basis document' | 'Currency' |
			| ''                               | 'Expense'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Veritas' | 'Company Veritas ' | ''               | 'TRY'      |
		And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session