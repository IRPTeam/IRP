#language: en
@tree
@Positive
@Group9
Feature: create Bank reciept

As an accountant
I want to display the incoming bank payments
To close partners debts

Background:
	Given I launch TestClient opening script or connect the existing one
# The currency of reports is lira
# CashBankDocFilters export scenarios

Scenario: _052001 create Bank reciept based on Sales invoice
	* Open list form Sales invoice and select SI №1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$SalesInvoice024001$$'      |
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
	* Create and filling in Bank reciept
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 250,00' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | ''                          |
		And "CurrenciesPaymentList" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '727,74' | '1'            |
	* Check account selection and saving 
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'USD'      | 'Bank account, USD' |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Account" became equal to "Bank account, USD"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 250,00' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | ''                          |
		And "CurrenciesPaymentList" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount'    | 'Multiplicity' |
			| 'TRY'                | 'Partner term' | 'USD'           | 'TRY'      | '0,1770'            | '24 011,30' | '1'            |
			| 'Local currency'     | 'Legal'     | 'USD'           | 'TRY'      | '0,1770'            | '24 011,30' | '1'            |
		Then the form attribute named "DocumentAmount" became equal to "4 250,00"
	* Change of Partner term and basis document
		And I select current line in "PaymentList" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                   |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And I go to line in "List" table
			| 'Company'      | 'Document amount' | 'Legal name'        | 'Partner'   |
			| 'Main Company' | '11 099,93'       | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
		And in "PaymentList" table I move to the next cell
	* Change in payment amount
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                     | 'Amount'    | 'Payer'             | 'Basis document'  |
			| 'Ferron BP' | 'Basic Partner terms, without VAT' | '20 000,00' | 'Company Ferron BP' | '$$SalesInvoice024008$$' |
	And I close all client application windows


Scenario: _052001 create Bank receipt (independently)
	* Create Bank receipt in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
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
		// * Change the document number to 1
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "1" text in "Number" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			Given form with "Documents for incoming payment" header is opened in the active window
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "100,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBankReceipt0520011$$"
		And I save the window as "$$BankReceipt0520011$$"
		And I click "Post and close" button
		* Check creation a Cash receipt
			And "List" table contains lines
				| 'Number' |
				| '$$NumberBankReceipt0520011$$'    |
	* Create Bank receipt in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
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
		// * Change the document number to 2
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "2" text in "Number" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			Given form with "Documents for incoming payment" header is opened in the active window
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "100,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBankReceipt0520012$$"
		And I save the window as "$$BankReceipt0520012$$"
		And I click "Post and close" button
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number' |
			|  '$$NumberBankReceipt0520012$$'    |
	* Create Bank receipt in Euro for Ferron BP (Sales invoice in USD)
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
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
		// * Change the document number to 3
		// 	And I input "0" text in "Number" field
		// 	Then "1C:Enterprise" window is opened
		// 	And I click "Yes" button
		// 	And I input "3" text in "Number" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Ferron, USD' |
			And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			Given form with "Documents for incoming payment" header is opened in the active window
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '200,00'          | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "50,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberBankReceipt0520013$$"
		And I save the window as "$$BankReceipt0520013$$"
		And I click "Post and close" button
		* Check creation a Bank receipt
			And "List" table contains lines
			| 'Number' |
			| '$$NumberBankReceipt0520013$$'    |	
	

Scenario: _052002 check Bank reciept movements by register PartnerArTransactions
	Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
	And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Legal name'        | 'Basis document'         | 'Company'      | 'Amount' | 'Partner term'             | 'Partner'   |
		| 'TRY'      | '$$BankReceipt0520011$$' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | 'Main Company' | '100,00' | 'Basic Partner terms, TRY' | 'Ferron BP' |
		| 'USD'      | '$$BankReceipt0520012$$' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | 'Main Company' | '100,00' | 'Basic Partner terms, TRY' | 'Ferron BP' |
		| 'EUR'      | '$$BankReceipt0520013$$' | 'Company Ferron BP' | 'Sales invoice 234*'     | 'Main Company' | '50,00'  | '*'                        | 'Ferron BP' |
	And I close all client application windows


