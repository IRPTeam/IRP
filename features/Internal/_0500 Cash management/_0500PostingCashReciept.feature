#language: en
@tree
@Positive
@BankCashDocuments
Feature: create Cash receipt

As a cashier
I want to accept the cash in hand.
For Cash/Bank accountsing

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira
# CashBankDocFilters export scenarios

		
Scenario: _050000 preparation (Cash receipt)
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
		When Create catalog Countries objects
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
		When Create catalog Partners objects
		When Create information register Taxes records (VAT)
		When Create catalog Partners, Companies, Agreements for Tax authority
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
				| "Documents.PurchaseReturn.FindByNumber(351).GetObject().Write(DocumentWriteMode.Posting);"     |
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
	Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
	And I set checkbox "Number editing available"
	And I close "System settings" window

Scenario: _0500001 check preparation
	When check preparation	

Scenario: _050001 create Cash receipt based on Sales invoice
	* Open list form Sales invoice and select SI №1
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'                          |
			| '$$NumberSalesInvoice024001$$'    |
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
	* Create and filling in Cash receipt
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'               | 'Total amount'   | 'Payer'               | 'Basis document'           | 'Planning transaction basis'    |
			| 'Ferron BP'   | 'Basic Partner terms, TRY'   | '4 350,00'       | 'Company Ferron BP'   | '$$SalesInvoice024001$$'   | ''                              |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'    |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '744,72'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '4 350'     |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '4 350'     |
		And I close current window	
	* Check account selection and saving 
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Payment from customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'               | 'Total amount'   | 'Payer'               | 'Basis document'           | 'Planning transaction basis'    |
			| 'Ferron BP'   | 'Basic Partner terms, TRY'   | '4 350,00'       | 'Company Ferron BP'   | '$$SalesInvoice024001$$'   | ''                              |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'    |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '744,72'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '4 350'     |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '4 350'     |
		And I close current window		
		Then the form attribute named "PaymentListTotalTotalAmount" became equal to "4 350,00"
	* Change of Partner term and basis document
		And I select current line in "PaymentList" table
		And I activate "Partner term" field in "PaymentList" table
		And I click choice button of "Partner term" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I go to line in "List" table
			| 'Company'        | 'Amount'      | 'Legal name'          | 'Partner'      |
			| 'Main Company'   | '11 099,93'   | 'Company Ferron BP'   | 'Ferron BP'    |
		And I click "Select" button
	* Change in payment amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'     | 'Partner term'                       | 'Total amount'   | 'Payer'               | 'Basis document'            |
			| 'Ferron BP'   | 'Basic Partner terms, without VAT'   | '20 000,00'      | 'Company Ferron BP'   | '$$SalesInvoice024008$$'    |
		And I close all client application windows
	

Scenario: _050002 check that the amount does not change when select basis document in Cash receipt
	And I close all client application windows
	* Open CR and filling main info
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Cash account" drop-down list by "Cash desk №2" string
		And I select from "Transaction type" drop-down list by "Payment from customer" string
		And I select from the drop-down list named "Currency" by "Turkish lira" string
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
	


Scenario: _0500011 create Cash receipt (independently)
	* Create Cash receipt in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code    | Description      |
				| TRY     | Turkish lira     |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №1     |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '4 350,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '4 350,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I select current line in "List" table
			And I finish line editing in "PaymentList" table		
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
		And I delete "$$NumberCashReceipt0500011$$" variable
		And I delete "$$CashReceipt0500011$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0500011$$"
		And I save the window as "$$CashReceipt0500011$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashReceipt0500011$$'    |
	* Create Cash receipt in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code     |
				| USD      |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №1     |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
					| 'Description'                   |
					| 'Basic Partner terms, TRY'      |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '4 250,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'      | 'Company'         | 'Legal name'           | 'Partner'       |
				| '4 250,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I select current line in "List" table
			And I finish line editing in "PaymentList" table
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "100,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt0500012$$" variable
		And I delete "$$CashReceipt0500012$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0500012$$"
		And I save the window as "$$CashReceipt0500012$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashReceipt0500012$$'    |
	* Create Cash receipt in Euro for Ferron BP (Sales invoice in USD)
		When create Sales invoice for Ferron BP in USD
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №2     |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code    | Description     |
				| EUR     | Euro            |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
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
		And I delete "$$NumberCashReceipt0500013$$" variable
		And I delete "$$CashReceipt0500013$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0500013$$"
		And I save the window as "$$CashReceipt0500013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashReceipt0500013$$'    |


