#language: en
@tree
@Positive
@BankCashDocuments

Feature: create Bank receipt

As an accountant
I want to display the incoming bank payments
To close partners debts


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira
# CashBankDocFilters export scenarios


	
Scenario:  _052001 preparation (Bank receipt)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
		When Create catalog ExpenseAndRevenueTypes objects
		When update ItemKeys
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
		When Create catalog CashStatementStatuses objects (Test)
		When Create document BR and CS (payment by POS)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Check or create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023001$$" |
			When create SalesOrder023001
	* Check or create SalesInvoice024001
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024001$$" |
			When create SalesInvoice024001
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesOrder023005$$" |
			When create SalesOrder023005
	* Check or create SalesInvoice024008
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberSalesInvoice024008$$" |
			When create SalesInvoice024008	
	When Create document PurchaseReturn objects (creation based on)
	And I execute 1C:Enterprise script at server
 		| "Documents.PurchaseReturn.FindByNumber(351).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
 		| "Documents.BankReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server		 
		| "Documents.BankReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server		 
		| "Documents.CashStatement.FindByNumber(104).GetObject().Write(DocumentWriteMode.Posting);" |
	


Scenario: _052001 create Bank receipt based on Sales invoice
	* Open list form Sales invoice and select SI №1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesInvoice024001$$'      |
		And I click the button named "FormDocumentBankReceiptGenarateBankReceipt"
	* Create and filling in Bank receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'             | 'Total amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 250,00' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | ''                          |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '727,60' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '4 250'  |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '4 250'  |
		And I close current window		
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
			| 'Partner'   | 'Partner term'             | 'Total amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 250,00' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | ''                          |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'    |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'USD'  | '1'            | '5,6275' | '23 916,88' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'USD'  | '1'            | '1'      | '4 250'     |
			| 'TRY'                | 'Partner term' | 'TRY' | 'USD'  | '1'            | '5,6275' | '23 916,88' |	
		And I close current window	
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
			| 'Company'      | 'Amount' | 'Legal name'        | 'Partner'   |
			| 'Main Company' | '11 099,93'       | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
		And in "PaymentList" table I move to the next cell
	* Change in payment amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                     | 'Total amount'    | 'Payer'             | 'Basis document'  |
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
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 250,00'     | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "100,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		* Select movement type
			And I activate "Financial movement type" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Movement type 1' |
			And I select current line in "List" table		
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0520011$$" variable
		And I delete "$$BankReceipt0520011$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0520011$$"
		And I save the window as "$$BankReceipt0520011$$"
		And I click the button named "FormPostAndClose"
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
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 150,00'     | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "100,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0520012$$" variable
		And I delete "$$BankReceipt0520012$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0520012$$"
		And I save the window as "$$BankReceipt0520012$$"
		And I click the button named "FormPostAndClose"
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
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '200,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "50,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0520013$$" variable
		And I delete "$$BankReceipt0520013$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0520013$$"
		And I save the window as "$$BankReceipt0520013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Bank receipt
			And "List" table contains lines
			| 'Number' |
			| '$$NumberBankReceipt0520013$$'    |	
	



	

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

Scenario: _050009 create Bank receipt based on Purchase return
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '24.03.2021 16:08:15' | '351'     |
		And I select current line in "List" table
		And I click "Bank receipt" button
	* Check creation
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return from vendor   "
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Return from vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "CurrencyExchange" became equal to ""
		And "PaymentList" table became equal
			| '#' | 'Partner'   | 'Payer'             | 'Partner term'       | 'Legal name contract' | 'Basis document'                                | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | ''                    | 'Purchase return 351 dated 24.03.2021 16:08:15' | '5 710,00'     | ''                        | ''                           |
		
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "DocumentAmount" became equal to "5 710,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	And I close all client application windows



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
			| '#' | Partner | Total amount | Payer           | Basis document | Planning transaction basis |
			| '1' | Kalipso | ''           | Company Kalipso | ''             | ''                         |



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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "2 000,00" text in "Amount exchange" field of "PaymentList" table
		And "PaymentList" table contains lines
			| '#' | 'Total amount' | 'Amount exchange' | 'Planning transaction basis' |
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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payer" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
			| '#' | 'Total amount' | 'Planning transaction basis' |
			| '1' | '100,00' | ''                          |

Scenario: _052016 check Commission calculation in the Bank receipt (Payment from customer by POS)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	And I select "Payment from customer by POS" exact value from "Transaction type" drop-down list
	* Filling PaymentList tab
		And in the table "PaymentList" I click "Add" button
		And I activate "Bank term" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Bank term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Test01' |
		And I select current line in "List" table
		And I activate "Payment type" field in "PaymentList" table
		And I click choice button of "Payment type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 01'     |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "PaymentList" table
		And I click choice button of "Payment terminal" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Test01'     |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,33" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check Commission
		And "PaymentList" table contains lines
			| 'Commission' | 'Payment terminal' | 'Payment type' | 'Commission percent' | 'Bank term' | 'Total amount' |
			| '1,00'       | 'Test01'           | 'Card 01'      | '1,00'               | 'Test01'    | '100,33'       |
	* Check Commission calculation (sum and commision percent)
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "333,33" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| '#' | 'Total amount' | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Commission percent' |
			| '1' | '333,33'       | '3,33'       | 'Card 01'      | 'Test01'           | 'Test01'    | '1,00'               |
	* Change Commission percent
		And I activate "Commission percent" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "5,00" text in "Commission percent" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Total amount' | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Commission percent' |
			| '1' | '333,33'       | '16,67'      | 'Card 01'      | 'Test01'           | 'Test01'    | '5,00'               |
	* Change Commission sum
		And I activate "Commission" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "22,52" text in "Commission" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Total amount' | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Commission percent' |
			| '1' | '333,33'       | '22,52'      | 'Card 01'      | 'Test01'           | 'Test01'    | '6,76'               |
	* Change payment type
		And I activate "Payment type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Payment type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Card 02'     |
		And I select current line in "List" table
		And "PaymentList" table became equal
			| '#' | 'Total amount' | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Commission percent' |
			| '1' | '333,33'       | '6,67'       | 'Card 02'      | 'Test01'           | 'Test01'    | '2,00'               |
	* Change sum
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "999,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#' | 'Total amount' | 'Commission' | 'Payment type' | 'Payment terminal' | 'Bank term' | 'Commission percent' |
			| '1' | '999,00'       | '19,98'      | 'Card 02'      | 'Test01'           | 'Test01'    | '2,00'               |
		And I close all client application windows		
		
