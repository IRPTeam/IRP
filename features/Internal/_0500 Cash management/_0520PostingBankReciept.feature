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
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create document BR and CS (payment by POS)
		When Create information register Taxes records (VAT)
		When Create catalog Partners, Companies, Agreements for Tax authority
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I set checkbox "Number editing available"
		And I close "System settings" window
	* Check or create SalesOrder023001
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		If "List" table does not contain lines Then
				| "Number"                         |
				| "$$NumberSalesOrder023001$$"     |
			When create SalesOrder023001
	* Check or create SalesInvoice024001
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number"                           |
				| "$$NumberSalesInvoice024001$$"     |
			When create SalesInvoice024001
	* Check or create SalesOrder023005
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number"                         |
				| "$$NumberSalesOrder023005$$"     |
			When create SalesOrder023005
	* Check or create SalesInvoice024008
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		If "List" table does not contain lines Then
				| "Number"                           |
				| "$$NumberSalesInvoice024008$$"     |
			When create SalesInvoice024008	
	When Create document PurchaseReturn objects (creation based on)
	And I execute 1C:Enterprise script at server
			| "Documents.PurchaseReturn.FindByNumber(351).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server		 
		| "Documents.BankReceipt.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server		 
		| "Documents.CashStatement.FindByNumber(104).GetObject().Write(DocumentWriteMode.Posting);"   |
	And I execute 1C:Enterprise script at server		 
		| "Documents.CashStatement.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);"   |
	When Create document SalesInvoice objects (advance, customers)
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(10).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);"    |
Scenario: _0520011 check preparation
	When check preparation

Scenario: _052001 create Bank receipt based on Sales invoice
	* Open list form Sales invoice and select SI №1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024001$$'    |
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
	* Create and filling in Bank receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'               | 'Total amount'   | 'Payer'               | 'Basis document'           | 'Planning transaction basis'    |
			| 'Ferron BP'   | 'Basic Partner terms, TRY'   | '3 687,25'       | 'Company Ferron BP'   | '$$SalesInvoice024001$$'   | ''                              |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'     | 'Amount'   |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,171200' | '631,26'   |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'        | '3 687,25' |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'        | '3 687,25' |
		And I close current window		
	* Check account selection and saving 
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'USD'        | 'Bank account, USD'    |
		And I select current line in "List" table
		Then the form attribute named "Currency" became equal to "USD"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Account" became equal to "Bank account, USD"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'               | 'Total amount'   | 'Payer'               | 'Basis document'           | 'Planning transaction basis'    |
			| 'Ferron BP'   | 'Basic Partner terms, TRY'   | '3 687,25'       | 'Company Ferron BP'   | '$$SalesInvoice024001$$'   | ''                              |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'     | 'Amount'    |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'USD'  | '1'            | '5,627500' | '20 750,00' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'USD'  | '1'            | '1'        | '3 687,25'  |
			| 'TRY'                | 'Partner term' | 'TRY' | 'USD'  | '1'            | '5,627500' | '20 750,00' |
		And I close current window	
		Then the form attribute named "PaymentListTotalTotalAmount" became equal to "3 687,25"
	* Change of Partner term and basis document
		And I select current line in "PaymentList" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		# temporarily
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		# temporarily
		And I go to line in "List" table
			| 'Company'        | 'Amount'      | 'Legal name'          | 'Partner'      |
			| 'Main Company'   | '11 099,93'   | 'Company Ferron BP'   | 'Ferron BP'    |
		And I click "Select" button
		And in "PaymentList" table I move to the next cell
	* Change in payment amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'                       | 'Total amount'   | 'Payer'               | 'Basis document'            |
			| 'Ferron BP'   | 'Basic Partner terms, without VAT'   | '20 000,00'      | 'Company Ferron BP'   | '$$SalesInvoice024008$$'    |
	And I close all client application windows

Scenario: _052002 check that the amount does not change when select basis document in Bank receipt
	And I close all client application windows
	* Open BR and filling main info
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Account" drop-down list by "Bank account, TRY" string
		And I select from "Transaction type" drop-down list by "Payment from customer" string
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select current line in "PaymentList" table
		And I select "Ferron BP" from "Partner" drop-down list by string in "PaymentList" table
		And I select "Company Ferron BP" from "Payer" drop-down list by string in "PaymentList" table
		And I select "Basic Partner terms, without VAT" from "Partner term" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "5 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Reselect SI and check amount
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I go to line in "List" table
			| 'Company'        | 'Amount'      | 'Legal name'          | 'Partner'      |
			| 'Main Company'   | '11 099,93'   | 'Company Ferron BP'   | 'Ferron BP'    |
		And I click "Select" button
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'                       | 'Total amount'   | 'Payer'               | 'Basis document'            |
			| 'Ferron BP'   | 'Basic Partner terms, without VAT'   | '5 000,00'       | 'Company Ferron BP'   | '$$SalesInvoice024008$$'    |
	* Add one more line with the same invoice and check amount
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select current line in "PaymentList" table
		And I select "Ferron BP" from "Partner" drop-down list by string in "PaymentList" table
		And I select "Company Ferron BP" from "Payer" drop-down list by string in "PaymentList" table
		And I select "Basic Partner terms, without VAT" from "Partner term" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I go to line in "List" table
			| 'Company'        | 'Amount'      | 'Legal name'          | 'Partner'      |
			| 'Main Company'   | '6 099,93'   | 'Company Ferron BP'   | 'Ferron BP'    |
		And I click "Select" button
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'                       | 'Total amount'   | 'Payer'               | 'Basis document'            |
			| 'Ferron BP'   | 'Basic Partner terms, without VAT'   | '5 000,00'       | 'Company Ferron BP'   | '$$SalesInvoice024008$$'    |
			| 'Ferron BP'   | 'Basic Partner terms, without VAT'   | '6 099,93'       | 'Company Ferron BP'   | '$$SalesInvoice024008$$'    |
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
				| Code    | Description      |
				| TRY     | Turkish lira     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description           |
				| Bank account, TRY     |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '3 687,25'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '3 687,25'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I select current line in "List" table
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
				| 'Description'         |
				| 'Movement type 1'     |
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
				| 'Number'                           |
				| '$$NumberBankReceipt0520011$$'     |
	* Create Bank receipt in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code    | Description         |
				| USD     | American dollar     |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description           |
				| Bank account, USD     |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '3 587,25'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '3 587,25'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I select current line in "List" table
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
			| 'Number'                          |
			| '$$NumberBankReceipt0520012$$'    |
	* Create Bank receipt in Euro for Ferron BP (Sales invoice in USD)
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code    | Description     |
				| EUR     | Euro            |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Account" field
			And I go to line in "List" table
				| Description           |
				| Bank account, EUR     |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in partners in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click choice button of "Payer" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'      |
					| 'Ferron, USD'      |
			And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Amount'    | 'Company'         | 'Legal name'           | 'Partner'       |
				| '200,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
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
			| 'Number'                          |
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

Scenario: _052009 create Bank receipt based on Purchase return
	And I close all client application windows
	* Select BR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '24.03.2021 16:08:15'   | '351'       |
		And I select current line in "List" table
		And I click "Bank receipt" button
	* Check creation
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return from vendor   Posting status: New   "
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Return from vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "CurrencyExchange" became equal to ""
		And "PaymentList" table became equal
			| '#'   | 'Partner'     | 'Payer'               | 'Partner term'         | 'Legal name contract'   | 'Basis document'                                  | 'Total amount'   | 'Financial movement type'   | 'Planning transaction basis'    |
			| '1'   | 'Ferron BP'   | 'Company Ferron BP'   | 'Vendor Ferron, TRY'   | ''                      | 'Purchase return 351 dated 24.03.2021 16:08:15'   | '5 710,00'       | ''                          | ''                              |
		
		Then the form attribute named "Branch" became equal to ""
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "5 710,00"
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
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| '#'   | Partner   | Total amount   | Payer             | Basis document   | Planning transaction basis    |
			| '1'   | Kalipso   | ''             | Company Kalipso   | ''               | ''                            |



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
			| '#'   | 'Total amount'   | 'Amount exchange'   | 'Planning transaction basis'    |
			| '1'   | '100,00'         | '2 000,00'          | ''                              |




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
			| '#'   | 'Total amount'   | 'Planning transaction basis'    |
			| '1'   | '100,00'         | ''                              |

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
			| 'Description'    |
			| 'Test01'         |
		And I select current line in "List" table
		And I activate "Payment type" field in "PaymentList" table
		And I click choice button of "Payment type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 01'        |
		And I select current line in "List" table
		And I activate "Payment terminal" field in "PaymentList" table
		And I click choice button of "Payment terminal" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Payment terminal 01'    |
		And I select current line in "List" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,33" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check Commission
		And "PaymentList" table contains lines
			| 'Commission'   | 'Payment terminal'      | 'Payment type'   | 'Commission percent'   | 'Bank term'   | 'Total amount'    |
			| '1,01'         | 'Payment terminal 01'   | 'Card 01'        | '1,00'                 | 'Test01'      | '100,33'          |
	* Check Commission calculation (sum and commision percent)
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "333,33" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| '#'   | 'Total amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'   | 'Commission percent'    |
			| '1'   | '333,33'         | '3,37'         | 'Card 01'        | 'Payment terminal 01'   | 'Test01'      | '1,00'                  |
	* Change Commission percent
		And I activate "Commission percent" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "5,00" text in "Commission percent" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'   | 'Commission percent'    |
			| '1'   | '333,33'         | '17,54'        | 'Card 01'        | 'Payment terminal 01'   | 'Test01'      | '5,00'                  |
	* Change Commission sum
		And I activate "Commission" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "22,52" text in "Commission" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'   | 'Commission percent'    |
			| '1'   | '333,33'         | '22,52'        | 'Card 01'        | 'Payment terminal 01'   | 'Test01'      | '6,33'                  |
	* Change payment type
		And I activate "Payment type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Payment type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Card 02'        |
		And I select current line in "List" table
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'   | 'Commission percent'    |
			| '1'   | '333,33'         | '6,80'         | 'Card 02'        | 'Payment terminal 01'   | 'Test01'      | '2,00'                  |
	* Change sum
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "999,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table became equal
			| '#'   | 'Total amount'   | 'Commission'   | 'Payment type'   | 'Payment terminal'      | 'Bank term'   | 'Commission percent'    |
			| '1'   | '999,00'         | '20,39'        | 'Card 02'        | 'Payment terminal 01'   | 'Test01'      | '2,00'                  |
		And I close all client application windows		
		
Scenario: _052017 create Bank receipt with Cash statement (Transfer from POS with Comission)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	And I select "Transfer from POS" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Currency" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Code    |
			| TRY     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description          |
			| Bank account, TRY    |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| Description     |
			| Front office    |
		And I select current line in "List" table
	* Filling PaymentList tab
		And in the table "PaymentList" I click "Add" button
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I activate "POS account" field in "PaymentList" table
		And I click choice button of "POS account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                             |
			| 'POS account 1, TRY'    |
		And I select current line in "List" table
	* Check planing transaction basis selection form
		And I activate "Planning transaction basis" field in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I activate "Cash statements" window
		And "List" table became equal
			| 'Number' | 'Date'                | 'Company'      | 'Amount' | 'Branch' | 'Amount Balance' |
			| '104'    | '07.07.2022 16:33:55' | 'Main Company' | '200,00' | ''       | '200,00'         |
			| '105'    | '08.07.2022 10:47:16' | 'Main Company' | '150,00' | ''       | '150,00'         |
		And in the table "List" I click the button named "ListSetDateInterval"
		Then "Select period" window is opened
		And I input "07.07.2022" text in the field named "DateBegin"
		And I input "07.07.2022" text in the field named "DateEnd"
		And I click the button named "Select"
		And "List" table became equal
			| 'Number' | 'Date'                | 'Company'      | 'Amount' | 'Branch' | 'Amount Balance' |
			| '104'    | '07.07.2022 16:33:55' | 'Main Company' | '200,00' | ''       | '200,00'         |
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
			| 'Number'                          |
			| '$$NumberBankReceipt0520014$$'    |
	* Create one more bank receipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select "Transfer from POS" exact value from "Transaction type" drop-down list
	* Filling in the details of the document
		And I click Select button of "Currency" field
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Code    |
			| TRY     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description          |
			| Bank account, TRY    |
		And I select current line in "List" table
		And I click Select button of "Branch" field
		And I go to line in "List" table
			| Description     |
			| Front office    |
		And I select current line in "List" table
	* Filling PaymentList tab
		And in the table "PaymentList" I click "Add" button
		And I finish line editing in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I activate "POS account" field in "PaymentList" table
		And I click choice button of "POS account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                             |
			| 'POS account 1, TRY'    |
		And I select current line in "List" table
	* Check planing transaction basis selection form
		And I activate "Planning transaction basis" field in "PaymentList" table
		And I click choice button of "Planning transaction basis" attribute in "PaymentList" table
		And I activate "Cash statements" window
		And "List" table became equal
			| 'Number' | 'Date'                | 'Company'      | 'Amount' | 'Branch' | 'Amount Balance' |
			| '104'    | '07.07.2022 16:33:55' | 'Main Company' | '200,00' | ''       | '100,00'         |
			| '105'    | '08.07.2022 10:47:16' | 'Main Company' | '150,00' | ''       | '150,00'         |
		And I go to line in "List" table
			| 'Amount' | 'Amount Balance' | 'Company'      | 'Date'                | 'Number' |
			| '200,00' | '100,00'         | 'Main Company' | '07.07.2022 16:33:55' | '104'    |
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
			| 'Description'                |
			| 'Distribution department'    |
		And I select current line in "List" table
		And I activate "Expense type" field in "PaymentList" table
		And I click choice button of "Expense type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
	* Check filling
		And "PaymentList" table became equal
			| '#' | 'Commission' | 'POS account'        | 'Total amount' | 'Financial movement type' | 'Profit loss center'      | 'Planning transaction basis'                   | 'Commission percent' | 'Additional analytic' | 'Expense type' |
			| '1' | '2,04'       | 'POS account 1, TRY' | '100,00'       | 'Movement type 1'         | 'Distribution department' | 'Cash statement 104 dated 07.07.2022 16:33:55' | '2,00'               | ''                    | 'Expense'      |
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0520015$$" variable
		And I delete "$$BankReceipt0520015$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0520015$$"
		And I save the window as "$$BankReceipt0520015$$"
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberBankReceipt0520015$$'    |
		And I close all client application windows
			
			
				

Scenario: _052018 check connection to BankReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number                         |
		| $$NumberBankReceipt0520011$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows


Scenario: _052019 try post Bank receipt with empty amount
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankReceipt"
	And I click the button named "FormCreate"
	* Filling in the details of the document
		And I select "Payment from customer" exact value from "Transaction type" drop-down list
		And I click Select button of "Currency" field
		And I go to line in "List" table
			| Code    | Description      |
			| TRY     | Turkish lira     |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| Description      |
			| Main Company     |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| Description           |
			| Bank account, TRY     |
		And I select current line in "List" table
	And in the table "PaymentList" I click the button named "PaymentListAdd"
	* Filling in partners in a tabular part
		And I activate "Partner" field in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Kalipso     |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description     |
			| Company Kalipso |
		And I select current line in "List" table
	* Try post and check message
		And I click "Post" button
		Then there are lines in TestClient message log
			|'Fill total amount. Row: [1]'|
		And I close all client application windows
		
Scenario: _052020 check selection form (Payment by documents) in BR
	And I close all client application windows
	* Open BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Account" drop-down list by "Bank account, TRY" string
		And I select from "Transaction type" drop-down list by "Payment from customer" string
	* Check filter by Branch
		* Without branch
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| 'Document'                                   | 'Partner'   | 'Partner term'                     | 'Legal name'        | 'Legal name contract' | 'Order'                                   | 'Project' | 'Amount'    | 'Payment' |
				| 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Lunch'     | 'Basic Partner terms, TRY'         | 'Company Lunch'     | ''                    | 'Sales order 6 dated 04.09.2023 13:03:16' | ''        | '2 600,00'  | ''        |
				| 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Lunch'     | 'Basic Partner terms, TRY'         | 'Company Lunch'     | ''                    | 'Sales order 7 dated 04.09.2023 13:03:26' | ''        | '2 600,00'  | ''        |
				| '$$SalesInvoice024001$$'                     | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$'                    | ''        | '3 024,50'  | ''        |
				| '$$SalesInvoice024008$$'                     | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$'                    | ''        | '11 099,93' | ''        |
			And I close current window
		* With branch
			And I move to "Other" tab
			And I select from the drop-down list named "Branch" by "Distribution department" string
			And I move to "Payments" tab
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| "Check" | "Document"                                   | "Partner"         | "Partner term"                  | "Legal name"       | "Order" | "Amount"    | "Payment" | "Legal name contract" | "Project" |
				| "No"    | ""                                           | "Partner Kalipso" | "Partner Kalipso Customer"      | "Company Kalipso"  | ""      | "3 000,00"  | ""        | ""                    | ""        |
				| "No"    | ""                                           | "DFC"             | "DFC Customer by Partner terms" | "DFC"              | ""      | "2 944,00"  | ""        | ""                    | ""        |
				| "No"    | "Sales invoice 14 dated 16.02.2021 12:14:54" | "Lomaniti"        | "Basic Partner terms, TRY"      | "Company Lomaniti" | ""      | "12 400,00" | ""        | ""                    | ""        |
				| "No"    | "Sales invoice 15 dated 12.04.2021 12:00:01" | "Lomaniti"        | "Basic Partner terms, TRY"      | "Company Lomaniti" | ""      | "20 000,00" | ""        | ""                    | ""        |				
	* Allocation check	(one partner)
		And I input "10 000,00" text in the field named "Amount"
		And I click the button named "Calculate"
		And "Documents" table became equal
			| "Check" | "Document"                                   | "Partner"         | "Partner term"                  | "Legal name"       | "Order" | "Amount"    | "Payment"  | "Legal name contract" | "Project" |
			| "No"    | ""                                           | "Partner Kalipso" | "Partner Kalipso Customer"      | "Company Kalipso"  | ""      | "3 000,00"  | "3 000,00" | ""                    | ""        |
			| "No"    | ""                                           | "DFC"             | "DFC Customer by Partner terms" | "DFC"              | ""      | "2 944,00"  | "2 944,00" | ""                    | ""        |
			| "No"    | "Sales invoice 14 dated 16.02.2021 12:14:54" | "Lomaniti"        | "Basic Partner terms, TRY"      | "Company Lomaniti" | ""      | "12 400,00" | "4 056,00" | ""                    | ""        |
			| "No"    | "Sales invoice 15 dated 12.04.2021 12:00:01" | "Lomaniti"        | "Basic Partner terms, TRY"      | "Company Lomaniti" | ""      | "20 000,00" | ""         | ""                    | ""        |		
		* Amount more then invoice sum
			And I input "45 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			And "Documents" table became equal
				| "Check" | "Document"                                   | "Partner"         | "Partner term"                  | "Legal name"       | "Order" | "Amount"    | "Payment"   | "Legal name contract" | "Project" |
				| "No"    | ""                                           | "Partner Kalipso" | "Partner Kalipso Customer"      | "Company Kalipso"  | ""      | "3 000,00"  | "3 000,00"  | ""                    | ""        |
				| "No"    | ""                                           | "DFC"             | "DFC Customer by Partner terms" | "DFC"              | ""      | "2 944,00"  | "2 944,00"  | ""                    | ""        |
				| "No"    | "Sales invoice 14 dated 16.02.2021 12:14:54" | "Lomaniti"        | "Basic Partner terms, TRY"      | "Company Lomaniti" | ""      | "12 400,00" | "12 400,00" | ""                    | ""        |
				| "No"    | "Sales invoice 15 dated 12.04.2021 12:00:01" | "Lomaniti"        | "Basic Partner terms, TRY"      | "Company Lomaniti" | ""      | "20 000,00" | "20 000,00" | ""                    | ""        |			
			And I click "Ok" button
			And I finish line editing in "PaymentList" table
			And "PaymentList" table became equal
				| "#" | "Partner"         | "Payer"            | "Partner term"                  | "Legal name contract" | "Basis document"                             | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
				| "1" | "Partner Kalipso" | "Company Kalipso"  | "Partner Kalipso Customer"      | ""                    | ""                                           | ""        | ""      | "3 000,00"     | ""                        | ""                 | ""                           |
				| "2" | "DFC"             | "DFC"              | "DFC Customer by Partner terms" | ""                    | ""                                           | ""        | ""      | "2 944,00"     | ""                        | ""                 | ""                           |
				| "3" | "Lomaniti"        | "Company Lomaniti" | "Basic Partner terms, TRY"      | ""                    | "Sales invoice 14 dated 16.02.2021 12:14:54" | ""        | ""      | "12 400,00"    | ""                        | ""                 | ""                           |
				| "4" | "Lomaniti"        | "Company Lomaniti" | "Basic Partner terms, TRY"      | ""                    | "Sales invoice 15 dated 12.04.2021 12:00:01" | ""        | ""      | "20 000,00"    | ""                        | ""                 | ""                           |			
			And in the table "PaymentList" I click "Payment by documents" button
			Then the number of "Documents" table lines is "равно" "0"
	* Allocation check	(two partners)
			And I close current window	
			And I move to "Other" tab
			And I input "" text in the field named "Branch"		
			And I move to "Payments" tab
			And in the table "PaymentList" I click "Payment by documents" button
		* Select lines and check allocation	
			And I go to line in "Documents" table
				| 'Amount'   | 'Document'                                   | 'Legal name'    | 'Order'                                   | 'Partner' | 'Partner term'             |
				| '2 600,00' | 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Company Lunch' | 'Sales order 6 dated 04.09.2023 13:03:16' | 'Lunch'   | 'Basic Partner terms, TRY' |
			And I move one line down in "Documents" table and select line
			And I input "4 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			And "Documents" table became equal
				| 'Document'                                   | 'Partner'   | 'Partner term'                     | 'Legal name'        | 'Legal name contract' | 'Order'                                   | 'Project' | 'Amount'    | 'Payment'  |
				| 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Lunch'     | 'Basic Partner terms, TRY'         | 'Company Lunch'     | ''                    | 'Sales order 6 dated 04.09.2023 13:03:16' | ''        | '2 600,00'  | '2 600,00' |
				| 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Lunch'     | 'Basic Partner terms, TRY'         | 'Company Lunch'     | ''                    | 'Sales order 7 dated 04.09.2023 13:03:26' | ''        | '2 600,00'  | '1 400,00' |
				| '$$SalesInvoice024001$$'                     | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$'                    | ''        | '3 024,50'  | ''         |
				| '$$SalesInvoice024008$$'                     | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$'                    | ''        | '11 099,93' | ''         |
		* Check fifo allocation
			Then "Payment distribution" window is opened
			And I select from the drop-down list named "FilterPartner" by "Ferron BP" string
			And I input "5 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			Then the form attribute named "FilterPartner" became equal to "Ferron BP"
			And "Documents" table became equal
				| 'Document'               | 'Partner'   | 'Partner term'                     | 'Legal name'        | 'Legal name contract' | 'Order'                | 'Project' | 'Amount'    | 'Payment'  |
				| '$$SalesInvoice024001$$' | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$' | ''        | '3 024,50'  | '3 024,50' |
				| '$$SalesInvoice024008$$' | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$' | ''        | '11 099,93' | '1 975,50' |
			And I click "Ok" button
			And "PaymentList" table became equal
				| '#' | 'Partner'         | 'Payer'             | 'Partner term'                     | 'Legal name contract' | 'Basis document'                             | 'Project' | 'Order'                | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
				| "1" | "Partner Kalipso" | "Company Kalipso"   | "Partner Kalipso Customer"         | ""                    | ""                                           | ""        | ""                     | "3 000,00"     | ""                        | ""                 | ""                           |
				| "2" | "DFC"             | "DFC"               | "DFC Customer by Partner terms"    | ""                    | ""                                           | ""        | ""                     | "2 944,00"     | ""                        | ""                 | ""                           |
				| '3' | 'Lomaniti'        | 'Company Lomaniti'  | 'Basic Partner terms, TRY'         | ''                    | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''        | ''                     | '12 400,00'    | ''                        | ''                 | ''                           |
				| '4' | 'Lomaniti'        | 'Company Lomaniti'  | 'Basic Partner terms, TRY'         | ''                    | 'Sales invoice 15 dated 12.04.2021 12:00:01' | ''        | ''                     | '20 000,00'    | ''                        | ''                 | ''                           |
				| '5' | 'Ferron BP'       | 'Company Ferron BP' | 'Basic Partner terms, TRY'         | ''                    | '$$SalesInvoice024001$$'                     | ''        | '$$SalesOrder023001$$' | '3 024,50'     | ''                        | ''                 | ''                           |
				| '6' | 'Ferron BP'       | 'Company Ferron BP' | 'Basic Partner terms, without VAT' | ''                    | '$$SalesInvoice024008$$'                     | ''        | '$$SalesOrder023005$$' | '1 975,50'     | ''                        | ''                 | ''                           |
		And I close all client application windows				
				
	

