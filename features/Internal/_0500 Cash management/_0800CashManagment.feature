#language: en
@tree
@Positive
@CashManagement

Feature: expense and income planning


As a financier
I want to create documents Incoming payment order and Outgoing payment order
For expense and income planning

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



		
Scenario: _080000 preparation (Incoming payment order and Outgoing payment order)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
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
		When create catalog ExpenseAndRevenueTypes objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog PlanningPeriods objects
		When Create information register Taxes records (VAT)
	* Create Planning period
		Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
		And I click the button named "FormCreate"
		And I input "Begin of the next month" text in "Description" field
		And I input begin of the next month date in "Begin date" field
		Then "Planning period (create) *" window is opened
		And I set checkbox "Is financial"
		And I input begin of the next month date in "End date" field
		And I set checkbox "Is financial"
		And I click the button named "FormWriteAndClose"
		And "List" table contains lines
			| 'Description'                |
			| 'Begin of the next month'    |
		And I close all client application windows

Scenario: _0800001 check preparation
	When check preparation		
		

Scenario: _080001 create Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| Description    |
		| Main Company   |
	And I select current line in "List" table
	And I click Select button of "Account" field
	And I go to line in "List" table
		| Description         |
		| Bank account, USD   |
	And I select current line in "List" table
	And I click Select button of "Currency" field
	And I go to line in "List" table
		| Code  | Description       |
		| USD   | American dollar   |
	And I select current line in "List" table
	And I click Select button of "Planning period" field
	And I go to line in "List" table
		| 'Description'               |
		| 'Begin of the next month'   |
	And I select current line in "List" table	
	* Filling in tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Lomaniti       |
		And I select current line in "List" table
		And I click choice button of "Payer" attribute in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description         |
			| Company Lomaniti    |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "1 000,00" text in "Amount" field of "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of the attribute named "PaymentListFinancialMovementType" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I select "Approved" exact value from "Status" drop-down list							
	And I click the button named "FormPost"
	And I delete "$$NumberIncomingPaymentOrder080001$$" variable
	And I delete "$$IncomingPaymentOrder080001$$" variable
	And I save the value of "Number" field as "$$NumberIncomingPaymentOrder080001$$"
	And I save the window as "$$IncomingPaymentOrder080001$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| 'Number'                                | 'Company'       | 'Account'            | 'Currency'   |
		| '$$NumberIncomingPaymentOrder080001$$'  | 'Main Company'  | 'Bank account, USD'  | 'USD'        |
	And I close all client application windows



Scenario: _080004 check Description in IncomingPaymentOrder
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check Description
	And I close all client application windows

Scenario: _080005 create Bank receipt based on Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	And I go to line in "List" table
		| 'Number'                                 |
		| '$$NumberIncomingPaymentOrder080001$$'   |
	* Create Bank receipt from Incoming Payment Order
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Total amount" field of "PaymentList" table
		And I select "Basic Partner terms, TRY" from "Partner term" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0800051$$" variable
		And I delete "$$BankReceipt080005$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0800051$$"
		And I save the window as "$$BankReceipt080005$$"
		And I click the button named "FormPostAndClose"
	* Create one more Bank receipt from Incoming Payment Order list form
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberIncomingPaymentOrder080001$$'    |
		And I click the button named "FormDocumentBankReceiptGenerateBankReceipt"
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Total amount" field of "PaymentList" table
		And I select "Basic Partner terms, TRY" from "Partner term" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table	
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0800052$$" variable
		And I delete "$$BankReceipt0800051$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0800052$$"
		And I save the window as "$$BankReceipt0800051$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And "List" table contains lines
			| 'Number'                          |
			| '$$NumberBankReceipt0800051$$'    |
			| '$$NumberBankReceipt0800052$$'    |
		And I close all client application windows


