#language: en
@tree
@Positive
@StandartAgreement

Feature: accounting of receivables / payables by Partner terms

As an accountant
I want to settle general Partner terms for partners group


Background:
	Given I launch TestClient opening script or connect the existing one



	
Scenario: _060200 preparation
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


Scenario: _060202 create Sales invoice with Ar details by Partner terms and check its movements
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso Customer'     |
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
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice062002$$" variable
			And I delete "$$SalesInvoice060202$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice060202$$"
			And I save the window as "$$SalesInvoice060202$$"
		* Check filling in sales invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'        | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'Basic Price Types' | 'pcs'  | '*'          | '*'          | '11 000,00'    | 'Store 02' |
			And I click the button named "FormPostAndClose"
		* Check Sales invoice movements
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberSalesInvoice060202$$'  |
			And I click "Registrations report" button
			And I select "Partner AR transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice060202$$'              | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     | '' | '' |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                | ''                | ''                         | ''         | ''                             | 'Attributes'           | '' | '' |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'         | 'Legal name'      | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
			And I select "Taxes turnovers" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                       | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
			| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'             | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
			| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'               | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                            | '*'      | '287,27'    | '287,27'        | '1 595,93'   | '$$SalesInvoice060202$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060202$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060202$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060202$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
			And I select "Accounts statement" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                | ''                | ''               | ''         | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                | ''                | ''               | ''         | '' | '' |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'         | 'Legal name'      | 'Basis document' | 'Currency' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | ''               | 'TRY'      | '' | '' |
		
		
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
			And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''                | ''                       | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''                | ''                       | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'           | 'Item key'               | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '20'                   | 'Main Company'   | '$$SalesInvoice060202$$' | 'Store 02'        | 'L/Green'                | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |

	And I close all client application windows

Scenario: _060203 create Cash receipt (partner term with Ar details by partner term) and check its movements
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
				| 'Partner Kalipso'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'              |
				| 'Partner Kalipso Customer' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt060203$$" variable
		And I delete "$$CashReceipt060203$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt060203$$"
		And I save the window as "$$CashReceipt060203$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberCashReceipt060203$$'  |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CashReceipt060203$$'               | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                | ''                | ''                         | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'         | 'Legal name'      | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'en description is empty'      | 'No'                   |
	
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
			| ''                                     | 'Expense'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company'                 | 'Partner Kalipso'      | 'Company Kalipso' | ''                             | 'TRY'                  |
		And I close all client application windows

Scenario: _0602031 create Bank receipt (partner term with Ar details by partner term) and check its movements
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
				| 'Partner Kalipso'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'              |
				| 'Partner Kalipso Customer' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0602031$$" variable
		And I delete "$$BankReceipt0602031$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0602031$$"
		And I save the window as "$$BankReceipt0602031$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt0602031$$'  |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankReceipt0602031$$'              | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                | ''                | ''                         | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'         | 'Legal name'      | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'en description is empty'      | 'No'                   |
	
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
			| ''                                     | 'Expense'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company'                 | 'Partner Kalipso'            | 'Company Kalipso' | ''                             | 'TRY'                  |
		And I close all client application windows

Scenario: _060204 check the offset of the advance for Sales invoice with the type of settlement under Partner terms and check its movements
	And I delete "$$NumberSalesInvoice060204$$" variable
	And I delete "$$SalesInvoice060204$$" variable
	And I delete "$$NumberBankReceipt060204$$" variable
	And I delete "$$BankReceipt060204$$" variable
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
				| 'Partner Kalipso'   |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "12 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click Clear button of "Partner term" field
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt060204$$" variable
		And I delete "$$BankReceipt060204$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt060204$$"
		And I save the window as "$$BankReceipt060204$$"
		And I click the button named "FormPostAndClose"
	* Check Bank Receipt movements 
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberBankReceipt060204$$' |
		And I click "Registrations report" button
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankReceipt060204$$'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                | ''                | ''               | ''         |
			| 'Document registrations records' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                | ''                | ''               | ''         |
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                | ''                | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                | ''                | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'         | 'Legal name'      | 'Basis document' | 'Currency' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | '12 000'                 | ''               | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | ''               | 'TRY'      |
	
		And I select "Advance from customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Advance from customers"' | ''            | ''       | ''          | ''             | ''                | ''                | ''         | ''                      | ''                             | ''                     | '' |
			| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                | ''                | ''         | ''                      | ''                             | 'Attributes'           | '' |
			| ''                                   | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'         | 'Legal name'      | 'Currency' | 'Receipt document'      | 'Multi currency movement type' | 'Deferred calculation' | '' |
			| ''                                   | 'Receipt'     | '*'      | '2 054,4'   | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | 'USD'      | '$$BankReceipt060204$$' | 'Reporting currency'           | 'No'                   | '' |
			| ''                                   | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | 'TRY'      | '$$BankReceipt060204$$' | 'Local currency'               | 'No'                   | '' |
			| ''                                   | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | 'TRY'      | '$$BankReceipt060204$$' | 'en description is empty'      | 'No'                   | '' |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''                | ''                             | ''                      | ''                             | ''                     | ''         |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''                | ''                             | 'Attributes'            | ''                             | ''                     | ''         |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'        | 'Multi currency movement type' | 'Deferred calculation'  | ''                             | ''                     | ''         |
			| ''                                     | 'Receipt'     | '*'      | '2 054,4'             | 'Main Company'   | 'Bank account, TRY'      | 'USD'             | 'Reporting currency'           | 'No'                    | ''                             | ''                     | ''         |
			| ''                                     | 'Receipt'     | '*'      | '12 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'             | 'Local currency'               | 'No'                    | ''                             | ''                     | ''         |
			| ''                                     | 'Receipt'     | '*'      | '12 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'             | 'en description is empty'      | 'No'                    | ''                             | ''                     | ''         |
		And I close all client application windows
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Kalipso'     |
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
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice060204$$" variable
			And I delete "$$SalesInvoice060204$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice060204$$"
			And I save the window as "$$SalesInvoice060204$$"
			And I click the button named "FormPostAndClose"
	* Check SalesInvoice movements
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberSalesInvoice060204$$' |
		And I click "Registrations report" button
		And I select "Partner AR transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$SalesInvoice060204$$'              | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Document registrations records'      | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     | '' | '' |
			| 'Register  "Partner AR transactions"' | ''            | ''       | ''          | ''             | ''               | ''                | ''                | ''                         | ''         | ''                             | ''                     | '' | '' |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                | ''                | ''                         | ''         | ''                             | 'Attributes'           | '' | '' |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'         | 'Legal name'      | 'Partner term'             | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
			| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |

		And I select "Taxes turnovers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Taxes turnovers"' | ''       | ''          | ''              | ''           | ''                       | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | ''                     |
			| ''                            | 'Period' | 'Resources' | ''              | ''           | 'Dimensions'             | ''    | ''          | ''         | ''                        | ''        | ''         | ''                             | 'Attributes'           |
			| ''                            | ''       | 'Amount'    | 'Manual amount' | 'Net amount' | 'Document'               | 'Tax' | 'Analytics' | 'Tax rate' | 'Include to total amount' | 'Row key' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                            | '*'      | '287,27'    | '287,27'        | '1 595,93'   | '$$SalesInvoice060204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                            | '*'      | '1 677,97'  | '1 677,97'      | '9 322,03'   | '$$SalesInvoice060204$$' | 'VAT' | ''          | '18%'      | 'Yes'                     | '*'       | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                | ''                | ''               | ''         | '' | '' |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                | ''                | ''               | ''         | '' | '' |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'         | 'Legal name'      | 'Basis document' | 'Currency' | '' | '' |
			| ''                               | 'Receipt'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | ''               | 'TRY'      | '' | '' |
			| ''                               | 'Expense'     | '*'      | ''                     | ''               | ''                       | '11 000'         | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | ''               | 'TRY'      | '' | '' |
			| ''                               | 'Expense'     | '*'      | ''                     | ''               | '11 000'                 | ''               | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | ''               | 'TRY'      | '' | '' |
	
	
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
			| 'Register  "Advance from customers"' | ''            | ''       | ''          | ''             | ''                | ''                | ''         | ''                      | ''                             | ''                     | '' | '' | '' |
			| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                | ''                | ''         | ''                      | ''                             | 'Attributes'           | '' | '' | '' |
			| ''                                   | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'         | 'Legal name'      | 'Currency' | 'Receipt document'      | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
			| ''                                   | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | 'USD'      | '$$BankReceipt060204$$' | 'Reporting currency'           | 'No'                   | '' | '' | '' |
			| ''                                   | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | 'TRY'      | '$$BankReceipt060204$$' | 'Local currency'               | 'No'                   | '' | '' | '' |
			| ''                                   | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Partner Kalipso' | 'Company Kalipso' | 'TRY'      | '$$BankReceipt060204$$' | 'en description is empty'      | 'No'                   | '' | '' | '' |
		And I select "Shipment confirmation schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Shipment confirmation schedule"' | ''            | ''          | ''                     | ''               | ''                       | ''                | ''                       | ''                         | ''                             | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Record type' | 'Period'    | 'Resources'            | 'Dimensions'     | ''                       | ''                | ''                       | ''                         | 'Attributes'                   | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | ''            | ''          | 'Quantity'             | 'Company'        | 'Order'                  | 'Store'           | 'Item key'               | 'Row key'                  | 'Delivery date'                | ''                             | ''                             | ''                             | ''                     |
			| ''                                           | 'Receipt'     | '*'         | '20'                   | 'Main Company'   | '$$SalesInvoice060204$$' | 'Store 02'        | 'L/Green'                | '*'                        | '*'                            | ''                             | ''                             | ''                             | ''                     |
		And I close all client application windows


Scenario: _060205 create Purchase invoice with Ap details by Partner terms and check its movements
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Ferron 1'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'       |
				| 'Company Ferron BP' |
			And I select current line in "List" table			
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor Ferron 1'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'     |
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
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
		* Check filling in purchase invoice
			And "ItemList" table contains lines
			| 'Price'  | 'Item'  | 'VAT' | 'Item key' | 'Q'      | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' | 'Store'    |
			| '550,00' | 'Dress' | '18%' | 'L/Green'  | '20,000' | 'en description is empty' | 'pcs'  | '1 677,97'   | '9 322,03'   | '11 000,00'    | 'Store 01' |
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice060205$$" variable
			And I delete "$$PurchaseInvoice060205$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060205$$"
			And I save the window as "$$PurchaseInvoice060205$$"
	* Check Purchase Invoice movements 
		And I click "Registrations report" button

	
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                 | ''                  | ''               | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'          | 'Legal name'        | 'Basis document' | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      | '' | '' |
	
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                          | ''         | ''         | ''        | ''              | '' | '' | '' | '' |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''         | ''         | ''        | 'Attributes'    | '' | '' | '' | '' |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                     | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060205$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060205$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''                 | ''                  | ''                | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                 | ''                  | ''                | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'          | 'Legal name'        | 'Partner term'    | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		
		And I close all client application windows
	
Scenario: _060206 create Cash payment (partner term with Ap details by partner term) and check its movements
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
				| 'Description'        |
				| 'Partner Ferron 1'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Vendor Ferron 1' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashPayment060206$$" variable
			And I delete "$$CashPayment060206$$" variable
			And I save the value of "Number" field as "$$NumberCashPayment060206$$"
			And I save the window as "$$CashPayment060206$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberCashPayment060206$$' |
		And I click "Registrations report" button
	
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''                 | ''                  | ''                | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                 | ''                  | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'          | 'Legal name'        | 'Partner term'    | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''                 | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''                 | ''                             | 'Attributes'           | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation' | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 883,2'             | 'Main Company'   | 'Cash desk №2'           | 'USD'              | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Cash desk №2'           | 'TRY'              | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Cash desk №2'           | 'TRY'              | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                 | ''                  | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'          | 'Legal name'        | 'Basis document' | 'Currency' |
			| ''                               | 'Expense'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      |
		And I close all client application windows

