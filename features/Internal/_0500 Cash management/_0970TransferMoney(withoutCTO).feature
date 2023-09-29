#language: en
@tree
@Positive
@CashManagement

Feature: transfer money without Cash transfer order



Variables:
import "Variables.feature"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _097000 preparation (Cash transfer order)
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
		When Create catalog Taxes objects	
		When Create catalog BusinessUnits objects
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog Partners objects (Employee)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create information register Taxes records (VAT)
		When Create catalog PlanningPeriods objects
	
	
Scenario: _0970001 check preparation
	When check preparation	

Scenario: _0970002 create Bank payment (cash transfer)
	And I close all client application windows
	* Open BP
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click the button named "FormCreate"
	* Filling main attributes
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, EUR' |
		And I select current line in "List" table
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Receipting account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Bank account 2, EUR' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I click choice button of "Receipting branch" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankPayment0970002$$" variable
		And I delete "$$BankPayment0970002$$" variable
		And I save the value of "Number" field as "$$NumberBankPayment0970002$$"
		And I save the window as "$$BankPayment0970002$$"
		And I click the button named "FormPostAndClose"
	* Check creation Bank payment
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberBankPayment0970002$$'    |
				

Scenario: _0970004 create Bank receipt (cash transfer)
	And I close all client application windows
	* Open BR
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click the button named "FormCreate"
	* Filling main attributes
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "Account"
		And I go to line in "List" table
			| 'Description'         |
			| 'Bank account 2, EUR' |
		And I select current line in "List" table
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Sending account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'       |
			| 'Bank account, EUR' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I click choice button of "Sending branch" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberBankReceipt0970003$$" variable
		And I delete "$$BankReceipt0970003$$" variable
		And I save the value of "Number" field as "$$NumberBankReceipt0970003$$"
		And I save the window as "$$BankReceipt0970003$$"
		And I click the button named "FormPostAndClose"
	* Check creation Bank receipt
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberBankReceipt0970003$$'    |		

Scenario: _0970005 create Cash payment (cash transfer)
	And I close all client application windows
	* Open CP
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click the button named "FormCreate"
	* Filling main attributes
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №4' |
		And I select current line in "List" table
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Receipting account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №1' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I click choice button of "Receipting branch" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashPayment0970005$$" variable
		And I delete "$$CashPayment0970005$$" variable
		And I save the value of "Number" field as "$$NumberCashPayment0970005$$"
		And I save the window as "$$CashPayment0970005$$"
		And I click the button named "FormPostAndClose"
	* Check creation Cash payment
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashPayment0970005$$'    |	


Scenario: _0970006 create Cash receipt (cash transfer)
	And I close all client application windows
	* Open CR
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click the button named "FormCreate"
	* Filling main attributes
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I click Choice button of the field named "CashAccount"
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №1' |
		And I select current line in "List" table
		And I click Choice button of the field named "Currency"
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I select "Cash transfer order" exact value from "Transaction type" drop-down list
		And I click Choice button of the field named "Branch"
		And I go to line in "List" table
			| 'Description'  |
			| 'Front office' |
		And I select current line in "List" table
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I select current line in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Sending account" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №4' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I click choice button of "Sending branch" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Distribution department' |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'     |
			| 'Movement type 1' |
		And I select current line in "List" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashReceipt0970006$$" variable
		And I delete "$$CashReceipt0970006$$" variable
		And I save the value of "Number" field as "$$NumberCashReceipt0970006$$"
		And I save the window as "$$CashReceipt0970006$$"
		And I click the button named "FormPostAndClose"
	* Check creation Cash payment
			And "List" table contains lines
			| 'Number'                          |
			| '$$NumberCashReceipt0970006$$'    |