#language: en
@tree
@Positive
@BankCashDocuments
Feature: create Cash receipt

As a cashier
I want to accept the cash in hand.
For Cash/Bank accountsing



Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira
# CashBankDocFilters export scenarios

		
Scenario: _050000 preparation (Cash receipt)
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
		When Create catalog BusinessUnits objects
		When update ItemKeys
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
	

Scenario: _050001 create Cash receipt based on Sales invoice
	* Open list form Sales invoice and select SI №1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberSalesInvoice024001$$'      |
		And I click the button named "FormDocumentCashReceiptGenarateCashReceipt"
	* Create and filling in Cash receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'             | 'Amount'   | 'Payer'             | 'Basis document'   | 'Planning transaction basis' |
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 350,00' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | ''                          |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '744,72' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '4 350'  |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '4 350'  |
		And I close current window	
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
			| 'Ferron BP' | 'Basic Partner terms, TRY' | '4 350,00' | 'Company Ferron BP' | '$$SalesInvoice024001$$' | ''                          |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount' |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '744,72' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '4 350'  |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '4 350'  |
		And I close current window		
		Then the form attribute named "DocumentAmount" became equal to "4 350,00"
	* Change of Partner term and basis document
		And I select current line in "PaymentList" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                   |
			| 'Basic Partner terms, without VAT' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I go to line in "List" table
			| 'Company'      | 'Amount' | 'Legal name'        | 'Partner'   |
			| 'Main Company' | '11 099,93'       | 'Company Ferron BP' | 'Ferron BP' |
		And I click "Select" button
	* Change in payment amount
		And I activate field named "PaymentListAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'                     | 'Amount'    | 'Payer'             | 'Basis document'  |
			| 'Ferron BP' | 'Basic Partner terms, without VAT' | '20 000,00' | 'Company Ferron BP' | '$$SalesInvoice024008$$' |
	And I close all client application windows




Scenario: _050001 create Cash receipt (independently)
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
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 350,00'         | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "100,00" text in "Amount" field of "PaymentList" table
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
		And I delete "$$NumberCashReceipt0500011$$" variable
		And I delete "$$CashReceipt0500011$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0500011$$"
		And I save the window as "$$CashReceipt0500011$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number' |
			|  '$$NumberCashReceipt0500011$$'    |
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
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '4 250,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "100,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt0500012$$" variable
		And I delete "$$CashReceipt0500012$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0500012$$"
		And I save the window as "$$CashReceipt0500012$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number' |
			|  '$$NumberCashReceipt0500012$$'    |
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
			And I go to line in "List" table
				| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
				| '200,00'        | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Amount" field in "PaymentList" table
			And I input "50,00" text in "Amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt0500013$$" variable
		And I delete "$$CashReceipt0500013$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0500013$$"
		And I save the window as "$$CashReceipt0500013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number' |
			|  '$$NumberCashReceipt0500013$$'    |


	


# Filters

Scenario: _050003 filter check by own companies in the document Cash receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the filter by own company

Scenario: _050004 cash filter check (bank selection not available)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the filter by cash account (bank account selection is not available)


Scenario: _050005 check input Description in the documentCash receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check filling in Description

Scenario: _050006 check the choice of transaction type in the documentCash receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the choice of the type of operation in the documents of receipt of payment


Scenario: _050007 check legal name filter in tabular part in document Cash receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the legal name filter in the tabular part of the payment receipt documents

Scenario: _050008 check partner filter in tabular part in document Cash receipt
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	When check the partner filter in the tabular part of the payment receipt documents



# EndFilters


Scenario: _050011 check currency selection in Cash receipt document in case the currency is specified in the account
# the choice is not available
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	And I click the button named "FormCreate"
	When check the choice of currency in the cash payment document if the currency is indicated in the account
	And I delete "CashAccounts" catalog element with the Description_en "Cash desk №4"




Scenario: _050013 check the display of details on the form Cash receipt with the type of operation Payment from customer
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



Scenario: _050014 check the display of details on the form Cash receipt with the type of operation Currency exchange
	And I close all client application windows
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



Scenario: _050015 check the display of details on the form Cash receipt with the type of operation Cash transfer
	And I close all client application windows
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



Scenario: _300513 check connection to CashReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberCashReceipt0500011$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