Scenario: _052021 check amount when create BR based on SI (partner term - by partner terms)
	And I close all client application windows
	* Select two SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Amount'   | 'Legal name'      |
			| '1 000,00' | 'Company Kalipso' |
		And I move one line down in "List" table and select line
	* Create Bank receipt
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
	* Check amount (documents amount )
		And "PaymentList" table became equal
			| '#' | 'Partner'         | 'Payer'           | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | ''                    | ''               | ''        | ''      | '3 000,00'     | ''                        | ''                 | ''                           |
	And I close all client application windows
	* Select one SI				
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Amount'   | 'Legal name'      |
			| '1 000,00' | 'Company Kalipso' |
	* Create Bank receipt
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
	* Check amount (documents amount )
		And "PaymentList" table became equal
			| '#' | 'Partner'         | 'Payer'           | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | ''                    | ''               | ''        | ''      | '1 000,00'     | ''                        | ''                 | ''                           |
	And I close all client application windows				

Scenario: _052022 create Bank receipt with transaction type Other income
	And I close all client application windows
	* Open BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Filling main details
		And I select "Other income" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Account" by "Bank account, TRY" string
	* Filling payment list
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I input "Movement type 1" text in "Financial movement type" field of "PaymentList" table
		And I activate "Cash flow center" field in "PaymentList" table
		And I select "Distribution department" from "Cash flow center" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I select "Revenue" by string from the drop-down list named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Profit loss center" field in "PaymentList" table
		And I select "Distribution department" from "Profit loss center" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
	* Check
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Revenue type' | 'Total amount' | 'Financial movement type' | 'Profit loss center'      | 'Cash flow center'        | 'Additional analytic' |
			| '1' | 'Revenue'      | '100,00'       | 'Movement type 1'         | 'Distribution department' | 'Distribution department' | ''                    |
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "TransactionType" became equal to "Other income"
		And I save the value of "Number" field as "NumberBankReceipt052022"
		And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                        |
				| '$NumberBankReceipt052022$'     |

Scenario: _052023 create Bank receipt with transaction type Other partner
	And I close all client application windows
	* Open BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Filling main details
		And I select "Other partner" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "Account" by "Bank account, TRY" string
	* Filling payment list
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select current line in "PaymentList" table
		And I input "Tax authority" text in "Partner" field of "PaymentList" table
		And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I input "Movement type 1" text in "Financial movement type" field of "PaymentList" table
		And I activate "Cash flow center" field in "PaymentList" table
		And I select "Distribution department" from "Cash flow center" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
	* Check
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'       | 'Payer'         | 'Partner term' | 'Legal name contract' | 'Total amount' | 'Financial movement type' | 'Cash flow center'        |
			| '1' | 'Tax authority' | 'Tax authority' | 'Tax'          | ''                    | '100,00'       | 'Movement type 1'         | 'Distribution department' |		
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "TransactionType" became equal to "Other partner"
		And I save the value of "Number" field as "NumberBankReceipt052023"
		And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                        |
				| '$NumberBankReceipt052023$'     |

// Scenario: _052024 create Bank receipt based on SO (Partner term - TRY, document USD)	
// 	And I close all client application windows
// 	* Select SO
// 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '235'    |
// 	* Create BR
// 		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
// 		And I click Select button of "Account" field
// 		And I go to line in "List" table
// 			| "Currency" | "Description"       |
// 			| "TRY"      | "Bank account, TRY" |
// 		And I select current line in "List" table
// 	* Check filling
// 		Then the form attribute named "Account" became equal to "Cash desk №4"
// 		Then the form attribute named "Company" became equal to "Main Company"
// 		Then the form attribute named "Currency" became equal to "TRY"
// 		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		
Scenario: _052026 create Bank receipt based on SI (Partner term - USD, document TRY)	
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '236'    |
	* Create first BR
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And I click Select button of "Account" field
		And I go to line in "List" table
			| "Description"       |
			| "Bank account, USD" |
		And I select current line in "List" table
	* Check filling
		Then the form attribute named "Account" became equal to "Bank account, USD"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "USD"
		And I click "Save" button		
		And "PaymentList" table became equal
			| "#" | "Partner"   | "Payer"             | "Partner term" | "Legal name contract" | "Basis document"                              | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
			| "1" | "Ferron BP" | "Company Ferron BP" | "Ferron, USD"  | ""                    | "Sales invoice 236 dated 08.08.2024 11:20:30" | ""        | ""      | "171,20"       | ""                        | ""                 | ""                           |
	* Reselect SI
		* From form select
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I click choice button of "Basis document" attribute in "PaymentList" table
			And I go to line in "List" table
				| "Amount" | "Company"      | "Currency" | "Document"                                    | "Legal name"        | "Partner"   | "Partner term" |
				| "171,20" | "Main Company" | "USD"      | "Sales invoice 236 dated 08.08.2024 11:20:30" | "Company Ferron BP" | "Ferron BP" | "Ferron, USD"  |
			And I select current line in "List" table
			And I click "Save" button		
			And "PaymentList" table became equal
				| "#" | "Partner"   | "Payer"             | "Partner term" | "Legal name contract" | "Basis document"                              | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
				| "1" | "Ferron BP" | "Company Ferron BP" | "Ferron, USD"  | ""                    | "Sales invoice 236 dated 08.08.2024 11:20:30" | ""        | ""      | "171,20"       | ""                        | ""                 | ""                           |
		* From payment distribution
			And I select current line in "PaymentList" table
			And I delete a line in "PaymentList" table
			And in the table "PaymentList" I click "Payment by documents" button
			And I go to line in "Documents" table
				| "Amount" | "Document"                                    |
				| "171,20" | "Sales invoice 236 dated 08.08.2024 11:20:30" |
			And I set "Check" checkbox in "Documents" table
			And I finish line editing in "Documents" table
			And I click "Ok" button
			And "PaymentList" table became equal
				| "#" | "Partner"   | "Payer"             | "Partner term" | "Legal name contract" | "Basis document"                              | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
				| "1" | "Ferron BP" | "Company Ferron BP" | "Ferron, USD"  | ""                    | "Sales invoice 236 dated 08.08.2024 11:20:30" | ""        | ""      | "171,20"       | ""                        | ""                 | ""                           |
		* Change amount and Post BR
			And I select current line in "PaymentList" table
			And I input "150,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I click "Post" button
		* Create second BR
			Given I open hyperlink "e1cib/list/Document.SalesInvoice"
			And I go to line in "List" table
				| 'Number' |
				| '236'    |			
			And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
			And I click Select button of "Account" field
			And I go to line in "List" table
				| "Description"       |
				| "Bank account, USD" |
			And I select current line in "List" table
		* Check amount
			And "PaymentList" table became equal
				| "#" | "Partner"   | "Payer"             | "Partner term" | "Legal name contract" | "Basis document"                              | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
				| "1" | "Ferron BP" | "Company Ferron BP" | "Ferron, USD"  | ""                    | "Sales invoice 236 dated 08.08.2024 11:20:30" | ""        | ""      | "21,20"        | ""                        | ""                 | ""                           |
			And I click "Post" button			
	And I close all client application windows

// Scenario: _050027 create Bank receipt based on SI (Partner term - TRY, document USD)
// 	And I close all client application windows
// 	* Select SI
// 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '235'    |
// 	* Create CR
// 		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
// 		And I click Select button of "Account" field
// 		And I go to line in "List" table
// 			| "Currency" | "Description"       |
// 			| "TRY"      | "Bank account, TRY" |
// 		And I select current line in "List" table
// 	* Check filling	
// 		Then the form attribute named "Account" became equal to "Cash desk №4"
// 		Then the form attribute named "Company" became equal to "Main Company"
// 		Then the form attribute named "Currency" became equal to "TRY"
// 		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
// 		And I click "Save" button	
// 		And "PaymentList" table became equal
// 			| "#" | "Partner"  | "Payer"            | "Partner term"             | "Legal name contract" | "Basis document"                              | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
// 			| "1" | "Lomaniti" | "Company Lomaniti" | "Basic Partner terms, TRY" | ""                    | "Sales invoice 235 dated 08.08.2024 11:04:29" | ""        | ""      | "19 268,56"    | ""                        | ""                 | ""                           |
// 	* Reselect SI
// 		And I select current line in "PaymentList" table
// 		And I delete a line in "PaymentList" table
// 		And in the table "PaymentList" I click "Payment by documents" button
// 		And I go to line in "Documents" table
// 			| "Amount"    | "Check" | "Document"                                    | "Legal name"       | "Partner"  | "Partner term"             |
// 			| "19 268,56" | "No"    | "Sales invoice 235 dated 08.08.2024 11:04:29" | "Company Lomaniti" | "Lomaniti" | "Basic Partner terms, TRY" |
// 		And I set "Check" checkbox in "Documents" table
// 		And I click "Ok" button
// 		And I click "Save" button
// 		And "PaymentList" table became equal
// 			| "#" | "Partner"  | "Payer"            | "Partner term"             | "Legal name contract" | "Basis document"                              | "Project" | "Order" | "Total amount" | "Financial movement type" | "Cash flow center" | "Planning transaction basis" |
// 			| "1" | "Lomaniti" | "Company Lomaniti" | "Basic Partner terms, TRY" | ""                    | "Sales invoice 235 dated 08.08.2024 11:04:29" | ""        | ""      | "19 268,56"    | ""                        | ""                 | ""                           |
// 	
// And I close all client application windows			