Scenario: _080006 create Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'    |
		| 'Main Company'   |
	And I select current line in "List" table
	And I click Select button of "Account" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Bank account, TRY'   |
	And I select current line in "List" table
	And I click Select button of "Currency" field
	And I go to line in "List" table
		| 'Code'   |
		| 'TRY'    |
	And I select current line in "List" table
	And I click Select button of "Planning period" field
	And I go to line in "List" table
		| 'Description'               |
		| 'Begin of the next month'   |
	And I select current line in "List" table
	* Change status
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I click choice button of "Payee" attribute in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| Description          |
			| Company Ferron BP    |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "3 000,00" text in "Amount" field of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table		
		And I finish line editing in "PaymentList" table
	And I click the button named "FormPost"
	And I delete "$$NumberOutgoingPaymentOrder080006$$" variable
	And I delete "$$OutgoingPaymentOrder080006$$" variable
	And I save the value of "Number" field as "$$NumberOutgoingPaymentOrder080006$$"
	And I save the window as "$$OutgoingPaymentOrder080006$$"
	And I click the button named "FormPostAndClose"
	And "List" table contains lines
		| Number  | Company       | Account            | Currency   |
		| 1       | Main Company  | Bank account, TRY  | TRY        |
	And I close all client application windows

	

Scenario: _080009 check Description in Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check Description
	And I close all client application windows

Scenario: _080010 create Bank payment based on Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	And I go to line in "List" table
		| 'Number'                                 |
		| '$$NumberOutgoingPaymentOrder080006$$'   |
	* Create Bank payment from Outgoing payment order
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Total amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I select "Vendor Ferron, TRY" from "Partner term" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment08000101$$" variable
		And I delete "$$BankPayment08000101$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment08000101$$"
		And I save the window as "$$BankPayment08000101$$"
		And I click the button named "FormPostAndClose"
	* Create Bank payment from Outgoing payment order list
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberOutgoingPaymentOrder080006$$'    |
		And I click the button named "FormDocumentBankPaymentGenerateBankPayment"
		And I activate "Total amount" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "250,00" text in "Total amount" field of "PaymentList" table
		And I select "Vendor Ferron, TRY" from "Partner term" drop-down list by string in "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment08000102$$" variable
		And I delete "$$BankPayment08000102$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment08000102$$"
		And I save the window as "$$BankPayment08000102$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And "List" table contains lines
			| 'Number'                           |
			| '$$NumberBankPayment08000102$$'    |
			| '$$NumberBankPayment08000101$$'    |
		And I close all client application windows
		
	


# Filters

Scenario: _080011 filter check by own companies in the document Incoming payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check the filter by own company
	
Scenario: _080012 check Description in Incoming payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check filling in Comment


Scenario: _080013 filter check by own companies in the document Outgoing payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check the filter by own company

Scenario: _080014 check Description in Outgoing payment order
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check filling in Comment

# EndFilters

Scenario: _080015 check the display of the header of the collapsible group in Incoming payment order
	Given I open hyperlink "e1cib/list/Document.IncomingPaymentOrder"
	When check the display of the header of the collapsible group in planned incoming/outgoing documents
	And I click Select button of "Planning period" field
	And I go to line in "List" table
		| 'Description'               |
		| 'Begin of the next month'   |
	And I select current line in "List" table
	And I move to the next attribute
	Then the field named "DecorationGroupTitleUncollapsedLabel" value contains "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planning period: Begin of the next month" text
	And I close all client application windows

Scenario: _080016 check the display of the header of the collapsible group in Outgoing payment order
	Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
	When check the display of the header of the collapsible group in planned incoming/outgoing documents
	And I click Select button of "Planning period" field
	And I go to line in "List" table
		| 'Description'   |
		| 'First'         |
	And I select current line in "List" table
	And I move to the next attribute
	Then the field named "DecorationGroupTitleUncollapsedLabel" value contains "Company: Main Company   Account: Cash desk №2   Currency: TRY   Planning period: First" text
	And I close all client application windows


