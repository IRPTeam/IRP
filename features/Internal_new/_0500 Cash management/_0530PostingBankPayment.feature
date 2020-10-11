#language: en
@tree
@Positive
@BankCashDocuments

Feature: create Bank payment


As an accountant
I want to pay by bank payment.
To close debts to partners

Background:
	Given I launch TestClient opening script or connect the existing one
# The currency of reports is lira
# CashBankDocFilters export scenarios


	
Scenario: _053000 preparation (Bank payment)
	* Constants
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


Scenario: _053001 create Bank payment based on Purchase invoice
	* Open list form Purchase invoice and select PI №1
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
	* Create and filling in Purchase invoice
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '136 000,00' | '$$PurchaseInvoice018001$$' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Amount'    | 'Multiplicity' |
			| 'Reporting currency' | '23 287,67' | '1'            |
	* Data overflow check
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '136 000,00' | '$$PurchaseInvoice018001$$' |
		And "PaymentListCurrencies" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'    | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '23 287,67' | '1'            |
	* Check calculation Document amount
		Then the form attribute named "DocumentAmount" became equal to "136 000,00"
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




Scenario: _053001 create Bank payment (independently)
	* Create Bank payment in lire for Ferron BP (Purchase invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Select transaction type
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		* Filling in the details of the document
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description  |
				| TRY  | Turkish lira |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
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
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "1000,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment0530011$$" variable
		And I delete "$$BankPayment0530011$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0530011$$"
		And I save the window as "$$BankPayment0530011$$"
		And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number' |
				| '$$NumberBankPayment0530011$$'    |
	* Create Bank payment in USD for Ferron BP (Purchase invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code | Description     |
				| USD  | American dollar |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, USD |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
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
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '137 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "20,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment0530012$$" variable
		And I delete "$$BankPayment0530012$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0530012$$"
		And I save the window as "$$BankPayment0530012$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
				| 'Number' |
				| '$$NumberBankPayment0530012$$'    |
	* Create Bank payment in Euro for Ferron BP (Purchase invoice in USD)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code | Description |
				| EUR  | Euro        |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description    |
				| Bank account, EUR |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
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
		And I delete "$$NumberBankPayment0530013$$" variable
		And I delete "$$BankPayment0530013$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0530013$$"
		And I save the window as "$$BankPayment0530013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Bank payment
			And "List" table contains lines
				| 'Number' |
				| '$$NumberBankPayment0530013$$'    |

Scenario: _053002 check Bank payment movements by register PartnerApTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerApTransactions"
		And "List" table contains lines
			| 'Currency' | 'Recorder'               | 'Legal name'        | 'Basis document'            | 'Company'      | 'Amount'   | 'Partner term'       | 'Partner'   |
			| 'TRY'      | '$$BankPayment0530011$$' | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' | 'Main Company' | '1 000,00' | 'Vendor Ferron, TRY' | 'Ferron BP' |
			| 'USD'      | '$$BankPayment0530012$$' | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' | 'Main Company' | '20,00'    | 'Vendor Ferron, TRY' | 'Ferron BP' |
			| 'EUR'      | '$$BankPayment0530013$$' | 'Company Ferron BP' | '*'                         | 'Main Company' | '150,00'   | 'Vendor Ferron, USD' | 'Ferron BP' |
		And I close all client application windows


Scenario: _050002 check Bank payment movements with transaction type Payment to the vendor
	* Open Bank payment 1
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankPayment0530011$$'      |
	* Check movements Bank payment 1
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$BankPayment0530011$$'               | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
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
			| ''                                     | 'Expense'     | '*'      | '171,23'               | 'Main Company'   | 'Bank account, TRY'         | 'USD'            | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Bank account, TRY'         | 'TRY'            | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Bank account, TRY'         | 'TRY'            | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
		And I close all client application windows
	* Clear movements Bank payment 1 and check that there is no movement on the registers
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankPayment0530011$$'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$BankPayment0530011$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$BankPayment0530011$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.ReconciliationStatement"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$BankPayment0530011$$' |
			And I close all client application windows
	* * Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.BankPayment"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankPayment0530011$$'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$BankPayment0530011$$'               | ''            | ''       | ''                     | ''               | ''                          | ''               | ''                             | ''                     | ''                  | ''                             | ''                     |
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
			| ''                                     | 'Expense'     | '*'      | '171,23'               | 'Main Company'   | 'Bank account, TRY'         | 'USD'            | 'Reporting currency'           | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Bank account, TRY'         | 'TRY'            | 'en description is empty'      | 'No'                   | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '1 000'                | 'Main Company'   | 'Bank account, TRY'         | 'TRY'            | 'Local currency'               | 'No'                   | ''                  | ''                             | ''                     |
			And I close all client application windows

# Filters

Scenario: _053003 filter check by own companies in the document Bank payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the filter by own company

	

Scenario: _053004 check the filter by bank accounts (the choice of Cash/Bank accounts is not available) + filling in currency from the bank account in Bank payment document
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the filter for bank accounts (cash account selection is not available) + filling in currency from a bank account

Scenario: _053005 check input Description in the document Bank payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check filling in Description

Scenario: _053006 check the choice of transaction type in the document Bank payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the choice of type of operation in the payment documents
	

Scenario: _053007 check legal name filter in tabular part in document Bank payment
	# when selecting a partner, only its legal names should be available on the selection list
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the legal name filter in the tabular part of the payment documents
	


Scenario: _053008 check partner filter in tabular part in document Bank payment
	# when selecting a legal name, only its partners should be available on the partner selection list
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the partner filter in the tabular part of the payment documents.
	

# EndFilters

Scenario: _053011 check currency selection in Bank payment document in case the currency is specified in the account
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	When check the choice of currency in the bank payment document if the currency is indicated in the account




Scenario: _053013 check the display of details on the form Bank payment with the type of operation Payment to the vendor
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is unavailable
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description  |
			| Kalipso |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| '#' | Partner | Amount | Payee              | Basis document | Planning transaction basis |
			| '1' | Kalipso | ''     | Company Kalipso    | ''             | ''                        |







Scenario: _053015 check the display of details on the form Bank payment with the type of operation Cash transfer
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is unavailable
	* Check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payee" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
			| '#' | 'Amount' | 'Planning transaction basis' |
			| '1' | '100,00' | ''                          |


Scenario: _300514 check connection to BankPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberBankPayment0530011$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows