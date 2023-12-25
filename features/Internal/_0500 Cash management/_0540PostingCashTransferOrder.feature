#language: en
@tree
@Positive
@CashManagement

Feature: create cash transfer

As an accountant
I want to transfer money from one account to another.
For actual Cash/Bank accountsing

Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira


		
Scenario: _054000 preparation (Cash transfer order)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog Partners objects (Employee)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create information register Taxes records (VAT)
		When Create catalog PlanningPeriods objects
	
	
Scenario: _0540001 check preparation
	When check preparation	


Scenario: _054001 create Cash transfer order (from Cash/Bank accounts to Cash/Bank accounts in the same currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №1    |
		And I select current line in "List" table
		And I input "500,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I input "500,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054001$$" variable
	And I delete "$$CashTransferOrder054001$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054001$$"
	And I save the window as "$$CashTransferOrder054001$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number  | Sender        | Receiver      | Company        |
		| 1       | Cash desk №1  | Cash desk №2  | Main Company   |
	And I close all client application windows

Scenario: _054002 check Cash transfer order movements by register Planing cash transactions
	* Check movements
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table contains lines
			| 'Currency'   | 'Recorder'                      | 'Basis document'                | 'Company'        | 'Account'        | 'Cash flow direction'   | 'Amount'   | 'Financial movement type'    |
			| 'USD'        | '$$CashTransferOrder054001$$'   | '$$CashTransferOrder054001$$'   | 'Main Company'   | 'Cash desk №1'   | 'Outgoing'              | '500,00'   | 'Movement type 1'            |
			| 'USD'        | '$$CashTransferOrder054001$$'   | '$$CashTransferOrder054001$$'   | 'Main Company'   | 'Cash desk №2'   | 'Incoming'              | '500,00'   | 'Movement type 1'            |
		And I close all client application windows
	* Clear movements
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberCashTransferOrder054001$$'    |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table does not contain lines
			| 'Currency'   | 'Recorder'                      | 'Basis document'                | 'Company'        | 'Account'        | 'Cash flow direction'   | 'Amount'   | 'Financial movement type'    |
			| 'USD'        | '$$CashTransferOrder054001$$'   | '$$CashTransferOrder054001$$'   | 'Main Company'   | 'Cash desk №1'   | 'Outgoing'              | '500,00'   | 'Movement type 1'            |
			| 'USD'        | '$$CashTransferOrder054001$$'   | '$$CashTransferOrder054001$$'   | 'Main Company'   | 'Cash desk №2'   | 'Incoming'              | '500,00'   | 'Movement type 1'            |
		And I close all client application windows
	* Re-posting document
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberCashTransferOrder054001$$'    |
		And in the table "List" I click the button named "ListContextMenuPost"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table contains lines
			| 'Currency'   | 'Recorder'                      | 'Basis document'                | 'Company'        | 'Account'        | 'Cash flow direction'   | 'Amount'   | 'Financial movement type'    |
			| 'USD'        | '$$CashTransferOrder054001$$'   | '$$CashTransferOrder054001$$'   | 'Main Company'   | 'Cash desk №1'   | 'Outgoing'              | '500,00'   | 'Movement type 1'            |
			| 'USD'        | '$$CashTransferOrder054001$$'   | '$$CashTransferOrder054001$$'   | 'Main Company'   | 'Cash desk №2'   | 'Incoming'              | '500,00'   | 'Movement type 1'            |
		And I close all client application windows





Scenario: _054003 create Cash payment and Cash receipt based on Cash transfer order + check movements
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I go to line in "List" table
		| 'Number'                             | 'Sender'        | 'Receiver'      | 'Company'        |
		| '$$NumberCashTransferOrder054001$$'  | 'Cash desk №1'  | 'Cash desk №2'  | 'Main Company'   |
	And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Check the filling of the tabular part
		And "PaymentList" table contains lines
		| 'Planning transaction basis'   | 'Total amount'   |
		| '$$CashTransferOrder054001$$'  | '500,00'         |
	And I click the button named "FormPost"
	And I delete "$$NumberCashPayment054003$$" variable
	And I delete "$$CashPayment054003$$" variable
	And I save the value of "Number" field as "$$NumberCashPayment054003$$"
	And I save the window as "$$CashPayment054003$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Creation of Cash receipt for a partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender         | Receiver       | Company         |
			| $$NumberCashTransferOrder054001$$   | Cash desk №1   | Cash desk №2   | Main Company    |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "400,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt054003$$" variable
		And I delete "$$CashReceipt054003$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt054003$$"
		And I save the window as "$$CashReceipt054003$$"
		And I click the button named "FormPostAndClose"
		And Delay 5
	* Creation of Cash receipt for the remaining amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender         | Receiver       | Company         |
			| $$NumberCashTransferOrder054001$$   | Cash desk №1   | Cash desk №2   | Main Company    |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
	* Check that the tabular part shows the rest of the amount
		And I move to "Payments" tab
		And "PaymentList" table contains lines
		| 'Planning transaction basis'   | 'Total amount'   |
		| '$$CashTransferOrder054001$$'  | '100,00'         |
	And I click the button named "FormPost"
	And I delete "$$NumberCashReceipt0540031$$" variable
	And I delete "$$CashReceipt0540031$$" variable
	And I save the value of "Number" field as "$$NumberCashReceipt0540031$$"
	And I save the window as "$$CashReceipt0540031$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Check movement of Cash payment and Cash receipt by register Planing cash transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table contains lines
		| 'Currency'  | 'Recorder'                | 'Basis document'               | 'Company'       | 'Account'       | 'Cash flow direction'  | 'Financial movement type'   |
		| 'USD'       | '$$CashPayment054003$$'   | '$$CashTransferOrder054001$$'  | 'Main Company'  | 'Cash desk №1'  | 'Outgoing'             | 'Movement type 1'           |
		| 'USD'       | '$$CashReceipt054003$$'   | '$$CashTransferOrder054001$$'  | 'Main Company'  | 'Cash desk №2'  | 'Incoming'             | 'Movement type 1'           |
		| 'USD'       | '$$CashReceipt0540031$$'  | '$$CashTransferOrder054001$$'  | 'Main Company'  | 'Cash desk №2'  | 'Incoming'             | 'Movement type 1'           |
	And I close all client application windows
	


Scenario: _054004 create Cash transfer order (from Cash/Bank accounts to Cash/Bank accounts in the different currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I input "200,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №1    |
		And I select current line in "List" table
		And I input "1150,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code   | Description     |
			| TRY    | Turkish lira    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054004$$" variable
	And I delete "$$CashTransferOrder054004$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054004$$"
	And I save the window as "$$CashTransferOrder054004$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
			| 'Number'                              | 'Sender'         | 'Receiver'       | 'Company'         |
			| '$$NumberCashTransferOrder054004$$'   | 'Cash desk №2'   | 'Cash desk №1'   | 'Main Company'    |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
	And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'       | 'Cash flow direction'  | 'Partner'  | 'Legal name'  | 'Amount'    | 'Financial movement type'   |
		| 'USD'       | '$$CashTransferOrder054004$$'  | '$$CashTransferOrder054004$$'  | 'Main Company'  | 'Cash desk №2'  | 'Outgoing'             | ''         | ''            | '200,00'    | 'Movement type 1'           |
		| 'TRY'       | '$$CashTransferOrder054004$$'  | '$$CashTransferOrder054004$$'  | 'Main Company'  | 'Cash desk №1'  | 'Incoming'             | ''         | ''            | '1 150,00'  | 'Movement type 1'           |
	And I close all client application windows

Scenario: _054005 create Cash receipt and Cash payment based on Cash transfer order in the different currency and check movements
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I go to line in "List" table
		| Number                             | Sender        | Receiver      | Company        |
		| $$NumberCashTransferOrder054004$$  | Cash desk №2  | Cash desk №1  | Main Company   |
	And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Check the filling of the tabular part
		And "PaymentList" table contains lines
		| 'Planning transaction basis'   | 'Total amount'   |
		| '$$CashTransferOrder054004$$'  | '200,00'         |
	* Filling in the employee responsible for curremcy exchange
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberCashPayment054005$$" variable
	And I delete "$$CashPayment054005$$" variable
	And I save the value of "Number" field as "$$NumberCashPayment054005$$"
	And I save the window as "$$CashPayment054005$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Create Cash receipt for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender         | Receiver       | Company         |
			| $$NumberCashTransferOrder054004$$   | Cash desk №2   | Cash desk №1   | Main Company    |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
	* Check that the correct receipt amount is indicated in the tabular part
		And I move to "Payments" tab
		And Delay 5
		And "PaymentList" table contains lines
		| 'Planning transaction basis'   | 'Partner'       | 'Total amount'  | 'Amount exchange'   |
		| '$$CashTransferOrder054004$$'  | 'Daniel Smith'  | '1 150,00'      | '200,00'            |
	And I click the button named "FormPost"
	And I delete "$$NumberCashReceipt054005$$" variable
	And I delete "$$CashReceipt054005$$" variable
	And I save the value of "Number" field as "$$NumberCashReceipt054005$$"
	And I save the window as "$$CashReceipt054005$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows
	* Check Cash payment and Cash receipt movements by register PlaningCashTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'       | 'Cash flow direction'  | 'Partner'  | 'Legal name'  | 'Amount'      |
		| 'USD'       | '$$CashTransferOrder054004$$'  | '$$CashTransferOrder054004$$'  | 'Main Company'  | 'Cash desk №2'  | 'Outgoing'             | ''         | ''            | '200,00'      |
		| 'TRY'       | '$$CashTransferOrder054004$$'  | '$$CashTransferOrder054004$$'  | 'Main Company'  | 'Cash desk №1'  | 'Incoming'             | ''         | ''            | '1 150,00'    |
		| 'USD'       | '$$CashPayment054005$$'        | '$$CashTransferOrder054004$$'  | 'Main Company'  | 'Cash desk №2'  | 'Outgoing'             | ''         | ''            | '-200,00'     |
		| 'TRY'       | '$$CashReceipt054005$$'        | '$$CashTransferOrder054004$$'  | 'Main Company'  | 'Cash desk №1'  | 'Incoming'             | ''         | ''            | '-1 150,00'   |
		And I close all client application windows

	
Scenario: _054006 create Cash transfer order (from Cash/Bank accounts to bank account in the same currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №1    |
		And I select current line in "List" table
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| 'Code'   | 'Description'        |
			| 'USD'    | 'American dollar'    |
		And I select current line in "List" table
		And I input "500,00" text in "Send amount" field
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description          |
			| Bank account, USD    |
		And I select current line in "List" table
		And I input "500,00" text in "Receive amount" field
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054006$$" variable
	And I delete "$$CashTransferOrder054006$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054006$$"
	And I save the window as "$$CashTransferOrder054006$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number                             | Sender        | Receiver           | Company        |
		| $$NumberCashTransferOrder054006$$  | Cash desk №1  | Bank account, USD  | Main Company   |
	And I close all client application windows
	* Post Cash payment
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender         | Receiver            | Company         |
			| $$NumberCashTransferOrder054006$$   | Cash desk №1   | Bank account, USD   | Main Company    |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Check the filling of the tabular part
		And "PaymentList" table contains lines
			| 'Planning transaction basis'    | 'Total amount'    |
			| '$$CashTransferOrder054006$$'   | '500,00'          |
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment054006$$" variable
		And I delete "$$CashPayment054006$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment054006$$"
		And I save the window as "$$CashPayment054006$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	*Post Bank receipt
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender         | Receiver            | Company         |
			| $$NumberCashTransferOrder054006$$   | Cash desk №1   | Bank account, USD   | Main Company    |
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And Delay 5
	* Check the filling of the tabular part
		And I move to "Payments" tab
		If "PaymentList" table does not contain line Then
			| 'Total amount'    |
			| '500,00'          |
			And I close current window
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I go to line in "List" table
				| Number                               | Sender          | Receiver             | Company          |
				| $$NumberCashTransferOrder054006$$    | Cash desk №1    | Bank account, USD    | Main Company     |
			And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And "PaymentList" table contains lines
			| 'Total amount'   | 'Planning transaction basis'     |
			| '500,00'         | '$$CashTransferOrder054006$$'    |
		* Change amount and reselect basis document
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "400,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I activate "Planning transaction basis" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
			And I go to line in "List" table
				| Number                               |
				| $$NumberCashTransferOrder054006$$    |
			And I select current line in "List" table
			And "PaymentList" table contains lines
				| 'Total amount'   | 'Planning transaction basis'     |
				| '400,00'         | '$$CashTransferOrder054006$$'    |	
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "500,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And "PaymentList" table contains lines
				| 'Total amount'   | 'Planning transaction basis'     |
				| '500,00'         | '$$CashTransferOrder054006$$'    |
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt054006$$" variable
		And I delete "$$BankReceipt054006$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt054006$$"
		And I save the window as "$$BankReceipt054006$$"
		And I click the button named "FormPostAndClose"
	* Check movements by register Planing cash transactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'            | 'Cash flow direction'  | 'Amount'    |
		| 'USD'       | '$$CashTransferOrder054006$$'  | '$$CashTransferOrder054006$$'  | 'Main Company'  | 'Cash desk №1'       | 'Outgoing'             | '500,00'    |
		| 'USD'       | '$$CashTransferOrder054006$$'  | '$$CashTransferOrder054006$$'  | 'Main Company'  | 'Bank account, USD'  | 'Incoming'             | '500,00'    |
		| 'USD'       | '$$CashPayment054006$$'        | '$$CashTransferOrder054006$$'  | 'Main Company'  | 'Cash desk №1'       | 'Outgoing'             | '-500,00'   |
		| 'USD'       | '$$BankReceipt054006$$'        | '$$CashTransferOrder054006$$'  | 'Main Company'  | 'Bank account, USD'  | 'Incoming'             | '-500,00'   |
		And I close all client application windows

Scenario: _054007 create Cash transfer order from bank account to Cash account (in the same currency)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description          |
			| Bank account, USD    |
		And I select current line in "List" table
		And I input "100,00" text in "Send amount" field
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №1    |
		And I select current line in "List" table
		And I input "100,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054007$$" variable
	And I delete "$$CashTransferOrder054007$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054007$$"
	And I save the window as "$$CashTransferOrder054007$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number                             | Sender             | Receiver      | Company        |
		| $$NumberCashTransferOrder054007$$  | Bank account, USD  | Cash desk №1  | Main Company   |
	And I close all client application windows
	* Post Bank payment
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender              | Receiver       | Company         |
			| $$NumberCashTransferOrder054007$$   | Bank account, USD   | Cash desk №1   | Main Company    |
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
		* Check the filling of the tabular part
			And "PaymentList" table contains lines
			| 'Planning transaction basis'    | 'Total amount'    |
			| '$$CashTransferOrder054007$$'   | '100,00'          |
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment054007$$" variable
		And I delete "$$BankPayment054007$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment054007$$"
		And I save the window as "$$BankPayment054007$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
		And Delay 5
	* Post Cash receipt
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| Number                              | Sender              | Receiver       | Company         |
			| $$NumberCashTransferOrder054007$$   | Bank account, USD   | Cash desk №1   | Main Company    |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		* Check the filling of the tabular part
			And "PaymentList" table contains lines
			| Planning transaction basis    | Total amount    |
			| $$CashTransferOrder054007$$   | '100,00'        |
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt054007$$" variable
		And I delete "$$CashReceipt054007$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt054007$$"
		And I save the window as "$$CashReceipt054007$$"
		And I click the button named "FormPostAndClose"
	* Check movements by register PlaningCashTransactions
		Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
		And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'            | 'Cash flow direction'  | 'Amount'    |
		| 'USD'       | '$$CashTransferOrder054007$$'  | '$$CashTransferOrder054007$$'  | 'Main Company'  | 'Bank account, USD'  | 'Outgoing'             | '100,00'    |
		| 'USD'       | '$$CashTransferOrder054007$$'  | '$$CashTransferOrder054007$$'  | 'Main Company'  | 'Cash desk №1'       | 'Incoming'             | '100,00'    |
		| 'USD'       | '$$CashReceipt054007$$'        | '$$CashTransferOrder054007$$'  | 'Main Company'  | 'Cash desk №1'       | 'Incoming'             | '-100,00'   |
		| 'USD'       | '$$BankPayment054007$$'        | '$$CashTransferOrder054007$$'  | 'Main Company'  | 'Bank account, USD'  | 'Outgoing'             | '-100,00'   |
		And I close all client application windows

Scenario: _054008 currency exchange within one Cash/Bank accounts with exchange in parts (exchange rate has increased)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I input "1150,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code   | Description     |
			| TRY    | Turkish lira    |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I input "175,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code    |
			| EUR     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054008$$" variable
	And I delete "$$CashTransferOrder054008$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054008$$"
	And I save the window as "$$CashTransferOrder054008$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number                             | Sender        | Receiver      | Company        |
		| $$NumberCashTransferOrder054008$$  | Cash desk №2  | Cash desk №2  | Main Company   |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
	And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'       | 'Cash flow direction'  | 'Amount'     |
		| 'TRY'       | '$$CashTransferOrder054008$$'  | '$$CashTransferOrder054008$$'  | 'Main Company'  | 'Cash desk №2'  | 'Outgoing'             | '1 150,00'   |
		| 'EUR'       | '$$CashTransferOrder054008$$'  | '$$CashTransferOrder054008$$'  | 'Main Company'  | 'Cash desk №2'  | 'Incoming'             | '175,00'     |
	And I close all client application windows
	* Create Cash payment based on Cash transfer order in partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054008$$'   | '175,00'            |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I input "650,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment054008$$" variable
		And I delete "$$CashPayment054008$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment054008$$"
		And I save the window as "$$CashPayment054008$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
		And Delay 5
	* Create Cash receipt based on Cash transfer order in partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054008$$'   | '175,00'            |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "600,00" text in "Amount exchange" field of "PaymentList" table
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt054008$$" variable
		And I delete "$$CashReceipt054008$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt054008$$"
		And I save the window as "$$CashReceipt054008$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Post Cash payment on the rest of the amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054008$$'   | '175,00'            |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| 'Partner'        | 'Total amount'   | 'Planning transaction basis'     |
			| 'Daniel Smith'   | '500,00'         | '$$CashTransferOrder054008$$'    |
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0540081$$" variable
		And I delete "$$CashPayment0540081$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0540081$$"
		And I save the window as "$$CashPayment0540081$$"
		And I click the button named "FormPostAndClose"
	* Post Cash receipt on the rest of the amount + 10 lirs
	# Originally 1,150 lire, but the exchange rate of 175 euros cost 1,160 lire. We have to compensate for 10 lire.
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054008$$'   | '175,00'            |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		And I input "560,00" text in "Amount exchange" field of "PaymentList" table
		And Delay 5
		And "PaymentList" table contains lines
			| 'Partner'        | 'Total amount'   | 'Planning transaction basis'    | 'Amount exchange'    |
			| 'Daniel Smith'   | '75,00'          | '$$CashTransferOrder054008$$'   | '560,00'             |
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt0540081$$" variable
		And I delete "$$CashReceipt0540081$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0540081$$"
		And I save the window as "$$CashReceipt0540081$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
		# issued 1150, spent 1160
		And I close all client application windows


Scenario: _054009 currency exchange within one Cash/Bank accounts with exchange in parts (exchange rate has decreased)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I input "1315,00" text in "Send amount" field
		And I click Select button of "Send currency" field
		And I go to line in "List" table
			| Code   | Description     |
			| TRY    | Turkish lira    |
		And I select current line in "List" table
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description     |
			| Cash desk №2    |
		And I select current line in "List" table
		And I input "200,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code    |
			| EUR     |
		And I activate "Description" field in "List" table
		And I select current line in "List" table
		And I click Select button of "Cash advance holder" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054009$$" variable
	And I delete "$$CashTransferOrder054009$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054009$$"
	And I save the window as "$$CashTransferOrder054009$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number                             | Sender        | Receiver      | Company        |
		| $$NumberCashTransferOrder054009$$  | Cash desk №2  | Cash desk №2  | Main Company   |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
	And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'       | 'Cash flow direction'  | 'Amount'     |
		| 'TRY'       | '$$CashTransferOrder054009$$'  | '$$CashTransferOrder054009$$'  | 'Main Company'  | 'Cash desk №2'  | 'Outgoing'             | '1 315,00'   |
		| 'EUR'       | '$$CashTransferOrder054009$$'  | '$$CashTransferOrder054009$$'  | 'Main Company'  | 'Cash desk №2'  | 'Incoming'             | '200,00'     |
	And I close all client application windows
	* Create Cash payment based on Cash transfer order for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054009$$'   | '200,00'            |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I input "1315,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment054009$$" variable
		And I delete "$$CashPayment054009$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment054009$$"
		And I save the window as "$$CashPayment054009$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create Cash receipt based on Cash transfer order in partial amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054009$$'   | '200,00'            |
		And I select current line in "List" table
		And Delay 10
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Daniel Smith'    |
		And I select current line in "List" table
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "1300,00" text in "Amount exchange" field of "PaymentList" table
		And I input "200,00" text in "Total amount" field of "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt054009$$" variable
		And I delete "$$CashReceipt054009$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt054009$$"
		And I save the window as "$$CashReceipt054009$$"
		And I click the button named "FormPostAndClose"
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
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	* Filling Sender and Send amount
		And I click Select button of "Sender" field
		And I go to line in "List" table
			| Description          |
			| Bank account, TRY    |
		And I select current line in "List" table
		And I input "1150,00" text in "Send amount" field
	* Filling Receiver and Receive amount
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description          |
			| Bank account, EUR    |
		And I select current line in "List" table
		And I input "175,00" text in "Receive amount" field
	* Filling Send period and Receive period
		And I click Select button of "Send period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'First'          |
		And I select current line in "List" table
		And I click Select button of "Receive period" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Second'         |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table	
	And I click the button named "FormPost"
	And I delete "$$NumberCashTransferOrder054012$$" variable
	And I delete "$$CashTransferOrder054012$$" variable
	And I save the value of "Number" field as "$$NumberCashTransferOrder054012$$"
	And I save the window as "$$CashTransferOrder054012$$"
	And I click the button named "FormPostAndClose"
	And Delay 5
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And "List" table contains lines
		| Number                             | Sender             | Receiver           | Company        |
		| $$NumberCashTransferOrder054012$$  | Bank account, TRY  | Bank account, EUR  | Main Company   |
	And I close all client application windows
	Given I open hyperlink "e1cib/list/AccumulationRegister.R3035T_CashPlanning"
	And "List" table contains lines
		| 'Currency'  | 'Recorder'                     | 'Basis document'               | 'Company'       | 'Account'            | 'Cash flow direction'  | 'Amount'     |
		| 'TRY'       | '$$CashTransferOrder054012$$'  | '$$CashTransferOrder054012$$'  | 'Main Company'  | 'Bank account, TRY'  | 'Outgoing'             | '1 150,00'   |
		| 'EUR'       | '$$CashTransferOrder054012$$'  | '$$CashTransferOrder054012$$'  | 'Main Company'  | 'Bank account, EUR'  | 'Incoming'             | '175,00'     |
	And I close all client application windows
	* Create Bank payment based on Cash transfer order for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054012$$'   | '175,00'            |
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
		And I input "1150,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment054012$$" variable
		And I delete "$$BankPayment054012" variable
		And I save the value of "Number" field as "$$NumberBankPayment054012$$"
		And I save the window as "$$BankPayment054012"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
	* Create Bank receipt based on Cash transfer order for the full amount
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number'                              | 'Receive amount'    |
			| '$$NumberCashTransferOrder054012$$'   | '175,00'            |
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "1150,00" text in "Amount exchange" field of "PaymentList" table
		And I input "175,00" text in "Total amount" field of "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt054012$$" variable
		And I delete "$$BankReceipt054012$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt054012$$"
		And I save the window as "$$BankReceipt054012$$"
		And I click the button named "FormPostAndClose"
		And I close all client application windows
		

Scenario: _054013 check Cash transfer order movements by register Cash in transit
# in the register Cash in transit enters cash that are transferred in the same currency
# if currency exchange takes place, then the money is credited to the person responsible for the conversion
	Given I open hyperlink "e1cib/list/AccumulationRegister.CashInTransit"
	And "List" table contains lines
		| 'Currency'  | 'Basis document'               | 'Company'       | 'From account'       | 'To account'         | 'Amount'   |
		| 'USD'       | '$$CashTransferOrder054001$$'  | 'Main Company'  | 'Cash desk №1'       | 'Cash desk №2'       | '500,00'   |
		| 'USD'       | '$$CashTransferOrder054001$$'  | 'Main Company'  | 'Cash desk №1'       | 'Cash desk №2'       | '400,00'   |
		| 'USD'       | '$$CashTransferOrder054001$$'  | 'Main Company'  | 'Cash desk №1'       | 'Cash desk №2'       | '100,00'   |
		| 'USD'       | '$$CashTransferOrder054006$$'  | 'Main Company'  | 'Cash desk №1'       | 'Bank account, USD'  | '500,00'   |
		| 'USD'       | '$$CashTransferOrder054007$$'  | 'Main Company'  | 'Bank account, USD'  | 'Cash desk №1'       | '100,00'   |
	And "List" table does not contain lines
		| 'Basis document'                |
		| '$$CashTransferOrder054004$$'   |
		| '$$CashTransferOrder054008$$'   |
		| '$$CashTransferOrder054009$$'   |
		| '$$CashTransferOrder054012$$'   |
	And I close all client application windows

Scenario: _054014 check message output in case money is transferred from Cash/Bank accounts to bank account and vice versa in different currencies
	* Check when moving money from bank account to Cash/Bank accounts in different currencies
		* Open a creation form
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
		* Filling in basic details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| Description           |
				| Bank account, TRY     |
			And I select current line in "List" table
			And I input "1150,00" text in "Send amount" field
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №2     |
			And I select current line in "List" table
			And I click Select button of "Receive currency" field
			And I go to line in "List" table
				| 'Code'    | 'Description'         |
				| 'USD'     | 'American dollar'     |
			And I select current line in "List" table
			And I input "200,00" text in "Receive amount" field
		* Check the message output and that the document was not created
			And I click the button named "FormPost"
			And I delete "$$NumberCashTransferOrder0540141$$" variable
			And I save the value of "Number" field as "$$NumberCashTransferOrder0540141$$"
			And I click the button named "FormPostAndClose"
			And I click the button named "FormPostAndClose"
			And Delay 5
			Then I wait that in user messages the "Currency exchange is available only for the same-type accounts (cash accounts or bank accounts)." substring will appear in 30 seconds
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And "List" table does not contain lines
			| 'Number'                               | 'Sender'              | 'Receiver'        |
			| '$$NumberCashTransferOrder0540141$$'   | 'Bank account, TRY'   | 'Cash desk №2'    |
	* Check when moving money from Cash/Bank accounts to bank account in different currencies
		* Open a creation form
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And I click the button named "FormCreate"
		* Filling in basic details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Sender" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №2     |
			And I select current line in "List" table
			And I click Select button of "Send currency" field
			And I go to line in "List" table
				| 'Code'    | 'Description'         |
				| 'USD'     | 'American dollar'     |
			And I select current line in "List" table
			And I input "20,00" text in "Send amount" field
			And I click Select button of "Receiver" field
			And I go to line in "List" table
				| Description           |
				| Bank account, TRY     |
			And I select current line in "List" table
			And I input "1150,00" text in "Receive amount" field
		* Check the message output and that the document was not created
			And I click the button named "FormPost"
			And I delete "$$NumberCashTransferOrder0540142$$" variable
			And I save the value of "Number" field as "$$NumberCashTransferOrder0540142$$"
			And I click the button named "FormPostAndClose"
			And Delay 5
			Then I wait that in user messages the "Currency exchange is available only for the same-type accounts (cash accounts or bank accounts)." substring will appear in 30 seconds
			And I close all client application windows
			Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
			And "List" table does not contain lines
			| 'Number'                               | 'Sender'         | 'Receiver'             |
			| '$$NumberCashTransferOrder0540142$$'   | 'Cash desk №2'   | 'Bank account, TRY'    |


Scenario: _054015 check message output in case the user tries to create a Bank payment by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Receiver'           | 'Sender'         |
		| 'Main Company'  | '$$NumberCashTransferOrder054006$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Bank payment and check message output
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
		Then I wait that in user messages the 'You do not need to create a "Bank payment" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054016 check message output in case the user tries to create a Cash receipt by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Receiver'           | 'Sender'         |
		| 'Main Company'  | '$$NumberCashTransferOrder054006$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Cash receipt and check message output
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		Then I wait that in user messages the 'You do not need to create a "Cash receipt" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054017 check message output in case the user tries to create Bank receipt again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Receiver'           | 'Sender'         |
		| 'Main Company'  | '$$NumberCashTransferOrder054006$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Bank receipt and check message output
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already received on the basis of the "Bank receipt" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054018 check message output in case the user tries to create Cash payment again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Receiver'           | 'Sender'         |
		| 'Main Company'  | '$$NumberCashTransferOrder054006$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Cash payment and check message output
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already paid on the basis of the "Cash payment" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054019 check message output in case the user tries to create a Bank receipt by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Sender'             | 'Receiver'       |
		| 'Main Company'  | '$$NumberCashTransferOrder054007$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Bank receipt and check message output
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		Then I wait that in user messages the 'You do not need to create a "Bank receipt" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054020 check message output in case the user tries to create a Cash payment by Cash transfer order for which he does not need to create it
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Sender'             | 'Receiver'       |
		| 'Main Company'  | '$$NumberCashTransferOrder054007$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Cash payment and check message output
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
		Then I wait that in user messages the 'You do not need to create a "Cash payment" document for the selected "Cash transfer order" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054021 check message output in case the user tries to create Bank payment again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Sender'             | 'Receiver'       |
		| 'Main Company'  | '$$NumberCashTransferOrder054007$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Bank payment and check message output
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already paid on the basis of the "Bank payment" document(s).' substring will appear in 30 seconds
		And I close all client application windows

Scenario: _054022 check message output in case the user tries to create Cash receipt again by Cash transfer order
	* Open the list Cash transfer order
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Select Cash transfer order
		And I go to line in "List" table
		| 'Company'       | 'Number'                             | 'Sender'             | 'Receiver'       |
		| 'Main Company'  | '$$NumberCashTransferOrder054007$$'  | 'Bank account, USD'  | 'Cash desk №1'   |
	* Trying to create Cash receipt and check message output
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
		Then I wait that in user messages the 'The total amount of the "Cash transfer order" document(s) is already received on the basis of the "Cash receipt" document(s).' substring will appear in 30 seconds
		And I close all client application windows


Scenario: _300516 check connection to CashTransferOrder report "Related documents" and generating a report for the current item (Cash receipt)
	Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
	* Form report Related documents
		And I go to line in "List" table
		| Number                              |
		| $$NumberCashTransferOrder054001$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
		Then "* Related documents" window is opened
		And "DocumentsTree" table contains lines
		| 'Presentation'                 | 'Amount'   |
		| '$$CashTransferOrder054001$$'  | '*'        |
		| '$$CashPayment054003$$'        | '500,00'   |
		| '$$CashReceipt054003$$'        | '400,00'   |
		| '$$CashReceipt0540031$$'       | '100,00'   |
	*  Check the report generation from list
		And I go to the last line in "DocumentsTree" table
		And I go to line in "DocumentsTree" table
		| 'Presentation'             |
		| '$$CashReceipt0540031$$'   |
		And in the table "DocumentsTree" I click the button named "DocumentsTreeGenerateForCurrent"
		And "DocumentsTree" table contains lines
		| 'Presentation'                 | 'Amount'   |
		| '$$CashTransferOrder054001$$'  | ''         |
		| '$$CashReceipt0540031$$'       | '100,00'   |
	And I close all client application windows
