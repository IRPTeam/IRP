#language: en
@tree
@Positive
@CashManagement

Feature: create money transfer

As an accountant
I want to transfer money from one account to another.
For actual Cash/Bank accountsing

Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira


		
Scenario: _054100 preparation (Money transfer)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
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
		When Create catalog BusinessUnits objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
		When Create catalog PlanningPeriods objects
	* Tax settings
		When filling in Tax settings for company
		When Create document CashTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.CashTransferOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.CashTransferOrder.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows


Scenario: _054101 filling Money transfer (same currency and account type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount (cash account)
		And I click Select button of "Sender" field
		And "List" table contains lines
			| 'Description'         | 'Currency' |
			| 'Cash desk №1'        | ''         |
			| 'Bank account, TRY'   | 'TRY'      |
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
	* Filling Receiver and Receive amount (cash account)
		And I click Select button of "Receiver" field
		And "List" table contains lines
			| 'Description'         | 'Currency' |
			| 'Cash desk №1'        | ''         |
			| 'Bank account, TRY'   | 'TRY'      |
		And I go to line in "List" table
			| Description    |
			| Cash desk №2 |
		And I select current line in "List" table
		And I input "500,00" text in "Receive amount" field
		And I click Select button of "Receive currency" field
		And I go to line in "List" table
			| Code | Description     |
			| USD  | American dollar |
		And I select current line in "List" table
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
	* Filling in Branch
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Post
		And I click "Post" button
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №1"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "USD"
		And the editing text of form attribute named "SendAmount" became equal to "500,00"
		Then the form attribute named "Receiver" became equal to "Cash desk №2"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "USD"
		And the editing text of form attribute named "ReceiveAmount" became equal to "500,00"
		Then the form attribute named "Branch" became equal to "Distribution department"
		Then the form attribute named "CashTransferOrder" became equal to ""
	* Check creation
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I save the value of "Number" field as "NumberMoneyTransfer054101"
		And I click "Post and close" button
		And "List" table contains lines
			| 'Number' |
			| '$NumberMoneyTransfer054101$'      |	
	

Scenario: _054102 filling Money transfer (different currency and account type)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description  |
		| Main Company |
	And I select current line in "List" table
	* Filling Sender and Send amount (cash account)
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
	* Filling Receiver and Receive amount (cash account)
		And I click Select button of "Receiver" field
		And I go to line in "List" table
			| Description    |
			| Bank account, TRY |
		And I select current line in "List" table
		And I input "500,00" text in "Receive amount" field
		Then the form attribute named "ReceiveCurrency" became equal to "TRY"
	* Filling Movement type
		And I click Select button of "Send financial movement type" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I click Select button of "Receive financial movement type" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
	* Filling in Branch
		And I move to "Other" tab
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
	* Post
		And I click "Post" button
	* Check filling in
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №1"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "USD"
		And the editing text of form attribute named "SendAmount" became equal to "500,00"
		Then the form attribute named "Receiver" became equal to "Bank account, TRY"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "TRY"
		And the editing text of form attribute named "ReceiveAmount" became equal to "500,00"
		Then the form attribute named "Branch" became equal to "Distribution department"
		Then the form attribute named "CashTransferOrder" became equal to ""
	* Check creation
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And I save the value of "Number" field as "NumberMoneyTransfer054102"
		And I click "Post and close" button
		And "List" table contains lines
			| 'Number' |
			| '$NumberMoneyTransfer054102$'      |	
				
Scenario: _054103 create Money transfer based on Cash transfer order (same currency and account type)
	* Select CTO
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Sender'            | 'Receiver'            | 'Company'      | 'Date'                |
			| '2'      | 'Bank account, EUR' | 'Bank account 2, EUR' | 'Main Company' | '05.04.2021 12:09:54' |
		And I click "Money transfer" button
	* Check money transfer creation
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Bank account, EUR"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "EUR"
		And the editing text of form attribute named "SendAmount" became equal to "500,00"
		Then the form attribute named "Receiver" became equal to "Bank account 2, EUR"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And the editing text of form attribute named "ReceiveAmount" became equal to "500,00"
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "CashTransferOrder" became equal to "Cash transfer order 2 dated 05.04.2021 12:09:54"
	* Try to change Sender, Reveiver
		And the attribute named "Sender" is read-only
		And the attribute named "Receiver" is read-only
		And the attribute named "SendFinancialMovementType" is read-only
		And the attribute named "ReceiveFinancialMovementType" is read-only
		And the attribute named "ReceiveCurrency" is read-only
		And the attribute named "SendCurrency" is read-only
	* Post and check creation
		And I click "Post" button
		And I move to "Other" tab
		And I save the value of "Number" field as "NumberMoneyTransfer054103"
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And "List" table contains lines
			| 'Number' |
			| '$NumberMoneyTransfer054103$'      |
		
Scenario: _054104 try to re-create Money transfer based on Cash transfer order (same currency and account type)
	* Select CTO
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Sender'            | 'Receiver'            | 'Company'      | 'Date'                |
			| '2'      | 'Bank account, EUR' | 'Bank account 2, EUR' | 'Main Company' | '05.04.2021 12:09:54' |
		And I click "Money transfer" button
	* Check info message
		When TestClient log message contains "Document [Cash transfer order 2 dated 05.04.2021 12:09:54] already have related documents" string


Scenario: _054105 create two Money transfer based on Cash transfer order (different currency)	
	* Select CTO
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Sender'            | 'Receiver'          | 'Company'      | 'Date'                |
			| '3'      | 'Bank account, TRY' | 'Bank account, EUR' | 'Main Company' | '05.04.2021 12:23:49' |
		And I click "Money transfer" button
	* Check money transfer creation
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Bank account, TRY"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "TRY"
		And the editing text of form attribute named "SendAmount" became equal to "1 000,00"
		Then the form attribute named "Receiver" became equal to "Bank account, EUR"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And the editing text of form attribute named "ReceiveAmount" became equal to "180,00"
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "CashTransferOrder" became equal to "Cash transfer order 3 dated 05.04.2021 12:23:49"
	* Change amount
		And I input "900,00" text in "Send amount" field
		And I input "170,00" text in "Receive amount" field
	* Post and check creation
		And I click "Post" button
		And the editing text of form attribute named "SendAmount" became equal to "900,00"
		And the editing text of form attribute named "ReceiveAmount" became equal to "170,00"
		And I move to "Other" tab
		And I save the value of "Number" field as "NumberMoneyTransfer054105"
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And "List" table contains lines
			| 'Number' |
			| '$NumberMoneyTransfer054105$'      |
	* Create second Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Sender'            | 'Receiver'          | 'Company'      | 'Date'                |
			| '3'      | 'Bank account, TRY' | 'Bank account, EUR' | 'Main Company' | '05.04.2021 12:23:49' |
		And I click "Money transfer" button
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Bank account, TRY"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "TRY"
		And the editing text of form attribute named "SendAmount" became equal to "100,00"
		Then the form attribute named "Receiver" became equal to "Bank account, EUR"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And the editing text of form attribute named "ReceiveAmount" became equal to "10,00"
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "CashTransferOrder" became equal to "Cash transfer order 3 dated 05.04.2021 12:23:49"
	* Change amount
		And I input "50,00" text in "Send amount" field
		And I input "5,00" text in "Receive amount" field
	* Post and check creation
		And I click "Post" button
		And the editing text of form attribute named "SendAmount" became equal to "50,00"
		And the editing text of form attribute named "ReceiveAmount" became equal to "5,00"
		And I move to "Other" tab
		And I save the value of "Number" field as "NumberMoneyTransfer0541052"
		And I click "Post and close" button
		Given I open hyperlink "e1cib/list/Document.MoneyTransfer"
		And "List" table contains lines
			| 'Number' |
			| '$NumberMoneyTransfer0541052$'      |

Scenario: _054106 check refilling Monet rtransfer based on Cash transfer order
	* Select CTO and create Money transfer
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashTransferOrder"
		And I go to line in "List" table
			| 'Number' | 'Sender'            | 'Receiver'          | 'Company'      | 'Date'                |
			| '3'      | 'Bank account, TRY' | 'Bank account, EUR' | 'Main Company' | '05.04.2021 12:23:49' |
		And I click "Money transfer" button
		Then the form attribute named "CashTransferOrder" became equal to "Cash transfer order 3 dated 05.04.2021 12:23:49"
	* Select another CTO
		And I move to "Other" tab
		And I click Select button of "Cash transfer order" field
		Then "Cash transfer orders" window is opened
		And I go to line in "List" table
			| 'Date'                | 'Number' | 'Receiver'     | 'Sender'       |
			| '05.04.2021 12:24:12' | '4'      | 'Cash desk №2' | 'Cash desk №1' |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "OK" button
	* Check refilling
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №1"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "TRY"
		And the editing text of form attribute named "SendAmount" became equal to "1 000,00"
		Then the form attribute named "Receiver" became equal to "Cash desk №2"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And the editing text of form attribute named "ReceiveAmount" became equal to "180,00"
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "CashTransferOrder" became equal to "Cash transfer order 4 dated 05.04.2021 12:24:12"
	*Select CTO and cancel refilling
		And I move to "Other" tab
		And I click Select button of "Cash transfer order" field
		And I go to line in "List" table
			| 'Company'      | 'Date'                | 'Number' | 'Receiver'          | 'Sender'            |
			| 'Main Company' | '05.04.2021 12:23:49' | '3'      | 'Bank account, EUR' | 'Bank account, TRY' |
		And I select current line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Cancel" button
		And I move to "Info" tab
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Sender" became equal to "Cash desk №1"
		Then the form attribute named "SendFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "SendCurrency" became equal to "TRY"
		And the editing text of form attribute named "SendAmount" became equal to "1 000,00"
		Then the form attribute named "Receiver" became equal to "Cash desk №2"
		Then the form attribute named "ReceiveFinancialMovementType" became equal to "Movement type 1"
		Then the form attribute named "ReceiveCurrency" became equal to "EUR"
		And the editing text of form attribute named "ReceiveAmount" became equal to "180,00"
		Then the form attribute named "Branch" became equal to "Front office"
		Then the form attribute named "CashTransferOrder" became equal to "Cash transfer order 4 dated 05.04.2021 12:24:12"
		And I close all client application windows
		
		
				
		
						
		
				
		
				
					