Scenario: _060207 check the offset of the advance for Purchase invoice with the type of settlement under Partner terms and check its movements
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
				| 'Partner Ferron 1'   |
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
			| '$$BankPayment060007$$'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         |
			| 'Document registrations records' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         |
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                 | ''                  | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'          | 'Legal name'        | 'Basis document' | 'Currency' |
			| ''                               | 'Receipt'     | '*'      | '12 000'               | ''               | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      |
	
		And I select "Advance to suppliers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Advance to suppliers"' | ''            | ''       | ''          | ''             | ''                 | ''                  | ''         | ''                      | ''                             | ''                     | '' |
			| ''                                 | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''                  | ''         | ''                      | ''                             | 'Attributes'           | '' |
			| ''                                 | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'          | 'Legal name'        | 'Currency' | 'Payment document'      | 'Multi currency movement type' | 'Deferred calculation' | '' |
			| ''                                 | 'Receipt'     | '*'      | '2 054,4'   | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | 'USD'      | '$$BankPayment060007$$' | 'Reporting currency'           | 'No'                   | '' |
			| ''                                 | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | 'TRY'      | '$$BankPayment060007$$' | 'Local currency'               | 'No'                   | '' |
			| ''                                 | 'Receipt'     | '*'      | '12 000'    | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | 'TRY'      | '$$BankPayment060007$$' | 'en description is empty'      | 'No'                   | '' |
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
			And I click "List" button	
			And I go to line in "List" table
				| 'Description' |
				| 'Partner Ferron 1'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description' |
				| 'Vendor Ferron 1'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'     |
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
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice060207$$" variable
			And I delete "$$PurchaseInvoice060207$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060207$$"
			And I save the window as "$$PurchaseInvoice060207$$"
	* Check movements PurchaseInvoice by register PartnerApTransactions
		And I click "Registrations report" button
	
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         | '' | '' |
		| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                 | ''                  | ''               | ''         | '' | '' |
		| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'          | 'Legal name'        | 'Basis document' | 'Currency' | '' | '' |
		| ''                               | 'Receipt'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      | '' | '' |
		| ''                               | 'Expense'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      | '' | '' |
		| ''                               | 'Expense'     | '*'      | '11 000'               | ''               | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      | '' | '' |
	
		And I select "Advance to suppliers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Advance to suppliers"' | ''            | ''       | ''          | ''             | ''                 | ''                  | ''         | ''                      | ''                             | ''                     | '' | '' | '' |
		| ''                                 | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                 | ''                  | ''         | ''                      | ''                             | 'Attributes'           | '' | '' | '' |
		| ''                                 | ''            | ''       | 'Amount'    | 'Company'      | 'Partner'          | 'Legal name'        | 'Currency' | 'Payment document'      | 'Multi currency movement type' | 'Deferred calculation' | '' | '' | '' |
		| ''                                 | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | 'USD'      | '$$BankPayment060007$$' | 'Reporting currency'           | 'No'                   | '' | '' | '' |
		| ''                                 | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | 'TRY'      | '$$BankPayment060007$$' | 'Local currency'               | 'No'                   | '' | '' | '' |
		| ''                                 | 'Expense'     | '*'      | '11 000'    | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | 'TRY'      | '$$BankPayment060007$$' | 'en description is empty'      | 'No'                   | '' | '' | '' |
		And I select "Goods receipt schedule" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Goods receipt schedule"' | ''            | ''       | ''          | ''             | ''                          | ''         | ''         | ''        | ''              | '' | '' | '' | '' |
		| ''                                   | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''                          | ''         | ''         | ''        | 'Attributes'    | '' | '' | '' | '' |
		| ''                                   | ''            | ''       | 'Quantity'  | 'Company'      | 'Order'                     | 'Store'    | 'Item key' | 'Row key' | 'Delivery date' | '' | '' | '' | '' |
		| ''                                   | 'Receipt'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060207$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		| ''                                   | 'Expense'     | '*'      | '20'        | 'Main Company' | '$$PurchaseInvoice060207$$' | 'Store 01' | 'L/Green'  | '*'       | '*'             | '' | '' | '' | '' |
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
		| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''                 | ''                  | ''                | ''         | ''                             | ''                     | '' | '' |
		| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                 | ''                  | ''                | ''         | ''                             | 'Attributes'           | '' | '' |
		| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'          | 'Legal name'        | 'Partner term'    | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		| ''                                    | 'Receipt'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'USD'      | 'Reporting currency'           | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'Local currency'               | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'TRY'                          | 'No'                   | '' | '' |
		| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'en description is empty'      | 'No'                   | '' | '' |
	
	And I close all client application windows
	

Scenario: _060208 create Bank payment (partner term with Ap details by partner term) and check its movements
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
				| 'Partner Ferron 1'   |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                            |
				| 'Vendor Ferron 1' |
			And I select current line in "List" table
			And I activate field named "PaymentListAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment060208$$" variable
			And I delete "$$BankPayment060208$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment060208$$"
			And I save the window as "$$BankPayment060208$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'  |
			| '$$NumberBankPayment060208$$' |
		And I click "Registrations report" button
	
		And I select "Partner AP transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Partner AP transactions"' | ''            | ''       | ''          | ''             | ''               | ''                 | ''                  | ''                | ''         | ''                             | ''                     |
			| ''                                    | 'Record type' | 'Period' | 'Resources' | 'Dimensions'   | ''               | ''                 | ''                  | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                    | ''            | ''       | 'Amount'    | 'Company'      | 'Basis document' | 'Partner'          | 'Legal name'        | 'Partner term'    | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                    | 'Expense'     | '*'      | '1 883,2'   | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                    | 'Expense'     | '*'      | '11 000'    | 'Main Company' | ''               | 'Partner Ferron 1' | 'Company Ferron BP' | 'Vendor Ferron 1' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I select "Account balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''                 | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''                 | ''                             | 'Attributes'           | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'         | 'Multi currency movement type' | 'Deferred calculation' | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 883,2'             | 'Main Company'   | 'Bank account, TRY'      | 'USD'              | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'              | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '11 000'               | 'Main Company'   | 'Bank account, TRY'      | 'TRY'              | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
		And I select "Accounts statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| 'Register  "Accounts statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''             | ''                 | ''                  | ''               | ''         |
			| ''                               | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'   | ''                 | ''                  | ''               | ''         |
			| ''                               | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'      | 'Partner'          | 'Legal name'        | 'Basis document' | 'Currency' |
			| ''                               | 'Expense'     | '*'      | ''                     | '11 000'         | ''                       | ''               | 'Main Company' | 'Partner Ferron 1' | 'Company Ferron BP' | ''               | 'TRY'      |
		And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session