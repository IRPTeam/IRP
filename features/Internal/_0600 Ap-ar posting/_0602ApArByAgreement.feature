#language: en
@tree
@Positive
@StandartAgreement

Feature: accounting of receivables / payables by Partner terms

As an accountant
I want to settle general Partner terms for partners group

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



	
Scenario: _060200 preparation
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

Scenario: _0602001 check preparation
	When check preparation

Scenario: _060202 create Sales invoice with Ar details by Partner terms and check its movements
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'         |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'                  |
				| 'Partner Kalipso Customer'     |
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
			And I delete "$$NumberSalesInvoice062002$$" variable
			And I delete "$$SalesInvoice060202$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice060202$$"
			And I save the window as "$$SalesInvoice060202$$"
		* Check filling in sales invoice
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'          | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '20,000'     | 'Basic Price Types'   | 'pcs'    | '*'            | '*'            | '11 000,00'      | 'Store 02'    |
			And I click the button named "FormPostAndClose"
		* Check Sales invoice movements
			And I go to line in "List" table
				| 'Number'                           |
				| '$$NumberSalesInvoice060202$$'     |
			And I click "Registrations report" button
			And I select "R2021 Customer transactions" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$SalesInvoice060202$$'                     | ''               | ''          | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                   | ''                   | ''                            | ''         | ''         | ''         | ''                        | ''                               |
				| 'Document registrations records'             | ''               | ''          | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                   | ''                   | ''                            | ''         | ''         | ''         | ''                        | ''                               |
				| 'Register  "R2021 Customer transactions"'    | ''               | ''          | ''             | ''                | ''          | ''                                | ''            | ''                        | ''                   | ''                   | ''                            | ''         | ''         | ''         | ''                        | ''                               |
				| ''                                           | 'Record type'    | 'Period'    | 'Resources'    | 'Dimensions'      | ''          | ''                                | ''            | ''                        | ''                   | ''                   | ''                            | ''         | ''         | ''         | 'Attributes'              | ''                               |
				| ''                                           | ''               | ''          | 'Amount'       | 'Company'         | 'Branch'    | 'Multi currency movement type'    | 'Currency'    | 'Transaction currency'    | 'Legal name'         | 'Partner'            | 'Agreement'                   | 'Basis'    | 'Order'    | 'Project'  | 'Deferred calculation'    | 'Customers advances closing'     |
				| ''                                           | 'Receipt'        | '*'         | '1 883,2'      | 'Main Company'    | '*'         | 'Reporting currency'              | 'USD'         | 'TRY'                     | 'Company Kalipso'    | 'Partner Kalipso'    | 'Partner Kalipso Customer'    | ''         | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '*'         | '11 000'       | 'Main Company'    | '*'         | 'Local currency'                  | 'TRY'         | 'TRY'                     | 'Company Kalipso'    | 'Partner Kalipso'    | 'Partner Kalipso Customer'    | ''         | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '*'         | '11 000'       | 'Main Company'    | '*'         | 'TRY'                             | 'TRY'         | 'TRY'                     | 'Company Kalipso'    | 'Partner Kalipso'    | 'Partner Kalipso Customer'    | ''         | ''         | ''         | 'No'                      | ''                               |
				| ''                                           | 'Receipt'        | '*'         | '11 000'       | 'Main Company'    | '*'         | 'en description is empty'         | 'TRY'         | 'TRY'                     | 'Company Kalipso'    | 'Partner Kalipso'    | 'Partner Kalipso Customer'    | ''         | ''         | ''         | 'No'                      | ''                               |
	And I close all client application windows

Scenario: _060203 create Cash receipt (partner term with Ar details by partner term) and check its movements
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
				| 'Description'         |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                  |
				| 'Partner Kalipso Customer'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt060203$$" variable
		And I delete "$$CashReceipt060203$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt060203$$"
		And I save the window as "$$CashReceipt060203$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberCashReceipt060203$$'    |
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CashReceipt060203$$'                     | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'            | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | ''                       | ''                              |
			| ''                                          | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                          | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'                  | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                          | 'Expense'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Kalipso'   | 'Partner Kalipso'   | 'Partner Kalipso Customer'   | ''        | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Kalipso'   | 'Partner Kalipso'   | 'Partner Kalipso Customer'   | ''        | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Kalipso'   | 'Partner Kalipso'   | 'Partner Kalipso Customer'   | ''        | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows

Scenario: _0602031 create Bank receipt (partner term with Ar details by partner term) and check its movements
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
				| 'Description'         |
				| 'Partner Kalipso'     |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                  |
				| 'Partner Kalipso Customer'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0602031$$" variable
		And I delete "$$BankReceipt0602031$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0602031$$"
		And I save the window as "$$BankReceipt0602031$$"
		And I click the button named "FormPostAndClose"
	* Check movements
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberBankReceipt0602031$$'    |
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankReceipt0602031$$'                    | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'            | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | ''                       | ''                              |
			| ''                                          | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                  | ''                  | ''                           | ''        | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                          | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'           | 'Agreement'                  | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                          | 'Expense'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Kalipso'   | 'Partner Kalipso'   | 'Partner Kalipso Customer'   | ''        | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Kalipso'   | 'Partner Kalipso'   | 'Partner Kalipso Customer'   | ''        | ''        | ''        | 'No'                     | ''                              |
			| ''                                          | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Kalipso'   | 'Partner Kalipso'   | 'Partner Kalipso Customer'   | ''        | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows


Scenario: _060205 create Purchase invoice with Ap details by Partner terms and check its movements
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I click "List" button	
			And I go to line in "List" table
				| 'Description'          |
				| 'Partner Ferron 1'     |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Company Ferron BP'     |
			And I select current line in "List" table			
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'         |
				| 'Vendor Ferron 1'     |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
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
			And I move to "Other" tab
			And I move to "More" tab
			And I set checkbox "Price includes tax"
			And I move to "Item list" tab
		* Check filling in purchase invoice
			And "ItemList" table contains lines
			| 'Price'    | 'Item'    | 'VAT'   | 'Item key'   | 'Quantity'   | 'Price type'                | 'Unit'   | 'Tax amount'   | 'Net amount'   | 'Total amount'   | 'Store'       |
			| '550,00'   | 'Dress'   | '18%'   | 'L/Green'    | '20,000'     | 'en description is empty'   | 'pcs'    | '1 677,97'     | '9 322,03'     | '11 000,00'      | 'Store 01'    |
			And I input end of the current month date in "Delivery date" field
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice060205$$" variable
			And I delete "$$PurchaseInvoice060205$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice060205$$"
			And I save the window as "$$PurchaseInvoice060205$$"
	* Check Purchase Invoice movements 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$PurchaseInvoice060205$$'                | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'            | 'Agreement'         | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Receipt'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Receipt'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Receipt'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows
	
Scenario: _060206 create Cash payment (partner term with Ap details by partner term) and check its movements
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
				| 'Description'          |
				| 'Partner Ferron 1'     |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Vendor Ferron 1'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberCashPayment060206$$" variable
			And I delete "$$CashPayment060206$$" variable
			And I save the value of "Number" field as "$$NumberCashPayment060206$$"
			And I save the window as "$$CashPayment060206$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberCashPayment060206$$'    |
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$CashPayment060206$$'                    | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'            | 'Agreement'         | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Expense'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |

		And I close all client application windows

	

Scenario: _060208 create Bank payment (partner term with Ap details by partner term) and check its movements
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
				| 'Description'          |
				| 'Partner Ferron 1'     |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Vendor Ferron 1'     |
			And I select current line in "List" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "11 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click the button named "FormPost"
			And I delete "$$NumberBankPayment060208$$" variable
			And I delete "$$BankPayment060208$$" variable
			And I save the value of "Number" field as "$$NumberBankPayment060208$$"
			And I save the window as "$$BankPayment060208$$"
		And I click the button named "FormPostAndClose"
		And I go to line in "List" table
			| 'Number'                         |
			| '$$NumberBankPayment060208$$'    |
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankPayment060208$$'                    | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'           | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'   | ''              | ''         | ''            | ''               | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'     | ''         | ''                               | ''           | ''                       | ''                    | ''                   | ''                  | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                         | ''              | ''         | 'Amount'      | 'Company'        | 'Branch'   | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'            | 'Agreement'         | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                         | 'Expense'       | '*'        | '1 883,2'     | 'Main Company'   | '*'        | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                         | 'Expense'       | '*'        | '11 000'      | 'Main Company'   | '*'        | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Partner Ferron 1'   | 'Vendor Ferron 1'   | ''        | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows