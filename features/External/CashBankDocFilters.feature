#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: check the filter by own company
	And I click the button named "FormCreate"
	* Check the filter by own company
		And I click Select button of "Company" field
		And "List" table became equal
		| Description    |
		| Main Company   |
		And I click the button named "FormChoose"
		And Delay 2
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Currency" field
		Then "Companies" window is opened
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "Company" became equal to 'Company Kalipso''    |
	And I close all client application windows 

Scenario: check the filter by own company in the Cash transfer order
	And I click the button named "FormCreate"
	* Check the filter by own company
		And I click Select button of "Company" field
		And "List" table became equal
		| Description    |
		| Main Company   |
		And I click the button named "FormChoose"
		And Delay 2
		Then the form attribute named "Company" became equal to "Main Company"
	* Check the filter by string input
		And Delay 2
		And I input "Company Kalipso" text in "Company" field
		And Delay 2
		And I click Select button of "Sender" field
		Then "Companies" window is opened
		And "List" table does not contain lines
			| Description        |
			| Company Kalipso    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "Company" became equal to 'Company Kalipso''    |
	And I close all client application windows

Scenario: check the filter for bank accounts (cash account selection is not available) + filling in currency from a bank account
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I click the button named "FormChoose"
	* Check the filter by bank account
		And I click Select button of "Account" field
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 4
		And "List" table contains lines
			| Description            |
			| Bank account, TRY      |
			| Bank account, USD      |
			| Bank account, EUR      |
			| Bank account 2, EUR    |
		And I go to line in "List" table
			| Description       |
			| Bank account, TRY |
		And I select current line in "List" table
		Then the form attribute named "Account" became equal to "Bank account, TRY"
	* Check the filling in currency
		Then the form attribute named "Currency" became equal to "TRY"
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description          |
			| Bank account, USD    |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "USD"
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description          |
			| Bank account, EUR    |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "EUR"
	* Check the filter by string input
		And Delay 2
		And I input "Cash desk №1" text in "Account" field
		And Delay 2
		And I click Select button of "Currency" field
		And "List" table does not contain lines
			| Description     |
			| Cash desk №1    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "CashAccount" became equal to 'Cash desk №1''    |
	And I close all client application windows

Scenario: check the filter by cash account (bank account selection is not available)
	And I click the button named "FormCreate"
	* Check the filter by bank account
		And I click Select button of "Company" field
		And I click the button named "FormChoose"
		And I click Select button of "Cash account" field
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 4
		And "List" table contains lines
			| Description     |
			| Cash desk №1    |
			| Cash desk №2    |
			| Cash desk №3    |
			| Cash desk №4    |
		And I go to line in "List" table
			| Description     |
			| Cash desk №1    |
		And I select current line in "List" table
		Then the form attribute named "CashAccount" became equal to "Cash desk №1"
	* Check the filter by string input
		And Delay 2
		And I input "Bank account, TRY" text in "Cash account" field
		And Delay 2
		And I click Select button of "Currency" field
		And "List" table does not contain lines
			| Description          |
			| Bank account, TRY    |
		And I click the button named "FormChoose"
		When I Check the steps for Exception
			| 'Then the form attribute named "CashAccount" became equal to 'Bank account, TRY''    |
	And I close all client application windows

Scenario: check filling in Description
	And I click the button named "FormCreate"
	* Filling in Description
		And I click "Comment" hyperlink
		And I input "Test Comment" text in "Text" field
		And I click "OK" button
		Then the form attribute named "Comment" became equal to "Test Comment"
	And I close all client application windows

Scenario: check the choice of type of operation in the payment documents
	And I click the button named "FormCreate"
	* Select operation type
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
	And I close all client application windows

Scenario: check the choice of the type of operation in the documents of receipt of payment
	And I click the button named "FormCreate"
	* Select the type of operation
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		And I select "Currency exchange" exact value from "Transaction type" drop-down list
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
	And I close all client application windows

Scenario: check the legal name filter in the tabular part of the payment documents
	# when selecting a partner, only its legal names should be available on the selection list
	And I click the button named "FormCreate"
	* Filling in partner info
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
	* Check the filter by legal name
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 1
		And "List" table contains lines
		| Description         |
		| Company Ferron BP   |
		And I select current line in "List" table
		And I move to the next attribute
		And Delay 2
		And "PaymentList" table contains lines
		| Partner    | Payee               |
		| Ferron BP  | Company Ferron BP   |
	And I close all client application windows

Scenario: check the legal name filter in the tabular part of the payment receipt documents
	# when selecting a partner, only its legal names should be available on the selection list
	And I click the button named "FormCreate"
	And I select "Payment from customer" exact value from "Transaction type" drop-down list
	* Filling in partner info
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
	* Check the filter by legal name
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 1
		And "List" table contains lines
		| Description         |
		| Company Ferron BP   |
		And I select current line in "List" table
		And I move to the next attribute
		And Delay 2
		And "PaymentList" table contains lines
		| Partner    | Payer               |
		| Ferron BP  | Company Ferron BP   |
	And I close all client application windows

Scenario: check the partner filter in the tabular part of the payment documents.
	# when selecting a legal name, only its partners should be available on the partner selection list
	And I click the button named "FormCreate"
	* Filling in legal name info
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And Delay 2
	* Check the filter by partner
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 1
		And "List" table contains lines
		| Description   |
		| Ferron BP     |
		And I select current line in "List" table
		And I move to the next attribute
		And "PaymentList" table contains lines
		| Partner    | Payee               |
		| Ferron BP  | Company Ferron BP   |
	And I close all client application windows

Scenario: check the partner filter in the tabular part of the payment receipt documents
	# when selecting a legal name, only its partners should be available on the partner selection list
	And I click the button named "FormCreate"
	And I select "Payment from customer" exact value from "Transaction type" drop-down list
	* Filling in legal name info
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And Delay 2
	* Check the filter by partner
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 1
		And "List" table contains lines
		| Description   |
		| Ferron BP     |
		And I select current line in "List" table
		And I move to the next attribute
		And "PaymentList" table contains lines
		| Partner    | Payer               |
		| Ferron BP  | Company Ferron BP   |
	And I close all client application windows

Scenario: check the filter on the basis documents in the payment documents
	And I click choice button of "Partner term" attribute in "PaymentList" table
	And I go to line in "List" table
		| 'Description'                |
		| 'Basic Partner terms, TRY'   |
	And I select current line in "List" table
	* Check the filter by basis documents
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And "List" table does not contain lines
			| Legal name        | Partner    |
			| Company Kalipso   | Kalipso    |
		And I close current window
	* Check the filter by basis documents for Kalipso
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click Clear button of the attribute named "PaymentListPayee" in "PaymentList"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And "List" table contains lines
			| Description        |
			| Company Kalipso    |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| Partner   | Payee              |
			| Kalipso   | Company Kalipso    |
	* Check the filter by basis documents
		And I go to line in "PaymentList" table
			| Partner   | Payee              |
			| Kalipso   | Company Kalipso    |
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
		| 'Description'               | 'Kind'      |
		| 'Basic Partner terms, TRY'  | 'Regular'   |
		And I select current line in "List" table
		And Delay 2
		And I move to the next attribute
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And "List" table does not contain lines
			| Legal name          | Partner      |
			| Company Ferron BP   | Ferron BP    |
	And I close all client application windows


Scenario: check the filter on the basis documents in the documents of receipt of payment
	And I click choice button of "Partner term" attribute in "PaymentList" table
	And I go to line in "List" table
		| 'Description'                |
		| 'Basic Partner terms, TRY'   |
	And I select current line in "List" table
	* Check the filter by basis documents
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And "List" table does not contain lines
			| Legal name        | Partner    |
			| Company Kalipso   | Kalipso    |
	* Check the filter by basis documents for Kalipso
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And "List" table contains lines
			| Description        |
			| Company Kalipso    |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| Partner   | Payer              |
			| Kalipso   | Company Kalipso    |
	* Check the filter by basis documents
		And I go to line in "PaymentList" table
			| Partner   | Payer              |
			| Kalipso   | Company Kalipso    |
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And "List" table does not contain lines
			| Legal name          | Partner      |
			| Company Ferron BP   | Ferron BP    |
	And I close all client application windows

Scenario: check the choice of the type of document-basis in the documents of receipt of payment
	And I click the button named "FormCreate"
	* Check the choice of the type of document-basis
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And "List" table does not contain lines
		| Reference          |
		| Sales invoice*     |
		| Purchase return*   |
	And I close all client application windows

	
Scenario: check the choice of currency in the bank payment document if the currency is indicated in the account
# in this case you cannot change the currency (documents: Bank payment, Bank receipt)
	And I click Select button of "Company" field
	And I select current line in "List" table
	And I click Select button of "Account" field
	And I go to line in "List" table
			| Description          |
			| Bank account, TRY    |
	And I select current line in "List" table
	Then the form attribute named "Currency" became equal to "TRY"
	* Change currency from lira to USD
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
	* Check that the document currency is the lira
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "Account" became equal to ""
	And I close all client application windows

Scenario: check the choice of currency in the cash payment document if the currency is indicated in the account
# in this case you cannot change the currency (documents: Cash payment, Cash receipt)
	And I click Select button of "Company" field
	And I select current line in "List" table
	And I click Select button of "Cash account" field
	And I go to line in "List" table
			| Description     |
			| Cash desk №4    |
	And I select current line in "List" table
	Then the form attribute named "Currency" became equal to "TRY"
	* Change currency from lira to USD
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| Code   | Description        |
			| USD    | American dollar    |
		And I select current line in "List" table
	* Check that the currency of the document has become USD while the Cash account field has cleared
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "CashAccount" became equal to ""
	And I close all client application windows


Scenario: create a temporary cash desk Cash account No. 4 with a strictly fixed currency (lira)
	Given I open hyperlink "e1cib/list/Catalog.CashAccounts"
	And Delay 2
	And I click the button named "FormCreate"
	And I click Open button of the field named "Description_en"
	And I input "Cash desk №4" text in the field named "Description_en"
	And I input "Cash desk №4 TR" text in the field named "Description_tr"
	And I click "Ok" button
	Then the form attribute named "Type" became equal to "Cash"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	And I change the radio button named "CurrencyType" value to "Fixed"
	And I click Choice button of the field named "Currency"
	And I go to line in "List" table
		| Code  | Description    |
		| TRY   | Turkish lira   |
	And I select current line in "List" table
	And I click the button named "FormWriteAndClose"
	And Delay 5
	Then I check for the "CashAccounts" catalog element with the "Description_en" "Cash desk №4"  
	Then I check for the "CashAccounts" catalog element with the "Description_tr" "Cash desk №4 TR" 





