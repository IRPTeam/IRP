#language: en
@tree
@Positive
@BankCashDocuments

Feature: create Bank payment


As an accountant
I want to pay by bank payment.
To close debts to partners


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira
# CashBankDocFilters export scenarios


	
Scenario: _053000 preparation (Bank payment)
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
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog CashAccounts objects (POS)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create information register Taxes records (VAT)
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number"                            |
				| "$$NumberPurchaseOrder017001$$"     |
			When create PurchaseOrder017001
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                              |
				| "$$NumberPurchaseInvoice018001$$"     |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice29604
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number"                             |
				| "$$NumberPurchaseInvoice29604$$"     |
			When create a purchase invoice for the purchase of sets and dimensional grids at the tore 02
	When Create document SalesReturn objects (advance, customers)
	And I execute 1C:Enterprise script at server
				| "Documents.SalesReturn.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"     |
	When Create document PurchaseInvoice objects (advance)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(120).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(121).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(122).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(123).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(124).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(126).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(127).GetObject().Write(DocumentWriteMode.Posting);"    |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(194).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _0530001 check preparation
	When check preparation

Scenario: _053001 create Bank payment based on Purchase invoice
	* Open list form Purchase invoice and select PI №1
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice018001$$'    |
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
	* Create and filling in Purchase invoice
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Payee'               | 'Partner term'         | 'Total amount'   | 'Basis document'               |
			| 'Ferron BP'   | 'Company Ferron BP'   | 'Vendor Ferron, TRY'   | '136 000,00'     | '$$PurchaseInvoice018001$$'    |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '23 283,20'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '136 000'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '136 000'      |
		And I close current window
	* Data overflow check
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'TRY'        | 'Bank account, TRY'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Payee'               | 'Partner term'         | 'Total amount'   | 'Basis document'               |
			| 'Ferron BP'   | 'Company Ferron BP'   | 'Vendor Ferron, TRY'   | '136 000,00'     | '$$PurchaseInvoice018001$$'    |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '23 283,20'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '136 000'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '136 000'      |
		And I close current window
	* Check calculation Document amount
		Then the form attribute named "PaymentListTotalTotalAmount" became equal to "136 000,00"
	* Change in basis document
		And I select current line in "PaymentList" table
		And I click choice button of "Basis document" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Document'                    |
			| '$$PurchaseInvoice29604$$'    |
		And I click "Select" button
		And in "PaymentList" table I move to the next cell
	* Change in payment amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'     | 'Payee'               | 'Partner term'         | 'Total amount'   | 'Basis document'              |
			| 'Ferron BP'   | 'Company Ferron BP'   | 'Vendor Ferron, TRY'   | '20 000,00'      | '$$PurchaseInvoice29604$$'    |
	And I close all client application windows

Scenario: _051002 check that the amount does not change when select basis document in Bank payment
	And I close all client application windows
	* Open BP and filling main info
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Account" drop-down list by "Bank account, TRY" string
		And I select from "Transaction type" drop-down list by "Payment from customer" string
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I select current line in "PaymentList" table
		And I select "Ferron BP" from "Partner" drop-down list by string in "PaymentList" table
		And I select "Company Ferron BP" from "Payee" drop-down list by string in "PaymentList" table
		And I select "Vendor Ferron, TRY" from "Partner term" drop-down list by string in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "5 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Reselect SI and check amount
		And I activate "Basis document" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I go to line in "List" table
			| 'Company'        | 'Amount'      | 'Legal name'          | 'Partner'      |
			| 'Main Company'   | '136 000,00'  | 'Company Ferron BP'   | 'Ferron BP'    |
		And I click "Select" button
		And "PaymentList" table contains lines
			| 'Partner'   | 'Partner term'       | 'Total amount' | 'Payee'             | 'Basis document'            |
			| 'Ferron BP' | 'Vendor Ferron, TRY' | '5 000,00'     | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' |
	// * Add one more line with the same invoice and check amount
	// 	And in the table "PaymentList" I click the button named "PaymentListAdd"
	// 	And I select current line in "PaymentList" table
	// 	And I select "Ferron BP" from "Partner" drop-down list by string in "PaymentList" table
	// 	And I select "Company Ferron BP" from "Payee" drop-down list by string in "PaymentList" table
	// 	And I select "Vendor Ferron, TRY" from "Partner term" drop-down list by string in "PaymentList" table
	// 	And I finish line editing in "PaymentList" table
	// 	And I activate "Basis document" field in "PaymentList" table
	// 	And I select current line in "PaymentList" table
	// 	And I go to line in "List" table
	// 		| 'Company'        | 'Amount'     | 'Legal name'          | 'Partner'      |
	// 		| 'Main Company'   | '132 000,00' | 'Company Ferron BP'   | 'Ferron BP'    |
	// 	And I click "Select" button
	// 	And "PaymentList" table contains lines
	// 		| 'Partner'   | 'Partner term'       | 'Total amount' | 'Payee'             | 'Basis document'            |
	// 		| 'Ferron BP' | 'Vendor Ferron, TRY' | '5 000,00'     | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' |
	// 		| 'Ferron BP' | 'Vendor Ferron, TRY' | '132 000,00'   | 'Company Ferron BP' | '$$PurchaseInvoice018001$$' |
	And I close all client application windows


Scenario: _0530011 create Bank payment (independently)
	* Create Bank payment in lire for Ferron BP (Purchase invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Select transaction type
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		* Filling in the details of the document
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
				| Description     |
				| Ferron BP       |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'             |
					| 'Vendor Ferron, TRY'      |
			And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Amount'        | 'Company'         | 'Legal name'           | 'Partner'       |
				| '136 000,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'       | 'Company'        | 'Legal name'          | 'Partner'      |
				| '136 000,00'   | 'Main Company'   | 'Company Ferron BP'   | 'Ferron BP'    |
			And I select current line in "List" table
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "1000,00" text in "Total amount" field of "PaymentList" table
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
		And I delete "$$NumberBankPayment0530011$$" variable
		And I delete "$$BankPayment0530011$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0530011$$"
		And I save the window as "$$BankPayment0530011$$"
		And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                           |
				| '$$NumberBankPayment0530011$$'     |
	* Create Bank payment in USD for Ferron BP (Purchase invoice in lire)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
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
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'             |
					| 'Vendor Ferron, TRY'      |
			And I select current line in "List" table
		# temporarily
		* Filling in basis documents in a tabular part
			# temporarily
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			# temporarily
			And I go to line in "List" table
				| 'Amount'        | 'Company'         | 'Legal name'           | 'Partner'       |
				| '135 000,00'    | 'Main Company'    | 'Company Ferron BP'    | 'Ferron BP'     |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'       | 'Company'        | 'Legal name'          | 'Partner'      |
				| '135 000,00'   | 'Main Company'   | 'Company Ferron BP'   | 'Ferron BP'    |
			And I select current line in "List" table
		# temporarily
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "20,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment0530012$$" variable
		And I delete "$$BankPayment0530012$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0530012$$"
		And I save the window as "$$BankPayment0530012$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
				| 'Number'                           |
				| '$$NumberBankPayment0530012$$'     |
	* Create Bank payment in Euro for Ferron BP (Purchase invoice in USD)
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
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
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Vendor Ferron, USD'     |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "150,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment0530013$$" variable
		And I delete "$$BankPayment0530013$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0530013$$"
		And I save the window as "$$BankPayment0530013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Bank payment
			And "List" table contains lines
				| 'Number'                           |
				| '$$NumberBankPayment0530013$$'     |



# Filters

Scenario: _053003 filter check by own companies in the document Bank payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the filter by own company

	

Scenario: _053004 check the filter by bank accounts (the choice of Cash/Bank accounts is not available) + filling in currency from the bank account in Bank payment document
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the filter for bank accounts (cash account selection is not available) + filling in currency from a bank account

Scenario: _053005 check input Description in the document Bank payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check filling in Description

Scenario: _053006 check the choice of transaction type in the document Bank payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the choice of type of operation in the payment documents
	

Scenario: _053007 check legal name filter in tabular part in document Bank payment
	# when selecting a partner, only its legal names should be available on the selection list
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the legal name filter in the tabular part of the payment documents
	


Scenario: _053008 check partner filter in tabular part in document Bank payment
	# when selecting a legal name, only its partners should be available on the partner selection list
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	When check the partner filter in the tabular part of the payment documents.
	
Scenario: _053009 create Bank payment based on Sales return
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '27.01.2021 19:50:46'   | '12'        |
		And I select current line in "List" table
		And I click "Bank payment" button
	* Check creation
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return to customer   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return to customer   "
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to ""
		Then the form attribute named "TransactionType" became equal to "Return to customer"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#'   | 'Partner'     | 'Payee'               | 'Partner term'               | 'Legal name contract'   | 'Basis document'                              | 'Total amount'   | 'Financial movement type'   | 'Planning transaction basis'    |
			| '1'   | 'Ferron BP'   | 'Company Ferron BP'   | 'Basic Partner terms, TRY'   | ''                      | 'Sales return 12 dated 27.01.2021 19:50:46'   | '500,00'         | ''                          | ''                              |
		
		Then the form attribute named "Branch" became equal to "Distribution department"
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "500,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	And I close all client application windows



# EndFilters

Scenario: _053011 check currency selection in Bank payment document in case the currency is specified in the account
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	When check the choice of currency in the bank payment document if the currency is indicated in the account




Scenario: _053013 check the display of details on the form Bank payment with the type of operation Payment to the vendor
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is unavailable
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| '#'   | Partner   | Total amount   | Payee             | Basis document   | Planning transaction basis    |
			| '1'   | Kalipso   | ''             | Company Kalipso   | ''               | ''                            |







Scenario: _053015 check the display of details on the form Bank payment with the type of operation Cash transfer
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "Account" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
		And form attribute named "TransitAccount" is unavailable
	* Check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payee" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
			| '#'   | 'Total amount'   | 'Planning transaction basis'    |
			| '1'   | '100,00'         | ''                              |


Scenario: _053018 check connection to BankPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number                         |
		| $$NumberBankPayment0530011$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows


Scenario: _053019 try post Bank payment with empty amount
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.BankPayment"
	And I click the button named "FormCreate"
	* Filling in the details of the document
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
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
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description     |
			| Company Kalipso |
		And I select current line in "List" table
	* Try post and check message
		And I click "Post" button
		Then there are lines in TestClient message log
			|'Fill total amount. Row: [1]'|
		And I close all client application windows

Scenario: _053020 check selection form (Payment by documents) in BP
	And I close all client application windows
	* Open BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Account" drop-down list by "Bank account, TRY" string
		And I select from "Transaction type" drop-down list by "Payment to the vendor" string
	* Check filter by Branch
		* Without branch
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| 'Document'                                       | 'Partner'   | 'Partner term'       | 'Legal name'        | 'Legal name contract' | 'Order'                   | 'Project' | 'Amount'     | 'Payment' |
				| 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Maxim'     | 'Partner term Maxim' | 'Company Maxim'     | ''                    | ''                        | ''        | '100,00'     | ''        |
				| '$$PurchaseInvoice018001$$'                      | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | '$$PurchaseOrder017001$$' | ''        | '135 000,00' | ''        |
				| '$$PurchaseInvoice29604$$'                       | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | ''                        | ''        | '13 000,00'  | ''        |
			And I close current window
		* With branch
			And I move to "Other" tab
			And I select from the drop-down list named "Branch" by "Front office" string
			And I move to "Payments" tab
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| 'Document'                                       | 'Partner' | 'Partner term'       | 'Legal name'    | 'Legal name contract' | 'Order'                                        | 'Project' | 'Amount' | 'Payment' |
				| 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'Maxim'   | 'Partner term Maxim' | 'Company Maxim' | ''                    | ''                                             | ''        | '190,00' | ''        |
				| 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Maxim'   | 'Partner term Maxim' | 'Company Maxim' | ''                    | ''                                             | ''        | '100,00' | ''        |
				| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Maxim'   | 'Partner term Maxim' | 'Company Aldis' | ''                    | 'Purchase order 118 dated 04.09.2023 13:46:08' | ''        | '900,00' | ''        |
				| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Maxim'   | 'Partner term Maxim' | 'Company Aldis' | ''                    | 'Purchase order 119 dated 04.09.2023 13:50:07' | ''        | '900,00' | ''        |
	* Allocation check	(one partner)
		And I input "2 000,00" text in the field named "Amount"
		And I click the button named "Calculate"
		And "Documents" table became equal
			| 'Document'                                       | 'Partner' | 'Partner term'       | 'Legal name'    | 'Legal name contract' | 'Order'                                        | 'Project' | 'Amount' | 'Payment' |
			| 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'Maxim'   | 'Partner term Maxim' | 'Company Maxim' | ''                    | ''                                             | ''        | '190,00' | '190,00'  |
			| 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Maxim'   | 'Partner term Maxim' | 'Company Maxim' | ''                    | ''                                             | ''        | '100,00' | '100,00'  |
			| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Maxim'   | 'Partner term Maxim' | 'Company Aldis' | ''                    | 'Purchase order 118 dated 04.09.2023 13:46:08' | ''        | '900,00' | '900,00'  |
			| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Maxim'   | 'Partner term Maxim' | 'Company Aldis' | ''                    | 'Purchase order 119 dated 04.09.2023 13:50:07' | ''        | '900,00' | '810,00'  |
		* Amount more then invoice sum
			And I input "5 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			And "Documents" table became equal
				| 'Document'                                       | 'Partner' | 'Partner term'       | 'Legal name'    | 'Legal name contract' | 'Order'                                        | 'Project' | 'Amount' | 'Payment' |
				| 'Purchase invoice 126 dated 15.03.2021 12:00:00' | 'Maxim'   | 'Partner term Maxim' | 'Company Maxim' | ''                    | ''                                             | ''        | '190,00' | '190,00'  |
				| 'Purchase invoice 127 dated 28.04.2021 21:50:01' | 'Maxim'   | 'Partner term Maxim' | 'Company Maxim' | ''                    | ''                                             | ''        | '100,00' | '100,00'  |
				| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Maxim'   | 'Partner term Maxim' | 'Company Aldis' | ''                    | 'Purchase order 118 dated 04.09.2023 13:46:08' | ''        | '900,00' | '900,00'  |
				| 'Purchase invoice 194 dated 04.09.2023 13:50:38' | 'Maxim'   | 'Partner term Maxim' | 'Company Aldis' | ''                    | 'Purchase order 119 dated 04.09.2023 13:50:07' | ''        | '900,00' | '900,00'  |
			And I click "Ok" button
			And I finish line editing in "PaymentList" table
			And "PaymentList" table became equal
				| '#' | 'Partner' | 'Payee'         | 'Partner term'       | 'Legal name contract' | 'Basis document'                                 | 'Project' | 'Order'                                        | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
				| '1' | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim' | ''                    | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''        | ''                                             | '190,00'       | ''                        | ''                 | ''                           |
				| '2' | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim' | ''                    | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''        | ''                                             | '100,00'       | ''                        | ''                 | ''                           |
				| '3' | 'Maxim'   | 'Company Aldis' | 'Partner term Maxim' | ''                    | 'Purchase invoice 194 dated 04.09.2023 13:50:38' | ''        | 'Purchase order 118 dated 04.09.2023 13:46:08' | '900,00'       | ''                        | ''                 | ''                           |
				| '4' | 'Maxim'   | 'Company Aldis' | 'Partner term Maxim' | ''                    | 'Purchase invoice 194 dated 04.09.2023 13:50:38' | ''        | 'Purchase order 119 dated 04.09.2023 13:50:07' | '900,00'       | ''                        | ''                 | ''                           |
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
				| 'Amount'     | 'Document'                                     |
				| '135 000,00' | '$$PurchaseInvoice018001$$' |
			And I move one line down in "Documents" table and select line
			And I input "146 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			And "Documents" table became equal
				| 'Document'                                       | 'Partner'   | 'Partner term'       | 'Legal name'        | 'Legal name contract' | 'Order'                   | 'Project' | 'Amount'     | 'Payment'    |
				| 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Maxim'     | 'Partner term Maxim' | 'Company Maxim'     | ''                    | ''                        | ''        | '100,00'     | ''           |
				| '$$PurchaseInvoice018001$$'                      | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | '$$PurchaseOrder017001$$' | ''        | '135 000,00' | '135 000,00' |
				| '$$PurchaseInvoice29604$$'                       | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | ''                        | ''        | '13 000,00'  | '11 000,00'  |
			And I click "Ok" button
			And "PaymentList" table became equal
				| 'Partner'   | 'Payee'             | 'Partner term'       | 'Legal name contract' | 'Basis document'                                 | 'Project' | 'Order'                                        | 'Total amount' |
				| 'Maxim'     | 'Company Maxim'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''        | ''                                             | '190,00'       |
				| 'Maxim'     | 'Company Maxim'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''        | ''                                             | '100,00'       |
				| 'Maxim'     | 'Company Aldis'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 194 dated 04.09.2023 13:50:38' | ''        | 'Purchase order 118 dated 04.09.2023 13:46:08' | '900,00'       |
				| 'Maxim'     | 'Company Aldis'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 194 dated 04.09.2023 13:50:38' | ''        | 'Purchase order 119 dated 04.09.2023 13:50:07' | '900,00'       |
				| 'Maxim'     | 'Company Maxim'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''        | ''                                             | '100,00'       |
				| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | ''                    | '$$PurchaseInvoice018001$$'                      | ''        | '$$PurchaseOrder017001$$'                      | '135 000,00'   |
				| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | ''                    | '$$PurchaseInvoice29604$$'                       | ''        | ''                                             | '10 900,00'    |
		And I close all client application windows

Scenario: _053021 check amount when create BP based on PI (partner term - by partner terms)
	And I close all client application windows
	* Select two PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Amount' | 'Legal name' |
			| '190,00' | 'DFC'        |
		And I move one line down in "List" table and select line
	* Create Bank payment
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
	* Check amount (documents amount )
		And "PaymentList" table became equal
			| '#' | 'Partner' | 'Payee' | 'Partner term'                | 'Legal name contract' | 'Basis document' | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'DFC'     | 'DFC'   | 'DFC Vendor by Partner terms' | ''                    | ''               | ''        | ''      | '390,00'       | ''                        | ''                 | ''                           |
	And I close all client application windows
	* Select one PI				
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Amount' | 'Legal name' |
			| '190,00' | 'DFC'        |
	* Create Bank payment
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
	* Check amount (documents amount )
		And "PaymentList" table became equal
			| '#' | 'Partner' | 'Payee' | 'Partner term'                | 'Legal name contract' | 'Basis document' | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'DFC'     | 'DFC'   | 'DFC Vendor by Partner terms' | ''                    | ''               | ''        | ''      | '190,00'       | ''                        | ''                 | ''                           |
	And I close all client application windows	