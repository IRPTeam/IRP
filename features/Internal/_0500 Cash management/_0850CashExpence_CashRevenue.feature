#language: en
@tree
@Positive
@CashManagement

Feature: write off expenses and record income directly to/from the account

As an accountant
I want to create Cash revenue and Cash expence documents
For write off expenses and record income directly to/from the account

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


# Cash revenue

	
Scenario: _085000 preparation (Cash expence and Cash revenue)
	When set True value to the constant
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog PlanningPeriods objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog CashAccounts objects
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create document CashExpense objects
		When Create document CashRevenue objects
		When Create catalog Partners objects
		When Create catalog SalaryCalculationType objects
		When Create catalog CashAccounts objects (Second Company)
		When Create information register Taxes records (VAT)
	* Post
		And I execute 1C:Enterprise script at server
			| "Documents.CashExpense.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashRevenue.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
	
Scenario: _0850001 check preparation
	When check preparation	

Scenario: _085001 check tax calculation in the document Cash revenue
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'TRY'        | 'Bank account, TRY'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Accountants office'    |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Fuel'           |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table		
		And I finish line editing in "PaymentList" table
	* Tax calculation check
		And "PaymentList" table contains lines
			| 'Net amount'   | 'Profit loss center'   | 'Revenue type'   | 'Total amount'   | 'Currency'   | 'VAT'   | 'Tax amount'    |
			| '100,00'       | 'Accountants office'   | 'Fuel'           | '118,00'         | 'TRY'        | '18%'   | '18,00'         |
		And I close all client application windows

Scenario: _085002 check Cash revenue creation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'TRY'        | 'Bank account, TRY'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Accountants office'    |
		And I select current line in "List" table
		And I activate field named "PaymentListRevenueType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListRevenueType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Fuel'           |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashRevenue1$$" variable
		And I delete "$$CashRevenue1$$" variable
		And I save the value of "Number" field as "$$NumberCashRevenue1$$"
		And I save the window as "$$CashRevenue1$$"
		And I close all client application windows
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberCashRevenue1$$'    |
		And I close all client application windows
	





Scenario: _085003 check the unavailability of currency selection in Cash revenue when it is strongly fixed in the Account
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
	* Check the Currency field unavailability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		When I Check the steps for Exception
			| 'And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table'    |

Scenario: _085004 check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №1'    |
		And I select current line in "List" table
	* Check the Currency field availability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And in "PaymentList" table "Currency" attribute is available


# Cash expence

Scenario: _085005 check tax calculation in the document Cash expense
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'TRY'        | 'Bank account, TRY'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Accountants office'    |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Fuel'           |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
	* Tax calculation check
		And "PaymentList" table contains lines
			| 'Net amount'   | 'Profit loss center'   | 'Expense type'   | 'Total amount'   | 'Currency'   | 'VAT'   | 'Tax amount'    |
			| '100,00'       | 'Accountants office'   | 'Fuel'           | '118,00'         | 'TRY'        | '18%'   | '18,00'         |
		And I close all client application windows

Scenario: _085006 check Cash expense creation
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'          |
			| 'TRY'        | 'Bank account, TRY'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I click choice button of the attribute named "PaymentListProfitLossCenter" in "PaymentList" table
		And I go to line in "List" table
			| 'Description'           |
			| 'Accountants office'    |
		And I select current line in "List" table
		And I activate field named "PaymentListExpenseType" in "PaymentList" table
		And I click choice button of the attribute named "PaymentListExpenseType" in "PaymentList" table
		And I activate "Description" field in "List" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Fuel'           |
		And I select current line in "List" table
		And I activate field named "PaymentListNetAmount" in "PaymentList" table
		And I input "100,00" text in the field named "PaymentListNetAmount" of "PaymentList" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table		
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashExpense1$$" variable
		And I delete "$$CashExpense1$$" variable
		And I save the value of "Number" field as "$$NumberCashExpense1$$"
		And I save the window as "$$CashExpense1$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberCashExpense1$$'    |
		And I close all client application windows
	
	



