#language: en
@tree
@Positive
@BankCashDocuments

Feature: create Cash payment

As a cashier
//I want to pay cash
//In order to record the fact of payment

Background:
	Given I launch TestClient opening script or connect the existing one
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
# The currency of reports is lira
# CashBankDocFilters export scenarios

	
Scenario: _051001 preparation (Cash payment)
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
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
		When Create catalog Partners objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018001$$" |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice29604
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice29604$$" |
			When create a purchase invoice for the purchase of sets and dimensional grids at the tore 02

Scenario: _051001 create Cash payment based on Purchase invoice
	* Open list form Purchase invoice and select PI №1
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Create and filling in Purchase invoice
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '137 000,00' | '$$PurchaseInvoice018001$$' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Amount'    | 'Multiplicity' |
			| 'Reporting currency' | '23 458,90' | '1'            |
	* Data overflow check
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '137 000,00' | '$$PurchaseInvoice018001$$' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'    | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '23 458,90' | '1'            |
	* Check calculation Document amount
		Then the form attribute named "DocumentAmount" became equal to "137 000,00"
	* Change in basis document
		And I select current line in "PaymentList" table
		And I click choice button of "Basis document" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Reference'        |
			| '$$PurchaseInvoice29604$$'      |
		And I click "Select" button
		And in "PaymentList" table I move to the next cell
	* Change in payment amount
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '20 000,00' | '$$PurchaseInvoice29604$$' |
	And I close all client application windows




Scenario: _051001 create Cash payment (independently)
	* Create Cash payment in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description  |
				| TRY  | Turkish lira |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
			| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "1000,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0510011$$" variable
		And I delete "$$CashPayment0510011$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510011$$"
		And I save the window as "$$CashPayment0510011$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash payment
			And "List" table contains lines
			| 'Number' |
			|  '$$NumberCashPayment0510011$$'    | 
	* Create Cash payment in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description     |
				| USD  | American dollar |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
			| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "20,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0510012$$" variable
		And I delete "$$CashPayment0510012$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510012$$"
		And I save the window as "$$CashPayment0510012$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number' |
			| '$$NumberCashPayment0510012$$'    |
	* Create Cash payment in Euro for Ferron BP (Partner term in USD)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №2 |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description |
				| EUR  | Euro        |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Vendor Ferron, USD' |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "150,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0510013$$" variable
		And I delete "$$CashPayment0510013$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510013$$"
		And I save the window as "$$CashPayment0510013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash payment
			And "List" table contains lines
			| 'Number' |
			| '$$NumberCashPayment0510013$$'    |	
	
Scenario: check Cash payment movements by register Partner Ap Transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Legal name'        | 'Basis document'            | 'Company'      | 'Amount'   | 'Partner term'       | 'Partner'   |
		| 'TRY'      | '$$CashPayment0510011$$' | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' | 'Main Company' | '1 000,00' | 'Vendor Ferron, TRY' | 'Ferron BP' |
		| 'USD'      | '$$CashPayment0510012$$' | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' | 'Main Company' | '20,00'    | 'Vendor Ferron, TRY' | 'Ferron BP' |
		| 'EUR'      | '$$CashPayment0510013$$' | 'Company Ferron BP' | ''                          | 'Main Company' | '150,00'   | 'Vendor Ferron, USD' | 'Ferron BP' |
		And I close all client application windows

Scenario: _050002 check Cash payment movements with transaction type Payment to the vendor
	* Open Cash payment 1
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements Cash payment 1
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
		| '$$CashPayment0510011$$'               | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| 'Document registrations records'       | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | ''               | ''                          | ''               | 'Dimensions'                   | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'    | 'Transaction AR' | 'Company'                      | 'Partner'              | 'Legal name'        | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Expense'     | '*'      | ''                     | '1 000'          | ''                          | ''               | 'Main Company'                 | 'Ferron BP'            | 'Company Ferron BP' | '$$PurchaseInvoice018001$$'    | 'TRY'                  |
		| ''                                     | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Legal name'                | 'Currency'       | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '1 000'                | 'Main Company'   | 'Company Ferron BP'         | 'TRY'            | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| 'Register  "Partner AP transactions"'  | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | 'Attributes'           |
		| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Basis document'            | 'Partner'        | 'Legal name'                   | 'Partner term'         | 'Currency'          | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'      | '171,23'               | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'USD'               | 'Reporting currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'TRY'               | 'en description is empty'      | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'TRY'               | 'Local currency'               | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'TRY'               | 'TRY'                          | 'No'                   |
		| ''                                     | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                          | ''               | ''                             | 'Attributes'           | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                   | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation' | ''                  | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'      | '171,23'               | 'Main Company'   | 'Cash desk №1'              | 'USD'            | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Cash desk №1'              | 'TRY'            | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Cash desk №1'              | 'TRY'            | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
		And I close all client application windows
	* Clear movements Cash payment 1 and check that there is no movement on the registers
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberCashPayment0510011$$'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$CashPayment0510011$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$CashPayment0510011$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.ReconciliationStatement"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$CashPayment0510011$$' |
			And I close all client application windows
	* * Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.CashPayment"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberCashPayment0510011$$'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$CashPayment0510011$$'               | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| 'Register  "Accounts statement"'       | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | ''               | ''                          | ''               | 'Dimensions'                   | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'    | 'Transaction AR' | 'Company'                      | 'Partner'              | 'Legal name'        | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Expense'     | '*'      | ''                     | '1 000'          | ''                          | ''               | 'Main Company'                 | 'Ferron BP'            | 'Company Ferron BP' | '$$PurchaseInvoice018001$$'    | 'TRY'                  |
			| ''                                     | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Legal name'                | 'Currency'       | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '1 000'                | 'Main Company'   | 'Company Ferron BP'         | 'TRY'            | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| 'Register  "Partner AP transactions"'  | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Basis document'            | 'Partner'        | 'Legal name'                   | 'Partner term'         | 'Currency'          | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '171,23'               | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'USD'               | 'Reporting currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'TRY'               | 'en description is empty'      | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'TRY'               | 'Local currency'               | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | '$$PurchaseInvoice018001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Vendor Ferron, TRY'   | 'TRY'               | 'TRY'                          | 'No'                   |
			| ''                                     | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                          | ''               | ''                             | 'Attributes'           | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                   | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation' | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '171,23'               | 'Main Company'   | 'Cash desk №1'              | 'USD'            | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Cash desk №1'              | 'TRY'            | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Cash desk №1'              | 'TRY'            | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
			And I close all client application windows

# Filters

Scenario: _051002 filter check by own companies in the document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the filter by own company


Scenario: _051003 cash filter check (bank selection not available) in the document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the filter by cash account (bank account selection is not available)

Scenario: _051004 check input Description in the documentCash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check filling in Description

Scenario: _051005 check the choice of transaction type in the document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the choice of type of operation in the payment documents

Scenario: _051006 check legal name filter in tabular part in document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the legal name filter in the tabular part of the payment documents

Scenario: _051007 check partner filter in tabular part in document Cash payment
	# when selecting a legal name, only its partners should be available on the partner selection list
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the partner filter in the tabular part of the payment documents.
	
Scenario: _051008 check basis document filter in Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	* Filling in the details of the document
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I click the button named "FormChoose"
		And I click Select button of "Cash account" field
		And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
		And I select current line in "List" table
		Then the form attribute named "CashAccount" became equal to "Cash desk №1"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
	* Filling in partner and legal name
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And "List" table contains lines
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| Partner   | Payee             |
			| Ferron BP | Company Ferron BP |
	When check the filter on the basis documents in the payment documents



# EndFilters


Scenario: _051010 check currency selection in Cash payment document in case the currency is specified in the account
# the choice is not available
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	When check the choice of currency in the cash payment document if the currency is indicated in the account




Scenario: _051012 check the display of details on the form Cash payment with the type of operation Payment to the vendor
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description  |
			| Kalipso |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| # | Partner | Amount | Payee              | Basis document | Planning transaction basis |
		| 1 | Kalipso | ''     | Company Kalipso    | ''             | ''                        |



Scenario: _051013 check the display of details on the form Cash payment with the type of operation Currency exchange
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description  |
			| Anna Petrova |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| # | Partner      | Amount| Planning transaction basis |
		| 1 | Anna Petrova | ''    | ''                        |


Scenario: _051014 check the display of details on the form Cash payment with the type of operation Cash transfer order
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payee" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
		| # | 'Amount'    | Planning transaction basis |
		| 1 | '100,00'    | ''                        |


Scenario: _300512 check connection to CashPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberCashPayment0510011$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