Scenario: _052017 create Bank receipt (Transfer from POS)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	And I select "Transfer from POS" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Currency" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Code |
			| TRY  |
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
	* Filling PaymentList tab
		And in the table "PaymentList" I click "Add" button
		And I set "Commission is separate" checkbox in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "POS account" field in "PaymentList" table
		And I click choice button of "POS account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
	* Check planing transaction basis selection form
		And I activate "Planning transaction basis" field in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I activate "Cash statements" window
		And "List" table became equal
			| 'Number' | 'Date'                | 'Company'      | 'Amount' | 'Commission' | 'Branch' | 'Amount Balance' | 'Commission Balance' | 'Reference'                                    |
			| '104'    | '07.07.2022 16:33:55' | 'Main Company' | '200,00' | '2,00'       | ''       | '200,00'         | '2,00'               | 'Cash statement 104 dated 07.07.2022 16:33:55' |
			| '105'    | '08.07.2022 10:47:16' | 'Main Company' | '150,00' | '1,50'       | ''       | '150,00'         | '1,50'               | 'Cash statement 105 dated 08.07.2022 10:47:16' |
		And in the table "List" I click the button named "ListSetDateInterval"
		Then "Select period" window is opened
		And I input "07.07.2022" text in the field named "DateBegin"
		And I input "07.07.2022" text in the field named "DateEnd"
		And I click the button named "Select"
		And "List" table became equal
			| 'Number' | 'Date'                | 'Company'      | 'Amount' | 'Commission' | 'Branch' | 'Amount Balance' | 'Commission Balance' | 'Reference'                                    |
			| '104'    | '07.07.2022 16:33:55' | 'Main Company' | '200,00' | '2,00'       | ''       | '200,00'         | '2,00'               | 'Cash statement 104 dated 07.07.2022 16:33:55' |
		And in the table "List" I click the button named "ListChoose"
		And I finish line editing in "PaymentList" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0520014$$" variable
		And I delete "$$BankReceipt0520014$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0520014$$"
		And I save the window as "$$BankReceipt0520014$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Bank receipt
			And "List" table contains lines
			| 'Number' |
			| '$$NumberBankReceipt0520014$$'    |	
	* Create one more bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select "Transfer from POS" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Currency" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Code |
			| TRY  |
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
	* Filling PaymentList tab
		And in the table "PaymentList" I click "Add" button
		And I set "Commission is separate" checkbox in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "POS account" field in "PaymentList" table
		And I click choice button of "POS account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Transit Main' |
		And I select current line in "List" table
	* Check planing transaction basis selection form
		And I activate "Planning transaction basis" field in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I activate "Cash statements" window
		And "List" table became equal
			| 'Number' | 'Date'                | 'Company'      | 'Amount' | 'Commission' | 'Branch' | 'Amount Balance' | 'Commission Balance' | 'Reference'                                    |
			| '104'    | '07.07.2022 16:33:55' | 'Main Company' | '200,00' | '2,00'       | ''       | '100,00'         | '2,00'               | 'Cash statement 104 dated 07.07.2022 16:33:55' |
			| '105'    | '08.07.2022 10:47:16' | 'Main Company' | '150,00' | '1,50'       | ''       | '150,00'         | '1,50'               | 'Cash statement 105 dated 08.07.2022 10:47:16' |
		And I go to line in "List" table
			| 'Amount' | 'Amount Balance' | 'Commission' | 'Commission Balance' | 'Company'      | 'Date'                | 'Number' | 'Reference'                                    |
			| '200,00' | '100,00'         | '2,00'       | '2,00'               | 'Main Company' | '07.07.2022 16:33:55' | '104'    | 'Cash statement 104 dated 07.07.2022 16:33:55' |
		And I select current line in "List" table
	* Filling other attribute
		And I activate "Commission percent" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "2,00" text in "Commission percent" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Profit loss center" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Profit loss center" attribute in "PaymentList" table
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I activate "Expense type" field in "PaymentList" table
		And I click choice button of "Expense type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Expense'     |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Commission is separate" field in "PaymentList" table
		And I remove "Commission is separate" checkbox in "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check filling
		And "PaymentList" table became equal
			| '#' | 'Commission' | 'Commission is separate' | 'POS account'  | 'Total amount' | 'Financial movement type' | 'Profit loss center'      | 'Planning transaction basis'                   | 'Commission percent' | 'Additional analytic' | 'Expense type' |
			| '1' | '2,00'       | 'No'                     | 'Transit Main' | '100,00'       | 'Movement type 1'         | 'Distribution department' | 'Cash statement 104 dated 07.07.2022 16:33:55' | '2,00'               | ''                    | 'Expense'      |
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0520015$$" variable
		And I delete "$$BankReceipt0520015$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0520015$$"
		And I save the window as "$$BankReceipt0520015$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number' |
			| '$$NumberBankReceipt0520015$$'    |
		And I close all client application windows
			
			
				

Scenario: _300515 check connection to BankReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberBankReceipt0520011$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
