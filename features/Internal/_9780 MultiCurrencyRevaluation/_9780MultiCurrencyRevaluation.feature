#language: en
@tree
@Positive
@MultiCurrencyRevaluation

Functionality: foreign currency revaluation

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _0978001 preparation (foreign currency revaluation)
	When set True value to the constant
	When set True value to the constant Use commission trading
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Countries objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog Stores (trade agent)
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
	When Create catalog LegalNameContracts objects
	When Create catalog CancelReturnReasons objects
	When Create catalog CashAccounts objects
	When Create catalog SerialLotNumbers objects
	When settings for Main Company (commission trade)
	When Create catalog RetailCustomers objects (check POS)
	When Create POS cash account objects
	When Create information register CurrencyRates records (multicurrency revaluation)
	* Add one more reporting currency for Main Company
		Given I open hyperlink "e1cib/data/Catalog.Companies?ref=aa78120ed92fbced11eaf113ba6c185c"
		And I move to "Currencies" tab
		And in the table "Currencies" I click the button named "CurrenciesAdd"
		And I click choice button of "Movement type" attribute in "Currencies" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Reporting currency Euro' |
		And I select current line in "List" table
		And I finish line editing in "Currencies" table
		And I click the button named "FormWriteAndClose"		
	* Workstation
		When Create catalog Workstations objects
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I go to line in "List" table
			| 'Description'       |
			| 'Workstation 01'    |
		And I click "Set current workstation" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one	
	* Load documents
	And I close all client application windows


Scenario: _0978002 check preparation
	When check preparation

Scenario: _0978003 check foreign currency revaluation
	And I close all client application windows
	* Create first document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "01.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number1$$" variable
		And I save the value of "Number" field as "$$Number1$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number1$$'    |
		And I close all client application windows
	* Create second document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "02.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number2$$" variable
		And I save the value of "Number" field as "$$Number2$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number2$$'    |
		And I close all client application windows
	* Create third document foreign currency revaluation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And I click "Create" button
		And I input "08.02.2023 23:59:59" text in the field named "Date"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "(Expense) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Expense'        |
		And I select current line in "List" table
		And I click Select button of "(Expense) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Revenue'        |
		And I select current line in "List" table
		And I click Select button of "(Revenue) Profit loss center" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Front office'    |
		And I select current line in "List" table
	* Post document
		And I click the button named "FormPost"
		And I delete "$$Number3$$" variable
		And I save the value of "Number" field as "$$Number3$$"
		And I delete "$$ForeignCurrencyRevaluation3$$" variable
		And I save the window as "$$ForeignCurrencyRevaluation3$$"
		And I click the button named "FormPostAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Document.ForeignCurrencyRevaluation"
		And "List" table contains lines
			| 'Number'         |
			| '$$Number3$$'    |
		And I close all client application windows


Scenario: _0978008 Sales (SI) and receipt of money (BR) on the same date - no exchange difference - 01.02
Scenario: _0978009 Sales (PI) and payment (BP) on the same date - no exchange difference - 01.02		
					
# Transaction +10, Reporting +100 (Trans*Rate < Rep - Revenue) 
Scenario: _0978004 revaluation of currency balance (customer) - exchange rate decreased



Scenario: _0978005 revaluation of currency balance (vendor) 

# Transaction +10, Reporting +100 (Trans*Rate < Rep - Expense) только инвойс
Scenario: _0978006 revaluation of currency balance (customer) - exchange rate increased
Scenario: _0978007 revaluation of currency balance (vendor) - exchange rate increased


#Transaction 0, Reporting 5 (SI 10 USD R:10, BR 10 USD R:9,5)

Scenario: _0978010 Sales (SI) and receipt of money (BR), debt repaid in USD, there is a balance of debt in local currency

#Transaction 0, Reporting -5 (PI 10 USD R:10, BP 10 USD R:9,5) - exchange rate decreased  USD закрылось, евро -минус, локальная плюс

Scenario: _0978011 Purchase (PI) and payment (BP), debt repaid in USD, there is a balance of debt in local currency

#Transaction +10, Reporting -5 (SI 20 USD R:10, BR 10 USD R:20,5) - только инвойс SI 2, BR -2, USD закрылось, евро -минус, локальная плюс

Scenario: _0978012 Sales (SI) and receipt of money (BR), debt repaid in USD, overpayment in local currency

#Transaction -10, Reporting 5 (PI 20 USD R:10, BP 10 USD R:20,5) - 

Scenario: _0978013 Purchase (SI) and payment (BP), debt repaid in USD, overpayment in local currency

#дописать проверку с закрытием аванса