Scenario: _0500012 check form for select basis document	
		And I close all client application windows
	* Create Cash receipt in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment from customer" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Code    | Description      |
				| TRY     | Turkish lira     |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №1     |
			And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
		* Check forms DocumentsForIncomingPayment (current time)
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And "List" table contains lines
				| 'Document'            | 'Company'         | 'Partner'      | 'Amount'      | 'Legal name'           | 'Partner term'                | 'Currency'     |
				| 'Sales invoice 1*'    | 'Main Company'    | 'Ferron BP'    | '3 687,25'    | 'Company Ferron BP'    | 'Basic Partner terms, TRY'    | 'TRY'          |
			And I click "Select" button
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I input "100,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Code'    | 'Description'     |
				| '50'      | 'Ferron BP'       |
			And I select current line in "List" table
			And I activate "Partner term" field in "PaymentList" table
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                  |
				| 'Basic Partner terms, TRY'     |
			And I select current line in "List" table
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And "List" table contains lines
				| 'Document'            | 'Company'         | 'Partner'      | 'Amount'      | 'Legal name'           | 'Partner term'                | 'Currency'     |
				| 'Sales invoice 1*'    | 'Main Company'    | 'Ferron BP'    | '3 587,25'    | 'Company Ferron BP'    | 'Basic Partner terms, TRY'    | 'TRY'          |
			And I close current window
		* Check forms DocumentsForIncomingPayment (by document date)
			And I input "{CurrentDate() - 86401}" text in the field named "Date"
			And I move to "Payments" tab
			And I go to line in "PaymentList" table
				| '#'    | 'Partner'      | 'Partner term'                | 'Payer'                 |
				| '2'    | 'Ferron BP'    | 'Basic Partner terms, TRY'    | 'Company Ferron BP'     |
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I change "Status" radio button value to "By document date"
			Then the number of "List" table lines is "равно" 0
			And I change "Status" radio button value to "Current time"
			Then the number of "List" table lines is "равно" 0
			And I close current window
		* Check forms DocumentsForIncomingPayment by time
			And I input "{CurrentDate()}" text in the field named "Date"
			And I move to "Payments" tab
			And I go to line in "PaymentList" table
				| '#'    | 'Partner'      | 'Partner term'                | 'Payer'                 |
				| '2'    | 'Ferron BP'    | 'Basic Partner terms, TRY'    | 'Company Ferron BP'     |
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And "List" table contains lines
				| 'Document'            | 'Company'         | 'Partner'      | 'Amount'      | 'Legal name'           | 'Partner term'                | 'Currency'     |
				| 'Sales invoice 1*'    | 'Main Company'    | 'Ferron BP'    | '3 587,25'    | 'Company Ferron BP'    | 'Basic Partner terms, TRY'    | 'TRY'          |
			And I close current window
		And I close all client application windows
		
		

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

Scenario: _050006 check the choice of transaction type in the document Cash receipt
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

Scenario: _050009 create Cash receipt based on Purchase return
	And I close all client application windows
	* Select PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '24.03.2021 16:08:15'   | '351'       |
		And I select current line in "List" table
		And I click "Cash receipt" button
	* Check creation
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return from vendor   Posting status: New   "
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
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| #  | Partner  | Total amount  | Payer            | Basis document  | Planning transaction basis   |
		| 1  | Kalipso  | ''            | Company Kalipso  | ''              | ''                           |



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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I activate "Amount exchange" field in "PaymentList" table
		And I input "2 000,00" text in "Amount exchange" field of "PaymentList" table
		And "PaymentList" table contains lines
			| '#'   | 'Partner'   | 'Total amount'   | 'Amount exchange'   | 'Planning transaction basis'    |
			| '1'   | ''          | '100,00'         | '2 000,00'          | ''                              |



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
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payer" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
		| '#'  | 'Total amount'  | 'Planning transaction basis'   |
		| '1'  | '100,00'        | ''                             |




Scenario: _050016 check connection to CashReceipt report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashReceipt"
	* Form report Related documents
		And I go to line in "List" table
		| Number                         |
		| $$NumberCashReceipt0500011$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

Scenario: _050017 check selection form (Payment by documents) in CR
	And I close all client application windows
	* Open CR
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Cash account" drop-down list by "Cash desk №2" string
		And I select from "Transaction type" drop-down list by "Payment from customer" string
		And I select from the drop-down list named "Currency" by "Turkish lira" string
	* Check filter by Branch
		* Without branch
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| 'Document'                                   | 'Partner'   | 'Partner term'                     | 'Legal name'        | 'Legal name contract' | 'Order'                                   | 'Project' | 'Amount'    | 'Payment' |
				| 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Lunch'     | 'Basic Partner terms, TRY'         | 'Company Lunch'     | ''                    | 'Sales order 6 dated 04.09.2023 13:03:16' | ''        | '2 600,00'  | ''        |
				| 'Sales invoice 16 dated 04.09.2023 13:04:13' | 'Lunch'     | 'Basic Partner terms, TRY'         | 'Company Lunch'     | ''                    | 'Sales order 7 dated 04.09.2023 13:03:26' | ''        | '2 600,00'  | ''        |
				| '$$SalesInvoice024001$$'                     | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$'                    | ''        | '3 687,25'  | ''        |
				| '$$SalesInvoice024008$$'                     | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$'                    | ''        | '11 099,93' | ''        |
			And I close current window
		* With branch
			And I move to "Other" tab
			And I select from the drop-down list named "Branch" by "Distribution department" string
			And I move to "Payments" tab
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| 'Document'                                   | 'Partner'  | 'Partner term'             | 'Legal name'       | 'Legal name contract' | 'Order' | 'Project' | 'Amount'    | 'Payment' |
				| 'Sales invoice 14 dated 16.02.2021 12:14:54' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Company Lomaniti' | ''                    | ''      | ''        | '12 400,00' | ''        |
				| 'Sales invoice 15 dated 12.04.2021 12:00:01' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Company Lomaniti' | ''                    | ''      | ''        | '20 000,00' | ''        |
	* Allocation check	(one partner)
		And I input "10 000,00" text in the field named "Amount"
		And I click the button named "Calculate"
		And "Documents" table became equal
			| 'Document'                                   | 'Partner'  | 'Partner term'             | 'Legal name'       | 'Legal name contract' | 'Order' | 'Project' | 'Amount'    | 'Payment'   |
			| 'Sales invoice 14 dated 16.02.2021 12:14:54' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Company Lomaniti' | ''                    | ''      | ''        | '12 400,00' | '10 000,00' |
			| 'Sales invoice 15 dated 12.04.2021 12:00:01' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Company Lomaniti' | ''                    | ''      | ''        | '20 000,00' | ''          |
		* Amount more then invoice sum
			And I input "35 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			And "Documents" table became equal
				| 'Document'                                   | 'Partner'  | 'Partner term'             | 'Legal name'       | 'Legal name contract' | 'Order' | 'Project' | 'Amount'    | 'Payment'   |
				| 'Sales invoice 14 dated 16.02.2021 12:14:54' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Company Lomaniti' | ''                    | ''      | ''        | '12 400,00' | '12 400,00' |
				| 'Sales invoice 15 dated 12.04.2021 12:00:01' | 'Lomaniti' | 'Basic Partner terms, TRY' | 'Company Lomaniti' | ''                    | ''      | ''        | '20 000,00' | '20 000,00' |
			And I click "Ok" button
			And I finish line editing in "PaymentList" table
			And "PaymentList" table became equal
				| '#' | 'Partner'  | 'Payer'            | 'Partner term'             | 'Legal name contract' | 'Basis document'                             | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
				| '1' | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | ''                    | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''        | ''      | '12 400,00'    | ''                        | ''                 | ''                           |
				| '2' | 'Lomaniti' | 'Company Lomaniti' | 'Basic Partner terms, TRY' | ''                    | 'Sales invoice 15 dated 12.04.2021 12:00:01' | ''        | ''      | '20 000,00'    | ''                        | ''                 | ''                           |
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
				| '$$SalesInvoice024001$$'                     | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$'                    | ''        | '3 687,25'  | ''         |
				| '$$SalesInvoice024008$$'                     | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$'                    | ''        | '11 099,93' | ''         |
		* Check fifo allocation
			Then "Payment by documents" window is opened
			And I select from the drop-down list named "FilterPartner" by "Ferron BP" string
			And I input "5 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			Then the form attribute named "FilterPartner" became equal to "Ferron BP"
			And "Documents" table became equal
				| 'Document'               | 'Partner'   | 'Partner term'                     | 'Legal name'        | 'Legal name contract' | 'Order'                | 'Project' | 'Amount'    | 'Payment'  |
				| '$$SalesInvoice024001$$' | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$' | ''        | '3 687,25'  | '3 687,25' |
				| '$$SalesInvoice024008$$' | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$' | ''        | '11 099,93' | '1 312,75' |
			And I click "Ok" button
			And "PaymentList" table became equal
				| '#' | 'Partner'   | 'Payer'             | 'Partner term'                     | 'Legal name contract' | 'Basis document'                             | 'Project' | 'Order'                | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
				| '1' | 'Lomaniti'  | 'Company Lomaniti'  | 'Basic Partner terms, TRY'         | ''                    | 'Sales invoice 14 dated 16.02.2021 12:14:54' | ''        | ''                     | '12 400,00'    | ''                        | ''                 | ''                           |
				| '2' | 'Lomaniti'  | 'Company Lomaniti'  | 'Basic Partner terms, TRY'         | ''                    | 'Sales invoice 15 dated 12.04.2021 12:00:01' | ''        | ''                     | '20 000,00'    | ''                        | ''                 | ''                           |
				| '3' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY'         | ''                    | '$$SalesInvoice024001$$'                     | ''        | '$$SalesOrder023001$$' | '3 687,25'     | ''                        | ''                 | ''                           |
				| '4' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, without VAT' | ''                    | '$$SalesInvoice024008$$'                     | ''        | '$$SalesOrder023005$$' | '1 312,75'       | ''                        | ''                 | ''                           |
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table does not contain lines
				| 'Document'               | 'Partner'   | 'Partner term'                     | 'Legal name'        | 'Legal name contract' | 'Order'                | 'Project' | 'Amount'    |
				| '$$SalesInvoice024001$$' | 'Ferron BP' | 'Basic Partner terms, TRY'         | 'Company Ferron BP' | ''                    | '$$SalesOrder023001$$' | ''        | '3 687,25'  |
				| '$$SalesInvoice024008$$' | 'Ferron BP' | 'Basic Partner terms, without VAT' | 'Company Ferron BP' | ''                    | '$$SalesOrder023005$$' | ''        | '11 099,93' |				
		And I close all client application windows

Scenario: _050018 check amount when create CR based on SI (partner term - by documents)
	And I close all client application windows
	* Select SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Amount'   | 'Number'                       | 'Partner'   |
			| '4 350,00' | '$$NumberSalesInvoice024001$$' | 'Ferron BP' |
	* Create Cash receipt
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
	* Check amount (document balance)
		And "PaymentList" table became equal
			| '#' | 'Partner'   | 'Payer'             | 'Partner term'             | 'Legal name contract' | 'Basis document'         | 'Project' | 'Order'                | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | ''                    | '$$SalesInvoice024001$$' | ''        | '$$SalesOrder023001$$' | '3 687,25'     | ''                        | ''                 | ''                           |
	And I close all client application windows
	

Scenario: _050019 check amount when create CR based on SI (partner term - by partner terms)
	And I close all client application windows
	* Select two SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Amount'   | 'Legal name'      |
			| '1 000,00' | 'Company Kalipso' |
		And I move one line down in "List" table and select line
	* Create Cash receipt
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
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
	* Create Cash receipt
		And I click the button named "FormDocumentCashReceiptGenerateCashReceipt"
	* Check amount (documents amount )
		And "PaymentList" table became equal
			| '#' | 'Partner'         | 'Payer'           | 'Partner term'             | 'Legal name contract' | 'Basis document' | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'Partner Kalipso' | 'Company Kalipso' | 'Partner Kalipso Customer' | ''                    | ''               | ''        | ''      | '1 000,00'     | ''                        | ''                 | ''                           |
	And I close all client application windows	

Scenario: _050020 create Cash receipt with transaction type Other partner
	And I close all client application windows
	* Open CR
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Filling main details
		And I select "Other partner" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "CashAccount" by "Cash desk №3" string
		And I select from the drop-down list named "Currency" by "Turkish lira" string
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
		Then the form attribute named "CashAccount" became equal to "Cash desk №3"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'       | 'Payer'         | 'Partner term' | 'Legal name contract' | 'Total amount' | 'Financial movement type' | 'Cash flow center'        |
			| '1' | 'Tax authority' | 'Tax authority' | 'Tax'          | ''                    | '100,00'       | 'Movement type 1'         | 'Distribution department' |		
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "TransactionType" became equal to "Other partner"
		And I save the value of "Number" field as "NumberCashReceipt052023"
		And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                        |
				| '$NumberCashReceipt052023$'     |			