#language: en
@tree
@Positive
@Group9
Feature: create cash transfer

As an accountant
I want to transfer money from one account to another.
For actual Cash/Bank accountsing

Background:
	Given I launch TestClient opening script or connect the existing one
# The currency of reports is lira


Scenario: _054001 create Cash transfer order (from Cash/Bank accounts to Cash/Bank accounts in the same currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №1 |
		And I select current line in "List" table
		And I input "500,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "500,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Filling Send date and Receive date
		And I input "01.07.2019  0:00:00" text in "Send date" field
		And I input "01.07.2019  0:00:00" text in "Receive date" field
	* Change the document number
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender       | Receiver     | Company      |
		| 1      | Cash desk №1 | Cash desk №2 | Main Company |
	And I close all client application windows

Scenario: _054002 check Cash transfer order movements by register Planing cash transactions
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		And I close all client application windows
	* Clear movements
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1'       |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table does not contain lines
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		And I close all client application windows
	* Re-posting document
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
			| 'Currency' | 'Recorder'         | 'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '500,00'    |
			| 'USD'      | 'Cash transfer order 1*' | 'Cash transfer order 1*'      | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '500,00'    |
		And I close all client application windows





Scenario: _054003 create Cash payment and Cash reciept based on Cash transfer order + check movements
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I go to line in "List" table
		| Number | Sender       | Receiver     | Company      |
		| 1      | Cash desk №1 | Cash desk №2 | Main Company |
	And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Change the document number to 4
		And I input "4" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "4" text in "Number" field
	* Check the filling of the tabular part
		And "PaymentList" table contains lines
		| 'Planning transaction basis'    | 'Amount' |
		| 'Cash transfer order 1*'             | '500,00' |
	And I click "Post and close" button
	And Delay 5
	* Creation of Cash receipt for a partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender       | Receiver     | Company      |
			| 1      | Cash desk №1 | Cash desk №2 | Main Company |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		And I activate "Amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "400,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		* Change the document number to 4
			And I input "4" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "4" text in "Number" field
		And I click "Post and close" button
		And Delay 5
	* Creation of Cash receipt for the remaining amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender       | Receiver     | Company      |
			| 1      | Cash desk №1 | Cash desk №2 | Main Company |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
	* Change the document number to 5
		And I input "5" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5" text in "Number" field
	* Check that the tabular part shows the rest of the amount
		And I move to "Payments" tab
		And "PaymentList" table contains lines
		| 'Planning transaction basis'   | 'Amount' |
		| 'Cash transfer order 1*'      | '100,00'    |
	And I click "Post and close" button
	And I close all client application windows
	* Check movement of Cash payment and Cash reciept by register Planing cash transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'          |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'USD'      | 'Cash payment 4*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'            | '-500,00'   |
		| 'USD'      | 'Cash receipt 4*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '-400,00'   |
		| 'USD'      | 'Cash receipt 5*'   | 'Cash transfer order 1*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '-100,00'   |
	And I close all client application windows
	


Scenario: _054004 create Cash transfer order (from Cash/Bank accounts to Cash/Bank accounts in the different currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "200,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №1 |
		And I select current line in "List" table
		And I input "1150,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code | Description  |
			| TRY  | Turkish lira |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
	* Filling Send date and Receive date
		And I input "02.07.2019  0:00:00" text in "Send date" field
		And I input "03.07.2019  0:00:00" text in "Receive date" field
	* Change the document number to 2
		And I input "2" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender       | Receiver     | Company      |
		| 2      | Cash desk №2 | Cash desk №1 | Main Company |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Basis document'         | 'Company'      | 'Account'      | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Amount'   |
		| 'USD'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '200,00'   |
		| 'TRY'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '1 150,00' |
	And I close all client application windows

Scenario: _054005 create Cash receipt and Cash payment based on Cash transfer order in the different currency and check movements
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I go to line in "List" table
		| Number | Sender       | Receiver     | Company      |
		| 2      | Cash desk №2 | Cash desk №1 | Main Company |
	And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Change the document number to 5
		And I input "5" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5" text in "Number" field
	* Check the filling of the tabular part
		And "PaymentList" table contains lines
		| 'Planning transaction basis'    | 'Amount' |
		| 'Cash transfer order 2*'             | '200,00' |
	* Filling in the employee responsible for curremcy exchange
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Arina Brown |
		And I select current line in "List" table
	And I click "Post and close" button
	And Delay 5
	* Create Cash receipt for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender       | Receiver     | Company      |
			| 2      | Cash desk №2 | Cash desk №1 | Main Company |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
	* Change the document number to 7
			And I input "7" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "7" text in "Number" field
	* Check that the correct receipt amount is indicated in the tabular part
		And I move to "Payments" tab
		And Delay 5
		And "PaymentList" table contains lines
		| 'Planning transaction basis'         | 'Partner'            | 'Amount'      | 'Amount exchange' |
		| 'Cash transfer order 2*'            | 'Arina Brown'        | '1 150,00'    | '200,00'          |
	And I click "Post and close" button
	And I close all client application windows
	* Check Cash payment and Cash reciept movements by register PlaningCashTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'               | 'Basis document'         | 'Company'      | 'Account'      | 'Cash flow direction' | 'Partner' | 'Legal name' | 'Amount'    |
		| 'USD'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '200,00'    |
		| 'TRY'      | 'Cash transfer order 2*' | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '1 150,00'  |
		| 'USD'      | 'Cash payment 5*'        | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №2' | 'Outgoing'            | ''        | ''           | '-200,00'   |
		| 'TRY'      | 'Cash receipt 7*'        | 'Cash transfer order 2*' | 'Main Company' | 'Cash desk №1' | 'Incoming'            | ''        | ''           | '-1 150,00' |
	* Check Cash payment and Cash reciept movements by register AccountBalance
		Given I open hyperlink "e1cib/list/AccumulationRegister.AccountBalance"
		And "List" table contains lines
		| 'Currency' | 'Recorder'        | 'Company'      | 'Account'      | 'Amount'   |
		| 'TRY'      | 'Cash receipt 7*' | 'Main Company' | 'Cash desk №1' | '1 150,00' |
		| 'USD'      | 'Cash payment 5*' | 'Main Company' | 'Cash desk №2' | '200,00' |
		And I close all client application windows

	
Scenario: _054006 create Cash transfer order (from Cash/Bank accounts to bank account in the same currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №1 |
		And I select current line in "List" table
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| 'Code' | 'Description'     |
			| 'USD'  | 'American dollar' |
		And I select current line in "List" table
		And I input "500,00" text in "Send amount" field
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Bank account, USD |
		And I select current line in "List" table
		And I input "500,00" text in "Receive amount" field
	* Filling Send date and Receive date
		And I input "01.07.2019  0:00:00" text in "Send date" field
		And I input "02.07.2019  0:00:00" text in "Receive date" field
	* Change the document number
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender       | Receiver          | Company      |
		| 3      | Cash desk №1 | Bank account, USD | Main Company |
	And I close all client application windows
	* Post Cash payment
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender       | Receiver          | Company      |
			| 3      | Cash desk №1 | Bank account, USD | Main Company |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		* Check the filling of the tabular part
			And "PaymentList" table contains lines
			| 'Planning transaction basis'    | 'Amount' |
			| 'Cash transfer order 3*'             | '500,00' |
		* Change the document number to 6
			And I input "6" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "6" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
	*Post Bank reciept
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender       | Receiver          | Company      |
			| 3      | Cash desk №1 | Bank account, USD | Main Company |
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		And Delay 5
		* Change the document number to 4
			And I input "4" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "4" text in "Number" field
		* Check the filling of the tabular part
			And I move to "Payments" tab
			And "PaymentList" table contains lines
			| 'Amount' | 'Planning transaction basis'  |
			| '500,00'    |  'Cash transfer order 3*'          |
		And I click "Post and close" button
	* Check movements by register Planing cash transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency'| 'Recorder'               |  'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction'   | 'Amount'    |
		| 'USD'     | 'Cash transfer order 3*' | 'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'              | '500,00'    |
		| 'USD'     | 'Cash transfer order 3*' | 'Cash transfer order 3*' | 'Main Company' | 'Bank account, USD' | 'Incoming'              | '500,00'    |
		| 'USD'     | 'Cash payment 6*'        | 'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Outgoing'              | '-500,00'   |
		| 'USD'     | 'Bank receipt 4*'        | 'Cash transfer order 3*' | 'Main Company' | 'Bank account, USD' | 'Incoming'              | '-500,00'   |
		And I close all client application windows

Scenario: _054007 create Cash transfer order from bank account to Cash/Bank accounts (in the same currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Bank account, USD |
		And I select current line in "List" table
		And I input "100,00" text in "Send amount" field
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №1 |
		And I select current line in "List" table
		And I input "100,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Filling Send date and Receive date
		And I input "03.07.2019  0:00:00" text in "Send date" field
		And I input "04.07.2019  0:00:00" text in "Receive date" field
	* Change the document number
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "4" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender            | Receiver          | Company      |
		| 4      | Bank account, USD |Cash desk №1       | Main Company |
	And I close all client application windows
	* Post Bank payment
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender       | Receiver          | Company      |
			| 4      | Bank account, USD |Cash desk №1  | Main Company |
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		* Change the document number to 4
			And I input "4" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "4" text in "Number" field
		* Check the filling of the tabular part
			And "PaymentList" table contains lines
			| 'Planning transaction basis'    | 'Amount' |
			| 'Cash transfer order 4*'             |  '100,00' |
		And I click "Post and close" button
		And I close all client application windows
		And Delay 5
	* Post Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Sender            | Receiver     | Company      |
			| 4      | Bank account, USD |Cash desk №1  | Main Company |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		* Change the document number to 7
			And I input "7" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "7" text in "Number" field
		* Check the filling of the tabular part
			And "PaymentList" table contains lines
			| Planning transaction basis |  Amount |
			| Cash transfer order 4*          | '100,00'    |
		And I click "Post and close" button
	* Check movements by register PlaningCashTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
		And "List" table contains lines
		| 'Currency' | 'Recorder'                  |  'Basis document'        | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'USD'      | 'Cash transfer order 4*'    | 'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Outgoing'            | '100,00'    |
		| 'USD'      | 'Cash transfer order 4*'    | 'Cash transfer order 4*' | 'Main Company' | 'Cash desk №1'      | 'Incoming'            | '100,00'    |
		| 'USD'      | 'Cash receipt 8*'           | 'Cash transfer order 4*' | 'Main Company' | 'Cash desk №1'      | 'Incoming'            | '-100,00'   |
		| 'USD'      | 'Bank payment 4*'           | 'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Outgoing'            | '-100,00'   |
		And I close all client application windows

Scenario: _054008 currency exchange within one Cash/Bank accounts with exchange in parts (exchange rate has increased)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "1150,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code | Description  |
			| TRY  | Turkish lira |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "175,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code |
			| EUR  |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
	* Filling Send date and Receive date
		And I input "04.07.2019  0:00:00" text in "Send date" field
		And I input "05.07.2019  0:00:00" text in "Receive date" field
	* Change the document number to 5
		And I input "5" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender       | Receiver     | Company      |
		| 5      | Cash desk №2 | Cash desk №2 | Main Company |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	And "List" table contains lines
		| 'Currency'   | 'Recorder'         |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'TRY'        | 'Cash transfer order 5*' | 'Cash transfer order 5*' | 'Main Company' | 'Cash desk №2'      | 'Outgoing'            | '1 150,00'  |
		| 'EUR'        | 'Cash transfer order 5*' | 'Cash transfer order 5*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '175,00'    |
	And I close all client application windows
	* Create Cash payment based on Cash transfer order in partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Receive amount |
			| '5'      | '175,00'         |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Arina Brown |
		And I select current line in "List" table
		And I input "650,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		* Change the document number to 7
			And I move to "Other" tab
			And I input "7" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "7" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
	* Create Cash reciept based on Cash transfer order in partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Receive amount |
			| '5'      | '175,00'         |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "600,00" text in "Amount exchange" field of "PaymentList" table
		And I input "100,00" text in "Amount" field of "PaymentList" table
		* Change the document number to 9
			And I move to "Other" tab
			And I input "9" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "9" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
	* Post Cash payment on the rest of the amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Receive amount |
			| '5'      | '175,00'         |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Arina Brown |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'     | 'Amount'  | 'Planning transaction basis'    |
			| 'Arina Brown' | '500,00'  | 'Cash transfer order 5*'             |
		* Change the document number to 8
			And I move to "Other" tab
			And I input "8" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "8" text in "Number" field
		And I click "Post and close" button
	* Post Cash reciept on the rest of the amount + 10 lirs
	# Originally 1,150 lire, but the exchange rate of 175 euros cost 1,160 lire. We have to compensate for 10 lire.
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number | Receive amount |
			| '5'      | '175,00'         |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		And I input "560,00" text in "Amount exchange" field of "PaymentList" table
		And Delay 5
		And "PaymentList" table contains lines
			|'Partner'      | 'Amount' | 'Planning transaction basis'    | 'Amount exchange' |
			| 'Arina Brown' | '75,00'     |  'Cash transfer order 5*'            | '560,00'          |
		* Change the document number to 10
			And I move to "Other" tab
			And I input "10" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "10" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
		# issued 1150, spent 1160
		And I close all client application windows


Scenario: _054009 currency exchange within one Cash/Bank accounts with exchange in parts (exchange rate has decreased)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "1315,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code | Description  |
			| TRY  | Turkish lira |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "200,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code |
			| EUR  |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description' |
			| 'Arina Brown' |
		And I select current line in "List" table
	* Filling Send date and Receive date
		And I input "04.07.2019  0:00:00" text in "Send date" field
		And I input "05.07.2019  0:00:00" text in "Receive date" field
	* Change the document number to 6
		And I input "6" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "6" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender       | Receiver     | Company      |
		| 6      | Cash desk №2 | Cash desk №2 | Main Company |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	And "List" table contains lines
		| 'Currency'   | 'Recorder'         |  'Basis document'  | 'Company'      | 'Account'           | 'Cash flow direction' | 'Amount'    |
		| 'TRY'        | 'Cash transfer order 6*' | 'Cash transfer order 6*' | 'Main Company' | 'Cash desk №2'      | 'Outgoing'            | '1 315,00'  |
		| 'EUR'        | 'Cash transfer order 6*' | 'Cash transfer order 6*' | 'Main Company' | 'Cash desk №2'      | 'Incoming'            | '200,00'    |
	And I close all client application windows
	* Create Cash payment based on Cash transfer order for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Receive amount' |
			| '6'      | '200,00'         |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Arina Brown |
		And I select current line in "List" table
		And I input "1315,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		* Change the document number to 11
			And I move to "Other" tab
			And I input "11" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "11" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
	* Create Cash reciept based on Cash transfer order in partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Receive amount' |
			| '6'      | '200,00'         |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Arina Brown |
		And I select current line in "List" table
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "1300,00" text in "Amount exchange" field of "PaymentList" table
		And I input "200,00" text in "Amount" field of "PaymentList" table
		* Change the document number to 11
			And I move to "Other" tab
			And I input "11" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "11" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
		# issued 1315, spent 1300 #
		And I close all client application windows

# Filters

Scenario: _054010 filter check by own companies in the document Cash Transfer Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	When check the filter by own company in the Cash transfer order

Scenario: _054011 check input Description in the document Cash Transfer Order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	When check filling in Description

# EndFilters


Scenario: _054012 exchange currency from bank account (Cash Transfer Order)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
		And I input "1150,00" text in "Send amount" field
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Bank account, EUR |
		And I select current line in "List" table
		And I input "175,00" text in "Receive amount" field
	* Filling Send date and Receive date
		And I input "04.07.2019  0:00:00" text in "Send date" field
		And I input "05.07.2019  0:00:00" text in "Receive date" field
	* Change the document number to 7
		And I input "7" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "7" text in "Number" field
	And I click "Post and close" button
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number | Sender            | Receiver          | Company      |
		| 7      | Bank account, TRY | Bank account, EUR | Main Company |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.PlaningCashTransactions"
	And "List" table contains lines
		| 'Currency'   | 'Recorder'         |  'Basis document'  | 'Company'      | 'Account'                | 'Cash flow direction' | 'Amount'    |
		| 'TRY'        | 'Cash transfer order 7*' | 'Cash transfer order 7*' | 'Main Company' | 'Bank account, TRY'      | 'Outgoing'            | '1 150,00'  |
		| 'EUR'        | 'Cash transfer order 7*' | 'Cash transfer order 7*' | 'Main Company' | 'Bank account, EUR'      | 'Incoming'            | '175,00'    |
	And I close all client application windows
	* Create Bank payment based on Cash transfer order for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Receive amount' |
			| '7'      | '175,00'         |
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		And I input "1150,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		* Change the document number to 7
			And I move to "Other" tab
			And I input "5" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "5" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
	* Create Bank reciept based on Cash transfer order for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Receive amount' |
			| '7'      | '175,00'         |
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "1150,00" text in "Amount exchange" field of "PaymentList" table
		And I input "175,00" text in "Amount" field of "PaymentList" table
		* Change the document number to 9
			And I move to "Other" tab
			And I input "5" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "5" text in "Number" field
		And I click "Post and close" button
		And I close all client application windows
		

Scenario: _054013 check Cash transfer order movements by register Cash in transit
# in the register Cash in transit enters cash that are transferred in the same currency
# if currency exchange takes place, then the money is credited to the person responsible for the conversion
	Given I open hyperlink "e1cib/list/AccumulationRegister.CashInTransit"
	And "List" table contains lines
		| 'Currency' |  'Basis document'         | 'Company'      | 'From account'      | 'To account'        | 'Amount' |
		| 'USD'      |  'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Cash desk №2'      | '500,00' |
		| 'USD'      |  'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Cash desk №2'      | '400,00' |
		| 'USD'      |  'Cash transfer order 1*' | 'Main Company' | 'Cash desk №1'      | 'Cash desk №2'      | '100,00' |
		| 'USD'      |  'Cash transfer order 3*' | 'Main Company' | 'Cash desk №1'      | 'Bank account, USD' | '500,00' |
		| 'USD'      |  'Cash transfer order 4*' | 'Main Company' | 'Bank account, USD' | 'Cash desk №1'      | '100,00' |
	And "List" table does not contain lines
		|  'Basis document'   |
		|  'Cash transfer order 2*' |
		|  'Cash transfer order 5*' |
		|  'Cash transfer order 6*' |
		|  'Cash transfer order 7*' |
	And I close all client application windows

Scenario: _054014 check message output in case money is transferred from Cash/Bank accounts to bank account and vice versa in different currencies
	* Check when moving money from bank account to Cash/Bank accounts in different currencies
		* Open a creation form
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
		* Filling in basic details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			And I input "1150,00" text in "Send amount" field
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №2   |
			And I select current line in "List" table
			And I click Select button of "Receive currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			And I select current line in "List" table
			And I input "200,00" text in "Receive amount" field
		* Change the document number to 101
			And I input "101" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "101" text in "Number" field
		* Check the message output and that the document was not created
			And Delay 5
			And I click "Post and close" button
			And Delay 5
			Then I wait that in user messages the "Currency exchange is available only for the same-type accounts (cash accounts or bank accounts)." substring will appear in 30 seconds
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And "List" table does not contain lines
			| 'Number'   | 'Sender'                 | 'Receiver'          |
			| '101'      | 'Bank account, TRY'      | 'Cash desk №2'      |
	* Check when moving money from Cash/Bank accounts to bank account in different currencies
		* Open a creation form
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
		* Filling in basic details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №2   |
			And I select current line in "List" table
			And I click Select button of "Send currency" field
			And I go to line in "List" table
				| 'Code' | 'Description'     |
				| 'USD'  | 'American dollar' |
			And I select current line in "List" table
			And I input "20,00" text in "Send amount" field
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| Description    |
				| Bank account, TRY |
			And I select current line in "List" table
			And I input "1150,00" text in "Receive amount" field
		* Change the document number to 102
			And I input "102" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "102" text in "Number" field
		* Check the message output and that the document was not created
			And Delay 5
			And I click "Post and close" button
			And Delay 5
			Then I wait that in user messages the "Currency exchange is available only for the same-type accounts (cash accounts or bank accounts)." substring will appear in 30 seconds
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And "List" table does not contain lines
			| 'Number'   | 'Sender'            | 'Receiver'          |
			| '102'      | 'Cash desk №2'      | 'Bank account, TRY' |


Scenario: _054015 check message output in case the user tries to create a Bank payment by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank payment and check message output
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		Then I wait that in user messages the 'You do not need to create a "Bank payment" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054016 check message output in case the user tries to create a Cash receipt by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash receipt and check message output
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		Then I wait that in user messages the 'You do not need to create a "Cash receipt" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054017 check message output in case the user tries to create Bank receipt again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank receipt and check message output
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already received on the basis of the "Bank receipt" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054018 check message output in case the user tries to create Cash payment again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Receiver'          | 'Sender'       |
		| 'Main Company' | '3'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash payment and check message output
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already paid on the basis of the "Cash payment" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054019 check message output in case the user tries to create a Bank receipt by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank receipt and check message output
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
		Then I wait that in user messages the 'You do not need to create a "Bank receipt" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054020 check message output in case the user tries to create a Cash payment by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash payment and check message output
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		Then I wait that in user messages the 'You do not need to create a "Cash payment" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054021 check message output in case the user tries to create Bank payment again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Bank payment and check message output
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already paid on the basis of the "Bank payment" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054022 check message output in case the user tries to create Cash receipt again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'      | 'Number' | 'Sender'            | 'Receiver'       |
		| 'Main Company' | '4'      | 'Bank account, USD' | 'Cash desk №1' |
	* Trying to create Cash receipt and check message output
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already received on the basis of the "Cash receipt" document(s).' substring will appear in 30 seconds
		And I close all client application windows
