#language: en
@tree
@Positive
@BankCashDocuments

Feature: create Cash payment

As a cashier
//I want to pay cash
//In order to record the fact of payment

Background:
	Given I launch TestClient opening script or connect the existing one

# The currency of reports is lira
# CashBankDocFilters export scenarios

	
Scenario: _051001 preparation (Cash payment)
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
		When Create catalog Partners objects
		When Create catalog ExpenseAndRevenueTypes objects
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
	* Check or create PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseOrder017001$$" |
			When create PurchaseOrder017001
	* Check or create PurchaseInvoice018001
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice018001$$" |
			When create PurchaseInvoice018001 based on PurchaseOrder017001
	* Check or create PurchaseInvoice29604
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		If "List" table does not contain lines Then
				| "Number" |
				| "$$NumberPurchaseInvoice29604$$" |
			When create a purchase invoice for the purchase of sets and dimensional grids at the tore 02
	When Create document SalesReturn objects (advance, customers)
	And I execute 1C:Enterprise script at server
 			| "Documents.SalesReturn.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |



Scenario: _051001 create Cash payment based on Purchase invoice
	* Open list form Purchase invoice and select PI №1
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseInvoice018001$$'      |
		And I click the button named "FormDocumentCashPaymentGenerateCashPayment"
	* Create and filling in Purchase invoice
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Total amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '137 000,00' | '$$PurchaseInvoice018001$$' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'    |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '23 454,40' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '137 000'   |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '137 000'   |
		And I close current window
	* Data overflow check
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №2"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Total amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '137 000,00' | '$$PurchaseInvoice018001$$' |
		And in the table "PaymentList" I click "Edit currencies" button
		And "CurrenciesTable" table became equal
			| 'Movement type'      | 'Type'         | 'To'  | 'From' | 'Multiplicity' | 'Rate'   | 'Amount'    |
			| 'Reporting currency' | 'Reporting'    | 'USD' | 'TRY'  | '1'            | '0,1712' | '23 454,40' |
			| 'Local currency'     | 'Legal'        | 'TRY' | 'TRY'  | '1'            | '1'      | '137 000'   |
			| 'TRY'                | 'Partner term' | 'TRY' | 'TRY'  | '1'            | '1'      | '137 000'   |
		And I close current window	
	* Check calculation Document amount
		Then the form attribute named "DocumentAmount" became equal to "137 000,00"
	* Change in basis document
		And I select current line in "PaymentList" table
		And I click choice button of "Basis document" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Document'        |
			| '$$PurchaseInvoice29604$$'      |
		And I click "Select" button
		And in "PaymentList" table I move to the next cell
	* Change in payment amount
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "20 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And "PaymentList" table contains lines
			| 'Partner'   | 'Payee'             | 'Partner term'          | 'Total amount'     | 'Basis document'      |
			| 'Ferron BP' | 'Company Ferron BP' | 'Vendor Ferron, TRY' | '20 000,00' | '$$PurchaseInvoice29604$$' |
	And I close all client application windows




Scenario: _051001 create Cash payment (independently)
	* Create Cash payment in lire for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description  |
				| TRY  | Turkish lira |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
			| 'Amount'     | 'Company'      | 'Legal name'        | 'Partner'   |
			| '137 000,00' | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
		* Filling in amount in a tabular part
			And I activate "Total amount" field in "PaymentList" table
			And I input "1000,00" text in "Total amount" field of "PaymentList" table
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
		And I delete "$$NumberCashPayment0510011$$" variable
		And I delete "$$CashPayment0510011$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0510011$$"
		And I save the window as "$$CashPayment0510011$$"
		And I click the button named "FormPostAndClose"
		* Check creation a Cash payment
			And "List" table contains lines
			| 'Number' |
			|  '$$NumberCashPayment0510011$$'    | 
	* Create Cash payment in USD for Ferron BP (Sales invoice in lire)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
			And I click Select button of "Cash account" field
			And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
			And I select current line in "List" table
			And I click Select button of "Currency" field
			And I go to line in "List" table
				| Code | Description     |
				| USD  | American dollar |
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
		* Filling in basis documents in a tabular part
			And I finish line editing in "PaymentList" table
			And I activate "Basis document" field in "PaymentList" table
			And I select current line in "PaymentList" table
			And I go to line in "List" table
			| 'Amount' | 'Company'      | 'Legal name'        | 'Partner'   |
			| '136 000,00'       | 'Main Company' | 'Company Ferron BP' | 'Ferron BP' |
			And I click "Select" button
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
			| 'Number' |
			| '$$NumberCashPayment0510012$$'    |
	* Create Cash payment in Euro for Ferron BP (Partner term in USD)
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
		* Filling in the details of the document
			And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
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
			And I click "Select" button
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		* Filling in a partner in a tabular part
			And I activate "Partner" field in "PaymentList" table
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click choice button of "Payee" attribute in "PaymentList" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
		* Filling in an Partner term
			And I click choice button of "Partner term" attribute in "PaymentList" table
			And I go to line in "List" table
					| 'Description'           |
					| 'Vendor Ferron, USD' |
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
			| 'Number' |
			| '$$NumberCashPayment0510013$$'    |	
	
	

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
		And I select "Payment to the vendor" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I click the button named "FormChoose"
		And I click Select button of "Cash account" field
		And I go to line in "List" table
				| Description    |
				| Cash desk №1 |
		And I select current line in "List" table
		Then the form attribute named "CashAccount" became equal to "Cash desk №1"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Payment to the vendor"
	* Filling in partner and legal name
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description |
			| Ferron BP   |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And "List" table contains lines
			| Description       |
			| Company Ferron BP |
		And I select current line in "List" table
		And "PaymentList" table contains lines
			| Partner   | Payee             |
			| Ferron BP | Company Ferron BP |
	When check the filter on the basis documents in the payment documents

Scenario: _051009 create Cash payment based on Sales return
	And I close all client application windows
	* Select SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Date'                | 'Number' |
			| '27.01.2021 19:50:46' | '12'     |
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
			| '#' | 'Partner'   | 'Payee'             | 'Partner term'             | 'Legal name contract' | 'Basis document'                            | 'Total amount' | 'Financial movement type' | 'Planning transaction basis' |
			| '1' | 'Ferron BP' | 'Company Ferron BP' | 'Basic Partner terms, TRY' | ''                    | 'Sales return 12 dated 27.01.2021 19:50:46' | '500,00'       | ''                        | ''                           |
		
		Then the form attribute named "Branch" became equal to "Distribution department"
		And the editing text of form attribute named "DocumentAmount" became equal to "500,00"
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
			| Description  |
			| Kalipso |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| # | Partner | Total Amount | Payee              | Basis document | Planning transaction basis |
		| 1 | Kalipso | ''     | Company Kalipso    | ''             | ''                        |



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
			| Description  |
			| Anna Petrova |
		And I select current line in "List" table
		And "PaymentList" table contains lines
		| # | Partner      | Total amount| Planning transaction basis |
		| 1 | Anna Petrova | ''    | ''                        |


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
		| # | 'Total amount'    | Planning transaction basis |
		| 1 | '100,00'    | ''                        |


Scenario: _300512 check connection to CashPayment report "Related documents"
	Given I open hyperlink "e1cib/list/Document.CashPayment"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberCashPayment0510011$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows
