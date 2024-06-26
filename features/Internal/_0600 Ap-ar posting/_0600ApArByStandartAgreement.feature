#language: en
@tree
@Positive
@StandartAgreement

Feature: accounting of receivables / payables under Standard type Partner terms

As an accountant
I want to settle general Partner terms for all partners.

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



	
Scenario: _060000 preparation
	When set True value to the constant
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
		When Create catalog Countries objects
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
		When Create information register Taxes records (VAT)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Countries objects
		When Create catalog BusinessUnits objects 


Scenario: _0600001 check preparation
	When check preparation

Scenario: _060002 create Sales invoice with the type of settlements under standard Partner terms
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Nicoletta'       |
			And I select current line in "List" table
		* Adding items to Sales Invoice
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
			And I activate "Quantity" field in "ItemList" table
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice060002$$" variable
			And I delete "$$SalesInvoice060002$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice060002$$"
			And I save the window as "$$SalesInvoice060002$$"
		* Check filling in sales invoice
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'          | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '20,000'     | 'Basic Price Types'   | 'pcs'    | '*'            | '*'            | '11 000,00'      | 'Store 01'    |
			And I click the button named "FormPostAndClose"
		* Check Sales invoice movements
			And I go to line in "List" table
				| 'Number'                           |
				| '$$NumberSalesInvoice060002$$'     |
			And I click "Registrations report" button
			And I select "R2021 Customer transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Document registrations records'             | ''               | ''          | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                     | ''             | ''                       | ''         | ''         | ''         | ''                        | ''                               |
				| 'Register  "R2021 Customer transactions"'    | ''               | ''          | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                     | ''             | ''                       | ''         | ''         | ''         | ''                        | ''                               |
				| ''                                           | 'Record type'    | 'Period'    | 'Resources'    | 'Dimensions'      | ''          | ''                                | ''            | ''                        | ''                     | ''             | ''                       | ''         | ''         | ''         | 'Attributes'              | ''                               |
				| ''                                           | ''               | ''          | 'Amount'       | 'Company'         | 'Branch'    | 'Multi currency movement type'    | 'Currency'    | 'Transaction currency'    | 'Legal name'           | 'Partner'      | 'Agreement'              | 'Basis'    | 'Order'    | 'Project'  | 'Deferred calculation'    | 'Customers advances closing'     |
				| ''                                           | 'Receipt'        | '*'         | '1 883,2'      | 'Main Company'    | '*'         | 'Reporting currency'              | 'USD'         | 'TRY'                     | 'Company Nicoletta'    | 'Nicoletta'    | 'Standard (Customer)'    | ''         | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '*'         | '11 000'       | 'Main Company'    | '*'         | 'Local currency'                  | 'TRY'         | 'TRY'                     | 'Company Nicoletta'    | 'Nicoletta'    | 'Standard (Customer)'    | ''         | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '*'         | '11 000'       | 'Main Company'    | '*'         | 'en description is empty'         | 'TRY'         | 'TRY'                     | 'Company Nicoletta'    | 'Nicoletta'    | 'Standard (Customer)'    | ''         | ''         | ''         | 'No'                      | ''                               |
	And I close all client application windows

Scenario: _060003 create Cash receipt with the type of settlements under standard Partner terms and check its movements
	* Create Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash desk №2'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Nicoletta'       |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                                   |
				| 'Posting by Standard Partner term Customer'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt060003$$" variable
		And I delete "$$CashReceipt060003$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt060003$$"
		And I save the window as "$$CashReceipt060003$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberCashReceipt060003$$'    |
		And I close all client application windows

Scenario: _0600031 create Bank receipt with the type of settlements under standard Partner terms and check its movements
	* Create Bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Bank account, TRY'     |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Nicoletta'       |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                                   |
				| 'Posting by Standard Partner term Customer'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0600031$$" variable
		And I delete "$$BankReceipt0600031$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0600031$$"
		And I save the window as "$$BankReceipt0600031$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberBankReceipt0600031$$'    |
		And I close all client application windows



Scenario: _060005 create Purchase invoice with the type of settlements under standard contracts and check its movements
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Veritas'         |
			And I select current line in "List" table
		* Adding items to Purchase Invoice
			And I move to "Item list" tab
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
			And I activate "Quantity" field in "ItemList" table
			And I input "20,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "550,00" text in "Price" field of "ItemList" table
		* Check filling in purchase invoice
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'                | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '20,000'     | 'en description is empty'   | 'pcs'    | '1 677,97'     | '9 322,03'     | '11 000,00'      | 'Store 01'    |
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice060005$$" variable
			And I delete "$$PurchaseInvoice060005$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060005$$"
			And I save the window as "$$PurchaseInvoice060005$$"
	* Check Purchase Invoice movements 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseInvoice060005$$'                | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'   | 'Agreement'           | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Receipt'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Standard (Vendor)'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Receipt'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Standard (Vendor)'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Receipt'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Standard (Vendor)'   | ''        | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows
	
Scenario: _060006 create Cash payment with the type of settlements under standard contracts and check its movements
	* Create Cash payment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Cash desk №2'     |
			And I select current line in "List" table
			And I click Choice button of the field named "Currency"
			And I go to line in "List" table
				| 'Code'     |
				| 'TRY'      |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Veritas'         |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                                    |
				| 'Posting by Standard Partner term (Veritas)'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashPayment060006$$" variable
			And I delete "$$CashPayment060006$$" variable
			And I save the value of "Number" field as "$$NumberCashPayment060006$$"
			And I save the window as "$$CashPayment060006$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberCashPayment060006$$'    |
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CashPayment060006$$'                    | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                                             | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                                             | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                                             | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                                             | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'   | 'Agreement'                                    | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Expense'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Posting by Standard Partner term (Veritas)'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Posting by Standard Partner term (Veritas)'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Posting by Standard Partner term (Veritas)'   | ''        | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows

	

Scenario: _060008 create Bank payment with the type of settlements under standard contracts and check its movements
	* Create Bank payment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Select company
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
		* Filling in the details of the document
			And I click Select button of "Account" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Bank account, TRY'     |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Veritas'         |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                                    |
				| 'Posting by Standard Partner term (Veritas)'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment060008$$" variable
			And I delete "$$BankPayment060008$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment060008$$"
			And I save the window as "$$BankPayment060008$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberBankPayment060008$$'    |
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankPayment060008$$'                    | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                   | ''          | ''                    | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'         | 'Partner'   | 'Agreement'           | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Expense'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Standard (Vendor)'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Standard (Vendor)'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Veritas '   | 'Veritas'   | 'Standard (Vendor)'   | ''        | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows