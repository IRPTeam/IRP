#language: en
@tree
@Positive
@BankCashDocuments

Feature: create Cash payment

As a cashier
//I want to pay cash
//In order to record the fact of payment


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira
# CashBankDocFilters export scenarios

	
Scenario: _051001 preparation (Cash payment)
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
		When Create catalog Partners objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create information register Taxes records (VAT)
		When Create catalog Partners, Companies, Agreements for Tax authority
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


Scenario: _0510011 check preparation
	When check preparation

Scenario: _051001 create Cash payment based on Purchase invoice
	* Open list form Purchase invoice and select PI №1
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number'                             |
			| '$$NumberPurchaseInvoice018001$$'    |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Create and filling in Purchase invoice
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Payee'               | 'Partner term'         | 'Total amount'   | 'Basis document'               |
			| 'Ferron BP'   | 'Company Ferron BP'   | 'Vendor Ferron, TRY'   | '137 000,00'     | '$$PurchaseInvoice018001$$'    |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '23 454,40'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
		And I close current window
	* Data overflow check
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №2'    |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And "PaymentList" table contains lines
			| 'Partner'     | 'Payee'               | 'Partner term'         | 'Total amount'   | 'Basis document'               |
			| 'Ferron BP'   | 'Company Ferron BP'   | 'Vendor Ferron, TRY'   | '137 000,00'     | '$$PurchaseInvoice018001$$'    |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'        | 'Type'           | 'To'    | 'From'   | 'Multiplicity'   | 'Rate'     | 'Amount'       |
			| 'Reporting currency'   | 'Reporting'      | 'USD'   | 'TRY'    | '1'              | '0,171200'   | '23 454,40'    |
			| 'Local currency'       | 'Legal'          | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
			| 'TRY'                  | 'Partner term'   | 'TRY'   | 'TRY'    | '1'              | '1'        | '137 000'      |
		And I close current window	
	* Check calculation Document amount
		Then the form attribute named "PaymentListTotalTotalAmount" became equal to "137 000,00"
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


Scenario: _051002 check that the amount does not change when select basis document in Cash payment
	And I close all client application windows
	* Open CP and filling main info
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Cash account" drop-down list by "Cash desk №2" string
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
			| 'Main Company'   | '137 000,00'  | 'Company Ferron BP'   | 'Ferron BP'    |
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

Scenario: _0510011 create Cash payment (independently)
	* Create Cash payment in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №1     |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code    | Description      |
				| TRY     | Turkish lira     |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'       | 'Company'        | 'Legal name'          | 'Partner'      |
				| '137 000,00'   | 'Main Company'   | 'Company Ferron BP'   | 'Ferron BP'    |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'       | 'Company'        | 'Legal name'          | 'Partner'      |
				| '137 000,00'   | 'Main Company'   | 'Company Ferron BP'   | 'Ferron BP'    |
			And I select current line in "List" table
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
		And I delete "$$NumberCashPayment0510011$$" variable
		And I delete "$$CashPayment0510011$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510011$$"
		And I save the window as "$$CashPayment0510011$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash payment
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashPayment0510011$$'    |
	* Create Cash payment in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description      |
				| Main Company     |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description      |
				| Cash desk №1     |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code    | Description         |
				| USD     | American dollar     |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'       | 'Company'        | 'Legal name'          | 'Partner'      |
				| '136 000,00'   | 'Main Company'   | 'Company Ferron BP'   | 'Ferron BP'    |
			And I click "Select" button
			And I click choice button of "Order" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Amount'       | 'Company'        | 'Legal name'          | 'Partner'      |
				| '136 000,00'   | 'Main Company'   | 'Company Ferron BP'   | 'Ferron BP'    |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "20,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0510012$$" variable
		And I delete "$$CashPayment0510012$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510012$$"
		And I save the window as "$$CashPayment0510012$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash receipt
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashPayment0510012$$'    |
	* Create Cash payment in Euro for Ferron BP (Partner term in USD)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
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
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
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
					| 'Vendor Ferron, USD'      |
			And I select current line in "List" table
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "150,00" text in "Total amount" field of "PaymentList" table
			And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0510013$$" variable
		And I delete "$$CashPayment0510013$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510013$$"
		And I save the window as "$$CashPayment0510013$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash payment
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashPayment0510013$$'    |
	
Scenario: _0510012 check form for select basis document	
		And I close all client application windows
	* Create Cash payment in lire for Ferron BP (Purchase invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
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
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description           |
				| Company Ferron BP     |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'            |
				| 'Vendor Ferron, TRY'     |
			And I select current line in "List" table
		* Check forms DocumentsForOutgoingPayment (current time)
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And "List" table contains lines
				| 'Document'               | 'Company'         | 'Partner'      | 'Amount'        | 'Legal name'           | 'Partner term'          | 'Currency'     |
				| 'Purchase invoice 1*'    | 'Main Company'    | 'Ferron BP'    | '136 000,00'    | 'Company Ferron BP'    | 'Vendor Ferron, TRY'    | 'TRY'          |
				| 'Purchase invoice 2*'    | 'Main Company'    | 'Ferron BP'    | '13 000,00'     | 'Company Ferron BP'    | 'Vendor Ferron, TRY'    | 'TRY'          |
			And I go to line in "List" table
				| 'Amount'         |
				| '136 000,00'     |
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
				| 'Description'            |
				| 'Vendor Ferron, TRY'     |
			And I select current line in "List" table
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And "List" table contains lines
				| 'Document'               | 'Company'         | 'Partner'      | 'Amount'        | 'Legal name'           | 'Partner term'          | 'Currency'     |
				| 'Purchase invoice 1*'    | 'Main Company'    | 'Ferron BP'    | '135 900,00'    | 'Company Ferron BP'    | 'Vendor Ferron, TRY'    | 'TRY'          |
				| 'Purchase invoice 2*'    | 'Main Company'    | 'Ferron BP'    | '13 000,00'     | 'Company Ferron BP'    | 'Vendor Ferron, TRY'    | 'TRY'          |
			And I close current window
		* Check forms DocumentsForIncomingPayment
			And I input "{CurrentDate()}" text in the field named "Date"
			And I move to "Payments" tab
			And I go to line in "PaymentList" table
				| '#'    | 'Partner'      | 'Partner term'          | 'Payee'                 |
				| '2'    | 'Ferron BP'    | 'Vendor Ferron, TRY'    | 'Company Ferron BP'     |
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And "List" table contains lines
				| 'Document'               | 'Company'         | 'Partner'      | 'Amount'        | 'Legal name'           | 'Partner term'          | 'Currency'     |
				| 'Purchase invoice 1*'    | 'Main Company'    | 'Ferron BP'    | '135 900,00'    | 'Company Ferron BP'    | 'Vendor Ferron, TRY'    | 'TRY'          |
				| 'Purchase invoice 2*'    | 'Main Company'    | 'Ferron BP'    | '13 000,00'     | 'Company Ferron BP'    | 'Vendor Ferron, TRY'    | 'TRY'          |
			And I close current window
			And I input "{CurrentDate() - 86401}" text in the field named "Date"
			And I move to "Payments" tab
			And I go to line in "PaymentList" table
				| '#' | 'Partner'   | 'Partner term'       | 'Payee'             |
				| '2' | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' |
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			Then the number of "List" table lines is "равно" 0
		And I close all client application windows	

# Filters

Scenario: _051002 filter check by own companies in the document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the filter by own company


Scenario: _051003 cash filter check (bank selection not available) in the document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the filter by cash account (bank account selection is not available)

Scenario: _051004 check input Description in the documentCash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check filling in Description

Scenario: _051005 check the choice of transaction type in the document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the choice of type of operation in the payment documents

Scenario: _051006 check legal name filter in tabular part in document Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the legal name filter in the tabular part of the payment documents

Scenario: _051007 check partner filter in tabular part in document Cash payment
	# when selecting a legal name, only its partners should be available on the partner selection list
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	When check the partner filter in the tabular part of the payment documents.
	
Scenario: _051008 check basis document filter in Cash payment
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	* Filling in the details of the document
		And I select "Return to customer" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I click the button named "FormChoose"
		And I click Select button of "Cash account" field
		And I go to line in "List" table
				| Description      |
				| Cash desk №1     |
		And I select current line in "List" table
		Then the form attribute named "CashAccount" became equal to "Cash desk №1"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Return to customer"
	* Filling in partner and legal name
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And "List" table contains lines
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| Partner     | Payee                |
			| Ferron BP   | Company Ferron BP    |
	When check the filter on the basis documents in the payment documents

Scenario: _051009 create Cash payment based on Sales return
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Date'                  | 'Number'    |
			| '27.01.2021 19:50:46'   | '12'        |
		And I select current line in "List" table
		And I click "Cash payment" button
	* Check creation
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return to customer   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Currency: TRY   Transaction type: Return to customer   "
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to ""
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


Scenario: _051010 check currency selection in Cash payment document in case the currency is specified in the account
# the choice is not available
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	When check the choice of currency in the cash payment document if the currency is indicated in the account




Scenario: _051012 check the display of details on the form Cash payment with the type of operation Payment to the vendor
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Kalipso        |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| #  | Partner  | Total Amount  | Payee            | Basis document  | Planning transaction basis   |
		| 1  | Kalipso  | ''            | Company Kalipso  | ''              | ''                           |



Scenario: _051013 check the display of details on the form Cash payment with the type of operation Currency exchange
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	And I select "Currency exchange" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Currency exchange"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description     |
			| Anna Petrova    |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| #  | Partner       | Total amount  | Planning transaction basis   |
		| 1  | Anna Petrova  | ''            | ''                           |


Scenario: _051014 check the display of details on the form Cash payment with the type of operation Cash transfer order
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	And I click the button named "FormCreate"
	And I select "Cash transfer order" exact value from "Transaction type" drop-down list
	* Then I check the display on the form of available fields
		And form attribute named "Company" is available
		And form attribute named "CashAccount" is available
		And form attribute named "Description" is available
		Then the form attribute named "TransactionType" became equal to "Cash transfer order"
		And form attribute named "Currency" is available
		And form attribute named "Date" is available
	* And I check the display of the tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I input "100,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		If "PaymentList" table does not contain column named "Payee" Then
		If "PaymentList" table does not contain column named "Partner" Then
		And "PaymentList" table contains lines
		| #  | 'Total amount'  | Planning transaction basis   |
		| 1  | '100,00'        | ''                           |


Scenario: _051015 check connection to CashPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number                         |
		| $$NumberCashPayment0510011$$   |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "* Related documents" window is opened
	And I close all client application windows

Scenario: _051017 check selection form (Payment by documents) in CP
	And I close all client application windows
	* Open CP
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from "Cash account" drop-down list by "Cash desk №2" string
		And I select from "Transaction type" drop-down list by "Payment to the vendor" string
		And I select from the drop-down list named "Currency" by "Turkish lira" string
	* Check filter by Branch
		* Without branch
			And in the table "PaymentList" I click "Payment by documents" button
			And "Documents" table became equal
				| 'Document'                                       | 'Partner'   | 'Partner term'       | 'Legal name'        | 'Legal name contract' | 'Order'                   | 'Project' | 'Amount'     | 'Payment' |
				| 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Maxim'     | 'Partner term Maxim' | 'Company Maxim'     | ''                    | ''                        | ''        | '100,00'     | ''        |
				| '$$PurchaseInvoice018001$$'                      | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | '$$PurchaseOrder017001$$' | ''        | '136 000,00' | ''        |
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
				| 'Amount'     | 'Document'                  |
				| '136 000,00' | '$$PurchaseInvoice018001$$' |
			And I move one line down in "Documents" table and select line
			And I input "149 000,00" text in the field named "Amount"
			And I click the button named "Calculate"
			And "Documents" table became equal
				| 'Document'                                       | 'Partner'   | 'Partner term'       | 'Legal name'        | 'Legal name contract' | 'Order'                   | 'Project' | 'Amount'     | 'Payment'    |
				| 'Purchase invoice 125 dated 12.02.2021 12:00:00' | 'Maxim'     | 'Partner term Maxim' | 'Company Maxim'     | ''                    | ''                        | ''        | '100,00'     | '100,00'     |
				| '$$PurchaseInvoice018001$$'                      | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | '$$PurchaseOrder017001$$' | ''        | '136 000,00' | '136 000,00' |
				| '$$PurchaseInvoice29604$$'                       | 'Ferron BP' | 'Vendor Ferron, TRY' | 'Company Ferron BP' | ''                    | ''                        | ''        | '13 000,00'  | '12 900,00'  |
			And I click "Ok" button
			And "PaymentList" table became equal
				| 'Partner'   | 'Payee'             | 'Partner term'       | 'Legal name contract' | 'Basis document'                                 | 'Project' | 'Order'                                        | 'Total amount' |
				| 'Maxim'     | 'Company Maxim'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 126 dated 15.03.2021 12:00:00' | ''        | ''                                             | '190,00'       |
				| 'Maxim'     | 'Company Maxim'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 127 dated 28.04.2021 21:50:01' | ''        | ''                                             | '100,00'       |
				| 'Maxim'     | 'Company Aldis'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 194 dated 04.09.2023 13:50:38' | ''        | 'Purchase order 118 dated 04.09.2023 13:46:08' | '900,00'       |
				| 'Maxim'     | 'Company Aldis'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 194 dated 04.09.2023 13:50:38' | ''        | 'Purchase order 119 dated 04.09.2023 13:50:07' | '900,00'       |
				| 'Maxim'     | 'Company Maxim'     | 'Partner term Maxim' | ''                    | 'Purchase invoice 125 dated 12.02.2021 12:00:00' | ''        | ''                                             | '100,00'       |
				| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | ''                    | '$$PurchaseInvoice018001$$'                      | ''        | '$$PurchaseOrder017001$$'                      | '136 000,00'   |
				| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | ''                    | '$$PurchaseInvoice29604$$'                       | ''        | ''                                             | '12 900,00'    |
		And I close all client application windows

Scenario: _050018 check amount when create CP based on PI (partner term - by documents)
	And I close all client application windows
	* Select PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Amount'     | 'Number'                          | 'Partner'   |
			| '137 000,00' | '$$NumberPurchaseInvoice018001$$' | 'Ferron BP' |
	* Create Cash payment
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Check amount (document balance)
		And "PaymentList" table became equal
			| '#' | 'Partner'   | 'Payee'             | 'Partner term'       | 'Legal name contract' | 'Basis document'            | 'Project' | 'Order'                   | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | ''                    | '$$PurchaseInvoice018001$$' | ''        | '$$PurchaseOrder017001$$' | '136 000,00'   | ''                        | ''                 | ''                           |
	And I close all client application windows
	

Scenario: _050019 check amount when create CP based on PI (partner term - by partner terms)
	And I close all client application windows
	* Select two PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Amount' | 'Legal name' |
			| '190,00' | 'DFC'        |
		And I move one line down in "List" table and select line
	* Create Cash payment
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
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
	* Create Cash payment
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Check amount (documents amount )
		And "PaymentList" table became equal
			| '#' | 'Partner' | 'Payee' | 'Partner term'                | 'Legal name contract' | 'Basis document' | 'Project' | 'Order' | 'Total amount' | 'Financial movement type' | 'Cash flow center' | 'Planning transaction basis' |
			| '1' | 'DFC'     | 'DFC'   | 'DFC Vendor by Partner terms' | ''                    | ''               | ''        | ''      | '190,00'       | ''                        | ''                 | ''                           |
	And I close all client application windows		

Scenario: _050023 create Cash payment with transaction type Other partner
	And I close all client application windows
	* Open CP
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Filling main details
		And I select "Other partner" exact value from "Transaction type" drop-down list
		And I select from the drop-down list named "Company" by "Main Company" string
		And I select from the drop-down list named "CashAccount" by "Cash desk №4" string
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
		Then the form attribute named "CashAccount" became equal to "Cash desk №4"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'       | 'Payee'         | 'Partner term' | 'Legal name contract' | 'Total amount' | 'Financial movement type' | 'Cash flow center'        |
			| '1' | 'Tax authority' | 'Tax authority' | 'Tax'          | ''                    | '100,00'       | 'Movement type 1'         | 'Distribution department' |		
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "100,00"
		Then the form attribute named "TransactionType" became equal to "Other partner"
		And I save the value of "Number" field as "NumberCashPayment053023"
		And I click the button named "FormPostAndClose"
		* Check creation
			And "List" table contains lines
				| 'Number'                        |
				| '$NumberCashPayment053023$'     |		