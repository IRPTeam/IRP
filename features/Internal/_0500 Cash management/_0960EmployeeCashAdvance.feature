#language: en
@tree
@Positive
@CashManagement

Feature: employee cash advance


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

		
Scenario: _096000 preparation (Employee cash advance)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog PriceTypes objects
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
	* Load documents
		When Create document OutgoingPaymentOrder (employee cash advance)	
		And I execute 1C:Enterprise script at server
			| "Documents.OutgoingPaymentOrder.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.OutgoingPaymentOrder.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document CashPayment (employee cash advance)
		And I execute 1C:Enterprise script at server
			| "Documents.CashPayment.FindByNumber(306).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document BankPayment (employee cash advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankPayment.FindByNumber(305).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document PurchaseInvoice objects
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |


Scenario: _0960001 check preparation
	When check preparation


Scenario: _0960005 create Outgoing payment order (employee cash advance, from bank account)
	And I close all client application windows
	* Open OPO
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I click "Create" button
	* Filling OPO
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'        |
			| 'Main Company'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Currency' | 'Description'       |
			| 'TRY'      | 'Bank account, TRY' |
		And I select current line in "List" table
		And I select "Approved" exact value from the drop-down list named "Status"
		And I select "Employee cash advance" exact value from "Transaction type" drop-down list
	* Filling tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Daniel Smith' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "1 000,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Post and check
		And I click the button named "FormPost"
		And I delete "$$OutgoingPaymentOrder0960005$$" variable
		And I delete "$$NumberOutgoingPaymentOrder0960005$$" variable
		And I save the window as "$$OutgoingPaymentOrder0960005$$"
		And I save the value of "Number" field as "$$NumberOutgoingPaymentOrder0960005$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And "List" table contains lines
			| 'Number'                                |
			| '$$NumberOutgoingPaymentOrder0960005$$' |
		ANd I close all client application windows
		

Scenario: _0960006 create Outgoing payment order (employee cash advance, from cash account)
	And I close all client application windows
	* Open OPO
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I click "Create" button
	* Filling OPO
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'        |
			| 'Main Company'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №1' |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I select "Approved" exact value from the drop-down list named "Status"
		And I select "Employee cash advance" exact value from "Transaction type" drop-down list
	* Filling tabular part
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Daniel Smith' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "1 000,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'David Romanov' |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I activate "Amount" field in "PaymentList" table
		And I input "1 000,00" text in "Amount" field of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Post and check
		And I click the button named "FormPost"
		And I delete "$$OutgoingPaymentOrder0960006$$" variable
		And I delete "$$NumberOutgoingPaymentOrder0960006$$" variable
		And I save the window as "$$OutgoingPaymentOrder0960006$$"
		And I save the value of "Number" field as "$$NumberOutgoingPaymentOrder0960006$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And "List" table contains lines
			| 'Number'                                |
			| '$$NumberOutgoingPaymentOrder0960006$$' |
		And I close all client application windows				


Scenario: _0960010 create Bank payment with transaction type Employee cash advance (based on OPO)
	And I close all client application windows
	* Select OPO
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table	
			| 'Number' |
			| '16'     |
	* Create BP
		And I click the button named "FormDocumentBankPaymentGenarateBankPayment"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Account" became equal to "Bank account, TRY"
		Then the form attribute named "TransactionType" became equal to "Employee cash advance"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'         | 'Commission' | 'Basis document' | 'Total amount' | 'Financial movement type' | 'Profit loss center' | 'Planning transaction basis'                          | 'Commission percent' | 'Additional analytic' | 'Expense type' |
			| '1' | 'Olivia Williams' | ''           | ''               | '1 000,00'     | 'Movement type 1'         | ''                   | 'Outgoing payment order 16 dated 12.01.2023 16:34:39' | ''                   | ''                    | ''             |
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "1 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$BankPayment0960010$$" variable
		And I delete "$$NumberBankPayment0960010$$" variable
		And I save the window as "$$BankPayment0960010$$"
		And I save the value of "Number" field as "$$NumberBankPayment0960010$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And "List" table contains lines
			| 'Number'                       |
			| '$$NumberBankPayment0960010$$' |
		And I close all client application windows	
				
				

Scenario: _0960011 create Cash payment with transaction type Employee cash advance (based on OPO)
	And I close all client application windows
	* Select OPO
		Given I open hyperlink "e1cib/list/Document.OutgoingPaymentOrder"
		And I go to line in "List" table	
			| 'Number' |
			| '15'     |
	* Create CP
		Then "Outgoing payment orders" window is opened
		And I click "Cash payment" button
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "CashAccount" became equal to "Cash desk №1"
		Then the form attribute named "TransactionType" became equal to "Employee cash advance"
		Then the form attribute named "Currency" became equal to "TRY"
		And "PaymentList" table became equal
			| '#' | 'Partner'         | 'Basis document' | 'Total amount' | 'Financial movement type' | 'Planning transaction basis'                          |
			| '1' | 'Olivia Williams' | ''               | '1 000,00'     | 'Movement type 1'         | 'Outgoing payment order 15 dated 12.01.2023 16:34:17' |
			| '2' | 'Emily Jones'     | ''               | '1 000,00'     | 'Movement type 1'         | 'Outgoing payment order 15 dated 12.01.2023 16:34:17' |
		And the editing text of form attribute named "PaymentListTotalTotalAmount" became equal to "2 000,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$CashPayment0960010$$" variable
		And I delete "$$NumberCashPayment0960010$$" variable
		And I save the window as "$$CashPayment0960010$$"
		And I save the value of "Number" field as "$$NumberCashPayment0960010$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And "List" table contains lines
			| 'Number'                       |
			| '$$NumberCashPayment0960010$$' |
		And I close all client application windows				

Scenario: _0960015 create document Employee cash advance (own expense)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
	And I click "Create" button
	* Filling header
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'        |
			| 'Main Company'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'         |
			| 'David Romanov'       |
		And I select current line in "List" table	
	* Filling tabular part
		And in the table "PaymentList" I click "Fill by advances" button
		And I activate "Expense type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Expense type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Expense'     |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| '#' | 'Account'           | 'Currency' | 'Dont calculate row' | 'Financial movement type' | 'Planing transaction basis'                           | 'Total amount' |
			| '2' | 'Bank account, TRY' | 'TRY'      | 'No'                 | 'Movement type 1'         | 'Outgoing payment order 16 dated 12.01.2023 16:34:39' | '1 000,00'     |
		And I select current line in "PaymentList" table
		And I click choice button of "Expense type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Expense'     |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| '#' | 'Account'      | 'Currency' | 'Dont calculate row' | 'Expense type' | 'Financial movement type' | 'Planing transaction basis'                           | 'Total amount' |
			| '1' | 'Cash desk №1' | 'TRY'      | 'No'                 | 'Expense'      | 'Movement type 1'         | 'Outgoing payment order 15 dated 12.01.2023 16:34:17' | '1 000,00'     |
		And I activate "Profit loss center" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Profit loss center" attribute in "PaymentList" table
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Department' | 'Description'          |
			| 'Yes'        | 'Logistics department' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I go to line in "PaymentList" table
			| '#' | 'Account'           | 'Currency' | 'Dont calculate row' | 'Expense type' | 'Financial movement type' | 'Planing transaction basis'                           | 'Total amount' |
			| '2' | 'Bank account, TRY' | 'TRY'      | 'No'                 | 'Expense'      | 'Movement type 1'         | 'Outgoing payment order 16 dated 12.01.2023 16:34:39' | '1 000,00'     |
		And I select current line in "PaymentList" table
		And I click choice button of "Profit loss center" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I input "800,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$ECA0960015$$" variable
		And I delete "$$NumberECA0960015$$" variable
		And I save the window as "$$ECA0960015$$"
		And I save the value of "Number" field as "$$NumberECA0960015$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And "List" table contains lines
			| 'Number'                       |
			| '$$NumberECA0960015$$' |
		And I close all client application windows					


Scenario: _0960016 create document Employee cash advance (purchase)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
	And I click "Create" button
	* Filling header
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'        |
			| 'Main Company'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Partner"
		And I go to line in "List" table
			| 'Description'         |
			| 'Sofia Borisova'       |
		And I select current line in "List" table	
	* Filling tabular part
		And in the table "PaymentList" I click "Fill by advances" button
	* Select PI
		And I activate "Invoice" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Invoice" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Amount'     | 'Number' |
			| '137 000,00' | '12'     |
		And I select current line in "List" table
	* Financial movement type
		And I click choice button of "Expense type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Expense'     |
		And I select current line in "List" table
		And I click choice button of "Profit loss center" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'          |
			| 'Logistics department' |
		And I select current line in "List" table
		And I input "50000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Check creation
		And I click the button named "FormPost"
		And I delete "$$ECA0960016$$" variable
		And I delete "$$NumberECA0960016$$" variable
		And I save the window as "$$ECA0960016$$"
		And I save the value of "Number" field as "$$NumberECA0960016$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.EmployeeCashAdvance"
		And "List" table contains lines
			| 'Number'                       |
			| '$$NumberECA0960016$$' |
		And I close all client application windows

				