Scenario: _085007 check the unavailability of currency selection in Cash expense when it is strongly fixed in the Account
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Bank account, TRY'    |
		And I select current line in "List" table
	* Check the Currency field unavailability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		When I Check the steps for Exception
			| 'And I click choice button of the attribute named "PaymentListCurrency" in "PaymentList" table'    |


Scenario: _085008 check the availability of currency selection in Cash revenue (not fixed in the Account)
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in the details of the document
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Cash desk №1'    |
		And I select current line in "List" table
	* Check the Currency field availability
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And in "PaymentList" table "Currency" attribute is available
	
Scenario: _085009 copy Cash expense and change date
	* Select Cash expense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Copy Cash expense
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I move to "Other" tab
		And I move to "More" tab
		And I input "14.03.2022 00:00:00" text in the field named "Date"
		And I click "Post" button
		Then user message window does not contain messages

Scenario: _085010 copy Cash revenue and change date
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Copy Cash revenue
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I move to "Other" tab
		And I move to "More" tab
		And I input "14.03.2022 00:00:00" text in the field named "Date"
		And I click "Post" button
		Then user message window does not contain messages	
		
				

Scenario: _085015 check Cash expense (Other company expense)
		And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I select "Other company expense" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Other company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'     |
			| 'TRY'        | 'Cash desk №4'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		* First line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Anna Petrova'     |
			And I select current line in "List" table
			And I activate "Profit loss center" field in "PaymentList" table
			And I click choice button of "Profit loss center" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table
			And I activate "Expense type" field in "PaymentList" table
			And I click choice button of "Expense type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Expense'         |
			And I select current line in "List" table
			And I activate "Financial movement type" field in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table
			And I activate "VAT" field in "PaymentList" table
			And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I select current line in "PaymentList" table
			And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		* Second line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I finish line editing in "PaymentList" table
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Arina Brown'    |
		And I select current line in "List" table
		And I activate "Profit loss center" field in "PaymentList" table
		And I click choice button of "Profit loss center" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Logistics department'    |
		And I select current line in "List" table
		And I activate "Expense type" field in "PaymentList" table
		And I click choice button of "Expense type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "VAT" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "2 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashExpense2$$" variable
		And I delete "$$CashExpense2$$" variable
		And I save the value of "Number" field as "$$NumberCashExpense2$$"
		And I save the window as "$$CashExpense2$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberCashExpense2$$'    |
		And I close all client application windows
		

Scenario: _085016 check Cash revenue (Other company revenue)
		And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I select "Other company revenue" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Other company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'     |
			| 'TRY'        | 'Cash desk №4'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		* First line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Anna Petrova'     |
			And I select current line in "List" table
			And I activate "Profit loss center" field in "PaymentList" table
			And I click choice button of "Profit loss center" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'                 |
				| 'Distribution department'     |
			And I select current line in "List" table
			And I activate "Revenue type" field in "PaymentList" table
			And I click choice button of "Revenue type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Revenue'         |
			And I select current line in "List" table
			And I activate "Financial movement type" field in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table
			And I activate "VAT" field in "PaymentList" table
			And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I select current line in "PaymentList" table
			And I input "500,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		* Second line
		And in the table "PaymentList" I click the button named "PaymentListAdd"
		And I finish line editing in "PaymentList" table
		And I activate "Partner" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I click choice button of "Partner" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Arina Brown'    |
		And I select current line in "List" table
		And I activate "Profit loss center" field in "PaymentList" table
		And I click choice button of "Profit loss center" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Logistics department'    |
		And I select current line in "List" table
		And I activate "Revenue type" field in "PaymentList" table
		And I click choice button of "Revenue type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I activate "Financial movement type" field in "PaymentList" table
		And I click choice button of "Financial movement type" attribute in "PaymentList" table
		And I go to line in "List" table
			| 'Description'        |
			| 'Movement type 1'    |
		And I select current line in "List" table
		And I finish line editing in "PaymentList" table
		And I activate "VAT" field in "PaymentList" table
		And I select current line in "PaymentList" table
		And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
		And I activate field named "PaymentListTotalAmount" in "PaymentList" table
		And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
		And I finish line editing in "PaymentList" table
		And I click the button named "FormPost"
		And I delete "$$NumberCashRevenue2$$" variable
		And I delete "$$CashRevenue2$$" variable
		And I save the value of "Number" field as "$$NumberCashRevenue2$$"
		And I save the window as "$$CashRevenue2$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberCashRevenue2$$'    |
		And I close all client application windows


Scenario: _085017 check Cash expense (Other company salary)
		And I close all client application windows
	* Open document form
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click the button named "FormCreate"
	* Filling in company and account
		And I select "Salary payment" exact value from "Transaction type" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Other company" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I click Select button of "Account" field
		And I go to line in "List" table
			| 'Currency'   | 'Description'     |
			| 'TRY'        | 'Cash desk №4'    |
		And I select current line in "List" table
	* Filling in the tabular part by cost
		* First line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Anna Petrova'     |
			And I select current line in "List" table
			And I activate "Employee" field in "PaymentList" table
			And I click choice button of "Employee" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Alexander Orlov'     |
			And I select current line in "List" table
			And I activate "Financial movement type" field in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table
			And I activate "Payment period" field in "PaymentList" table
			And I click choice button of "Payment period" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Third (only salary)'     |
			And I select current line in "List" table
			And I activate "Calculation type" field in "PaymentList" table
			And I click choice button of "Calculation type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Salary'     |
			And I select current line in "List" table
			And I activate "VAT" field in "PaymentList" table
			And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I select current line in "PaymentList" table
			And I input "1 000,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
		* Second line
			And in the table "PaymentList" I click the button named "PaymentListAdd"
			And I click choice button of "Partner" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'      |
				| 'Anna Petrova'     |
			And I select current line in "List" table
			And I activate "Employee" field in "PaymentList" table
			And I click choice button of "Employee" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'       |
				| 'David Romanov'     |
			And I select current line in "List" table
			And I activate "Financial movement type" field in "PaymentList" table
			And I click choice button of "Financial movement type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'         |
				| 'Movement type 1'     |
			And I select current line in "List" table
			And I activate "Payment period" field in "PaymentList" table
			And I click choice button of "Payment period" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Third (only salary)'     |
			And I select current line in "List" table
			And I activate "Calculation type" field in "PaymentList" table
			And I click choice button of "Calculation type" attribute in "PaymentList" table
			And I go to line in "List" table
				| 'Description'             |
				| 'Bonus'     |
			And I select current line in "List" table
			And I activate "VAT" field in "PaymentList" table
			And I select "0%" exact value from "VAT" drop-down list in "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I activate field named "PaymentListTotalAmount" in "PaymentList" table
			And I select current line in "PaymentList" table
			And I input "1 500,00" text in the field named "PaymentListTotalAmount" of "PaymentList" table
			And I finish line editing in "PaymentList" table
			And I move to "Other" tab
			And I finish line editing in "PaymentList" table
			And I move to "More" tab
			And I click Choice button of the field named "Branch"
			And I go to line in "List" table
				| 'Description'            |
				| 'Accountants office'     |
			And I select current line in "List" table		
		And I click the button named "FormPost"
		And I delete "$$NumberCashExpense3$$" variable
		And I delete "$$CashExpense3$$" variable
		And I save the value of "Number" field as "$$NumberCashExpense3$$"
		And I save the window as "$$CashExpense3$$"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And "List" table contains lines
			| 'Number'                    |
			| '$$NumberCashExpense3$$'    |
		And I close all client application windows