Scenario: _050002  check Bank receipt movements with transaction type Payment from customer
	* Open Bank receipt 1
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberBankReceipt0520011$$'      |
	* Check movements Bank receipt 1
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
		| '$$BankReceipt0520011$$'               | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| 'Document registrations records'       | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| 'Register  "Partner AR transactions"'  | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | 'Attributes'           |
		| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'                   | 'Partner term'             | 'Currency'          | 'Multi currency movement type' | 'Deferred calculation' |
		| ''                                     | 'Expense'     | '*'      | '17,12'                | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'USD'               | 'Reporting currency'           | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'TRY'               | 'en description is empty'      | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'TRY'               | 'Local currency'               | 'No'                   |
		| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'TRY'               | 'TRY'                          | 'No'                   |
		| ''                                     | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| 'Register  "Accounts statement"'       | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'                   | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'                      | 'Partner'                  | 'Legal name'        | 'Basis document'               | 'Currency'             |
		| ''                                     | 'Expense'     | '*'      | ''                     | ''               | ''                       | '100'            | 'Main Company'                 | 'Ferron BP'                | 'Company Ferron BP' | '$$SalesInvoice024001$$'       | 'TRY'                  |
		| ''                                     | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| 'Register  "Reconciliation statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
		| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | 'Attributes'               | ''                  | ''                             | ''                     |
		| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation'     | ''                  | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '17,12'                | 'Main Company'   | 'Bank account, TRY'      | 'USD'            | 'Reporting currency'           | 'No'                       | ''                  | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '100'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'en description is empty'      | 'No'                       | ''                  | ''                             | ''                     |
		| ''                                     | 'Receipt'     | '*'      | '100'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'Local currency'               | 'No'                       | ''                  | ''                             | ''                     |
		And I close all client application windows
	* Clear movements Bank receipt 1 and check that there is no movement on the registers
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankReceipt0520011$$'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$BankReceipt0520011$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$BankReceipt0520011$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.ReconciliationStatement"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$BankReceipt0520011$$' |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.BankReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberBankReceipt0520011$$'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| '$$BankReceipt0520011$$'               | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Basis document'         | 'Partner'        | 'Legal name'                   | 'Partner term'             | 'Currency'          | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '17,12'                | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'USD'               | 'Reporting currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'TRY'               | 'en description is empty'      | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'TRY'               | 'Local currency'               | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | '$$SalesInvoice024001$$' | 'Ferron BP'      | 'Company Ferron BP'            | 'Basic Partner terms, TRY' | 'TRY'               | 'TRY'                          | 'No'                   |
			| ''                                     | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| 'Register  "Accounts statement"'       | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | ''               | ''                       | ''               | 'Dimensions'                   | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers' | 'Transaction AR' | 'Company'                      | 'Partner'                  | 'Legal name'        | 'Basis document'               | 'Currency'             |
			| ''                                     | 'Expense'     | '*'      | ''                     | ''               | ''                       | '100'            | 'Main Company'                 | 'Ferron BP'                | 'Company Ferron BP' | '$$SalesInvoice024001$$'       | 'TRY'                  |
			| ''                                     | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Legal name'             | 'Currency'       | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'                  | 'Main Company'   | 'Company Ferron BP'      | 'TRY'            | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''                     | ''               | ''                       | ''               | ''                             | ''                         | ''                  | ''                             | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources'            | 'Dimensions'     | ''                       | ''               | ''                             | 'Attributes'               | ''                  | ''                             | ''                     |
			| ''                                     | ''            | ''       | 'Amount'               | 'Company'        | 'Account'                | 'Currency'       | 'Multi currency movement type' | 'Deferred calculation'     | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '17,12'                | 'Main Company'   | 'Bank account, TRY'      | 'USD'            | 'Reporting currency'           | 'No'                       | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'en description is empty'      | 'No'                       | ''                  | ''                             | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'                  | 'Main Company'   | 'Bank account, TRY'      | 'TRY'            | 'Local currency'               | 'No'                       | ''                  | ''                             | ''                     |
			And I close all client application windows

# Filters

Scenario: _052003 filter check by own companies in the document Bank Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check the filter by own company

Scenario: _052004 check the filter by bank accounts (the choice of Cash/Bank accounts is not available) + filling in currency from the bank account in Bank Receipt document
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check the filter for bank accounts (cash account selection is not available) + filling in currency from a bank account


Scenario: _052005 check input Description in the document Bank Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check filling in Description

Scenario: _052006 check the choice of transaction type in the document Bank Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check the choice of the type of operation in the documents of receipt of payment

Scenario: _052007 check legal name filter in tabular part in document Bank Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check the legal name filter in the tabular part of the payment receipt documents

Scenario: _052008 check partner filter in tabular part in document Bank Receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	When check the partner filter in the tabular part of the payment receipt documents


# EndFilters

Scenario: _052011 check currency selection in Bank receipt document in case the currency is specified in the account
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	When check the choice of currency in the bank payment document if the currency is indicated in the account




Scenario: _052013 check the display of details on the form Bank receipt with the type of operation Payment from customer
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	And I select "Payment from customer" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is unavailable
		And form attribute named "CurrencyExchange" is unavailable
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description  |
			| Kalipso |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| '#' | Partner | Amount | Payer              | Basis document | Planning transaction basis |
			| '1' | Kalipso | ''     | Company Kalipso    | ''             | ''                        |



Scenario: _052014 check the display of details on the form Bank receipt with the type of operation Currency exchange
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "2 000,00" text in "Amount exchange" field of "PaymentList" table
		And "PaymentList" table contains lines
			| '#' | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
			| '1' | '100,00' | '2 000,00'        | ''                          |




Scenario: _052015 check the display of details on the form Bank receipt with the type of operation Cash transfer order
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is unavailable
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payer" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
			| '#' | 'Amount' | 'Planning transaction basis' |
			| '1' | '100,00' | ''                          |
