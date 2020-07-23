#language: en
@tree
@Positive
Feature: create Cash reciept

As a cashier
I want to accept the cash in hand.
For Cash/Bank accountsing



Background:
	Given I launch TestClient opening script or connect the existing one
# The currency of reports is lira
# CashBankDocFilters export scenarios


Scenario: _050001 create Cash reciept based on Sales invoice
	* Open list form Sales invoice and select SI №1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
	* Create and filling in Cash reciept
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 350,00' | 'Company Ferron BP' | 'Sales invoice 1*' | ''                          |
		And "CurrenciesPaymentList" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '744,86' | '1'            |
	* Check account selection and saving 
		And I click Select button of "Cash account" field
		And I go to line in "List" table
		| 'Description'  |
		| 'Cash desk №2' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 350,00' | 'Company Ferron BP' | 'Sales invoice 1*' | ''                          |
		And "CurrenciesPaymentList" table contains lines
			| 'Movement type'      | 'Type'      | 'Currency from' | 'Currency' | 'Rate presentation' | 'Amount' | 'Multiplicity' |
			| 'Reporting currency' | 'Reporting' | 'TRY'           | 'USD'      | '5,8400'            | '744,86' | '1'            |
		Then the form attribute named "DocumentAmount" became equal to "4 350,00"
	* Change of Partner term and basis document
		And I select current line in "PaymentList" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                   |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		# temporarily
		// And Delay 2
		// When I Check the steps for Exception
		// |'And I click choice button of "Basis document" attribute in "PaymentList" table'|
		// # temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I go to line in "List" table
			| 'Company'      | 'Document amount' | 'Legal name'        | 'Partner'   |
			| 'Main Company' | '11 099,93'       | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
	* Change in payment amount
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                     | 'Amount'    | 'Payer'             | 'Basis document'  |
			| 'Ferron BP' | 'Basic Partner terms, without VAT' | '20 000,00' | 'Company Ferron BP' | 'Sales invoice 2*' |
	And I close all client application windows




Scenario: _050001 create Cash reciept (independently)
	* Create Cash receipt in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code | Description  |
				| TRY  | Turkish lira |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
			And I select current line in "List" table
		* Change the document number to 1
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "1" text in "Number" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
//			And I click choice button of "Basis document" attribute in "PaymentList" table
//			# temporarily
//			When I Check the steps for Exception
//			|'And I click choice button of "Basis document" attribute in "PaymentList" table'|
//			# temporarily
			Given form with "Documents for incoming payment" header is opened in the active window
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "100,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click "Post and close" button
		* Check creation a Cash receipt
			And "List" table contains lines
			| Number |
			|   1    |
	* Create Cash receipt in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code |
				| USD  |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
			And I select current line in "List" table
		* Change the document number to 2
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2" text in "Number" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			// # temporarily
			// When I Check the steps for Exception
			// |'And I click choice button of "Basis document" attribute in "PaymentList" table'|
			// # temporarily
			Given form with "Documents for incoming payment" header is opened in the active window
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "100,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click "Post and close" button
		* Check creation a Cash receipt
			And "List" table contains lines
			| Number |
			|   2    |
	* Create Cash receipt in Euro for Ferron BP (Sales invoice in USD)
		When create Sales invoice for Ferron BP in USD
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
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
			And I select current line in "List" table
		* Change the document number to 3
			And I input "0" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "3" text in "Number" field
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			Given form with "Documents for incoming payment" header is opened in the active window
			And I go to line in "List" table
				| 'Document amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '200,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "50,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click "Post and close" button
		* Check creation a Cash receipt
			And "List" table contains lines
			| Number |
			|   3    |

Scenario: _050002 check Cash receipt movements by register PartnerArTransactions
	Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
	And "List" table contains lines
	| 'Currency' | 'Recorder'           | 'Legal name'        |  'Basis document'     | 'Company'      | 'Amount'    | 'Partner term'                     | 'Partner'   |
	| 'TRY'      | 'Cash receipt 1*'    | 'Company Ferron BP' |  'Sales invoice 1*'   | 'Main Company' | '100,00'    | 'Basic Partner terms, TRY'         | 'Ferron BP' |
	| 'USD'      | 'Cash receipt 2*'    | 'Company Ferron BP' |  'Sales invoice 1*'   | 'Main Company' | '100,00'    | 'Basic Partner terms, TRY'         | 'Ferron BP' |
	| 'EUR'      | 'Cash receipt 3*'    | 'Company Ferron BP' |  'Sales invoice 234*' | 'Main Company' | '50,00'     | 'Ferron, USD'                   | 'Ferron BP' |

Scenario: _050002 check Cash receipt movements with transaction type Payment from customer
	* Open Cash receipt 1
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I go to line in "List" table
			| 'Number' |
			| '1'      |
	* Check movements Cash receipt 1
		And I click "Registrations report" button
		Then "ResultTable" spreadsheet document is equal by template
			| 'Cash receipt 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Partner term'             | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '17,12'     | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'               | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                  | 'Partner'               | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                     | 'Expense'     | '*'                   | ''                    | ''               | ''                                          | '100'            | 'Main Company'             | 'Ferron BP'             | 'Company Ferron BP' | 'Sales invoice 1*'         | 'TRY'                  |
			| ''                                     | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Company Ferron BP'    | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Multi currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company'    | 'Cash desk №1'         | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
		And I close all client application windows
	* Clear movements Cash receipt 1 and check that there is no movement on the registers
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.CashReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '1'      |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.PartnerArTransactions"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Cash receipt 1*' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Cash receipt 1*' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.ReconciliationStatement"
			And "List" table does not contain lines
				| 'Recorder'           |
				| 'Cash receipt 1*' |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.CashReceipt"
			And I go to line in "List" table
				| 'Number' |
				| '1'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			Then "ResultTable" spreadsheet document is equal by template
			| 'Cash receipt 1*'                      | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Document registrations records'       | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Partner AR transactions"'  | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | 'Attributes'           |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Basis document'       | 'Partner'      | 'Legal name'               | 'Partner term'             | 'Currency' | 'Multi currency movement type'   | 'Deferred calculation' |
			| ''                                     | 'Expense'     | '*'      | '17,12'     | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'USD'      | 'Reporting currency'       | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'en descriptions is empty' | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'Local currency'           | 'No'                   |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Sales invoice 1*'     | 'Ferron BP'    | 'Company Ferron BP'     | 'Basic Partner terms, TRY' | 'TRY'      | 'TRY'                      | 'No'                   |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Accounts statement"'       | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period'              | 'Resources'           | ''               | ''                                          | ''               | 'Dimensions'               | ''                      | ''                  | ''                         | ''                     |
			| ''                                     | ''            | ''                    | 'Advance to suppliers' | 'Transaction AP' | 'Advance from customers'                    | 'Transaction AR' | 'Company'                  | 'Partner'               | 'Legal name'        | 'Basis document'           | 'Currency'             |
			| ''                                     | 'Expense'     | '*'                   | ''                    | ''               | ''                                          | '100'            | 'Main Company'             | 'Ferron BP'             | 'Company Ferron BP' | 'Sales invoice 1*'         | 'TRY'                  |
			| ''                                     | ''            | ''                    | ''                    | ''               | ''                                          | ''               | ''                         | ''                      | ''                  | ''                         | ''                     |
			| 'Register  "Reconciliation statement"' | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Legal name'           | 'Currency'     | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Expense'     | '*'      | '100'       | 'Main Company'    | 'Company Ferron BP'    | 'TRY'          | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| 'Register  "Account balance"'          | ''            | ''       | ''          | ''                | ''                     | ''             | ''                         | ''                      | ''         | ''                         | ''                     |
			| ''                                     | 'Record type' | 'Period' | 'Resources' | 'Dimensions'      | ''                     | ''             | ''                         | 'Attributes'            | ''         | ''                         | ''                     |
			| ''                                     | ''            | ''       | 'Amount'    | 'Company'         | 'Account'              | 'Currency'     | 'Multi currency movement type'   | 'Deferred calculation'  | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '17,12'     | 'Main Company'    | 'Cash desk №1'         | 'USD'          | 'Reporting currency'       | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'en descriptions is empty' | 'No'                    | ''         | ''                         | ''                     |
			| ''                                     | 'Receipt'     | '*'      | '100'       | 'Main Company'    | 'Cash desk №1'         | 'TRY'          | 'Local currency'           | 'No'                    | ''         | ''                         | ''                     |
			And I close all client application windows




# Filters

Scenario: _050003 filter check by own companies in the document Cash reciept
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the filter by own company

Scenario: _050004 cash filter check (bank selection not available)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the filter by cash account (bank account selection is not available)


Scenario: _050005 check input Description in the documentCash reciept
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check filling in Description

Scenario: _050006 check the choice of transaction type in the documentCash reciept
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the choice of the type of operation in the documents of receipt of payment


Scenario: _050007 check legal name filter in tabular part in document Cash reciept
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the legal name filter in the tabular part of the payment receipt documents

Scenario: _050008 check partner filter in tabular part in document Cash reciept
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the partner filter in the tabular part of the payment receipt documents



# EndFilters


Scenario: _050011 check currency selection in Cash reciept document in case the currency is specified in the account
# the choice is not available
	When create a temporary cash desk Cash account No. 4 with a strictly fixed currency (lira)
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	When check the choice of currency in the cash payment document if the currency is indicated in the account
	And I delete "CashAccounts" catalog element with the Description_en "Cash desk №4"




Scenario: _050013 check the display of details on the form Cash reciept with the type of operation Payment from customer
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	And I select "Payment from customer" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "CurrencyExchange" is unavailable
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description  |
			| Kalipso |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| # | Partner | Amount | Payer                | Basis document | Planning transaction basis |
		| 1 | Kalipso | ''     | Company Kalipso    | ''             | ''                        |



Scenario: _050014 check the display of details on the form Cash reciept with the type of operation Currency exchange
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "CurrencyExchange" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "2 000,00" text in "Amount exchange" field of "PaymentList" table
		And "PaymentList" table contains lines
			| '#' | 'Partner' | 'Amount' | 'Amount exchange' | 'Planning transaction basis' |
			| '1' | ''        | '100,00' | '2 000,00'        | ''                          |



Scenario: _050015 check the display of details on the form Cash reciept with the type of operation Cash transfer
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "CurrencyExchange" is unavailable
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payer" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
		| '#' | 'Amount' | 'Planning transaction basis' |
		| '1' | '100,00' | ''                          |


